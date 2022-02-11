close all;
clear;

xlsFile = './20191018.xlsx';
[fileType, sheets] = xlsfinfo(xlsFile);

% load epoch and event data
[NUM{1},TXT{1},RAW{1}] = xlsread(xlsFile, string(sheets(1)));
epoch = length(RAW{1,1}(:,1))-1;
[NUM{1},TXT{1},RAW{1}] = xlsread(xlsFile, string(sheets(2)));

people = unique(RAW{1, 1}(2:end, 1));

% golden是people中的第幾個
number = 7;
goldArousal = zeros(epoch, 1);
goldno = zeros(epoch, 1);
for i = 2:length(RAW{1, 1})
    if(string(RAW{1, 1}(i, 1)) == string(people(number)))
        if(string(RAW{1, 1}(i, 4)) == "ARO SPONT")
            for j = floor(cell2mat(RAW{1, 1}(i, 5)) / 30)+1:ceil(cell2mat(RAW{1, 1}(i, 6)) / 30)+1
                goldArousal(j, 1) = 1;
            end
        end
    end
end
goldno = ~goldArousal;

runNumber = length(people);
for i = 1:runNumber

    % 畫圖
    arousal = zeros(epoch, 1);
    no = zeros(epoch, 1);
    for k = 2:length(RAW{1, 1})
        if(string(RAW{1, 1}(k, 1)) == string(people(i)))
            if(string(RAW{1, 1}(k, 4)) == "ARO SPONT")
                timefrom = floor(cell2mat(RAW{1, 1}(k, 5)) / 30) + 1;
                timeto = ceil(cell2mat(RAW{1, 1}(k, 6)) / 30) + 1;
                if(timeto > epoch)
                    timeto = epoch;
                end
                for j = timefrom:timeto
                    arousal(j, 1) = 1;
                end
            end
        end
    end
    no = ~arousal;

    subplot(runNumber, 1, i);
    hold on;
    grid on;
    bar(arousal, 'FaceColor', '#B32540', 'BarWidth', 1);
    
    title(people(i));
    axis tight;
    yticks([0 1]);
    ylim([0 1]);
    yticklabels(["None", "Arousal"]);

    % 計算一致性
    agreement = zeros(3, 3);

    agreement(3, 3) = round(((sum(arousal & goldArousal) + sum(no & goldno)) / (sum(goldArousal) + sum(goldno)))*100, 1);
    goldenEvent = [goldno, goldArousal];
    myEvent = [no, arousal];
    for j = 1:2
        for k = 1:2
            count = myEvent(:,j) & goldenEvent(:,k);
            agreement(j, k) = round((sum(count) / sum(goldenEvent(:,k)))*100, 1);
        end
    end

    % 存成csv
    writematrix(agreement, string(people(i)) + "_arousal_agreement.csv");

end