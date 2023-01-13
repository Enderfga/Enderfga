
% plot SYSU 
clear
clc
close all
load 'SI_dynamic_fomation_manv_results.mat'
fs = 24; % Font size in the figure
avgMs = 5; % Average marker size
lw = 3.5; % Linewidth
tf = max(t);
Adj_plot_s = [0, 1, 1, 0, 0, 0; ...
    1, 0, 0, 0, 0, 0; ...
    1, 0, 0, 0, 0, 1; ...
    0, 0, 0, 0, 1, 0; ...
    0, 0, 0, 1, 0, 1; ...
    0, 0, 1, 0, 1, 0];
        


%% Plot trajectory

%% plot S  initial
figure
xlim([-1, 3]);
ylim([-0.6, 0.6])
hold on
set(gca, 'DataAspectRatio', [1, 1, 1], 'Box', 'on', 'FontSize', fs)
%CurrFrame = getframe(gcf);   % 获取像素，否则无法显示动画
%im = frame2im(CurrFrame);  
%[A,map] = rgb2ind(im,256);  % 将RGB图像转换为索引图像
%imwrite(A,map,'SI.gif','gif','LoopCount',Inf,'DelayTime',0.01);  % DelayTime表示写入的时间间隔
for ii = 1:1:length(t)
    for jj = 1:n
        plot(xx(ii, jj), yy(ii, jj), 'k.', 'MarkerSize', avgMs);
        %CurrFrame = getframe(gcf);   % 获取像素，否则无法显示动画
%im = frame2im(CurrFrame);  
%[A,map] = rgb2ind(im,256);  % 将RGB图像转换为索引图像
%imwrite(A,map,'SI.gif','gif','WriteMode','append','DelayTime',0);
    end
    if (ii == 1) || (ii == length(t))
        for i0 = 1:n - 1
            for j0 = i0 + 1:n
                if Adj_plot_s(i0, j0) == 1
                    line([xx(ii, i0), xx(ii, j0)], [yy(ii, i0), yy(ii, j0)], ...
                        'LineWidth', lw)
%CurrFrame = getframe(gcf);   % 获取像素，否则无法显示动画
%im = frame2im(CurrFrame);  
%[A,map] = rgb2ind(im,256);  % 将RGB图像转换为索引图像
%imwrite(A,map,'SI.gif','gif','WriteMode','append','DelayTime',0);
                end
            end
        end
    end
    %     pause(0.05) % Uncomment this if animation is needed
end
for i1 = 1:n
    hh1 = plot(xx(3, i1), yy(3, i1), 'rs', 'MarkerSize', 1.4*avgMs);
    hh2 = plot(xx(length(t), i1), yy(length(t), i1), 'ro', ...
        'MarkerSize', 1.4*avgMs);
    %CurrFrame = getframe(gcf);   % 获取像素，否则无法显示动画
%im = frame2im(CurrFrame);  
%[A,map] = rgb2ind(im,256);  % 将RGB图像转换为索引图像
%imwrite(A,map,'SI.gif','gif','WriteMode','append','DelayTime',0);
end

%% plot S->Y 
for ii = 1:1:length(t)
    for jj = 1:n
        plot(xx_Y(ii, jj), yy_Y(ii, jj), 'k.', 'MarkerSize', avgMs);
        %CurrFrame = getframe(gcf);   % 获取像素，否则无法显示动画
%im = frame2im(CurrFrame);  
%[A,map] = rgb2ind(im,256);  % 将RGB图像转换为索引图像
%imwrite(A,map,'SI.gif','gif','WriteMode','append','DelayTime',0);
    end
    if (ii == 1)
        for i0 = 1:n - 1
            for j0 = i0 + 1:n
                if Adj_plot_s(i0, j0) == 1
                    line([xx_Y(ii, i0), xx_Y(ii, j0)], [yy_Y(ii, i0), yy_Y(ii, j0)], ...
                        'LineWidth', lw)
                    %CurrFrame = getframe(gcf);   % 获取像素，否则无法显示动画
%im = frame2im(CurrFrame);  
%[A,map] = rgb2ind(im,256);  % 将RGB图像转换为索引图像
%imwrite(A,map,'SI.gif','gif','WriteMode','append','DelayTime',0);
                end
            end
        end
    end
    %     pause(0.05) % Uncomment this if animation is needed
end
for i1 = 1:n
    hh1 = plot(xx_Y(3, i1), yy_Y(3, i1), 'rs', 'MarkerSize', 1.4*avgMs);
    hh2 = plot(xx_Y(length(t), i1), yy_Y(length(t), i1), 'ro', ...
        'MarkerSize', 1.4*avgMs);
    %CurrFrame = getframe(gcf);   % 获取像素，否则无法显示动画
