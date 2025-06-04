%Plot the torques and angles for each leg during a simulated trial
clear all
baseFolderLoc = 'C:\Users\Clarissa G\Documents\MATLAB\Design Drosophibot\';
organism = 'Drosophibot 2';
k_spring = 0;
T_swing = 1;
load([baseFolderLoc organism '\k_spring = ' num2str(k_spring) '\T_swing = ' num2str(T_swing) '\allVars.mat'],'timeVecPlot','thetaPlot','Tactuator');

colors = {'#77AC30','#7E2F8E','#EDB120','#D95319','#0072BD'};
legNames = {'Left Hind','Right Hind','Left Middle','Right Middle','Left Front','Right Front'};

figure
tl = tiledlayout(2,6,'TileSpacing','compact','Padding','compact');
for l = 1:6
    nexttile(l)
    hold on
    [~,c] = size(Tactuator{l});
    for j=1:c-1
        if l <= 4
            if j > 1
                plot(timeVecPlot,Tactuator{l}(:,j),'Color',colors{j+1})
            end
        else
            plot(timeVecPlot,Tactuator{l}(:,j),'Color',colors{j})
        end
    end
    title(legNames{l})
    grid on
    ylabel('Actuator Torque (Nm)')
    xlabel('Time (s)')
    xlim([0 timeVecPlot(end)])
    ylim([-2 1.5])
    nexttile(l+6)
    hold on
    for j=1:c-1
        if l <= 4
            if j > 1
                plot(timeVecPlot,thetaPlot{l}(:,j),'Color',colors{j+1})
            end
        else
            plot(timeVecPlot,thetaPlot{l}(:,j),'Color',colors{j})
        end
    end
    grid on
    ylabel('Joint Angle (rad)')
    xlabel('Time (s)')
    xlim([0 timeVecPlot(end)])
    ylim([-1 1])
end
title(tl,'Drosophibot II Kinematics and Dynamics')
stepT = T_swing/0.4;
subtitle(tl,['Stepping Period: ' num2str(stepT) ' s'])
lgd1 = legend('ThC1','ThC3','CTr','TrF','FTi','Location','southeastoutside');