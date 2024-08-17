import { exec } from "child_process";

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