%im = frame2im(CurrFrame);  
%[A,map] = rgb2ind(im,256);  % 将RGB图像转换为索引图像
%imwrite(A,map,'SI.gif','gif','WriteMode','append','DelayTime',0);
end


%% plot Y --> s
Adj_plot_y = [0, 0, 1, 0, 0, 0; ...
    0, 0, 1, 0, 0, 0; ...
    0, 0, 0, 1, 0, 0; ...
    0, 0, 1, 0, 0, 0; ...
    0, 0, 0, 0, 0, 0; ...
    0, 0, 0, 0, 0, 0];

for ii = 1:1:length(t)
    for jj = 1:n
        plot(xx_S(ii, jj), yy_S(ii, jj), 'k.', 'MarkerSize', avgMs);
        %CurrFrame = getframe(gcf);   % 获取像素，否则无法显示动画
%im = frame2im(CurrFrame);  
%[A,map] = rgb2ind(im,256);  % 将RGB图像转换为索引图像
%imwrite(A,map,'SI.gif','gif','WriteMode','append','DelayTime',0);
    end
    if (ii == 1)
        for i0 = 1:n - 1
            for j0 = i0 + 1:n
                if Adj_plot_y(i0, j0) == 1
                    line([xx_S(ii, i0), xx_S(ii, j0)], [yy_S(ii, i0), yy_S(ii, j0)], ...
                        'LineWidth', lw)
                    %CurrFrame = getframe(gcf);   % 获取像素，否则无法显示动画
%im = frame2im(CurrFrame);  
%[A,map] = rgb2ind(im,256);  % 将RGB图像转换为索引图像
%imwrite(A,map,'SI.gif','gif','WriteMode','append','DelayTime',0);
                end
            end
        end
    end
    %     pause(0.05) % Uncomment this if animation is needed
end
for i1 = 1:n
    hh1 = plot(xx_S(2, i1), yy_S(2, i1), 'rs', 'MarkerSize', 1.4*avgMs);
    hh2 = plot(xx_S(length(t), i1), yy_S(length(t), i1), 'ro', ...
        'MarkerSize', 1.4*avgMs);
    %CurrFrame = getframe(gcf);   % 获取像素，否则无法显示动画
%im = frame2im(CurrFrame);  
%[A,map] = rgb2ind(im,256);  % 将RGB图像转换为索引图像
%imwrite(A,map,'SI.gif','gif','WriteMode','append','DelayTime',0);
end

%% plot s--> u
Adj_plot_s = [0, 1, 1, 0, 0, 0; ...
    1, 0, 0, 0, 0, 0; ...
    1, 0, 0, 0, 0, 1; ...
    0, 0, 0, 0, 1, 0; ...
    0, 0, 0, 1, 0, 1; ...
    0, 0, 1, 0, 1, 0];
Adj_plot_u = [0, 0, 1, 0, 0, 0; ...
    0, 0, 0, 0, 0, 1; ...
    1, 0, 0, 1, 0, 0; ...
    0, 0, 1, 0, 1, 0; ...
    0, 0, 0, 1, 0, 1; ...
    0, 1, 0, 0, 1, 0];
for ii = 1:1:length(t)
    for jj = 1:n
        plot(xx_U(ii, jj), yy_U(ii, jj), 'k.', 'MarkerSize', avgMs);
        %CurrFrame = getframe(gcf);   % 获取像素，否则无法显示动画
%im = frame2im(CurrFrame);  
%[A,map] = rgb2ind(im,256);  % 将RGB图像转换为索引图像
%imwrite(A,map,'SI.gif','gif','WriteMode','append','DelayTime',0);
    end
    if (ii == 1)
        for i0 = 1:n - 1
            for j0 = i0 + 1:n
                if Adj_plot_s(i0, j0) == 1
                    line([xx_U(ii, i0), xx_U(ii, j0)], [yy_U(ii, i0), yy_U(ii, j0)], ...
                        'LineWidth', lw)
                    %CurrFrame = getframe(gcf);   % 获取像素，否则无法显示动画
%im = frame2im(CurrFrame);  
%[A,map] = rgb2ind(im,256);  % 将RGB图像转换为索引图像
%imwrite(A,map,'SI.gif','gif','WriteMode','append','DelayTime',0);
                end
            end
        end
    end
    if ii == length(t)
        for i0 = 1:n - 1
            for j0 = i0 + 1:n
                if Adj_plot_u(i0, j0) == 1
                    line([xx_U(ii, i0), xx_U(ii, j0)], [yy_U(ii, i0), yy_U(ii, j0)], ...
                        'LineWidth', lw)
                    %CurrFrame = getframe(gcf);   % 获取像素，否则无法显示动画
%im = frame2im(CurrFrame);  
%[A,map] = rgb2ind(im,256);  % 将RGB图像转换为索引图像
%imwrite(A,map,'SI.gif','gif','WriteMode','append','DelayTime',0);
                end
            end
        end
    end
    %     pause(0.05) % Uncomment this if animation is needed
