#!/bin/bash

# get Download from: https://www.betterbird.eu/downloads/
# find the suitable language (en-US,de,fr,...): 
lang=de
#release, previous:
version=release


tmpPath=~/tmp/betterbird
tmpFile=$tmpPath/download

dstRootPath=~/
#desktopFile=$dstRootPath/betterbird.desktop
desktopFile=~/.local/share/applications/betterbird.desktop

mkdir -p $tmpPath
cd  $tmpPath||exit 1

downloadUpdate(){
	rm $tmpFile
	wget -O $tmpFile "https://www.betterbird.eu/downloads/get.php?os=linux&lang=$lang&version=$version"
#	Location: https://www.betterbird.eu/downloads/LinuxArchive/betterbird-102.5.0-bb24.de.linux-x86_64.tar.bz2 [following]

}



checkHash(){
	hash=`sha256sum $tmpFile|awk '{print $1}'`
	echo Hash: $hash
	update=`cat sha256*.txt|grep $hash|awk '{print $2}'`
	echo Found: $update
	if [ "$update" == "" ]; then
		echo getting last version of hash
		rm $tmpPath/sha256*.txt
	        wget https://www.betterbird.eu/downloads/sha256-102.txt
		
		hash=`sha256sum $tmpFile|awk '{print $1}'`
		echo Hash: $hash
		update=`cat sha256*.txt|grep $hash|awk '{print $2}'`
		echo Found: $update
		if [ "$update" == "" ]; then
			echo no valid update found
			echo check this script $0 and the downloadpage. Perhaps you have to adapt the sha256-Url
			exit 1
		fi

	fi
}


extract(){
	cd $dstRootPath||exit 1
	rm -rf betterbird
	tar xjvf $tmpFile -C $dstRootPath
	cd betterbird
	ls -l
	pwd

}

createDesktopFile(){
cat << EOF > $desktopFile
	[Desktop Entry]
	Encoding=UTF-8
	Version=1.0
	Type=Application
	Terminal=false
	Name=Betterbird
EOF
	echo Exec=$dstRootPath/betterbird/betterbird >> $desktopFile
	echo Icon=$dstRootPath/betterbird//chrome/icons/default/default256.png >> $desktopFile

#	sudo mv ~/.local/share/applications/<application-name.desktop> 
#	/usr/share/applications/
#  	/usr/share/app-install/desktop/
}



downloadUpdate
getSha256
checkHash
extract
createDesktopFile
echo Ende
