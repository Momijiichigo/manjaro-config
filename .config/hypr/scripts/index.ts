#!/usr/bin/bun run

import {$} from "bun";
import {Some, None, Option} from "rusty-enums"

import {setEwwVar as setEwwVarWspaces} from "../../eww/scripts/workspaces"
import {setEwwVar as setEwwVarCurrentWspace} from "../../eww/scripts/current_workspace"

import {listenToS2EventLoop, addS2Listener} from "./event_handler.ts"

const arg = Bun.argv[2];
switch (arg) {
  case "main": {
    await mainLoop();
    break;
  }
  default:
    break;
}


const monitorNameMap: Map<string, number> = new Map();

async function mainLoop() {
  // Check if the process is already running
  const foundProcess = await $`ps o command | grep -E '[/ \w]+\.config/hypr/scripts/index\.ts main'`
    .nothrow()
    .text();
  console.log("foundProcess:", foundProcess)
  // If the process is running, then the command will find
  // that process and this process itself; 2 lines.
  const processNotRunning = foundProcess.trim().split('\n').length < 2;
  console.log("processNotRunning", processNotRunning)
  if (processNotRunning) {
    setEwwVarWspaces();
    registerListeners();
    await listenToS2EventLoop();
  }
}


function registerListeners() {
  // Registering S2 event listeners

  addS2Listener("workspacev2", async ([ws_id, _ws_name]) => {
    await $`eww update current_workspace=${ws_id}`
      .nothrow()
      .text();
  })

  addS2Listener("monitoraddedv2", async ([disp_id, disp_name]) => {
    monitorNameMap.set(disp_name, Number(disp_id));
    await Promise.all([
      $`eww open-many bar:bar_${disp_name} \
          --arg bar_${disp_name}:screen=${disp_id}`
        .nothrow()
        .text(),
      setEwwVarWspaces()
    ])
  })

  addS2Listener("monitorremoved", async ([disp_name]) => {
    monitorNameMap.delete(disp_name);
    await Promise.all([
      $`eww close bar_${disp_name}`
        .nothrow()
        .text(),
      setEwwVarWspaces()
    ])
  })

  addS2Listener("createworkspace", async ([ws_id, _ws_name]) => {
    await setEwwVarWspaces()
    console.log("createworkspace", ws_id)
  })

  addS2Listener("destroyworkspace", async () => {
    await setEwwVarWspaces()
  })

  addS2Listener("moveworkspace", async () => {
    await Promise.all([
      setEwwVarWspaces(),
      setEwwVarCurrentWspace()
    ])
  })

  addS2Listener("movewindow", async () => {
    await setEwwVarCurrentWspace()
  })

}
