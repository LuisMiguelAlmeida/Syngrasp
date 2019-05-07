%    SGSyngrasp_GUI
%    Graphic User Interface for SynGrasp (Synergy Grasping Toolbox)
%    Copyright (c) 2013 J. Acquarelli,D. Conti,G. Gioioso
%
%    This file is part of SynGrasp (Synergy Grasping Toolbox).
%
%    SynGrasp is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    SynGrasp is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with SynGrasp. If not, see <http://www.gnu.org/licenses/>.


function varargout = Syngrasp_GUI(varargin)
% SYNGRASP_GUI MATLAB code for Syngrasp_GUI.fig
%      SYNGRASP_GUI, by itself, creates a new SYNGRASP_GUI or raises the existing
%      singleton*.
%
%      H = SYNGRASP_GUI returns the handle to a new SYNGRASP_GUI or the handle to
%      the existing singleton*.
%
%      SYNGRASP_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYNGRASP_GUI.M with the given input arguments.
%
%      SYNGRASP_GUI('Property','Value',...) creates a new SYNGRASP_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Syngrasp_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Syngrasp_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Syngrasp_GUI

% Last Modified by GUIDE v2.5 03-May-2019 17:40:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Syngrasp_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @Syngrasp_GUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Syngrasp_GUI is made visible.
function Syngrasp_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Syngrasp_GUI (see VARARGIN)

%clear screen
clc

% Choose default command line output for Syngrasp_GUI
handles.output = hObject;
% Update handles structure
guidata(hObject,handles);
evalin('base','clear all');

% Initialize variable for GUI
handles=SGGUIinitialize(handles);

% plot empty figure
plot3(0,0,0)
axis 'equal'
xlabel('x')
ylabel('y')
zlabel('z')
grid on

guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = Syngrasp_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FUNCTIONS                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% EXPORT/LOAD/NEW
function export2ws_ClickedCallback(hObject, eventdata, handles)
try
    assignin('base','hand',handles.hand);
    h = msgbox('Hand saved in workspace');
catch
    disp('No hand loaded, nothing to export!');
    h = msgbox('No hand loaded, nothing to export!');
    evalin('base','clear hand');
end

try
    assignin('base','obj',handles.obj);
    h = msgbox('Object saved in workspace');
catch
    disp('No object loaded, nothing to export!');
    h = msgbox('No object loaded, nothing to export!');
    evalin('base','clear obj');
