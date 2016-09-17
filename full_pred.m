load full_in.data;
load full_out.data;

net = network;
net.numInputs = 1;
net.numLayers = 2;
net.biasConnect = [1;1];
net.inputConnect = [1; 0];
net.layerConnect = [0 0; 1 0];
net.outputConnect = [0 1];
%net.inputs.size = 1;
net.layers{1}.size = 20;
net.layers{1}.transferFcn = 'purelin';
net.layers{1}.initFcn = 'initnw';
net.layers{2}.size = 1;
net.layers{2}.transferFcn = 'purelin';
net.layers{2}.initFcn = 'initnw';
net.initFcn = 'initlay';
net.performFcn = 'mse';
net.divideFcn = 'divideind'; %'dividerand'; %(3000,1:2000,2001:2500,2501:3000); %'dividerand';
net.plotFcns = {'plotperform','plottrainstate','plotregression'};
net.trainFcn = 'trainlm';
net.trainParam.showWindow = 0;
X_orig = mapminmax(full_in');
T_orig = full_out';
[T, ps] = mapminmax(full_out');
X = X_orig(:, :);
ans1 = [];
for i = 50:5:50
    ans_tmp = [];
    for j = 1:20
        best_perf = inf;
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
        %detail_result = best_net(X);
        detail_result = mapminmax('reverse',best_net(X),ps);
        %ans_tmp = [ans_tmp;[i,mean(abs(detail_result - T)),sqrt(sum((detail_result - T).^2,2)/size(X,2)),mean(abs(detail_result./T - 1))]];
        ans_tmp = [ans_tmp;[i,mean(abs(detail_result - T_orig)),sqrt(sum((detail_result - T_orig).^2,2)/size(X,2)),mean(abs(detail_result./T_orig - 1))]];
    end
    ans1 = [ans1;median(ans_tmp,1)]
end   



%net = init(net);
%[net,tr] = train(net, X, T);