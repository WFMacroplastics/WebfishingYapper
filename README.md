# Yapper - by Awesomerly & Sulayre

Yapper is an accessibility mod for Webfishing that integrates text-to-speech into the game. It can read out dialog, chat messages, and UI elements (with a hotkey). It uses the very useful [godot_tts](https://github.com/bruvzg/godot_tts) library by bruvzg to talk to the Microsoft Speech API.

## Installation instructions

If you're using a mod manager for Webfishing, you can search for Yapper and click install. Otherwise, make sure that GDWeave is working. Then, drag the zip file from the releases tab into your GDWeave/mods folder, and do the same for Yapper's dependencies:

- [LucysLib](https://github.com/ceionia/LucysLib) - for BBCode stripping
- [BlueberryWolfi.APIs](https://github.com/BlueberryWolf/APIs) - For keybinds
- [Tacklebox](https://github.com/puppy-girl/TackleBox) - A convenient ingame mod menu/config API

## How to use

Yapper adds a settings page accessible from the main menu that allows you to change various voice parameters (pitch, speed, volume), and change the voicebank. This settings menu has multiple checkboxes for enabling and disabling various sources of TTS input. By default, chat is disabled because it may be undesireable to read out chat messages for people who need TTS for gameplay reasons. 

Yapper also adds a hotkey to the settings to read out UI elements and tooltips, which is bound to **R** by default. To read out extended tooltip descriptions, **hold SHIFT while pressing the hotkey**.

## Building Yapper

We use NotNite's [manifestation](https://github.com/NotNite/manifestation) to package and test Yapper. It builds the C# dll and Godot .pck files and arranges folders to allow for easy distribution of mods. It can also optionally copy the built mod to your mods directory. Running manifestation is as simple as `manifestation ./manifestation.toml -copy`. For more info, check out manifestation's README.

## Credits

- Awesomerly, Sulayre - Main developers
- ZeaTheMays - Logo design