end
function select_hand_Callback(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% New hand from workspace. Load a user hand.                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
contents = cellstr(get(hObject,'String')) ;
hand_selected=contents{get(hObject,'Value')};
if(strcmp(hand_selected,'None'))
    set(findall(handles.hand_x, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.hand_y, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.hand_z, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.hand_rotx, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.hand_roty, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.hand_rotz, '-property', 'enable'), 'enable', 'off');
    %set(findall(handles.button_place_hand, '-property', 'enable'), 'enable', 'off');
else
    set(findall(handles.hand_x, '-property', 'enable'), 'enable', 'on');
    set(findall(handles.hand_y, '-property', 'enable'), 'enable', 'on');
    set(findall(handles.hand_z, '-property', 'enable'), 'enable', 'on');
    set(findall(handles.hand_rotx, '-property', 'enable'), 'enable', 'on');
    set(findall(handles.hand_roty, '-property', 'enable'), 'enable', 'on');
    set(findall(handles.hand_rotz, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.button_place_hand, '-property', 'enable'), 'enable', 'on');

end

if(strcmp(hand_selected,'User Defined Hand (max 25 joints)')==0)
    return
end

lst = evalin('base','who(''*hand*'',''base'')');
if isempty(lst)
    disp('No match found for worskspace variable')
    disp('which its name contain the string ''hand''')
    set(handles.select_object,'Value',1);
    return
end
[s,v] = listdlg('PromptString','Select hand:','ListSize',[250,100],...
                'Name','Select hand model from workspace',...
                'SelectionMode','single','InitialValue',1,'ListString',lst);
if v==1
    set(handles.select_hand,'Value',6);
    handles.hand_wvar=s;
    guidata(handles.output,handles);

end


%%%%% INITIALIZE/RESET
function handles = SGGUIinitialize (handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inizialize all variable for GUI interface and put in all to handles     %
% structure, hide edit text and sliderbar, reset edit text and sliderbar  %                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Initialize HAND - Position,Rotation
handles.hand_data.type='None';
handles.hand_data.x=0;
handles.hand_data.y=0;
handles.hand_data.z=0;
handles.hand_data.rotx=0;
handles.hand_data.roty=0;
handles.hand_data.rotz=0;

set(handles.hand_x,'String',0);
set(handles.hand_y,'String',0);
set(handles.hand_z,'String',0);
set(handles.hand_rotx,'String',0);
set(handles.hand_roty,'String',0);
set(handles.hand_rotz,'String',0);

%Initialize OBJECT - Position,Rotation,Parameters
handles.obj_data.type='None';
handles.obj_data.x=0;
handles.obj_data.y=0;
handles.obj_data.z=0;
handles.obj_data.rotx=0;
handles.obj_data.roty=0;
handles.obj_data.rotz=0;
handles.obj_data.rad=0;
handles.obj_data.height=0;
handles.obj_data.side=0;

set(handles.object_x,'String',0);
set(handles.object_y,'String',0);
set(handles.object_z,'String',0);
set(handles.object_rotx,'String',0);
set(handles.object_roty,'String',0);
set(handles.object_rotz,'String',0);


%Hide slider and edit text
for i = 1:5
    for j=0:4
        if j<4
            eval([ 'set(handles.finger_', num2str(i), '_', num2str(j) ,',''Visible'',''off'');'])
            eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''Visible'',''off'');'])
        else
            index_plus=5-(j+1-i);
            eval([ 'set(handles.edit_plus_', num2str(index_plus) ,',''Visible'',''off'');'])
            eval([ 'set(handles.slider_plus_', num2str(index_plus) ,',''Visible'',''off'');'])            
        end
    end
end

%Hide and disable panel
%%set(handles.mode_panel,'Visible','off');
set(handles.control_hand,'Visible','off');
        set(findall(handles.hand_x, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.hand_y, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.hand_z, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.hand_rotx, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.hand_roty, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.hand_rotz, '-property', 'enable'), 'enable', 'off');
                %set(findall(handles.button_place_hand, '-property', 'enable'), 'enable', 'off');
set(findall(handles.uipanel2, '-property', 'enable'), 'enable', 'off');
set(findall(handles.grasp_panel, '-property', 'enable'), 'enable', 'off');


%Inizialize some variable
% handles.q=zeros(20,1);
handles.z=zeros(1,20);
handles.step_degree=5;
handles.radio='radio_joint';
handles.radio_grasp='radio_closeall';
handles.grasp_quality_panel='mev';
handles.grasp_numbers=1;
set(handles.grasp_quality,'String','0');


%Set default hand and default object
set(handles.select_hand,'Value',1);
set(handles.select_object,'Value',1);
set(handles.select_method,'Value',1);



guidata(handles.output,handles);
function button_resethand_Callback(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reset hand parameters after grasp                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(isfield(handles,'obj'))
    handles=rmfield(handles,'obj');
end
reset_hand(handles);
reset_object(handles);
selectHand(handles.select_hand,eventdata,handles);

%%%%% PLOTTING
% Plot Hand
function SGGUIplothand(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the different type of hands before rotostralation or finger        %
% movements.                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
contents = cellstr(get(handles.select_hand,'String'));
hand_selected=contents{get(handles.select_hand,'Value')};

x=handles.hand_data.x;
y=handles.hand_data.y;
z=handles.hand_data.z;
theta=handles.hand_data.rotx;
phi=handles.hand_data.roty;
psi=handles.hand_data.rotz;
F=handles.hand.F;

[az, el]=view;
handles.hand.F = SGhand_rototraslation(F,x,y,z,theta,phi,psi);
handles.hand = SGmoveHand(handles.hand,handles.hand.q);
SGplotHand(handles.hand);
view(az,el);
colormap([1 0 0])
freezeColors
axis 'equal'
xlabel('x')
ylabel('y')
zlabel('z')
grid on
guidata(handles.output,handles);
% Plot Object
function SGGUIplotobject(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the different type of objects before rotostralation or after       %
% changing parameters                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
contents = cellstr(get(handles.select_object,'String')) ;
obj_selected=contents{get(handles.select_object,'Value')};

contents = cellstr(get(handles.select_hand,'String')) ;
hand_selected=contents{get(handles.select_hand,'Value')};

x=handles.obj_data.x;
y=handles.obj_data.y;
z=handles.obj_data.z;
theta=handles.obj_data.rotx;
phi=handles.obj_data.roty;
psi=handles.obj_data.rotz;
rad=handles.obj_data.rad;
height=handles.obj_data.height;
side=handles.obj_data.side;

set(handles.object_x,'String',num2str(x));
set(handles.object_y,'String',num2str(y));
set(handles.object_z,'String',num2str(z));
set(handles.object_rotx,'String',num2str(rad2deg(theta)));
set(handles.object_roty,'String',num2str(rad2deg(phi)));
set(handles.object_rotz,'String',num2str(rad2deg(psi)));
set(handles.obj_rad,'String',num2str(rad));
set(handles.obj_height,'String',num2str(height));
set(handles.obj_side,'String',num2str(side));

[az, el]=view;
if(isfield(handles,'obj'))
    SGplotSolid(handles.obj)
end
view(az,el);
colormap([0 0 1])
freezeColors
axis 'equal'
xlabel('x')
ylabel('y')
zlabel('z')
axis 'equal'
grid on
guidata(handles.output,handles);
% Rototraslation
function F=SGhand_rototraslation(F,x,y,z,theta,phi,psi)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rototrasl the hand, finger by finger                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(F)
    F{i}.base=SGGUIrotate(F{i}.base,theta,phi,psi);
    F{i}.base=F{i}.base+[zeros(3) [x y z]';[0 0 0 0]];
end
function H=SGobj_rototraslation(H,x,y,z,theta,phi,psi)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rototrasl the object                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H=SGGUIrotate(H,theta,phi,psi);
H=H+[zeros(3) [x y z]';[0 0 0 0]];
% Rotate
function base=SGGUIrotate(base,theta,phi,psi)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rotations                                                  %
%                                                                         %
% J.Acquarelli, D.Conti                                                   %
% December 2012                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
base=[SGrotx(theta) [0 0 0]'; [0 0 0 1]]*[SGroty(phi) [0 0 0]'; [0 0 0 1]]*[SGrotz(psi) [0 0 0]'; [0 0 0 1]]*base;

%%%%% GRASPING
function grasp_button_Callback(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Star grasp closehand
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp (handles.hand.type)
switch handles.hand.type
    case 'Paradigmatic'
        active=[0 1 1 0 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 ]';
    case '3Fingered'
        active=[1 1 0 1 1 0 1 1]';
    case 'DLR'
        active=[0 1 1 0 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 ]';
    case 'Modular'
        active= [1 1 1 1 1 1 1 1 1];
    case 'VizzyHand'
        active= [1 1 1 1 1 1 1 1 1 1 1 1];
        
end

enableGUI(handles,false)
handles.obj
[handles.hand,handles.obj] = SGcloseHand(handles.hand,handles.obj,active,0.1);   
handles.obj
guidata(handles.output,handles);
%refresh print
SGGUIplothand(handles);
handles.obj
SGGUIplotobject (handles);
updateAll(handles)

set(findall(handles.uipanel1, '-property', 'enable'), 'enable', 'on');
set(findall(handles.export3, '-property', 'enable'), 'enable', 'on');
set(findall(handles.uipanel3, '-property', 'enable'), 'enable', 'on');
set(findall(handles.uipanel2, '-property', 'enable'), 'enable', 'on');
set(findall(handles.grasp_panel, '-property', 'enable'), 'enable', 'on');
if(~isfield(handles.obj,'G'))
    set(findall(handles.button_quality, '-property', 'enable'), 'enable','off');
end

if (isempty(handles.hand.J))
    set(findall(handles.uipanel14, '-property', 'enable'), 'enable', 'off');
else
    set(findall(handles.uipanel14, '-property', 'enable'), 'enable', 'on');
end

%%%% PLACING
function button_place_obj_Callback(hObject, eventdata, handles)
function button_quality_Callback(hObject, eventdata, handles)
% hObject    handle to button_quality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hand=handles.hand;
object=handles.obj;
switch handles.grasp_quality_panel
        case 'mev'
            Quality = SGmanipEllipsoidVolume(object.G,hand.J);
        case 'gii'
            Quality = SGgraspIsotropyIndex(object.G);
        case 'msvg'
            Quality = SGminSVG(object.G);
        case 'dtsc'
            Quality = SGdistSingularConfiguration(object.G,hand.J);
        case 'uot'
            Quality = SGunifTransf(object.G,hand.J);
        otherwise
            error 'bad quality measure type'
end
set(handles.grasp_quality,'String',num2str(Quality));
guidata(handles.output,handles)

function button_place_object_Callback(hObject, eventdata, handles)
% hObject    handle to button_place_object (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select object and set up structure with default parameters              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
contents = cellstr(get(handles.select_object,'String')) ;
obj_selected=contents{get(handles.select_object,'Value')};

contents = cellstr(get(handles.select_hand,'String')) ;
hand_selected=contents{get(handles.select_hand,'Value')};

axis 'equal'
H=eye(4);       
res_sphere=50;
res_cylinder=100;
disp(obj_selected)

if(strcmp(obj_selected,'None')==0)
        x=str2double(get(handles.object_x,'String'));
        y=str2double(get(handles.object_y,'String'));
        z=str2double(get(handles.object_z,'String'));
        theta=str2double(get(handles.object_rotx,'String'));
        phi=str2double(get(handles.object_roty,'String'));
        psi=str2double(get(handles.object_rotz,'String'));
        rad=str2double(get(handles.obj_rad,'String'));
        height=str2double(get(handles.obj_height,'String'));
        side=str2double(get(handles.obj_side,'String'));

        handles.obj_data.x=x;
        handles.obj_data.y=y;
        handles.obj_data.z=z;
        handles.obj_data.rotx=theta;
        handles.obj_data.roty=phi;
        handles.obj_data.rotz=psi;
        handles.obj_data.rad=rad;
        handles.obj_data.height=height;
        handles.obj_data.side=side;
        switch obj_selected
            case 'None'
                handles.obj_data.type='None';
            case 'Sphere'
                handles.obj_data.type='Sphere';
                H=SGobj_rototraslation(H,x,y,z,theta,phi,psi);
                handles.obj=SGsphere(H,rad,res_sphere);
            case 'Cylinder'
                handles.obj_data.type='Cylinder';   
                H=SGobj_rototraslation(H,x,y,z,theta,phi,psi);
                handles.obj=SGcylinder(H,height,rad,res_cylinder);
            case 'Cube'
                handles.obj_data.type='Cube';
                H=SGobj_rototraslation(H,x,y,z,theta,phi,psi);
                handles.obj=SGcube(H,side,side,side);
        end

        contact = [];
        for i=1:handles.hand.n
            c=SGcontactDetection(handles.hand,handles.obj,i);
            contact = [contact; c];
        end
        if isempty(contact)
            hold off
            SGGUIplothand(handles)
            hold on
            SGGUIplotobject(handles);
            hold off
            set(findall(handles.grasp_panel, '-property', 'enable'), 'enable', 'on');
            if(~isfield(handles.obj,'G'))
                set(findall(handles.button_quality, '-property', 'enable'), 'enable','off');
            end

        else
            disp('Cannot place the object in the desired position');
            h = msgbox('Cannot place the object in the desired position','WARNING','warn');
            return
        end
else
    reset_object(handles);
    set(findall(handles.grasp_panel, '-property', 'enable'), 'enable', 'off');
    SGGUIplothand(handles);
end
guidata(handles.output,handles)
function button_place_hand_Callback(hObject, eventdata, handles)
% hObject    handle to button_place_hand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        if(~isfield(handles,'hand') || ~isfield(handles,'obj'))
            selectHand(handles.select_hand,eventdata,handles);
            return
        end
        contact = [];
        for i=1:handles.hand.n
            c=SGcontactDetection(handles.hand,handles.obj,i);
            contact = [contact; c];
        end
        if isempty(contact)
            selectHand(handles.select_hand,eventdata,handles);    
        else
            disp('Cannot place the hand in the desired position');
            h = msgbox('Cannot place the hand in the desired position','WARNING','warn');
            return
        end

        
function grasp_edit_z_Callback(hObject, eventdata, handles)
function grasp_edit_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grasp_edit_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function mode_policy_SelectionChangeFcn(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select grasp grasp_quality_panel                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.radio_grasp=get(eventdata.NewValue,'tag');
set(findall(handles.grasp_edit_z, '-property', 'enable'), 'enable', 'off');

guidata(handles.output,handles);

function select_method_Callback(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select quality grasp_quality_panel                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
contents = cellstr(get(handles.select_object,'String')) ;
method_selected=contents{get(handles.select_object,'Value')};

switch method_selected
    case 'Manipolability Ellisoid Volume'
        handles.grasp_quality_panel='mev';
    case 'Grasp Isotropy Index'
        handles.grasp_quality_panel='gii';
    case 'Min SVG'
        handles.grasp_quality_panel='msvg';
    case 'Dist Singular Configuration'
        handles.grasp_quality_panel='dtsc';
    case 'Unif Transf'
        handles.grasp_quality_panel='uot';
end
guidata(handles.output,handles);
function select_method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function grasp_quality_Callback(hObject, eventdata, handles)
function grasp_quality_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grasp_quality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Select joint by joint control or synergies control
function control_hand_CreateFcn(hObject, eventdata, handles)
%%do nothing
function control_hand_SelectionChangeFcn(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select joint by joint/ Synerigies control grasp_quality_panel                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

contents = cellstr(get(handles.select_hand,'String'));
hand_selected=contents{get(handles.select_hand,'Value')};
handles.radio=get(eventdata.NewValue,'tag');
[m,n]=size(handles.hand.S);
% set the right value for slider [min,max,slider_step] when switch to
% synergies/joint mode
step_deg=handles.step_degree/(2*180);
step_rad=deg2rad(handles.step_degree)/(2*pi);
%enableGUI(handles,false);

switch handles.radio
    case 'radio_joint'
        hold off
                SGGUIplothand(handles);
                hold on
                SGGUIplotobject(handles); 
    case 'radio_synergies'
                        handles.hand.q=handles.hand.qm;

                hold off
                SGGUIplothand(handles);
                hold on

                if isfield(handles,'obj')
                    SGGUIplotobject(handles);
                end
end
for i = 1:5
    for j=0:3
        switch handles.radio
            case 'radio_joint'
                eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''Min'',-3.14);'])
                eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''Max'',3.14);'])
                eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''SliderStep'',[step_rad,0.1]);'])
                              
            case 'radio_synergies'

                eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''Min'',-2);'])
                eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''Max'',2);'])
                eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''SliderStep'',[step_rad,0.1]);'])
                
        end
    end
end


Q_size=handles.hand.m;
switch handles.radio
    case 'radio_joint'
        disp('Direct Joint Control Mode');
        % display and update all the field relative at each joint
        for i = 1:5
            for j=0:4
                q_index=(j+1)+(i-1)*4;           
                if j<4
                  if q_index<=Q_size
                    eval([ 'set(handles.finger_', num2str(i), '_', num2str(j) ,',''String'',handles.hand.q(q_index));'])
                    eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''Value'',handles.hand.q(q_index));'])

                        
                        eval([ 'set(handles.finger_', num2str(i), '_', num2str(j) ,',''Visible'',''on'');'])
                        eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''Visible'',''on'');'])
                    end
                else
                  if q_index<=Q_size     
                    eval([ 'set(handles.edit_plus_', num2str(i) ,',''String'',handles.hand.q(q_index));'])
                    eval([ 'set(handles.slider_plus_', num2str(i) ,',''Value'',handles.hand.q(q_index));'])
                    

                        eval([ 'set(handles.edit_plus_', num2str(i) ,',''Visible'',''on'');'])
                        eval([ 'set(handles.slider_plus_', num2str(i) ,',''Visible'',''on'');'])
                    end
                end
                
            end
        end
    case 'radio_synergies'
        disp('Synergies Joint Control Mode');
        handles.qold=handles.hand.q;
        handles.z=zeros(1,n);
        for i = 1:5
            for j=0:4
                z_index=(j+1)+(i-1)*4;
                if j<4
                    if z_index>n
                        eval([ 'set(handles.finger_', num2str(i), '_', num2str(j) ,',''Visible'',''off'');'])
                        eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''Visible'',''off'');'])
                    else
                        eval([ 'set(handles.finger_', num2str(i), '_', num2str(j) ,',''String'',''0'');'])
                        eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''Value'',0);'])
                    end
                else
                    plus_index=20+i;
                    if plus_index>n
                        eval([ 'set(handles.edit_plus_', num2str(i) ,',''Visible'',''off'');'])
                        eval([ 'set(handles.slider_plus_', num2str(i) ,',''Visible'',''off'');'])
                    else
                        eval([ 'set(handles.edit_plus_', num2str(i) ,',''String'',''0'');'])
                        eval([ 'set(handles.slider_plus_', num2str(i) ,',''Value'',0);'])
                    end
                end
            end
        end
end

%enableGUI(handles,true);
guidata(hObject,handles);

%%%%% RESET/DISABLE
% Enable/Disable all GUI
function enableGUI(handles,onoff)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Enable/Disable al GUI                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if onoff
    set(findall(handles.grasp_panel, '-property', 'enable'), 'enable', 'on');
    if(~isfield(handles,'obj'))
        set(findall(handles.button_quality, '-property', 'enable'), 'enable','off');
    elseif(~isfield(handles.obj,'G'))
        set(findall(handles.button_quality, '-property', 'enable'), 'enable','off');
    end
    set(findall(handles.uipanel1, '-property', 'enable'), 'enable', 'on');


   
         set(findall(handles.uipanel2, '-property', 'enable'), 'enable', 'on');


    set(findall(handles.uipanel3, '-property', 'enable'), 'enable', 'on');
    set(findall(handles.uipanel4, '-property', 'enable'), 'enable', 'on');
    set(findall(handles.export3, '-property', 'enable'), 'enable', 'on');
    set(findall(handles.figure1, '-property', 'enable'), 'enable', 'on');
else
    set(findall(handles.grasp_panel, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.uipanel1, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.uipanel2, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.uipanel3, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.uipanel4, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.export3, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.figure1, '-property', 'enable'), 'enable', 'off');
end
drawnow
    contents = cellstr(get(handles.select_hand,'String'));
if (strcmp(contents{get(handles.select_hand,'Value')},'None'))
    
        set(findall(handles.hand_x, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.hand_y, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.hand_z, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.hand_rotx, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.hand_roty, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.hand_rotz, '-property', 'enable'), 'enable', 'off');
        %set(findall(handles.button_place_hand, '-property', 'enable'), 'enable', 'off');
        drawnow
end
    contents = cellstr(get(handles.select_object,'String'));

    if(strcmp(contents{get(handles.select_object,'Value')},'None') )

        set(findall(handles.object_x, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.object_y, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.object_z, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.object_rotx, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.object_roty, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.object_rotz, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.obj_rad, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.obj_height, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.obj_side, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.grasp_panel, '-property', 'enable'), 'enable', 'off');
        %set(findall(handles.button_place_object, '-property', 'enable'), 'enable', 'off');
        drawnow
    end
guidata(handles.output,handles);

% Reset position and rotation hand variables
function reset_hand(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reset the variables hand                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Reset HAND - Position,Rotation
handles.hand_data.x=0;
handles.hand_data.y=0;
handles.hand_data.z=0;
handles.hand_data.rotx=0;
handles.hand_data.roty=0;
handles.hand_data.rotz=0;

set(handles.hand_x,'String',0);
set(handles.hand_y,'String',0);
set(handles.hand_z,'String',0);
set(handles.hand_rotx,'String',0);
set(handles.hand_roty,'String',0);
set(handles.hand_rotz,'String',0);
set(handles.select_object,'Value',1);
guidata(handles.output,handles);
% Reset position and rotation object variables
function reset_object(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reset the variables' object                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Reset OBJECT - Position,Rotation
handles.obj_data.x=0;
handles.obj_data.y=0;
handles.obj_data.z=0;
handles.obj_data.rotx=0;
handles.obj_data.roty=0;
handles.obj_data.rotz=0;
handles.obj_data.rad=0;
handles.obj_data.height=0;
handles.obj_data.side=0;

set(handles.object_x,'String',0);
set(handles.object_y,'String',0);
set(handles.object_z,'String',0);
set(handles.object_rotx,'String',0);
set(handles.object_roty,'String',0);
set(handles.object_rotz,'String',0);
set(handles.obj_rad,'String',0);
set(handles.obj_height,'String',0);
set(handles.obj_side,'String',0);

%%%%% UPDATE
function updateAll(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Upadate all joints after grasping                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m,n]=size(handles.hand.S);
contents = cellstr(get(handles.select_hand,'String'));
hand_selected=contents{get(handles.select_hand,'Value')};
radio=handles.radio;
%%handles.hand.q=checkValues(handles.hand.q,3.14);   

    for i = 1:5
        for j=0:4
            q_index=(j+1)+(i-1)*4;
            if q_index>n
                break;
            end
            if j<4
                switch radio
                    case 'radio_joint'

                                eval([ 'set(handles.finger_', num2str(i), '_', num2str(j) ,',''String'',handles.hand.q(q_index));'])
                                eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''Value'',handles.hand.q(q_index));'])

                    case 'radio_synergies'
                        if q_index>n
                            break;
                        end

                                eval([ 'set(handles.finger_', num2str(i), '_', num2str(j) ,',''String'',handles.z(q_index));'])
                                eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''Value'',handles.z(q_index));'])

                end
            else
                q_index=20+i;
                if q_index>n
                    break;
                end
                switch radio
                    case 'radio_joint'

                                eval([ 'set(handles.edit_plus_', num2str(i),',''String'',handles.hand.q(q_index));'])
                                eval([ 'set(handles.slider_plus_', num2str(i) ,',''Value'',handles.hand.q(q_index));'])
                    case 'radio_synergies'

                                eval([ 'set(handles.edit_plus_', num2str(i) ,',''String'',handles.z(q_index));'])
                                eval([ 'set(handles.slider_plus_', num2str(i) ,',''Value'',handles.z(q_index));'])

                end
            end
        end
    end
guidata(handles.output,handles);
function updateFromSlider(column,row,hObject,handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get a new value from the slider and put it in the textbox               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sliderValue = get(hObject,'Value');
if strcmp(handles.radio,'radio_joint')

            sliderValue=num2str(checkValues(sliderValue,3.14,'Slider',hObject));

else
    sliderValue=num2str(checkValues(sliderValue,10,'Slider',hObject));
end
contents = cellstr(get(handles.select_hand,'String'));
hand_selected=contents{get(handles.select_hand,'Value')};
radio=handles.radio;
q=handles.hand.q;
S=handles.hand.S;
i=0;
       if row<4
           eval([ 'old_z_syn=get(handles.finger_', num2str(column), '_', num2str(row) ,',''String'');'])
           eval([ 'set(handles.finger_', num2str(column), '_', num2str(row) ,',''String'',''',sliderValue,''');'])
       else            
           eval([ 'set(handles.edit_plus_', num2str(column) ,',''String'',''',sliderValue,''');'])    
           eval([ 'old_z_syn=get(handles.edit_plus_', num2str(column) ,',''String'');'])
       end
        switch radio
            case 'radio_joint'
                if row<4

                            q((row+1)+(column-1)*4)=get(hObject,'Value');

                    i=(row+1)+(column-1)*4;
                else
                    plus_index=20+column;
                    i=plus_index;

                            q(plus_index)=get(hObject,'Value');

                end
            case 'radio_synergies'

                handles.z((row+1)+(column-1)*4)=get(hObject,'Value');
 
%                 q=S*(handles.z)'+handles.qold;
%                 synergies_update(handles,hand_selected,column,row)
        end
switch radio
    case 'radio_joint'
                q=checkValues(q,3.14);
                if(isfield(handles,'obj'))

                    [handles.hand,handles.obj]=SGblockingContactDetection(handles.hand,handles.obj,i,q(i));
                    if ~(handles.hand.q(i) == q(i))
                       set(hObject,'Value',handles.hand.q(i))
                    end
                end
               
    case 'radio_synergies'
        q=checkValues(q,3.14);
        if(isfield(handles,'obj'))
            [handles.hand,handles.obj]=SGblockingContactDetectionSyn(handles.hand,handles.obj,handles.z);
            if ~(handles.hand.q == q)
                set(hObject,'Value',str2double(old_z_syn))
                if row<4
                    
                    eval([ 'set(handles.finger_', num2str(column), '_', num2str(row) ,',''String'',''',old_z_syn,''');'])
                else            
                    eval([ 'set(handles.edit_plus_', num2str(column) ,',''String'',''',old_z_syn,''');'])    
                    
                end
            else
                synergies_update(handles,hand_selected,column,row)
            end
        else
                q=S*(handles.z)'+handles.hand.qm;
                synergies_update(handles,hand_selected,column,row)
            
        end
        
end
if(isfield(handles,'obj'))
    handles.hand=SGmoveHand(handles.hand,handles.hand.q);
else
        handles.hand=SGmoveHand(handles.hand,q);
end
guidata(hObject,handles);
%refresh print
hold off
SGGUIplothand(handles);
hold on
if(isfield(handles,'obj'))
    SGGUIplotobject(handles);
end
function updateFromInput(column,row,hObject,handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get a new values to edit text and put it in slider                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
textValue = str2double( get(hObject,'String') );
any(isnan(textValue));
if any(isnan(textValue))
    %error('Wrong value','The value inserted is not a number')
    errordlg('The value inserted is not a number','Wrong value')
    return
end

handles.hand.q=checkValues(handles.hand.q,3.14);
if strcmp(handles.radio,'radio_joint')
            textValue=checkValues(textValue,3.14,'Input',hObject);
            right_step=deg2rad(handles.step_degree);

else
    textValue=checkValues(textValue,10,'Input',hObject);
end

contents = cellstr(get(handles.select_hand,'String'));
hand_selected=contents{get(handles.select_hand,'Value')};
radio=handles.radio;
value=textValue;
% step=handles.step_degree;
first=true;
q=handles.hand.q;
S=handles.hand.S;
enableGUI(handles,false);

                if row<4
                    eval([ 'set(handles.slider_finger_', num2str(column), '_', num2str(row) ,',''Value'',',num2str(textValue),');'])
                else
                    eval([ 'set(handles.slider_plus_', num2str(column) ,',''Value'',',num2str(textValue),');'])     
                end
        switch radio
            case 'radio_joint'
                if row<4
                            q((row+1)+(column-1)*4)=textValue;
                else
                    plus_index=20+column;
                            q(plus_index)=textValue;
                end
            case 'radio_synergies'

                handles.z((row+1)+(column-1)*4)=textValue;

                q=S*(handles.z)'+handles.qold;
                synergies_update(handles,hand_selected,column,row)
        end        
switch radio
    case 'radio_joint'
         %       q=checkValues(handles.hand.q,handles.hand.limit(i,2));
    case 'radio_synergies'
    %    q=checkValues(q,3.14);
        synergies_update(handles,hand_selected,column,row)
end
handles.hand=SGmoveHand(handles.hand,q);
enableGUI(handles,true);
guidata(hObject,handles);
%refresh print
hold off
SGGUIplothand(handles);
hold on
SGGUIplotobject (handles);
%%%% UTILITIES
function D=distanceh2o(hand_data,obj_data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute distance between hand and object center                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xh=hand_data.x;
yh=hand_data.y;
zh=hand_data.z;
xo=obj_data.x;
yo=obj_data.y;
zo=obj_data.z;
D=norm([xh yh zh]-[xo yo zo]);
function y = checkValues(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check if some vector values are out of a fixed range                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin <2 || nargin==3
    disp('You must specify vector and threshold!! Or type of object if you want to change GUI value')
    return
end
x=varargin{1};
threshold=varargin{2};

[m,n]=size(x);
if m>n
    mn=m;
else
    mn=n;
end
y=zeros(m,n);
for i=1:mn
    if abs(x(i))>threshold
        disp(['Value out of bound at q( ',num2str(i),' ) = ',num2str(abs(x(i))),' with threshold ',  num2str(threshold)])
        if x(i)<0
            y(i)=-threshold;
        else
            y(i)=threshold;
        end
        if nargin ==4
            %disp('passaggio')
            switch varargin{3}
                case 'Input'
                    set(varargin{4},'String',num2str(y(i)))
                case 'Slider'
                    set(varargin{4},'Value',y(i))
            end
        end
    else
        y(i)=x(i);
    end
    
end
function synergies_update(handles,hand_selected,x,y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Update joints variable after synergies use                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[m,n]=size(handles.hand.S);
max_x=(n/5)+1;
max_y=mod(n,5)+(max_x-1);

for i = 1:max_x
    for j=0:max_y
        z_index=(j+1)+(i-1)*4;
        if i~=x && j~=y && z_index<n
            if j<4
                        eval([ 'set(handles.finger_', num2str(i), '_', num2str(j) ,',''String'',handles.z(z_index));'])
                        eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''Value'',handles.z(z_index));'])
            else
                        eval([ 'set(handles.edit_plus_', num2str(i) ,',''String'',handles.z(z_index));'])
                        eval([ 'set(handles.slider_plus_', num2str(i) ,',''Value'',handles.z(z_index));'])

            end
        end
    end
end
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
disp('Closing GUI');
allHandle = allchild(0);
allTag = get(allHandle, 'Tag');
isMsgbox = strncmp(allTag, 'Msgbox_', 7);
delete(allHandle(isMsgbox));
delete(hObject);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GUI                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%HAND
function selectHand(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select hand and set up structure with default parameters                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
contents = cellstr(get(hObject,'String')) ;
hand_selected=contents{get(hObject,'Value')};
% check modes
set(handles.radio_joint,'Value',1);
handles.radio='radio_joint';
set(handles.grasp_quality,'String',0);

handles.mode='radio_rad';
handles.radio_grasp='radio_closeall';

reset_hand(handles);
set(findall(handles.button_resethand, '-property', 'enable'), 'enable', 'on');
if(strcmp(hand_selected,'None'))
    set(findall(handles.hand_x, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.hand_y, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.hand_z, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.hand_rotx, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.hand_roty, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.hand_rotz, '-property', 'enable'), 'enable', 'off');
else
    set(findall(handles.hand_x, '-property', 'enable'), 'enable', 'on');
    set(findall(handles.hand_y, '-property', 'enable'), 'enable', 'on');
    set(findall(handles.hand_z, '-property', 'enable'), 'enable', 'on');
    set(findall(handles.hand_rotx, '-property', 'enable'), 'enable', 'on');
    set(findall(handles.hand_roty, '-property', 'enable'), 'enable', 'on');
    set(findall(handles.hand_rotz, '-property', 'enable'), 'enable', 'on');
    
end
set(findall(handles.uipanel2, '-property', 'enable'), 'enable', 'on');
        %set(findall(handles.button_place_object, '-property', 'enable'), 'enable', 'off');

set(findall(handles.object_x, '-property', 'enable'), 'enable', 'off');
set(findall(handles.object_y, '-property', 'enable'), 'enable', 'off');
set(findall(handles.object_z, '-property', 'enable'), 'enable', 'off');
set(findall(handles.object_rotx, '-property', 'enable'), 'enable', 'off');
set(findall(handles.object_roty, '-property', 'enable'), 'enable', 'off');
set(findall(handles.object_rotz, '-property', 'enable'), 'enable', 'off');
set(findall(handles.obj_rad, '-property', 'enable'), 'enable', 'off');
set(findall(handles.obj_height, '-property', 'enable'), 'enable', 'off');
set(findall(handles.obj_side, '-property', 'enable'), 'enable', 'off');

% set(findall(handles.hand_x, '-property', 'enable'), 'enable', 'off');
% set(findall(handles.hand_y, '-property', 'enable'), 'enable', 'off');
% set(findall(handles.hand_z, '-property', 'enable'), 'enable', 'off');
% set(findall(handles.hand_rotx, '-property', 'enable'), 'enable', 'off');
% set(findall(handles.hand_roty, '-property', 'enable'), 'enable', 'off');
% set(findall(handles.hand_rotz, '-property', 'enable'), 'enable', 'off');

if isfield(handles,'hand')~=0
    handles = guidata(hObject);
end

step_rad=deg2rad(handles.step_degree)/(2*pi);
if strcmp(hand_selected,'None')==1
        handles.hand_data.type='None';
%         
%         set(findall(handles.hand_x, '-property', 'enable'), 'enable', 'off');
%         set(findall(handles.hand_y, '-property', 'enable'), 'enable', 'off');
%         set(findall(handles.hand_z, '-property', 'enable'), 'enable', 'off');
%         set(findall(handles.hand_rotx, '-property', 'enable'), 'enable', 'off');
%         set(findall(handles.hand_roty, '-property', 'enable'), 'enable', 'off');
%         set(findall(handles.hand_rotz, '-property', 'enable'), 'enable', 'off');
%         set(findall(handles.button_resethand, '-property', 'enable'), 'enable', 'off');
%         set(findall(handles.uipanel2, '-property', 'enable'), 'enable', 'off');
        set(handles.control_hand,'Visible','off');
        if isfield(handles,'mode_panel')
            set(handles.mode_panel,'Visible','off');
        end
        plot3(0,0,0)
        axis 'equal'
        
        grid on
        S=zeros(5);
        
        %set the slider and edit text
        for i = 1:5
            for j=0:4
                if j<4
                    eval([ 'set(handles.finger_', num2str(i), '_', num2str(j) ,',''Visible'',''off'');'])
                    eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''Visible'',''off'');'])
                else
                    eval([ 'set(handles.edit_plus_', num2str(i) ,',''Visible'',''off'');'])
                    eval([ 'set(handles.slider_plus_', num2str(i) ,',''Visible'',''off'');']) 
                end
            end
        end
else
    % case with default hand
    switch hand_selected
        case 'Paradigmatic Hand'
            handles.hand_data.type='Paradigmatic Hand';
            set(findall(handles.uipanel3, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_x, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_y, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_z, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_rotx, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_roty, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_rotz, '-property', 'enable'), 'enable', 'on');
            set(handles.control_hand,'Visible','on');


            hand=SGparadigmatic;

            [qm,S]=SGsantelloSynergies;
            hand = SGdefineSynergies(hand,S,qm);
        case '3 Fingered Hand'
            handles.hand_data.type='3 Fingered Hand';
            set(findall(handles.uipanel3, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_x, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_y, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_z, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_rotx, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_roty, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_rotz, '-property', 'enable'), 'enable', 'on');

            set(handles.control_hand,'Visible','on');


            hand=SG3Fingered;
        case 'DLR Hand'

            handles.hand_data.type='DLR Hand';
            set(findall(handles.uipanel3, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_x, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_y, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_z, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_rotx, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_roty, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_rotz, '-property', 'enable'), 'enable', 'on');

            set(handles.control_hand,'Visible','on');


            hand=SGDLRHandII;
        case 'Modular Hand'

            handles.hand_data.type='Modular Hand';
            set(findall(handles.uipanel3, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_x, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_y, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_z, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_rotx, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_roty, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_rotz, '-property', 'enable'), 'enable', 'on');

            set(handles.control_hand,'Visible','on');


            hand = SGmodularHand;
            
        case 'VizzyHandModel'

            handles.hand_data.type='VizzyHandModel';
            set(findall(handles.uipanel3, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_x, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_y, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_z, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_rotx, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_roty, '-property', 'enable'), 'enable', 'on');
            set(findall(handles.hand_rotz, '-property', 'enable'), 'enable', 'on');

            set(handles.control_hand,'Visible','on');


            hand = VizzyHandModel;
        otherwise
            try
                lst = evalin('base','who(''*hand*'',''base'')');
                if ~isfield(handles,'hand_wvar')
                    disp('You should select the hand structure to import by clicking the New Hand button')
                    disp('Trying to import the defaut hand structure named ''hand''')
                    handles.hand_wvar=1;
                    lst={'hand'};
                end    
                exsS=evalin('base',['isfield(',lst{handles.hand_wvar},',''S'')']);
                exsq=evalin('base',['isfield(',lst{handles.hand_wvar},',''q'')']);
                if exsq==1
                    hand=evalin('base',lst{handles.hand_wvar});
                    handles.hand_data.type='User Defined Hand (max 25 joint)';
                    set(findall(handles.uipanel3, '-property', 'enable'), 'enable', 'on');
                    set(findall(handles.hand_x, '-property', 'enable'), 'enable', 'on');
                    set(findall(handles.hand_y, '-property', 'enable'), 'enable', 'on');
                    set(findall(handles.hand_z, '-property', 'enable'), 'enable', 'on');
                    set(findall(handles.hand_rotx, '-property', 'enable'), 'enable', 'on');
                    set(findall(handles.hand_roty, '-property', 'enable'), 'enable', 'on');
                    set(findall(handles.hand_rotz, '-property', 'enable'), 'enable', 'on');
                    set(handles.control_hand,'Visible','on');

                else
                    set(findall(handles.uipanel2, '-property', 'enable'), 'enable', 'off');
                     disp('The variable selected is not a valid hand: miss field ''q''')
                     return
                end
            catch
                disp('You must specify the hand structure in the base workspace')
                return
            end
            disp('Hand model successfully imported')
    end

        axis 'equal'
        
        grid on
        if ~isfield(hand,'S')
           set(handles.control_hand,'Visible','off');
        end
        %save hand in handles structure
        handles.hand=hand;
        
        S_size=size(handles.hand.S,1);
        guidata(handles.output,handles);
        hold off
        SGGUIplothand(handles);
        %Refresh joint position from user's hand
        for i = 1:5
            for j=0:4
                if j<4
                    q_index=(j+1)+(i-1)*4;
                    if q_index> S_size
                        eval([ 'set(handles.finger_', num2str(i), '_', num2str(j) ,',''Visible'',''off'');'])
                        eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''Visible'',''off'');'])
                    else
                                eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''Min'',-3.14);'])
                                eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''Max'',3.14);'])
                                eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''SliderStep'',[step_rad,0.1]);'])
                                eval([ 'set(handles.finger_', num2str(i), '_', num2str(j) ,',''String'',hand.q(q_index));'])
                                eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''Value'',hand.q(q_index));'])
                        eval([ 'set(handles.finger_', num2str(i), '_', num2str(j) ,',''Visible'',''on'');'])
                        eval([ 'set(handles.slider_finger_', num2str(i), '_', num2str(j) ,',''Visible'',''on'');'])
                    end
                else
                   
                   q_index=20+i;
                   
                   %size(handles.q)
                   if q_index> S_size
                    eval([ 'set(handles.slider_plus_', num2str(i) ,',''Visible'',''off'');'])
                    eval([ 'set(handles.edit_plus_', num2str(i) ,',''Visible'',''off'');'])
                   else
                            eval([ 'set(handles.slider_plus_', num2str(i) ,',''Min'',-3.14);'])
                            eval([ 'set(handles.slider_plus_', num2str(i) ,',''Max'',3.14);'])
                            eval([ 'set(handles.slider_plus_', num2str(i) ,',''SliderStep'',[step_rad,0.1]);'])
                            eval([ 'set(handles.slider_plus_', num2str(i) ,',''String'',hand.q(q_index));'])
                            eval([ 'set(handles.slider_plus_', num2str(i) ,',''Value'',hand.q(q_index));'])

                        eval([ 'set(handles.slider_plus_', num2str(i) ,',''Visible'',''on'');'])
                        eval([ 'set(handles.edit_plus_', num2str(i) ,',''Visible'',''on'');'])
                   end
                end
               
                
            end
        end
        handles.radio='radio_joint';
        guidata(handles.output,handles);
        
