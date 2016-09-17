load communication_size_input.data;
load communication_size_input_simple.data;
load communication_size_target.data;
net = network;
net.numInputs = 1;
net.numLayers = 2;
net.biasConnect = [1;1];
net.inputConnect = [1;0];
net.layerConnect = [0 0; 1 0];
net.outputConnect = [0 1];
net.inputs{1}.size = 2; %1;
net.layers{1}.size = 10;
net.layers{1}.transferFcn = 'purelin';
net.layers{1}.initFcn = 'initnw';
net.layers{2}.transferFcn = 'purelin';
net.layers{2}.initFcn = 'initnw';
net.initFcn = 'initlay';
net.performFcn = 'mse';
net.divideFcn = 'divideind';%'dividerand';
net.plotFcns = {'plotperform','plottrainstate','plotregression'};
net = init(net);
X = communication_size_input';
%X = communication_size_input_simple';
T = communication_size_target';
net.trainFcn = 'trainlm';
%net.trainParam.max_fail = 10;
%net.trainParam.epochs = 20;
ans1 = [];
for i = 5:5:100
    best_perf = inf;
    ans_tmp = [];
    for j = 1:10
        [trainInd,valInd,testInd] = dividerand(i);
        tmp = randperm(size(X,2));
        net.divideParam.trainInd = tmp(trainInd);
        net.divideParam.valInd = tmp(valInd);
        net.divideParam.testInd = tmp(testInd);
        for k = 1:20
            net = init(net);
            [net,tr] = train(net, X, T);
            if tr.best_perf < best_perf
                best_net = net;
                best_tr = tr;
                best_perf = tr.best_perf;
            end
        end
        detail_result = best_net(X);
        ans_tmp = [ans_tmp;[i,mean(abs(detail_result - T)),sqrt(sum((detail_result - T).^2,2)/size(X,2)),mean(abs(detail_result./T - 1))]];
    end
    ans1 = [ans1;mean(ans_tmp,1)]
end    
%plotperf(tr)

%{
outputs = net(X);
trOut = outputs(tr.trainInd);
vOut = outputs(tr.valInd);
tsOut = outputs(tr.testInd);
trTarg = T(tr.trainInd);
vTarg = T(tr.valInd);
tsTarg = T(tr.testInd);
plotregression(trTarg, trOut, 'Train', vTarg, vOut, 'validation',...
    tsTarg,tsOut, 'Testing');
%}

%Y = [abs(sim(net, X) - T); T]'
%z = sum(abs(sim(net, X) - T))