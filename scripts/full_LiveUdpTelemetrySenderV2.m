classdef full_LiveUdpTelemetrySenderV2 < matlab.System
    % Inputs, in order:
    %  1  batterySocPct
    %  2  batteryVoltageV
    %  3  batteryCurrentA
    %  4  batteryTemperatureC
    %  5  motorTorqueCommandNm
    %  6  motorSpeedRpm
    %  7  vehicleSpeedKmh
    %  8  powerLimitKw
    %  9  faultStatus

    properties (Nontunable)
        RemoteHost = '127.0.0.1'
        RemotePort = 9000
        SampleTime = 0.05
    end

    properties (Access = private)
        Udp
        Sequence = 0
    end

    methods (Access = protected)
        function setupImpl(obj)
            obj.Udp = udpport('datagram', 'IPV4');
            obj.Sequence = 0;
        end

        function stepImpl(obj, batterySocPct, batteryVoltageV, ...
                batteryCurrentA, batteryTemperatureC, motorTorqueCommandNm, ...
                motorSpeedRpm, vehicleSpeedKmh, powerLimitKw, faultStatus)

            obj.Sequence = obj.Sequence + 1;

            telemetry.timestamp = char(datetime('now', 'TimeZone', 'UTC'));
            telemetry.sequence = obj.Sequence;
            telemetry.simulation_time_s = obj.Sequence * obj.SampleTime;
            telemetry.battery_soc_pct = double(batterySocPct);
            telemetry.battery_voltage_v = double(batteryVoltageV);
            telemetry.battery_current_a = double(batteryCurrentA);
            telemetry.battery_temperature_c = double(batteryTemperatureC);
            telemetry.motor_torque_command_nm = double(motorTorqueCommandNm);
            telemetry.motor_speed_rpm = double(motorSpeedRpm);
            telemetry.vehicle_speed_kmh = double(vehicleSpeedKmh);
            telemetry.power_limit_kw = double(powerLimitKw);
            telemetry.fault_status = logical(faultStatus);

            packet = uint8(char(jsonencode(telemetry)));
            write(obj.Udp, packet, 'uint8', obj.RemoteHost, obj.RemotePort);
        end

        function sampleTime = getSampleTimeImpl(obj)
            sampleTime = createSampleTime(obj, ...
                'Type', 'Discrete', ...
                'SampleTime', obj.SampleTime);
        end

        function resetImpl(obj)
            obj.Sequence = 0;
        end

        function releaseImpl(obj)
            if ~isempty(obj.Udp)
                clear obj.Udp
            end
        end
    end
end