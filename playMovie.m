function [trialSpec] = playMovie(trialSpec, ioStruct, ind_vid, UF, VOF, left_ind, mid_ind, right_ind, task_start_time)

% from Eva Pool - 2017

% initialize variables
nFrames = length(ioStruct.video(ind_vid).vdata);
frameTime = (0:nFrames-1)/25;
actualFrameTime  = zeros(1,nFrames);
FlushEvents(); % clean the keyboard memory
iFrame = 0;
trialSpec.tVidOn = GetSecs() - task_start_time;

while iFrame < nFrames
    
    iFrame = iFrame + 1;   
    
    %draw the movie frame
    tex = Screen('MakeTexture', ioStruct.wPtr, ioStruct.video(ind_vid).vdata{iFrame,1});       
    Screen('DrawTexture', ioStruct.wPtr, tex, [], ioStruct.MovieBox);
    
    %draw the boxes
    Screen('FrameRect', ioStruct.wPtr, ioStruct.textColor, ioStruct.TopBox);
    Screen('FrameRect', ioStruct.wPtr, ioStruct.textColor, ioStruct.BottomBox);
    
    %draw the slot machines
    if frameTime(iFrame)<1.1
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
    else
        % after 1.1 s of the video highlight partner's chosen action
        if trialSpec.unavAct == 1 %unavailable action 1
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.UA.(UF).(VOF)(left_ind), [], ioStruct.LeftSMObs);
            if trialSpec.corrAct == 2 %partner's action 2
                Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.CH.(UF).(VOF)(mid_ind), [], ioStruct.MidSMObs);
                Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(right_ind), [], ioStruct.RightSMObs);
            elseif trialSpec.corrAct == 3 %partner's action 3
                Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(mid_ind), [], ioStruct.MidSMObs);
                Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.CH.(UF).(VOF)(right_ind), [], ioStruct.RightSMObs);
            end
        elseif trialSpec.unavAct == 2 %unavailable action 2
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.UA.(UF).(VOF)(mid_ind), [], ioStruct.MidSMObs);
            if trialSpec.corrAct == 1 %partner's action 1
                Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.CH.(UF).(VOF)(left_ind), [], ioStruct.LeftSMObs);
                Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(right_ind), [], ioStruct.RightSMObs);
            elseif trialSpec.corrAct == 3 %partner's action 3
                Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(left_ind), [], ioStruct.LeftSMObs);
                Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.CH.(UF).(VOF)(right_ind), [], ioStruct.RightSMObs);
            end
        elseif trialSpec.unavAct == 3 %unavailable action 3
            Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.UA.(UF).(VOF)(right_ind), [], ioStruct.RightSMObs);
            if trialSpec.corrAct == 1 %partner's action 1
                Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.CH.(UF).(VOF)(left_ind), [], ioStruct.LeftSMObs);
                Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(mid_ind), [], ioStruct.MidSMObs);
            elseif trialSpec.corrAct == 2 %partner's action 2
                Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.AV.(UF).(VOF)(left_ind), [], ioStruct.LeftSMObs);
                Screen('DrawTexture', ioStruct.wPtr, ioStruct.SM.CH.(UF).(VOF)(mid_ind), [], ioStruct.MidSMObs);
            end
        end
    end
    
    when = actualFrameTime(1) + frameTime(iFrame);
    [~,actualFrameTime(iFrame)] = Screen('Flip', ioStruct.wPtr, when);% Update display
    Screen('Close', tex); % Release texture
    
end
