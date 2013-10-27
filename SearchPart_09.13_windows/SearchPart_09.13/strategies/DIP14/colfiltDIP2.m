%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [b] = colfiltDIP2(varargin)
%COLFILT Columnwise neighborhood operations.
%   COLFILT processes distinct or sliding blocks as columns. COLFILT can
%   perform similar operations to BLOCKPROC and NLFILTER, but often
%   executes much faster.
%
%   B = COLFILT(A,[M N],BLOCK_TYPE,FUN) processes the image A by rearranging
%   each M-by-N block of A into a column of a temporary matrix, and then
%   applying the function FUN to this matrix.  FUN must be a
%   FUNCTION_HANDLE. COLFILT zero pads A, if necessary.
%
%   Before calling FUN, COLFILT calls IM2COL to create the temporary
%   matrix. After calling FUN, COLFILT rearranges the columns of the matrix
%   back into M-by-N blocks using COL2IM.
%
%   BLOCK_TYPE is a string with one these values:
%
%        'distinct' for M-by-N distinct blocks
%        'sliding'  for M-by-N sliding neighborhoods
%
%   B = COLFILT(A,[M N],'distinct',FUN) rearranges each M-by-N distinct
%   block of A in a temporary matrix, and then applies the function FUN to
%   this matrix. FUN must return a matrix of the same size as the temporary
%   matrix. COLFILT then rearranges the columns of the matrix returned by
%   FUN into M-by-N distinct blocks.
%
%   B = COLFILT(A,[M N],'sliding',FUN) rearranges each M-by-N sliding
%   neighborhood of A into a column in a temporary matrix, and then applies
%   the function FUN to this matrix. FUN must return a row vector containing
%   a single value for each column in the temporary matrix. (Column
%   compression functions such as SUM return the appropriate type of
%   output.) COLFILT then rearranges the vector returned by FUN into a
%   matrix of the same size as A.
%
%   B = COLFILT(A,[M N],[MBLOCK NBLOCK],BLOCK_TYPE,FUN)  processes the
%   matrix A as above, but in blocks of size MBLOCKS-by-NBLOCKS to save
%   memory. Note that using the [MBLOCK NBLOCK] argument does not change the
%   result of the operation.
%
%   B = COLFILT(A,'indexed',...) processes A as an indexed image, padding
%   with zeros if the class of A is uint8 or uint16, or ones if the class of
%   A is double or single.
%
%   Note
%   ----
%   To save memory, COLFILT may divide A into subimages and process one
%   subimage at a time.  This implies that FUN may be called multiple
%   times, and that the first argument to FUN may have a different number
%   of columns each time.
%
%   Class Support
%   -------------
%   The input image A can be of any class supported by FUN. The class of B
%   depends on the class of the output from FUN.
%
%   Example
%   -------
%       I = imread('tire.tif');
%       figure, imshow(I)
%       I2 = uint8(colfilt(I,[5 5],'sliding',@mean));
%       figure, imshow(I2)
%
%   See also BLOCKPROC, COL2IM, FUNCTION_HANDLE, IM2COL, NLFILTER.

%   Copyright 1993-2010 The MathWorks, Inc.
%   $Revision: 5.22.4.8 $  $Date: 2010/03/04 16:20:58 $

% Obsolete syntax:
%   B = COLFILT(A,[M N],BLOCK_TYPE,FUN,P1,P2,...) passes the additional
%   parameters P1,P2,..., to FUN. COLFILT calls FUN using:
%
%        Y = FUN(X,P1,P2,...)

%   I/O Spec
%   ========
%   IN
%      A             - any class supported by FUN
%      M,N           - double, integer scalars
%      FUN           - function handle
%      BLOCK_TYPE    - string; either 'sliding' or 'distinct'
%      MBLOCK,NBLOCK - doube, integer scalars
%   OUT
%      B             - class of output depends on the class produced
%                      by FUN

iptchecknargin(4,Inf,nargin,mfilename)

a = varargin{1};
if ischar(varargin{2}) && strcmpi(varargin{2},'indexed')
    indexed = 1;        % It's an indexed image
    varargin(2) = [];
else
    indexed = 0;
end
nhood = varargin{2};

if nargin==4,
    % COLFILT(A, [m n], kind, fun)
    kind = varargin{3};
    fun = varargin{4};
    block = bestblk(size(a));
    params = cell(0,0);
    
else
    
    if ~ischar(varargin{3}),
        % COLFILT(A, [m n], block, kind, fun, P1, ...)
        
        block = varargin{3};
        kind = varargin{4};
        fun = varargin{5};
        T=varargin{6};
        Ic=varargin{7};
        params = varargin(8:end);
        
        
    else
        % COLFILT(A, [m n], kind, fun, P1, ...)
        
        kind = varargin{3};
        fun = varargin{4};
        block = bestblk(size(a));
        T=varargin{5};
        Ic=varargin{6};
        params = varargin(7:end);
        
    end
end

fun = fcnchk(fun, length(params));

if ~ischar(kind),
    error('Image:colfilt:ivalidBlockType',...
        'The block type parameter must be either ''distinct'' or ''sliding''.');
end

kind = [lower(kind) ' ']; % Protect against short string

