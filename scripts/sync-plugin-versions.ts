const manifests = [
  "plugin.json",
  ".claude-plugin/plugin.json",
  ".cursor-plugin/plugin.json",
  ".codex-plugin/plugin.json",
];

const { version } = await Bun.file("package.json").json();

for (const path of manifests) {
  const manifest = await Bun.file(path).json();
  manifest.version = version;
  await Bun.write(path, `${JSON.stringify(manifest, null, 2)}\n`);
  console.log(`${path} -> ${version}`);
}
