function tr_table = initTaskStruct_Task(tr_list)
   
    numTrials = length(tr_list(:,1));
    
    %define variable from the tr_list matrix
    runNb = tr_list(:,1);
    runID = tr_list(:,2);
    trialNb = tr_list(:,3);
    trType = tr_list(:,4);
    goalToken = tr_list(:,5);
    uncertainty = tr_list(:,6);
    unavAct = tr_list(:,7);
    corrAct = tr_list(:,8);
    bestAct = tr_list(:,9);
    vertOrd = tr_list(:,10);
    horizOrd = tr_list(:,11);
    
    %calculate on how many play trials each color-majority slot machine is available
    recap = zeros(numTrials,3);
    i_glu_av = ((horizOrd==1 & unavAct~=1) | (horizOrd==2 & unavAct~=3) | (horizOrd==3 & unavAct~=2)) & trType==2 & uncertainty==1;
    i_rlu_av = ((horizOrd==1 & unavAct~=2) | (horizOrd==2 & unavAct~=1) | (horizOrd==3 & unavAct~=3)) & trType==2 & uncertainty==1;
    i_blu_av = ((horizOrd==1 & unavAct~=3) | (horizOrd==2 & unavAct~=2) | (horizOrd==3 & unavAct~=1)) & trType==2 & uncertainty==1;
    i_ghu_av = ((horizOrd==1 & unavAct~=1) | (horizOrd==2 & unavAct~=3) | (horizOrd==3 & unavAct~=2)) & trType==2 & uncertainty==2;
    i_rhu_av = ((horizOrd==1 & unavAct~=2) | (horizOrd==2 & unavAct~=1) | (horizOrd==3 & unavAct~=3)) & trType==2 & uncertainty==2;
    i_bhu_av = ((horizOrd==1 & unavAct~=3) | (horizOrd==2 & unavAct~=2) | (horizOrd==3 & unavAct~=1)) & trType==2 & uncertainty==2;
    
    gmaj_av_lu = sum(i_glu_av);
    rmaj_av_lu = sum(i_rlu_av);
    bmaj_av_lu = sum(i_blu_av);
    gmaj_av_hu = sum(i_ghu_av);
    rmaj_av_hu = sum(i_rhu_av);
    bmaj_av_hu = sum(i_bhu_av);
    
    %pre-determine token counts
    ptok_glu = [round(gmaj_av_lu*0.75) round(gmaj_av_lu*0.2) gmaj_av_lu-round(gmaj_av_lu*0.75)-round(gmaj_av_lu*0.2)];
    ptok_rlu = [round(rmaj_av_lu*0.75) round(rmaj_av_lu*0.2) rmaj_av_lu-round(rmaj_av_lu*0.75)-round(rmaj_av_lu*0.2)];
    ptok_blu = [round(bmaj_av_lu*0.75) round(bmaj_av_lu*0.2) bmaj_av_lu-round(bmaj_av_lu*0.75)-round(bmaj_av_lu*0.2)];
    
    ptok_ghu = [round(gmaj_av_hu*0.5) round(gmaj_av_hu*0.3) gmaj_av_hu-round(gmaj_av_hu*0.5)-round(gmaj_av_hu*0.3)];
    ptok_rhu = [round(rmaj_av_hu*0.5) round(rmaj_av_hu*0.3) rmaj_av_hu-round(rmaj_av_hu*0.5)-round(rmaj_av_hu*0.3)];
    ptok_bhu = [round(bmaj_av_hu*0.5) round(bmaj_av_hu*0.3) bmaj_av_hu-round(bmaj_av_hu*0.5)-round(bmaj_av_hu*0.3)];
    
    %pre-determine which token to show
    tok_gmaj_lu = [randperm(gmaj_av_lu)' [ones(ptok_glu(1),1); 2*ones(ptok_glu(2),1); 3*ones(ptok_glu(3),1)]];
    tok_gmaj_lu = sortrows(tok_gmaj_lu,1);
    tok_rmaj_lu = [randperm(rmaj_av_lu)' [2*ones(ptok_rlu(1),1); 3*ones(ptok_rlu(2),1); ones(ptok_rlu(3),1)]];
    tok_rmaj_lu = sortrows(tok_rmaj_lu,1);
    tok_bmaj_lu = [randperm(bmaj_av_lu)' [3*ones(ptok_blu(1),1); ones(ptok_blu(2),1); 2*ones(ptok_blu(3),1)]];
    tok_bmaj_lu = sortrows(tok_bmaj_lu,1);
    
    tok_gmaj_hu = [randperm(gmaj_av_hu)' [ones(ptok_ghu(1),1); 2*ones(ptok_ghu(2),1); 3*ones(ptok_ghu(3),1)]];
    tok_gmaj_hu = sortrows(tok_gmaj_hu,1);
    tok_rmaj_hu = [randperm(rmaj_av_hu)' [2*ones(ptok_rhu(1),1); 3*ones(ptok_rhu(2),1); ones(ptok_rhu(3),1)]];
    tok_rmaj_hu = sortrows(tok_rmaj_hu,1);
    tok_bmaj_hu = [randperm(bmaj_av_hu)' [3*ones(ptok_bhu(1),1); ones(ptok_bhu(2),1); 2*ones(ptok_bhu(3),1)]];
    tok_bmaj_hu = sortrows(tok_bmaj_hu,1);
    
    %fill out recap matrix: left=token to show for green maj SM;
    %middle=token to show for red maj SM; right=token to show for blue maj SM
    recap(i_glu_av(:,1),1) = tok_gmaj_lu(:,2);
    recap(i_ghu_av(:,1),1) = tok_gmaj_hu(:,2);
    recap(i_rlu_av(:,1),2) = tok_rmaj_lu(:,2);
    recap(i_rhu_av(:,1),2) = tok_rmaj_hu(:,2);
    recap(i_blu_av(:,1),3) = tok_bmaj_lu(:,2);
    recap(i_bhu_av(:,1),3) = tok_bmaj_hu(:,2);
    
    tokenIfLeft = nan(numTrials, 1);
    tokenIfMid = nan(numTrials, 1);
    tokenIfRight = nan(numTrials, 1);
    for t=1:numTrials
        if trType(t) == 2 %play trial
            if unavAct(t) == 1 %left unavailable
                if horizOrd(t) == 1
                    tokenIfMid(t) = recap(t,2); %red_maj
                    tokenIfRight(t) = recap(t,3); %blue_maj
                elseif horizOrd(t) == 2
                    tokenIfMid(t) = recap(t,3); %blue_maj
                    tokenIfRight(t) = recap(t,1); %green_maj
                elseif horizOrd(t) == 3
                    tokenIfMid(t) = recap(t,1); %green_maj
                    tokenIfRight(t) = recap(t,2); %red_maj
                end
            elseif unavAct(t) == 2 %middle unavailable
                if horizOrd(t) == 1
                    tokenIfLeft(t) = recap(t,1); %green_maj
                    tokenIfRight(t) = recap(t,3); %blue_maj
                elseif horizOrd(t) == 2
                    tokenIfLeft(t) = recap(t,2); %red_maj
                    tokenIfRight(t) = recap(t,1); %green_maj
                elseif horizOrd(t) == 3
                    tokenIfLeft(t) = recap(t,3); %blue_maj
                    tokenIfRight(t) = recap(t,2); %red_maj
                end
            elseif unavAct(t) == 3 %right unavailable
                if horizOrd(t) == 1
                    tokenIfLeft(t) = recap(t,1); %green_maj
                    tokenIfMid(t) = recap(t,2); %red_maj
                elseif horizOrd(t) == 2
                    tokenIfLeft(t) = recap(t,2); %red_maj
                    tokenIfMid(t) = recap(t,3); %blue_maj
                elseif horizOrd(t) == 3
                    tokenIfLeft(t) = recap(t,3); %blue_maj
                    tokenIfMid(t) = recap(t,1); %green_maj
                end
            end
        end
    end    
    isBreak = (((runID==1 | runID==2) & trialNb==10) | ((runID==3 | runID==4) & trialNb==11)) & runNb~=8;
        
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
        unavAct, corrAct, bestAct, vertOrd, horizOrd, isBreak, ...
        video_nb, choice, choiceRT, isCorr, tokenIfLeft, tokenIfMid, tokenIfRight, ...
        tokenShown, isGoal, outcome, miss,...
        tFixOn, tTrTypeOn, tSMOn, tFixObsOn, tVidOn, tResp, tChFbOn, tFixPlayOn, tTokOn, tMissOn);
    
end