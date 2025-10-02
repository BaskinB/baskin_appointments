const fxManifest = await Bun.file('./fxmanifest.lua').text();
const versionFile = await Bun.file('./version').text();

let newVersion = process.env.TGT_RELEASE_VERSION;
newVersion = newVersion.replace('');

const newFileContent = fxManifest.replace(/\bversion\s+(.*)$/gm, `version '${newVersion}'`);
const versionContent = versionFile.replace(/<.*>/, `<${newVersion}>`);

await Bun.write('./fxmanifest.lua', newFileContent);
await Bun.write('./version', versionContent);