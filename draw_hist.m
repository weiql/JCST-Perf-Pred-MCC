load hist_plot.data
data = hist_plot;
%subplot(2,1,1);
hist(data,20);
%h = histfit(data, 20, 'tlocationscale');
%{
h = histfit(data, 20, 'normal');
mu = mean(data);% ����ƽ��ֵ
a=80000;%������ֵ
outliers = abs(data - mu) > a;%�����Ⱥֵ��λ��
nout = sum(outliers) % ������Ⱥֵ�ĸ�������ʾ
data(outliers) = [];%ȥ����Ⱥֵ
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
%title 'Ƶ��ֱ��ͼ����̬�ֲ��ܶȺ�������ϣ�';
%}
%{
x = data;
figure;
histfit(x, 20);%��̬�������
normfit(x);%��̬�Լ��飨��ɢ���Ƿ�ֲ���һ��ֱ���ϣ���������������̬�ֲ��������Ƿ���̬�ֲ���
%�������� 
[muhat,sigmahat,muci,sigmaci]=normfit(x);%muhat��ֵ,sigmahat����,muci��ֵ��0.95��������,sigmaci�����0.95��������



%������飨�����ڷ���δ֪������£������ֵ�Ƿ�Ϊmahat��
[h,sig,ci]=ttest(x,muhat); %h=0,���ܼ��裬��ֵ=mahat
%����hΪ����������h=0��ʾ���ܾ�����裬˵����ֵΪmahat�ļ��������h=1���෴��
%ci��ʾ0.95���������䡣
%sig����0.5�����ܾܾ�����裬�����෴��

%%����ʽ����̬�Լ��鷽��
%kstest Kolmogorov-Smirnov��̬�Լ��飬���������׼��̬�ֲ�����ֵΪ0������Ϊ1�����жԱȣ���������̬�ֲ�����1�����򷵻�0���ú���Ҳ�������������ֲ����͵ļ��飻
[h,p,jbstat,cv]=kstest(x); %H0: ������̬N��0,1��

%lillietest Lilliefors test�� ��kstest��ͬ������Ŀ�겻�Ǳ�׼��̬�����Ǿ�����������ͬ��ֵ�ͷ������̬�ֲ���
[h,p,istat,cv]=lillietest(x); %H0: ����N��mu,sigma2��;

%jbtest Jarque-Bera test���� Lilliefors test ���ƣ�����������С�����������
[h,p,jbstat,cv]=jbtest(x); %H0��������̬N(mu,sigma2)   
%}