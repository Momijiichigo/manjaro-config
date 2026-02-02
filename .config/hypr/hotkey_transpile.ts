#!/usr/bin/bun run

// Define flag mappings for abbreviations to full form
const flagMappings: Record<string, string> = {
  'locked': 'l',
  'release': 'r',
  'long-press': 'o',
  'repeat': 'e',
  'non-consuming': 'n',
  'mouse': 'm',
  'transparent': 't',
  'ignore-mods': 'i',
  'separate': 's',
  'description': 'd',
  'bypasses': 'p',
};

// Paths
const inputPath = './hotkeys.conf';
const outputPath = './hyprland.conf';

// Read config files
let input = '';
let hyprlandConfig = '';

try {
  input = await Bun.file(inputPath).text();
  console.log(`Successfully read hotkeys file: ${inputPath}`);
} catch (error) {
  throw new Error(`Error reading ${inputPath}: ${error}`);
}

try {
  hyprlandConfig = await Bun.file(outputPath).text();
  console.log(`Successfully read Hyprland config: ${outputPath}`);
} catch (error) {
  throw new Error(`Error reading ${outputPath}: ${error}`);
}

const MODIFIER_KEYS = ['ctrl', 'shift', 'alt', 'super'];
function getExpandedLines(line: string): string[] {
  const results: string[] = [line];
  let hasExpansion = true;

  while (hasExpansion) {
    hasExpansion = false;
    const newResults: string[] = [];

    for (const currentLine of results) {
      const openCurly = currentLine.indexOf('{');
      const closeCurly = currentLine.indexOf('}');

      if (openCurly === -1 || closeCurly === -1 || closeCurly < openCurly) {
        newResults.push(currentLine);
        continue;
      }

      hasExpansion = true;
      const before = currentLine.slice(0, openCurly);
      const after = currentLine.slice(closeCurly + 1);
      const inner = currentLine.slice(openCurly + 1, closeCurly).split(',').map(s => s.trim());

      for (const key of inner) {
        if (key === '_') {
          newResults.push(`${before}${after}`);
        } else {
          newResults.push(`${before}${key}${after}`);
        }
      }
    }

    results.length = 0;
    results.push(...newResults);
  }

  return results;
}
/**
 * Simple transpiler to convert swhkd-style hotkey config to Hyprland format
 */
function transpileHotkeys(input: string): string[] {
  // replace `{<other keys>, 1-9, <other keys>}` with `{<other keys>, 1, 2, 3, <abbrev>, 8, 9, <other keys>}`
  input = input.replace(/({[\s\w,]*)(\d-\d)([\s\w,]*)/g, (_, before, range, after) => {
    const [start, end] = range.split('-').map(Number);
    const rangeKeys = Array.from({length: end - start + 1}, (_, i) => (start + i).toString());
    return `${before}${rangeKeys.join(', ')}${after}`;
  });
  const lines = input.split('\n');
  type Binding = {
    modKeys: string[],
    keys: string[],
    command: string,
    flags: string[]
  }
  const bindings: Array<Binding> = [];

  let flags: string[] = [];
  let command = '';
  let currentBindings: Binding[] = [];
  for (const line of lines) {
    if (!line || line.trim().startsWith('#')) continue; // skip empty lines and comments
    if (line.startsWith('(')) {
      // flags
      flags = line.slice(1, line.indexOf(')'))
        .split(',')
        .map(flag => {
          flag = flag.trim();
          return flagMappings[flag] || flag;
        });
    } else if (!line.startsWith(' ')) {
      getExpandedLines(line).map((expLine, i) => {
        let modKeys: string[] = [];
        let keys: string[] = [];
        expLine.split('+').map(key => key.trim()).forEach(key => {
          if (MODIFIER_KEYS.includes(key)) {
            modKeys.push(key);
          } else {
            keys.push(key);
          }
        })
        currentBindings[i] = {
          modKeys,
          keys,
          command: "",
          flags
        }
      })

    } else {
      // multi line command
      if (line.endsWith('\\')) {
        command += line.slice(0, -1).trim() + ' ';
        continue;
      } else {
        command += line.trim();
        getExpandedLines(command).forEach((expCommand, i) => {
          if (currentBindings[i]) currentBindings[i].command = expCommand;
        })
        // reset
        command = '';
        flags = [];
        bindings.push(...currentBindings);
        currentBindings = [];

      }
    }
  }
  return bindings.map(binding => {
    const modKeys = binding.modKeys.join(' ');
    const keys = binding.keys.join(' ');
    const flags = binding.flags.join('');
    // modify to absolute path if command includes relative paths
    binding.command = binding.command.replace(/\.\.?\/[^\s]*/g, (match) => {
      return Bun.resolveSync(match, import.meta.dir);
    });
    if (binding.command.startsWith('hyprctl dispatch')) {
      let [, dispatcher, args] = binding.command.match(/hyprctl dispatch ([\w:]+)( .*)?/) || [];
      args = args ? `, ${args}` : '';
      return `bind${flags} = ${modKeys}, ${keys}, ${dispatcher}${args}`;
    } else {
      return `bind${flags} = ${modKeys}, ${keys}, exec, ${binding.command}`;
    }
  });
}

// Generate the bindings
console.log('Transpiling hotkey configuration...');
const bindings = transpileHotkeys(input);

if (bindings.length === 0) {
  throw new Error('Error: No bindings were generated. Check your hotkeys.conf file.');

}

console.log(`Generated ${bindings.length} bindings.`);
const transpiledContent = bindings.join('\n');

// Define the markers for the transpiled section
const startMarker = '# >>> HOTKEY CONFIG TRANSPILED SECTION >>>';
const endMarker = '# <<< HOTKEY CONFIG TRANSPILED SECTION <<<';

// Find the markers in the config
const startIndex = hyprlandConfig.indexOf(startMarker);
const endIndex = hyprlandConfig.indexOf(endMarker);

let updatedConfig: string;

if (startIndex === -1 || endIndex === -1) {
  console.log('Markers not found in hyprland.conf. Adding them...');

  // Find a good place to insert the transpiled section
  const bindIdx = hyprlandConfig.indexOf('bind = ');

  if (bindIdx !== -1) {
    // Insert before the first bind
    const insertPos = hyprlandConfig.lastIndexOf('\n', bindIdx);

    if (insertPos !== -1) {
      updatedConfig =
        hyprlandConfig.substring(0, insertPos) +
        `\n\n${startMarker}\n\n${transpiledContent}\n\n${endMarker}\n` +
        hyprlandConfig.substring(insertPos);
    } else {
      updatedConfig =
        `${startMarker}\n\n${transpiledContent}\n\n${endMarker}\n\n` +
        hyprlandConfig;
    }
  } else {
    // Append to the end
    updatedConfig =
      hyprlandConfig +
      `\n\n${startMarker}\n\n${transpiledContent}\n\n${endMarker}\n`;
  }
} else {
  // Replace the content between markers
  updatedConfig =
    hyprlandConfig.substring(0, startIndex + startMarker.length) +
    `\n\n${transpiledContent}\n\n` +
    hyprlandConfig.substring(endIndex);
}

// Write the updated config
try {
  await Bun.write(outputPath, updatedConfig);
  console.log(`Successfully updated ${outputPath} with ${bindings.length} transpiled bindings.`);
} catch (error) {
  throw new Error(`Error writing to ${outputPath}: ${error}`);
}