if kind(1)=='s', % Sliding
    if all(block>=size(a)), % Process the whole matrix at once.
        % Expand A
        [ma,na] = size(a);
        if indexed && isa(a, 'double'),
            aa = ones(size(a)+nhood-1);
        else
            aa = mymkconstarray(class(a), 0, (size(a)+nhood-1));
        end
        aa(floor((nhood(1)-1)/2)+(1:ma),floor((nhood(2)-1)/2)+(1:na)) = a;
        
        % Convert neighborhoods of matrix A to columns
        x = im2col(aa,nhood,'sliding');
        
        % Apply fun to column version of a
        b = reshape(feval(fun,x,params{:}), size(a));
        
    else % Process the matrix in blocks of size BLOCK.
        % Expand A: Add border, pad if size(a) is not divisible by block.
        [ma,na] = size(a);
        mpad = rem(ma,block(1)); if mpad>0, mpad = block(1)-mpad; end
        npad = rem(na,block(2)); if npad>0, npad = block(2)-npad; end
        if indexed && isa(a, 'double'),
            aa = ones(size(a) + [mpad npad] + (nhood-1));
        else
            aa = mymkconstarray(class(a), 0, size(a) + [mpad npad] + (nhood-1));
        end
        aa(floor((nhood(1)-1)/2)+(1:ma),floor((nhood(2)-1)/2)+(1:na)) = a;
        
        %
        % Process each block in turn.
        %
        m = block(1) + nhood(1)-1;
        n = block(2) + nhood(2)-1;
        mblocks = (ma+mpad)/block(1);
        nblocks = (na+npad)/block(2);
        
        % Figure out return type
        chunk1 = a(1:nhood(1), 1:nhood(2));
        chunk2 = Ic(1:nhood(1), 1:nhood(2),:);
        temp = feval(fun, chunk1(:),chunk2(:), params{:});
        
        b = mymkconstarray(class(temp), 0, [ma+mpad,na+npad]);
        arows = (1:m); acols = (1:n);
        brows = (1:block(1)); bcols = (1:block(2));
        mb = block(1); nb = block(2);
        
        Icaa=uint8(zeros(size(aa,1),size(aa,2),3));
        %Icaa(floor((nhood(1)-1)/2)+(1:ma),floor((nhood(2)-1)/2)+(1:na))=Ic;
        Icaa(floor((nhood(1)-1)/2)+(1:ma),floor((nhood(2)-1)/2)+(1:na),:)=Ic;
        

        
        Tall=single(zeros(size(aa)));
        Tall(floor((nhood(1)-1)/2)+(1:ma),floor((nhood(2)-1)/2)+(1:na)) = T;
        
        for i=0:mblocks-1,
            for j=0:nblocks-1,
                T1=Tall(i*mb+arows,j*nb+acols);
                T2=T1(11:end-10,23:end-22);
                %T1=reshape(T1,1,size(T1,1)*size(T1,2));
                %x = im2col(aa(i*mb+arows,j*nb+acols),nhood);
                [x,ind] = myim2colp(aa(i*mb+arows,j*nb+acols),nhood,T1);
                %xg = im2col(Icaa(i*mb+arows,j*nb+acols),nhood);
                [xc,ind] = myim2colc(Icaa(i*mb+arows,j*nb+acols,:),nhood,T1);
                %ind=find(T1);
                %x=x(:,ind);
                %xg=xg(:,ind);
                
                out=feval(fun,x,xc,params{:});
                %outg=feval(fun,xg,params{:});
                
                res2=zeros(1,block(1)*block(2));
                res2(ind)=out;

                b(i*mb+brows,j*nb+bcols) = reshape(res2,block(1),block(2));

            end
        end
        b = b(1:ma,1:na);

    end
    
elseif kind(1)=='d', % Distinct
    if all(block>=size(a)), % Process the whole matrix at once.
        % Convert neighborhoods of matrix A to columns
        x = im2col(a,nhood,'distinct');
        
        % Apply fun to column version of A and reshape
        b = col2im(feval(fun,x,params{:}),nhood,size(a),'distinct');
        
    else % Process the matrix in blocks of size BLOCK.
        % Expand BLOCK so that it is divisible by NHOOD.
        mpad = rem(block(1),nhood(1)); if mpad>0, mpad = nhood(1)-mpad; end
        npad = rem(block(2),nhood(2)); if npad>0, npad = nhood(2)-npad; end
        block = block + [mpad npad];
        
        % Expand A: Add border, pad if size(A) is not divisible by BLOCK.
        [ma,na] = size(a);
        mpad = rem(ma,block(1)); if mpad>0, mpad = block(1)-mpad; end
        npad = rem(na,block(2)); if npad>0, npad = block(2)-npad; end
        if indexed && isa(a, 'double'),
            aa = ones(size(a) + [mpad npad]);
        else
            aa = mymkconstarray(class(a), 0, size(a) + [mpad npad]);
        end
        aa((1:ma),(1:na)) = a;
        
        %
        % Process each block in turn.
        %
        m = block(1); n = block(2);
        mblocks = (ma+mpad)/block(1);
        nblocks = (na+npad)/block(2);
        
        % Figure out return type
        chunk = a(1:nhood(1), 1:nhood(2));
        temp = feval(fun, chunk(:), params{:});
        
        b = mymkconstarray(class(temp), 0, [ma+mpad,na+npad]);
        rows = 1:block(1); cols = 1:block(2);
        for i=0:mblocks-1,
            ii = i*m+rows;
            for j=0:nblocks-1,
                jj = j*n+cols;
                x = im2col(aa(ii,jj),nhood,'distinct');
                b(ii,jj) = col2im(feval(fun,x,params{:}),nhood,block,'distinct');
            end
        end
        b = b(1:ma,1:na);
    end
    
else
    error('Image:colfilt:unknownBlockType',[deblank(kind),' is a unknown block type']);
end
