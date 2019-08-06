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
