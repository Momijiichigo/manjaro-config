
import {$} from "bun";
import {Some, None, Option} from "rusty-enums"





const S2Listeners: {
  [key: string]: Array<(...data: string[]) => Promise<void>>
} = {}

/**
 * Adds Listeners to `$XDG_RUNTIME_DIR/hypr/[HIS]/.socket2.sock` events.
 *
 * Spec: https://wiki.hyprland.org/IPC/#xdg_runtime_dirhyprhissocket2sock
 *
 */
export function addS2Listener(
  event: string,
  listener: (...data: string[]) => Promise<void>
) {
  if (!S2Listeners[event]) {
    S2Listeners[event] = [];
  }
  S2Listeners[event].push(listener);
}

/**
 * Listens to the `$XDG_RUNTIME_DIR/hypr/[HIS]/.socket2.sock` events.
 *
 * Spec: https://wiki.hyprland.org/IPC/#xdg_runtime_dirhyprhissocket2sock
 *
 *
 * Note:
 * ```sh
 * socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock
 * ```
 */
export async function listenToS2EventLoop() {

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

    const eventLines = text.trim().split("\n")

    // eventStr: "eventName>>data1,data2,data3"
    for (const eventStr of eventLines) {

      const [event, dataStr] = eventStr.split(">>");
      const data = dataStr?.trim().split(",");

      // console.log("event:", event, "data:", data)

      if (event in S2Listeners) {
        await Promise.all(S2Listeners[event].map(listener => listener(...data)))
      }
    }

  }
}

