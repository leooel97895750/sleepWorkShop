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
for i = 2:length(RAW{1, 1})
    if(string(RAW{1, 1}(i, 1)) == string(people(number)))
        if(string(RAW{1, 1}(i, 4)) == "Central Apnea")
            for j = floor(cell2mat(RAW{1, 1}(i, 5)) / 30):ceil(cell2mat(RAW{1, 1}(i, 6)) / 30)
                goldca(j, 1) = 1;
            end
        elseif(string(RAW{1, 1}(i, 4)) == "Obstructive Apnea")
            for j = floor(cell2mat(RAW{1, 1}(i, 5)) / 30):ceil(cell2mat(RAW{1, 1}(i, 6)) / 30)
                goldoa(j, 1) = 1;
            end
        elseif(string(RAW{1, 1}(i, 4)) == "Mixed Apnea")
            for j = floor(cell2mat(RAW{1, 1}(i, 5)) / 30):ceil(cell2mat(RAW{1, 1}(i, 6)) / 30)
                goldma(j, 1) = 1;
            end
        elseif(string(RAW{1, 1}(i, 4)) == "Central Hypopnea")
            for j = floor(cell2mat(RAW{1, 1}(i, 5)) / 30):ceil(cell2mat(RAW{1, 1}(i, 6)) / 30)
                goldch(j, 1) = 1;
            end
        elseif(string(RAW{1, 1}(i, 4)) == "Obstructive Hypopnea")
            for j = floor(cell2mat(RAW{1, 1}(i, 5)) / 30):ceil(cell2mat(RAW{1, 1}(i, 6)) / 30)
                goldoh(j, 1) = 1;
            end
        elseif(string(RAW{1, 1}(i, 4)) == "Mixed Hypopnea")
            for j = floor(cell2mat(RAW{1, 1}(i, 5)) / 30):ceil(cell2mat(RAW{1, 1}(i, 6)) / 30)
                goldmh(j, 1) = 1;
            end
        end
    end
end

for i = 1:length(people)

    % 計算
    ca = zeros(epoch, 1);
    oa = zeros(epoch, 1);
    ma = zeros(epoch, 1);
    ch = zeros(epoch, 1);
    oh = zeros(epoch, 1);
    mh = zeros(epoch, 1);

end