function [ ] = updateStatus( handles,op,text )
%UPDATESTATUS Summary of this function goes here
%   Detailed explanation goes here
if op==1
    set(handles.stat_txt,'String',text);
else
    set(handles.imFile_txt,'String',text);
end

end

