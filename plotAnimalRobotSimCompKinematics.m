%Plot the angles for each leg during a simulated trial for Drosophibot II
%and Drosophila
clear all
close all
baseFolderLoc = 'C:\Users\Clarissa G\Documents\MATLAB\Design Drosophibot\';
% baseFolderLoc = 'G:\Other computers\NeuroMINT Lab Computer\MATLAB\Design Drosophibot\';
organism = {'Drosophibot 2 Alt Hind Legs', 'Scale Drosophila'};
% k_spring = [1;3e-09];
k_spring = [0;0];
T_swing = [1.6,0.1];
% terrainShape = 'Ball';
terrainShape = 'Flat';
for o=1:length(organism)
    if contains(terrainShape,'Flat') %&& o == 1
        data{o} = load([baseFolderLoc organism{o} '\' terrainShape '\k_spring = ' num2str(k_spring(o)) '\T_swing = ' num2str(T_swing(o)) '\phi_I = 0.5\phi_C = 0.5\allVars.mat'],'timeVecPlot','thetaPlot','Tactuator');
    else
        data{o} = load([baseFolderLoc organism{o} '\' terrainShape '\k_spring = ' num2str(k_spring(o)) '\T_swing = ' num2str(T_swing(o)) '\allVars.mat'],'timeVecPlot','thetaPlot','Tactuator');
    end
end
for L=1:6
    if ~rem(L,2)
        if L <= 4
            data{1}.thetaPlot{L}(:,3) = -data{1}.thetaPlot{L}(:,3);
            data{1}.Tactuator{L}(:,3) = -data{1}.Tactuator{L}(:,3);
        else
            data{1}.thetaPlot{L}(:,4) = -data{1}.thetaPlot{L}(:,4);
            data{1}.Tactuator{L}(:,4) = -data{1}.Tactuator{L}(:,4);
        end
    end
end
timeVecNorm = data{1}.timeVecPlot/(T_swing(1)/.4);
colors = {"#67CCED",'#258942','#ab3377','#ddaa2f','#ed6677','#4478ab'};
legNames = {'Left Hind','Right Hind','Left Middle','Right Middle','Left Front','Right Front'};
chosenTripod = [1,4,5];
% chosenTripod = [2,3,6];
handPlot1 = gobjects(7,1);
handPlot2 = gobjects(1,2);

fig = figure;
tl1 = tiledlayout(3,3,'TileSpacing','loose','Padding','compact','TileIndexing','columnmajor');
set(fig,'Renderer','painters')
lineW = 1;

for l=chosenTripod
    for c=1:3
    nexttile
    if chosenTripod(1) == 1
        patch('XData',[0.2 0.2 0.8 0.8],'YData',[-1.6 1.2 1.2 -1.6],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
    else
        patch('XData',[-.3 -.3 .3 .3],'YData',[-1.6 1.2 1.2 -1.6],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
        patch('XData',[.5 .5 1.1 1.1],'YData',[-1.6 1.2 1.2 -1.6],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
    end
    hold on
        if c == 1
            if l <= chosenTripod(2)
                plot(timeVecNorm,data{1}.thetaPlot{l}(:,3),'Color',colors{5},'LineWidth',lineW)
            else
                handPlot1(5) = plot(timeVecNorm,data{1}.thetaPlot{l}(:,4),'Color',colors{5},'LineWidth',lineW);
                handPlot1(2) = plot(timeVecNorm,data{1}.thetaPlot{l}(:,1),'Color',colors{2},'LineWidth',lineW);
                handPlot1(3) = plot(timeVecNorm,data{1}.thetaPlot{l}(:,2),'Color',colors{3},'LineWidth',lineW);
            end
            plot(timeVecNorm,data{2}.thetaPlot{l}(:,5),'Color',colors{5},'LineStyle','--','LineWidth',lineW)
            plot(timeVecNorm,data{2}.thetaPlot{l}(:,2),'Color',colors{2},'LineStyle','--','LineWidth',lineW)
            plot(timeVecNorm,data{2}.thetaPlot{l}(:,3),'Color',colors{3},'LineStyle','--','LineWidth',lineW)
            % plot(timeVecNorm,data{2}.thetaPlot{l}(:,3)+data{2}.thetaPlot{l}(:,2)+data{2}.thetaPlot{l}(:,5),'Color','k','LineStyle','--','LineWidth',lineW)
            title(legNames{l})
            xlabel('Steps (s)')
            if l == chosenTripod(1)
                ylabel({'Pro/Sup'; 'Angle(rad)'})
            end
            if contains(terrainShape,'Flat')
                ylim([-1.2 1])
            else
                ylim([-1.6 1.2])
            end

        elseif c == 2
            if l <= chosenTripod(2)
                plot(timeVecNorm,data{1}.thetaPlot{l}(:,2),'Color',colors{4},'LineWidth',lineW)
                plot(timeVecNorm,data{2}.thetaPlot{l}(:,1),'Color',colors{1},'LineStyle','--','LineWidth',lineW)
            else
                handPlot1(4) = plot(timeVecNorm,data{1}.thetaPlot{l}(:,3),'Color',colors{4},'LineWidth',lineW);
                handPlot1(1) = plot(timeVecNorm,data{2}.thetaPlot{l}(:,1),'Color',colors{1},'LineStyle','--','LineWidth',lineW);
            end
            plot(timeVecNorm,data{2}.thetaPlot{l}(:,4),'Color',colors{4},'LineStyle','--','LineWidth',lineW)
            test = mean([data{2}.thetaPlot{l}(:,4) data{2}.thetaPlot{l}(:,1)],2);
            if l == chosenTripod(3)
                handPlot1(7) = plot(timeVecNorm,data{2}.thetaPlot{l}(:,4)+data{2}.thetaPlot{l}(:,1),'LineStyle','--','Color','k','LineWidth',lineW);
            else
                plot(timeVecNorm,data{2}.thetaPlot{l}(:,4)+data{2}.thetaPlot{l}(:,1),'LineStyle','--','Color','k','LineWidth',lineW)
            end
            xlabel('Steps (s)')
            if l == chosenTripod(1)
                ylabel({'Lev/Dep';'Angle (rad)'})
            end
            if contains(terrainShape,'Flat')
                ylim([-1.2 1])
            else
                ylim([-1.6 1.2])
            end
        else
            if l <= chosenTripod(2)
                if l == chosenTripod(1)
                    handPlot2(1) = plot(timeVecNorm,data{1}.thetaPlot{l}(:,4),'Color',colors{6},'LineWidth',lineW);
                    handPlot2(2) = plot(timeVecNorm,data{2}.thetaPlot{l}(:,6),'Color',colors{6},'LineStyle','--','LineWidth',lineW);
                else
                    plot(timeVecNorm,data{1}.thetaPlot{l}(:,4),'Color',colors{6},'LineWidth',lineW)
                    plot(timeVecNorm,data{2}.thetaPlot{l}(:,6),'Color',colors{6},'LineStyle','--','LineWidth',lineW)
                end
            else
                handPlot1(6) = plot(timeVecNorm,data{1}.thetaPlot{l}(:,5),'Color',colors{6},'LineWidth',lineW);
                plot(timeVecNorm,data{2}.thetaPlot{l}(:,6),'Color',colors{6},'LineStyle','--','LineWidth',lineW)
            end
            xlabel('Steps (s)')
            if l == chosenTripod(1)
                ylabel({'Ext/Flx';'Angle (rad)'})
            end
            if contains(terrainShape,'Flat')
                ylim([-1.2 1])
            else
                ylim([-1.6 1.2])
            end
        end
        xlim([0 1])
        grid on
    end

end
lgd1 = legend(handPlot1(:,1),'ThC2','ThC1','ThC3','CTr','TrF','FTi','ThC2 + CTr','Location','southoutside','Orientation','horizontal');
title(lgd1,'Degrees of Freedom')
lgd2 = legend(handPlot2(1,:),'Drosophibot II','Scale Drosophila','Location','southoutside','Orientation','horizontal');
title(lgd2,'Organism');
title(tl1,'KINEMATIC COMPARISON')
subtitle(tl1,'Drosophibot II vs. Scaled Drosophila')
