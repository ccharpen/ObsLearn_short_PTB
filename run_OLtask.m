%% Initialization
clear all;

% some initial global setup
RestrictKeysForKbCheck( [] );
% initialize the random number stream
RandStream.setGlobalStream(RandStream('mt19937ar','Seed','shuffle'));
    
% initialize the task strcutures for practice and test
taskStruct = struct();
taskStruct.startTime = GetSecs();

% subejct ID info
current_dir = pwd;
taskStruct.outputFolder = fullfile(current_dir, 'data');
taskStruct.subID = input('Participant number:\n','s');
taskStruct.session = input('Pre-scan (1), MRI (2), Behavior (3):\n');
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
ioStruct = initIOStruct(taskStruct);

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

if taskStruct.session == 1
    %%  run instructions
    taskStruct.startInstruction = GetSecs();
    taskStruct.InstructionFolder = fullfile(current_dir, 'instructions');
    showInstructions(ioStruct, taskStruct.InstructionFolder);
    taskStruct.endInstruction = GetSecs();

    %% run practice trials
    taskStruct_practice = initTaskStruct_Practice();
    practice_startTime = GetSecs();
    % run a set of practice trials
    for tI = 1 : size(taskStruct_practice,1)
        taskStruct_practice(tI,:) = runTrial(ioStruct, taskStruct_practice(tI,:), practice_startTime, 0, 0);
        save(fullfile(taskStruct.outputFolder, taskStruct.fileName), 'taskStruct', 'taskStruct_practice');
    end
    save(fullfile(taskStruct.outputFolder, taskStruct.fileName), 'taskStruct', 'taskStruct_practice');
end
%% run main task

% wait for experimentor input to prompt wait for scanner pulse
Screen(ioStruct.wPtr, 'Flip');
% show inter-block information
Screen('TextSize', ioStruct.wPtr, 30); 
Screen('TextColor', ioStruct.wPtr, [255 255 255]); 
Screen('TextFont', ioStruct.wPtr, 'Helvetica');
if taskStruct.session == 1 %pre-scan
    DrawFormattedText(ioStruct.wPtr, 'End of practice rounds.', 'center', ioStruct.centerY-260);
    DrawFormattedText(ioStruct.wPtr, 'The task is now about to start.', 'center', ioStruct.centerY-200);
    DrawFormattedText(ioStruct.wPtr, 'It will last about 15 minutes, split into 8 short blocks.', 'center', ioStruct.centerY-140);
    DrawFormattedText(ioStruct.wPtr, 'Remember that when it''s your turn to play, you only have', 'center', ioStruct.centerY-40);
    DrawFormattedText(ioStruct.wPtr, '4s to choose, so try not to miss!', 'center', ioStruct.centerY+10);
    DrawFormattedText(ioStruct.wPtr, 'If anything is unclear, please ask the experimenter.', 'center', ioStruct.centerY+110);
    DrawFormattedText(ioStruct.wPtr, 'Otherwise, press ''p'' to begin.', 'center', ioStruct.centerY+160);
    % show prompt and wait for p (proceed) or q (quit)
    Screen(ioStruct.wPtr, 'Flip');
    RestrictKeysForKbCheck( [ioStruct.respKey_Quit, ioStruct.respKey_Proceed] );
    [~, keyCode] = KbWait(-3,2);
elseif taskStruct.session == 2 %MRI
    DrawFormattedText(ioStruct.wPtr, 'Welcome to the observational learning game!', 'center', ioStruct.centerY-320);
    DrawFormattedText(ioStruct.wPtr, 'In this game, you learn which token (green, red, or blue) is', 'center', ioStruct.centerY-260);
    DrawFormattedText(ioStruct.wPtr, 'valuable and which slot machine is best to choose by observing', 'center', ioStruct.centerY-200);
    DrawFormattedText(ioStruct.wPtr, 'another person make choices.', 'center', ioStruct.centerY-140);
    DrawFormattedText(ioStruct.wPtr, 'When it''s your turn to play, use the 3 left-most buttons of the', 'center', ioStruct.centerY-80);
    DrawFormattedText(ioStruct.wPtr, 'response box, with the index, middle and ring fingers,', 'center', ioStruct.centerY-20);
    DrawFormattedText(ioStruct.wPtr, 'to choose the left, middle, and right slot machine, respectively.', 'center', ioStruct.centerY+40);
    DrawFormattedText(ioStruct.wPtr, 'Remember that you only have 4s to choose!', 'center', ioStruct.centerY+120);
    DrawFormattedText(ioStruct.wPtr, 'Now, please wait for the scanner to start.', 'center', ioStruct.centerY+200);
    % show prompt and wait for 5 (trigger)
    Screen(ioStruct.wPtr, 'Flip');
    RestrictKeysForKbCheck( [KbName('5'), KbName('5%')] );
    [~, keyCode] = KbWait(-3,2);
