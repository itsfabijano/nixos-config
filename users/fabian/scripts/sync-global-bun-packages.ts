import { dirname, join, resolve } from "node:path";

type PackageJson = {
  dependencies?: Record<string, string>;
};

const packageJsonPath = resolve(import.meta.dir, "../../../package.json");
const packageJson = (await Bun.file(packageJsonPath).json()) as PackageJson;
const desiredPackages = packageJson.dependencies ?? {};

const globalBinProcess = Bun.spawn(["bun", "pm", "bin", "--global"], {
  stdout: "pipe",
  stderr: "inherit",
});
const globalBin = (await new Response(globalBinProcess.stdout).text()).trim();

if ((await globalBinProcess.exited) !== 0 || !globalBin) {
  throw new Error("Could not determine Bun's global package directory");
}

const globalPackageJsonPath = join(dirname(globalBin), "install/global/package.json");
const globalPackageJsonFile = Bun.file(globalPackageJsonPath);
const globalPackageJson = (await globalPackageJsonFile.exists())
  ? ((await globalPackageJsonFile.json()) as PackageJson)
  : {};
const installedPackages = Object.keys(globalPackageJson.dependencies ?? {});
const packagesToRemove = installedPackages.filter(
  (name) => !(name in desiredPackages),
);

async function runBun(args: string[]) {
  const process = Bun.spawn(["bun", ...args], {
    stdin: "inherit",
    stdout: "inherit",
    stderr: "inherit",
  });

  if ((await process.exited) !== 0) {
    throw new Error(`bun ${args.join(" ")} failed`);
  }
}

if (packagesToRemove.length > 0) {
  console.log(`Removing global Bun packages: ${packagesToRemove.join(", ")}`);
  await runBun(["remove", "--global", ...packagesToRemove]);
}

const packagesToInstall = Object.entries(desiredPackages).map(
  ([name, version]) => `${name}@${version}`,
);

if (packagesToInstall.length > 0) {
  console.log(`Installing global Bun packages: ${packagesToInstall.join(", ")}`);
  await runBun(["install", "--global", "--trust", ...packagesToInstall]);
}
