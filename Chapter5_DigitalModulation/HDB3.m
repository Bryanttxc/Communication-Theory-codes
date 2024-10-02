%  * @file HDB3.m
%  * @brief 仿真HDB3编码译码
%  * @author Bryanttxc
%  * @contact 克夏csdn
%  * @date 2024-10-02
%  * @copyright Copyright (c) 2024年 Bryanttxc All rights reserved

src_case_total{1} = [1 0 0 0 1 0 0 1 0 0 0 0 1 0 0 0 0 1 1 0 0 0 0 1 1]; % source code
src_case_total{2} = [0 0 0 0 1 0 0 1 0 0 0 0 1 0 0 0 0 1 1 0 0 0 0 1 1]; % source code

for tmp = 1:2

src_code = src_case_total{tmp};

%% encode
% HDB3
% rule1: 不超过3个0, HDB3 = AMI
% rule2: 超过3个0，第4个0置±V，根据前面的极性
% rule3: 相邻的V要极性交替，所以会需要有±B的帮助

% 约定:
% 第一个出现的1，记为-1
% 若传输开始即出现连续3个0，约定第1个V记为+V（+1）

pre_one_pos = 0; % 前一个1的位置
pre_v_pos = 0; % 前一个v的位置
zero_count = 0; % 连续0的个数

len = length(src_code);
encode_arr = zeros(1, len);

for index = 1:len
     if src_code(index) == 0 % src_code == 0
         zero_count = zero_count + 1;
         if zero_count == 4
            % 置V
            if pre_v_pos ~= 0
                encode_arr(index) = -encode_arr(pre_v_pos);
                if pre_one_pos ~= 0 && encode_arr(index) == -encode_arr(pre_one_pos)
                    % 置B
                    encode_arr(index - 3) = encode_arr(index);
                end
            elseif pre_one_pos ~= 0
                encode_arr(index) = encode_arr(pre_one_pos);
            else
                encode_arr(index) = 1; % 若传输开始即出现连续3个0，约定第1个V记为+V
            end
            
            pre_v_pos = index;
            pre_one_pos = index;
            zero_count = 0;
         end
     
     else % src_code == 1

         if pre_one_pos ~= 0 % 是否是第一个1
            encode_arr(index) = -1 * encode_arr(pre_one_pos);
         else
             encode_arr(index) = -1; % 约定第一个出现的1，记为-1
         end
         pre_one_pos = index;
         zero_count = 0;
     end
end


%% decode
% rule1: ±1000±1 => 10000
% rule2: ±100±1 => 0000

zero_count = 0; % 连续0的个数
decode_arr = zeros(1, len);

for index = 1:len
    if encode_arr(index) == 0 % encode_arr == 0
        zero_count = zero_count + 1;
        decode_arr(index) = encode_arr(index);
    else % encode_arr == ±1 / ±V / ±B
        if zero_count == 3 && ...
                    (  (index > 4 && encode_arr(index) == encode_arr(index-4)) ... % only ±V
                    || (index <= 4 && encode_arr(index) == 1) ) % 传输开始即连续出现3个0
            decode_arr(index) = 0;
        elseif zero_count == 2 && ...
                index > 3 && encode_arr(index) == encode_arr(index-3) % ±V and ±B
            decode_arr(index-3) = 0; % B
            decode_arr(index) = 0; % V
        else
            decode_arr(index) = abs(encode_arr(index));
        end
        
        zero_count = 0;
    end
end


%% validation
if src_code == decode_arr
    fprintf("case %d decode success!\n", tmp);
else
    fprintf("case %d decode fail!\n", tmp);
    for tt = 1:len
        if src_code(tt) ~= decode_arr(tt)
            fprintf("decode No.%d symbol fail!\n", tt);
        end
    end
end

end
