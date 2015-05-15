function varargout = NB_Sim_GUI(varargin)
% NB_SIM_GUI M-file for NB_Sim_GUI.fig
%      NB_SIM_GUI, by itself, creates a new NB_SIM_GUI or raises the existing
%      singleton*.
%
%      H = NB_SIM_GUI returns the handle to a new NB_SIM_GUI or the handle to
%      the existing singleton*.
%
%      NB_SIM_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NB_SIM_GUI.M with the given input arguments.
%
%      NB_SIM_GUI('Property','Value',...) creates a new NB_SIM_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NB_Sim_GUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NB_Sim_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NB_Sim_GUI

% Last Modified by GUIDE v2.5 28-Dec-2005 21:25:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NB_Sim_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @NB_Sim_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before NB_Sim_GUI is made visible.
function NB_Sim_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NB_Sim_GUI (see VARARGIN)

% Choose default command line output for NB_Sim_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = NB_Sim_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function RxAlgorithmList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RxAlgorithmList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
% Fill the Listbox with the available receiver algorithms
DirStruct=dir('Receivers/*.m');
DirContent={DirStruct.name};
ReceiversList={DirStruct.name};%{DirContent{3:size(DirContent,2)}};
for k=1:size(ReceiversList,2)
    ReceiversList{k}=ReceiversList{k}(1:size(ReceiversList{k},2)-2);
end;
set(hObject,'String',ReceiversList);
set(hObject,'Max',size(ReceiversList,2));


% --- Executes on selection change in RxAlgorithmList.
function RxAlgorithmList_Callback(hObject, eventdata, handles)
% hObject    handle to RxAlgorithmList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns RxAlgorithmList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RxAlgorithmList


% --- Executes on button press in StartSim.
function StartSim_Callback(hObject, eventdata, handles)
% hObject    handle to StartSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%% Gets the settings and starts simulation
Sys.Ntx=str2num(get(handles.NTX,'String'));
Sys.Nrx=str2num(get(handles.NRX,'String'));
Sys.Modulation_order=str2num(get(handles.ModOrder,'String'));        % Modulation_order = 2: QPSK, 4: 16QAM, 6: 64QAM
Sim.SNR_dB_list=[str2num(get(handles.SNRStart,'String')):str2num(get(handles.SNRStep,'String')):str2num(get(handles.SNRStop,'String'))]; 
Sim.nr_of_channels=str2num(get(handles.NumChannels,'String'));
Sim.nr_of_data_per_channel=str2num(get(handles.NumVecsPerChannel,'String'));
Sim.fig_nr=1;       % Figure number to plot results
% Build list of receivers
Sim.RxList=[];
AllRxAlgorithmList=get(handles.RxAlgorithmList,'String');
for k=get(handles.RxAlgorithmList,'Value')
    Sim.RxList=[Sim.RxList,AllRxAlgorithmList(k)];
end;
SimResultsList=RunSim(Sim,Sys);
if get(handles.AddToLoadedCheckbox,'Value')==0
    handles.SimResultsList=SimResultsList;
elseif isfield(handles,'SimResultsList')==0
    handles.SimResultsList=SimResultsList;
else
    handles.SimResultsList={handles.SimResultsList{:},SimResultsList{:}};
end;
guidata(gcbo,handles);
UpdateSelectSimResults;
RePlotBER; %(handles.SimResultsList)

function RePlotBER
handles=guidata(gcbo);
SimResultsList=handles.SimResultsList;
if get(handles.DetachCheckbox,'Value')==1
    figure(handles.DetachedFigureHandle);
end;
cla;
% Plot the BER curves
for SimResultNumber=[1:size(SimResultsList,2)]
    RxFunctionName=SimResultsList{SimResultNumber}.Sim.RxName;
    LineStyles=get(handles.SelLine,'String');
    ColorStyles=get(handles.SelColor,'String');
    PointsStyles=get(handles.SelPoints,'String');
    Style=sprintf('%s%s%s',LineStyles{SimResultsList{SimResultNumber}.SelLine},...
        ColorStyles{SimResultsList{SimResultNumber}.SelColor},PointsStyles{SimResultsList{SimResultNumber}.SelPoints});
    if SimResultsList{SimResultNumber}.Visible==1
        if get(handles.HighlightCheckbox,'Value')==1
            if SimResultNumber==get(handles.SelectSimResults,'Value')
                LineWidth=2;
            else 
                LineWidth=1;
            end;
        else 
            LineWidth=1;
        end;
        semilogy(SimResultsList{SimResultNumber}.Sim.SNR_dB_list,SimResultsList{SimResultNumber}.BER_log,Style,'LineWidth',LineWidth); hold on;
    end;
