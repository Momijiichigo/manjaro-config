import {$} from "bun";
enum BatteryWarned {
  None,
  Low,
  Critical
}

let batteryWarned: BatteryWarned = BatteryWarned.None;

export async function checkAndWarnBattery() {
  const batteryPercentage = Number(
    await $`upower -i $(upower -e | rg 'BAT') | rg ' +percentage: +(\d+)%$' -r '$1'`
      .nothrow()
      .text()
  );
  console.log("batteryPercentage", batteryPercentage)

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