end
try
% set the size of z containing the synergies paramethers
    [rows,columns]=size(hand.S);
    handles.z=zeros(1,columns);
catch
    disp('Empty hand')
end
% removed (just a try)
% handles.qold=handles.hand.q;
%
if (strcmp(hand_selected,'None')==0)
    handles.q=hand.q;
end
guidata(handles.output,handles)
function select_hand_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_hand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Hand Traslation
function hand_x_Callback(hObject, eventdata, handles)
% hObject    handle to hand_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.hand_data.x=str2double(get(hObject,'String'));
if any(isnan(handles.hand_data.x))
    errordlg('The value inserted is not a number','Wrong value')
    return
end
guidata(hObject,handles);
SGGUIplothand(handles);
SGGUIplotobject(handles);
function hand_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hand_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function hand_y_Callback(hObject, eventdata, handles)
% hObject    handle to hand_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.hand_data.y=str2double(get(hObject,'String'));
if any(isnan(handles.hand_data.y))
    errordlg('The value inserted is not a number','Wrong value')
    return
end
guidata(hObject,handles);
SGGUIplotobject (handles);
function hand_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hand_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function hand_z_Callback(hObject, eventdata, handles)
% hObject    handle to hand_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.hand_data.z=str2double(get(hObject,'String'));
if any(isnan(handles.hand_data.z))
    errordlg('The value inserted is not a number','Wrong value')
    return
