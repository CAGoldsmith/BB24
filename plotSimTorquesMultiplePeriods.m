%Plot the difference between the torques in a three legs across three
%different stepping periods in simulation
%Plot the torques and angles for each leg during a simulated trial
clear all
baseFolderLoc = 'C:\Users\Clarissa G\Documents\MATLAB\Design Drosophibot\';
organism = 'Drosophibot 2';
k_spring = 0;
T_swing = [0.4,0.8, 1.6];
T_step = T_swing/0.4;
for tr=1:length(T_swing)
    data{tr} = load([baseFolderLoc organism '\k_spring = ' num2str(k_spring) '\T_swing = ' num2str(T_swing(tr)) '\allVars.mat'],'timeVecPlot','thetaPlot','Tactuator');
end
figure
tl = tiledlayout(1,3,'TileSpacing','compact','Padding','compact');
colors = {'#77AC30','#7E2F8E','#EDB120','#D95319','#0072BD'};
legNames = {'Left Hind', 'Right Hind', 'Left Middle', 'Right Middle', 'Left Front', 'Right Front'};
chosenTripod = [1,4,5];
lineStyles = {'-','--',':'};
handPlot1 = gobjects(5,3);
handPlot2 = gobjects(5,3);
for l=1:3
    nexttile(l)
    hold on
    for tr=1:length(T_swing)
        [r,c] = size(data{tr}.Tactuator{chosenTripod(l)});
        if chosenTripod(l) <= 4
            for j=2:c-1
                if l == 1
                    handPlot1(j,tr) = plot(data{tr}.Tactuator{chosenTripod(l)}(:,j),'Color',colors{j+1},'LineStyle',lineStyles{tr});
                else
                    plot(data{tr}.Tactuator{chosenTripod(l)}(:,j),'Color',colors{j+1},'LineStyle',lineStyles{tr})
                end
            end
        else
            for j=1:c-1
                handPlot2(j,tr) = plot(data{tr}.Tactuator{chosenTripod(l)}(:,j),'Color',colors{j},'LineStyle',lineStyles{tr});
            end
        end
    end
    axis([0 r -2 2.5])
    grid on
    ylabel('Actuator Torque (Nm)')
    xlabel('Timestep')
    rectangle('Position',[r*.2 2 r*.6 .125],'FaceColor','k')
    if l == 1
        lgd1 = legend(handPlot1(end-1,:),[num2str(T_step(1)) ' s'],[num2str(T_step(2)) ' s'],[num2str(T_step(3)) ' s'],'Location','southeastoutside');
        title(lgd1,'Stepping Periods')
    elseif l == 3
        lgd1 = legend(handPlot2(:,1),'ThC1','ThC3','CTr','TrF','FTi','Location','northeastoutside');
        title(lgd1,'Joints')
    end
end

title(tl,'Simulated Torques for Multiple Stepping Periods');
subtitle(tl,['Forward Walking, Stiffness: ' num2str(k_spring) ' Nm/rad']);
