load hist_plot.data
data = hist_plot;
%subplot(2,1,1);
hist(data,20);
%h = histfit(data, 20, 'tlocationscale');
%{
h = histfit(data, 20, 'normal');
mu = mean(data);% 计算平均值
a=80000;%输入阈值
outliers = abs(data - mu) > a;%求出离群值的位置
nout = sum(outliers) % 计算离群值的个数并显示
data(outliers) = [];%去除离群值
subplot(2,1,2);
h = histfit(data, 20, 'normal');
%}

%{
x = data;
[mu,sigma]=normfit(x);
[y,x]=hist(x,20);
bar(x,y,'FaceColor','r','EdgeColor','w');
box off;
xlim([mu-3*sigma,mu+3*sigma]);
a2=axes;
ezplot(@(x)normpdf(x,mu,sigma),[mu-3*sigma,mu+3*sigma]);
set(a2,'box','off','yaxislocation','right','color','none');
%title '频数直方图与正态分布密度函数（拟合）';
%}
%{
x = data;
figure;
histfit(x, 20);%正态曲线拟合
normfit(x);%正态性检验（离散点是否分布在一条直线上，表明样本来自正态分布，否则是非正态分布）
%参数估计 
[muhat,sigmahat,muci,sigmaci]=normfit(x);%muhat均值,sigmahat方差,muci均值的0.95置信区间,sigmaci方差的0.95置信区间



%假设检验（现在在方差未知的情况下，检验均值是否为mahat）
[h,sig,ci]=ttest(x,muhat); %h=0,接受假设，均值=mahat
%其中h为布尔变量，h=0表示不拒绝零假设，说明均值为mahat的假设合理。若h=1则相反；
%ci表示0.95的置信区间。
%sig若比0.5大则不能拒绝零假设，否则相反。

%%更正式的正态性检验方法
%kstest Kolmogorov-Smirnov正态性检验，将样本与标准正态分布（均值为0，方差为1）进行对比，不符合正态分布返回1，否则返回0；该函数也可以用于其它分布类型的检验；
[h,p,jbstat,cv]=kstest(x); %H0: 服从正态N（0,1）

%lillietest Lilliefors test。 与kstest不同，检验目标不是标准正态，而是具有与样本相同均值和方差的正态分布。
[h,p,istat,cv]=lillietest(x); %H0: 服从N（mu,sigma2）;

%jbtest Jarque-Bera test。与 Lilliefors test 类似，但不适用于小样本的情况。
[h,p,jbstat,cv]=jbtest(x); %H0：服从正态N(mu,sigma2)   
%}