end
guidata(hObject,handles);
SGGUIplothand(handles);
SGGUIplotobject (handles);
function hand_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hand_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% Hand Rotation
function hand_rotx_Callback(hObject, eventdata, handles)
% hObject    handle to hand_rotx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value=str2double(get(hObject,'String'));
if any(isnan(value))
    errordlg('The value inserted is not a number','Wrong value')
    return
end
step=handles.step_degree;
first=true;
enableGUI(handles,false);
while step<abs(value) || first
    if abs(abs(value)-step)<handles.step_degree || (abs(value)-step)<0
        handles.hand_data.rotx=deg2rad(value);
    else
        if value>=0
            handles.hand_data.rotx=deg2rad(step);
        else
            handles.hand_data.rotx=deg2rad(-step);
        end
    end
    
    pause(0.01);
    SGGUIplothand(handles);
    SGGUIplotobject (handles);
    step=step+handles.step_degree;
    first=false;
end
enableGUI(handles,true);
guidata(hObject,handles);
function hand_rotx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hand_rotx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function hand_roty_Callback(hObject, eventdata, handles)
% hObject    handle to hand_roty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value=str2double(get(hObject,'String'));
if any(isnan(value))
    errordlg('The value inserted is not a number','Wrong value')
    return
end
step=handles.step_degree;
first=true;
enableGUI(handles,false);
while step<abs(value) || first
    if abs(abs(value)-step)<handles.step_degree || (abs(value)-step)<0
        handles.hand_data.roty=deg2rad(value);
    else
        if value>=0
            handles.hand_data.roty=deg2rad(step);
        else
            handles.hand_data.roty=deg2rad(-step);
        end
    end
    pause(0.01);
    SGGUIplothand(handles);
    SGGUIplotobject (handles);
    step=step+handles.step_degree;
    first=false;
