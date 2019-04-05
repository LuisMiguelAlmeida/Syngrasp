% sort a grasp planner structure from smallest to biggest
function sorted = mySort(tosort)
    
    n = size(tosort.QIndex,2);
        
    for i=1:n     
        for j=1:n-i  
            if tosort.QIndex{j} > tosort.QIndex{j+1}
                temp.r = tosort.Object{j};
                temp.q = tosort.QIndex{j};
                temp.p = tosort.Hands{j};
                tosort.Object{j} = tosort.Object{j+1};
                tosort.QIndex{j} = tosort.QIndex{j+1};
                tosort.Hands{j} = tosort.Hands{j+1};
                tosort.Object{j+1} = temp.r;
                tosort.QIndex{j+1} = temp.q;
                tosort.Hands{j+1} = temp.p;
            end
        end  
    end
    sorted=tosort;  
end
