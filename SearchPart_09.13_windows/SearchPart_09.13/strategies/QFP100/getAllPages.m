%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [pages1,pages2]=getAllPages(Strings1,Strings2)

pagename='http://www.datasheetarchive.com/datasheet/';  % check internet connection
[~,network] = urlread2(pagename,[],[],5000);

pages1=[];  
pages2=[];
if(network)                         % check internet connection
    for i=1:size(Strings1,2)
        for j=1:size(Strings1{i},2)

            % String1
            strS=Strings1{i}{j};
            strA=[pagename,'1--',strS,'.html'];
            [FullSide]=getFullSide(strA);               % get first Full side
            if(FullSide)
                [strN]=searchaltered(FullSide,strS);        % change string if name of the part altered to another name on www.datasheetarchive.com search 
                strA=[pagename,'1--',strN,'.html'];
                [SubSide]=getSubSide(strA);             % get subside of searchpages results
                pages1{i}{j}{1}=SubSide;
                if(SubSide)
                    [pageend]=ispageend(SubSide,strN,1);        % check if there are more pages 
                    page=2;
                    while(~pageend && p<10 && ~isempty(SubSide))
                        strA=[pagename,num2str(p),'--',strN,'.html'];
                        [SubSide]=getSubSide(strA);
                        if(SubSide)
                            [pageend]=ispageend(SubSide,strN,p);        % check if there are more pages  
                            pages1{i}{j}{p}=SubSide;
                        end
                        page=page+1;
                    end
                end
            end
        end
    end

    for i=1:size(Strings2,2)
        for j=1:size(Strings2{i},2)        
            % String2
            strS=Strings2{i}{j};
            strA=[pagename,'1--',strS,'.html'];
            [FullSide]=getFullSide(strA);                        % get first Full side
            if(FullSide)
                [strN,altered]=searchaltered(FullSide,strS);            % change string if name of the part altered to another name on www.datasheetarchive.com search 
                strA=[pagename,'1--',strN,'.html'];
                [SubSide]=getSubSide(strA);                             % get subside of searchpages results
                if(SubSide)
                    pages2{i}{j}{1}=SubSide;
                    [pageend]=ispageend(SubSide,strN,1);                 % check if there are more pages  
                    page=2;
                    while(~pageend && p<10 && ~isempty(SubSide))
                        strA=[pagename,num2str(p),'--',strN,'.html'];
                        [SubSide]=getSubSide(strA);                     % get subside of searchpages results
                        if(SubSide)
                            [pageend]=ispageend(SubSide,strN,p);         % check if there are more pages  
                            pages2{i}{j}{p}=SubSide;
                        end
                        page=page+1;
                    end
                end
            end

        end
    end
end

end