# About

Musical instrument tuning demo for use with ProjectLam.

HTML version of the demo is available at here :

https://darthlevi.itch.io/auidio

You can check ProjectLam at :

https://projectlam.org/

# Getting started.

In order to use run this demo you will need the "Auidio" module which is reponsiblty for creating the AudioEffect used by this project.

The fork below contains this module at the ProjectLam 
The development takes place in the 'godot_ProjectLam' branch. for a working snapshot use the PL_vxx.xx tags.

https://github.com/darthLeviN/godot.git

clone the latest ```PL``` tag and compile the engine and export templates.

```
git clone https://github.com/darthLeviN/godot.git --depth 1 --branch PL_v0.1
```

Then you need to cd into the resulting folder and compile the engine and the export templates.

for the compliation you will need vulkanSDK. the version 1.3.211.0 is recommended. vulkanSDK can be downloaded at https://vulkan.lunarg.com/sdk/home

A more detailed compliation guide is available at https://docs.godotengine.org/en/latest/development/compiling/index.html 

For web exports you will need to install ```Emscripten```. Installation is available at https://emscripten.org/docs/getting_started/downloads.html

For compiling the web exports you will need to use the command below (for release or debug) :
```
scons platform=web target=template_release
```

If you get a invalid platform error, you will need to source the emscripten file which you were informed about when you entered ```./emsdk activate latest```. The required command is something like ```source ./emsdk_env.sh```. This will add the env variables to your console for compilation.

After compiling the web exports, they will be available as .zip files in the 'bin' foolder.

Then you will need to use the export templates in the godot engine. There are two ways to do this. either the 'Custom Template' option in the web export page. or rename them and directly copying them in the export templates folder. Location for this folder and the required names will be shown in red at the bottom of the Export window in godot when you have the 'Web' Export selected.
