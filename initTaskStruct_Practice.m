function tr_table = initTaskStruct_Practice()
   
    numTrials = 10;
    
    %define variable from the tr_list matrix
    runNb = zeros(numTrials,1);
    runID = zeros(numTrials,1);
    trialNb = (1:numTrials)';
    trType = [1;1;2;1;1;1;2;1;1;2];
    goalToken = [3;3;3;3;2;2;2;1;1;1];
    uncertainty = ones(numTrials,1);
    unavAct = [3;2;2;1;1;2;1;1;3;2];
    corrAct = [2;3;3;3;2;1;2;3;1;1];
    bestAct = [3;3;3;3;2;2;2;1;1;1];
    vertOrd = ones(numTrials,1);
    horizOrd = ones(numTrials,1);
    
    %pre-determine token to show depending on run and response
    tokenIfLeft = nan(numTrials, 1);
    tokenIfMid = nan(numTrials, 1);
    tokenIfRight = nan(numTrials, 1);
    for t=1:numTrials
        if trType(t) == 2 %play trial
            tokenIfLeft(t) = 1;
            tokenIfMid(t) = 2;
            tokenIfRight(t) = 3;
        end
    end
        
    % to store task events as the unfold
    video_nb = nan(numTrials, 1);
    choice = nan(numTrials, 1);
    choiceRT = nan(numTrials, 1);
    isCorr = nan(numTrials, 1);
    tokenShown = nan(numTrials, 1);
    isGoal = nan(numTrials, 1);
    outcome = nan(numTrials, 1);
    miss = nan(numTrials, 1);

    % to store event times
    tFixOn = nan(numTrials, 1);
    tTrTypeOn = nan(numTrials, 1);
    tSMOn = nan(numTrials, 1);
    tFixObsOn = nan(numTrials, 1);
    tVidOn = nan(numTrials, 1);
    tResp = nan(numTrials, 1);
    tChFbOn = nan(numTrials, 1);
    tFixPlayOn = nan(numTrials, 1);
    tTokOn = nan(numTrials, 1);
    tMissOn = nan(numTrials, 1);
    
    % collate data into a trial structure
    tr_table = table(runNb, runID, trialNb, trType, goalToken, uncertainty, ...
        unavAct, corrAct, bestAct, vertOrd, horizOrd, ...
        video_nb, choice, choiceRT, isCorr, tokenIfLeft, tokenIfMid, tokenIfRight, ...
        tokenShown, isGoal, outcome, miss,...
        tFixOn, tTrTypeOn, tSMOn, tFixObsOn, tVidOn, tResp, tChFbOn, tFixPlayOn, tTokOn, tMissOn);
    
end