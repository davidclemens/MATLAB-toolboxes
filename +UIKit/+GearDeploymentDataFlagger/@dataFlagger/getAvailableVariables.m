function getAvailableVariables(obj)

    availableVariables = table();
    for oo = 1:obj.NDeployments
        newTable            = obj.Deployments(oo).data.info;
        newTable{:,'ObjId'}	= oo;
        availableVariables	= cat(1,availableVariables,newTable);
    end
    availableVariables  = availableVariables(availableVariables{:,'Type'} == 'Dependent',:);
    availableVariables{:,'NIndependentVariables'} = cellfun(@numel,availableVariables{:,'IndependentVariableIndex'});

    if any(availableVariables{:,'NIndependentVariables'} > 1)
        error('Dingi:UIKit:GearDeploymentDataFlagger:dataFlagger:getAvailableVariables:TODO',...
          'TODO: not implemented yet.')
    end
    
    obj.AvailableVariables  = availableVariables;
end