end
enableGUI(handles,true);
guidata(hObject,handles);
function hand_roty_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hand_roty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function hand_rotz_Callback(hObject, eventdata, handles)
% hObject    handle to hand_rotz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value=str2double(get(hObject,'String'));
if any(isnan(value))
    errordlg('The value inserted is not a number','Wrong value')
    return
end
step=handles.step_degree;
first=true;
enableGUI(handles,false);
while step<abs(value) || first
    if abs(abs(value)-step)<handles.step_degree || (abs(value)-step)<0
        handles.hand_data.rotz=deg2rad(value);
    else
        if value>=0
            handles.hand_data.rotz=deg2rad(step);
        else
            handles.hand_data.rotz=deg2rad(-step);
        end
    end
    pause(0.01);
    SGGUIplothand(handles);
    SGGUIplotobject (handles);
    step=step+handles.step_degree;
    first=false;
end
enableGUI(handles,true);
guidata(hObject,handles);
function hand_rotz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hand_rotz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%OBJECT
function select_object_Callback(hObject, eventdata, handles)
    contents = cellstr(get(hObject,'String')) ;
    obj_selected=contents{get(handles.select_object,'Value')};
    if strcmp(obj_selected,'None')==0
        %%DEFAULT VALUES
        theta=0;
        phi=0;
        psi=0;
        x=0;
        y=0;
        z=0;
        rad=10;
        height=10;
        side=10;
        
        set(handles.object_x, 'String',num2str(x));
        set(handles.object_y, 'String',num2str(y));
        set(handles.object_z, 'String',num2str(z));
        set(handles.object_rotx, 'String',num2str(theta));
        set(handles.object_roty, 'String',num2str(phi));
        set(handles.object_rotz, 'String',num2str(psi));
        set(handles.obj_rad, 'String',num2str(rad));
        set(handles.obj_height, 'String',num2str(height));
        set(handles.obj_side, 'String',num2str(side));
        set(findall(handles.object_x, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.object_y, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.object_z, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.object_rotx, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.object_roty, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.object_rotz, '-property', 'enable'), 'enable', 'on');
                set(findall(handles.button_place_object, '-property', 'enable'), 'enable', 'on');

        switch obj_selected
            case 'Sphere'
                set(findall(handles.obj_rad, '-property', 'enable'), 'enable', 'on');
                set(findall(handles.obj_height, '-property', 'enable'), 'enable', 'off');
                set(findall(handles.obj_side, '-property', 'enable'), 'enable', 'off');
            case 'Cube'
                set(findall(handles.obj_rad, '-property', 'enable'), 'enable', 'off');
                set(findall(handles.obj_height, '-property', 'enable'), 'enable', 'off');
                set(findall(handles.obj_side, '-property', 'enable'), 'enable', 'on');
           case 'Cylinder'
                set(findall(handles.obj_rad, '-property', 'enable'), 'enable', 'on');
                set(findall(handles.obj_height, '-property', 'enable'), 'enable', 'on');
                set(findall(handles.obj_side, '-property', 'enable'), 'enable', 'off');   
            otherwise
                disp('bad object selection')
        end
    else
        %reset_object(handles);
        %SGGUIplothand(handles);
        %set(findall(handles.grasp_panel, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.object_x, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.object_y, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.object_z, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.object_rotx, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.object_roty, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.object_rotz, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.obj_rad, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.obj_height, '-property', 'enable'), 'enable', 'off');
        set(findall(handles.obj_side, '-property', 'enable'), 'enable', 'off');
                %set(findall(handles.button_place_object, '-property', 'enable'), 'enable', 'off');

        if(isfield(handles,'obj'))
            handles=rmfield(handles,'obj');
        end
    end
    guidata(handles.output,handles)
