load full_in_new_scheme.data;
load full_out_new_scheme.data;
X_orig = mapminmax(full_in_new_scheme');
T_orig = full_out_new_scheme';
[T, ps] = mapminmax(full_out_new_scheme');
X = X_orig(:, :);
detail_result = mapminmax('reverse',best_net(X),ps);
[detail_result',T_orig']
[mean(abs(detail_result - T_orig)),sqrt(sum((detail_result - T_orig).^2,2)/size(X,2)),mean(abs(detail_result./T_orig - 1))]