%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [R1]=createFit1(x1,y1,w)
pl=false;
%CREATEFIT Create plot of data sets and fits
%   CREATEFIT(X1,Y1,W)
%   Creates a plot, similar to the plot in the main Curve Fitting Tool,
%   using the data that you provide as input.  You can
%   use this function with the same data you used with CFTOOL
%   or with different data.  You may want to edit the function to
%   customize the code and this help message.
%
%   Number of data sets:  1
%   Number of fits:  1

% Data from data set "y1 vs. x1 with w":
%     X = x1:
%     Y = y1:
%     Weights = w:

% Auto-generated by MATLAB on 29-Jan-2013 15:31:56

% Set up figure to receive data sets and fits
if(pl)
    f_ = clf;
    figure(f_);
    set(f_,'Units','Pixels','Position',[466 139 616 430]);
    % Line handles and text for the legend.
    legh_ = [];
    legt_ = {};
    % Limits of the x-axis.
    xlim_ = [Inf -Inf];
    % Axes for the plot.
    ax_ = axes;
    set(ax_,'Units','normalized','OuterPosition',[0 0 1 1]);
    set(ax_,'Box','on');
    axes(ax_);
    hold on;

    % --- Plot data that was originally in data set "y1 vs. x1 with w"
    x1 = x1(:);
    y1 = y1(:);
    w = w(:);
    h_ = line(x1,y1,'Parent',ax_,'Color',[0.333333 0 0.666667],...
        'LineStyle','none', 'LineWidth',1,...
        'Marker','.', 'MarkerSize',12);
    xlim_(1) = min(xlim_(1),min(x1));
    xlim_(2) = max(xlim_(2),max(x1));
    legh_(end+1) = h_;
    legt_{end+1} = 'y1 vs. x1 with w';

    % Nudge axis limits beyond data limits
    if all(isfinite(xlim_))
        xlim_ = xlim_ + [-1 1] * 0.01 * diff(xlim_);
        set(ax_,'XLim',xlim_)
    else
        set(ax_, 'XLim',[0.94999999999999995559, 6.0499999999999998224]);
    end
end
% --- Create fit "fit 1"

fo_ = fitoptions('method','LinearLeastSquares','Lower',[-1 -Inf],'Upper',[1 Inf]);
ok_ = isfinite(x1) & isfinite(y1) & isfinite(w);
if ~all( ok_ )
    warning( 'GenerateMFile:IgnoringNansAndInfs',...
        'Ignoring NaNs and Infs in data.' );
end
set(fo_,'Weight',w(ok_));
ft_ = fittype('poly1');

% Fit this model using new data
cf_ = fit(x1(ok_),y1(ok_),ft_,fo_);
R1=abs(cf_(x1)-y1);
% Alternatively uncomment the following lines to use coefficients from the
% original fit. You can use this choice to plot the original fit against new
% data.
%    cv_ = { 0.069159071344977243734, 29.929635134394473539};
%    cf_ = cfit(ft_,cv_{:});

% Plot this fit
if(pl)
    h_ = plot(cf_,'fit',0.95);
    set(h_(1),'Color',[1 0 0],...
        'LineStyle','-', 'LineWidth',2,...
        'Marker','none', 'MarkerSize',6);
    % Turn off legend created by plot method.
    legend off;
    % Store line handle and fit name for legend.
    legh_(end+1) = h_(1);
    legt_{end+1} = 'fit 1';

    % --- Finished fitting and plotting data. Clean up.
    hold off;
    % Display legend
    leginfo_ = {'Orientation', 'vertical', 'Location', 'NorthEast'};
    h_ = legend(ax_,legh_,legt_,leginfo_{:});
    set(h_,'Interpreter','none');
    % Remove labels from x- and y-axes.
    xlabel(ax_,'');
    ylabel(ax_,'');
end