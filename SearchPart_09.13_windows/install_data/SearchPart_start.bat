	
set var1=cd
echo "Setting MATLAB userpath"
echo "Starting SearchPart"

matlab -nodesktop -r "pt=%var1%;pt=[pt,'\SearchPart_09.13'];disp(pt);userpath(pt);pause(1);SearchPart; pause(10^10);quit;"
