#!/usr/bin/bun run

/* @ts-ignore */
const proc = Bun.spawnSync(["hyprctl", "activewindow", "-j"])

type WindowInfo = {
  workspace: {
    id: number,
    name: string,
  }
}
const windowInfo: WindowInfo = JSON.parse(proc.stdout.toString());

// console.log(workspaces)

console.log(
  JSON.stringify(
    windowInfo?.workspace?.id
  )
)
