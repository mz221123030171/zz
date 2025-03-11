function sd2 = MS1dancha(BS,user_ref)
    % 计算所有基站点到所有移动站的距离
    
    distances_user_ref_BS = pdist2(BS, user_ref);

    % 选择第一个基站点作为参考基站点
    ref_BS_idx = 1;

    % 初始化双差分观测矩阵
   
    num_BS = size(BS, 1);
    sd2=size(num_BS-1,1);

   
     for j = 2:num_BS
         
           
            % 单差：用户端参考站与当前基站点的差
            sd2(j-1)= distances_user_ref_BS(j) - distances_user_ref_BS(ref_BS_idx);
            %disp(sd2)
           
     end
    
end