#!/usr/bin/bun run

import {$} from "bun";

export function getCurrentWorkspace() {
  const proc = Bun.spawnSync(["hyprctl", "activewindow", "-j"])
  
  type WindowInfo = {
    workspace: {
      id: number,
      name: string,
    }
  }
  const windowInfo: WindowInfo = JSON.parse(proc.stdout.toString());
  return JSON.stringify(
    windowInfo?.workspace?.id
  )
}

export async function setEwwVar() {
  $`eww update current_workspace="${getCurrentWorkspace()}"`
    .nothrow()
    .text()
}
const arg = Bun.argv[2];

switch (arg) {
  case "print": {
    console.log(
      getCurrentWorkspace()
    )
    break;
  }
  case "setEwwVar": {
    setEwwVar()
    break;
  }
  default:
    break;
}
