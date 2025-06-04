clear all
simBaseFolderLoc = 'C:\Users\Clarissa G\Documents\MATLAB\Design Drosophibot\';
organism = 'Drosophibot 2';
k_spring = 0;
T_swing = [0.4,0.8,1.6];
T_step = T_swing/0.4;
for tr=1:length(T_swing)
    simData{tr} = load([simBaseFolderLoc organism '\k_spring = ' num2str(k_spring) '\T_swing = ' num2str(T_swing(tr)) '\allVars.mat'],'timeVecPlot','thetaPlot','Tactuator');
end
stepNum = 5;
trialBaseFolderLoc = 'C:\Users\Clarissa G\Documents\MATLAB\Running Drosophibot\Trials\';
trialNames = {'01-Sep-2023 17_07_07', '01-Sep-2023 17_01_41', '01-Sep-2023 17_05_44'};
for tr=1:length(trialNames)
    trialData = load([trialBaseFolderLoc trialNames{tr} '\robotData.mat']);
    torques{tr} = trialData.dxl_present_load_pp;
    try timeVec{tr} = trialData.timeVec;
    catch
        endPt = trialData.actTimeStep*length(torques{tr});
        timeVec{tr} = linspace(0,endPt,length(torques{tr}));
    end
    [r,c] = size(torques{tr});
    torques{tr} = circshift(torques{tr},-ceil((r/stepNum)*.2),1);
    normTimeVec{tr} = timeVec{tr}/T_step(tr);
    stepCutoff(tr) = ceil(length(torques{tr})/stepNum);
    for act = 1:c
        for s=1:stepNum-1
            torquesSteps{tr}{act}(s,:) = torques{tr}(1+stepCutoff(tr)*(s-1):stepCutoff(tr)*(s),act);
        end
        minTorques{tr}(act,:) = min(torquesSteps{tr}{act});
        maxTorques{tr}(act,:) = max(torquesSteps{tr}{act});
        meanTorque{tr}(:,act) = mean(torquesSteps{tr}{act},1);
    end
    [r,~] = size(meanTorque{tr});
    singleStepTimeVec{tr} = linspace(0,1,r);
end

