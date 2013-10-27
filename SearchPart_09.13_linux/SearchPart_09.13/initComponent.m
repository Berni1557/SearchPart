%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize component list used in the session
% Output: componentListTemp is a list of all components with the strategy used in the session
function [componentListTemp]=initComponent()

componentListTemp=[];

% Add you strategy
% componentListTemp{num}=Component('ComponentID',<ID>,'Strategy',<name of strategy object(<ID>,<duration>)>,'Componentname',<Componentname>,'HasDatasheet',<true/false>);

componentListTemp{end+1}=Component('ComponentID',1,'Strategy',ResistorAxialLead_Strategy('duratione',60),'Componentname','ResistorAxialLead','HasDatasheet',false);
componentListTemp{end+1}=Component('ComponentID',2,'Strategy',SMDResistor1206_Strategy('duratione',70),'Componentname','SMDResistor1206','HasDatasheet',false);
componentListTemp{end+1}=Component('ComponentID',3,'Strategy',DIP14_Strategy('duratione',80),'Componentname','DIP14','HasDatasheet',true);
componentListTemp{end+1}=Component('ComponentID',4,'Strategy',PCI_Strategy('duratione',15),'Componentname','PCI','HasDatasheet',false);
componentListTemp{end+1}=Component('ComponentID',5,'Strategy',QFP100_Strategy('duratione',90),'Componentname','QFP100','HasDatasheet',true);
componentListTemp{end+1}=Component('ComponentID',6,'Strategy',SMDResistor0805_Strategy('duratione',70),'Componentname','SMDResistor0805','HasDatasheet',false);

% dummy strategy: (you can replace the dummy_Strategy by your strategy and the DummyComponent by your component and uncomment the line

% componentListTemp{end+1}=Component('ComponentID',7,'Strategy',dummy_Strategy('duratione',5),'Componentname','DummyComponent','HasDatasheet',false);

