function tree=UITree_ted(RootDir,extensions,SelectionChangeFcn,parent)
%This will make a uitree of a root directory and display all files with a
%given extension

myExpfcnAll=@(tree,value)myExpfcn(tree,value,extensions,RootDir);

if(~exist('SelectionChangeFcn'))
    SelectionChangeFcn=[];
end
if(~exist('parent'))
    parent=[];
    position=[];
else
    units=get(parent,'units');
    set(parent,'units','pixel');
    position=get(parent,'position');
    set(parent,'units',units);
    
    if(strcmp(get(get(parent,'parent'),'type'),'uipanel'))
        set(get(parent,'parent'),'units','pixel');
        position2=get(get(parent,'parent'),'position');
        positionN(1)=position2(1)+position(1);
        positionN(2)=position2(2)+position(2);
        positionN(3)=position(3);
        positionN(4)=position(4);
        position=positionN;
        set(get(parent,'parent'),'units','normalized');
        
    end
    
end


tree = uitree('Root', 'D:\','ExpandFcn', myExpfcnAll,...
    'SelectionChangeFcn', SelectionChangeFcn,'parent',parent,...
    'position',position);

return

function nodes = myExpfcn(tree,value,extensions,RootDir)

    count = 0;
    ch = dir(value);
    
   for i=1:length(ch)
        if (any(strcmp(ch(i).name, {'.', '..', ''})) == 0)
            count = count + 1;
            if ch(i).isdir
                
                if(isempty(strfind(RootDir,[value ch(i).name])) &... 
                    isempty(strfind([value ch(i).name],RootDir)))
                       count=count-1;
                     continue;
                 end
                             
                iconpath = [matlabroot, '/toolbox/matlab/icons/foldericon.gif'];
            else
                if(isempty(strfind(ch(i).name,extensions)))
                    count=count-1;
                    continue;
                end
                
                iconpath = [matlabroot, '/toolbox/matlab/icons/pageicon.gif'];
            end
            nodes(count) = uitreenode([value, ch(i).name, filesep], ...
                ch(i).name, iconpath, ~ch(i).isdir);
        end
    end


if (count == 0)
    nodes = [];
end

return
