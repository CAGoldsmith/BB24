%Compare the GRF across the different terrain shapes in Drosophila
%Plot a comparison of the fly walking the ball vs. flat ground
clear all
close all
baseFolderLoc = 'C:\Users\Clarissa G\Documents\MATLAB\Design Drosophibot\';
% baseFolderLoc = 'G:\Other computers\NeuroMINT Lab Computer\MATLAB\Design Drosophibot\';
k_spring = 3e-09;
T_swing = 0.1;
terrainShape = {'Flat', 'Ball'};
for o=1:length(terrainShape)
        data{o} = load([baseFolderLoc  'Scale Drosophila\' terrainShape{o} '\k_spring = ' num2str(k_spring) '\T_swing = ' num2str(T_swing) '\allVars.mat'],'timeVecPlot','thetaPlot','FjointGlobal');
        for l=1:6
            data{o}.FjointGlobal{l}{end} = data{o}.FjointGlobal{l}{end}*1e6;
            for i=1:length(data{1}.FjointGlobal{1}{end})
                GRFMag{o}{l}(i) = norm(data{o}.FjointGlobal{l}{end}(:,i));
            end
        end
end

timeVecNorm = data{1}.timeVecPlot/(T_swing(1)/.4);
colors = {'r','b','g','k'};
legNames = {'Left Hind','Right Hind','Left Middle','Right Middle','Left Front','Right Front'};
dims = {'X Coord','Y Coord', 'Z Coord','Total Magnitude'};
chosenTripod = [1,4,5];

figure
tl1 = tiledlayout(4,3,'TileSpacing','loose','Padding','compact');
tl1.TileIndexing = 'columnmajor';
set(gcf,'Renderer','painters')
lineW = 1;
tileCount = 1;

for l=chosenTripod
    for dim = 1:3
        nexttile(tileCount)
        if chosenTripod(1) == 1
            patch('XData',[0.2 0.2 0.8 0.8],'YData',[-60 80 80 -60],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
        else
            patch('XData',[-.3 -.3 .3 .3],'YData',[-60 80 80 -60],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
            patch('XData',[.5 .5 1.1 1.1],'YData',[-60 80 80 -60],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
        end
        hold on
        plot(timeVecNorm,data{1}.FjointGlobal{l}{end}(dim,:),'Color',colors{dim},'LineWidth',lineW)
        plot(timeVecNorm,data{2}.FjointGlobal{l}{end}(dim,:),'Color',colors{dim},'LineWidth',lineW,'LineStyle','--')
        if dim == 1
           title({legNames{l};dims{dim}}) 
        else
            title(dims{dim})
        end
        grid on
        ylim([-60 70])
        xlabel('Step (%)')
        ylabel('Force (uN)')
        tileCount = tileCount + 1;
    end
    nexttile(tileCount)
    if chosenTripod(1) == 1
        patch('XData',[0.2 0.2 0.8 0.8],'YData',[-10 80 80 -10],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
    else
        patch('XData',[-.3 -.3 .3 .3],'YData',[-10 80 80 -10],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
        patch('XData',[.5 .5 1.1 1.1],'YData',[-10 80 80 -10],'FaceColor','black','FaceAlpha',0.05,'EdgeColor','none')
    end
    hold on
    plot(timeVecNorm,GRFMag{1}{l},'Color',colors{4},'LineWidth',lineW)
    plot(timeVecNorm,GRFMag{2}{l},'Color',colors{4},'LineWidth',lineW,'LineStyle','--')
    ylim([-10 80])
    title(dims{4})
    grid on
    xlabel('Step (%)')
    ylabel('Force (uN)')
    tileCount = tileCount + 1;
end
legend('','Flat Plane','Ball','Location','southoutside','Orientation','horizontal');
title(tl1, {'DROSOPHILA TERRAIN SHAPE COMPARISON'})
subtitle(tl1, 'Ground Reaction Forces')
