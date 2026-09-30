%% Generate_Validation_Plots.m
simOut = sim('Diagnostics');
logs = simOut.logsout;

faultStatus = logs.getElement('Fault_Status');

if ~exist('documentation', 'dir')
    mkdir('documentation');
end

% --- Voltage ---
voltage = logs.getElement('Battery_Voltage');
figure;
subplot(2,1,1);
plot(voltage.Values.Time, voltage.Values.Data);
ylabel('Battery Voltage (V)'); grid on;
title('Validation Run: Voltage vs Fault Status');
subplot(2,1,2);
plot(faultStatus.Values.Time, faultStatus.Values.Data, 'r');
ylabel('Fault Code'); xlabel('Time (s)'); grid on;
saveas(gcf, 'documentation/Validation_Voltage_Fault.png');

% --- Temp ---
temp = logs.getElement('Battery_Temp');
figure;
subplot(2,1,1);
plot(temp.Values.Time, temp.Values.Data);
ylabel('Battery Temp (°C)'); grid on;
title('Validation Run: Temp vs Fault Status');
subplot(2,1,2);
plot(faultStatus.Values.Time, faultStatus.Values.Data, 'r');
ylabel('Fault Code'); xlabel('Time (s)'); grid on;
saveas(gcf, 'documentation/Validation_Temp_Fault.png');

% --- SOC ---
soc = logs.getElement('Battery_SOC');
figure;
subplot(2,1,1);
plot(soc.Values.Time, soc.Values.Data);
ylabel('Battery SOC (%)'); grid on;
title('Validation Run: SOC vs Fault Status');
subplot(2,1,2);
plot(faultStatus.Values.Time, faultStatus.Values.Data, 'r');
ylabel('Fault Code'); xlabel('Time (s)'); grid on;
saveas(gcf, 'documentation/Validation_SOC_Fault.png');

% --- Current ---
current = logs.getElement('Battery_Current');
figure;
subplot(2,1,1);
plot(current.Values.Time, current.Values.Data);
ylabel('Battery Current (A)'); grid on;
title('Validation Run: Current vs Fault Status');
subplot(2,1,2);
plot(faultStatus.Values.Time, faultStatus.Values.Data, 'r');
ylabel('Fault Code'); xlabel('Time (s)'); grid on;
saveas(gcf, 'documentation/Validation_Current_Fault.png');

disp('All 4 validation plots saved to documentation/');