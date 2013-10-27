%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [stat]=datasheetarchive(name,fullpath)
% inputs: name - string with the name of the part with the datasheet for example "LM358" or "GD74LS00"
stat=false;

str1='http://www.datasheetarchive.com/';
str2='-datasheet.html';

database='main';

        dir=[];
        file=[];
        datasheet=[];
        if(~isempty(name))               
            datasheet=name;
            strA=[str1,name,str2];
            [strWeb,status] = urlread(strA);                % check if datasheet exist on http://www.datasheetarchive.com/
            try
                [mR,sR,eR] = regexp(strWeb, 'dir=', 'match','start','end');             % exctract dir variable

                [~,sAnd,~] = regexp(strWeb(eR(1):end), '&', 'match','start','end');          
                dir=strWeb(eR(1)+1:eR(1)+sAnd(1)-2);

                [mR,sR,eR] = regexp(strWeb, 'file=', 'match','start','end');            % exctract file variable
                [~,sAnd,~] = regexp(strWeb(eR(1):end), '&', 'match','start','end');     % exctract file variable
                file=strWeb(eR(1)+1:eR(1)+sAnd(1)-2);

                fullpath1=fullpath(2:end-1);

                pt=userpath;
                pt=[pt(1:end-1),'/SearchPart Java '];
                js=['java -cp ', pt, fullpath1,' ', datasheet,' ', dir,' ',file,' ',database];      % bilt java command for terminal
                system(js);                                     % download dataseet with java programm
                
%                 upath=userpath();
%                 currentpath=upath(1:end-1);
%                 javaaddpath(currentpath);
%                 o=Java;
%                 javaMethod('main',o, {fullpath1, datasheet, dir, file, database});
                
                stat=true;
            catch err
                disp('error: not possible reading datasheet!');
                
            end
        end

end
