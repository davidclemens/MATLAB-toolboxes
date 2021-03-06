classdef measuringDeviceType < DataKit.enum
    enumeration
        undefined
        BigoOptode
        BigoConductivityCell
        BigoSyringeSampler
        BigoCapillarySampler
        BigoManualSampling
        BigoInjector
        BigoNiskinBottle
        BigoPushCore
        BigoVoltage
        HoboLightLogger
        SeabirdCTD
        NortekVector
        O2Logger
        PyrosciencePico
    end
    properties (SetAccess = 'immutable')
        
    end
    methods (Static)
        L = listMembers()
        obj = fromProperty(propertyname,value)
        [tf,info] = validate(propertyname,value)
    end
end