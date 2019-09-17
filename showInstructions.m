function [] = showInstructions(ioStruct, instrDir)
    instrFiles = dir(fullfile(instrDir, '*.jpg'));

    % load task instruction images
    ioStruct.instructions = nan(length(instrFiles),1);
    for iI = 1 : length(ioStruct.instructions) %do not show last instruction slide (keep for after practice)
        ioStruct.instructions(iI) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(instrDir, instrFiles(iI).name)));
    end
    
    % define forward/back keys for each screne (default to arrow keys)
    backKeys = repmat({KbName('z')}, length(ioStruct.instructions), 1);
    nextKeys = repmat({KbName('space')}, length(ioStruct.instructions), 1);
    % define response keys the move them forward
    nextKeys{2} = KbName('g');
    nextKeys{6} = 0; %wait 3s
    nextKeys{7} = ioStruct.respKey_3; %right arrow
    nextKeys{8} = 0; %wait 3s
    nextKeys{10} = 0; %wait 3s
    nextKeys{11} = ioStruct.respKey_2; %down arrow
    nextKeys{12} = 0; %wait 3s
    nextKeys{16} = KbName('r');
    nextKeys{18} = [KbName('2') KbName('2@')];
        
    % initialize the instruction display
    instructionWidth = 1000;
    instructionHeight = 750;
    leftX = ioStruct.centerX - round((instructionWidth/2));
    topY = ioStruct.centerY - round((instructionHeight/2));
    ioStruct.instructionRect = [leftX, topY, leftX+instructionWidth, topY+instructionHeight];
    
    % list of instructions to show
    instructions = 1:(size(ioStruct.instructions));
    % init the current instruction
    currentInst = 1;

    % loop until done signal
    doneInst = false;
    while ~doneInst
        % show instructions
        Screen('DrawTexture', ioStruct.wPtr, ioStruct.instructions(currentInst), [], ioStruct.instructionRect, [], [], 1 );
        Screen(ioStruct.wPtr, 'Flip');
        
        % wait for navigation input
        if nextKeys{currentInst} ~= 0
            RestrictKeysForKbCheck( [backKeys{currentInst}, nextKeys{currentInst} ] );
            [~, keyCode] = KbWait(-3, 2);

            % update the current instructin according to key press
            respKey = find(keyCode);
            if ismember( respKey, nextKeys{currentInst} ) && currentInst == instructions(end)
                doneInst = true;
            elseif ismember( respKey, backKeys{currentInst} )
                % move back
                currentInst = max(1, currentInst-1);
            elseif ismember( respKey, nextKeys{currentInst} )
                % move forward
                currentInst = min(length(instructions), currentInst+1);
            end
        else
            %wait 3s then move forward
            WaitSecs(3);
            currentInst = min(length(instructions), currentInst+1);
        end
    end
    
    RestrictKeysForKbCheck([]);
end