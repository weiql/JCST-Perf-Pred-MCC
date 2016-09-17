load errorbar_normal.data
load errorbar_component.data
load errorbar_device.data

y = errorbar_component;                 % Simulated process data
randsample(y,1)
capable = @(x)randsample(x,1);  % Process capability
%ci = bootci(1000000,{capable,y},'alpha', 0.32)            % BCa confidence interval

%y = [median(errorbar_normal,2) median(errorbar_component,2) median(errorbar_device,2)];
y = [mean(errorbar_normal,2) mean(errorbar_component,2) mean(errorbar_device,2)];
%e = [std(errorbar_normal,1,2) std(errorbar_component,1,2) std(errorbar_device,1,2)];
%e = [paramci(fitdist(errorbar_normal', 'Kernel', 'Kernel', 'triangle', 'Support', 'unbounded', 'Width', 0.1)) 
%    paramci(fitdist(errorbar_component','Kernel', 'Kernel', 'Kernel', 'normal', 'Support', 'unbounded', 'Width', 0.1))
%    paramci(fitdist(errorbar_device','Kernel', 'Kernel', 'Kernel', 'normal', 'Support', 'unbounded', 'Width', 0.1))];
%L = y - [prctile(errorbar_normal, 2.5) prctile(errorbar_component, 2.5) prctile(errorbar_device, 2.5)];
L = y - [prctile(errorbar_normal, 16) prctile(errorbar_component, 16) prctile(errorbar_device, 16)];
%U = [prctile(errorbar_normal, 97.5) prctile(errorbar_component, 97.5) prctile(errorbar_device, 97.5)] - y;
U = [prctile(errorbar_normal, 84) prctile(errorbar_component, 84) prctile(errorbar_device, 84)] - y;
figure
%errorbar(y,e,'rx')
%errorbar([1 2 3],y,L,U,'rx')
b = bar(y);
ch = get(b,'children');
set(ch,'FaceVertexCData',[0 0 1;0 1 1;1 1 1;])
hold on
errorbar([1 2 3],y,L,U,'rx');%errorbar(y,e);
%set(h(1),'color','r')
%set(h(2),'LineStyle','none')
hold off


%{
% 生成示例数据
x=1:10;
y=cumsum(randn(1,10));
lower = y - (rand(1,10));
upper = y + (rand(1,10));

% 由于errorbar函数使用相对差值在图形上绘图，所以
% 需要将绝对差值转变为相对差值。
L = y - lower;
U = upper -y;

% 绘图时需要设定 hold on
% 柱状图
clf;
figure(1);
hold on;
bar(x,y);
% 此处需要隐藏折线
errorbar(x,y,L,U,'Marker','none','LineStyle','none');

% 折线图
figure(2);
hold('on');
plot( x, y);
errorbar( x, y, L, U);
%}