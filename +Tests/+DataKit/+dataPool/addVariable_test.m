classdef (SharedTestFixtures = { ...
            matlab.unittest.fixtures.PathFixture(subsref(strsplit(mfilename('fullpath'),'/+'),substruct('{}',{':'})))
        }) addVariable_test < matlab.unittest.TestCase

    % run:
    % tests = matlab.unittest.TestSuite.fromClass(?Tests.DataKit.dataPool.addVariable_test);
    % run(tests)

    properties
        DataPoolInstance
        IndependentVariables
        DependentVariables
        NIndependentVariables
        NDependentVariables
        NData
        ExampleData = struct(...
            'Variable',                     {{'Time','Zinc'}},...
            'Data',                         {cat(2,linspace(0,3600,20)',randn(20,1))},...
            'Pool',                         {9},...
            'Uncertainty',                  {randn(20,2)},...
            'Flag',                         {randi(10,20,2)},...
            'VariableType',                 {{'Independent','Dependent'}},...
            'VariableCalibrationFunction',  {{@(t,x) 2.*x,@(t,x) x + 1}},...
            'VariableOrigin',               {{datetime(1999,3,2,4,32,10),0}},...
            'VariableMeasuringDevice',      {repmat(GearKit.measuringDevice('BigoManualSampling','Ch1AA1','Chamber Lid','BenthicWaterColumn','Chamber1'),1,2)})
    end
    properties (ClassSetupParameter)

    end
    properties (MethodSetupParameter)
        % Creates data pools with a single (s) or multiple (m),
        % independent (I) or dependent (D) variables.
        SetupData	= struct(...
            'ImDm',     struct(...
                'Variable',          {{'Time','Depth','Nitrate','Oxygen'}},...
                'Data',              cat(2,linspace(0,3600,16000)',reshape(repmat(0:15,1000,1),[],1),randn(16000,1),randn(16000,1)),...
                'VariableOrigin',    {{datetime(2020,10,2,15,32,50),0,0,0}},...
                'VariableType',      {{'Independent','Independent','Dependent','Dependent'}},...
                'MeasuringDevice',   repmat(GearKit.measuringDevice('BigoSyringeSampler','Ch1AA1','Chamber Lid','BenthicWaterColumn','Chamber1'),1,4)))
    end
    properties (TestParameter)
        % Selectively only input some of the inputs
        UsePool                         = struct('yes',true,'no',false)
        UseUncertainty              	= struct('yes',true,'no',false)
        UseFlag                         = struct('yes',true,'no',false)
        UseVariableType                 = struct('yes',true,'no',false)
        UseVariableCalibrationFunction	= struct('yes',true,'no',false)
        UseVariableOrigin               = struct('yes',true,'no',false)
        UseVariableMeasuringDevice     	= struct('yes',true,'no',false)

        % Add the new data to an existing or a new data pool
        PoolIdx = struct(...
                         'existing',        1,...
                         'new',             2,...
                         'newLarge',        5)
        % Creates data pools with a single (s) or multiple (m),
        % independent (I) or dependent (D) variables and sample sizes
        % equal (Eq), greater than (Gt) or less than (Lt) the existing
        % ones.
        NewData = struct(...
            'IsDsEq',     	struct('Variable',          {{'Time','Oxygen'}},...
                                   'Data',              cat(2,linspace(0,3600,16000)',randn(16000,1)),...
                                   'VariableOrigin',    {{datetime(2020,10,2,15,32,50),0}},...
                                   'VariableType',      {{'Independent','Dependent'}},...
                                   'MeasuringDevice',   repmat(GearKit.measuringDevice('BigoCapillarySampler','Ch1AA1','Chamber Lid','BenthicWaterColumn','Chamber1'),1,2)),...
            'ImDsEq',     	struct('Variable',          {{'Time','Depth','Oxygen'}},...
                                   'Data',              cat(2,linspace(0,3600,16000)',reshape(repmat(0:15,1000,1),[],1),randn(16000,1)),...
                                   'VariableOrigin',    {{datetime(2020,10,2,15,32,50),0,0}},...
                                   'VariableType',      {{'Independent','Independent','Dependent'}},...
                                   'MeasuringDevice',   repmat(GearKit.measuringDevice('BigoCapillarySampler','Ch1AA1','Chamber Lid','BenthicWaterColumn','Chamber1'),1,3)),...
            'IsDmEq',       struct('Variable',          {{'Time','Nitrate','Oxygen'}},...
                                   'Data',              cat(2,linspace(0,3600,16000)',randn(16000,1),randn(16000,1)),...
                                   'VariableOrigin',    {{datetime(2020,10,2,15,32,50),0,0}},...
                                   'VariableType',      {{'Independent','Dependent','Dependent'}},...
                                   'MeasuringDevice',   repmat(GearKit.measuringDevice('BigoCapillarySampler','Ch1AA1','Chamber Lid','BenthicWaterColumn','Chamber1'),1,2)),...
            'ImDmEq',     	struct('Variable',          {{'Time','Depth','Nitrate','Oxygen'}},...
                                   'Data',              cat(2,linspace(0,3600,16000)',reshape(repmat(0:15,1000,1),[],1),randn(16000,1),randn(16000,1)),...
                                   'VariableOrigin',    {{datetime(2020,10,2,15,32,50),0,0,0}},...
                                   'VariableType',      {{'Independent','Independent','Dependent','Dependent'}},...
                                   'MeasuringDevice',   repmat(GearKit.measuringDevice('BigoCapillarySampler','Ch1AA1','Chamber Lid','BenthicWaterColumn','Chamber1'),1,4)),...
            'IsDsGt',      	struct('Variable',          {{'Time','Oxygen'}},...
                                   'Data',              cat(2,linspace(0,3600,18000)',randn(18000,1)),...
                                   'VariableOrigin',    {{datetime(2020,10,2,15,32,50),0}},...
                                   'VariableType',      {{'Independent','Dependent'}},...
                                   'MeasuringDevice',   repmat(GearKit.measuringDevice('BigoCapillarySampler','Ch1AA1','Chamber Lid','BenthicWaterColumn','Chamber1'),1,2)),...
            'ImDsGt',      	struct('Variable',          {{'Time','Depth','Oxygen'}},...
                                   'Data',              cat(2,linspace(0,3600,18000)',reshape(repmat(0:17,1000,1),[],1),randn(18000,1)),...
                                   'VariableOrigin',    {{datetime(2020,10,2,15,32,50),0,0}},...
                                   'VariableType',      {{'Independent','Independent','Dependent'}},...
                                   'MeasuringDevice',   repmat(GearKit.measuringDevice('BigoCapillarySampler','Ch1AA1','Chamber Lid','BenthicWaterColumn','Chamber1'),1,3)),...
            'IsDmGt',     	struct('Variable',          {{'Time','Nitrate','Oxygen'}},...
                                   'Data',              cat(2,linspace(0,3600,18000)',randn(18000,1),randn(18000,1)),...
                                   'VariableOrigin',    {{datetime(2020,10,2,15,32,50),0,0}},...
                                   'VariableType',      {{'Independent','Dependent','Dependent'}},...
                                   'MeasuringDevice',   repmat(GearKit.measuringDevice('BigoCapillarySampler','Ch1AA1','Chamber Lid','BenthicWaterColumn','Chamber1'),1,3)),...
            'ImDmGt',     	struct('Variable',          {{'Time','Depth','Nitrate','Oxygen'}},...
                                   'Data',              cat(2,linspace(0,3600,18000)',reshape(repmat(0:17,1000,1),[],1),randn(18000,1),randn(18000,1)),...
                                   'VariableOrigin',    {{datetime(2020,10,2,15,32,50),0,0,0}},...
                                   'VariableType',      {{'Independent','Independent','Dependent','Dependent'}},...
                                   'MeasuringDevice',   repmat(GearKit.measuringDevice('BigoCapillarySampler','Ch1AA1','Chamber Lid','BenthicWaterColumn','Chamber1'),1,4)),...
            'IsDsLt',      	struct('Variable',          {{'Time','Oxygen'}},...
                                   'Data',              cat(2,linspace(0,3600,10000)',randn(10000,1)),...
                                   'VariableOrigin',    {{datetime(2020,10,2,15,32,50),0}},...
                                   'VariableType',      {{'Independent','Dependent'}},...
                                   'MeasuringDevice',   repmat(GearKit.measuringDevice('BigoCapillarySampler','Ch1AA1','Chamber Lid','BenthicWaterColumn','Chamber1'),1,2)),...
            'ImDsLt',     	struct('Variable',          {{'Time','Depth','Oxygen'}},...
                                   'Data',              cat(2,linspace(0,3600,10000)',reshape(repmat(0:9,1000,1),[],1),randn(10000,1)),...
                                   'VariableOrigin',    {{datetime(2020,10,2,15,32,50),0,0}},...
                                   'VariableType',      {{'Independent','Independent','Dependent'}},...
                                   'MeasuringDevice',   repmat(GearKit.measuringDevice('BigoCapillarySampler','Ch1AA1','Chamber Lid','BenthicWaterColumn','Chamber1'),1,3)),...
            'IsDmLt',      	struct('Variable',          {{'Time','Nitrate','Oxygen'}},...
                                   'Data',              cat(2,linspace(0,3600,10000)',randn(10000,1),randn(10000,1)),...
                                   'VariableOrigin',    {{datetime(2020,10,2,15,32,50),0,0}},...
                                   'VariableType',      {{'Independent','Dependent','Dependent'}},...
                                   'MeasuringDevice',   repmat(GearKit.measuringDevice('BigoCapillarySampler','Ch1AA1','Chamber Lid','BenthicWaterColumn','Chamber1'),1,3)),...
            'ImDmLt',    	struct('Variable',          {{'Time','Depth','Nitrate','Oxygen'}},...
                                   'Data',              cat(2,linspace(0,3600,10000)',reshape(repmat(0:9,1000,1),[],1),randn(10000,1),randn(10000,1)),...
                                   'VariableOrigin',    {{datetime(2020,10,2,15,32,50),0,0,0}},...
                                   'VariableType',      {{'Independent','Independent','Dependent','Dependent'}},...
                                   'MeasuringDevice',   repmat(GearKit.measuringDevice('BigoCapillarySampler','Ch1AA1','Chamber Lid','BenthicWaterColumn','Chamber1'),1,4))...
            )
    end

    methods (TestClassSetup)

    end
    methods (TestMethodSetup)
        function createDataPool(testCase,SetupData)
       	% Create a data pool before every test is run

            import DataKit.dataPool

            dp = dataPool();
            dp.addVariable(SetupData.Variable,SetupData.Data,...
                'VariableType',     SetupData.VariableType,...
                'VariableOrigin',   SetupData.VariableOrigin);

            testCase.DataPoolInstance = dp;

            testCase.addTeardown(@delete,testCase.DataPoolInstance)
        end
    end
    methods (TestMethodTeardown)

    end

    methods (Test)
        function testNoInput(testCase)
        % Test addVariable with no inputs

            testCase.verifyError(@() testCase.DataPoolInstance.addVariable(),'MATLAB:narginchk:notEnoughInputs');
        end
        function testEmptyVariableInput(testCase)
        % Test addVariable with empty variable

            testCase.verifyError(@() testCase.DataPoolInstance.addVariable([],1),'Dingi:DataKit:dataPool:addVariable:emptyVariable');
        end
        function testEmptyDataInput(testCase)
        % Test addVariable with empty data

            testCase.verifyError(@() testCase.DataPoolInstance.addVariable('Oxygen',[]),'Dingi:DataKit:dataPool:addVariable:emptyData');
        end
        function testVariableDataSizeMismatch(testCase)
        % Test addVariable with mismatching variable/data shapes

            testCase.verifyError(@() testCase.DataPoolInstance.addVariable('Oxygen',ones(2,5)),'Dingi:DataKit:dataPool:addVariable:variableDataSizeMismatch');
        end
        function testWithDifferingInputCounts(testCase,UsePool,UseUncertainty,UseFlag,UseVariableType,UseVariableCalibrationFunction,UseVariableOrigin,UseVariableMeasuringDevice)

            import DataKit.bitflag
            import DataKit.Metadata.validators.validInfoVariableType
            import GearKit.measuringDevice

            dp = testCase.DataPoolInstance;

            inputArguments = {testCase.ExampleData.Variable,testCase.ExampleData.Data};

            nVariables      = numel(testCase.ExampleData.Variable);

            if UsePool
                inputArguments  = cat(2,inputArguments,'Pool',testCase.ExampleData.Pool);
            end
            if UseUncertainty
                inputArguments  = cat(2,inputArguments,'Uncertainty',testCase.ExampleData.Uncertainty);
                expUncertainty  = testCase.ExampleData.Uncertainty;
            else
                expUncertainty  = zeros(size(testCase.ExampleData.Uncertainty));
            end
            if UseFlag
                inputArguments  = cat(2,inputArguments,'Flag',testCase.ExampleData.Flag);
                expFlag         = bitflag('DataKit.Metadata.validators.validFlag',testCase.ExampleData.Flag);
            else
                expFlag         = bitflag('DataKit.Metadata.validators.validFlag',size(testCase.ExampleData.Flag,1),size(testCase.ExampleData.Flag,2));
            end
            if UseVariableType
                inputArguments  = cat(2,inputArguments,'VariableType',{testCase.ExampleData.VariableType});
                expVariableType = validInfoVariableType(testCase.ExampleData.VariableType);
            else
                expVariableType = repmat(validInfoVariableType.Dependent,1,nVariables);
            end
            if UseVariableCalibrationFunction
                inputArguments                  = cat(2,inputArguments,'VariableCalibrationFunction',{testCase.ExampleData.VariableCalibrationFunction});
                expVariableCalibrationFunction  = testCase.ExampleData.VariableCalibrationFunction;
            else
                expVariableCalibrationFunction  = repmat({'@(x) x'},1,nVariables);
            end
            if UseVariableOrigin
                inputArguments      = cat(2,inputArguments,'VariableOrigin',{testCase.ExampleData.VariableOrigin});
                expVariableOrigin   = testCase.ExampleData.VariableOrigin;
            else
                expVariableOrigin   = repmat({0},1,nVariables);
            end
            if UseVariableMeasuringDevice
                inputArguments  	= cat(2,inputArguments,'VariableMeasuringDevice',{testCase.ExampleData.VariableMeasuringDevice});
                expVariableMeasuringDevice  = testCase.ExampleData.VariableMeasuringDevice;
            else
                expVariableMeasuringDevice  = repmat(measuringDevice(),1,nVariables);
            end

            % Call addVariable
            dp.addVariable(inputArguments{:})

            % Test uncertainty
            testCase.verifyEqual(dp.Uncertainty{2},expUncertainty);

            % Test flags
            testCase.verifyEqual(dp.Flag{2},expFlag);

            % Test variable type
            testCase.verifyEqual(dp.Info(2).VariableType,expVariableType);

            % Test variable calibration function
%             testCase.verifyEqual(dp.Info(2).VariableCalibrationFunction,expVariableCalibrationFunction);

            % Test variable origin
            testCase.verifyEqual(dp.Info(2).VariableOrigin,expVariableOrigin);

            % Test variable origin
            testCase.verifyEqual(dp.Info(2).VariableMeasuringDevice,expVariableMeasuringDevice);
        end
	end
end
