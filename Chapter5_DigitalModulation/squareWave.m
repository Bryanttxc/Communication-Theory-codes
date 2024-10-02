function wave = squareWave(varargin)
%SQUAREWAVE   Generate square wave
%   WAVE = SQUAREWAVE(codeSequence,period,timeSeries)
%   1. timeSeries: time series, e.g. 0:0.01:10 means from 0s to 10s, the
%      interval is 0.01s.
%   2. codeSequence: code sequence according the type of code.
%   3. period: length of a signal
%
%   WAVE = SQUAREWAVE(codeSequence,period,timeSeries,codeWidth)
%   4. codeWidth: width of code

% check for input parameters
narginchk(3,4);
nargoutchk(0,1);

codeSequence = varargin{1};
period = varargin{2};
timeSeries = varargin{3};

varLen = length(varargin);
if varLen == 4 % the fourth input is codeWidth
    codeWidth = varargin{varLen};
else
    codeWidth = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initial setup
[~,codeLen] = size(codeSequence);
startTime = timeSeries(1);
endTime = timeSeries(end);

waveNum = endTime / period;
if waveNum < codeLen
    % num of wave should not lower than column
    error("The length of time series is not enough");
else
    repeatCount = ceil(waveNum / codeLen); % the repeat num of the whole code sequence
end

% generate square wave
timeLen = length(timeSeries);
wave = zeros(1,timeLen);
start = startTime;
for p = 1:repeatCount
    for q = 1:codeLen
        % update the end index
        over = start + period;
        if(over > timeSeries(end))
            % arrive at the end of timeSeries
            wave(timeSeries >= start & timeSeries < start + codeWidth) = codeSequence(q);
            break;
        else
            wave(timeSeries >= start & timeSeries < start + codeWidth) = codeSequence(q);
        end
        % update the start index
        start = over;
    end
end

end