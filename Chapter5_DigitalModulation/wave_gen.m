function wave = wave_gen(varargin)
%WAVE_GEN   Generate waveform.
%   WAVE = WAVE_GEN(binarySequence,type,rate,timeSeries)
%   1. binarySequence: binary sequence, vector, e.g. [1 0 0 1 0 1].
%   2. type: the type of the code, e.g.
%      'unipolar_nrz','unipolar_rz','polar_nrz','polar_rz','Manchester code'.
%   3. rate: symbol rate, note that byte/s == bit/s in binary.
%   4. timeSeries: time series, e.g. 0:0.01:10 means from 0s to 10s, the
%      interval is 0.01s.
%  
%   WAVE = WAVE_GEN(binarySequence,type,rate,timeSeries,dutyCycle)
%   5. dutyCycle: the fraction of one period in which a signal or system is
%      active. e.g. dutyCycle = PW / T, where PW denotes as pulse_width and
%      T denotes as the total period of the signal.
%   Return-Zero code (_rz) must add this input parameter.

% check for input parameters
narginchk(4,5);
nargoutchk(0,1);

binarySequence = varargin{1};
type = varargin{2};
rate = varargin{3};
timeSeries = varargin{4};

% check for the data type of input
if ~isa(binarySequence,'numeric')
    error("The first input is not vaild.")
elseif ~isa(type,'char') && ~isa(type,'string')
    error("The second input is not vaild.");
elseif length(rate) ~= 1 || rate < 0 || ~isa(rate,'numeric') 
    error("The third input is not vaild.");
elseif ~isa(timeSeries,'numeric')
    error("The fourth input is not vaild.");
end

% check for size and elements of binarySequence
[row,codeLen] = size(binarySequence);
if row ~= 1
    error("Input of binary sequence must be a vector.");
elseif ~isempty(find(binarySequence ~= 0 & binarySequence ~= 1,1))
    error("The input sequence must be binary codes");
end

% check for the code type, only support the type in the following array
codeType = ["unipolar_nrz","unipolar_rz","polar_nrz","polar_rz","Manchester_code"];
typeIndex = 0;
for p = 1:length(codeType)
   if strcmpi(type,codeType(p))
        typeIndex = p;
   end
end
if typeIndex == 0
    error("Please input the right code type.");
end

% the fifth input is duty cycle
varLen = length(varargin);
if varLen == 5 
    if ~isa(varargin{varLen},'numeric')
        error("The fifth input is not vaild.");
    end
    if typeIndex == 2 || typeIndex == 4 || varargin{varLen} == 1
        dutyCycle = varargin{varLen};
    else
        error("The code type don't have duty cycle except for return-zero code.")
    end
else
    if typeIndex == 2 || typeIndex == 4 % "_rz" should input duty cycle
        error("Return-zero code should input duty cycle.")
    else
        dutyCycle = 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initial setup
period = 1 / rate; % T = 1/Rb, ms
if typeIndex >= 1 && typeIndex <= 4
    % (uni)polar_(n)rz
    codeSequence = binarySequence;
    if typeIndex == 3 || typeIndex == 4 % polar_nrz / polar_rz
        codeSequence(codeSequence == 0) = -1;
    end
else
    % Manchester_code
    codeSequence = zeros(codeLen,2);
    for p = 1:codeLen
        if binarySequence(p) == 0
            codeSequence(p,1) = -1;
            codeSequence(p,2) = 1;
        else
            codeSequence(p,1) = 1;
            codeSequence(p,2) = -1;
        end
    end
    codeSequence = reshape(codeSequence',1,[]);
    period = period / 2;
end
tau = dutyCycle * period; % width of code

% generate square wave
wave = squareWave(codeSequence, period, timeSeries, tau);
end
