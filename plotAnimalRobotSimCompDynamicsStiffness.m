%Plot the torques for each leg during a simulated trial
clear all
close all
baseFolderLoc = 'C:\Users\Clarissa G\Documents\MATLAB\Design Drosophibot\';
% baseFolderLoc = 'G:\Other computers\NeuroMINT Lab Computer\MATLAB\Design Drosophibot\';
organism = {'Drosophibot 2', 'Scale Drosophila'};
k_spring = [1;3.8e-08];
T_swing = [1.6,0.1];
scaleFactor = 1e9;
% terrainShape = 'Flat';
terrainShape = 'Ball';
for o=1:length(organism)
    if contains(terrainShape,'Flat') && o == 1
        dataNoStiff{o} = load([baseFolderLoc organism{o} '\' terrainShape '\k_spring = 0\T_swing = ' num2str(T_swing(o)) '\phi_I = 0.5\phi_C = 0.5\allVars.mat'],'timeVecPlot','thetaPlot','Tactuator');
    else
        dataNoStiff{o} = load([baseFolderLoc organism{o} '\' terrainShape '\k_spring = 0\T_swing = ' num2str(T_swing(o)) '\allVars.mat'],'timeVecPlot','thetaPlot','Tactuator');
    end
end
for o=1:length(organism)
        dataStiff{o} = load([baseFolderLoc organism{o} '\' terrainShape '\k_spring = ' num2str(k_spring(o)) '\T_swing = ' num2str(T_swing(o)) '\allVars.mat'],'timeVecPlot','thetaPlot','Tactuator');
end
for i=1:6
    dataNoStiff{2}.Tactuator{i} = dataNoStiff{2}.Tactuator{i}*scaleFactor;
    dataStiff{2}.Tactuator{i} = dataStiff{2}.Tactuator{i}*scaleFactor;
    if ~rem(i,2)
        if i <= 4
            dataNoStiff{1}.Tactuator{i}(:,3) = -dataNoStiff{1}.Tactuator{i}(:,3);
            dataStiff{1}.Tactuator{i}(:,3) = -dataStiff{1}.Tactuator{i}(:,3);
        else
            dataNoStiff{1}.Tactuator{i}(:,4) = -dataNoStiff{1}.Tactuator{i}(:,4);
            dataStiff{1}.Tactuator{i}(:,4) = -dataStiff{1}.Tactuator{i}(:,4);
        end
    end
end
timeVecNorm = dataNoStiff{1}.timeVecPlot/(T_swing(1)/.4);
colors = {"#67CCED",'#258942','#ab3377','#ddaa2f','#ed6677','#4478ab'};
legNames = {'Left Hind','Right Hind','Left Middle','Right Middle','Left Front','Right Front'};
chosenTripod = [1,4,5];
% chosenTripod = [2,3,6];
handPlot1 = gobjects(6,1);
handPlot2 = gobjects(1,2);

figure('Renderer','painters')
tl1 = tiledlayout(3,3,'TileSpacing','compact','Padding','compact');
tl1.TileIndexing = 'columnmajor';
lineW = 1;

for l=chosenTripod
    for r=1:3
        nexttile
        if chosenTripod(1) == 1
            patch('XData',[0.2 0.2 0.8 0.8],'YData',[-5 6 6 -5],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
        else
            patch('XData',[-.3 -.3 .3 .3],'YData',[-5 6 6 -5],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
            patch('XData',[.5 .5 1.1 1.1],'YData',[-5 6 6 -5],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
        end
        hold on
        if r == 1
            yyaxis left
            if l <= chosenTripod(2)
                plot(timeVecNorm,dataNoStiff{1}.Tactuator{l}(:,3),'Color',colors{5},'LineWidth',lineW)
            else
                plot(timeVecNorm,dataNoStiff{1}.Tactuator{l}(:,4),'Color',colors{5},'LineWidth',lineW,'LineStyle','-','Marker','none');
                plot(timeVecNorm,dataNoStiff{1}.Tactuator{l}(:,1),'Color',colors{2},'LineWidth',lineW,'LineStyle','-','Marker','none');
                plot(timeVecNorm,dataNoStiff{1}.Tactuator{l}(:,2),'Color',colors{3},'LineWidth',lineW,'LineStyle','-','Marker','none');
            end
            ylabel('Robot Torque (Nm)')
            yyaxis right
            handPlot1(5) = plot(timeVecNorm,dataNoStiff{2}.Tactuator{l}(:,5),'Color',colors{5},'LineStyle','--','LineWidth',lineW);
            handPlot1(2) = plot(timeVecNorm,dataNoStiff{2}.Tactuator{l}(:,2),'Color',colors{2},'LineStyle','--','LineWidth',lineW);
            handPlot1(3) = plot(timeVecNorm,dataNoStiff{2}.Tactuator{l}(:,3),'Color',colors{3},'LineStyle','--','LineWidth',lineW);
            % plot(timeVecNorm,data{2}.Tactuator{chosenTripod(1)}(:,3)+data{2}.Tactuator{chosenTripod(1)}(:,2)+data{2}.Tactuator{chosenTripod(1)}(:,5),'Color',colors{3},'LineStyle','--','LineWidth',lineW)
            ylabel('Fly Torque (uNmm)')
            yyaxis left
            if l == chosenTripod(1)
                subtitle('Left Hind')
                ylabel({'Pro/Sup';'Robot Torque (Nm)'})
                if contains(terrainShape,'Flat')
                    % yMax(r,l) = 4.4;
                    % yMin(r,l) = -3.4;
                    ylim([-.5 .2])
                    yyaxis right
                    ylim([-.5 .2])
                    % ylim([yMin(r,l) yMax(r,l)])
                    % yticks(ceil(yMin(r,l)):1:floor(yMax(r,l)));
                    % yyaxis right
                    % ylim([yMin(r,l) yMax(r,l)])
                    % yticks(ceil(yMin(r,l)):1:floor(yMax(r,l)));
                    % ylim([-4 4.6])
                    % yyaxis right
                    % ylim([-4 4.6])
                else
                    ylim([-0.6 0.2])
                    yyaxis right
                    ylim([-0.6 0.2])
                    % ylim([-4.6 4.6])
                    % yyaxis right
                    % ylim([-4.6 4.6])
                    % ylim([-5 6])
                    % yyaxis right
                    % ylim([-5 6])
                end

            elseif l == chosenTripod(2)
                subtitle('Right Middle')
                title('No Parallel Stiffness')
                if contains(terrainShape,'Flat')
                    ylim([-0.4 .4])
                    yyaxis right
                    ylim([-0.4 .4])
                    % ylim([-1 1.6])
                    % yticks(-1:0.4:1.6)
                    % yyaxis right
                    % ylim([-1 1.6])
                    % yticks(-1:0.4:1.6)
                    % ylim([-4 4.6])
                    % yyaxis right
                    % ylim([-4 4.6])
                else
                    ylim([-.3 .4])
                    yyaxis right
                    ylim([-.3 .4])
                    % ylim([-1.5 2.2])
                    % yyaxis right
                    % ylim([-1.5 2.2])
                    % ylim([-5 6])
                    % yyaxis right
                    % ylim([-5 6])
                end
            else
                subtitle('Left Front')
                if contains(terrainShape,'Flat')
                    ylim([-.2 1.4])
                    yticks([0, 0.4, 0.8, 1.2])
                    yyaxis right
                    yticks([0, 0.4, 0.8, 1.2])
                    ylim([-.2 1.4])
                    % ylim([-4 1.4])
                    % yyaxis right
                    % ylim([-4 1.4])
                    % ylim([-4 4.6])
                    % yyaxis right
                    % ylim([-4 4.6])
                else
                    ylim([-.2 1.5])
                    yyaxis right
                    ylim([-.2 1.5])
                    % ylim([-5 2])
                    % yyaxis right
                    % ylim([-5 2])
                    % ylim([-5 6])
                    % yyaxis right
                    % ylim([-5 6])
                end
            end

        elseif r == 2
            if l <= chosenTripod(2)
                yyaxis left
                plot(timeVecNorm,dataNoStiff{1}.Tactuator{l}(:,2),'Color',colors{4},'LineWidth',lineW)
            else
                yyaxis left
                plot(timeVecNorm,dataNoStiff{1}.Tactuator{l}(:,3),'Color',colors{4},'LineWidth',lineW);
            end
            yyaxis right
            handPlot1(1) = plot(timeVecNorm,dataNoStiff{2}.Tactuator{l}(:,1),'Color',colors{1},'LineStyle','--','LineWidth',lineW);
            handPlot1(4) = plot(timeVecNorm,dataNoStiff{2}.Tactuator{l}(:,4),'Color',colors{4},'LineStyle','--','LineWidth',lineW);

            if l == chosenTripod(1)
                yyaxis left
                ylabel({'Lev/Dep';'Robot Torque (Nm)'})
                yyaxis right
                ylabel('Fly Torque (uNmm)')
                yyaxis left
                if contains(terrainShape,'Flat')
                    ylim([-1.6 .4])
                    yyaxis right
                    ylim([-1.6 .4])
                    % ylim([-1.6 4.4])
                    % yyaxis right
                    % ylim([-1.6 4.4])
                    % ylim([-4 4.6])
                    % yyaxis right
                    % ylim([-4 4.6])
                else
                    ylim([-1.7 .4])
                    yyaxis right
                    ylim([-1.7 .4])
                    % ylim([-1.8 4.2])
                    % yyaxis right
                    % ylim([-1.8 4.2])
                    % ylim([-5 6])
                    % yyaxis right
                    % ylim([-5 6])
                end
            elseif l == chosenTripod(2)
                yyaxis left
                ylabel('Robot Torque (Nm)')
                yyaxis right
                ylabel('Fly Torque (uNmm)')
                yyaxis left
                if contains(terrainShape,'Flat')
                    ylim([-1.5 .5])
                    yyaxis right
                    ylim([-1.5 .5])
                    % ylim([-2.8 3.4])
                    % yyaxis right
                    % ylim([-2.8 3.4])
                    % ylim([-4 4.6])
                    % yyaxis right
                    % ylim([-4 4.6])
                else
                    ylim([-2 .3])
                    yyaxis right
                    ylim([-2 .3])
                    % ylim([-3.5 3.5])
                    % yyaxis right
                    % ylim([-3.5 3.5])
                    % ylim([-5 6])
                    % yyaxis right
                    % ylim([-5 6])
                end
            else
                yyaxis left
                ylabel('Robot Torque (Nm)')
                yyaxis right
                ylabel('Fly Torque (uNmm)')
                yyaxis left
                if contains(terrainShape,'Flat')
                    ylim([-2 .3])
                    yyaxis right
                    ylim([-2 0.3])
                    % ylim([-2 3.6])
                    % yyaxis right
                    % ylim([-2 3.6])
                    % ylim([-4 4.6])
                    % yyaxis right
                    % ylim([-4 4.6])
                else
                    ylim([-2.1 .3])
                    yyaxis right
                    ylim([-2.1 .3])
                    % ylim([-2.2 6])
                    % yyaxis right
                    % ylim([-2.2 6])
                    % ylim([-5 6])
                    % yyaxis right
                    % ylim([-5 6])
                end
            end
        else %r == 3
            if l <= chosenTripod(2)
                if l == chosenTripod(1)
                    yyaxis left
                    plot(timeVecNorm,dataNoStiff{1}.Tactuator{l}(:,4),'Color',colors{6},'LineWidth',lineW);
                    yyaxis right
                    plot(timeVecNorm,dataNoStiff{2}.Tactuator{l}(:,6),'Color',colors{6},'LineStyle','--','LineWidth',lineW);
                else
                    yyaxis left
                    plot(timeVecNorm,dataNoStiff{1}.Tactuator{l}(:,4),'Color',colors{6},'LineWidth',lineW)
                    yyaxis right
                    plot(timeVecNorm,dataNoStiff{2}.Tactuator{l}(:,6),'Color',colors{6},'LineStyle','--','LineWidth',lineW)
                end
            else
                yyaxis left
                plot(timeVecNorm,dataNoStiff{1}.Tactuator{l}(:,5),'Color',colors{6},'LineWidth',lineW);
                yyaxis right
                handPlot1(6) = plot(timeVecNorm,dataNoStiff{2}.Tactuator{l}(:,6),'Color',colors{6},'LineStyle','--','LineWidth',lineW);
            end
            if l == chosenTripod(1)
                yyaxis left
                ylabel({'Ext/Flx';'Robot Torque (Nm)'})
                yyaxis right
                ylabel('Fly Torque (uNmm)')
                yyaxis left
                if contains(terrainShape,'Flat')
                    ylim([-.1 2.5])
                    yyaxis right
                    ylim([-.1 2.5])
                    % ylim([-1 4])
                    % yyaxis right
                    % ylim([-1 4])
                    % ylim([-4 4.6])
                    % yyaxis right
                    % ylim([-4 4.6])
                else
                    ylim([-.1 2.5])
                    yyaxis right
                    ylim([-.1 2.5])
                    % ylim([-1.4 4.2])
                    % yyaxis right
                    % ylim([-1.4 4.2])
                    % ylim([-5 6])
                    % yyaxis right
                    % ylim([-5 6])
                end
            elseif l == chosenTripod(2)
                ylabel('Robot Torque (Nm)')
                yyaxis right
                ylabel('Fly Torque (uNmm)')
                yyaxis left
                if contains(terrainShape,'Flat')
                    ylim([0 1.5])
                    yyaxis right
                    ylim([0 1.5])
                    % ylim([-.2 2.4])
                    % yticks(0:0.4:2.4)
                    % yyaxis right
                    % yticks(0:0.4:2.4)
                    % ylim([-.2 2.4])
                    % ylim([-4 4.6])
                    % yyaxis right
                    % ylim([-4 4.6])
                else
                    ylim([-.1 1.6])
                    yyaxis right
                    ylim([-.1 1.6])
                    % ylim([-.8 2.4])
                    % yyaxis right
                    % ylim([-.8 2.4])
                    % ylim([-5 6])
                    % yyaxis right
                    % ylim([-5 6])
                end
            else
                yyaxis left
                ylabel('Robot Torque (Nm)')
                yyaxis right
                ylabel('Fly Torques (uNmm)')
                yyaxis left
                if contains(terrainShape,'Flat')
                    ylim([-.1 2.6])
                    yyaxis right
                    ylim([-.1 2.6])
                    % ylim([-.1 4.6])
                    % yyaxis right
                    % ylim([-.1 4.6])
                    % ylim([-4 4.6])
                    % yyaxis right
                    % ylim([-4 4.6])
                else
                    % ylim([-0.2 5.2])
                    % yyaxis right
                    % ylim([-0.2 5.2])
                    ylim([-.2 2])
                    yyaxis right
                    ylim([-.2 2.2])
                    % ylim([-5 6])
                    % yyaxis right
                    % ylim([-5 6])
                end
            end
        end

        xlim([0 1])
        xlabel('Step (%)')
        grid on
    end
end

figure('Renderer','painters')
tl2 = tiledlayout(3,3,'TileSpacing','compact','Padding','compact');
tl2.TileIndexing = 'columnmajor';

for l=chosenTripod
    for r=1:3
        nexttile
        if chosenTripod(1) == 1
            patch('XData',[0.2 0.2 0.8 0.8],'YData',[-5 6 6 -5],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
        else
            patch('XData',[-.3 -.3 .3 .3],'YData',[-5 6 6 -5],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
            patch('XData',[.5 .5 1.1 1.1],'YData',[-5 6 6 -5],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
        end
        hold on
        if r == 1
            yyaxis left
            if l <= chosenTripod(2)
                plot(timeVecNorm,dataStiff{1}.Tactuator{l}(:,3),'Color',colors{5},'LineWidth',lineW)
            else
                plot(timeVecNorm,dataStiff{1}.Tactuator{l}(:,4),'Color',colors{5},'LineWidth',lineW,"LineStyle","-","Marker",'none');
                plot(timeVecNorm,dataStiff{1}.Tactuator{l}(:,1),'Color',colors{2},'LineWidth',lineW,"LineStyle","-","Marker",'none');
                plot(timeVecNorm,dataStiff{1}.Tactuator{l}(:,2),'Color',colors{3},'LineWidth',lineW,"LineStyle","-","Marker",'none');
            end
            yyaxis right
            plot(timeVecNorm,dataStiff{2}.Tactuator{l}(:,5),'Color',colors{5},'LineStyle','--','LineWidth',lineW,"Marker",'none')
            plot(timeVecNorm,dataStiff{2}.Tactuator{l}(:,2),'Color',colors{2},'LineStyle','--','LineWidth',lineW,"Marker",'none')
            plot(timeVecNorm,dataStiff{2}.Tactuator{l}(:,3),'Color',colors{3},'LineStyle','--','LineWidth',lineW,"Marker",'none')
            % plot(timeVecNorm,dataStiff{2}.Tactuator{l}(:,3)+dataStiff{2}.Tactuator{l}(:,5),'Color','k','LineStyle','--','LineWidth',lineW)
            yyaxis left
            ylabel('Robot Torque (Nm)')
            yyaxis right
            ylabel('Fly Torque (uNmm)')
            yyaxis left
            if l == chosenTripod(1)
                subtitle('Left Hind')
                if contains(terrainShape,'Flat')
                    ylim([-0.5 1])
                    yyaxis right
                    ylim([-40 80])
                    yticks([-40 0 40 80])
                else
                    ylim([-1 1.5])
                    yyaxis right
                    ylim([-60 90])
                    yticks([-60 -30 0 30 60 90])
                end
            elseif l == chosenTripod(2)
                subtitle('Right Middle')
                title('Parallel Stiffness Added')
                if contains(terrainShape,'Flat')
                    yyaxis left
                    ylim([-0.8 0.8])
                    yyaxis right
                    ylim([-20 20])
                else
                    ylim([-1 1])
                    yyaxis right
                    ylim([-30 30])
                    yticks([-30 -15 0 15 30])
                    % ylim([-5 6])
                    % yyaxis right
                    % ylim([-5 6])
                end
            else
                subtitle('Left Front')
                if contains(terrainShape,'Flat')
                    ylim([-1.5 0.5])
                    yyaxis right
                    ylim([-60 20])
                    % ylim([-4 4.6])
                    % yyaxis right
                    % ylim([-4 4.6])
                else
                    ylim([-1.5 1])
                    yyaxis right
                    ylim([-75 50])
                    yticks([-75 -50 -25 0 25 50])
                    % ylim([-5 6])
                    % yyaxis right
                    % ylim([-5 6])
                end
            end

        elseif r == 2
            yyaxis left
            if l <= chosenTripod(2)
                plot(timeVecNorm,dataStiff{1}.Tactuator{l}(:,2),'Color',colors{4},'LineWidth',lineW)
                yyaxis right
                plot(timeVecNorm,dataStiff{2}.Tactuator{l}(:,1),'Color',colors{1},'LineStyle','--','LineWidth',lineW)
            else
                plot(timeVecNorm,dataStiff{1}.Tactuator{l}(:,3),'Color',colors{4},'LineWidth',lineW);
                yyaxis right
                plot(timeVecNorm,dataStiff{2}.Tactuator{l}(:,1),'Color',colors{1},'LineStyle','--','LineWidth',lineW);
            end
            plot(timeVecNorm,dataStiff{2}.Tactuator{l}(:,4),'Color',colors{4},'LineStyle','--','LineWidth',lineW)
            % plot(timeVecNorm,dataStiff{2}.Tactuator{l}(:,4)+dataStiff{2}.Tactuator{l}(:,1),'LineStyle','--','Color','k','LineWidth',lineW)
            yyaxis left
            ylabel('Robot Torque (Nm)')
            yyaxis right
            ylabel('Fly Torque (uNmm)')
            yyaxis left
            if l == chosenTripod(1)
                if contains(terrainShape,'Flat')
                    ylim([-0.5 2])
                    yyaxis right
                    ylim([-15 60])
                    yticks([-15 0 15 30 45 60])
                    % ylim([-4 4.6])
                    % yyaxis right
                    % ylim([-4 4.6])
                else
                    ylim([-0.5 3])
                    yyaxis right
                    ylim([-10 60])
                    % ylim([-5 6])
                    % yyaxis right
                    % ylim([-5 6])
                end
            elseif l == chosenTripod(2)
                if contains(terrainShape,'Flat')
                    ylim([-1 2])
                    yyaxis right
                    ylim([-20 40])
                    % ylim([-4 4.6])
                    % yyaxis right
                    % ylim([-4 4.6])
                else
                    ylim([-1.5 2])
                    yticks([-1 0 1 2])
                    yyaxis right
                    ylim([-37.5 50])
                    yticks([-25 0 25 50])
                    % ylim([-5 6])
                    % yyaxis right
                    % ylim([-5 6])
                end
            else
                if contains(terrainShape,'Flat')
                    ylim([-2 2])
                    yyaxis right
                    ylim([-40 40])
                    % ylim([-4 4.6])
                    % yyaxis right
                    % ylim([-4 4.6])
                else
                    ylim([-2.5 2])
                    yyaxis right
                    ylim([-100 80])
                    yticks([-80 -40 0 40 80])
                end
            end
        else %r == 3
            if l <= chosenTripod(2)
                if l == chosenTripod(1)
                    yyaxis left
                    plot(timeVecNorm,dataStiff{1}.Tactuator{l}(:,4),'Color',colors{6},'LineWidth',lineW);
                    yyaxis right
                    plot(timeVecNorm,dataStiff{2}.Tactuator{l}(:,6),'Color',colors{6},'LineStyle','--','LineWidth',lineW);
                else
                    yyaxis left
                    plot(timeVecNorm,dataStiff{1}.Tactuator{l}(:,4),'Color',colors{6},'LineWidth',lineW)
                    yyaxis right
                    plot(timeVecNorm,dataStiff{2}.Tactuator{l}(:,6),'Color',colors{6},'LineStyle','--','LineWidth',lineW)
                end

            else
                yyaxis left
                handPlot2(1) = plot(timeVecNorm,dataStiff{1}.Tactuator{l}(:,5),'Color',colors{6},'LineWidth',lineW);
                yyaxis right
                handPlot2(2) = plot(timeVecNorm,dataStiff{2}.Tactuator{l}(:,6),'Color',colors{6},'LineStyle','--','LineWidth',lineW);
            end
            ylabel('Fly Torque (uNmm)')
            yyaxis left
            ylabel('Robot Torque (Nm)')
            if l == chosenTripod(1)
                if contains(terrainShape,'Flat')
                    ylim([-0.5 1.5])
                    yyaxis right
                    ylim([-20 60])
                    % ylim([-4 4.6])
                    % yyaxis right
                    % ylim([-4 4.6])
                else
                    ylim([-1 1.5])
                    yyaxis right
                    ylim([-40 60])
                    % ylim([-5 6])
                    % yyaxis right
                    % ylim([-5 6])
                end
            elseif l == chosenTripod(2)
                if contains(terrainShape,'Flat')
                    ylim([-.2 0.8])
                    yyaxis right
                    ylim([-10 40])
                    % ylim([-4 4.6])
                    % yyaxis right
                    % ylim([-4 4.6])
                else
                    ylim([-.5 1])
                    yyaxis right
                    ylim([-20 40])
                    % ylim([-5 6])
                    % yyaxis right
                    % ylim([-5 6])
                end
            else
                if contains(terrainShape,'Flat')
                    ylim([0 2])
                    yyaxis right
                    ylim([0 60])
                    % ylim([-4 4.6])
                    % yyaxis right
                    % ylim([-4 4.6])
                else
                    ylim([-.25 1.5])
                    yyaxis right
                    ylim([-15 90])
                    yticks([0 30 60 90])
                end
            end
        end
        xlim([0 1])
        xlabel( 'Step (%)')
        grid on
 
    end
end

lgd1 = legend(handPlot1(:,1),'ThC2','ThC1','ThC3','CTr','TrF','FTi','Location','southoutside','Orientation','horizontal');
title(lgd1,'Degrees of Freedom')
lgd2 = legend(handPlot2(1,:),'Drosophibot II','Scale Drosophila','Location','southoutside','Orientation','horizontal');
title(lgd2,'Organism');
title(tl1,{'DYNAMIC COMPARISON: DROSOPHIBOT II VS. DROSOPHILA'; terrainShape})

