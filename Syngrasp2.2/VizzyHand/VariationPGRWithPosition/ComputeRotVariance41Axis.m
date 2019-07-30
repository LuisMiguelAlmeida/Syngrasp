% Given an initial grasp, this fuction computes the PGR for a given
% Rot variance in X or Y axis
function axisGrasps = ComputeRotVariance41Axis(obj, rotCoor, maxVar, n_iter, PGRtypes, mode)
    if nargin ==5
        mode = 'auto';
    end
    offset = 3; 
    rot = zeros(3,1);
    
    % Compute PGR for each Rotation variance
    [PGR, Rot] = PGRwithRotVar(obj, obj.center, rot, [rotCoor,'Rot'], maxVar, n_iter, PGRtypes);

     % For each computed PGR type
    for type = PGRtypes
        close;
        f = figure();
        plot(Rot, [PGR.(type)]);
        hold on;
        xlabel([rotCoor,' object rotation']);
        ylabel('PGR Quality metric');
        legend(type);

        switch mode
            case 'man' % manual
                % Choose two points from the plot to compute the PGR variance
                d = datacursormode(f);
                input('Put 2 datatips to limit the samples that will be used to compute the variance\n');
                vals = getCursorInfo(d);
                ind1.(type) = min(vals.DataIndex);
                ind2.(type) = max(vals.DataIndex);

            case 'auto'
                grasp_ini = round(length(Rot)/2);% Initial grasp
                PGR_ini = PGR(grasp_ini).(type); % Initial grasp PGR
                % Minimum PGR where it's considered that the grasp is still stable
                PGR_min = PGR_ini -offset;
                ind1.(type) = grasp_ini;
                while(PGR(ind1.(type)-1).(type) >= PGR_min)
                    ind1.(type) = ind1.(type)-1;
                    if(ind1.(type) == 1) 
                        break;
                    end
                end
                ind2.(type) = grasp_ini; 
                while(PGR(ind2.(type)+1).(type) >= PGR_min)
                    ind2.(type) = ind2.(type)+1;
                    if(ind2.(type) == length(Rot)) 
                        break;
                    end
                end

                % Useless grasp 
                if PGR_min < 0
                    ind1.(type) = grasp_ini;
                    ind2.(type) = grasp_ini;
                end
        end

        axisGrasps.ind1.(type) = ind1.(type);
        axisGrasps.ind2.(type) = ind2.(type);
        axisGrasps.Rot1.(type) = Rot(ind1.(type));
        axisGrasps.Rot2.(type) = Rot(ind2.(type));
        axisGrasps.RotLen.(type) = Rot(ind2.(type))- Rot(ind1.(type)); 
    end
    
    % Saves quality measures
    axisGrasps.PGR = PGR;
    axisGrasps.Rot = Rot;
end
