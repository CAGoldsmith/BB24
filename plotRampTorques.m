clear all
stepPeriod = 2;
stepNum = 5;
numPts = 102;
baseFolderLoc = 'C:\Users\Clarissa G\Documents\MATLAB\Running Drosophibot\Trials\';
trialName = '2024-04-29 18_30_15';
trialData = load([baseFolderLoc trialName '\robotData.mat']);
torques = trialData.dxl_present_load_pp;
timeVec = trialData.timeVec;
timeVecIndices = trialData.timeVecInds;
tVecIndicesDiff = -(timeVecIndices(2:end) - timeVecIndices(1:end-1));

trialNameBase = '2023-09-01 17_01_41';
trialDataBase = load([baseFolderLoc trialNameBase '\robotData.mat']);
torquesBase = trialDataBase.dxl_present_load_pp;
endPt = trialDataBase.actTimeStep*length(torquesBase);
timeVecBase = linspace(0,endPt,length(torquesBase));
normTimeVecBase = timeVecBase/stepPeriod;
stepCutoffBase = ceil(length(torquesBase)/stepNum);

stepStartIDs = 1;
stepIndL = [];
for i=2:length(tVecIndicesDiff)
    if tVecIndicesDiff(i-1) > 50
        stepStartIDs = [stepStartIDs i];
    end
end
stepStartIDs = [stepStartIDs length(timeVec)];
stepIndL = stepStartIDs(2:end) - stepStartIDs(1:end-1);
[maxStepIndL,maxStepIndLID] = max(stepIndL);

for act = 1:22
    for s=1:stepNum
        torqueStepTemp = torques(stepStartIDs(s):stepStartIDs(s+1)-1,act);
        timeVecStepNorm = (timeVec(stepStartIDs(s):stepStartIDs(s+1)-1)-timeVec(stepStartIDs(s)))/(timeVec(stepStartIDs(s+1)-1)-timeVec(stepStartIDs(s)));
        torquesSteps{act}(s,:) = interp1(timeVecStepNorm,torqueStepTemp,linspace(0,timeVecStepNorm(end),maxStepIndL));
        timeVecSteps{act} = linspace(0,timeVecStepNorm(end),maxStepIndL);
    end
    minTorques(act,:) = min(torquesSteps{act});
    maxTorques(act,:) = max(torquesSteps{act});
    meanTorque(:,act) = mean(torquesSteps{act},1);

    for s=1:stepNum-1
        torquesStepsBase{act}(s,:) = torquesBase(1+stepCutoffBase*(s-1):stepCutoffBase*(s),act);
    end
    meanTorqueBase(:,act) = mean(torquesStepsBase{act},1);
end
[r,~] = size(meanTorqueBase);
singleStepTimeVecBase = linspace(0,1,r);

figure
tl = tiledlayout(3,4,'TileSpacing','loose','Padding','compact');
tl.TileIndexing = 'columnmajor';
set(gcf,'Renderer','painters')
legStartCols = [1,4,7,10,13,18,23];
colors = {'#258942','#ab3377','#ddaa2f','#ed6677','#4478ab'};
legNames = {'Left Hind', 'Right Hind', 'Left Middle', 'Right Middle', 'Left Front', 'Right Front'};
handPlot1 = gobjects(5,1);
handPlot2 = gobjects(2,1);
chosenTripod = [1,4,5];

