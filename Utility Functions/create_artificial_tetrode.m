function [art_tetr_array] = create_artificial_tetrode(n_chan_per_tetr)
    %this function works only for the neuralink probes which have 384 channels staggered in 4 cols
    %therefore:
        % #of artificial tetrodes = 384 / n_chan_per_tetr
        % if 384 % n_chan_per_tetro != = then the last artificial tetrode will be shorted
    %the goal of this function is to return an array of artificial tetrodes

    %n_chan_per_tetr: an int that tells you how many channels per art. tetrode
    %art_tetr_array: array where each row is an artificial tetrode, each column is the channel in that tetrode
    n_chan_per_first_col = floor(n_chan_per_tetr/2);
    n_chan_per_second_col = ceil(n_chan_per_tetr/2);
    n_chan_per_third_col = n_chan_per_first_col;
    n_chan_per_fourth_col = n_chan_per_second_col;

    number_of_artificial_tetrodes = ceil(384/n_chan_per_tetr);

    first_col_ptr = 1;
    second_col_ptr = 97;
    third_col_ptr = 193;
    fourth_col_ptr = 289;

    art_tetr_array = zeros(number_of_artificial_tetrodes,n_chan_per_tetr);
    for i=1:2:number_of_artificial_tetrodes
        %on the first pass the nearest n channels will be bundled into an art. tetrode
        for k=1:1:n_chan_per_first_col
            art_tetr_array(i,k) = first_col_ptr;
            %first_col_ptr = first_col_ptr+1;
            if first_col_ptr > 96
                art_tetr_array(i,k) = NaN;
                first_col_ptr = NaN;
            else
                first_col_ptr = first_col_ptr+1;
            end
        end
         
        for p=n_chan_per_first_col+1:n_chan_per_tetr
            art_tetr_array(i,p)= second_col_ptr;
            % second_col_ptr = second_col_ptr+1;
            if second_col_ptr > 192
                art_tetr_array(i,k) = NaN;
                second_col_ptr = NaN;
            else
                second_col_ptr = second_col_ptr +1;
            end
        end

        for k=1:1:n_chan_per_third_col
            art_tetr_array(i+1,k)= third_col_ptr;
            %third_col_ptr = third_col_ptr+1;
            if third_col_ptr > 288
                art_tetr_array(i,k) = NaN;
                third_col_ptr = Nan;
            else
                %third_col_ptr = NaN;
                third_col_ptr = third_col_ptr+1;
            end
        end
        for p=n_chan_per_third_col+1:1:n_chan_per_tetr
            % disp(p)
            art_tetr_array(i+1,p) = fourth_col_ptr;
            %fourth_col_ptr = fourth_col_ptr+1;
            if fourth_col_ptr > 384
                art_tetr_array(i,k) = NaN;
                fourth_col_ptr = NaN;
            else
                fourth_col_ptr = fourth_col_ptr+1;
            end
        end
        
    end
    
end