p1 = {-1  0 1 0 1 1 -1  0 -1 1 0 1};
t1 = {-1 -1 1 1 1 2  0 -1 -1 0 1 1};
net = linearlayer([0 1],0.1);
for i = 1:100
    [net,y,e,pf] = adapt(net,p1,t1);
end
mse(e)
