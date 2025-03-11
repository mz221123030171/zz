function dd_phi = generate_double_difference_observations(BS, MS, user_ref)
    % 计算所有基站点到所有移动站的距离
    distances_BS_MS = pdist2(BS, MS);
    distances_user_ref_BS = pdist2(BS, user_ref);

    % 选择第一个基站点作为参考基站点
    ref_BS_idx = 1;

    % 初始化双差分观测矩阵
    num_MS = size(MS, 1);
    num_BS = size(BS, 1);
    dd_phi = zeros(num_MS, num_BS - 1);

    for i = 1:num_MS
        for j = 2:num_BS
            % 单差：基站点之间的差
            sd1 = distances_BS_MS(j, i) - distances_BS_MS(ref_BS_idx, i);
            % 单差：用户端参考站与当前基站点的差
            sd2 = distances_user_ref_BS(j) - distances_user_ref_BS(ref_BS_idx);
            %disp(sd2)
            % 双差
            dd_phi(i, j-1) = (sd2 - sd1);
        end
    end
end