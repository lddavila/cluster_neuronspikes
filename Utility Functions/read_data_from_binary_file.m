function [all_data,std_dvns_per_channel,means_per_channel,z_scores_per_channel] = read_data_from_binary_file(binary_file_path,binary_file_name,which_channel_do_you_want,which_seconds,want_plot,dir_to_save_figs_to,data_type)
%binary_file_path: string, gives file path of the binary file

%binary_file_name: string, name of the binary file

%which_channel: can be either string or double
%if it is a string, the string must be all
%if it is a double then it should represent the max number of channels you desire
%example) which_channel = "all", gets all channels
%which_channel = 10, gets channels 1-10

%which_seconds: can be either string or double 2x1 array
%if it is a string it must be all
%if it is a double array the first digit should represent the first second you desire, and the second digit should represent the last second you desire
%example) which_seconds = [1 10], get seconds 1-10 (inclusive)
%which_channel = [1 1], get second 1
%which_channel = "all", get all seconds

%want_plot: boolean, tells you to save a plot or not

%dir_to_save_figs_to: string, name of the directory you wish to save files to

%data_type: string, can be either 'A' for analogue or 'D' for digital


meta = SGLX_readMeta.ReadMeta(binary_file_name,binary_file_path); %parse the meta file for the meta data

if strcmpi(string(which_seconds),"all") % use this to get either all data or a segment of data
    nChan = str2double(meta.nSavedChans); %gets number of channels in the file (number of rows)
    nSamp = str2double(meta.fileSizeBytes) / (2* nChan); %gets the max number of samples in the binary file (number of cols)
    dataArray = SGLX_readMeta.ReadBin(0,nSamp,meta,binary_file_name,binary_file_path); %extracts voltage readings for specified time segment
    all_data = dataArray;
else
    nSamp = floor(which_seconds(2) *SGLX_readMeta.SampRate(meta)); % tells you how many samples per second
    dataArray = SGLX_readMeta.ReadBin(which_seconds(1),nSamp,meta,binary_file_name,binary_file_path); % extracts volate readings for specified time segment
    all_data = dataArray;
end


if strcmpi(string(which_channel_do_you_want),"all")
    ch = str2double(meta.nSavedChans);
else
    ch = which_channel_do_you_want;
end

% Read these lines in dw (0-based).
% For 3B2 imec data: the sync pulse is stored in line 6.
% May be 1 or more line indices.
dLineList = [0,1,6];

if data_type == 'A'
    switch meta.typeThis
        case 'imec'
            dataArray = SGLX_readMeta.GainCorrectIM(dataArray, [ch], meta);
        case 'nidq'
            dataArray = SGLX_readMeta.GainCorrectNI(dataArray, [ch], meta);
        case 'obx'
            dataArray = SGLX_readMeta.GainCorrectOBX(dataArray, [ch], meta);
    end
    if want_plot
        dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
        plot(1e6*dataArray(ch,:));
        xlabel("time (\mu s)");
        ylabel("voltage");
        saveas(gcf,strcat(dir_to_save_figs_to,"\Channel Plot"),"fig")
    end
else
    digArray = SGLX_readMeta.ExtractDigital(dataArray, meta, dw, dLineList);
    if want_plot
        dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
        for i = 1:numel(dLineList)
            plot(digArray(i,:));
            hold on
        end
        ylabel("Voltage")
        xlabel("time (\mu s)")
        hold off
        saveas(gcf,strcat(dir_to_save_figs_to,"Channel Plot"),"fig")
    end
end

[z_scores_per_channel,means_per_channel,std_dvns_per_channel] = zscore(all_data,1,2);



end