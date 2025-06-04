%Plot the torques for a single robot trial
clear all
%Load the robot data for a particular trial
stepPeriod = 2;
stepNum = 5;
shiftAmnt = 21;
baseFolderLoc = 'C:\Users\Clarissa G\Documents\MATLAB\Running Drosophibot\Trials\';
trialName = '01-Sep-2023 17_01_41';
trialData = load([baseFolderLoc trialName '\robotData.mat']);
torques = trialData.dxl_present_load_pp;
endPt = trialData.actTimeStep*length(torques);
timeVec = linspace(0,endPt,length(torques));
x = trialData.x;
[~,c] = size(torques);
normTimeVec = timeVec/stepPeriod;
stepCutoff = ceil(length(torques)/stepNum);


for act = 1:c
    for s=1:stepNum-1
        torquesSteps{act}(s,:) = torques(1+stepCutoff*(s-1):stepCutoff*(s),act);
    end
    minTorques(act,:) = min(torquesSteps{act});
    maxTorques(act,:) = max(torquesSteps{act});
    meanTorque(:,act) = mean(torquesSteps{act},1);
end
[r,~] = size(meanTorque);
singleStepTimeVec = linspace(0,1,r);

%Load variables from the simulated data that was used to run this trial
simBaseFolderLoc = 'C:\Users\Clarissa G\Documents\MATLAB\Design Drosophibot\';
simData = load([simBaseFolderLoc 'Physical Drosophibot 2\k_spring = 0\T_swing = ' num2str(stepPeriod*.4) '\allVars.mat'],'timeVecPlot','thetaPlot','Tactuator','stanceIDs','n');
for l=1:6
    simData.Tactuator{l} = circshift(simData.Tactuator{l},shiftAmnt,1);
end
simTimeVec = linspace(0,1,length(simData.Tactuator{1}))*stepPeriod;
normSimTimeVec = linspace(0,1,length(simData.Tactuator{1}));
stanceIDs = simData.stanceIDs;
n = simData.n;
patchStart = zeros(6,2);
patchEnd = zeros(6,2);
for l=1:6
    %Shift the stance IDs by the shiftAmnt
    stanceIDs{l} = stanceIDs{l}+shiftAmnt;
    %If any of the numbers end up greater than the number of data points
    %after the shift, subtract n
    for i=1:length(stanceIDs{l})
        if stanceIDs{l}(i) > n
            stanceIDs{l}(i) = stanceIDs{l}(i) - n;
        end
    end
    %Reorder so the points are in ascending order
    stanceIDs{l} = sort(stanceIDs{l});
    %
    stanceDiff = diff(stanceIDs{l});
    patchStart(l,1) = stanceIDs{l}(1);
    if sum(stanceDiff) > length(stanceDiff)
        [~,maxID] = max(stanceDiff);
        patchEnd(l,1) = stanceIDs{l}(maxID);
        patchStart(l,2) = stanceIDs{l}(maxID+1);
        patchEnd(l,2) = stanceIDs{l}(end);
    else
        patchEnd(l,1) = stanceIDs{l}(end);
    end
end


%Create a normalized time vector for plotting in terms of steps
normTimeVec = timeVec/stepPeriod;

%Create the figure
figure
tl = tiledlayout(3,7,'TileSpacing','tight','Padding','tight');
tl.TileIndexing = 'columnmajor';
set(gcf,'Renderer','painters')
legStartCols = [1,4,7,10,13,18,23];
colors = {'#77AC30','#7E2F8E','#EDB120','#D95319','#0072BD'};
legNames = {'Left Hind', 'Right Hind', 'Left Middle', 'Right Middle', 'Left Front', 'Right Front'};
handPlot = gobjects(5,1);
chosenTripod = [1,4,5];

for l=chosenTripod %For each leg...
    nexttile([1 3]);
    hold on
    %Plot a series of patches to signify stance phase
    for s = 1:stepNum
        if patchStart(l,2) == 0
            patch('XData',[simTimeVec(patchStart(l,1))+(s-1)*stepPeriod simTimeVec(patchStart(l,1))+(s-1)*stepPeriod simTimeVec(patchEnd(l,1))+(s-1)*stepPeriod simTimeVec(patchEnd(l,1))+(s-1)*stepPeriod],'YData',[-2.5 2.5 2.5 -2.5],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
        else
            patch('XData',[simTimeVec(patchStart(l,1))+(s-1)*stepPeriod simTimeVec(patchStart(l,1))+(s-1)*stepPeriod simTimeVec(patchEnd(l,1))+(s-1)*stepPeriod simTimeVec(patchEnd(l,1))+(s-1)*stepPeriod],'YData',[-2.5 2.5 2.5 -2.5],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
            patch('XData',[simTimeVec(patchStart(l,2))+(s-1)*stepPeriod simTimeVec(patchStart(l,2))+(s-1)*stepPeriod simTimeVec(patchEnd(l,2))+(s-1)*stepPeriod simTimeVec(patchEnd(l,2))+(s-1)*stepPeriod],'YData',[-2.5 2.5 2.5 -2.5],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
        end
    end
    %For the number of joints in the leg...
    for j=1:legStartCols(l+1)-legStartCols(l)
        colIDs = legStartCols(l):legStartCols(l+1)-1;
        %Plot the torque curve with the appropriate color
            if l <= 4
                plot(timeVec,torques(:,colIDs(j)),'Color',colors{j+2});
            else
                if l == 5
                    %If we're in leg 5, store these lines in the legend
                    %variable
                    handPlot(j,1) = plot(timeVec,torques(:,colIDs(j)),'Color',colors{j});
                else
                    plot(timeVec,torques(:,colIDs(j)),'Color',colors{j});
                end
            end
    end
    title(legNames{l})
    axis([0 stepPeriod*stepNum -2.5 2.5])
    grid on
    ylabel('Actuator Torque (Nm)')
    xlabel('Time (s)')

    if l == 5
        lgd1 = legend(handPlot(:,1),'ThC1','ThC3','CTr','TrF','FTi','Location','northoutside','Orientation','horizontal');
        title(lgd1,'Joints')
    end
end

legActIDs = [1,2,3,10,11,12,13,14,15,16,17];
colorIDs = [3,4,5,3,4,5,1,2,3,4,5];

for act = 1:length(legActIDs)
    nexttile
    patch('XData',[normSimTimeVec(patchStart(1,1)) normSimTimeVec(patchStart(1,1)) normSimTimeVec(patchEnd(1,1)) normSimTimeVec(patchEnd(1,1))],'YData',[-2.5 2.5 2.5 -2.5],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
    patch('XData',[singleStepTimeVec,fliplr(singleStepTimeVec)],'YData',[minTorques(legActIDs(act),:),fliplr(maxTorques(legActIDs(act),:))],'FaceColor',colors{colorIDs(act)},'FaceAlpha',0.1,'EdgeColor','none')
    hold on
    plot(singleStepTimeVec,meanTorque(:,legActIDs(act)),'Color',colors{colorIDs(act)},'LineWidth',0.75);
    ylim([-2.5 2.5])
    grid on
    if legActIDs(act) == 1
        title(legNames{1})
    elseif legActIDs(act) == 10
        title(legNames{4})
    elseif legActIDs(act) == 13
        title(legNames{5})
    end
    ylabel('Est. Actuator Torque (Nm)')
    xlabel('Step (%)')
end

title(tl,'Drosophibot II Forward Walking')
subtitle(tl,['T_{step} = ' num2str(stepPeriod) ' s'])
