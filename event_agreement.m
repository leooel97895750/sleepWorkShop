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
goldca = zeros(epoch, 1);
goldoa = zeros(epoch, 1);
goldma = zeros(epoch, 1);
goldch = zeros(epoch, 1);
goldoh = zeros(epoch, 1);
goldmh = zeros(epoch, 1);
goldno = zeros(epoch, 1);
for i = 2:length(RAW{1, 1})
    if(string(RAW{1, 1}(i, 1)) == string(people(number)))
        if(string(RAW{1, 1}(i, 4)) == "Central Apnea")
            for j = floor(cell2mat(RAW{1, 1}(i, 5)) / 30)+1:ceil(cell2mat(RAW{1, 1}(i, 6)) / 30)+1
                goldca(j, 1) = 1;
            end
        elseif(string(RAW{1, 1}(i, 4)) == "Obstructive Apnea")
            for j = floor(cell2mat(RAW{1, 1}(i, 5)) / 30)+1:ceil(cell2mat(RAW{1, 1}(i, 6)) / 30)+1
                goldoa(j, 1) = 1;
            end
        elseif(string(RAW{1, 1}(i, 4)) == "Mixed Apnea")
            for j = floor(cell2mat(RAW{1, 1}(i, 5)) / 30)+1:ceil(cell2mat(RAW{1, 1}(i, 6)) / 30)+1
                goldma(j, 1) = 1;
            end
        elseif(string(RAW{1, 1}(i, 4)) == "Central Hypopnea")
            for j = floor(cell2mat(RAW{1, 1}(i, 5)) / 30)+1:ceil(cell2mat(RAW{1, 1}(i, 6)) / 30)+1
                goldch(j, 1) = 1;
            end
        elseif(string(RAW{1, 1}(i, 4)) == "Obstructive Hypopnea")
            for j = floor(cell2mat(RAW{1, 1}(i, 5)) / 30)+1:ceil(cell2mat(RAW{1, 1}(i, 6)) / 30)+1
                goldoh(j, 1) = 1;
            end
        elseif(string(RAW{1, 1}(i, 4)) == "Mixed Hypopnea")
            for j = floor(cell2mat(RAW{1, 1}(i, 5)) / 30)+1:ceil(cell2mat(RAW{1, 1}(i, 6)) / 30)+1
                goldmh(j, 1) = 1;
            end
        end
    end
end
goldno = ~(goldca | goldoa | goldma | goldch | goldoh | goldmh);

runNumber = length(people);
for i = 1:runNumber

    % 畫圖
    ca = zeros(epoch, 1);
    oa = zeros(epoch, 1);
    ma = zeros(epoch, 1);
    ch = zeros(epoch, 1);
    oh = zeros(epoch, 1);
    mh = zeros(epoch, 1);
    no = zeros(epoch, 1);
    for k = 2:length(RAW{1, 1})
        if(string(RAW{1, 1}(k, 1)) == string(people(i)))
            timefrom = floor(cell2mat(RAW{1, 1}(k, 5)) / 30) + 1;
            timeto = ceil(cell2mat(RAW{1, 1}(k, 6)) / 30) + 1;
            if(timeto > epoch)
                timeto = epoch;
            end
            if(string(RAW{1, 1}(k, 4)) == "Central Apnea")
                for j = timefrom:timeto
                    ca(j, 1) = 1;
                end
            elseif(string(RAW{1, 1}(k, 4)) == "Obstructive Apnea")
                for j = timefrom:timeto
                    oa(j, 1) = 1;
                end
            elseif(string(RAW{1, 1}(k, 4)) == "Mixed Apnea")
                for j = timefrom:timeto
                    ma(j, 1) = 1;
                end
            elseif(string(RAW{1, 1}(k, 4)) == "Central Hypopnea")
                for j = timefrom:timeto
                    ch(j, 1) = 1;
                end
            elseif(string(RAW{1, 1}(k, 4)) == "Obstructive Hypopnea")
                for j = timefrom:timeto
                    oh(j, 1) = 1;
                end
            elseif(string(RAW{1, 1}(k, 4)) == "Mixed Hypopnea")
                for j = timefrom:timeto
                    mh(j, 1) = 1;
                end
            end
        end
    end
    no = ~(ca | oa | ma | ch | oh | mh);

    subplot(runNumber, 1, i);
    hold on;
    grid on;
    bar(ca*3, 'FaceColor', '#d47800', 'BarWidth', 1);
    bar(oa*2, 'FaceColor', '#B32540', 'BarWidth', 1);
    bar(ma, 'FaceColor', '#4d0000', 'BarWidth', 1);
    bar(ch*-1, 'FaceColor', '#03965e', 'BarWidth', 1);
    bar(oh*-2, 'FaceColor', '#77AC30', 'BarWidth', 1);
    bar(mh*-3, 'FaceColor', '#114d00', 'BarWidth', 1);
    
    title(people(i));
    axis tight;
    yticks([-3 -2 -1 0 1 2 3]);
    ylim([-3 3]);
    yticklabels(["Mixed Hypopnea", "Obstructive Hypopnea", "Central Hypopnea", " ", "Mixed Apnea", "Obstructive Apnea", "Central Apnea"]);

    % 計算一致性
    agreement = zeros(8, 8);

    agreement(8, 8) = round((sum(no & goldno) + sum(ca & goldca) + sum(oa & goldoa) + sum(ma & goldma) + sum(ch & goldch) + sum(oh & goldoh) + sum(mh & goldmh)) / (sum(goldno) + sum(goldca) + sum(goldoa) + sum(goldma) + sum(goldch) + sum(goldoh) + sum(goldmh))*100, 1);
    goldenEvent = [goldno, goldca, goldoa, goldma, goldch, goldoh, goldmh];
    myEvent = [no, ca, oa, ma, ch, oh, mh];
    for j = 1:7
        for k = 1:7
            count = myEvent(:,j) & goldenEvent(:,k);
            agreement(j, k) = round((sum(count) / sum(goldenEvent(:,k)))*100, 1);
        end
    end

    % 存成csv
    writematrix(agreement, string(people(i)) + "_event_agreement.csv");

end