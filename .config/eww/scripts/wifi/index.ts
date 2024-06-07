#!/usr/bin/bun run
import {$} from "bun";

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
    cleanup();
  }
} catch (e) {
  // just in case the script didn't finish properly,
  // we want to remove the temp file
  cleanup();
  throw e;
}

function cleanup() {
  $`rm ${TMP_FILE}`;
}

async function handleLogMessage(text: string) {
  // Example: Connectivity is now 'full'
  const connectStatus = text
    .match(
      /Connectivity is now '(?<status>\w+)'/
    )
    ?.groups
    ?.status;
  if (connectStatus) {
    let wifiIcon = ""
    switch (connectStatus) {
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
  }


}

async function getEssid() {
  return await $`nmcli connection show --active`
    .text()
    .then((text) => {
      const lines = text.split("\n")
      const essidLine = lines.find((line) => line.includes("wlp"))
      console.log(essidLine?.includes("\t"))
      return essidLine?.split("\t")[0].trim() || "No Wifi Connected"
    })

}

async function getWifiStatusIcon() {
  const status = await $`nmcli networking connectivity`
    .text()
    .then((text) => text.trim())

  switch (status) {
    case "full":
      return "󰤨"
    case "limited":
      return "󰤠"
    default:
      return "󰤯"
  }
}

