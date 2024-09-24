#!/usr/bin/bun run

import {$} from 'bun'

const POPUP_NAMES = ['calendar', 'system', 'music_win', 'audio_ctl']



type PopupName = typeof POPUP_NAMES[number]

async function open(popupName: PopupName) {
  const currentMonitor = await $`hyprctl activeworkspace | rg 'monitorID: (.+)' -o -r '$1'`
    .text()
    .then(s => s.trim())

  console.log('Current monitor:', currentMonitor)

  const activeWindows = (await $`eww active-windows`.text())
    .trim()
    .split('\n')
    .map(s => s.split(':')[0])

  console.log('Active windows:', activeWindows)

  if (activeWindows.includes(popupName)) {
    await $`eww close ${popupName}`.nothrow().text()
  } else {
    await $`eww close ${
      activeWindows
        .filter(id => POPUP_NAMES.includes(id))
        .join(' ')
    }`.nothrow().text()

    await $`eww open --screen ${currentMonitor} ${popupName}`.text().catch(console.error)
  }
}

const arg = Bun.argv[2]

if (POPUP_NAMES.includes(arg)) {
  await open(arg)
} else {
  console.error(`Invalid popup name: ${arg}`)
}


