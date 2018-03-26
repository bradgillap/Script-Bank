#!/bin/bash

#Requires https://github.com/muldjord/skyscraper

#Set options

CONSOLE="snes"

USR1="Brad"
USR2="Ethan"
USR3="Haley"
USR4="Mirm"

SCRAPER1="screenscraper"
SCRAPER2="openretro"
SCRAPER3="thegamesdb"
SCRAPER4="worldofspectrum"

#Update master first.

Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/Master --unattend -s $SCRAPER1 -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/Master --unattend -s $SCRAPER2 -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/Master --unattend -s $SCRAPER3 -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/Master --unattend -s $SCRAPER4 -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video

#Update videos per user
#Brad
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/$USR1 --unattend -s $SCRAPER1 --videos -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/$USR1 --unattend -s $SCRAPER2 --videos -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/$USR1 --unattend -s $SCRAPER3 --videos -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/$USR1 --unattend -s $SCRAPER4 --videos -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/$USR1 --unattend --videos -s localdb -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video

#Ethan
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/$USR2 --unattend -s $SCRAPER1 --videos -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/$USR2 --unattend -s $SCRAPER2 --videos -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/$USR2 --unattend -s $SCRAPER3 --videos -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/$USR2 --unattend -s $SCRAPER4 --videos -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/$USR2 --unattend --videos -s localdb -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video

#Haley
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/$USR3 --unattend -s $SCRAPER1 --videos -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/$USR3 --unattend -s $SCRAPER2 --videos -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/$USR3 --unattend -s $SCRAPER3 --videos -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/$USR3 --unattend -s $SCRAPER4 --videos -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/$USR3 --unattend --videos -s localdb -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video

#Mirm
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/$USR4 --unattend -s $SCRAPER1 --videos -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/$USR4 --unattend -s $SCRAPER2 --videos -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/$USR4 --unattend -s $SCRAPER3 --videos -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/$USR4 --unattend -s $SCRAPER4 --videos -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video
Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/$USR4 --unattend --videos -s localdb -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video

#After users are updated add videos back to master from the local db.

Skyscraper -p $CONSOLE -i ~/RetroPie/roms/$CONSOLE/Master --unattend --videos -s localdb -o ~/RetroPie/roms/$CONSOLE/images -v ~/RetroPie/roms/$CONSOLE/video

#Combine gamelist.xml files for users and master.  Place in the consoles directory.
