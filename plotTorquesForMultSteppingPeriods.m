%Generate figure comparing the normalized torques over different stepping
%periods from the robot

stepPeriod = [1;2;4];
stepNum = 6;
baseFolderLoc = 'C:\Users\Clarissa G\Documents\MATLAB\Running Drosophibot\Trials\';
trialNames = {'23-Aug-2023 16_48_27', '23-Aug-2023 16_22_09', '23-Aug-2023 16_39_07'};
for tr=1:length(trialNames)
    trialData = load([baseFolderLoc trialNames{tr} '\robotData.mat']);
    torques{tr} = trialData.dxl_present_load_pp;
    [r,c] = size(torques{tr});
    timeVec{tr} = linspace(0,stepPeriod(tr)*stepNum,length(torques{tr}))';
    temp = [];
    tempTime = [];
    tempRow = 1;
    for rr=1:r
        if torques{tr}(rr,1) ~= 0 && torques{tr}(rr,2) ~= 0 && torques{tr}(rr,3) ~= 0
            tempTime(tempRow,1) = timeVec{tr}(rr); 
            temp(tempRow,:) = torques{tr}(rr,:);
            tempRow = tempRow+1;
        end
    end
    timeVec{tr} = tempTime;
    torques{tr} = temp;
    normTimeVec{tr} = timeVec{tr}/stepPeriod(tr);
end
figure
tl = tiledlayout(2,3,'TileSpacing','compact','Padding','compact');
tl.TileIndexing = 'columnmajor';
legStartCols = [1,4,7,10,13,18,23];
colors = {"#67CCED",'#258942','#ab3377','#ddaa2f','#ed6677','#4478ab'};
legNames = {'Left Hind', 'Right Hind', 'Left Middle', 'Right Middle', 'Left Front', 'Right Front'};
lineStyles = {'-','--',':'};
handPlot1 = gobjects(5,3);
handPlot2 = gobjects(5,3);
for l=1:6
    nexttile
    hold on
    if l == 1 || l == 4 || l == 5
        for s = 1:stepNum
            patch('XData',[.2+1*(s-1) .2+1*(s-1) .8+1*(s-1) .8+1*(s-1)],'YData',[-2.5 2.5 2.5 -2.5],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
            %                     rectangle('Position',[.2+1*(s-1) 2 0.6 .1],'FaceColor','k')
        end
    else
        for s = 1:stepNum+1
            patch('XData',[-.3+1*(s-1) -.3+1*(s-1) .3+1*(s-1) .3+1*(s-1)],'YData',[-2.5 2.5 2.5 -2.5],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
            %                     rectangle('Position',[-.3+1*(s-1) 2 0.6 .1],'FaceColor','k')
        end
    end
    for j=1:legStartCols(l+1)-legStartCols(l)
        colIDs = legStartCols(l):legStartCols(l+1)-1;
        for tr=1:length(trialNames)
            if l <= 4
                plot(normTimeVec{tr},torques{tr}(:,colIDs(j)),'LineStyle',lineStyles{tr},'Color',colors{j+2});
            elseif l == 5
                handPlot1(j,tr) = plot(normTimeVec{tr},torques{tr}(:,colIDs(j)),'LineStyle',lineStyles{tr},'Color',colors{j});
            else
                handPlot2(j,tr) = plot(normTimeVec{tr},torques{tr}(:,colIDs(j)),'LineStyle',lineStyles{tr},'Color',colors{j});
            end
        end
    end

    title(legNames{l})
    axis([0 normTimeVec{1}(end) -2.5 2.5])
    grid on
    ylabel('Actuator Torque (Nm)')
    xlabel('Steps')

    if l == 5
        lgd1 = legend(handPlot1(:,1),'ThC1','ThC3','CTr','TrF','FTi','Location','northoutside');
        title(lgd1,'Joints')
    elseif l == 6
        lgd2 = legend(handPlot2(1,:),[num2str(stepPeriod(1)) ' s'],[num2str(stepPeriod(2)) ' s'],[num2str(stepPeriod(3)) ' s'],'Location','southoutside');
        title(lgd2,'Stepping Periods')
    end
end

title(tl,'Torques for Multiple Stepping Periods');
subtitle(tl,'Forward Walking');


