function obj = readO2Logger(obj,path)
    
    fId             = fopen(path,'r');
    if fId == -1
        warning('readO2Logger:unableToOpenFile',...
                'Unable to read data in:\n\t ''%s''',path)
        return
    end
    
    rawHeader     	= textscan(fId,'%s',4,...
                        'Delimiter',         	',',...
                        'MultipleDelimsAsOne',  false,...
                        'HeaderLines',          0);
	frewind(fId);
    rawText         = textscan(fId,'%{ddMMyy}D%{HHmmss}D%f%*f%f%*f%*f%*f%*f%*f%*f%*f%*f',...
                        'Delimiter',         	',',...
                        'MultipleDelimsAsOne',  false,...
                        'HeaderLines',          4);
    fclose(fId);
    
	
    date        = datevec(rawText{1});
    time        = datevec(rawText{2});
    dt          = datetime([date(:,1:3),time(:,4:6)]);
    
    % extract serial number from filename
    measuringDevice                 = GearKit.measuringDevice();
    measuringDevice.Type            = 'O2Logger';
    SN                              = regexp(rawHeader{1}{2},'SerNum\s:\s(\d+)$','tokens');
    measuringDevice.SerialNumber  	= SN{:}{:};
    
	pool                    = obj.PoolCount;
    variables               = {'Time','Oxygen','Temperature'};
    data                    = cat(2,seconds(dt - dt(1)),rawText{3:4});
    uncertainty             = [];
    variableType            = {'Independant','Dependant','Dependant'};
    variableOrigin          = {dt(1), 0, 0};
    variableMeasuringDevice	= repmat(measuringDevice,1,size(data,2));
    
    obj	= obj.addVariable(pool,variables,data,uncertainty,...
            'VariableType',             variableType,...
            'VariableOrigin',           variableOrigin,...
            'VariableMeasuringDevice',	variableMeasuringDevice);
end