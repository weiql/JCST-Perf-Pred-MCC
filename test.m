net = network;
net.numInputs = 2;
net.numLayers = 2;
net.biasConnect = [1;1];
net.inputConnect = [1 1; 0 0];
net.layerConnect = [0 0; 1 0];
net.outputConnect = [0 1];
net.inputs{1}.size = 1;
net.inputs{2}.size = 1;
net.layers{1}.size = 10;
%net.layers{1}.transferFcn = 'poslin';
net.layers{1}.initFcn = 'initnw';
net.layers{2}.size = 1;
%net.layers{2}.transferFcn = 'poslin';
net.layers{2}.initFcn = 'initnw';
net.initFcn = 'initlay';
net.performFcn = 'mse';
net.divideFcn = 'dividerand';
net.plotFcns = {'plotperform','plottrainstate','plotregression'};
net.trainFcn = 'trainlm';
%net.trainParam.max_fail = 10;
net = init(net);

load test_f1.data
load test_f2.data
load test_mt.data
%{
X = mat2cell([test_f1; test_mt], 2, ones(1,size(test_f1,2)));
T = mat2cell(test_f2, 1, ones(1,size(test_f1,2)));
[net,a,e,pf] = adapt(net,X,T);

net.adaptFcn = 'adaptwb';
for i = 1:1000
    [net,a,e,pf] = adapt(net, X, T);
end
[T;a;e]'
mse(e)
%}

X = [test_f1; test_mt];
T = test_f2;
[net,tr] = train(net, X, T);

