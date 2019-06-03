function ioStruct = initIOStruct()
    % hide input to prevent participant from over-writing into the script
%     HideCursor(); 
    ListenChar(2);
    Screen('Preference', 'SkipSyncTests', 1);
    KbName('UnifyKeyNames');
    Screen('Preference', 'ConserveVRAM', 64);
    
    % set up the screen
    ioStruct = struct();
    ioStruct.bgColor = [0 0 0];
    ioStruct.textColor = [200 200 200];
    debugWinSize = [0,0,1000,800];
    fullWinSize = [];
    % run full-screen task
    [ioStruct.wPtr, ioStruct.wPtrRect] = Screen('OpenWindow', 0, ioStruct.bgColor, debugWinSize);
    % activate for alpha blending
    Screen('BlendFunction', ioStruct.wPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    
    % Extract vertical and horizontal center of screen
    ioStruct.centerX = round(ioStruct.wPtrRect(3)/2);
    ioStruct.centerY = round(ioStruct.wPtrRect(4)/2);
    
    % show loading prompt
    Screen('TextFont', ioStruct.wPtr, 'Courier');
    % show the loading screen
    Screen('TextSize', ioStruct.wPtr, 45);
    Screen('TextColor', ioStruct.wPtr, ioStruct.textColor);
    DrawFormattedText(ioStruct.wPtr, 'Loading...', 'center', 'center', [], 70, false, false, 1.1);
    Screen(ioStruct.wPtr, 'Flip');
    
    % stimulus durations
    ioStruct.SLOW = -1;
    ioStruct.MAX_RT = 4;
    ioStruct.FIX_DURATION = 3;
    ioStruct.OBSPLAY_DURATION = 1;
    ioStruct.SM_OBS_DURATION = 2;
    ioStruct.CHOICE_FB_DURATION = 0.5;
    ioStruct.TOKEN_DURATION = 2;
    ioStruct.MISSED_DURATION = 2.5;
    
    % response keys
    ioStruct.respKey_1 = KbName('LeftArrow');
    ioStruct.respKey_2 = KbName('DownArrow');
    ioStruct.respKey_3 = KbName('RightArrow');
    
    % task control keys
    ioStruct.respKey_Quit = KbName('Q');
    ioStruct.respKeyName_Quit = 'Q';
    ioStruct.respKey_Proceed = KbName('P');
    ioStruct.respKeyName_Proceed = 'P';
    
    %%%%%%%%%%%%%%%%%%%%%
    % Define stimuli
    
    % top box
    width = 700; 
    height = 400;
    rect = [0, 0, width, height];
    leftX = ioStruct.centerX - width/2;
    topY = ioStruct.centerY - 130 - height/2;
    ioStruct.TopBox = rect + [leftX, topY, leftX, topY];
    
    % bottom box
    width = 303; 
    height = 230;
    rect = [0, 0, width, height];
    leftX = ioStruct.centerX - round(width/2);
    topY = ioStruct.centerY + 230 - height/2;
    ioStruct.BottomBox = rect + [leftX, topY, leftX, topY];
    
    % slot machines OBS
    width = 161; 
    height = 334;
    rect = [0, 0, width, height];
    topY = ioStruct.centerY - 120 - height/2;  
    leftX = ioStruct.centerX - 250 - round(width/2);
    ioStruct.LeftSMObs = rect + [leftX, topY, leftX, topY];  
    leftX = ioStruct.centerX - round(width/2);
    ioStruct.MidSMObs = rect + [leftX, topY, leftX, topY]; 
    leftX = ioStruct.centerX + 250 - round(width/2);
    ioStruct.RightSMObs = rect + [leftX, topY, leftX, topY];
    
    % movie rectangle
    width = 293; 
    height = 220;
    rect = [0, 0, width, height];
    leftX = ioStruct.centerX - round(width/2);
    topY = ioStruct.centerY + 230 - height/2;  
    ioStruct.MovieBox = rect + [leftX, topY, leftX, topY];  
    
    % slot machines PLAY
    width = 161; 
    height = 334;
    rect = [0, 0, width, height];
    topY = ioStruct.centerY - height/2;  
    leftX = ioStruct.centerX - 250 - round(width/2);
    ioStruct.LeftSMPlay = rect + [leftX, topY, leftX, topY];  
    leftX = ioStruct.centerX - round(width/2);
    ioStruct.MidSMPlay = rect + [leftX, topY, leftX, topY]; 
    leftX = ioStruct.centerX + 250 - round(width/2);
    ioStruct.RightSMPlay = rect + [leftX, topY, leftX, topY];
    
    %token display box
    width = 120; 
    height = 120;
    rect = [0, 0, width, height];
    leftX = ioStruct.centerX - width/2;
    topY = ioStruct.centerY - height/2;  
    ioStruct.TokenBox = rect + [leftX, topY, leftX, topY];  
    
    % load all the images
    imageDir = fullfile('.', 'stimuli');
        
    % token images
    ioStruct.token(1) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'green.jpg')));
    ioStruct.token(2) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'red.jpg')));
    ioStruct.token(3) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'blue.jpg')));
    
    % available slot machine images
    ioStruct.SM.AV.LU.VO1(1) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'G1_lbu_a.jpg')));
    ioStruct.SM.AV.LU.VO1(2) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'R1_lbu_a.jpg')));
    ioStruct.SM.AV.LU.VO1(3) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'B1_lbu_a.jpg')));
    ioStruct.SM.AV.LU.VO2(1) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'G2_lbu_a.jpg')));
    ioStruct.SM.AV.LU.VO2(2) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'R2_lbu_a.jpg')));
    ioStruct.SM.AV.LU.VO2(3) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'B2_lbu_a.jpg')));
    ioStruct.SM.AV.LU.VO3(1) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'G3_lbu_a.jpg')));
    ioStruct.SM.AV.LU.VO3(2) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'R3_lbu_a.jpg')));
    ioStruct.SM.AV.LU.VO3(3) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'B3_lbu_a.jpg')));
    ioStruct.SM.AV.HU.VO1(1) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'G1_hbu_a.jpg')));
    ioStruct.SM.AV.HU.VO1(2) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'R1_hbu_a.jpg')));
    ioStruct.SM.AV.HU.VO1(3) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'B1_hbu_a.jpg')));
    ioStruct.SM.AV.HU.VO2(1) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'G2_hbu_a.jpg')));
    ioStruct.SM.AV.HU.VO2(2) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'R2_hbu_a.jpg')));
    ioStruct.SM.AV.HU.VO2(3) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'B2_hbu_a.jpg')));
    ioStruct.SM.AV.HU.VO3(1) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'G3_hbu_a.jpg')));
    ioStruct.SM.AV.HU.VO3(2) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'R3_hbu_a.jpg')));
    ioStruct.SM.AV.HU.VO3(3) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'B3_hbu_a.jpg')));
    
    % unavailable slot machine images
    ioStruct.SM.UA.LU.VO1(1) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'G1_lbu_ua.jpg')));
    ioStruct.SM.UA.LU.VO1(2) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'R1_lbu_ua.jpg')));
    ioStruct.SM.UA.LU.VO1(3) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'B1_lbu_ua.jpg')));
    ioStruct.SM.UA.LU.VO2(1) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'G2_lbu_ua.jpg')));
    ioStruct.SM.UA.LU.VO2(2) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'R2_lbu_ua.jpg')));
    ioStruct.SM.UA.LU.VO2(3) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'B2_lbu_ua.jpg')));
    ioStruct.SM.UA.LU.VO3(1) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'G3_lbu_ua.jpg')));
    ioStruct.SM.UA.LU.VO3(2) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'R3_lbu_ua.jpg')));
    ioStruct.SM.UA.LU.VO3(3) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'B3_lbu_ua.jpg')));
    ioStruct.SM.UA.HU.VO1(1) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'G1_hbu_ua.jpg')));
    ioStruct.SM.UA.HU.VO1(2) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'R1_hbu_ua.jpg')));
    ioStruct.SM.UA.HU.VO1(3) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'B1_hbu_ua.jpg')));
    ioStruct.SM.UA.HU.VO2(1) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'G2_hbu_ua.jpg')));
    ioStruct.SM.UA.HU.VO2(2) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'R2_hbu_ua.jpg')));
    ioStruct.SM.UA.HU.VO2(3) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'B2_hbu_ua.jpg')));
    ioStruct.SM.UA.HU.VO3(1) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'G3_hbu_ua.jpg')));
    ioStruct.SM.UA.HU.VO3(2) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'R3_hbu_ua.jpg')));
    ioStruct.SM.UA.HU.VO3(3) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'B3_hbu_ua.jpg')));
    
    % chosen slot machine images
    ioStruct.SM.CH.LU.VO1(1) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'G1_lbu_p.jpg')));
    ioStruct.SM.CH.LU.VO1(2) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'R1_lbu_p.jpg')));
    ioStruct.SM.CH.LU.VO1(3) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'B1_lbu_p.jpg')));
    ioStruct.SM.CH.LU.VO2(1) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'G2_lbu_p.jpg')));
    ioStruct.SM.CH.LU.VO2(2) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'R2_lbu_p.jpg')));
    ioStruct.SM.CH.LU.VO2(3) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'B2_lbu_p.jpg')));
    ioStruct.SM.CH.LU.VO3(1) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'G3_lbu_p.jpg')));
    ioStruct.SM.CH.LU.VO3(2) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'R3_lbu_p.jpg')));
    ioStruct.SM.CH.LU.VO3(3) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'B3_lbu_p.jpg')));
    ioStruct.SM.CH.HU.VO1(1) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'G1_hbu_p.jpg')));
    ioStruct.SM.CH.HU.VO1(2) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'R1_hbu_p.jpg')));
    ioStruct.SM.CH.HU.VO1(3) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'B1_hbu_p.jpg')));
    ioStruct.SM.CH.HU.VO2(1) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'G2_hbu_p.jpg')));
    ioStruct.SM.CH.HU.VO2(2) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'R2_hbu_p.jpg')));
    ioStruct.SM.CH.HU.VO2(3) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'B2_hbu_p.jpg')));
    ioStruct.SM.CH.HU.VO3(1) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'G3_hbu_p.jpg')));
    ioStruct.SM.CH.HU.VO3(2) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'R3_hbu_p.jpg')));
    ioStruct.SM.CH.HU.VO3(3) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(imageDir, 'B3_hbu_p.jpg')));
    
    % read video files
    videoDir = fullfile('.', 'videos');
    vidFiles = dir(fullfile(videoDir, '*.mp4'));
    ioStruct.video = struct('vname',cell(length(vidFiles),1),'vdata',cell(length(vidFiles),1));
    for v=1:length(vidFiles)
        vidname = vidFiles(v).name;
        vobj = VideoReader(fullfile(videoDir, vidname));
        nFrames = floor(vobj.Duration * vobj.FrameRate);
        testmov = cell(nFrames,1);
        k = 1; % cmpt
        while hasFrame(vobj)
            tmp = readFrame(vobj);
            testmov{k} = tmp(:,:,:);
            k = k+1;
        end
        ioStruct.video(v).vname = vidname;
        ioStruct.video(v).vdata = testmov;
    end
    
end