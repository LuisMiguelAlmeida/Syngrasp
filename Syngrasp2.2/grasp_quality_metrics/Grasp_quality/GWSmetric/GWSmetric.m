function GWS_dic = GWSmetric(hand,obj, method)
    if nargin == 2
        %method = "Inc_minkowski";
        method = "minkowski";
    end

    % We have to add the current MATLAB path to the Python path,
    % so Python can be able to find GWS module.
    if count(py.sys.path,'incremental_gws_lib/lib/1.0/examples') == 0
        insert(py.sys.path,int32(0),'incremental_gws_lib/lib/1.0/examples');
    end
    if count(py.sys.path,'incremental_gws_lib/lib/1.0/x86_64') == 0
        insert(py.sys.path,int32(0),'incremental_gws_lib/lib/1.0/x86_64');
    end
    
    py.importlib.import_module('incremental_gws_calculation'); % Adding library
    
    n_cp = size(hand.cp,2); % Number of contact points
    
    % Passing the methods (of how GWS should be computed) to a python list
    method_list = py.list();
    for i = 1 : length(method)
        method_list.append(py.str(method(i)));
    end
    
    % Define the Actuation Matrix for a given grasp
    A = DefineActuationMatrix(hand);
    
    % Create a contact points list ([cp1Pos, cp1Normal],...,[cpN_Pos, cpN_Normal])
    contacts = py.list();
    for i = 1: n_cp
        array = [hand.cp(1:3,i)', obj.normals(:,i)'];
        
        contacts.append(py.list(array));
    end
    
    contacts = py.numpy.asarray(contacts);
    % Forces that can be applied at each contact point
    maxForce = 3; % In this case the maximum force applied is 3N
    normal_forces = py.list(maxForce *ones(1,n_cp));
    
    % How many edges will have each friction pyramid
    max_mEdges = 3; % Approximating each friction cone by a pyramid of 3 edges
    mEdges_float = max_mEdges *ones(1,n_cp);
    mEdges_int = arrayfun(@(x) py.numpy.int64(x), mEdges_float , 'UniformOutput', false);
    mConeEdges = py.list(mEdges_int);
    
    % Fricition coeffiecients for each contact point
    mu =0.5;
    frictions = py.list(mu*ones(1,n_cp));
    
    % Object center of mass (COM)
    obj_com = py.list(obj.center);
    
    % Dictionary that contains input variables to the python function that 
    % computes the Largest minimum resisted wrench adapted to underactuated
    % hands
    input_dict = py.dict(pyargs("object_com",obj_com,"contacts",contacts,...
        "actuation_matrix", A,"normal_forces", normal_forces, ...
        "cone_discretization_factors",mConeEdges,"frictions", frictions, ...
        "method_list",method_list));
    
    % Calling GWS python function
    GWS_dic = py.gws.GWS(input_dict);
end

