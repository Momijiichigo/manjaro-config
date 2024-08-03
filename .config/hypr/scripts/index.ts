#!/usr/bin/bun run

import {$} from "bun";
import {Some, None, Option} from "rusty-enums"

import {setEwwVar as setEwwVarWspaces} from "../../eww/scripts/workspaces"
import {setEwwVar as setEwwVarCurrentWspace} from "../../eww/scripts/current_workspace"

import {listenToS2EventLoop, addS2Listener} from "./event_handler.ts"
import {checkAndWarnBattery} from "./battery.ts"

const monitorNameMap: Map<string, number> = new Map();

const arg = Bun.argv[2];
switch (arg) {
  case "main": {
    await main();
    break;
  }
  default:
    console.warn("No argument provided. Exiting...")
    break;
}

async function main() {
  // Check if the process is already running
  const foundProcess = await $`ps o command | rg '[/ \w]+\.config/hypr/scripts/index\.ts main'`
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
    intervalLoop(2);
    await listenToS2EventLoop();
  }
}

/**
 * main loop that runs code every {interval} minutes
 */
function intervalLoop(interval = 2) {
  // check battery percentage
  checkAndWarnBattery();
  const intervalMs = interval * 60000;

  setTimeout(intervalLoop, intervalMs);

}


async function adjustBarDimension() {
  const activeWorkspaceInfo = await $`hyprctl activeworkspace -j`
    .nothrow()
    .json() as {
      windows: number
    };
  const isOneWindowWorkspace = activeWorkspaceInfo.windows === 1;
  await $`eww update is_one_window_wspace=${isOneWindowWorkspace}`
    .nothrow()
    .text();

}




/**
 * Registers S2 event listeners
 */
function registerListeners() {

  addS2Listener("workspacev2", async ([ws_id, _ws_name]) => {
    await Promise.all([
      adjustBarDimension(),
      $`eww update current_workspace=${ws_id}`
        .nothrow()
        .text()
    ])
  })

  addS2Listener("monitoraddedv2", async ([disp_id, disp_name]) => {
    monitorNameMap.set(disp_name, Number(disp_id));

    /*
      # ------------ Workaround --------------
      Currently (Eww 0.5.0) the dimension of 
      the widget on another monitors are not correct
      (the dimension of the first monitor is used for all monitors)
      Below is a workaround to fix the issue
    */
    const screenInfos: ScreenInfo[] = await $`hyprctl monitors all -j`
      .nothrow()
      .json();
    const screenInfo = screenInfos.find(s => s.name === disp_name);

    let screenWidth = 0;
    if (screenInfo) {
      const {width, scale} = screenInfo;
      screenWidth = width / scale | 0;

    }

    // End of the workaround ----------


    await Promise.all([
      $`eww open-many bar:bar_${disp_name} \
          --arg bar_${disp_name}:screen=${disp_id} \
          --arg bar_${disp_name}:width=${screenWidth}`
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
    await Promise.all([
      adjustBarDimension(),
      setEwwVarWspaces()
    ])
    console.log("createworkspace", ws_id)
  })

  addS2Listener("destroyworkspace", async () => {
    await setEwwVarWspaces()
  })

  addS2Listener("moveworkspace", async () => {
    await Promise.all([
      setEwwVarWspaces(),
      setEwwVarCurrentWspace(),
      adjustBarDimension()
    ])
  })

  addS2Listener("movewindow", async () => {
    await Promise.all([
      adjustBarDimension(),
      setEwwVarCurrentWspace()
    ])
  })

}

type ScreenInfo = {
  id: 0,
  name: string,
  description: string,
  make: string,
  model: string,
  serial: string,
  width: number,
  height: number,
  refreshRate: number,
  x: number,
  y: number,
  activeWorkspace: {
    id: number,
    name: string
  },
  specialWorkspace: {
    id: number,
    name: string
  },
  reserved: number[],
  scale: number,
  transform: number,
  focused: boolean,
  dpmsStatus: boolean,
  vrr: boolean,
  activelyTearing: boolean,
  disabled: boolean,
  currentFormat: string,
  availableModes: string[]
}