end;
grid on;
% generate legend if ON
if get(handles.LegendCheckbox,'Value')==1
    LegendText={};
    for SimResultNumber=[1:size(SimResultsList,2)]
        if SimResultsList{SimResultNumber}.Visible==1
            LegendText={LegendText{:},SimResultsList{SimResultNumber}.LegendText};
        end;
    end;
    legend(LegendText);
else 
    legend off;
end;


function UpdateSelectSimResults
handles=guidata(gcbo);
SimResultsList=handles.SimResultsList;
SimResultsNames={};
for SimResultNumber=[1:size(SimResultsList,2)]
    ResultsName=SimResultsList{SimResultNumber}.LegendText;
    SimResultsNames={SimResultsNames{:},ResultsName};
end;
set(handles.SelectSimResults,'String',SimResultsNames);

% --- Executes during object creation, after setting all properties.
function NTX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NTX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function NTX_Callback(hObject, eventdata, handles)
% hObject    handle to NTX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NTX as text
%        str2double(get(hObject,'String')) returns contents of NTX as a double


% --- Executes during object creation, after setting all properties.
function NRX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NRX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function NRX_Callback(hObject, eventdata, handles)
% hObject    handle to NRX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NRX as text
%        str2double(get(hObject,'String')) returns contents of NRX as a double


% --- Executes during object creation, after setting all properties.
function NumChannels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function NumChannels_Callback(hObject, eventdata, handles)
% hObject    handle to NumChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumChannels as text
%        str2double(get(hObject,'String')) returns contents of NumChannels as a double


% --- Executes during object creation, after setting all properties.
function NumVecsPerChannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumVecsPerChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function NumVecsPerChannel_Callback(hObject, eventdata, handles)
% hObject    handle to NumVecsPerChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumVecsPerChannel as text
%        str2double(get(hObject,'String')) returns contents of NumVecsPerChannel as a double


% --- Executes during object creation, after setting all properties.
function ModOrder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ModOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ModOrder_Callback(hObject, eventdata, handles)
% hObject    handle to ModOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ModOrder as text
%        str2double(get(hObject,'String')) returns contents of ModOrder as a double


% --- Executes during object creation, after setting all properties.
function SNRStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SNRStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function SNRStart_Callback(hObject, eventdata, handles)
% hObject    handle to SNRStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SNRStart as text
%        str2double(get(hObject,'String')) returns contents of SNRStart as a double


% --- Executes during object creation, after setting all properties.
function SNRStop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SNRStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function SNRStop_Callback(hObject, eventdata, handles)
% hObject    handle to SNRStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SNRStop as text
%        str2double(get(hObject,'String')) returns contents of SNRStop as a double


% --- Executes during object creation, after setting all properties.
function SNRStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SNRStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function SNRStep_Callback(hObject, eventdata, handles)
% hObject    handle to SNRStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SNRStep as text
%        str2double(get(hObject,'String')) returns contents of SNRStep as a double


% --- Executes on button press in ClearButton.
function ClearButton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla;

% --- Executes on button press in ReplotAllButton.
function ReplotAllButton_Callback(hObject, eventdata, handles)
% hObject    handle to ReplotAllButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RePlotBER;


% --- Executes on button press in AddToLoadedCheckbox.
function AddToLoadedCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to AddToLoadedCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AddToLoadedCheckbox


% --- Executes during object creation, after setting all properties.
function SelectSimResults_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelectSimResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in SelectSimResults.
function SelectSimResults_Callback(hObject, eventdata, handles)
% hObject    handle to SelectSimResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SelectSimResults contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelectSimResults
SelectedSimResultNumber=get(handles.SelectSimResults,'Value');
set(handles.SelLine,'Value',handles.SimResultsList{SelectedSimResultNumber}.SelLine);
set(handles.SelColor,'Value',handles.SimResultsList{SelectedSimResultNumber}.SelColor);
set(handles.SelPoints,'Value',handles.SimResultsList{SelectedSimResultNumber}.SelPoints);
set(handles.VisibleCheckBox,'Value',handles.SimResultsList{SelectedSimResultNumber}.Visible);
set(handles.CommentTextBox,'String',handles.SimResultsList{SelectedSimResultNumber}.CommentText);
set(handles.NTX,'String',num2str(handles.SimResultsList{SelectedSimResultNumber}.Sys.Ntx));
set(handles.NRX,'String',num2str(handles.SimResultsList{SelectedSimResultNumber}.Sys.Nrx));
set(handles.ModOrder,'String',num2str(handles.SimResultsList{SelectedSimResultNumber}.Sys.Modulation_order));
set(handles.SNRStart,'String',num2str(min(handles.SimResultsList{SelectedSimResultNumber}.Sim.SNR_dB_list)));
set(handles.SNRStep,'String',num2str(abs(handles.SimResultsList{SelectedSimResultNumber}.Sim.SNR_dB_list(2)-handles.SimResultsList{SelectedSimResultNumber}.Sim.SNR_dB_list(1))));
set(handles.SNRStop,'String',num2str(max(handles.SimResultsList{SelectedSimResultNumber}.Sim.SNR_dB_list)));
set(handles.NumChannels,'String',num2str(max(handles.SimResultsList{SelectedSimResultNumber}.Sim.nr_of_channels)));
set(handles.NumVecsPerChannel,'String',num2str(max(handles.SimResultsList{SelectedSimResultNumber}.Sim.nr_of_data_per_channel)));

