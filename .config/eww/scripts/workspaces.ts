#!/usr/bin/bun run
/* @ts-ignore */
const proc = Bun.spawnSync(["hyprctl", "workspaces", "-j"])
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
const workspaces: Workspace[] = JSON.parse(proc.stdout.toString());

// console.log(workspaces)

const monitorWorkspaces: number[][] = []

workspaces.forEach(ws => {
  monitorWorkspaces[ws.monitorID] ??= []
  const workspaceList = monitorWorkspaces[ws.monitorID]
  workspaceList.push(ws.id)
  workspaceList.sort((a, b) => a - b)
})
console.log(
  JSON.stringify(
    monitorWorkspaces
  )
)

//Bun.write(Bun.stdout, 
