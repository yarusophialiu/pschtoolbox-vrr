% Initialize Psychtoolbox
try
    % Set to debug level 3 (less verbose) and high precision timing
    Screen('Preference', 'VisualDebugLevel', 3);
    Screen('Preference', 'SkipSyncTests', 1);  % Skip sync tests for simplicity, remove this for actual experiments

    % Open a full-screen window
    screenID = max(Screen('Screens'));  % Select the screen (main or secondary)
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
    
    % Enable VRR
    PsychVRR('SetVRR', window, 1);  % Enable VRR mode
    
    % Define different frame durations (in seconds)
    frameRates = [30, 60, 90, 120];  % Frame rates in Hz
    frameDurations = 1 ./ frameRates;  % Frame durations in seconds (1/frameRate)

    % Initialize vbl for time tracking
    previousVBL = Screen('Flip', window);  % Initial flip to set up timing

    % Run the animation with changing frame rates
    for i = 1:300
        % Simple flicker stimulus, alternating frames between white and black
        if mod(i, 2) == 0
            Screen('FillRect', window, [255 255 255]);  % White frame
        else
            Screen('FillRect', window, [0 0 0]);  % Black frame
        end
        
        % Flip the screen and show the stimulus
        vbl = Screen('Flip', window);

        % Calculate and display the time between flips
        timeBetweenFlips = vbl - previousVBL;  % Time between the current and previous flip
        disp(['Time between frames: ', num2str(timeBetweenFlips), ' seconds\n']);
        previousVBL = vbl;
        
        % Choose a random frame rate for each frame to simulate variable refresh rate
        frameDuration = frameDurations(randi(length(frameDurations)));  % Random frame duration
        disp(['Displaying frame at approximately ', num2str(1/frameDuration), ' Hz']);

        % Draw the next stimulus (this ensures something new is drawn before the next flip)
        if mod(i, 2) == 0
            Screen('FillRect', window, [0 0 0]);  % Black frame
        else
            Screen('FillRect', window, [255 255 255]);  % White frame
        end
        
        
        % Wait for the next flip based on the randomly selected frame rate
        Screen('Flip', window, vbl + frameDuration);
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
