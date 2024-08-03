#!/usr/bin/bun run

import {$} from "bun";

type Workspace = {
  "id": number,
  "name": `${number}`,
  "monitor": string,
  "monitorID": number,
  "windows": number,
  "hasfullscreen": boolean,
  "lastwindow": string,
  "lastwindowtitle": string,
}
export function getWorkspaces() {
  const proc = Bun.spawnSync(["hyprctl", "workspaces", "-j"])
  let workspaces: Workspace[] = []
  try {
    workspaces = JSON.parse(proc.stdout.toString());
  } catch (e) {
    // sometimes returns strings like:
    // "Hyprland IPC didn't respond in time"
    console.error(e)
    console.error(proc.stdout.toString())
    return "[]"
  }
  // console.log(workspaces)

  const monitorWorkspaces: number[][] = []

  workspaces.forEach(ws => {
    monitorWorkspaces[ws.monitorID] ??= []
    const workspaceList = monitorWorkspaces[ws.monitorID]
    workspaceList.push(ws.id)
    workspaceList.sort((a, b) => a - b)
  })
  return JSON.stringify(monitorWorkspaces)
}

export async function setEwwVar() {
  $`eww update wspaces="${getWorkspaces()}"`.nothrow().text()
}

const arg = Bun.argv[2];
switch (arg) {
  case "print": {
    console.log(
      getWorkspaces()
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
