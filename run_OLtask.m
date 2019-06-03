%% Initialization
clear all;

% some initial global setup
RestrictKeysForKbCheck( [] );
% initialize the random number stream
RandStream.setGlobalStream(RandStream('mt19937ar','Seed','shuffle'));
    
% initialize the task strcutures for practice and test
taskStruct = struct();
taskStruct.startTime = GetSecs();
% taskStruct_practice = initTaskStruct_Practice(20);

% subejct ID info
current_dir = pwd;
taskStruct.outputFolder = fullfile(current_dir, 'data');
taskStruct.subID = input('Participant number :\n','s');
% check to see if the output folder exists
if exist(taskStruct.outputFolder, 'dir') == 0
    % folder does not exist - create it
    mkdir( taskStruct.outputFolder );
end
taskStruct.fileName = [taskStruct.subID '_Sub_OLtask_' datestr(now, 'mm-dd-yyyy_HH-MM-SS')];

% load trial data
trListVersion = randi(10);
taskStruct.trListFile = ['trial_list_v' num2str(trListVersion) '.csv'];
tr_list = csvread(fullfile(current_dir, 'trial_lists', taskStruct.trListFile),1,0);
taskStruct.allTrials = initTaskStruct_Task(tr_list);

% initialize the IO for the task
ioStruct = initIOStruct();

% wait for experimentor input to prompt wait for scanner pulse
Screen(ioStruct.wPtr, 'Flip');
% show inter-block information
Screen('TextSize', ioStruct.wPtr, 30); 
Screen('TextColor', ioStruct.wPtr, [255 255 255]); 
Screen('TextFont', ioStruct.wPtr, 'Helvetica');
DrawFormattedText(ioStruct.wPtr, 'Waiting for experimenter to mark ready status.', 'center', 'center');
% show prompt
RestrictKeysForKbCheck( [ioStruct.respKey_Quit, ioStruct.respKey_Proceed] );
Screen(ioStruct.wPtr, 'Flip');
[~, keyCode] = KbWait(-3,2);
% check to see if we proceed or quit
if find(keyCode) == ioStruct.respKey_Quit
    % end the task and clean up
    sca; ShowCursor(); ListenChar();
    return;
end

%%  run instructions
taskStruct.startInstruction = GetSecs();
taskStruct.InstructionFolder = fullfile(current_dir, 'instructions');
showInstructions(ioStruct, taskStruct.InstructionFolder);
taskStruct.endInstruction = GetSecs();

%% run practice trials
% taskStruct_practice.startTime = GetSecs();
% % run a set of practice trials
% for tI = 1 : size(taskStruct_practice.allTrials,1)
%     taskStruct_practice.allTrials(tI,:) = runTrial(taskStruct_practice, ioStruct, taskStruct_practice.allTrials(tI,:));
%     save(fullfile(taskStruct.outputFolder, taskStruct.fileName), 'taskStruct', 'taskStruct_practice', 'taskStruct_test');
% end
% taskStruct_practice.endTime = GetSecs();
% save(fullfile(taskStruct.outputFolder, taskStruct.fileName), 'taskStruct', 'taskStruct_practice', 'taskStruct_test');

%% run main task

% wait for experimentor input to prompt wait for scanner pulse
Screen(ioStruct.wPtr, 'Flip');
% show inter-block information
Screen('TextSize', ioStruct.wPtr, 30); 
Screen('TextColor', ioStruct.wPtr, [255 255 255]); 
Screen('TextFont', ioStruct.wPtr, 'Helvetica');
DrawFormattedText(ioStruct.wPtr, 'Please ask the experimenter any questions you might have.\n\n Otherwise please let them know that you''re ready to begin.', 'center', 'center');
% show prompt
Screen(ioStruct.wPtr, 'Flip');
RestrictKeysForKbCheck( [ioStruct.respKey_Quit, ioStruct.respKey_Proceed] );
[~, keyCode] = KbWait(-3,2);
% check to see if we proceed or quit
if find(keyCode) == ioStruct.respKey_Quit
    % end the task and clean up
    sca; 
    ShowCursor(); 
    ListenChar(); 
    return;
end

% run test trials
taskStruct.startTime = GetSecs();
breakTic = GetSecs();
for tI = 1 : size(taskStruct.allTrials,1)
    taskStruct.allTrials(tI,:) = runTrial(ioStruct, taskStruct.allTrials(tI,:), taskStruct.startTime);
    save(fullfile(taskStruct.outputFolder, taskStruct.fileName), 'taskStruct'); %taskStruct_practice
    
    % check if we should run the break
    if tI == size(taskStruct.allTrials,1)/2
        % reset the break timer
        breakTic = GetSecs();
        % extract scores
        currentScore = nansum(taskStruct.allTrials.outcome);
        breakText = ['End of block 1/2.\n\n You''ve collected a total of ' num2str(currentScore) ' points so far.\n\n Take a short break and press space when ready to start block #2.'];
        Screen('TextSize', ioStruct.wPtr, 30); 
        Screen('TextColor', ioStruct.wPtr, [255 255 255]); 
        Screen('TextFont', ioStruct.wPtr, 'Helvetica');
        DrawFormattedText(ioStruct.wPtr, breakText, 'center', 'center');
        % show prompt
        RestrictKeysForKbCheck( KbName('space') ); 
        Screen(ioStruct.wPtr, 'Flip');
        KbWait(-3, 2);
    end
end

% mark completion time
taskStruct.endTime = GetSecs();

% save data and clean up
save(fullfile(taskStruct.outputFolder, taskStruct.fileName), 'taskStruct');

% accumulate the total number of points earned
totalPoints = nansum(taskStruct.allTrials.outcome);

% finish game
Screen(ioStruct.wPtr, 'Flip');

% show outcome information
Screen('TextSize', ioStruct.wPtr, 30); 
Screen('TextColor', ioStruct.wPtr, [255 255 255]); 
Screen('TextFont', ioStruct.wPtr, 'Helvetica');
DrawFormattedText(ioStruct.wPtr, ['End of the task.\n\n You earned a total of ' num2str(totalPoints) ' points.\n\n Please let the experimenter know that you''re done.'], 'center', 'center');
% show prompt
Screen(ioStruct.wPtr, 'Flip');

RestrictKeysForKbCheck( ioStruct.respKey_Quit );
[~, keyCode] = KbWait(-3,2);

RestrictKeysForKbCheck( [] );
ListenChar(1); ShowCursor();
sca; 