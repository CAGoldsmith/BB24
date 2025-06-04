%Plot the torques for a single robot trial
clear all
stepPeriod = 2;
stepNum = 5;
shiftAmnt = 21;
baseFolderLoc = 'C:\Users\Clarissa G\Documents\MATLAB\Running Drosophibot\Trials\';
trialName = '01-Sep-2023 17_01_41';
convEq = @(tau) 0.0029*tau + .1892;
trialData = load([baseFolderLoc trialName '\robotData.mat']);
torques = trialData.dxl_present_load_pp;
x = trialData.x;

try timeVec = trialData.timeVec;
catch
     endPt = trialData.actTimeStep*length(torques);
     timeVec = linspace(0,endPt,length(torques));
end
[r,c] = size(torques);

simBaseFolderLoc = 'C:\Users\Clarissa G\Documents\MATLAB\Design Drosophibot\';
simData = load([simBaseFolderLoc 'Physical Drosophibot 2\k_spring = 0\T_swing = ' num2str(stepPeriod*.4) '\allVars.mat'],'timeVecPlot','thetaPlot','Tactuator','stanceIDs','n');
for l=1:6
    simData.Tactuator{l} = circshift(simData.Tactuator{l},shiftAmnt,1);
end
simTimeVec = linspace(0,1,length(simData.Tactuator{1}));
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

normTimeVec = timeVec/stepPeriod;
stepCutoff = ceil(length(torques)/stepNum);

for act = 1:c
    torques(act,:) = convEq(torques(act,:));
    for s=1:stepNum-1
        torquesSteps{act}(s,:) = torques(1+stepCutoff*(s-1):stepCutoff*(s),act); 
    end
    minTorques(act,:) = min(torquesSteps{act});
    maxTorques(act,:) = max(torquesSteps{act});
    meanTorque(:,act) = mean(torquesSteps{act},1);
end
singleStepTimeVec = linspace(0,1,length(meanTorque));

tau = .065;
fil = exp(-singleStepTimeVec./tau);
for a = 1:c
    torquesFilt(:,a) = ifft(fft(meanTorque(:,a)')./fft(fil)).*sum(fil);
end

figure
tl = tiledlayout(2,3,'TileSpacing','tight','Padding','tight');
tl.TileIndexing = 'columnmajor';
set(gcf,'Renderer','painters')
legStartCols = [1,4,7,10,13,18,23];
colors = {'#77AC30','#7E2F8E','#EDB120','#D95319','#0072BD'};
legNames = {'Left Hind', 'Right Hind', 'Left Middle', 'Right Middle', 'Left Front', 'Right Front'};
handPlot = gobjects(5,1);
handPlot2 = gobjects(5,2);

for l=1:6
    nexttile
    hold on
    for s = 1:stepNum
        if patchStart(l,2) == 0
            patch('XData',[simTimeVec(patchStart(l,1))+(s-1) simTimeVec(patchStart(l,1))+(s-1) simTimeVec(patchEnd(l,1))+(s-1) simTimeVec(patchEnd(l,1))+(s-1)],'YData',[-2.5 2.5 2.5 -2.5],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
        else
            patch('XData',[simTimeVec(patchStart(l,1))+(s-1) simTimeVec(patchStart(l,1))+(s-1) simTimeVec(patchEnd(l,1))+(s-1) simTimeVec(patchEnd(l,1))+(s-1)],'YData',[-2.5 2.5 2.5 -2.5],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
            patch('XData',[simTimeVec(patchStart(l,2))+(s-1) simTimeVec(patchStart(l,2))+(s-1) simTimeVec(patchEnd(l,2))+(s-1) simTimeVec(patchEnd(l,2))+(s-1)],'YData',[-2.5 2.5 2.5 -2.5],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
        end
    end

    for j=1:legStartCols(l+1)-legStartCols(l)
        colIDs = legStartCols(l):legStartCols(l+1)-1;
            if l <= 4
                patch('XData',[singleStepTimeVec,fliplr(singleStepTimeVec)],'YData',[minTorques(colIDs(j),:),fliplr(maxTorques(colIDs(j),:))],'FaceColor',colors{j+2},'FaceAlpha',0.1,'EdgeColor','none')
                plot(singleStepTimeVec,meanTorque(:,colIDs(j)),'Color',colors{j+2},'LineWidth',0.75);
                if j <= 3
                    plot(simTimeVec,simData.Tactuator{l}(:,j+1),'Color',colors{j+2},'LineStyle','--')
                end
            else
                if l == 5
                    patch('XData',[singleStepTimeVec,fliplr(singleStepTimeVec)],'YData',[minTorques(colIDs(j),:),fliplr(maxTorques(colIDs(j),:))],'FaceColor',colors{j},'FaceAlpha',0.1,'EdgeColor','none')
                    handPlot(j,1) = plot(singleStepTimeVec,meanTorque(:,colIDs(j)),'Color',colors{j},'LineWidth',0.75);
                else
                    patch('XData',[singleStepTimeVec,fliplr(singleStepTimeVec)],'YData',[minTorques(colIDs(j),:),fliplr(maxTorques(colIDs(j),:))],'FaceColor',colors{j},'FaceAlpha',0.1,'EdgeColor','none')
                    handPlot2(j,1) = plot(singleStepTimeVec,meanTorque(:,colIDs(j)),'Color',colors{j},'LineWidth',0.75);
                end
                if j <= 5
                    handPlot2(j,2) = plot(simTimeVec,simData.Tactuator{l}(:,j),'Color',colors{j},'LineStyle','--');
                end
            end
    end
    title(legNames{l})
    axis([0 singleStepTimeVec(end) -2.5 2.5])
    grid on
    if l <= 2
        ylabel('Actuator Torque (Nm)')
    end
    xlabel('Steps')

    if l == 5
        lgd1 = legend(handPlot(:,1),'ThC1','ThC3','CTr','TrF','FTi','Location','northoutside','Orientation','horizontal');
        title(lgd1,'Joints')
    elseif l == 6
        lgd2 = legend(handPlot2(1,:),'Actual','Calculated','Location','southoutside','Orientation','horizontal');
    end
    
end

title(tl,'DROSOPHIBOT II FORWARD WALKING')
subtitle(tl,'Calculated vs. Actual')
