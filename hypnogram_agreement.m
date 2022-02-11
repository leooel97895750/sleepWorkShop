close all;
clear;

xlsFile = './20191018.xlsx';
[fileType, sheets] = xlsfinfo(xlsFile);

% load hypnogram
[NUM{1},TXT{1},RAW{1}] = xlsread(xlsFile, string(sheets(1)));
epoch = length(RAW{1,1}(:,1))-1;
people = length(RAW{1,1}(1,:))-1;

% 將文字轉換成數字的函式
stage2num=containers.Map(["W","N1","N2","N3","REM","?"],[0 1 2 3 -1 4]);

% 輸入專家是第幾個 或是直接給個陣列
which = 10;
data = RAW{1,1}(2:end, which);
golden = zeros(epoch, 1);
for i = 1:length(data)
    golden(i, 1) = stage2num(cell2mat(data(i)));
end

figure(1);
for i = 1:people
    % 個別取出每一個人
    data = RAW{1,1}(2:end, i+1);
    hypnogram = zeros(epoch, 1);
    for j = 1:length(data)
        hypnogram(j, 1) = stage2num(cell2mat(data(j)));
    end

    subplot(people,1,i);
    hold on
    grid on
    W = hypnogram == 0;
    R = hypnogram == -1;
    bar(R,'FaceColor','#A2142F','BarWidth',1)
    N1 = hypnogram == 1;
    bar(N1*-1,'FaceColor','#EDB120','BarWidth',1)
    N2 = hypnogram == 2;
    bar(N2*-2,'FaceColor','#77AC30','BarWidth',1)
    N3 = hypnogram == 3;
    bar(N3*-3,'FaceColor','#0072BD','BarWidth',1)
    
    title(RAW{1,1}(1, i+1));
    axis tight;
    ylim([-3 1])
    yticklabels({'N3','N2','N1','W','R'});

    % 計算一致性
    agreement = zeros(6, 6);

    correct = golden == hypnogram;
    agreement(6, 6) = round((sum(correct) / epoch)*100, 1);

    goldenWake = golden == 0;
    goldenN1 = golden == 1;
    goldenN2 = golden == 2;
    goldenN3 = golden == 3;
    goldenRem = golden == -1;

    goldenStage = [goldenWake, goldenN1, goldenN2, goldenN3, goldenRem];
    myStage = [W, N1, N2, N3, R];
    for j = 1:5
        for k = 1:5
            count = myStage(:,j) & goldenStage(:,k);
            agreement(j, k) = round((sum(count) / sum(goldenStage(:,k)))*100, 1);
        end
    end

    % 存成csv
    writematrix(agreement, string(RAW{1,1}(1, i+1)) + "_agreement.csv");
%     ww = W == goldenWake;
%     wn1 = W == goldenN1;
%     wn2 = W == goldenN2;
%     wn3 = W == goldenN3;
%     wrem = W == goldenRem;
% 
%     n1w = N1 == goldenWake;
%     n1n1 = N1 == goldenN1;
%     n1n2 = N1 == goldenN2;
%     n1n3 = N1 == goldenN3;
%     n1rem = N1 == goldenRem;
% 
%     n2w = N2 == goldenWake;
%     n2n1 = N2 == goldenN1;
%     n2n2 = N2 == goldenN2;
%     n2n3 = N2 == goldenN3;
%     n2rem = N2 == goldenRem;
% 
%     n3w = N3 == goldenWake;
%     n3n1 = N3 == goldenN1;
%     n3n2 = N3 == goldenN2;
%     n3n3 = N3 == goldenN3;
%     n3rem = N3 == goldenRem;
% 
%     remw = R == goldenWake;
%     remn1 = R == goldenN1;
%     remn2 = R == goldenN2;
%     remn3 = R == goldenN3;
%     remrem = R == goldenRem;

end
