function [ccc] = classify_clusters_based_on_grades_ver_2(grades)
%ccc stands for current cluster category
ccc = "";
if grades(6) < 100
    ccc = "MUA underpowered";
elseif grades(5) < 550
    if grades(2)> 0.0538 && grades(2) < 0.07
        if grades(1) > 0 && grades(1) < 0.05
            if grades(8) > 0.3 && grades(8) < 0.9
                ccc = "Neruon c1.1.1.1";
            else
                ccc = "MUA 1.1.1.end";
            end
        else
            ccc = "MUA 1.1.end";
        end
    elseif grades(6) > 2670
        if grades(1) >0 && grades(1) < 0.1
            ccc = "Neuron c1.2.1";
        else
            ccc = "MUA 1.2.end";
        end
    elseif grades(12) > 0.086 && grades(12) <0.13
        ccc = "Neuron c1.3";
    elseif grades(13) < 0.344 && grades(13) > 0.086
        ccc = "Neuron c1.4";
    elseif grades(14) <0.303  && grades(17) > 0.101
        ccc = "Neuron c1.5";
    elseif grades(25) <92
        ccc = "MUA c1.6";
    elseif grades(28) >0.204
        ccc = "MUA c1.7";
    elseif grades(36) >0.25
        ccc = "Neuron c1.8";
    elseif grades(40) >0.2172
        ccc = "Neuron c1.9";
    elseif grades(41) >0  && grades(41) <0.0181
        ccc = "Neuron c1.10";
    else
        ccc="MUA c1.end";
    end

elseif grades(12) < 0.57
    if grades(2) > 0.5
        ccc = "MUA c2.1";
    elseif grades(5) > 4450
        ccc = "MUA c2.2";
    elseif grades(6) > 1172
        if grades(1) < 0.05 && grades(1) >0
            ccc = "Neuron c2.3.1";
        elseif grades(2) >0 && grades(2) <0.1
            ccc = "Neuron c2.3.2";
        elseif grades(5) > 0 && grades(2) < 1000
            ccc = "Neuron c2.3.3";
        elseif grades(8) > 0.3 && grades(8) < 0.9
            ccc = "Neuron c2.3.4";
        else
            ccc = "MUA c2.3.end";
        end
    elseif grades(8) > 0.194 && grades(8) < 0.58
        ccc = "Neuron c2.3";
    elseif grades(10) > 1.82 && grades(10) < 2.73
        ccc = "Neuron c2.4"; MUA
        ccc = "MUA c2.4";
    elseif grades(13) > 0.144 && grades(13) < 0.354
        ccc = "Neuron c2.5";%
        ccc = "MUA c2.5 Updated";
    elseif grades(14) <0.456
        ccc = "Neuron c2.6";
    elseif grades(16) > 0 && grades(16) < 0.05
        ccc = "Neuron c2.7";
    elseif grades(17) > 0 && grades(17) < 0.05
        ccc = "Neuron c2.8"; %OG
        ccc = "MUA c2.8 Updated";
    elseif grades(18) > 0 && grades(18) < 0.05
        ccc = "Neuron c2.9";
    elseif grades(19) > 2.5 && grades(19) < 3.5
        ccc = "Neuron c2.10"; %OG
        ccc = "MUA c2.10"; 
    elseif grades(20) <0.4
        ccc = "Neuron c2.11";
    elseif grades(21) < 200
        ccc = "Neuron c2.12"; %OG
        ccc = "MUA c2.12";
    elseif grades(22) > 0.57 && grades(22) < 0.58
        ccc = "Neuron c2.13";
    elseif grades(23) < 0.2
        ccc = "Neuron c2.14";
    elseif grades(25) > 200 && grades(25) < 280
    else
        ccc = "MUA c2.end";
    end
% elseif grades(49) > .9
%     ccc = "Neuron Grade 5 by cicrcle SNR";
% elseif grades(49) < -0.8
%     ccc = "MUA by circle SNR";

    %current_cluster_category = "Neuron c2";
    % elseif grades(13) < 1 && grades(13) > 0.05
    %     ccc = "Neuron c3";
    % elseif grades(18) > 0 && grades(18) < 0.03
    %     ccc = "Neuron c4";
    % elseif grades(22) > 0.561 && grades(22) < 0.595
    %     ccc = "Neuron c5";
    % elseif grades(23) <  0.18
    %     ccc = "Neuron c6";
    % elseif grades(26) > 21000000
    %     ccc = "Neuron c7";
    % elseif grades(28) > -0.1 && grades(28) <= 0.1
    %     ccc = "Neuron c8";
    % elseif grades(30) <= 1.1 && grades(30) > 1
    %     ccc = "Neuron c9";
    % elseif grades(29) < 2e-30
    %     ccc = "Neuron c10";
    % elseif grades(40) >= 0.5
    %     ccc = "Neuron c11";
    % elseif grades(36) < 0.2
    %     ccc = "Neuron c12";
end
if ccc==""
    ccc = "MUA Default";
end
end
