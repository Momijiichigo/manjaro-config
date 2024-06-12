#!/usr/bin/bun run
import {$} from "bun";
import {getEssid, getWifiIconColor, getWifiStatusIcon} from "./utils.ts";
import type {Connectivity} from "./utils.ts";
import {Some, None, Option} from "rusty-enums"

const arg = Bun.argv[2];
switch (arg) {
  case "main":
    await mainLoop();
    break;
  case "essid":
    console.log(await getEssid())
    break;
  case "icon":
    console.log(await getWifiStatusIcon())
    break;
  case "icon-color":
    console.log(await getWifiIconColor(None))
    break;
  default:
    break;
}

async function mainLoop() {

  const TMP_FILE = "/tmp/eww-wifi-script-running";

  // true if the temp file exists
  const tempFileExists: boolean = (
    await $`
    if [ -f ${TMP_FILE} ]; then
      echo 1;
    else
      echo 0;
    fi`.text()
  ).trim() === "1";

  // If the temp file exists, then the script is already running
  try {
    if (!tempFileExists) {
      // if (true) {
      await $`touch ${TMP_FILE}`;

      const proc = Bun.spawn(["nmcli", "monitor"])
      const reader = proc.stdout.getReader();

      const decoder = new TextDecoder();

      let done = false;
      while (!done) {
        const {value, done: d} = await reader.read()
        done = d;
        const text = decoder.decode(value);
        console.log(text)

        await handleLogMessage(text);

      }
      await cleanup();
    }
  } catch (e) {
    // just in case the script didn't finish properly,
    // we want to remove the temp file
    await cleanup();
    throw e;
  }

  function cleanup() {
    return $`rm ${TMP_FILE}`.text();
  }
  process.on("beforeExit", async (code) => {
    console.log("Exiting with code", code);
    await cleanup();
  })

}

async function handleLogMessage(text: string) {
  // Example: Connectivity is now 'full'
  const connectivity = text
    .match(
      /Connectivity is now '(?<status>\w+)'/
    )
    ?.groups
    ?.status as Connectivity | undefined;
  if (connectivity) {
    let wifiIcon = ""
    switch (connectivity) {
      case "full":
        wifiIcon = "󰤨";
        break;
      case "limited":
        wifiIcon = "󰤠";
        break;
      default:
        wifiIcon = "󰤯";
        break;
    }
    console.log(wifiIcon)
    $`eww update WLAN_ICON="${wifiIcon}"`.text();
    $`eww update ESSID_WLAN="${await getEssid()}"`.text();
    $`eww update WLAN_ICON_COLOR="${
      await getWifiIconColor(Some(connectivity))
    }"`.text();
  }


}


