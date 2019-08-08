clc

disp('SynGrasp installation')

%parpool; % Starts a parallel pool

addpath(genpath(pwd))


if 1
    a=genpath(pwd);
    b=regexp(a,':','split');

    disp('Add the following lines to your startup.m file')
    
    for i=1:length(b)
        disp(['addpath(' b{i} ')']);
    end
    
end

% Load GWS python module and a shared library
InstallPath = pwd;
Module_path = [pwd, '/grasp_quality_metrics/Grasp_quality/GWSmetric/incremental_gws_lib/lib/1.0/examples'];
SharedLib = [pwd, '/grasp_quality_metrics/Grasp_quality/GWSmetric/incremental_gws_lib/lib/1.0/x86_64'];



if count(py.sys.path, Module_path) == 0
    insert(py.sys.path,int32(0), Module_path);
end

if count(py.sys.path, SharedLib) == 0
    insert(py.sys.path,int32(0), SharedLib);
end

py.importlib.import_module('incremental_gws_calculation'); % Adding library