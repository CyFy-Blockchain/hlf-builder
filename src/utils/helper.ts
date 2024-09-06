import { exec } from "child_process";
import { ScriptMode } from "../interface/cliArgs";

export function parseMode(mode: string) {
  if (mode === "up") return ScriptMode.Up;
  if (mode === "down") return ScriptMode.Down;

  throw new Error(`Invalid mode "${mode}"`);
}

// for yaml data structures like ['key=value', ...]
export function updateKeyValueInArray(
  arr: string[],
  key: string,
  value: string | number
) {
  return arr.map((item) => {
    const [k, v] = item.split("=");
    if (k === key) return `${key}=${value}`;
    return item;
  });
}

export async function runCommand(
  command: string,
  params: (string | number)[] = []
) {
  return new Promise((resolve, reject) => {
    exec(command + " " + params.join(" "), (error, stdout, stderr) => {
      if (error) {
        console.error(`Error: ${error.message}`);
        reject(error);
      } else {
        console.log(`stdout: ${stdout}`);
        console.error(`stderr: ${stderr}`);
        resolve({ stdout, stderr });
      }
    });
  });
}
