function obj = initializeAxesAppearance(obj)



    defaultColorOrder = [...
             0    0.4470    0.7410
        0.8500    0.3250    0.0980
        0.9290    0.6940    0.1250
        0.4940    0.1840    0.5560
        0.4660    0.6740    0.1880
        0.3010    0.7450    0.9330
        0.6350    0.0780    0.1840];
    
    set(obj.Children,...
        'Box',              'off',...
        'Color',            'none',...
        'Clipping',         'on',...
        'TickDir',          'out',...
        'XMinorTick',       'on',...
        'YMinorTick',       'on')

    % set limits
    set(obj.Children,...
        {[obj.CommonAxis(1),'Lim']},        obj.CommonAxesDataLimits)
    set(obj.Children,...
        {[obj.IndividualAxis(1),'Lim']},	obj.IndividualAxesDataLimits)
    
    switch obj.CommonAxis
        case 'XAxis'
            set(obj.Children(end:-2:1),...
                'YAxisLocation',        'left')
            set(obj.Children(end - 1:-2:1),...
                'YAxisLocation',        'right')
            set(obj.Children,...
                'XAxisLocation',        'bottom')
            
            set(obj.Children(1:end - 1),...
                'XColor',               'none',...
                'XTick',                [])
            set(obj.Children(1:end),...
                'YColor',           	'k',...
                'YTickMode',            'auto')
%                 {'YColor'},           	num2cell(defaultColorOrder(1 + mod(0:obj.NAxes - 1,size(defaultColorOrder,1)),:),2),...
        case 'YAxis'
            switch obj.CommonAxesDirection
                case 'normal'
                    set(obj.Children(1:2:end),...
                        'XAxisLocation',        'bottom')
                    set(obj.Children(2:2:end),...
                        'XAxisLocation',        'top')
                case 'reverse'
                    set(obj.Children(1:2:end),...
                        'XAxisLocation',        'top')
                    set(obj.Children(2:2:end),...
                        'XAxisLocation',        'bottom')
            end
            
            
            set(obj.Children,...
                'YAxisLocation',        'left')
            
            set(obj.Children(2:end),...
                'YColor',               'none',...
                'YTick',                [])
            set(obj.Children(1:end),...
                'XColor',               'k',...
                'XTickMode',            'auto')
    end
end