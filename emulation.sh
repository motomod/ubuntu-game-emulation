#!/bin/bash

#root check
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

#software install
echo | add-apt-repository ppa:libretro/testing
echo | add-apt-repository ppa:gregory-hainaut/pcsx2.official.ppa
echo | add-apt-repository ppa:emulationstation/ppa
apt-get update
apt-get install retroarch libretro-genesisplusgx libretro-snes9x libretro-vbam libretro-nestopia libretro-tgbdual libretro-stella pcsxr pcsx2-unstable emulationstation emulationstation-theme-simple -y

echo "Software packages installed"



#configs copy
rm -r ~/.emulationstation ~/.config/retroarch ~/.config/PCSX2 ~/.pcsx
cp -r config/retroarch ~/.config/retroarch
cp -r config/emulationstation ~/.emulationstation
cp -r config/pcsx ~/.pcsx
cp -r config/pcsx2 ~/.config/PCSX2

echo "Configs copied"

read -e -p "Please enter the path to your Roms: " -i "/home/$SUDO_USER/roms" rom_path
echo "Setting up for Rom Path at $rom_path"



#paths update
sed -i "s.%%%rom_path%%%.$rom_path.g" ~/.emulationstation/es_systems.cfg ~/.pcsx/pcsx.cfg ~/.config/PCSX2/inis/PCSX2_ui.ini

echo "Configs set with provided Rom Path"



#create directories if needed
if [ ! -d "$DIRECTORY" ]; then
    echo "Rom directory doesn't exist, creating now"
    mkdir $rom_path
    mkdir $rom_path/snes $rom_path/megadrive $rom_path/segacd $rom_path/32x $rom_path/atari2600 $rom_path/gameboy $rom_path/gameboycolor $rom_path/ps1 $rom_path/ps2 $rom_path/ps1bios $rom_path/ps2bios
    echo "Name your PS2 bios 'ps2bios.bin' and place in here" > $rom_path/ps2bios/readme

  # Control will enter here if $DIRECTORY exists.
else
    echo "Rom directory already exists, assuming already created"
fi



#permissions
chown $SUDO_USER:$SUDO_USER ~/.emulationstation ~/.config/retroarch ~/.pcsx ~/.config/PCSX2 ~/roms -R

echo "Permissions fixed"