elseif taskStruct.session == 3 %behavior
    DrawFormattedText(ioStruct.wPtr, 'Welcome to the observational learning game!', 'center', ioStruct.centerY-320);
    DrawFormattedText(ioStruct.wPtr, 'In this game, you learn which token (green, red, or blue)', 'center', ioStruct.centerY-260);
    DrawFormattedText(ioStruct.wPtr, 'is valuable and which slot machine is best to choose by observing', 'center', ioStruct.centerY-200);
    DrawFormattedText(ioStruct.wPtr, 'another person make choices.', 'center', ioStruct.centerY-140);
    DrawFormattedText(ioStruct.wPtr, 'When it''s your turn to play, use the left, middle and right arrow keys,', 'center', ioStruct.centerY-40);
    DrawFormattedText(ioStruct.wPtr, 'to choose the left, middle, and right slot machine, respectively.', 'center', ioStruct.centerY+20);
    DrawFormattedText(ioStruct.wPtr, 'Remember that you only have 4s to choose!', 'center', ioStruct.centerY+120);
    DrawFormattedText(ioStruct.wPtr, 'If anything is unclear, please ask the experimenter.', 'center', ioStruct.centerY+180);
    DrawFormattedText(ioStruct.wPtr, 'Otherwise, press ''p'' to begin.', 'center', ioStruct.centerY+240);
    % show prompt and wait for p (proceed) or q (quit)
    Screen(ioStruct.wPtr, 'Flip');
    RestrictKeysForKbCheck( [ioStruct.respKey_Quit, ioStruct.respKey_Proceed] );
    [~, keyCode] = KbWait(-3,2);
end

% check to see if quit
if find(keyCode) == ioStruct.respKey_Quit
    % end the task and clean up
    sca; 
    ShowCursor(); 
    ListenChar(); 
    return;
end

% run main trial loop
taskStruct.startTime = GetSecs();
breakTic = GetSecs();
block = 1;
tO = 1; %counter of observe trials for jitter
tnf = 1; %counter of all trials except first of each block
for tI = 1 : size(taskStruct.allTrials,1)
    
    taskStruct.allTrials(tI,:) = runTrial(ioStruct, taskStruct.allTrials(tI,:), taskStruct.startTime, tnf, tO);
    if taskStruct.session == 1
        save(fullfile(taskStruct.outputFolder, taskStruct.fileName), 'taskStruct', 'taskStruct_practice');
    else
        save(fullfile(taskStruct.outputFolder, taskStruct.fileName), 'taskStruct');
    end
    
    % check if we should run the break
    if taskStruct.allTrials.isBreak(tI)==1
        % reset the break timer
        breakTic = GetSecs();
        % extract scores
        for w=1:5
            breakText = ['End of block ' num2str(block) '/8.\n\n Block ' num2str(block+1) ' will start in ' num2str(6-w) 's.'];
            Screen('TextSize', ioStruct.wPtr, 30); 
            Screen('TextColor', ioStruct.wPtr, [255 255 255]); 
            Screen('TextFont', ioStruct.wPtr, 'Helvetica');
            DrawFormattedText(ioStruct.wPtr, breakText, 'center', 'center');
            % show prompt
            Screen(ioStruct.wPtr, 'Flip');
            WaitSecs(1);
        end
        block = block + 1;
    end
    
    if taskStruct.allTrials.trialNb(tI)~=1
        tnf = tnf + 1;
    end
    if taskStruct.allTrials.trType(tI)==1 %observe
        tO = tO + 1;
    end
end

% mark completion time
taskStruct.endTime = GetSecs();

% save data and clean up
if taskStruct.session == 1
    save(fullfile(taskStruct.outputFolder, taskStruct.fileName), 'taskStruct', 'taskStruct_practice');
else
    save(fullfile(taskStruct.outputFolder, taskStruct.fileName), 'taskStruct');
end

% accumulate the total number of points earned
totalPoints = nansum(taskStruct.allTrials.outcome);

% finish game
Screen(ioStruct.wPtr, 'Flip');

% show outcome information
Screen('TextSize', ioStruct.wPtr, 30); 
Screen('TextColor', ioStruct.wPtr, [255 255 255]); 
Screen('TextFont', ioStruct.wPtr, 'Helvetica');
DrawFormattedText(ioStruct.wPtr, ['End of the task.\n\n You earned a total of ' num2str(totalPoints) ' points.'], 'center', 'center');
% show prompt
Screen(ioStruct.wPtr, 'Flip');

RestrictKeysForKbCheck( [ioStruct.respKey_Quit, KbName('space')] );
[~, keyCode] = KbWait(-3,2);

RestrictKeysForKbCheck( [] );
ListenChar(1); ShowCursor();
sca; 