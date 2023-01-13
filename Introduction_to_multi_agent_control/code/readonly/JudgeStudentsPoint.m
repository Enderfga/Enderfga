load '6formation_results.mat'

[~, num] = size(x0);
pointNum = size(get(thtraj1, 'XData'),2);
k = 0.5;

%% statistics position error, include x, y and z
% if you add the drone num, you should add the additional position error
absPositionErrormean = (sum(abs(get(thtraj1, 'XData')-get(ehtraj1, 'XData'))+abs(get(thtraj1, 'YData')-get(ehtraj1, 'YData'))+abs(get(thtraj1, 'ZData')-get(ehtraj1, 'ZData')) ...
    +abs(get(thtraj2, 'XData')-get(ehtraj2, 'XData'))+abs(get(thtraj2, 'YData')-get(ehtraj2, 'YData'))+abs(get(thtraj2, 'ZData')-get(ehtraj2, 'ZData')) ...
    +abs(get(thtraj3, 'XData')-get(ehtraj3, 'XData'))+abs(get(thtraj3, 'YData')-get(ehtraj3, 'YData'))+abs(get(thtraj3, 'ZData')-get(ehtraj3, 'ZData')) ...
    +abs(get(thtraj4, 'XData')-get(ehtraj4, 'XData'))+abs(get(thtraj4, 'YData')-get(ehtraj4, 'YData'))+abs(get(thtraj4, 'ZData')-get(ehtraj4, 'ZData')) ...
    +abs(get(thtraj5, 'XData')-get(ehtraj5, 'XData'))+abs(get(thtraj5, 'YData')-get(ehtraj5, 'YData'))+abs(get(thtraj5, 'ZData')-get(ehtraj5, 'ZData')) ...
    +abs(get(thtraj6, 'XData')-get(ehtraj6, 'XData'))+abs(get(thtraj6, 'YData')-get(ehtraj6, 'YData'))+abs(get(thtraj6, 'ZData')-get(ehtraj6, 'ZData'))))/num/pointNum; % 203.1524



finalPoint = absPositionErrormean*100 + time;

disp(finalPoint);    %20.3076
