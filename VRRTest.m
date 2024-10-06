% VRRTest.m
% A simple test for Variable Refresh Rate (VRR) display using Psychtoolbox
% a simple animation where you change the frame rate throughout
% opening the screen, drawing a rectangle that moves across the screen and 
% changing the frame-rate throughout the animation (just so we know it works)

% Initialize Psychtoolbox
try
    % Set to debug level 3 (less verbose) and high precision timing
    Screen('Preference', 'VisualDebugLevel', 3);
    Screen('Preference', 'SkipSyncTests', 1);  % Skip sync tests for simplicity, remove this for actual experiments

    % Open a full-screen window
    screenID = max(Screen('Screens'));  % Selects the screen (main or secondary)
    fprintf('screenID %s\n', screenID);
    [window, windowRect] = Screen('OpenWindow', screenID, 0);  % Open window with black background
    
    % Check if the display supports VRR
    vrrSupport = PsychVRR('IsVRRAvailable', window);
    disp('vrrSupport');
    disp(vrrSupport);
    
    if vrrSupport
        disp('Variable Refresh Rate is supported by this display.');
    else
        disp('Variable Refresh Rate is NOT supported by this display.');
        Screen('CloseAll');
        return;
    end
    
    % Get current refresh rate
    refreshRate = Screen('FrameRate', window);
    disp(['Current display refresh rate: ', num2str(refreshRate), ' Hz']);
    
    % Enable VRR and test the behavior
    disp('Enabling VRR mode...');
    PsychVRR('SetVRR', window, 1);  % Enable VRR (1 to enable, 0 to disable)
    
    % Run a simple animation test to evaluate VRR
    for i = 1:300
        % Simple flicker stimulus, alternating frames between white and black
        if mod(i, 2) == 0
            Screen('FillRect', window, [255 255 255]);  % White frame
        else
            Screen('FillRect', window, [0 0 0]);  % Black frame
        end
        
        % Flip the screen and show the stimulus
        % first drawn "offscreen." Only after calling Screen('Flip') does the content become visible onscreen.
        % Screen('Flip') ensures that the image is displayed at the exact moment when the monitor starts refreshing its screen
        % vbl is the timestamp (in seconds) when the monitor finished flipping to the new frame
        vbl = Screen('Flip', window);
        
        % Print the time of each flip for performance analysis
        disp(['Frame ', num2str(i), ' at time ', num2str(vbl)]);
        
        % Introduce a small delay between frames to simulate dynamic rendering
        WaitSecs(0.01 + rand * 0.01);  % Random wait to simulate varying render time
    end
    
    % Disable VRR and exit
    disp('Disabling VRR mode...');
    PsychVRR('SetVRR', window, 0);  % Disable VRR
    
    % Close the window and cleanup
    Screen('CloseAll');

catch e
    % Handle errors gracefully
    disp('An error occurred:');
    disp(e.message);
    Screen('CloseAll');
end
