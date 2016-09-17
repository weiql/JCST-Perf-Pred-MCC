function result = emb_exec_new()

load emb_exec_inputs_1.data;
load emb_exec_inputs_2.data;
load emb_exec_targets.data;
load new_device_arr.data;
load new_component_arr.data;
load error_weight_arr.data;

net = network;
net.numInputs = 2;
net.numLayers = 4;
net.biasConnect = [1;1;1;1];
net.inputConnect = [1 0; 0 1; 0 0; 0 0];
net.layerConnect = [0 0 0 0; 0 0 0 0; 1 1 0 0; 0 0 1 0];
net.outputConnect = [0 0 0 1];
net.inputs{1}.size = 9;
net.inputs{2}.size = 4;
net.layers{1}.size = 5;
net.layers{1}.transferFcn = 'purelin';%'poslin';
net.layers{1}.initFcn = 'initnw';
net.layers{2}.size = 5;
net.layers{2}.transferFcn = 'purelin';%'poslin';
net.layers{2}.initFcn = 'initnw';
net.layers{3}.size = 20;
net.layers{3}.transferFcn = 'purelin';%'poslin';
net.layers{3}.initFcn = 'initnw';
net.layers{4}.size = 1;
net.layers{4}.transferFcn = 'poslin';%'poslin';
net.layers{4}.initFcn = 'initnw';
net.initFcn = 'initlay';
net.performFcn = 'mse';
net.divideFcn = 'divideind'; %(3000,1:2000,2001:2500,2501:3000); %'dividerand';
s1 = size(new_device_arr, 2);
s2 = size(error_weight_arr, 2);
%net.plotFcns = {'plotperform','plottrainstate','plotregression'};
X = [emb_exec_inputs_1; emb_exec_inputs_2];
T = emb_exec_targets;
net.trainFcn = 'trainlm';
%net.trainParam.max_fail = 6;
net.trainParam.showWindow = 0;
best_perf = inf;
for n = 1:30
    tmp = randperm(s2-s1) + s1; % [1:s2-s1] + s1; %  
    net.divideParam.trainInd = tmp(s1+1:s2-s1);
    net.divideParam.valInd = tmp(1:s1);
    net.divideParam.testInd = 1:s1;
    net = init(net);
    %[net,tr] = train(net, X, T, {}, {}, error_weight_arr);
    [net,tr] = train(net, X, T);
    if tr.best_perf < best_perf
        best_net = net;
        best_tr = tr;
        best_perf = tr.best_perf;
    end
end
detail_result = [best_net(X(:,1:s1)); T(1:s1); new_component_arr; new_device_arr]';

ans11 = sum(abs(best_net(X(:,1:s1)) - T(1:s1)) .* (1 - new_component_arr), 2) / sum(T(1:s1) .* (1 - new_component_arr), 2);
ans12 = sum(abs(best_net(X(:,1:s1)) - T(1:s1)) .* (new_component_arr - new_device_arr), 2) / sum(T(1:s1) .* (new_component_arr - new_device_arr), 2);
ans13 = sum(abs(best_net(X(:,1:s1)) - T(1:s1)) .* new_device_arr, 2) / sum(T(1:s1) .* new_device_arr, 2);
ans21 = sum(abs(best_net(X(:,1:s1)) - T(1:s1)) .* (1 - new_component_arr), 2) / sum(1 - new_component_arr, 2);
ans22 = sum(abs(best_net(X(:,1:s1)) - T(1:s1)) .* (new_component_arr - new_device_arr), 2) / sum(new_component_arr - new_device_arr, 2);
ans23 = sum(abs(best_net(X(:,1:s1)) - T(1:s1)) .* new_device_arr, 2) / sum(new_device_arr, 2);
result = [ans11, ans12, ans13, ans21, ans22, ans23, sum(new_component_arr - new_device_arr, 2)];

save e:\result.txt -ascii result;
save e:\detail_result.txt -ascii detail_result;
exit;
end

%plotperf(tr);
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