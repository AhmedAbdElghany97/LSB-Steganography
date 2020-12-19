function varargout = LSB(varargin)
% Last Modified by GUIDE v2.5 23-Jun-2019 11:42:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LSB_OpeningFcn, ...
                   'gui_OutputFcn',  @LSB_OutputFcn, ...
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


% --- Executes just before LSB is made visible.
function LSB_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LSB (see VARARGIN)

% Choose default command line output for LSB
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LSB wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LSB_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in hide_tab.
function hide_tab_Callback(hObject, eventdata, handles)
set(handles.hide_panel,          'visible','on')  
set(handles.extract_panel,         'visible','off' ) 





% --- Executes on button press in extract_gui.
function extract_gui_Callback(hObject, eventdata, handles)
set(handles.hide_panel,          'visible','off')  
set(handles.extract_panel,         'visible','on' ) 



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in origimg_sel.
function origimg_sel_Callback(hObject, eventdata, handles)
[File,Path] = uigetfile('*.bmp','Select Image');
if isequal(File,0)
   disp('User selected Cancel')
else
   path = strcat(Path,File);
   handles.covImg = imread(path);
   handles.cimg = 1;
   axes(handles.axes1); imshow(handles.covImg);
   guidata(hObject,handles);
   set(handles.orig_path,'String',path);
   set(handles.origimg_nor,'enable','on');
   set(handles.origimg_clear,'enable','on');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
set(gca,'visible','off')



% --- Executes on button press in origimg_nor.
function origimg_nor_Callback(hObject, eventdata, handles)
figure, imshow(handles.covImg); title('Original Image');
% hObject    handle to origimg_nor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in origimg_clear.
function origimg_clear_Callback(hObject, eventdata, handles)
cla(handles.axes1)
set(handles.origimg_nor,'enable','off');
set(handles.origimg_clear,'enable','off');
set(handles.orig_path,'String','.');
handles.cimg=0;
guidata(hObject,handles);
% hObject    handle to origimg_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in text_sel.
function text_sel_Callback(hObject, eventdata, handles)
[File,Path] = uigetfile('*.txt','Select Text File');
if isequal(File,0)
   disp('User selected Cancel')
else
    handles.f_id=fopen(File,'r');
    handles.ctxt=1;
    handles.filename_txt=strcat(Path,File);
    guidata(hObject,handles);
    set(handles.text_path,'String',handles.filename_txt);
    dr=dir(handles.filename_txt); size=num2str(dr.bytes);
    filesize=strcat(size,' bytes');
    set(handles.text_size,'String',filesize);
end


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
set(gca,'visible','off')


% --- Executes on button press in stegoimg_folder.
function stegoimg_folder_Callback(hObject, eventdata, handles)
winopen(handles.s_path);


% --- Executes on button press in encrypt.
function encrypt_Callback(hObject, eventdata, handles)
if isequal(handles.cimg,1)&&isequal(handles.ctxt,1)
    waitfor(msgbox('Select path to save'));
    [file,path,indx] = uiputfile('stego-img.bmp');
    if isequal(file,0)
        disp('User selected Cancel')
    else
        handles.stego_img=LSB_HIDE(handles.covImg,handles.filename_txt);
        handles.s_path=path;
        guidata(hObject,handles);
        imwrite(handles.stego_img,file)
        axes(handles.axes2); imshow(handles.stego_img);
        set(handles.stegoimg_folder,'enable','on');
        set(handles.stegoimg_nor,'enable','on');
        set(handles.stego_path,'String',strcat(path,file));
        set(handles.sh_psnr,'String',Calc_PSNR(handles.covImg,handles.stego_img));
        set(handles.statistics,'enable','on');
    end
elseif isequal(handles.cimg,0)&&isequal(handles.ctxt,1)
    msgbox('Please select the Cover Image');
elseif isequal(handles.cimg,1)&&isequal(handles.ctxt,0)
    msgbox('Please select a Text File');
else
    msgbox('Please select the following  [Cover Image - Text File]');
end


% --- Executes on button press in stegoimg_nor.
function stegoimg_nor_Callback(hObject, eventdata, handles)
figure, imshow(handles.stego_img); title('Stego-Image');



% --- Executes on button press in statistics.
function statistics_Callback(hObject, eventdata, handles)
figure,
subplot(2,2,1),imshow(handles.covImg);title('Original image');
subplot(2,2,3),imhist(handles.covImg);title('Original image Histogram');
subplot(2,2,2),imshow(handles.stego_img);title('StegoImage');
subplot(2,2,4),imhist(handles.stego_img);title('Stego-Image Histogram');



% --- Executes on button press in reset_bttn.
function reset_bttn_Callback(hObject, eventdata, handles)
cla(handles.axes1)
set(handles.orig_path,'String','.');
set(handles.origimg_nor,'enable','off');
set(handles.origimg_clear,'enable','off');

cla(handles.axes2)
set(handles.stegoimg_folder,'enable','off');
set(handles.stegoimg_nor,'enable','off');
set(handles.statistics,'enable','off');
set(handles.stego_path,'String','.');

set(handles.text_path,'String','.');
set(handles.text_size,'String','.');
set(handles.sh_psnr,'String','.');
handles.ctxt=0;
handles.cimg=0;


cla(handles.axes3)
set(handles.p2_stg_nor,'enable','off');
set(handles.p2_stg_clear,'enable','off');
set(handles.p2_stg_path,'String','.');
handles.eximg=0;
guidata(hObject,handles);





% --- Executes on button press in close_btn.
function close_btn_Callback(hObject, eventdata, handles)
Close all;


% --- Executes during object creation, after setting all properties.
function hide_panel_CreateFcn(hObject, eventdata, handles)
handles.ctxt=0;
handles.cimg=0;
guidata(hObject,handles);


% --- Executes on button press in p2_stg_sel.
function p2_stg_sel_Callback(hObject, eventdata, handles)
[File,Path] = uigetfile('*.bmp','Select Image');
if isequal(File,0)
   disp('User selected Cancel')
else
   handles.eximg=1;
   guidata(hObject,handles);
   path = strcat(Path,File);
   handles.p2_stg_img = imread(path);
   axes(handles.axes3); imshow(handles.p2_stg_img);
   guidata(hObject,handles);
   set(handles.p2_stg_nor,'enable','on');
   set(handles.p2_stg_clear,'enable','on');
   set(handles.p2_stg_path,'String',path);
end



% --- Executes on button press in p2_stg_nor.
function p2_stg_nor_Callback(hObject, eventdata, handles)
figure, imshow(handles.p2_stg_img); title('Stego-Image');


% --- Executes on button press in p2_stg_clear.
function p2_stg_clear_Callback(hObject, eventdata, handles)
cla(handles.axes3)
set(handles.p2_stg_nor,'enable','off');
set(handles.p2_stg_clear,'enable','off');
set(handles.p2_stg_path,'String','.');
handles.eximg=0;
guidata(hObject,handles);


% --- Executes on button press in extract.
function extract_Callback(hObject, eventdata, handles)
if isequal(handles.eximg,1)
    waitfor(msgbox('Select path to save'));
    [file,path,indx] = uiputfile('Recover-msg.txt');
    if isequal(file,0)
        disp('User selected Cancel')
    else
        LSB_EXTRACT(handles.p2_stg_img,path,file);
        msgbox('Extracted Done')
        guidata(hObject,handles);
    end
else
    msgbox('Please select the Stego-Image');
end


% --- Executes during object creation, after setting all properties.
function extract_panel_CreateFcn(hObject, eventdata, handles)
handles.eximg=0;
guidata(hObject,handles);
