%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [b,indOut]=myim2colp(varargin)
%IM2COL Rearrange image blocks into columns.
%   B = IM2COL(A,[M N],'distinct') rearranges each distinct
%   M-by-N block in the image A into a column of B. IM2COL pads A
%   with zeros, if necessary, so its size is an integer multiple
%   of M-by-N. If A = [A11 A12; A21 A22], where each Aij is
%   M-by-N, then B = [A11(:) A12(:) A21(:) A22(:)].
%
%   B = IM2COL(A,[M N],'sliding') converts each sliding M-by-N
%   block of A into a column of B, with no zero padding. B has
%   M*N rows and will contain as many columns as there are M-by-N
%   neighborhoods in A. If the size of A is [MM NN], then the
%   size of B is (M*N)-by-((MM-M+1)*(NN-N+1). Each column of B
%   contains the neighborhoods of A reshaped as NHOOD(:), where
%   NHOOD is a matrix containing an M-by-N neighborhood of
%   A. IM2COL orders the columns of B so that they can be
%   reshaped to form a matrix in the normal way. For example,
%   suppose you use a function, such as SUM(B), that returns a
%   scalar for each column of B. You can directly store the
%   result in a matrix of size (MM-M+1)-by-(NN-N+1) using these
%   calls:
%
%        B = im2col(A,[M N],'sliding');
%        C = reshape(sum(B),MM-M+1,NN-N+1);
%
%   B = IM2COL(A,[M N]) uses the default block type of
%   'sliding'.
%
%   B = IM2COL(A,'indexed',...) processes A as an indexed image,
%   padding with zeros if the class of A is uint8 or uint16, or
%   ones if the class of A is double.
%
%   Class Support
%   -------------
%   The input image A can be numeric or logical. The output matrix
%   B is of the same class as the input image.
%
%   Example
%   -------
%   Calculate the local mean using a [2 2] neighborhood with zero padding.
%
%       A = reshape(linspace(0,1,16),[4 4])'
%       B = im2col(A,[2 2])
%       M = mean(B)
%       newA = col2im(M,[1 1],[3 3])
%
%   See also BLOCKPROC, COL2IM, COLFILT, NLFILTER.

%   Copyright 1993-2009 The MathWorks, Inc.
%   $Revision: 5.22.4.6 $  $Date: 2009/04/15 23:10:36 $
T=varargin{3};
varargin2=varargin(1:end-1);
[a, block, kind, padval] = parse_inputs(varargin2{:});

if strcmp(kind, 'distinct')
    % Pad A if size(A) is not divisible by block.
%     [m,n] = size(a);
%     mpad = rem(m,block(1)); if mpad>0, mpad = block(1)-mpad; end
%     npad = rem(n,block(2)); if npad>0, npad = block(2)-npad; end
%     aa = mkconstarray(class(a), padval, [m+mpad n+npad]);
%     aa(1:m,1:n) = a;
%     
%     [m,n] = size(aa);
%     mblocks = m/block(1);
%     nblocks = n/block(2);
%     
%     b = mkconstarray(class(a), 0, [prod(block) mblocks*nblocks]);
%     x = mkconstarray(class(a), 0, [prod(block) 1]);
%     rows = 1:block(1); cols = 1:block(2);
%     for i=0:mblocks-1,
%         for j=0:nblocks-1,
%             x(:) = aa(i*block(1)+rows,j*block(2)+cols);
%             b(:,i+j*mblocks+1) = x;
%         end
%     end
    
elseif strcmp(kind,'sliding')

    [ma,na] = size(a);
    m = block(1); n = block(2);
    s1=round(m/2);
    s2=round(n/2);
    %T1=zeros(size(T));
    %T1(s1:end-s1,s2:end-s2)=T(s1:end-s1,s2:end-s2);
    T1=T(s1:end-s1+1,s2:end-s2+1);
    T2=reshape(T1,1,size(T1,1)*size(T1,2));
    indOut=find(T2>0);
    
    if any([ma na] < [m n]) % if neighborhood is larger than image
        b = zeros(m*n,0);
        return
    end
    
    % Create Hankel-like indexing sub matrix.
    mc = block(1); nc = ma-m+1; nn = na-n+1;
    cidx = (0:mc-1)'; ridx = 1:nc;
    t = cidx(:,ones(nc,1)) + ridx(ones(mc,1),:);    % Hankel Subscripts
    tt = zeros(mc*n,nc);
    rows = 1:mc;
    for i=0:n-1,
        tt(i*mc+rows,:) = t+ma*i;
    end
    
    
    numT=sum(T2(:));
    
    ttt = zeros(mc*n,numT);
    cols = 1:nc;
    k=1;
    for j=0:nn-1,
        ind=find(T2((j*nc)+1:(j+1)*nc));
        ttn=tt(:,ind); 
        colsn=cols(ind);
        ttt(:,k:k+size(ttn,2)-1) = ttn+ma*j;
        k=k+size(ttn,2);
    end
    q=1;



%     ttt = zeros(mc*n,nc*nn);
%     cols = 1:nc;
%     for j=0:nn-1,
%         ttt(:,j*nc+cols) = tt+ma*j;
%     end


    % If a is a row vector, change it to a column vector. This change is
    % necessary when A is a row vector and [M N] = size(A).
    if ndims(a) == 2 && na > 1 && ma == 1
        a = a(:);
    end
    
    %ind2=ttt(ttt>0);
    %b=zeros(size(ttt));
    b = a(ttt);
    %b = a(ttt);
    q=1;
else
    % We should never fall into this section of code.  This problem should
    % have been caught in input parsing.
    eid = sprintf('Images:%s:internalErrorUnknownBlockType', mfilename);
    error(eid, '%s is an unknown block type', kind);
end

%%%
%%% Function parse_inputs
%%%
function [a, block, kind, padval] = parse_inputs(varargin)

iptchecknargin(2,4,nargin,mfilename);

switch nargin
    case 2
        if (strcmp(varargin{2},'indexed'))
            eid = sprintf('Images:%s:tooFewInputs', mfilename);
            error(eid, '%s: Too few inputs to IM2COL.', upper(mfilename));
        else
            % IM2COL(A, [M N])
            a = varargin{1};
            block = varargin{2};
            kind = 'sliding';
            padval = 0;
        end
        
    case 3
        if (strcmp(varargin{2},'indexed'))
            % IM2COL(A, 'indexed', [M N])
            a = varargin{1};
            block = varargin{3};
            kind = 'sliding';
            padval = 1;
        else
            % IM2COL(A, [M N], 'kind')
            a = varargin{1};
            block = varargin{2};
            kind = iptcheckstrs(varargin{3},{'sliding','distinct'},mfilename,'kind',3);
            padval = 0;
        end
        
    case 4
        % IM2COL(A, 'indexed', [M N], 'kind')
        a = varargin{1};
        block = varargin{3};
        kind = iptcheckstrs(varargin{4},{'sliding','distinct'},mfilename,'kind',4);
        padval = 1;
        
end

if (isa(a,'uint8') || isa(a, 'uint16'))
    padval = 0;
end
