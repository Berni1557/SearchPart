 #!/bin/bash 
echo "Installing SearchPart"
var1=`pwd`
var2=$var1/SearchPart_09.13

echo "Creating file SearchPart_start.sh"
echo " #!/bin/bash " > SearchPart_start.sh
echo "/usr/local/MATLAB/R2011a/bin/matlab -nodesktop -r \"userpath('$var2');SearchPart();pause(10^10);\"" >> SearchPart_start.sh
chmod u+x SearchPart_start.sh
sudo chown root.root SearchPart_start.sh
sudo chmod 4755 SearchPart_start.sh

echo "Copy SearchPart_start.sh to bin directory"
sudo cp SearchPart_start.sh /usr/bin/SearchPart_start.sh

chmod u+x /usr/bin/SearchPart_start.sh
sudo chown root.root /usr/bin/SearchPart_start.sh
sudo chmod 4755 /usr/bin/SearchPart_start.sh

#sudo rm SearchPart_start.sh

echo "Creating startfile"
echo "[Desktop Entry]" > SearchPart.desktop
echo "Name=SearchPart" >> SearchPart.desktop
echo "Type=Application" >> SearchPart.desktop
echo "Comment=SearchPart" >> SearchPart.desktop
echo "Exec=SearchPart_start.sh" >> SearchPart.desktop
echo "Icon=label.png" >> SearchPart.desktop
echo "GenericName=SearchPart" >> SearchPart.desktop
echo "Name[de_DE]=SearchPart" >> SearchPart.desktop
chmod u+x SearchPart.desktop


echo "Installing tesseract"
sudo apt-get install tesseract-ocr
sudo cp SearchPart_09.13/label/label.png /usr/share/icons/label.png

echo "Checking Java-version"
javastr=`java -version 2>&1 |awk 'NR==1{ gsub(/"/,""); print $1 }'`

if [ "$javastr" == "java" ] ;then
	JAVA_VERSION=`java -version 2>&1 |awk 'NR==1{ gsub(/"/,""); print $3 }'`
	javav1=`echo $JAVA_VERSION | cut -c3-3`
	var1=6
	hasjava=`echo "$javav1 <= $var1" | bc`
	if [ "$hasjava" == "1" ] ;then
		echo "Installing Java-version 1.7"
		sudo add-apt-repository ppa:webupd8team/java
		sudo apt-get update
		sudo apt-get install oracle-java7-installer
	fi
else
	echo "Installing Java-version 1.7"
	sudo add-apt-repository ppa:webupd8team/java
	sudo apt-get update
	sudo apt-get install oracle-java7-installer
fi

echo "Creating Desktop icon"
cp SearchPart.desktop $HOME/Desktop
echo "Have fun!"
exit 0

