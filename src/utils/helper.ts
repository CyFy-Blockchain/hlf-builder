import { exec } from "child_process";
import { v4 as uuid4 } from "uuid";

export function generateUuid() {
  // return uuid4();
  return "8bc631f7-e262-43f0-af58-791820422fbf";
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
