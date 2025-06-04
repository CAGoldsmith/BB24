clear all
stepPeriod = 2;
stepNum = 5;
baseFolderLoc = 'C:\Users\Clarissa G\Documents\MATLAB\Running Drosophibot\Trials\';
trialNames = {'2023-09-01 17_18_33','2023-09-01 17_01_41'};
for tr=1:length(trialNames)
    trialData = load([baseFolderLoc trialNames{tr} '\robotData.mat']);
    torques{tr} = trialData.dxl_present_load_pp;
    try timeVec{tr} = trialData.timeVec;
    catch
        endPt = trialData.actTimeStep*length(torques{tr});
        timeVec{tr} = linspace(0,endPt,length(torques{tr}));
    end
    [~,c] = size(torques{tr});
    normTimeVec{tr} = timeVec{tr}/stepPeriod;
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
tl = tiledlayout(3,4,'TileSpacing','loose','Padding','compact');
tl.TileIndexing = 'columnmajor';
set(gcf,'Renderer','painters')
legStartCols = [1,4,7,10,13,18,23];
colors = {'#77AC30','#7E2F8E','#EDB120','#D95319','#0072BD'};
legNames = {'Left Hind', 'Right Hind', 'Left Middle', 'Right Middle', 'Left Front', 'Right Front'};
lineStyles = {'-','--',':'};
handPlot1 = gobjects(5,2);
handPlot2 = gobjects(5,2);
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
            for s = 1:stepNum
                patch('XData',[.4+1*(s-1) .4+1*(s-1) 1+(s-1) 1+(s-1)],'YData',[-2.5 2.5 2.5 -2.5],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
                %                     rectangle('Position',[.2+1*(s-1) 2 0.6 .1],'FaceColor','k')
            end
        else
            for s = 1:stepNum+1
                patch('XData',[-.1+1*(s-1) -.1+1*(s-1) .5+1*(s-1) .5+1*(s-1)],'YData',[-2.5 2.5 2.5 -2.5],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
                %                     rectangle('Position',[-.3+1*(s-1) 2 0.6 .1],'FaceColor','k')
            end
        end

        colIDs = legStartCols(l):legStartCols(l+1)-1;
        for tr=1:length(trialNames)
            if l <= 4
                if tr < 2
                    patch('XData',[singleStepTimeVec{tr},fliplr(singleStepTimeVec{tr})],'YData',[minTorques{tr}(colIDs(j),:),fliplr(maxTorques{tr}(colIDs(j),:))],'FaceColor',colors{j+2},'FaceAlpha',0.1,'EdgeColor','none')
                end
                plot(singleStepTimeVec{tr},meanTorque{tr}(:,colIDs(j)),'LineStyle',lineStyles{tr},'Color',colors{j+2},'LineWidth',0.75);
            else
                if l == 5
                    if tr < 2
                        patch('XData',[singleStepTimeVec{tr},fliplr(singleStepTimeVec{tr})],'YData',[minTorques{tr}(colIDs(j),:),fliplr(maxTorques{tr}(colIDs(j),:))],'FaceColor',colors{j},'FaceAlpha',0.1,'EdgeColor','none')
                    end
                    handPlot1(j,tr) = plot(singleStepTimeVec{tr},meanTorque{tr}(:,colIDs(j)),'LineStyle',lineStyles{tr},'Color',colors{j},'LineWidth',0.75);
                else
                    if tr < 2
                        patch('XData',[singleStepTimeVec{tr},fliplr(singleStepTimeVec{tr})],'YData',[minTorques{tr}(colIDs(j),:),fliplr(maxTorques{tr}(colIDs(j),:))],'FaceColor',colors{j},'FaceAlpha',0.1,'EdgeColor','none')
                    end
                    handPlot2(j,tr) = plot(singleStepTimeVec{tr},meanTorque{tr}(:,colIDs(j)),'LineStyle',lineStyles{tr},'Color',colors{j},'LineWidth',0.75);
                end
            end
        end
        if j==1
            title(legNames{l})
            if l <= 4
                axis([0 singleStepTimeVec{1}(end) -1.5 0.5])
            else
                axis([0 singleStepTimeVec{1}(end) -1 2])
            end
        elseif j==2
            if l <= 4
                axis([0 singleStepTimeVec{1}(end) -2.6 1])
            else
                axis([0 singleStepTimeVec{1}(end) -.5 .5])
            end
        elseif j==3
            if l <= 4
                axis([0 singleStepTimeVec{1}(end) -1 2])
            else
                axis([0 singleStepTimeVec{1}(end) -1.5 0.5])
            end
        elseif j==4
            axis([0 singleStepTimeVec{1}(end) -2.6 1])
        else
            axis([0 singleStepTimeVec{1}(end) -1 2])
        end
        grid on
        ylabel('Est. Torque (Nm)')
        xlabel('Steps')

        % if l == 5 && j==2
        %     lgd2 = legend(handPlot1(:,1),'ThC1','ThC3','CTr','TrF','FTi','Location','southoutside');
        %     title(lgd2,'Joints')
        % end
    end
end

title(tl,'EFFECT OF WALKING DIRECTION ON DYNAMICS');
subtitle(tl,'Backward vs. Forward Walking');
set(findall(gcf,'-property','FontSize'),'FontSize',14)