function select_object_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_object (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Object Traslation
function object_x_Callback(hObject, eventdata, handles)
% hObject    handle to object_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.obj_data.x=str2double(get(hObject,'String'));
if any(isnan(handles.obj_data.x))
    errordlg('The value inserted is not a number','Wrong value')
    return
end
guidata(hObject,handles);
function object_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to object_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function object_y_Callback(hObject, eventdata, handles)
% hObject    handle to object_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.obj_data.y=str2double(get(hObject,'String'));
if any(isnan(handles.obj_data.y))
    errordlg('The value inserted is not a number','Wrong value')
    return
end
guidata(hObject,handles);
function object_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to object_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function object_z_Callback(hObject, eventdata, handles)
% hObject    handle to object_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.obj_data.z=str2double(get(hObject,'String'));
if any(isnan(handles.obj_data.z))
    errordlg('The value inserted is not a number','Wrong value')
    return
end
guidata(hObject,handles);
function object_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to object_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% Object Rotation
function object_rotx_Callback(hObject, eventdata, handles)
% hObject    handle to object_rotx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.obj_data.rotx=deg2rad(str2double(get(hObject,'String')));
if any(isnan(handles.obj_data.rotx))
    errordlg('The value inserted is not a number','Wrong value')
    return
end
guidata(hObject,handles);
function object_rotx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to object_rotx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function object_roty_Callback(hObject, eventdata, handles)
% hObject    handle to object_roty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.obj_data.roty=deg2rad(str2double(get(hObject,'String')));
if any(isnan(handles.obj_data.roty))
    errordlg('The value inserted is not a number','Wrong value')
    return
end
guidata(hObject,handles);
function object_roty_CreateFcn(hObject, eventdata, handles)
% hObject    handle to object_roty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function object_rotz_Callback(hObject, eventdata, handles)
% hObject    handle to object_rotz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.obj_data.rotz=deg2rad(str2double(get(hObject,'String')));
if any(isnan(handles.obj_data.rotz))
    errordlg('The value inserted is not a number','Wrong value')
    return
end
guidata(hObject,handles);
function object_rotz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to object_rotz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% Object Parameters
function obj_rad_Callback(hObject, eventdata, handles)
% hObject    handle to obj_rad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of obj_rad as text
%        str2double(get(hObject,'String')) returns contents of obj_rad as a double
handles.obj_data.rad=str2double(get(hObject,'String'));
if any(isnan(handles.obj_data.rad))
    errordlg('The value inserted is not a number','Wrong value')
    return
end
guidata(hObject,handles);
function obj_rad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to obj_rad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function obj_side_Callback(hObject, eventdata, handles)
% hObject    handle to obj_side (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of obj_side as text
%        str2double(get(hObject,'String')) returns contents of obj_side as a double
handles.obj_data.side=str2double(get(hObject,'String'));
if any(isnan(handles.obj_data.side))
    errordlg('The value inserted is not a number','Wrong value')
    return
end
guidata(hObject,handles);
function obj_side_CreateFcn(hObject, eventdata, handles)
% hObject    handle to obj_side (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function obj_height_Callback(hObject, eventdata, handles)
% hObject    handle to obj_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of obj_height as text
%        str2double(get(hObject,'String')) returns contents of obj_height as a double
handles.obj_data.height=str2double(get(hObject,'String'));
if any(isnan(handles.obj_data.height))
    errordlg('The value inserted is not a number','Wrong value')
    return
end
guidata(hObject,handles);
function obj_height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to obj_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%FINGERS
%Finger 1, Joint 0
function finger_1_0_Callback(hObject, eventdata, handles)
% hObject    handle to finger_1_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateFromInput(1,0,hObject,handles);
function finger_1_0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finger_1_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_finger_1_0_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finger_1_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateFromSlider(1,0,hObject,handles);
function slider_finger_1_0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finger_1_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%Finger 1, Joint 1
function finger_1_1_Callback(hObject, eventdata, handles)
% hObject    handle to finger_1_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateFromInput(1,1,hObject,handles);
function finger_1_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finger_1_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_finger_1_1_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finger_1_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateFromSlider(1,1,hObject,handles);
function slider_finger_1_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finger_1_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%Finger 1, Joint 2
function finger_1_2_Callback(hObject, eventdata, handles)
% hObject    handle to finger_1_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateFromInput(1,2,hObject,handles);
function finger_1_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finger_1_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_finger_1_2_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finger_1_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateFromSlider(1,2,hObject,handles);
function slider_finger_1_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finger_1_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%Finger 1, Joint 3
function finger_1_3_Callback(hObject, eventdata, handles)
% hObject    handle to finger_1_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% to update slider
updateFromInput(1,3,hObject,handles);
function finger_1_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finger_1_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_finger_1_3_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finger_1_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(1,3,hObject,handles);
function slider_finger_1_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finger_1_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%Finger 2, Joint 0
function finger_2_0_Callback(hObject, eventdata, handles)
% hObject    handle to finger_2_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of finger_2_3 as text
%        str2double(get(hObject,'String')) returns contents of finger_2_3 as a double
updateFromInput(2,0,hObject,handles);
function finger_2_0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finger_2_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider_finger_2_0_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finger_2_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateFromSlider(2,0,hObject,handles);
function slider_finger_2_0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finger_2_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%Finger 2, Joint 1
function finger_2_1_Callback(hObject, eventdata, handles)
% hObject    handle to finger_2_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of finger_2_2 as text
%        str2double(get(hObject,'String')) returns contents of finger_2_2 as a double
updateFromInput(2,1,hObject,handles);
function finger_2_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finger_2_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_finger_2_1_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finger_2_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(2,1,hObject,handles);
function slider_finger_2_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finger_2_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%Finger 2, Joint 2
function finger_2_2_Callback(hObject, eventdata, handles)
% hObject    handle to finger_2_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of finger_2_2 as text
%        str2double(get(hObject,'String')) returns contents of finger_2_2 as a double
updateFromInput(2,2,hObject,handles);
function finger_2_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finger_2_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_finger_2_2_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finger_2_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(2,2,hObject,handles);
function slider_finger_2_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finger_2_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%Finger 2, Joint 3
function finger_2_3_Callback(hObject, eventdata, handles)
% hObject    handle to finger_2_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of finger_2_3 as text
%        str2double(get(hObject,'String')) returns contents of finger_2_3 as a double
updateFromInput(2,3,hObject,handles);
function finger_2_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finger_2_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_finger_2_3_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finger_2_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(2,3,hObject,handles);
function slider_finger_2_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finger_2_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%Finger 3, Joint 0
function finger_3_0_Callback(hObject, eventdata, handles)
% hObject    handle to finger_3_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of finger_3_3 as text
%        str2double(get(hObject,'String')) returns contents of finger_3_3 as a double
updateFromInput(3,0,hObject,handles);
function finger_3_0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finger_3_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_finger_3_0_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finger_3_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(3,0,hObject,handles);
function slider_finger_3_0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finger_3_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%Finger 3, Joint 1
function finger_3_1_Callback(hObject, eventdata, handles)
% hObject    handle to finger_3_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of finger_3_2 as text
%        str2double(get(hObject,'String')) returns contents of finger_3_2 as a double
updateFromInput(3,1,hObject,handles);
function finger_3_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finger_3_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_finger_3_1_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finger_3_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(3,1,hObject,handles);
function slider_finger_3_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finger_3_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%Finger 3, Joint 2
function finger_3_2_Callback(hObject, eventdata, handles)
% hObject    handle to finger_3_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of finger_3_2 as text
%        str2double(get(hObject,'String')) returns contents of finger_3_2 as a double
updateFromInput(3,2,hObject,handles);
function finger_3_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finger_3_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_finger_3_2_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finger_3_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(3,2,hObject,handles);
function slider_finger_3_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finger_3_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%Finger 3, Joint 3
function finger_3_3_Callback(hObject, eventdata, handles)
% hObject    handle to finger_3_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of finger_3_3 as text
%        str2double(get(hObject,'String')) returns contents of finger_3_3 as a double
updateFromInput(3,3,hObject,handles);
function finger_3_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finger_3_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_finger_3_3_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finger_3_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(3,3,hObject,handles);
function slider_finger_3_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finger_3_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%Finger 4, Joint 0
function finger_4_0_Callback(hObject, eventdata, handles)
% hObject    handle to finger_4_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of finger_4_3 as text
%        str2double(get(hObject,'String')) returns contents of finger_4_3 as a double
updateFromInput(4,0,hObject,handles);
function finger_4_0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finger_4_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_finger_4_0_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finger_4_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(4,0,hObject,handles);
function slider_finger_4_0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finger_4_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%Finger 4, Joint 1
function finger_4_1_Callback(hObject, eventdata, handles)
% hObject    handle to finger_4_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of finger_4_2 as text
%        str2double(get(hObject,'String')) returns contents of finger_4_2 as a double
updateFromInput(4,1,hObject,handles);
function finger_4_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finger_4_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_finger_4_1_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finger_4_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(4,1,hObject,handles);
function slider_finger_4_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finger_4_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%Finger 4, Joint 2
function finger_4_2_Callback(hObject, eventdata, handles)
% hObject    handle to finger_4_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of finger_4_2 as text
%        str2double(get(hObject,'String')) returns contents of finger_4_2 as a double
updateFromInput(4,2,hObject,handles);
function finger_4_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finger_4_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_finger_4_2_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finger_4_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(4,2,hObject,handles);
function slider_finger_4_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finger_4_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%Finger 4, Joint 3
function finger_4_3_Callback(hObject, eventdata, handles)
% hObject    handle to finger_4_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of finger_4_3 as text
%        str2double(get(hObject,'String')) returns contents of finger_4_3 as a double
updateFromInput(4,3,hObject,handles);
function finger_4_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finger_4_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_finger_4_3_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finger_4_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(4,3,hObject,handles);
function slider_finger_4_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finger_4_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%Finger 5, Joint 0
function finger_5_0_Callback(hObject, eventdata, handles)
% hObject    handle to finger_5_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of finger_5_3 as text
%        str2double(get(hObject,'String')) returns contents of finger_5_3 as a double
updateFromInput(5,0,hObject,handles);
function finger_5_0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finger_5_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_finger_5_0_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finger_5_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(5,0,hObject,handles);
function slider_finger_5_0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finger_5_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%Finger 5, Joint 1
function finger_5_1_Callback(hObject, eventdata, handles)
% hObject    handle to finger_5_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of finger_5_2 as text
%        str2double(get(hObject,'String')) returns contents of finger_5_2 as a double
updateFromInput(5,1,hObject,handles);
function finger_5_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finger_5_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_finger_5_1_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finger_5_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(5,1,hObject,handles);
function slider_finger_5_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finger_5_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%Finger 5, Joint 2
function finger_5_2_Callback(hObject, eventdata, handles)
% hObject    handle to finger_5_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of finger_5_2 as text
%        str2double(get(hObject,'String')) returns contents of finger_5_2 as a double
updateFromInput(5,2,hObject,handles);
function finger_5_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finger_5_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_finger_5_2_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finger_5_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(5,2,hObject,handles);
function slider_finger_5_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finger_5_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%Finger 5, Joint 3
function finger_5_3_Callback(hObject, eventdata, handles)
% hObject    handle to finger_5_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of finger_5_3 as text
%        str2double(get(hObject,'String')) returns contents of finger_5_3 as a double
updateFromInput(5,3,hObject,handles);
function finger_5_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finger_5_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_finger_5_3_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finger_5_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(5,3,hObject,handles);
function slider_finger_5_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finger_5_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% EXTRA FINGERS
function slider_plus_1_Callback(hObject, eventdata, handles)
% hObject    handle to slider_plus_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(1,5,hObject,handles);
function slider_plus_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_plus_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function edit_plus_1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_plus_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_plus_1 as text
%        str2double(get(hObject,'String')) returns contents of edit_plus_1 as a double
updateFromInput(1,5,hObject,handles);
function edit_plus_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_plus_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_plus_2_Callback(hObject, eventdata, handles)
% hObject    handle to slider_plus_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(2,5,hObject,handles);
function slider_plus_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_plus_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function edit_plus_2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_plus_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_plus_2 as text
%        str2double(get(hObject,'String')) returns contents of edit_plus_2 as a double
updateFromInput(2,5,hObject,handles);
function edit_plus_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_plus_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_plus_3_Callback(hObject, eventdata, handles)
% hObject    handle to slider_plus_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(3,5,hObject,handles);
function slider_plus_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_plus_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function edit_plus_3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_plus_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_plus_3 as text
%        str2double(get(hObject,'String')) returns contents of edit_plus_3 as a double
updateFromInput(3,5,hObject,handles);
function edit_plus_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_plus_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_plus_4_Callback(hObject, eventdata, handles)
% hObject    handle to slider_plus_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(4,5,hObject,handles);
function slider_plus_4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_plus_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function edit_plus_4_Callback(hObject, eventdata, handles)
% hObject    handle to edit_plus_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_plus_4 as text
%        str2double(get(hObject,'String')) returns contents of edit_plus_4 as a double
updateFromInput(4,5,hObject,handles);
function edit_plus_4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_plus_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider_plus_5_Callback(hObject, eventdata, handles)
% hObject    handle to slider_plus_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateFromSlider(5,5,hObject,handles);
function slider_plus_5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_plus_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function edit_plus_5_Callback(hObject, eventdata, handles)
% hObject    handle to edit_plus_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_plus_5 as text
%        str2double(get(hObject,'String')) returns contents of edit_plus_5 as a double
updateFromInput(5,5,hObject,handles);
function edit_plus_5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_plus_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

    


% --- Executes on button press in GraspwithSynergies.
function GraspwithSynergies_Callback(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Star grasp closehand
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp (handles.hand.type)
switch handles.hand.type
    case 'Paradigmatic'
        active=[0 1 1 0 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 ]';
    case '3Fingered'
        active=[1 1 0 1 1 0 1 1]';
    case 'DLR'
        active=[0 1 1 0 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 ]';
    case 'Modular'
        active= [1 1 1 1 1 1 1 1 1];
    case 'VizzyHand'
        active= 0.05*[1 1 1];
        n_syn = 3;
        
end

enableGUI(handles,false)
handles.obj 
[handles.hand,handles.obj] = SGcloseHandWithSynergies(handles.hand,handles.obj,active, n_syn);   
handles.obj
guidata(handles.output,handles);
%refresh print
SGGUIplothand(handles);
handles.obj
SGGUIplotobject (handles);
updateAll(handles)

set(findall(handles.uipanel1, '-property', 'enable'), 'enable', 'on');
set(findall(handles.export3, '-property', 'enable'), 'enable', 'on');
set(findall(handles.uipanel3, '-property', 'enable'), 'enable', 'on');
set(findall(handles.uipanel2, '-property', 'enable'), 'enable', 'on');
set(findall(handles.grasp_panel, '-property', 'enable'), 'enable', 'on');
if(~isfield(handles.obj,'G'))
    set(findall(handles.button_quality, '-property', 'enable'), 'enable','off');
end

if (isempty(handles.hand.J))
    set(findall(handles.uipanel14, '-property', 'enable'), 'enable', 'off');
else
    set(findall(handles.uipanel14, '-property', 'enable'), 'enable', 'on');
end
