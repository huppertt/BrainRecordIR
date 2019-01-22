function ChangeProbeViewStats
% This controls the drawing of the stats view
global BrainRecordIRApp;

vtype = 'tstat';
Stats=BrainRecordIRApp.UIAxesStatsViewPlot.UserData;

if(isempty(Stats.conditions))
    return
end

% Need to make sure variables and link tables are in same order
Stats=Stats.sorted();

v=Stats.(vtype);

cond=BrainRecordIRApp.ListBoxWhichContrast.Value;
if(isempty(cond))
    BrainRecordIRApp.ListBoxWhichContrast.Value=BrainRecordIRApp.ListBoxWhichContrast.Items{1};
    cond=BrainRecordIRApp.ListBoxWhichContrast.Value;
end



    
if(contains(BrainRecordIRApp.DrawMode4StatsView.Value,'HbO2'))
    lst=find(ismember(Stats.variables.type,'hbo') & ismember(Stats.variables.cond,cond));
else
    
    lst=find(ismember(Stats.variables.type,'hbr') & ismember(Stats.variables.cond,cond));
end
v=v(lst);

vmax    = max(abs(v(:)));
vrange  = vmax*[-1 1];

thres=BrainRecordIRApp.ThreshholdEditField.Value;
if(contains(BrainRecordIRApp.DropDownStatsPorQ.Value,'q'))
    mask=(Stats.q(lst)<thres);
else
    mask=(Stats.p(lst)<thres);
end

% colormap
[~,cmap] = evalc('flipud( cbrewer(''div'',''RdBu'',128) )');
z = linspace(vrange(1), vrange(2), size(cmap,1))';

idx = bsxfun(@minus, v', z);
[~, idx] = min(abs(idx), [], 1);
colors = cmap(idx, :);

for i=1:size(colors,1)
    set(BrainRecordIRApp.Drawing.StatsHandles(i),'Color',colors(i,:));
    if(mask(i))
        set(BrainRecordIRApp.Drawing.StatsHandles(i),'LineStyle', '-', 'LineWidth', 8);
    else
        set(BrainRecordIRApp.Drawing.StatsHandles(i),'LineStyle', '--', 'LineWidth', 4);
        
    end
end

c = colorbar(BrainRecordIRApp.UIAxesStatsViewPlot); 
colormap(BrainRecordIRApp.UIAxesStatsViewPlot,cmap); 
caxis(BrainRecordIRApp.UIAxesStatsViewPlot,vrange);
       
% lst=find(BrainRecordIRApp.Drawing.MeasListAct);
% lst=(lst-1)*2+1+1*(~contains(BrainRecordIRApp.DrawMode4StatsView.Value,'HbO2'));
% HRF=Stats.HRF;
% cla(BrainRecordIRApp.UIAxes);
% h=HRF.draw(lst,0,BrainRecordIRApp.UIAxes);

return              


