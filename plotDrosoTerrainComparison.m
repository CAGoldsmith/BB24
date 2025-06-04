%Plot a comparison of the fly walking the ball vs. flat ground
clear all
close all
% baseFolderLoc = 'C:\Users\Clarissa G\Documents\MATLAB\Design Drosophibot\';
baseFolderLoc = 'G:\Other computers\NeuroMINT Lab Computer\MATLAB\Design Drosophibot\';
k_spring = 3.8e-08;
T_swing = 0.1;
terrainShape = {'Flat', 'Ball'};
for o=1:length(terrainShape)
        data{o} = load([baseFolderLoc  'Scale Drosophila\' terrainShape{o} '\k_spring = ' num2str(k_spring) '\T_swing = ' num2str(T_swing) '\allVars.mat'],'timeVecPlot','thetaPlot','Tactuator');
        for L=1:6
            data{o}.Tactuator{L} = data{o}.Tactuator{L}*1e9;
        end
end

timeVecNorm = data{1}.timeVecPlot/(T_swing(1)/.4);
colors = {"#67CCED",'#258942','#ab3377','#ddaa2f','#ed6677','#4478ab'};
legNames = {'Left Hind','Right Hind','Left Middle','Right Middle','Left Front','Right Front'};
chosenTripod = [1,4,5];
handPlot1 = gobjects(6,1);
handPlot2 = gobjects(1,2);


figure
tl1 = tiledlayout(6,6,'TileSpacing','loose','Padding','compact');
tl1.TileIndexing = 'rowmajor';
set(gcf,'Renderer','painters')
lineW = 1;
tileCount = 1;
row = 1;

for l=chosenTripod
    for i = 1:12
        nexttile(tileCount)
        if chosenTripod(1) == 1
            patch('XData',[0.2 0.2 0.8 0.8],'YData',[-60 80 80 -60],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
        else
            patch('XData',[-.3 -.3 .3 .3],'YData',[-60 80 80 -60],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
            patch('XData',[.5 .5 1.1 1.1],'YData',[-60 80 80 -60],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
        end
        hold on
        if i <=6
            if l==1
                handPlot1(i) = plot(timeVecNorm, data{1}.thetaPlot{l}(:,i),"Color",colors{i},'LineWidth',lineW);
                if i == 6
                    handPlot2(1) = handPlot1(i);
                end
            else
                plot(timeVecNorm, data{1}.thetaPlot{l}(:,i),"Color",colors{i},'LineWidth',lineW);
            end
            hold on
            if l == 1 && i == 6
                handPlot2(2) = plot(timeVecNorm, data{2}.thetaPlot{l}(:,i),"Color",colors{i},'LineWidth',lineW,'LineStyle','--');
            else
                plot(timeVecNorm, data{2}.thetaPlot{l}(:,i),"Color",colors{i},'LineWidth',lineW,'LineStyle','--');
            end
            grid on
            ylim([-1.6 1])
            if i==1
                ylabel({legNames{l}; 'Kinematics'; 'Angle (rad)'})
            end
        else
            plot(timeVecNorm, data{1}.Tactuator{l}(:,i-6),"Color",colors{i-6},'LineWidth',lineW)
            hold on
            plot(timeVecNorm, data{2}.Tactuator{l}(:,i-6),"Color",colors{i-6},'LineWidth',lineW,'LineStyle','--')
            if i == 7
                ylabel({'Dynamics';'Torque (uNmm)'})
            end
            grid on
            ylim([-60 80])

            if row == 3
                xlabel('Step (%)')
            end
        end
        tileCount = tileCount + 1;
    end
    row = row + 1;
end
lgd1 = legend(handPlot1(:,1),'ThC2','ThC1','ThC3','CTr','TrF','FTi','Location','northoutside','Orientation','horizontal');
title(lgd1,'Degrees of Freedom')
lgd2 = legend(handPlot2,'Flat Plane','Ball','Location','northoutside','Orientation','horizontal');
title(lgd2,'Terrain Shape')
title(tl1, {'DROSOPHILA TERRAIN SHAPE COMPARISON'})
