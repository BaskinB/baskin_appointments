const fxManifest = await Bun.file('./fxmanifest.lua').text();

let newVersion = process.env.TGT_RELEASE_VERSION;
newVersion = newVersion.replace('');

const newFileContent = fxManifest.replace(/\bversion\s+(.*)$/gm, `version '${newVersion}'`);

await Bun.write('./fxmanifest.lua', newFileContent);