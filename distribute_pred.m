%y = normrnd(1,1,30,1);                 % Simulated process data
%capable = @(x)mean(x);                  % Process capability
%ci = bootci(2000,capable,y)            % BCa confidence interval

load device_in.data
load component_in.data
load param_in.data
load size_in.data
load delay_in.data
load full_out_new_device.data

load exec_time.data
comm_in = [];
exec_in = [];
time = [];
E = [];
for i = 1 : 1 : size(size_in, 1)/5
    x = [size_in((i-1)*5+1:i*5)'; delay_in((i-1)*5+1:i*5)'];
    comm_in = [comm_in, comm_net(x)'];
    tmp=[ones(1,5);x].*[b_comm b_comm b_comm b_comm b_comm];
    tsum=sum(tmp(:));
    
    x = [device_in((i-1)*5+1:i*5,:)'; component_in((i-1)*5+1:i*5,:)'; param_in((i-1)*5+1:i*5)'];
    exec_in = [exec_in, exec_net(x)'];
    tmp=[ones(1,5);x].*[b_exec b_exec b_exec b_exec b_exec];
    tsum = tsum + sum(tmp(:));
    time=[time, tsum];
    %[exec_net(x)', exec_time((i-1)*5+1:i*5)]
end
X = [exec_in; comm_in]
T = full_out_new_device';
%result = topo_net(X)
%result = sum(X,1);
result = time;
[result',T']
[mean(abs(result - T)),sqrt(sum((result - T).^2,2)/size(X,2)),mean(abs(result./T - 1))]