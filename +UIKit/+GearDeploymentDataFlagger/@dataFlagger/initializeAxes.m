function initializeAxes(obj)
    
    import GraphKit.Colormaps.cbrewer.cbrewer
    
    % Determine axes canvas position
    obj.AxesCanvas	= [...
        obj.OuterMargin,...
        obj.OuterMargin + obj.FooterHeight + obj.InnerMargin,...
        obj.FigurePosition(3) - 2*obj.OuterMargin - obj.PanelOptionsWidth - obj.InnerMargin,...
        obj.FigurePosition(4) - 2*obj.OuterMargin - obj.FooterHeight - 2*obj.InnerMargin - obj.HeaderHeight];
    
    % Initialize axes handle array
    hax     = gobjects(obj.NVariables,1);
    for ax = 1:obj.NVariables
        % Create axes
        hax(ax) = axes(obj.FigureHandle,...
            'Visible',                  'off',...
            'NextPlot',                 'add',...
            'Tag',                      obj.VariablesList{ax,'Tag'}{:},...
            'Units',                    obj.Units,...
            'Position',                 obj.AxesCanvas,...
            'FontName',                 obj.FontName,...
            'FontSize',                 obj.FontSize,...
            'LabelFontSizeMultiplier',  obj.FontSizeLabelMultiplier,...
            'TitleFontSizeMultiplier',  obj.FontSizeTitleMultiplier,...
            'TickDir',                  'out',...
            'TickLength',               ones(1,2).*obj.TickLength./max(obj.AxesCanvas(3:4)),...
            'ColorOrder',               cbrewer('qual','Set1',9),...
            'UIContextMenu',            findall(obj.FigureHandle,'Tag','AxesContextMenu'));
        
        % Add listener to the axes handle that listens to the Visible
        % property
        addlistener(hax(ax),'Visible','PostSet',@clearAxis);
    end
    
    % Set ylabel
   	set(cat(1,hax.YLabel),...
        {'String'},     strcat(obj.VariablesList.Abbreviation,{' \color[rgb]{0.5 0.5 0.5}('},obj.VariablesList.Unit,{')'}))
    
    % Assign axes handle array to the the data flagger
    obj.AxesHandles     = hax;
   
    function clearAxis(~,evnt)
    % Clear all children of the axes as soon as it becomes invisible
        switch evnt.AffectedObject.Visible
            case 'off'
                delete(evnt.AffectedObject.Children)
                evnt.AffectedObject.ColorOrderIndex = 1; % Reset ColorOrderIndex
        end
    end
end