if get(handles.HighlightCheckbox,'Value')==1
    RePlotBER;
end;
guidata(gcbo,handles);

% --- Executes on button press in PlotSelected.
function PlotSelected_Callback(hObject, eventdata, handles)
% hObject    handle to PlotSelected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

SelectedSimResultNumber=get(handles.SelectSimResults,'Value');
SimResultsList=handles.SimResultsList;
LineStyles=get(handles.SelLine,'String');
ColorStyles=get(handles.SelColor,'String');
PointsStyles=get(handles.SelPoints,'String');
Style=sprintf('%s%s%s',LineStyles{SimResultsList{SelectedSimResultNumber}.SelLine},...
    ColorStyles{SimResultsList{SelectedSimResultNumber}.SelColor},PointsStyles{SimResultsList{SelectedSimResultNumber}.SelPoints});
% Plot the BER curves
semilogy(SimResultsList{SelectedSimResultNumber}.Sim.SNR_dB_list,SimResultsList{SelectedSimResultNumber}.BER_log,Style); 


% --- Executes during object creation, after setting all properties.
function SelLine_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in SelLine.
function SelLine_Callback(hObject, eventdata, handles)
% hObject    handle to SelLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SelLine contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelLine
SelectedSimResultNumber=get(handles.SelectSimResults,'Value');
handles.SimResultsList{SelectedSimResultNumber}.SelLine=get(hObject,'Value');
guidata(gcbo,handles);
RePlotBER;

% --- Executes during object creation, after setting all properties.
function SelColor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in SelColor.
function SelColor_Callback(hObject, eventdata, handles)
% hObject    handle to SelColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SelColor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelColor
SelectedSimResultNumber=get(handles.SelectSimResults,'Value');
handles.SimResultsList{SelectedSimResultNumber}.SelColor=get(hObject,'Value');
guidata(gcbo,handles);
RePlotBER;


% --- Executes during object creation, after setting all properties.
function SelPoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in SelPoints.
function SelPoints_Callback(hObject, eventdata, handles)
% hObject    handle to SelPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SelPoints contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelPoints
SelectedSimResultNumber=get(handles.SelectSimResults,'Value');
handles.SimResultsList{SelectedSimResultNumber}.SelPoints=get(hObject,'Value');
guidata(gcbo,handles);
RePlotBER;


% --- Executes on button press in VisibleCheckBox.
function VisibleCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to VisibleCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VisibleCheckBox
SelectedSimResultNumber=get(handles.SelectSimResults,'Value');
handles.SimResultsList{SelectedSimResultNumber}.Visible=get(hObject,'Value');
guidata(gcbo,handles);
RePlotBER;


% --- Executes on button press in LegendCheckbox.
function LegendCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to LegendCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LegendCheckbox
% generate legend if ON
SimResultsList=handles.SimResultsList;
if get(handles.DetachCheckbox,'Value')==1
    figure(handles.DetachedFigureHandle);
end;
if get(handles.LegendCheckbox,'Value')==1
    LegendText={};
    for SimResultNumber=[1:size(SimResultsList,2)]
        if SimResultsList{SimResultNumber}.Visible==1
            LegendText={LegendText{:},SimResultsList{SimResultNumber}.LegendText};
        end;
    end;
    legend(LegendText);
else 
    legend off;
end;


% --- Executes during object creation, after setting all properties.
function CommentTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CommentTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function CommentTextBox_Callback(hObject, eventdata, handles)
% hObject    handle to CommentTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CommentTextBox as text
%        str2double(get(hObject,'String')) returns contents of CommentTextBox as a double
SelectedSimResultNumber=get(handles.SelectSimResults,'Value');
handles.SimResultsList{SelectedSimResultNumber}.CommentText=get(hObject,'String');
guidata(gcbo,handles);


