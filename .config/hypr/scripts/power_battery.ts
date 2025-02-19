#!/usr/bin/bun run
import {$} from "bun";
enum BatteryWarned {
  None,
  Low,
  Critical
}

const arg = Bun.argv[2];
switch (arg) {
  case "set_mode": {
    await setPowerMode(Number(Bun.argv[3]) as 0 | 1 | 2);
    break;
  }
  default:
    console.warn("No argument provided. Exiting...")
    break;
}

let batteryWarned: BatteryWarned = BatteryWarned.None;

export async function checkAndWarnBattery() {
  const batteryPercentage = Number(
    await $`upower -i $(upower -e | rg 'BAT') | rg ' +percentage: +(\d+)%$' -r '$1'`
      .nothrow()
      .text()
  );

  const chargingStatus = await $`upower -i $(upower -e | rg 'BAT') | rg ' +state: +(.+)$' -r '$1'`
    .nothrow()
    .text()
    .then(text => text.trim());

  console.log("batteryPercentage", batteryPercentage);
  console.log("chargingStatus", chargingStatus);

  // Update EWW with charging state
  await $`eww update charging_state=${chargingStatus}`
    .nothrow()
    .text();

  // Power management logic
  if (batteryPercentage > 40 && (chargingStatus === 'charging' || chargingStatus === 'pending-charge')) {
    await $`pstate-frequency -S -g performance -e performance -t on`
      .nothrow()
      .text();
  } else if (batteryPercentage < 60 && chargingStatus === 'discharging') {
    await $`pstate-frequency -S -g powersave -e power -t off`
      .nothrow()
      .text();
  }

  // Battery warning logic
  if (batteryPercentage > 20) {
    batteryWarned = BatteryWarned.None;
  } else if (batteryWarned !== BatteryWarned.Critical && batteryPercentage < 10) {
    // critical warning is not shown yet and level reached below 10%
    batteryWarned = BatteryWarned.Critical;
    await $`notify-send --icon battery-empty "Battery Critical" "Battery is critically low, please plug in the charger"`
      .nothrow()
      .text();
  } else if (batteryWarned === BatteryWarned.None && batteryPercentage < 20) {
    // warning is not shown yet and level reached below 20%
    batteryWarned = BatteryWarned.Low;
    await $`notify-send --icon battery "Battery Low" "Battery is low, please plug in the charger"`
      .nothrow()
      .text();
  } 
}

export async function checkPowerMode() {
  const output = await $`pstate-frequency --get`
    .nothrow()
    .text();

  const governor = output.match(/CPU_GOVERNOR -> (\w+)/)?.[1] ?? "";
  const epp = output.match(/EPP\s+-> (\w+)/)?.[1] ?? "";
  const turbo = output.match(/TURBO\s+-> \d+ \[(\w+)\]/)?.[1]?.toLowerCase() ?? "";

  let power_mode = 1; // default middle state

  if (governor === "performance" && epp === "performance" && turbo === "on") {
    power_mode = 2;
  } else if (governor === "powersave" && epp === "power" && turbo === "off") {
    power_mode = 0;
  }
  console.log("governor", governor, "epp", epp, "turbo", turbo);
  
  console.log("power_mode", power_mode);
  

  await $`eww update power_mode=${power_mode}`
    .nothrow()
    .text();
}

export async function setPowerMode(mode: 0 | 1 | 2) {
  switch (mode) {
    case 0:
      await $`pstate-frequency -S -g powersave -e power -t off`
        .nothrow()
        .text();
      break;
    case 1:
      await $`pstate-frequency -S -g ondemand -e balance_power -t off`
        .nothrow()
        .text();
      break;
    case 2:
      await $`pstate-frequency -S -g performance -e performance -t on`
        .nothrow()
        .text();
      break;
  }

  // Update eww variable
  await $`eww update power_mode=${mode}`
    .nothrow()
    .text();
}

