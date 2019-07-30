% Given an initial grasp, this fuction computes the PGR for a given
% Pos variance in X or Y axis
function axisGrasps = ComputePosVariance41Axis(obj, posCoor, maxVar, n_iter, PGRtypes, mode)
    if nargin ==5
        mode = 'auto';
    end
    offset = 3; 
   
    
    % Compute PGR for each position variance
    [PGR, Pos] = PGRwithPosVar(obj, obj.center, [0, 0, 0], [posCoor,'Pos'], maxVar, n_iter,PGRtypes);

    
    % For each computed PGR type
    for type = PGRtypes
        close;
        f = figure();
        plot(Pos, [PGR.(type)]);
        hold on;
        xlabel([posCoor,' object position']);
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
                grasp_ini = round(length(Pos)/2);% Initial grasp
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
                    if(ind2.(type) == length(Pos)) 
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
        axisGrasps.Pos1.(type) = Pos(ind1.(type));
        axisGrasps.Pos2.(type) = Pos(ind2.(type));
        axisGrasps.PosLen.(type) = Pos(ind2.(type))- Pos(ind1.(type)); 
    end
    
    %plot(Pos(ind1.(type)), PGR(ind1.(type)).BF, 'rx'); hold on;
    %plot(Pos(ind2.(type)), PGR(ind2.(type)).BF, 'rx');
    % Saves quality measures
    axisGrasps.PGR = PGR;
    axisGrasps.Pos = Pos;


end
