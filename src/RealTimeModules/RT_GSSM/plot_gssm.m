function plot_gssm(Yh_k,time)
h=figure(findobj('tag','RT_gssm'));

ca=get(h,'CurrentAxes');
if(isempty(ca) || isempty(get(ca,'children')))
    plot(0,zeros(size(Yh_k)));
    hold on;
else
    children=get(ca,'children');
    time_all=get(children(1),'Xdata');
    for idx=1:size(Yh_k)
        data_all=get(children(idx),'Ydata');
        set(children(idx),'Ydata',[data_all Yh_k(idx)],...
            'Xdata',[time_all time]);
    end
    
end

return