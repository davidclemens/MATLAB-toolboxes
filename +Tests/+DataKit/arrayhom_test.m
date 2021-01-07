classdef arrayhom_test < matlab.unittest.TestCase
    
    % run:
    % tests = matlab.unittest.TestSuite.fromClass(?Tests.DataKit.arrayhom_test);
    % run(tests)
    
    properties
        Inputs
        ExpectedShape
        ExpectedErrorId
        InputInfoCase
    end
    properties (MethodSetupParameter)
        % Creates inputs with a scalar (s), vertical vector (v), horizontal
        % vector (h) or matrix (m) shape.
        InputInfo 	= struct(...
                             ... %
                             'SS',      struct('Size',      {{[1 1],[1 1]}},...
                                               'ErrId',     {''}),...
                             'SV',      struct('Size',      {{[1 1],[9 1]}},...
                                               'ErrId',     {''}),...
                             'SH',      struct('Size',      {{[1 1],[9 1]}},...
                                               'ErrId',     {''}),...
                             'SM',      struct('Size',      {{[1 1],[9 5]}},...
                                               'ErrId',     {''}),...
                             'VV',      struct('Size',      {{[9 1],[9 1]}},...
                                               'ErrId',     {''}),...
                             'HH',      struct('Size',      {{[9 1],[9 1]}},...
                                               'ErrId',     {''}),...
                             'MM',      struct('Size',      {{[9 5],[9 5]}},...
                                               'ErrId',     {''}),...
                             'VVe',     struct('Size',      {{[9 1],[6 1]}},...
                                               'ErrId',     {'DataKit:arrayhom:invalidNumberOfSingletonDimensions'}),...
                             'HHe',     struct('Size',      {{[9 1],[6 1]}},...
                                               'ErrId',     {'DataKit:arrayhom:invalidNumberOfSingletonDimensions'}),...
                             'MMe',     struct('Size',      {{[9 5],[6 2]}},...
                                               'ErrId',     {'DataKit:arrayhom:invalidNumberOfSingletonDimensions'}),...
                             'VMe',     struct('Size',      {{[9 1],[9 5]}},...
                                               'ErrId',     {'DataKit:arrayhom:invalidNumberOfSingletonDimensions'}),...
                             'HMe',     struct('Size',      {{[1 9],[9 5]}},...
                                               'ErrId',     {'DataKit:arrayhom:invalidNumberOfSingletonDimensions'}),...
                             'SSS',     struct('Size',      {{[1 1],[1 1],[1 1]}},...
                                               'ErrId',     {''}),...
                             'SSV',     struct('Size',      {{[1 1],[1 1],[9 1]}},...
                                               'ErrId',     {''}),...
                             'SSH',     struct('Size',      {{[1 1],[1 1],[1 9]}},...
                                               'ErrId',     {''}),...
                             'SVV',     struct('Size',      {{[1 1],[9 1],[9 1]}},...
                                               'ErrId',     {''}),...
                             'SHH',     struct('Size',      {{[1 1],[1 9],[1 9]}},...
                                               'ErrId',     {''}),...
                             'VVV',     struct('Size',      {{[9 1],[9 1],[9 1]}},...
                                               'ErrId',     {''}),...
                             'HHH',     struct('Size',      {{[1 9],[1 9],[1 9]}},...
                                               'ErrId',     {''}),...
                             'SVVe',    struct('Size',      {{[1 1],[9 1],[6 1]}},...
                                               'ErrId',     {'DataKit:arrayhom:invalidNumberOfSingletonDimensions'}),...
                             'SHHe',    struct('Size',      {{[1 1],[1 9],[1 6]}},...
                                               'ErrId',     {'DataKit:arrayhom:invalidNumberOfSingletonDimensions'}),...
                             'VVVe',    struct('Size',      {{[9 1],[9 1],[6 1]}},...
                                               'ErrId',     {'DataKit:arrayhom:invalidNumberOfSingletonDimensions'}),...
                             'HHHe',    struct('Size',      {{[1 9],[1 9],[1 6]}},...
                                               'ErrId',     {'DataKit:arrayhom:invalidNumberOfSingletonDimensions'}),...
                             'MMMe',    struct('Size',      {{[9 5],[9 5],[6 2]}},...
                                               'ErrId',     {'DataKit:arrayhom:invalidNumberOfSingletonDimensions'})...
                             )
    end
    properties (TestParameter)
        
    end
    
    methods (TestClassSetup)
        function addPath(testCase)
            pathOld = path;
            testCase.addTeardown(@path,pathOld)
            addpath('/Users/David/Dropbox/David/Syncing/MATLAB/toolboxes/')
        end
    end
    methods (TestMethodSetup)
        function createInputs(testCase,InputInfo)
       	% Create the inputs before every test is run
            testCase.Inputs = cellfun(@(sz) rand(sz),InputInfo.Size,'un',0);
        end
        function getExpectedValues(testCase,InputInfo)
            testCase.ExpectedErrorId = InputInfo.ErrId;
        end
    end
    methods (TestMethodTeardown)
        
    end
    
    methods (Test)
        function testShape(testCase)
            
            % Catch and verify errors
            if ~isempty(testCase.ExpectedErrorId)
                testCase.verifyError(@() ...
                    DataKit.arrayhom(testCase.Inputs{:}),...
                    testCase.ExpectedErrorId)
                return
            end
            
            
            nInputs = numel(testCase.Inputs);
            
            out         = cell(1,nInputs);
            [out{:}]    = DataKit.arrayhom(testCase.Inputs{:});
            
            dims        = max(cellfun(@ndims,out));
            Sz          = ones(nInputs,dims);
            for dim = 1:dims
                Sz(:,dim) = cellfun(@(in) size(in,dim),out)';
            end
            
            % Subtest 01: verify output shapes are equal
            actual  = all(all(diff(Sz) == 0,1),2);
            testCase.verifyTrue(actual);
        end
	end
end