for l=chosenTripod
    if l <= 4
        jVec = 1:legStartCols(l+1)-legStartCols(l);
    else
        jVec = [1,2,3,4,5];
    end
    for j=jVec
        nexttile
        hold on
        if l == 1 || l == 4 || l == 5
            patch('XData',[.4 .4 1 1],'YData',[-3 3 3 -3],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
            %                     rectangle('Position',[.2+1*(s-1) 2 0.6 .1],'FaceColor','k')
        else
            for s = 1:2
                patch('XData',[-.1+1*(s-1) -.1+1*(s-1) .5+1*(s-1) .5+1*(s-1)],'YData',[-3 3 3 -3],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
                %                     rectangle('Position',[-.3+1*(s-1) 2 0.6 .1],'FaceColor','k')
            end
        end

        colIDs = legStartCols(l):legStartCols(l+1)-1;

        if l <= 4
            patch('XData',[timeVecSteps{colIDs(j)},fliplr(timeVecSteps{colIDs(j)})],'YData',[minTorques(colIDs(j),:),fliplr(maxTorques(colIDs(j),:))],'FaceColor',colors{j+2},'FaceAlpha',0.1,'EdgeColor','none')
            if l == 1 && j == 1
                handPlot2(1) = plot(timeVecSteps{colIDs(j)},meanTorque(:,colIDs(j)),'Color',colors{j+2},'LineWidth',1);
                hold on
                handPlot2(2) = plot(singleStepTimeVecBase,meanTorqueBase(:,colIDs(j)),'--','Color',colors{j+2},'LineWidth',0.75);
            else
                plot(timeVecSteps{colIDs(j)},meanTorque(:,colIDs(j)),'Color',colors{j+2},'LineWidth',1);
                hold on
                plot(singleStepTimeVecBase,meanTorqueBase(:,colIDs(j)),'--','Color',colors{j+2},'LineWidth',0.75);
            end
        else
            patch('XData',[timeVecSteps{colIDs(j)},fliplr(timeVecSteps{colIDs(j)})],'YData',[minTorques(colIDs(j),:),fliplr(maxTorques(colIDs(j),:))],'FaceColor',colors{j},'FaceAlpha',0.1,'EdgeColor','none')
            if l == 5
                handPlot1(j) = plot(timeVecSteps{colIDs(j)},meanTorque(:,colIDs(j)),'Color',colors{j},'LineWidth',1);
                plot(singleStepTimeVecBase,meanTorqueBase(:,colIDs(j)),'--','Color',colors{j},'LineWidth',0.75);
            else
                plot(timeVecSteps{colIDs(j)},meanTorque(:,colIDs(j)),'Color',colors{j},'LineWidth',1);
                plot(singleStepTimeVecBase,meanTorqueBase(:,colIDs(j)),'--','Color',colors{j},'LineWidth',0.75);
            end
        end
        if j==1
            title(legNames{l})
            if l <= 4
                axis([0 timeVecSteps{colIDs(j)}(end) -1.7 0.5])
            else
                axis([0 timeVecSteps{colIDs(j)}(end) -1 2])
            end
        elseif j==2
            if l <= 4
                axis([0 timeVecSteps{colIDs(j)}(end) -2.6 1])
            else
                axis([0 timeVecSteps{colIDs(j)}(end) -.8 .5])
            end
        elseif j==3
            if l <= 4
                axis([0 timeVecSteps{colIDs(j)}(end) -1 2.6])
            else
                axis([0 timeVecSteps{colIDs(j)}(end) -1.5 0.5])
            end
        elseif j==4
            axis([0 timeVecSteps{colIDs(j)}(end) -2.6 1])
        else
            axis([0 timeVecSteps{colIDs(j)}(end) -1 2])
        end
        grid on
        ylabel('Est. Torque (Nm)')
        xlabel('Step (%)')
        grid on
        ylabel('Est. Torque (Nm)')
        xlabel('Step (%)')
    end
end
lgd1 = legend(handPlot1(:,1),'ThC1','ThC3','CTr','TrF','FTi','Location','northoutside','Orientation','horizontal');
title(lgd1,'Degrees of Freedom')
lgd2 = legend(handPlot2,'Incline','Flat Plane','Location','northoutside','Orientation','horizontal');
title(lgd2,'Terrain Shape')

set(findall(gcf,'-property','FontSize'),'FontSize',14)
title(tl,'Incline Walking','FontSize',16)
subtitle(tl,['15 degree ramp, T_{step} = ' num2str(stepPeriod) ' s'],'FontSize',14)