% --- Executes on button press in EditLegendTextButton.
function EditLegendTextButton_Callback(hObject, eventdata, handles)
% hObject    handle to EditLegendTextButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function EditLegendText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditLegendText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function EditLegendText_Callback(hObject, eventdata, handles)
% hObject    handle to EditLegendText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditLegendText as text
%        str2double(get(hObject,'String')) returns contents of EditLegendText as a double
SelectedSimResultNumber=get(handles.SelectSimResults,'Value');
handles.SimResultsList{SelectedSimResultNumber}.LegendText=get(hObject,'String');
guidata(gcbo,handles);
UpdateSelectSimResults;
set(handles.EditLegendText,'Visible','off');
set(handles.SelectSimResults,'Visible','on');
% Redraw legend if needed
SimResultsList=handles.SimResultsList;
if get(handles.LegendCheckbox,'Value')==1
    LegendText={};
    for SimResultNumber=[1:size(SimResultsList,2)]
        if SimResultsList{SimResultNumber}.Visible==1
            LegendText={LegendText{:},SimResultsList{SimResultNumber}.LegendText};
        end;
    end;
    legend off;
    legend(LegendText);
else 
    legend off;
end;

% --- Executes on button press in EditLegendButton.
function EditLegendButton_Callback(hObject, eventdata, handles)
% hObject    handle to EditLegendButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SelectedSimResultNumber=get(handles.SelectSimResults,'Value');
set(handles.EditLegendText,'Visible','on');
set(handles.EditLegendText,'String',handles.SimResultsList{SelectedSimResultNumber}.LegendText);
set(handles.SelectSimResults,'Visible','off');
guidata(gcbo,handles);


% --- Executes on button press in HighlightCheckbox.
function HighlightCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to HighlightCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HighlightCheckbox
RePlotBER;


% --- Executes during object creation, after setting all properties.
function FileNameTextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileNameTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function FileNameTextbox_Callback(hObject, eventdata, handles)
% hObject    handle to FileNameTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FileNameTextbox as text
%        str2double(get(hObject,'String')) returns contents of FileNameTextbox as a double


% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileName=get(handles.FileNameTextbox,'String');
FileName=sprintf('./results/%s',FileName);
SimResultsList=handles.SimResultsList;
FileAttributes=fileattrib(FileName);
if FileAttributes == 0
    % New File (does not exist yet)... just write it
    save(FileName,'SimResultsList');
else 
    % File already exists... check if it should be overwritten
    Overwrite = questdlg('Save: File already exists. Overwrite?');
    if strcmp(Overwrite,'Yes')
        save(FileName,'SimResultsList');
    end;
end;

% --- Executes on button press in LoadButton.
function LoadButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileName=get(handles.FileNameTextbox,'String');
FileName=sprintf('./results/%s',FileName);
load(FileName);
if isfield(handles,'SimResultsList')==0
    handles.SimResultsList=SimResultsList;
elseif get(handles.AddToLoadedCheckbox,'Value')==0
    handles.SimResultsList=SimResultsList;
else
    handles.SimResultsList={handles.SimResultsList{:},SimResultsList{:}};
end;
guidata(gcbo,handles);
UpdateSelectSimResults;
RePlotBER;


% --- Executes on button press in DetachCheckbox.
function DetachCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to DetachCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DetachCheckbox
if (get(hObject,'Value')==1) && isfield(handles,'DetachedFigureHandle')
    handles.DetachedFigureHandle=figure(handles.DetachedFigureHandle);
elseif get(hObject,'Value')==1
    handles.DetachedFigureHandle=figure;
end;    
guidata(gcbo,handles);


% --- Executes on button press in BrowseButton.
function BrowseButton_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d = dir('results');
str = {d.name};
[s,v] = listdlg('PromptString','Select a file:',...
    'SelectionMode','single',...
    'ListString',str,...
    'ListSize',[300,200]);
if v==1
    FileName=str{s};
    set(handles.FileNameTextbox,'String',FileName);
    guidata(gcbo,handles);
end;


% --- Executes on button press in DeleteButton.
function DeleteButton_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SelectedSimResultNumber=get(handles.SelectSimResults,'Value');
RequesterString=sprintf('Delete entry: %s ?',handles.SimResultsList{SelectedSimResultNumber}.LegendText);
DeleteYesNo = questdlg(RequesterString,'Delete: Are you sure?','Yes','No','No');
if strcmp(DeleteYesNo,'Yes')
    if SelectedSimResultNumber==size(handles.SimResultsList,2)
        set(handles.SelectSimResults,'Value',SelectedSimResultNumber-1);
    end;
    handles.SimResultsList={handles.SimResultsList{1:SelectedSimResultNumber-1},handles.SimResultsList{SelectedSimResultNumber+1:size(handles.SimResultsList,2)}};
    guidata(gcbo,handles);
    UpdateSelectSimResults;
    RePlotBER;
end;
