#!/bin/bash
#Update master first.

Skyscraper -p snes -i ~/RetroPie/roms/snes/Master --unattend -s screenscraper -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video
Skyscraper -p snes -i ~/RetroPie/roms/snes/Master --unattend -s openretro -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video
Skyscraper -p snes -i ~/RetroPie/roms/snes/Master --unattend -s thegamesdb -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video
Skyscraper -p snes -i ~/RetroPie/roms/snes/Master --unattend -s worldofspectrum -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video

#Update videos per user
#Brad
Skyscraper -p snes -i ~/RetroPie/roms/snes/Brad --unattend -s screenscraper --videos -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video
Skyscraper -p snes -i ~/RetroPie/roms/snes/Brad --unattend -s openretro --videos -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video
Skyscraper -p snes -i ~/RetroPie/roms/snes/Brad --unattend -s thegamesdb --videos -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video
Skyscraper -p snes -i ~/RetroPie/roms/snes/Brad --unattend -s worldofspectrum --videos -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video
Skyscraper -p snes -i ~/RetroPie/roms/snes/Brad --unattend --videos -s localdb -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video

#Ethan
Skyscraper -p snes -i ~/RetroPie/roms/snes/Ethan --unattend -s screenscraper --videos -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video
Skyscraper -p snes -i ~/RetroPie/roms/snes/Ethan --unattend -s openretro --videos -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video
Skyscraper -p snes -i ~/RetroPie/roms/snes/Ethan --unattend -s thegamesdb --videos -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video
Skyscraper -p snes -i ~/RetroPie/roms/snes/Ethan --unattend -s worldofspectrum --videos -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video
Skyscraper -p snes -i ~/RetroPie/roms/snes/Ethan --unattend --videos -s localdb -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video

#Haley
Skyscraper -p snes -i ~/RetroPie/roms/snes/Haley --unattend -s screenscraper --videos -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video
Skyscraper -p snes -i ~/RetroPie/roms/snes/Haley --unattend -s openretro --videos -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video
Skyscraper -p snes -i ~/RetroPie/roms/snes/Haley --unattend -s thegamesdb --videos -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video
Skyscraper -p snes -i ~/RetroPie/roms/snes/Haley --unattend -s worldofspectrum --videos -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video
Skyscraper -p snes -i ~/RetroPie/roms/snes/Haley --unattend --videos -s localdb -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video

#Mirm
Skyscraper -p snes -i ~/RetroPie/roms/snes/Mirm --unattend -s screenscraper --videos -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video
Skyscraper -p snes -i ~/RetroPie/roms/snes/Mirm --unattend -s openretro --videos -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video
Skyscraper -p snes -i ~/RetroPie/roms/snes/Mirm --unattend -s thegamesdb --videos -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video
Skyscraper -p snes -i ~/RetroPie/roms/snes/Mirm --unattend -s worldofspectrum --videos -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video
Skyscraper -p snes -i ~/RetroPie/roms/snes/Mirm --unattend --videos -s localdb -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video

#After users are updated add videos back to master from the local db.

Skyscraper -p snes -i ~/RetroPie/roms/snes/Master --unattend --videos -s localdb -o ~/RetroPie/roms/snes/images -v ~/RetroPie/roms/snes/video

#Combine gamelist.xml files for users and master.  Place in the consoles directory.
