classdef (SharedTestFixtures = { ...
            matlab.unittest.fixtures.PathFixture(subsref(strsplit(mfilename('fullpath'),'/+'),substruct('{}',{':'})))
        }) setBit_test < matlab.unittest.TestCase
    

% run and stop if verification fails:
%     tests     = matlab.unittest.TestSuite.fromClass(?Tests.DataKit.Metadata.sparseBitmask.setBit_test);
%     runner    = matlab.unittest.TestRunner.withTextOutput;
%     runner.addPlugin(matlab.unittest.plugins.StopOnFailuresPlugin);
%     runner.run(tests)
% run :
%     tests     = matlab.unittest.TestSuite.fromClass(?Tests.DataKit.Metadata.sparseBitmask.setBit_test);
%     run(tests)
    
    properties
        Bitmask
        Sz          = [100 10]
    end
    properties (MethodSetupParameter)
        
        
    end
    properties (TestParameter)
        % Input parameters to test for the following input schemes:
        %     obj = setBit(obj,i,j,bit,highlow)
        %
        % The naming convention for each test case is
        %     {inputParameter}_{shapeInput}
        % or
        %     {inputParameter}_{shapeInput}_{inputValueMagnitude}
        % or
        %     {inputParameter}_{shapeInput}_{specialCase}
        % or
        %     {inputParameter}_{shapeInput}_{highlowtype}
        % where
        %     shapeInput: S (scalar), V (vertical vector), H (horizontal
        %       vector), M1 (matrix long), M2 (matrix wide)
        %     inputValueMagnitude: U (unit), S (small), L (large)
        %     specialCase: E (index exceeding the size limit)
        %     highlowtype: high (only 1's), low (only 0's), mixed (both 1's
        %       and 0's)
        
        i	= struct(...
                'i_S',              5,...
                'i_V',              [3 9 13 9 1]',...
                'i_H',              [3 9 13 9 1],...
                'i_M1',             [3 9 13 9 1].*[3 1 6 1 3 7 2]',...
                'i_M2',             [3 9 13 9 1]'.*[3 1 6 1 3 7 2],...
                'i_S_E',            101 ...
                )
        j	= struct(...
                'j_S',              3,...
                'j_V',              [8 7 1 3 7]',...
                'j_H',              [8 7 1 3 7],...
                'j_M1',             [9 3 9 3 10;4 2 3 7 5;4 9 6 6 10;8 8 4 6 1;1 6 8 10 2;6 5 1 4 2;8 4 6 2 3],...
                'j_M2',             [9 3 9 3 10;4 2 3 7 5;4 9 6 6 10;8 8 4 6 1;1 6 8 10 2;6 5 1 4 2;8 4 6 2 3]',...
                'j_S_E',            11 ...
                )
        bit	= struct(...
                'bit_S_S',          6,...
                'bit_S_L',          50,...
                'bit_V_U',          ones(5,1),...
                'bit_V_S',          [4 5 5 9 3]',...
                'bit_V_L',          [52 43 50 49 45]',...
                'bit_H_U',          ones(1,5),...
                'bit_H_S',          [4 5 5 9 3],...
                'bit_H_L',          [52 43 50 49 45],...
                'bit_M1_U',         ones(7,5),...
                'bit_M1_S',         [9 3 9 3 10;4 2 3 7 5;4 9 6 6 10;8 8 4 6 1;1 6 8 10 2;6 5 1 4 2;8 4 6 2 3],...
                'bit_M1_L',         [43 29 42 2 35;48 50 8 45 9;7 51 22 49 37;48 9 48 36 2;33 51 42 40 15;6 50 50 39 3;15 26 35 21 6],...
                'bit_M2_U',         ones(5,7),...
                'bit_M2_S',         [9 3 9 3 10;4 2 3 7 5;4 9 6 6 10;8 8 4 6 1;1 6 8 10 2;6 5 1 4 2;8 4 6 2 3]',...
                'bit_M2_L',         [43 29 42 2 35;48 50 8 45 9;7 51 22 49 37;48 9 48 36 2;33 51 42 40 15;6 50 50 39 3;15 26 35 21 6]'...
                )
        hl	= struct(...
                'hl_S_low',      	0,...
                'hl_S_high',     	1,...
                'hl_V_low',      	zeros(5,1),...
                'hl_V_high',      	ones(5,1),...
                'hl_V_mixed',     	[1 0 0 1 1]',...
                'hl_H_low',      	zeros(1,5),...
                'hl_H_high',      	ones(1,5),...
                'hl_H_mixed',     	[1 0 0 1 1],...
                'hl_M1_low',      	zeros(7,5),...
                'hl_M1_high',       ones(7,5),...
                'hl_M1_mixed',      [1 0 1 0 0;0 0 1 1 0;0 1 0 1 1;0 0 0 1 0;0 0 0 1 0;1 1 0 1 0;0 1 1 0 1],...
                'hl_M2_low',       	zeros(5,7),...
                'hl_M2_high',       ones(5,7),...
                'hl_M2_mixed',      [1 0 1 0 0;0 0 1 1 0;0 1 0 1 1;0 0 0 1 0;0 0 0 1 0;1 1 0 1 0;0 1 1 0 1]'...
                )
    end
    
    methods (TestClassSetup)
        
    end
    methods (TestMethodSetup)
        function createBitmaskA(testCase)
            import DataKit.Metadata.sparseBitmask
            
            m   = testCase.Sz(1);
            n   = testCase.Sz(2);
            
            testCase.Bitmask = sparseBitmask([10 3 4 4 2],[3 4 5 5 1],[20 3 5 52 9],m,n);
        end       
    end
    methods (TestMethodTeardown)
        
    end
    
    methods (Test)
        function testInvalidBit(testCase)
            testCase.verifyError(@() ...
                setBit(testCase.Bitmask,1,1,53,1),...
                'DataKit:Metadata:sparseBitmask:setBit:bitPositionExceedsLimit')
            testCase.verifyError(@() ...
                setBit(testCase.Bitmask,1,1,0,1),...
                'DataKit:Metadata:sparseBitmask:setBit:bitPositionExceedsLimit')
        end
        function testIndexExceedsSize(testCase)
            testCase.verifyWarning(@() ...
                setBit(testCase.Bitmask,testCase.Sz(1) + 1,1,1,1),...
                'DataKit:Metadata:sparseBitmask:setBit:subscriptsExceedBitmaskSize')
        end
        function testSetBit(testCase,i,j,bit,hl)
            import matlab.unittest.fixtures.SuppressedWarningsFixture
            import DataKit.Metadata.sparseBitmask
            import DataKit.arrayhom
            
            try
                [i2,j2,bit2,hl2]	= arrayhom(i,j,bit,hl);
            catch ME
                switch ME.identifier
                    case 'DataKit:arrayhom:invalidNumberOfSingletonDimensions'
                        return
                    otherwise
                        rethrow(ME)
                end
            end
            
            szOld               = testCase.Sz;
            szNew               = max([testCase.Sz;max(i2),max(j2)]);
            dsz                 = diff(cat(1,szOld,szNew));
            if any(dsz > 0)
                testCase.applyFixture(...
                    SuppressedWarningsFixture('DataKit:Metadata:sparseBitmask:setBit:subscriptsExceedBitmaskSize'));
            end
            
            % get actual value
            BitmaskA	= testCase.Bitmask;
            act         = setBit(BitmaskA,i,j,bit,hl);
            act       	= act.Bitmask;
            
            % determine expected bitmask
            exp        	= BitmaskA.Bitmask; % start with existing bitmask
            exp       	= cat(1,exp,zeros(dsz(1),szOld(2)));
            exp       	= cat(2,exp,zeros(szNew(1),dsz(2)));
            
            ind                 = sub2ind(szNew,i2,j2); % indices to the bitmasks that will change
            [uBits,~,uBitsInd]  = unique(cat(2,ind,bit2),'rows'); % get unique index-bit touples
            for ii = 1:size(uBits,1)
                mask                = uBitsInd == ii;
                highlow             = max(hl2(mask));   % if the same bit is addressed multiple times set it to the max of the corresponding highlow values.
                exp(uBits(ii,1))	= bitset(full(exp(uBits(ii,1))),uBits(ii,2),highlow);
            end
            
            testCase.verifyEqual(act,exp)
        end
	end
end