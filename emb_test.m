k = 30;
A = [[10,20,30,40,50,60,70];
     [20,40,60,80,100,120,140];
     [30,60,90,120,150,180,210];
     [40,80,120,160,200,240,280];
     [50,100,150,200,250,300,350];
     [60,120,180,240,300,360,420]];
n = size(A,1);
m = size(A,2);
X = [];
T = [];
for i = 1:n
    for j = 1:m
        tmp = [];
        for l = 1:n
            if l == i
                tmp = [tmp;ones(1,k)];
            else
                tmp = [tmp;zeros(1,k)];
            end
        end
        for l = 1:m
            if l == j
                tmp = [tmp;ones(1,k)];
            else
                tmp = [tmp;zeros(1,k)];
            end
        end        
        if i == n && j == m
            X1 = tmp;
            T1 = normrnd(A(i,j),3,1,k);
        else
            X = [X,tmp];
            T = [T, normrnd(A(i,j),3,1,k)];           
        end
    end
end

% X = [[ones(1,n),ones(1,n),ones(1,n),zeros(1,n),zeros(1,n)];
%      [zeros(1,n),zeros(1,n),zeros(1,n),ones(1,n),ones(1,n)];
%      [zeros(1,n),zeros(1,n),zeros(1,n),ones(1,n),ones(1,n)];
%      [ones(1,n),zeros(1,n),zeros(1,n),ones(1,n),zeros(1,n)];
%      [zeros(1,n),ones(1,n),zeros(1,n),zeros(1,n),ones(1,n)];
%      [zeros(1,n),zeros(1,n),ones(1,n),zeros(1,n),zeros(1,n)]];
% T = [normrnd(10,2,1,n),normrnd(20,3,1,n),normrnd(30,4,1,n),normrnd(20,3,1,n),normrnd(40,4,1,n)];

% X1 = [zeros(1,n);ones(1,n);zeros(1,n);zeros(1,n);ones(1,n)];
% T1 = normrnd(60,5,1,n);

net_old = network;
net_old.numInputs = 1;
net_old.numLayers = 2;
net_old.biasConnect = [1;1];
net_old.inputConnect = [1; 0];
net_old.layerConnect = [0 0; 1 0];
net_old.outputConnect = [0 1];
net_old.layers{1}.size = 10;
net_old.layers{1}.transferFcn = 'purelin';
net_old.layers{1}.initFcn = 'initnw';
net_old.layers{2}.transferFcn = 'purelin';
net_old.layers{2}.initFcn = 'initnw';
net_old.initFcn = 'initlay';
net_old.performFcn = 'mse';
net_old.divideFcn = 'dividerand';
net_old.plotFcns = {'plotperform','plottrainstate','plotregression'};
net_old.trainFcn = 'trainlm';
net_old = init(net_old);
[net_old,tr_old] = train(net_old, X, T);
R_old = net_old(X1);


net_new = network;
net_new.numInputs = 2;
net_new.numLayers = 4;
net_new.biasConnect = [1;1;1;1];
net_new.inputConnect = [1 0; 0 1; 0 0; 0 0];
net_new.layerConnect = [0 0 0 0; 0 0 0 0; 1 1 0 0; 0 0 1 0];
net_new.outputConnect = [0 0 0 1];
net_new.inputs{1}.size = n;
net_new.inputs{2}.size = m;
net_new.layers{1}.size = 1;
net_new.layers{1}.transferFcn = 'purelin';
net_new.layers{1}.initFcn = 'initnw';
net_new.layers{2}.size = 1;
net_new.layers{2}.transferFcn = 'purelin';
net_new.layers{2}.initFcn = 'initnw';
net_new.layers{3}.size = 20;
net_new.layers{3}.transferFcn = 'purelin';
net_new.layers{3}.initFcn = 'initnw';
net_new.layers{4}.size = 1;
net_new.layers{4}.transferFcn = 'purelin';
net_new.layers{4}.initFcn = 'initnw';
net_new.initFcn = 'initlay';
net_new.performFcn = 'mse';
net_new.divideFcn = 'dividerand';
net_new.plotFcns = {'plotperform','plottrainstate','plotregression'};
net_new.trainFcn = 'trainlm';
net_new = init(net_new);
[net_new,tr] = train(net_new, X, T);
R_new = net_new(X1);
[R_old',R_new']