end

for i1 = 1:n
    hh1 = plot(xx_U(2, i1), yy_U(2, i1), 'rs', 'MarkerSize', 1.4*avgMs);
    hh2 = plot(xx_U(length(t), i1), yy_U(length(t), i1), 'ro', ...
        'MarkerSize', 1.4*avgMs);
    %CurrFrame = getframe(gcf);   % 获取像素，否则无法显示动画
%im = frame2im(CurrFrame);  
%[A,map] = rgb2ind(im,256);  % 将RGB图像转换为索引图像
%imwrite(A,map,'SI.gif','gif','WriteMode','append','DelayTime',0);
end

% %% Plot distance error %%
% nn = 1:1:length(t); % Plot distance error (e) using less points
% figure
% grid on
% hold on
% set(gca, 'Box', 'on', 'FontSize', fs)
% plot(t(nn), e12(nn), 'LineWidth', lw, 'Color', [0, 0, 1]);
% plot(t(nn), e23(nn), 'LineWidth', lw, 'Color', [0, 0.5, 0]);
% plot(t(nn), e34(nn), 'LineWidth', lw, 'Color', [1, 0, 0]);
% plot(t(nn), e45(nn), 'LineWidth', lw, 'Color', [0, 0, 0]);
% plot(t(nn), e15(nn), 'LineWidth', lw, 'Color', [0.75, 0, 0.75]);
% plot(t(nn), e13(nn), 'LineWidth', lw, 'Color', [0, 0, 1]);
% plot(t(nn), e14(nn), 'LineWidth', lw, 'Color', [0, 0.5, 0]);
% plot(t(nn), e24(nn), 'LineWidth', lw, 'Color', [1, 0, 0]);
% plot(t(nn), e25(nn), 'LineWidth', lw, 'Color', [0, 0, 0]);
% plot(t(nn), e35(nn), 'LineWidth', lw, 'Color', [0.75, 0, 0.75]);
% plot(t(nn), e16(nn), 'LineWidth', lw, 'Color', [0, 0, 1]);
% plot(t(nn), e26(nn), 'LineWidth', lw, 'Color', [0, 0.5, 0]);
% plot(t(nn), e36(nn), 'LineWidth', lw, 'Color', [1, 0, 0]);
% plot(t(nn), e46(nn), 'LineWidth', lw, 'Color', [0, 0, 0]);
% plot(t(nn), e56(nn), 'LineWidth', lw, 'Color', [0.75, 0, 0.75]);
% xlabel('Time')
% ylabel('e_i_j')
% xlim([0, 1])
% 
% %% Plot control input %%
% figure
% subplot(211)
% grid on
% hold on
% set(gca, 'Box', 'on', 'FontSize', fs)
% 
% plot(t(nn), u(1, nn), 'LineWidth', lw, 'Color', [0, 0, 1]);
% plot(t(nn), u(3, nn), 'LineWidth', lw, 'Color', [0, 0.5, 0]);
% plot(t(nn), u(5, nn), 'LineWidth', lw, 'Color', [1, 0, 0]);
% plot(t(nn), u(7, nn), 'LineWidth', lw, 'Color', [0, 0, 0]);
% plot(t(nn), u(9, nn), 'LineWidth', lw, 'Color', [0.75, 0, 0.75]);
% plot(t(nn), u(11, nn), 'LineWidth', lw, 'Color', [0.75, 0, 0.75]);
% xlim([0, tf])
% xlabel('Time')
% ylabel('u_i_x')
% legend('u_1_x', 'u_2_x', 'u_3_x', 'u_4_x', 'u_5_x', 'Location', 'NorthEastOutside')
% subplot(212)
% grid on
% hold on
% set(gca, 'Box', 'on', 'FontSize', fs)
% plot(t(nn), u(2, nn), 'LineWidth', lw, 'Color', [0, 0, 1]);
% plot(t(nn), u(4, nn), 'LineWidth', lw, 'Color', [0, 0.5, 0]);
% plot(t(nn), u(6, nn), 'LineWidth', lw, 'Color', [1, 0, 0]);
% plot(t(nn), u(8, nn), 'LineWidth', lw, 'Color', [0, 0, 0]);
% plot(t(nn), u(10, nn), 'LineWidth', lw, 'Color', [0.75, 0, 0.75]);
% plot(t(nn), u(12, nn), 'LineWidth', lw, 'Color', [0.75, 0, 0.75]);
% xlim([0, tf])
% legend('u_1_y', 'u_2_y', 'u_3_y', 'u_4_y', 'u_5_y', 'Location', 'NorthEastOutside')
% xlabel('Time')
% ylabel('u_i_y')
