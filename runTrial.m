function trialSpec = runTrial(ioStruct, trialSpec, task_start_time, tnf, tO)
    %trialSpec is the trial list; for the OL task, it's a table with the
    %following columns:
    %1: run number
    %2: run ID
    %3: trial number
    %4: trial type (1: observe, 2: play)
    %5: goal token (1: green, 2: red, 3: blue)
    %6: volatility (1: stable, 2: volatile)
    %7: uncertainty (1: low, 2: high)
    %8: unavailable action
    %9: correct action
    %10: best action
    %11: vertical order
    %12: horizontal order
    
    % only allow relevant keys
    if trialSpec.unavAct == 1
        RestrictKeysForKbCheck( [ioStruct.respKey_2, ioStruct.respKey_3] );
    elseif trialSpec.unavAct == 2
        RestrictKeysForKbCheck( [ioStruct.respKey_1, ioStruct.respKey_3] );
    elseif trialSpec.unavAct == 3
        RestrictKeysForKbCheck( [ioStruct.respKey_1, ioStruct.respKey_2] );
    end
    
    % fixation cross to start trial
    startTime = GetSecs();
    Screen('TextSize', ioStruct.wPtr, 40); 
    Screen('TextColor', ioStruct.wPtr, ioStruct.textColor);
    if trialSpec.trialNb ~= 1 %only show ITI fixation on first trial
        DrawFormattedText(ioStruct.wPtr, '+', 'center', 'center');
        [~, onset] = Screen(ioStruct.wPtr, 'Flip', 0);
        trialSpec.tFixOn = onset - task_start_time;
    end
    
    %print observe or play to indicate trial type
    if trialSpec.trType == 1 %observe trial
        trtype_text = 'Observe';
    elseif trialSpec.trType == 2 %play trial
        trtype_text = 'Play';
    end
    DrawFormattedText(ioStruct.wPtr, trtype_text, 'center', 'center');
    if trialSpec.trialNb ~= 1 %only show ITI fixation on first trial
        if tnf ~= 0
            [~, onset_trtype] = Screen(ioStruct.wPtr, 'Flip', startTime + ioStruct.FIX_DURATION(tnf), 1); %jitter
        else
            [~, onset_trtype] = Screen(ioStruct.wPtr, 'Flip', startTime + 3, 1); %no jitter (practice)
        end
    else %show trType onset at t=0
        [~, onset_trtype] = Screen(ioStruct.wPtr, 'Flip', startTime, 1);
    end
    trialSpec.tTrTypeOn = onset_trtype - task_start_time;
    
    %determine which slot machines to draw where
    if trialSpec.uncertainty == 1 %low uncertainty
        UF = 'LU';
    elseif trialSpec.uncertainty == 2 %high uncertainty
        UF = 'HU';
    end
    VOF = ['VO' num2str(trialSpec.vertOrd)];
    if trialSpec.horizOrd == 1 %horizontal order 1
        left_ind = 1;
        mid_ind = 2;
        right_ind = 3;
    elseif trialSpec.horizOrd == 2 %horizontal order 2
        left_ind = 2;
        mid_ind = 3;
        right_ind = 1;
    elseif trialSpec.horizOrd == 3 %horizontal order 3
        left_ind = 3;
        mid_ind = 1;
        right_ind = 2;
    end
    
    if trialSpec.trType == 1 %observe trial
        % draw top and bottom rectangles for partner's action
        Screen('FrameRect', ioStruct.wPtr, ioStruct.textColor, ioStruct.TopBox);
        Screen('FrameRect', ioStruct.wPtr, ioStruct.textColor, ioStruct.BottomBox);
        %draw slot machines
        if trialSpec.unavAct == 1 %unavailable action 1
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.UA.(UF).(VOF)(left_ind), [], ioStruct.LeftSMObs);
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(mid_ind), [], ioStruct.MidSMObs);
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(right_ind), [], ioStruct.RightSMObs);
        elseif trialSpec.unavAct == 2 %unavailable action 2
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(left_ind), [], ioStruct.LeftSMObs);
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.UA.(UF).(VOF)(mid_ind), [], ioStruct.MidSMObs);
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(right_ind), [], ioStruct.RightSMObs);
        elseif trialSpec.unavAct == 3 %unavailable action 3
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(left_ind), [], ioStruct.LeftSMObs);
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(mid_ind), [], ioStruct.MidSMObs);
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.UA.(UF).(VOF)(right_ind), [], ioStruct.RightSMObs);
        end
        [~, onset_sm] = Screen(ioStruct.wPtr, 'Flip', onset_trtype + ioStruct.OBSPLAY_DURATION, 1);
        trialSpec.tSMOn = onset_sm - task_start_time;
        % clear the screen after required duration
        Screen(ioStruct.wPtr, 'Flip', onset_sm + ioStruct.SM_OBS_DURATION);
        
        % show fixation cross before video
        Screen('FrameRect', ioStruct.wPtr, ioStruct.textColor, ioStruct.TopBox);
        Screen('FrameRect', ioStruct.wPtr, ioStruct.textColor, ioStruct.BottomBox);
        DrawFormattedText(ioStruct.wPtr, '+', 'center', ioStruct.centerY - 120);
        [~, onset_fixobs] = Screen(ioStruct.wPtr, 'Flip', onset_sm + ioStruct.SM_OBS_DURATION, 1); 
        trialSpec.tFixObsOn = onset_fixobs - task_start_time;
        
        % clear the screen after required duration, before playing video
        if tO ~= 0
            Screen(ioStruct.wPtr, 'Flip', onset_fixobs + ioStruct.FIXOBS_DURATION(tO)); %jitter
        else 
            Screen(ioStruct.wPtr, 'Flip', onset_fixobs + 1); %no jitter (practice)
        end
    
        % determine which video to show
        trialSpec.video_nb = randi(5);
        if trialSpec.corrAct == 1 %left action
            ind_vid = trialSpec.video_nb + 5; %indices 6 to 10 in video list
        elseif trialSpec.corrAct == 2 %down action
            ind_vid = trialSpec.video_nb; %indices 1 to 5 in video list
        elseif trialSpec.corrAct == 3 %right action
            ind_vid = trialSpec.video_nb + 10; %indices 11 to 15 in video list
        end

        % keep slot machines on and show video
        [trialSpec] = playMovie(trialSpec, ioStruct, ind_vid, UF, VOF, left_ind, mid_ind, right_ind, task_start_time);
        
        % clear the screen after required duration
        Screen(ioStruct.wPtr, 'Flip');
        
    elseif trialSpec.trType == 2 %play trial
        %draw slot machines
        if trialSpec.unavAct == 1 %unavailable action 1
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.UA.(UF).(VOF)(left_ind), [], ioStruct.LeftSMPlay);
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(mid_ind), [], ioStruct.MidSMPlay);
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(right_ind), [], ioStruct.RightSMPlay);
        elseif trialSpec.unavAct == 2 %unavailable action 2
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(left_ind), [], ioStruct.LeftSMPlay);
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.UA.(UF).(VOF)(mid_ind), [], ioStruct.MidSMPlay);
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(right_ind), [], ioStruct.RightSMPlay);
        elseif trialSpec.unavAct == 3 %unavailable action 3
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(left_ind), [], ioStruct.LeftSMPlay);
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(mid_ind), [], ioStruct.MidSMPlay);
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.UA.(UF).(VOF)(right_ind), [], ioStruct.RightSMPlay);
        end
        Screen('TextSize', ioStruct.wPtr, 40);
        Screen('TextColor', ioStruct.wPtr, [255 255 255]);
        Screen('TextFont', ioStruct.wPtr, 'Helvetica');
        DrawFormattedText(ioStruct.wPtr, 'CHOOSE', 'center', ioStruct.centerY + 300);

        % remove fixation after all keys are released
        KbReleaseWait(-3);
        [~, onset_sm] = Screen(ioStruct.wPtr, 'Flip', onset_trtype + ioStruct.OBSPLAY_DURATION, 1);
        trialSpec.tSMOn = onset_sm - task_start_time;
        
        % wait for response and store RT
        [onset_ch, keyCode] = KbWait(-3, 2, GetSecs() + ioStruct.MAX_RT);
        trialSpec.tResp = onset_ch - task_start_time;
        trialSpec.choiceRT = trialSpec.tResp - trialSpec.tSMOn;
        pressedKey = find(keyCode); %only keep last keypress
        
        % was a valid response captured
        if isempty(pressedKey)
            % no valid response - show missed trial message 
            Screen(ioStruct.wPtr, 'Flip'); % clear the screen
            Screen('TextSize', ioStruct.wPtr, 30);
            Screen('TextColor', ioStruct.wPtr, [255 255 255]);
            Screen('TextFont', ioStruct.wPtr, 'Helvetica');
            DrawFormattedText(ioStruct.wPtr, 'Missed response.\n\n Please wait for next round...', 'center', 'center');
            [~, onset_miss] = Screen(ioStruct.wPtr, 'Flip');
            trialSpec.tMissOn = onset_miss - task_start_time;
            Screen(ioStruct.wPtr, 'Flip', GetSecs() + ioStruct.MISSED_DURATION);
            
            trialSpec.miss = 1;
            trialSpec.isCorr = 0;
            trialSpec.outcome = 0;
            
            return;
        
        else
            % capture selected option
            if ismember(pressedKey(end), ioStruct.respKey_1)
                trialSpec.choice = 1;
            elseif ismember(pressedKey(end), ioStruct.respKey_2)
                trialSpec.choice = 2;
            elseif ismember(pressedKey(end), ioStruct.respKey_3)
                trialSpec.choice = 3;
            end
        
            trialSpec.miss = 0;
            if trialSpec.choice == trialSpec.corrAct
                trialSpec.isCorr = 1;
            else
                trialSpec.isCorr = 0;
            end
            
            % show the chosen option
            if trialSpec.unavAct == 1 %unavailable action 1
                Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.UA.(UF).(VOF)(left_ind), [], ioStruct.LeftSMPlay);
                if trialSpec.choice == 2 %choice 2
                    Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.CH.(UF).(VOF)(mid_ind), [], ioStruct.MidSMPlay);
                    Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(right_ind), [], ioStruct.RightSMPlay);
                elseif trialSpec.choice == 3 %choice 3
                    Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(mid_ind), [], ioStruct.MidSMPlay);
                    Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.CH.(UF).(VOF)(right_ind), [], ioStruct.RightSMPlay);
                end
            elseif trialSpec.unavAct == 2 %unavailable action 2
                Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.UA.(UF).(VOF)(mid_ind), [], ioStruct.MidSMPlay);
                if trialSpec.choice == 1 %choice 1
                    Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.CH.(UF).(VOF)(left_ind), [], ioStruct.LeftSMPlay);
                    Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(right_ind), [], ioStruct.RightSMPlay);
                elseif trialSpec.choice == 3 %choice 3
                    Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(left_ind), [], ioStruct.LeftSMPlay);
                    Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.CH.(UF).(VOF)(right_ind), [], ioStruct.RightSMPlay);
                end
            elseif trialSpec.unavAct == 3 %unavailable action 3
                Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.UA.(UF).(VOF)(right_ind), [], ioStruct.RightSMPlay);
                if trialSpec.choice == 1 %choice 1
                    Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.CH.(UF).(VOF)(left_ind), [], ioStruct.LeftSMPlay);
                    Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(mid_ind), [], ioStruct.MidSMPlay);
                elseif trialSpec.choice == 2 %choice 2
                    Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(left_ind), [], ioStruct.LeftSMPlay);
                    Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.CH.(UF).(VOF)(mid_ind), [], ioStruct.MidSMPlay);
                end
            end
            [~, onset_chfb] = Screen(ioStruct.wPtr, 'Flip', 0);
            trialSpec.tChFbOn = onset_chfb - task_start_time;
            
            % show fixation cross for 4s - RT
            DrawFormattedText(ioStruct.wPtr, '+', 'center', 'center');
            [~, onset_fixplay] = Screen(ioStruct.wPtr, 'Flip', onset_chfb + ioStruct.CHOICE_FB_DURATION, 0); 
            trialSpec.tFixPlayOn = onset_fixplay - task_start_time;
            dur_fix = ioStruct.MAX_RT - trialSpec.choiceRT;
            
            % show token
            if trialSpec.choice == 1
                trialSpec.tokenShown = trialSpec.tokenIfLeft;
            elseif trialSpec.choice == 2
                trialSpec.tokenShown = trialSpec.tokenIfMid;
            elseif trialSpec.choice == 3
                trialSpec.tokenShown = trialSpec.tokenIfRight;
            end
            if trialSpec.tokenShown == trialSpec.goalToken
                trialSpec.isGoal = 1;
                trialSpec.outcome = 10;
            else
                trialSpec.isGoal = 0;
                trialSpec.outcome = 0;
            end
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.token(trialSpec.tokenShown), [], ioStruct.TokenBox);
            [~, onset_tok] = Screen(ioStruct.wPtr, 'Flip', onset_fixplay + dur_fix, 0);
            trialSpec.tTokOn = onset_tok - task_start_time;
            
            % clear the screen after required duration
            Screen(ioStruct.wPtr, 'Flip', onset_tok + ioStruct.TOKEN_DURATION);
        
        end
    end
end
