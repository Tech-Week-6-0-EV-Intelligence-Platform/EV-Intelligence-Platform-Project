%% Automated_Fault_Test_Suite.m
model = 'Diagnostics';
load_system(model);

testCases = {
    'F001_Overvoltage',  'Battery_Voltage_Mock', 'Bias',          '75', 1, '48';
    'F002_Overtemp',     'Battery_Temp_Mock',    'Bias',          '55', 2, '30';
    'F003_LowSOC',       'Battery_SOC_Mock',     'InitialOutput', '3',  3, '100';
    'F004_Overtorque',   'Motor_Torque_Mock',    'Bias',          '50', 4, '20';
    'F005_CommsLost',    'Comm_OK_Mock',         'Value',         '0',  5, '1';
    'F006_Overcurrent',  'Battery_Current_Mock', 'Bias',          '25', 6, '10';
    'F007_Undervoltage', 'Battery_Voltage_Mock', 'Bias',          '40', 7, '48';
    };

results = {};
logFile = 'fault_log.csv';

for i = 1:size(testCases,1)
    name          = testCases{i,1};
    blockName     = testCases{i,2};
    paramName     = testCases{i,3};
    testValue     = testCases{i,4};
    expectedCode  = testCases{i,5};
    restoreValue  = testCases{i,6};
    blockPath = [model '/' blockName];

    % --- Trigger phase ---
    if exist(logFile, 'file')
        delete(logFile);
    end
    set_param(blockPath, paramName, testValue);
    sim(model);

    triggeredCode = NaN;
    triggerPassed = false;
    if exist(logFile, 'file')
        T = readtable(logFile, 'ReadVariableNames', false);
        triggeredCode = T{end, 2};
        triggerPassed = (triggeredCode == expectedCode);
    end

    % --- Recovery phase (log NOT deleted here, so the new row appends) ---
    set_param(blockPath, paramName, restoreValue);
    sim(model);

    recoveredCode = NaN;
    recoveryPassed = false;
    if exist(logFile, 'file')
        T2 = readtable(logFile, 'ReadVariableNames', false);
        recoveredCode = T2{end, 2};
        recoveryPassed = (recoveredCode == 0);
    end

    results(end+1, :) = {name, expectedCode, triggeredCode, triggerPassed, recoveredCode, recoveryPassed}; %#ok<AGROW>
end

resultsTable = cell2table(results, ...
    'VariableNames', {'TestCase','ExpectedFault','ActualFault','TriggerPass','ActualAfterRecovery','RecoveryPass'});
disp(resultsTable);

if ~exist('documentation', 'dir')
    mkdir('documentation');
end
writetable(resultsTable, 'documentation/Fault_Injection_Results.csv');