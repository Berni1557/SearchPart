%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [err,StrName]=searchWord(Strings,bar,SearchPartLibrary)
DatasheetNamesSize=SearchPartLibrary.loadDatasheetNamesSize();
err=[];
StrName=[];
ret=char(10);
% load name-list of all parts od datasheet.com the list is sorted by number of characters
%load ('DIP14Data/NamesNumOut');
for i=1:size(Strings,2)
    bar.update();
    for j=1:size(Strings{i},2)
        StrName{i}{j}=[];
        err{i}{j}=[];
        S=Strings{i}{j};
        Err=10;
        % maximum number of characters is 10
        if(size(S,2)<=10)
            n=size(S,2);
        else
            n=10;
            S=S(1:10);
        end
        
        % check if string is empty
        if(~isempty(S))
            % search for string in name-list of names with number of characters-1 till number of characters+1
            for numC=n-1:n+1
                text=DatasheetNamesSize{numC};
                % replace charachters '|','^' and '$' by '!'
                S = strrep(S, '|', '!');
                S = strrep(S, '^', '!');
                S = strrep(S, '$', '!');
                
                % s is number 2^n-1 is number of possible changes of characters in theword
                for s=2^n-1:-1:1
                    % transfor from decimal system to binary system
                    b =de2bi(s,n);
                    
                    if(s==109)
                        q=1;
                    end
                    % replace all charcters on position where b is 1 by '.'
                    strSearch=S;
                    strSearch(find(~b))='.';
                    
                    % calculate number of errors
                    r=size(strfind(strSearch,'!'),2)+size(strfind(strSearch,'.'),2);
                    % check size of the error
                    if((r<=round(n*0.3)) && sum(b)>=4 && r<=Err) 
                        % search word-variants in word list
                        [mS] = regexp(text, strSearch, 'match');         
                        for k=1:size(mS,2)
                            if(size(strfind(mS{k},ret),2)==0)
                                StrName{i}{j}{end+1}=mS{k};
                                % compute the error between word-variant and original
                                E=(strdist(S,mS{k}));     
                                err{i}{j}{end+1}=E/n;        
                                if(E<Err)
                                    Err=E;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end


end