figure
tl = tiledlayout(2,3,'TileSpacing','tight','Padding','tight');
set(gcf,'Renderer','painters')
colors = {'#77AC30','#7E2F8E','#EDB120','#D95319','#0072BD'};
legNames = {'Left Hind', 'Right Hind', 'Left Middle', 'Right Middle', 'Left Front', 'Right Front'};
chosenTripod = [1,4,5];
lineStyles = {'-','--',':'};
handPlot1 = gobjects(5,3);
handPlot2 = gobjects(5,3);
simTimeVec = linspace(0,1,length(simData{1}.Tactuator{1}));
for l=1:3
    nexttile(l)
    hold on
    for tr=1:length(T_swing)
        [r,c] = size(simData{tr}.Tactuator{chosenTripod(l)});
        if tr == 1
            patch('XData',[0.2 0.2 0.8 0.8],'YData',[-2.5 2.5 2.5 -2.5],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
            %         rectangle('Position',[r*.2 2 r*.6 .1],'FaceColor','k')
        end
        if chosenTripod(l) <= 4
            for j=2:c-1
                    plot(simTimeVec,simData{tr}.Tactuator{chosenTripod(l)}(:,j),'Color',colors{j+1},'LineStyle',lineStyles{tr},'LineWidth',0.75)
            end
        else
            for j=1:c-1
                handPlot1(j,tr) = plot(simTimeVec,simData{tr}.Tactuator{chosenTripod(l)}(:,j),'Color',colors{j},'LineStyle',lineStyles{tr},'LineWidth',0.75);
            end
        end
    end
    if l == 1
        axis([0 simTimeVec(end) -2.5 2.5])
        ylabel('Actuator Torque (Nm)')
    elseif l == 2
        axis([0 simTimeVec(end) -2 1])
    else
        axis([0 simTimeVec(end) -2 1.75])
    end
    grid on
    xlabel('Steps')
if l == 2
    title('Simulated Torques')
end
subtitle(legNames{chosenTripod(l)})
if l == 3
        lgd1 = legend(handPlot1(:,1),'ThC1','ThC3','CTr','TrF','FTi','Location','northeastoutside');
        title(lgd1,'Joints')
end
end

legStartCols = [1,4,7,10,13,18,23];
for l=1:3
    nexttile(l+3)
    hold on
    if chosenTripod(l) == 1 || chosenTripod(l) == 4 || chosenTripod(l) == 5
        for s = 1:stepNum
            patch('XData',[.2+1*(s-1) .2+1*(s-1) .8+(s-1) .8+(s-1)],'YData',[-2.5 2.5 2.5 -2.5],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
            %                     rectangle('Position',[.2+1*(s-1) 2 0.6 .1],'FaceColor','k')
        end
    else
        for s = 1:stepNum+1
            patch('XData',[-.3+1*(s-1) -.3+1*(s-1) .3+1*(s-1) .3+1*(s-1)],'YData',[-2.5 2.5 2.5 -2.5],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
            %                     rectangle('Position',[-.3+1*(s-1) 2 0.6 .1],'FaceColor','k')
        end
    end
    for j=1:legStartCols(chosenTripod(l)+1)-legStartCols(chosenTripod(l))
        colIDs = legStartCols(chosenTripod(l)):legStartCols(chosenTripod(l)+1)-1;
        for tr=1:length(trialNames)
            if chosenTripod(l) <= 4
                % plot(normTimeVec{tr},torques{tr}(:,colIDs(j)),'LineStyle',lineStyles{tr},'Color',colors{j+2},'LineWidth',0.75);
                patch('XData',[singleStepTimeVec{tr},fliplr(singleStepTimeVec{tr})],'YData',[minTorques{tr}(colIDs(j),:),fliplr(maxTorques{tr}(colIDs(j),:))],'FaceColor',colors{j+2},'FaceAlpha',0.1,'EdgeColor','none')
                plot(singleStepTimeVec{tr},meanTorque{tr}(:,colIDs(j)),'LineStyle',lineStyles{tr},'Color',colors{j+2},'LineWidth',0.75)
            else
                if l == 3
                    patch('XData',[singleStepTimeVec{tr},fliplr(singleStepTimeVec{tr})],'YData',[minTorques{tr}(colIDs(j),:),fliplr(maxTorques{tr}(colIDs(j),:))],'FaceColor',colors{j},'FaceAlpha',0.1,'EdgeColor','none')
                    % handPlot2(j,tr) = plot(normTimeVec{tr},torques{tr}(:,colIDs(j)),'LineStyle',lineStyles{tr},'Color',colors{j},'LineWidth',0.75);
                    handPlot2(j,tr) = plot(singleStepTimeVec{tr},meanTorque{tr}(:,colIDs(j)),'LineStyle',lineStyles{tr},'Color',colors{j},'LineWidth',0.75);
                else
                    patch('XData',[singleStepTimeVec{tr},fliplr(singleStepTimeVec{tr})],'YData',[minTorques{tr}(colIDs(j),:),fliplr(maxTorques{tr}(colIDs(j),:))],'FaceColor',colors{j},'FaceAlpha',0.1,'EdgeColor','none')
                    % plot(normTimeVec{tr},torques{tr}(:,colIDs(j)),'LineStyle',lineStyles{tr},'Color',colors{j},'LineWidth',0.75);
                    plot(singleStepTimeVec{tr},meanTorque{tr}(:,colIDs(j)),'LineStyle',lineStyles{tr},'Color',colors{j},'LineWidth',0.75);
                end
            end
        end
    end

    if l == 2
        title('Recorded Robot Torques')
    end
    subtitle(legNames{chosenTripod(l)})
    if l == 1
        % axis([0 normTimeVec{1}(end) -2.5 2.5])
        axis([0 singleStepTimeVec{1}(end) -2.5 2.5])
        ylabel('Actuator Torque (Nm)')
    elseif l == 2
        % axis([0 normTimeVec{1}(end) -2 1])
        axis([0 singleStepTimeVec{1}(end) -2 1])
    else
        % axis([0 normTimeVec{1}(end) -2 1.75])
        axis([0 singleStepTimeVec{1}(end) -2 1.75])
    end
    grid on
    xlabel('Steps')

    if l == 3
        lgd2 = legend(handPlot2(end,:),[num2str(T_step(1)) ' s'],[num2str(T_step(2)) ' s'],[num2str(T_step(3)) ' s'],'Location','northeastoutside');
        title(lgd2,'Stepping Periods')
    end
end

 set(findall(gcf,'-property','FontSize'),'FontSize',14)
