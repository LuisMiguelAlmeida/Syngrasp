function [Data, Time] = MatchDataThroughTime(bag)
% MatchDataThroughTime(bag)
% Receives a bag cointaining joint angles from one finger and the angle
% from the actuator, then for each joint angle in time, it chooses the
% closest (in time) actuator angle.

    % Bag Joint Angles
    bagsJA = select(bag, 'Topic', 'joint_angles_fingers_topic');
    % Bag with Tactile sensors measures
    bagsActuator = select(bag, 'Topic' , 'vizzy/joint_states');

    % Message Joint Angles
    msgsJA = readMessages(bagsJA,'DataFormat','struct');
    msgsActuator= readMessages(bagsActuator , 'DataFormat', 'struct');

    %Time series
    [tsJa, colsJa] = timeseries(bagsJA);
    [tsActuator, colsActuator]=timeseries(bagsActuator);

    Data = [msgsJA msgsJA];
    Time = [ tsJa.Time tsJa.Time];

    for i=1:length(tsJa.Time)

        % Finds the time index that is more close of the joint angle
        [~ , index] = min(abs(tsActuator.Time-tsJa.Time(i)));
        % Save the data from actuator for that index
        Data{i,2}= msgsActuator{index,1};
        % Save the time where the data from actuator was recorded for that index
        Time(i,2) = tsActuator.Time(index);
        disp(i)
        disp(index)
        disp('----------------------------------')

    end

end

