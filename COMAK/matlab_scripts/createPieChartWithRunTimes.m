function createPieChartWithRunTimes(total_run_time, time_ik, time_comak, time_mech, time_visualization, project_id, numeric_id)
    % Display total run times
    fprintf('Total run time: %.2f seconds\n', total_run_time);
    fprintf('Total run time for IK: %.2f seconds\n', time_ik);
    fprintf('Total run time for COMAK: %.2f seconds\n', time_comak);
    fprintf('Total run time for Joint Mechanics: %.2f seconds\n', time_mech);
    fprintf('Total run time for Visualization: %.2f seconds\n', time_visualization);

    % Create a pie chart
    figure('Visible', 'off');
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);
    save_path = ['../results/' project_id '_' numeric_id '/graphics'];
    labels = {'IK', 'COMAK', 'Joint Mechanics', 'Visualization'};
    times = [time_ik, time_comak, time_mech, time_visualization];
    
    % Convert times to integers for labeling
    times_int = round(times);
    
    % Create the pie chart and get handles to text and patch objects
    h = pie(times);
    % Set the pie chart colors for better visuals (optional)
    colors = [0.8 0.4 0.4; 0.4 0.8 0.4; 0.4 0.4 0.8; 0.8 0.8 0.4];
    for i = 1:length(times)
        h(i*2-1).FaceColor = colors(i,:);
    end
    
    % Extract the text objects from the handles
    textObjs = findobj(h, 'Type', 'text');
    
    % Calculate percentages
    percentages = 100 * times / sum(times);
    
    % Set the text labels with run times and percentages
    for i = 1:length(textObjs)
        textObjs(i).String = sprintf('%s: %ds (%.1f%%)', labels{i}, times_int(i), percentages(i));
        textObjs(i).FontSize = 12; % Make the text bigger
        textObjs(i).FontWeight = 'bold'; % Make the text bold
    end
    
    % Enhance title and aesthetics
    title(sprintf('Run Time Distribution\nTotal run time: %.2f seconds', total_run_time), 'FontSize', 16, 'FontWeight', 'bold');
    set(gca, 'FontSize', 12, 'FontWeight', 'bold');
    colormap(colors);
    
    % Create the save directory if it doesn't exist
    if ~exist(save_path, 'dir')
        mkdir(save_path);
    end
    
    % Save the figure
    saveas(gcf, fullfile(save_path, 'RunTimeDistribution.png'));
end
