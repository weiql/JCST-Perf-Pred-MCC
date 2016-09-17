load emb_exec_inputs_1.data;
load emb_exec_inputs_2.data;
load emb_exec_targets.data;
net = network;
net.numInputs = 2;
net.numLayers = 3;
net.biasConnect = [1;1;1];
net.inputConnect = [1 0; 0 1; 0 0];
net.layerConnect = [0 0 0; 0 0 0; 1 1 0];
net.outputConnect = [0 0 1];
net.inputs{1}.size = 9;
net.inputs{2}.size = 4;
net.layers{1}.size = 10;
net.layers{1}.transferFcn = 'purelin';
net.layers{1}.initFcn = 'initnw';
net.layers{2}.size = 10;
net.layers{2}.transferFcn = 'purelin';
net.layers{2}.initFcn = 'initnw';
net.layers{3}.transferFcn = 'poslin';
net.layers{3}.initFcn = 'initnw';
net.initFcn = 'initlay';
net.performFcn = 'mse';
net.divideFcn = 'dividerand';
net.plotFcns = {'plotperform','plottrainstate'};
net = init(net);
X = [emb_exec_inputs_1; emb_exec_inputs_2];
T = emb_exec_targets;
net.trainFcn = 'trainlm';
net.trainParam.max_fail = 10;
[net,tr] = train(net, X, T);
plotperf(tr)

outputs = net(X);
trOut = outputs(tr.trainInd);
vOut = outputs(tr.valInd);
tsOut = outputs(tr.testInd);
trTarg = T(tr.trainInd);
vTarg = T(tr.valInd);
tsTarg = T(tr.testInd);
plotregression(trTarg, trOut, 'Train', vTarg, vOut, 'validation',...
    tsTarg,tsOut, 'Testing');

%Y = [abs(sim(net, X) - T); T]'
%z = sum(abs(sim(net, X) - T))