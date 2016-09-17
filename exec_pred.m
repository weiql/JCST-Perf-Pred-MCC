load exec_device_in.data;
load exec_component_in.data;
load exec_param_in.data;
load exec_time.data
XX=[ones(2380,1) exec_device_in exec_component_in exec_param_in];
[b_exec,bint,r,rint,stats]=regress(exec_time, XX);
b_exec
stats

net = network;
net.numInputs = 3;
net.numLayers = 4;
net.biasConnect = [1;1;1;1];
net.inputConnect = [1 0 0; 0 1 0; 0 0 1; 0 0 0];
net.layerConnect = [0 0 0 0; 0 0 0 0; 1 1 0 0; 0 0 1 0];
net.outputConnect = [0 0 0 1];
net.inputs{1}.size = 3;
net.inputs{2}.size = 5;
net.inputs{3}.size = 1;
net.layers{1}.size = 5;
net.layers{1}.transferFcn = 'poslin';%'purelin';
net.layers{1}.initFcn = 'initnw';
net.layers{2}.size = 5;
net.layers{2}.transferFcn = 'poslin';
net.layers{2}.initFcn = 'initnw';
net.layers{3}.size = 30;
net.layers{3}.transferFcn = 'poslin';
net.layers{3}.initFcn = 'initnw';
net.layers{4}.size = 1;
net.layers{4}.transferFcn = 'poslin';
net.layers{4}.initFcn = 'initnw';
net.initFcn = 'initlay';
net.performFcn = 'mse';
net.divideFcn = 'dividerand';
net.plotFcns = {'plotperform','plottrainstate','plotregression'};
X = [exec_device_in'; exec_component_in'; exec_param_in'];
T = exec_time';
net.trainFcn = 'trainlm';
%net.trainParam.max_fail = 6;
best_perf = inf;
for n = 1:10
    net = init(net);
    %[net,tr] = train(net, X, T, {}, {}, error_weight_arr);
    [net,tr] = train(net, X, T);
    if tr.best_perf < best_perf
        exec_net = net;
        best_perf = tr.best_perf;
    end
end
detail_result = exec_net(X);
[detail_result', T']
[mean(abs(detail_result - T)),sqrt(sum((detail_result - T).^2,2)/size(X,2)),mean(abs(detail_result./T - 1))]

