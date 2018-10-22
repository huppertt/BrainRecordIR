function SaveComments(gcbo)

richtext=get(gcbo,'UserData');
text=richtext.Text;

if(~isempty(text))
    fid=fopen('Comments.txt','a');
    fprintf(fid,'\n****************************************');
    fprintf(fid,'\nComments Added: %s\n\n',datestr(now));
    fprintf(fid,'\n%s',text);
    fclose(fid);
end

closereq;
return
