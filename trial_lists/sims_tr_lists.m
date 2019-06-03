clear all
close all

data_dir = 'C:\Users\Caroline\OL_task_for_battery_PTB\trial_lists\';
cd(data_dir)

% init the randomization screen
RandStream.setGlobalStream(RandStream('mt19937ar','Seed','shuffle'));

%Setup solver opt 
% for fminunc (Jeff's settings)
npar = 5; %number of parameters
opts = optimoptions(@fminunc, ...
        'Algorithm', 'quasi-newton', ...
        'Display','off', ...
        'MaxFunEvals', 50 * npar, ...
        'MaxIter', 50 * npar,...
        'TolFun', 0.01, ...
        'TolX', 0.01);
    
nt = 84; %number of trials

%contingencies of the slot machine (each row=token, each column=action)
SM_struct = cell(2,3);
SM_struct{1,1} = [0.75 0.05 0.2; 0.2 0.75 0.05; 0.05 0.2 0.75]; %probability distribution of EASY slot machine (low BU, horizOrd 1)
SM_struct{1,2} = [0.05 0.2 0.75; 0.75 0.05 0.2; 0.2 0.75 0.05]; %probability distribution of EASY slot machine (low BU, horizOrd 2)
SM_struct{1,3} = [0.2 0.75 0.05; 0.05 0.2 0.75; 0.75 0.05 0.2]; %probability distribution of EASY slot machine (low BU, horizOrd 3)
SM_struct{2,1} = [0.5 0.2 0.3; 0.3 0.5 0.2; 0.2 0.3 0.5]; %probability distribution of HARD slot machine (high BU, horizOrd 1)
SM_struct{2,2} = [0.2 0.3 0.5; 0.5 0.2 0.3; 0.3 0.5 0.2]; %probability distribution of HARD slot machine (high BU, horizOrd 2)
SM_struct{2,3} = [0.3 0.5 0.2; 0.2 0.3 0.5; 0.5 0.2 0.3]; %probability distribution of HARD slot machine (high BU, horizOrd 3)

%task structure matrices
P_PA_Tok{1,1} = [0 0 1;0 1 0;0 0 1]; %ua 1, horizOrd 1
P_PA_Tok{1,2} = [0 0 1;0 0 1;0 1 0]; %ua 1, horizOrd 2
P_PA_Tok{1,3} = [0 1 0;0 0 1;0 0 1]; %ua 1, horizOrd 3
P_PA_Tok{2,1} = [1 0 0;1 0 0;0 0 1]; %ua 2, horizOrd 1
P_PA_Tok{2,2} = [0 0 1;1 0 0;1 0 0]; %ua 2, horizOrd 2
P_PA_Tok{2,3} = [1 0 0;0 0 1;1 0 0]; %ua 2, horizOrd 3
P_PA_Tok{3,1} = [1 0 0;0 1 0;0 1 0]; %ua 3, horizOrd 1
P_PA_Tok{3,2} = [0 1 0;1 0 0;0 1 0]; %ua 3, horizOrd 2
P_PA_Tok{3,3} = [0 1 0;0 1 0;1 0 0]; %ua 3, horizOrd 3
%here we detail the structure of probability of each partner's action given
%set of available actions and given goal token
%each row of the cell structure {1}, {2}, or {3} represents the unavailable action.
%each column of the cell structure {1}, {2}, or {3} represents the horizontal order.
%within each cell, each column represents the action performed by the partner
%and each row represents the conditional goal token (1:green, 2:red, 3:blue)

EM_pcorr = zeros(nt,10);
IM_pcorr = zeros(nt,10);
for v=1:10
    P = csvread(['trial_list_v' num2str(v) '.csv'],1,0);
    %column order
    %col 1: run number
    %col 2: run ID
    %col 3: trial number
    %col 4: Observe (1), Play (2)
    %col 5: goal token
    %col 6: stable (1), volatile (2)
    %col 7: low uncertainty (1), high uncertainty (2)
    %col 8: unavailable action
    %col 9: correct action (also partner's action)
    %col 10: best action
    
    i_1 = P(:,2)==1;
    i_2 = P(:,2)==2;

    V_tok = [NaN(nt,3) P(:,4) NaN(nt,2)];
    V_act = [P(:,9) P(:,8) P(:,4) NaN(nt,2)];
    for t=1:nt
        if P(t,3) == 1 %first trial of a block
            nat = 0; %reset nat
        end
        HO = P(t,12);
        UA = P(t,8);
        PA = P(t,9);
        GT = P(t,5);
        BU = P(t,7);

        poss_tok = P_PA_Tok{UA,HO}(:,PA)';

        %make V_tok keep track of previous token values since last
        %'sure' (i.e. non-ambiguous) set of values
        if P(t,4) == 1 %observe
            if sum(poss_tok)==1
                ambig = 0;
                nat = t; %save non-ambiguous trial number for below
            else
                ambig = 1;
            end
            if ambig == 0 || P(t,3) == 1
                V_tok(t,1:3) = poss_tok/sum(poss_tok);
            else
                if P(t-1,4) == 1 %previous trial is also observe
                    past_val = V_tok(t-1,1:3);
                else
                    past_val = V_tok(t-2,1:3);
                end
                past_val(poss_tok == 0) = 0;
                curr_val = poss_tok/sum(poss_tok) + past_val;
                V_tok(t,1:3) = curr_val/sum(curr_val);
            end
        else %play
            SC = P(t,9); %subject's choice - for simulations, make it correct choice
            %change for actual or generated data

            %calculate probability to choose according to token inference strategy
            AV_1 = V_tok(t-1,1:3)*SM_struct{BU, HO};
            AV_1(UA) = 0;
            PCprev = find(AV_1 == max(AV_1));
            AV_1 = AV_1/sum(AV_1); %normalize action values
            if ~isnan(SC)
                V_tok(t,5) = AV_1(SC); %probability that subject chooses according to token inference
                if SC == PCprev
                    V_tok(t,6) = 1; %choice consistent with token inference strategy
                else
                    V_tok(t,6) = 0; %choice inconsistent with token inference strategy
                end
            else
                V_tok(t,5) = 0.5;
                V_tok(t,6) = 0.5;
            end

            %fill out action (V_act) imitation matrix
            if UA ~= V_act(t-1,1) 
                V_act(t,4) = V_act(t-1,1);
            else
                t1b = find(P(1:t,3)==1); %trial number of first trial of current block
                tr_cb = [(t1b(end):t-2)' V_act(t1b(end):t-2,1)~=UA]; %trial list current block 
                l = find(tr_cb(:,2)==1);
                if ~isempty(l)
                    tr_rep = tr_cb(l(end),1); %number of trial to be repeated
                    V_act(t,4) = V_act(tr_rep,1);
                else
                    V_act(t,4) = 0; %no past evidence to be repeated
                end
            end
            if ~isnan(SC)
                if V_act(t,4)==SC %predicted choice is subject choice
                    V_act(t,5) = 1; %P(action imitation)=1
                else
                    if V_act(t,4)==0 %indifferent
                        V_act(t,5) = 0.5; %P(action imitation)=0.5
                    else
                        V_act(t,5) = 0; %P(action imitation)=0
                    end
                end 
            else
                V_act(t,5) = 0.5; %P(action imitation)=0.5
            end
        end
    end
    EM_pcorr(:,v) = [V_tok(i_1,5);V_tok(i_2,5)];
    IM_pcorr(:,v) = [V_act(i_1,5);V_act(i_2,5)];
end