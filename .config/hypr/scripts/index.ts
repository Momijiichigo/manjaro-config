#!/usr/bin/bun run

import {$} from "bun";
import {Some, None, Option} from "rusty-enums"

import {handleEventS2} from "./event_handler.ts"
import type {EventS2} from "./event_handler.ts"

const arg = Bun.argv[2];
switch (arg) {
  case "main":
    await mainLoop();
    break;
  default:
    break;
}
async function mainLoop() {
  const foundProcess = await $`ps o command | grep -E '[/ \w]+\.config/hypr/scripts/index\.ts main'`
    .nothrow()
    .text();
  console.log("foundProcess:", foundProcess)
  // If the process is running, then the command will find
  // that process and this process itself; 2 lines.
  const processNotRunning = foundProcess.trim().split('\n').length < 2;
  console.log("processNotRunning", processNotRunning)
  if (processNotRunning) {
    // socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock
    const { XDG_RUNTIME_DIR, HYPRLAND_INSTANCE_SIGNATURE } = Bun.env;
    const proc = Bun.spawn([
      "socat",
      "-U",
      "-",
      `UNIX-CONNECT:${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock`
    ]);
    const reader = proc.stdout.getReader();

    const decoder = new TextDecoder();

    let done = false;
    while (!done) {
      const {value, done: d} = await reader.read()
      done = d;
      const text = decoder.decode(value)

      console.log("text:", text)
      const eventStr = text.trim().split("\n") as EventS2[]
      for (const event of eventStr) {
        await handleEventS2(event);
      }

    }
  
  }
}

