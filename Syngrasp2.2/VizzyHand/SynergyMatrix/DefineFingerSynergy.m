function [s] = DefineFingerSynergy(Data,Time, Debug, Njoints, Finger)
% Through the data received from the arguments, the synergy regarding to
% all joints of the index or middle finger are computed
% Arguments: Data - contains joints angles from one finger and its atuator
%            Time - time from when data was recorded
%            Njoints - number of joints on the finger
%            Finger - String that identify the finger 
    for i = 1:Njoints
        if(Debug == 1)
            figure();
        end

        JA = zeros(length(Time(:,1)),1); % Joint Angles
        AA = zeros(length(Time(:,1)),1); % Actuator Angles
        for j = 1:length(Time(:,1))
            JA(j) = Data{j,1}.JointAngles(i).Z;
            AA(j) = Data{j,2}.Position(28);

            if(Debug == 1)
                plot(AA(j),JA(j) ,'rx');
                hold on;
            end
        end

        if(Debug == 1)
            xlabel('Actuator angle (in radians)');
            ylabel(sprintf('Joint Angle nº %d (in radians)',i));
            title(sprintf('Mapping joint angles through actuator angles %s', Finger));
            legend(sprintf('%s', Finger));
        end
        
        while (1)
            mode = input('Enter "a" for automatically compute the linear regression coeffiecients, or "m" to do it manually\n', 's');
            if(strcmp(mode, 'a') == 1 || strcmp(mode, 'm'))
                break;
            else
                disp('Wrong option, please insert "a" or "m"');
            end
        end
    
        switch mode
            case 'a'
                coeffs = polyfit(AA, JA, 1);

                if(Debug == 1) % Plot the regression line 
                    x_ja = 0:0.01:pi;
                    plot(x_ja,coeffs(1)*x_ja+coeffs(2));
                    disp('---\n');
                    disp(coeffs(2));
                end
                sm{1}.xmin = 0;
                sm{1}.ymin = min(coeffs(2),  coeffs(1)*pi+coeffs(2));
                sm{1}.xmax = pi;
                sm{1}.ymax = max(coeffs(2),  coeffs(1)*pi+coeffs(2));
                sm{1}.slope =coeffs(1);
                sm{1}.b =coeffs(2);
                % Synergy equal to slope of the regression s = m (y=mx+b)
            case 'm'
                % Two clicks on two different followed points to define a line
                [x,y] = ginput; %
                
                for j = 1:length(x)/2
                    indx1 = find(abs(AA-x((j-1)*2+1))<0.05);
                    indx2 = find(abs(AA-x((j-1)*2+2))<0.05);
                    
                    sm{1}.xmin(j) = min(x((j-1)*2+1),x((j-1)*2+2));
                    sm{1}.ymin(j) = min(y((j-1)*2+1),y((j-1)*2+2));
                    sm{1}.xmax(j) = max(x((j-1)*2+1),x((j-1)*2+2));
                    sm{1}.ymax(j) = max(y((j-1)*2+1),y((j-1)*2+2));
                    coeffs = polyfit(AA(indx1(1):indx2(1)),JA(indx1(1):indx2(1)), 1);
                    sm{1}.slope(j) = coeffs(1);
                    sm{1}.b(j) = coeffs(2);
                    b = coeffs(2); % computes b (y = mx+b)
                    hold on;
                    % Interpolates the rest of the plot
                    if(j == 1) 
                        sm{1}.xmin(j) = 0; % stretches the first line to begin on the origin
                        sm{1}.ymin(j) = min(b,y((j-1)*2+2));
                        plot(linspace(0,x((j-1)*2+2), 1000), linspace(b , coeffs(1)*x((j-1)*2+2)+b , 1000));
                    else if(j == length(x)/2) 
                        sm{1}.xmax(j) = pi; % stretches the first line to end in max angle of actuator
                        sm{1}.ymax(j) = max(y((j-1)*2+1), sm{1}.slope(j)*x((j-1)*2+2)+b );
                        plot(linspace(x((j-1)*2+1), pi, 1000), linspace(coeffs(1)*x((j-1)*2+1)+b, sm{1}.slope(j)*pi+b, 1000));
                    else
                        plot(linspace(x((j-1)*2+1), x((j-1)*2+2), 1000), linspace(coeffs(1)*x((j-1)*2+1)+b, coeffs(1)*x((j-1)*2+2)+b, 1000));
                        end
                   end

                end
        end
        s(i) = sm;
        
    end
end

