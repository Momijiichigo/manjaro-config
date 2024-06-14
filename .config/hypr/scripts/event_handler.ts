
import {$} from "bun";
import {Some, None, Option} from "rusty-enums"

import {setEwwVar as setEwwVarWspaces} from "../../eww/scripts/workspaces"
import {setEwwVar as setEwwVarCurrentWspace} from "../../eww/scripts/current_workspace"

const monitorNameMap: Map<string, number> = new Map();

export type EventS2 = `${string}>>${string}\n`;
/**
 * Listens to `$XDG_RUNTIME_DIR/hypr/[HIS]/.socket2.sock`
 *
 * Spec: https://wiki.hyprland.org/IPC/#xdg_runtime_dirhyprhissocket2sock
 *
 */
export async function handleEventS2(text: EventS2) {
  const [event, dataStr] = text.split(">>");
  const data = dataStr.trim().split(",");

  console.log("event:", event, "data:", data)
  switch (event) {
    case "workspacev2": {
      // data: [WORKSPACEID, WORKSPACENAME]
      await $`eww update current_workspace=${data[0]}`
        .nothrow()
        .text();
      break;
    }
    case "monitoraddedv2": {
      // data: [MONITORID,MONITORNAME,MONITORDESCRIPTION]
      const disp_id = data[0];
      const disp_name = data[1];

      monitorNameMap.set(disp_name, Number(disp_id));
      await Promise.all([
        $`eww open-many bar:${disp_name} \
          --arg ${disp_name}:screen=${disp_id}`
          .nothrow()
          .text(),
        setEwwVarWspaces()
      ])
      break;
    }
    case "monitorremoved": {
      // data: [MONITORNAME]
      const disp_name = data[0];
      monitorNameMap.delete(disp_name);
      await Promise.all([
        $`eww close bar:${disp_name}`
          .nothrow()
          .text(),
        setEwwVarWspaces()
      ])
      break;
    }
    case "createworkspace": {
      await setEwwVarWspaces()
      console.log("createworkspace", data)
      break;
    }
    case "destroyworkspace": {
      await setEwwVarWspaces()
      break;
    }
    case "moveworkspace": {
      await Promise.all([
        setEwwVarWspaces(),
        setEwwVarCurrentWspace()
      ])
      break;
    }
    case "movewindow": {
      await setEwwVarCurrentWspace()
      break;
    }

    default:
      break;
  }

}
