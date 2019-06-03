function tr_table = initTaskStruct_Task(tr_list)
   
    numTrials = length(tr_list(:,1));
    
    %define variable from the tr_list matrix
    runNb = tr_list(:,1);
    runID = tr_list(:,2);
    trialNb = tr_list(:,3);
    trType = tr_list(:,4);
    goalToken = tr_list(:,5);
    volatility = tr_list(:,6);
    uncertainty = tr_list(:,7);
    unavAct = tr_list(:,8);
    corrAct = tr_list(:,9);
    bestAct = tr_list(:,10);
    vertOrd = tr_list(:,11);
    horizOrd = tr_list(:,12);
    
    %pre-determine token to show depending on run and response
    ptok = [10,3,1];
    tok_gmaj_lu = [ones(ptok(1),1); 2*ones(ptok(2),1); 3*ones(ptok(3),1)];
    tok_rmaj_lu = [2*ones(ptok(1),1); 3*ones(ptok(2),1); ones(ptok(3),1)];
    tok_bmaj_lu = [3*ones(ptok(1),1); ones(ptok(2),1); 2*ones(ptok(3),1)];
    shuffle_order_lu = randperm(14)';
    sorted_lu = [shuffle_order_lu tok_gmaj_lu tok_rmaj_lu tok_bmaj_lu];
    sorted_lu = sortrows(sorted_lu,1);
    
    ptok = [7,4,3];
    tok_gmaj_hu = [ones(ptok(1),1); 2*ones(ptok(2),1); 3*ones(ptok(3),1)];
    tok_rmaj_hu = [2*ones(ptok(1),1); 3*ones(ptok(2),1); ones(ptok(3),1)];
    tok_bmaj_hu = [3*ones(ptok(1),1); ones(ptok(2),1); 2*ones(ptok(3),1)];
    shuffle_order_hu = randperm(14)';
    sorted_hu = [shuffle_order_hu tok_gmaj_hu tok_rmaj_hu tok_bmaj_hu];
    sorted_hu = sortrows(sorted_hu,1);
    
    if uncertainty(1) == 1 %task starts with low uncertainty block
        token_matrix = [sorted_lu(:,2:4); sorted_hu(:,2:4)];
    elseif uncertainty(1) == 2 %task starts with high uncertainty block
        token_matrix = [sorted_hu(:,2:4); sorted_lu(:,2:4)];
    end
        
    tokenIfLeft = nan(numTrials, 1);
    tokenIfMid = nan(numTrials, 1);
    tokenIfRight = nan(numTrials, 1);
    tp = 1;
    for t=1:numTrials
        if trType(t) == 2 %play trial
            if horizOrd(t) == 1
                tokenIfLeft(t) = token_matrix(tp,1);
                tokenIfMid(t) = token_matrix(tp,2);
                tokenIfRight(t) = token_matrix(tp,3);
            elseif horizOrd(t) == 2
                tokenIfLeft(t) = token_matrix(tp,2);
                tokenIfMid(t) = token_matrix(tp,3);
                tokenIfRight(t) = token_matrix(tp,1);
            elseif horizOrd(t) == 3
                tokenIfLeft(t) = token_matrix(tp,3);
                tokenIfMid(t) = token_matrix(tp,1);
                tokenIfRight(t) = token_matrix(tp,2);
            end
            tp = tp + 1;
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
    tVidOn = nan(numTrials, 1);
    tResp = nan(numTrials, 1);
    tChFbOn = nan(numTrials, 1);
    tTokOn = nan(numTrials, 1);
    tMissOn = nan(numTrials, 1);
    
    % collate data into a trial structure
   tr_table = table(runNb, runID, trialNb, trType, goalToken, volatility, uncertainty, ...
        unavAct, corrAct, bestAct, vertOrd, horizOrd, ...
        video_nb, choice, choiceRT, isCorr, tokenIfLeft, tokenIfMid, tokenIfRight, ...
        tokenShown, isGoal, outcome, miss,...
        tFixOn, tTrTypeOn, tSMOn, tVidOn, tResp, tChFbOn, tTokOn, tMissOn);
    
end