close all;
clear;

xlsFile = './20191018.xlsx';
[fileType, sheets] = xlsfinfo(xlsFile);

% load epoch and event data
[NUM{1},TXT{1},RAW{1}] = xlsread(xlsFile, string(sheets(1)));
epoch = length(RAW{1,1}(:,1))-1;
[NUM{1},TXT{1},RAW{1}] = xlsread(xlsFile, string(sheets(2)));

% load edf
eeg = load('20191018.mat');
% 約略計算sampling rate
e1 = eeg.data(1,:);
per30 = length(e1) / epoch;
afs = per30 / 30;
% 擷取要使用的資料段
if afs > 210
    spo2data = eeg.data(8,:);
else
    spo2data = eeg.data(16,:);
end
spo2data = spo2data(1:epoch*30);

people = unique(RAW{1, 1}(2:end, 1));

% golden是people中的第幾個
number = 7;
goldspo2 = zeros(epoch, 1);
goldno = zeros(epoch, 1);
for i = 2:length(RAW{1, 1})
    if(string(RAW{1, 1}(i, 1)) == string(people(number)))
        if(string(RAW{1, 1}(i, 4)) == "SpO2 Desat")
            for j = floor(cell2mat(RAW{1, 1}(i, 5)) / 30)+1:ceil(cell2mat(RAW{1, 1}(i, 6)) / 30)+1
                goldspo2(j, 1) = 1;
            end
        end
    end
end
goldno = ~goldspo2;

runNumber = length(people);
for i = 1:runNumber

    % 畫圖
    spo2 = zeros(epoch, 1);
    no = zeros(epoch, 1);
    for k = 2:length(RAW{1, 1})
        if(string(RAW{1, 1}(k, 1)) == string(people(i)))
            if(string(RAW{1, 1}(k, 4)) == "SpO2 Desat")
                timefrom = floor(cell2mat(RAW{1, 1}(k, 5)) / 30) + 1;
                timeto = ceil(cell2mat(RAW{1, 1}(k, 6)) / 30) + 1;
                if(timeto > epoch)
                    timeto = epoch;
                end
                for j = timefrom:timeto
                    spo2(j, 1) = 1;
                end
            end
        end
    end
    no = ~spo2;

    subplot(runNumber, 1, i);
    hold on;
    grid on;
    plot((1:length(spo2data))/30, spo2data);
    b = bar(spo2*100, 'FaceColor', '#666666', 'BarWidth', 1);
    set(b, 'FaceAlpha', 0.5);
    
    title(people(i));
    axis tight;
    ylim([80 100]);

    % 計算一致性
    agreement = zeros(3, 3);

    agreement(3, 3) = round(((sum(spo2 & goldspo2) + sum(no & goldno)) / (sum(goldspo2) + sum(goldno)))*100, 1);
    goldenEvent = [goldno, goldspo2];
    myEvent = [no, spo2];
    for j = 1:2
        for k = 1:2
            count = myEvent(:,j) & goldenEvent(:,k);
            agreement(j, k) = round((sum(count) / sum(goldenEvent(:,k)))*100, 1);
        end
    end

    % 存成csv
    writematrix(agreement, string(people(i)) + "_spo2_agreement.csv");

end