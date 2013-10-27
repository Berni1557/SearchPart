%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function OCRtesseractLetterSample()
% sample of the library function SearchPartLibrary.OCRtesseractLetter
% load library
load('SearchPartLibrary');
% read images and do character recognition
I1=imread('6.JPG');
[letter_6]=OCRtesseractLetter(I1);
I2=imread('T.JPG');
[letter_T]=OCRtesseractLetter(I2);
I3=imread('V.JPG');
[letter_V]=OCRtesseractLetter(I3);
delete('out.txt');
% show results
subplot(3,1,1);
hold on;
imshow(I1);
title(['Recognized as: ',letter_6{1}]);
subplot(3,1,2);
imshow(I2);
title(['Recognized as: ',letter_T{1}]);
subplot(3,1,3);
imshow(I3);
title(['Recognized as: ',letter_V{1}]);
end
