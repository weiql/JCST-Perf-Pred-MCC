X = []
T = []
for i = 1:1000
    a = rand();
    b = rand();
    c = rand();
    d = rand();
    e = rand();
    f = rand();    
    t = max(a+b+e,max(a+b+d+f,a+c+f));
    X = [X,[a;b]];
    T = [T,c];
end
net = network;
net.numInputs = 1;
net.numLayers = 3;
net.biasConnect = [1;1;1];
net.inputConnect = [1; 0; 0];
net.layerConnect = [0 0 0 ; 1 0 0 ; 0 1 0];
net.outputConnect = [0 0 1];
net.layers{1}.size = 30;
net.layers{1}.transferFcn = 'purelin';%'tansig';
net.layers{1}.initFcn = 'initnw';
net.layers{2}.size = 30;
net.layers{2}.transferFcn = 'purelin';%'tansig';
net.layers{2}.initFcn = 'initnw';
net.layers{3}.size = 1;
net.layers{3}.transferFcn = 'poslin';
net.layers{3}.initFcn = 'initnw';
net.initFcn = 'initlay';
net.performFcn = 'mse';
net.divideFcn = 'dividerand';
net.plotFcns = {'plotperform','plottrainstate','plotregression'};
net.trainFcn = 'trainlm';
best_perf = inf;
for k = 1:20
    net = init(net);
    [net,tr] = train(net, X, T);
    if tr.best_perf < best_perf
        best_net = net;
        best_tr = tr;
        best_perf = tr.best_perf;
    end    
end
result = best_net(X);
[result', T']
[mean(abs(result - T)),sqrt(sum((result - T).^2,2)/size(X,2)),mean(abs(result./T - 1))]