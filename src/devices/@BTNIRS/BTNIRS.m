classdef BTNIRS < handle
    
    properties
        sample_rate;
        isrunning;
    end
    properties( Dependent = true )
        samples_avaliable;
    end
    
    
    properties(Hidden = true)
        laserstate;
        laserpwr;
        detgains;
        usefilter;
        probe;
        serialport;
        cnt;
        
        numsrc=8;
        numdet=8;
        SPbuffersize = 1024; %*1024;   % serial port buffer size 1 meg byte
        WordsPerRecord = 5+64+11; % 2 srcs X 4 dets X 2 sides (=32) + 2.5 Header + 5.5 Trailing ***"16-bitWORDS"
        
        DAQMeasList =table;
        listML1;  % list to hold the instrument to probe mapping
        listML2;
    end
    
    
    methods
        
        function obj=BTNIRS
            obj.isrunning=false;
            obj.sample_rate=10;
            
            in=instrfind;
             for i=1:length(in); fclose(in(i)); end;
            
            %% intialize to the serial port
            if(ispc)
                 answer=inputdlg('Which COM Port?','COM',1,{'1'});
                b = sprintf('%s%s','COM',answer{1});
            else
                b='/dev/cu.Dual-SPP-SerialPort';
            end
            obj.serialport=serial(b);
            
            set(obj.serialport, 'FlowControl', 'none');
            set(obj.serialport, 'BaudRate', 115200);
            set(obj.serialport, 'Parity', 'none');
            set(obj.serialport, 'DataBits', 8);
            set(obj.serialport, 'StopBit', 1);
            set(obj.serialport, 'Timeout',10);           
           % set(obj.serialport,'byteorder','littleendian');



            
            set(obj.serialport, 'InputBufferSize',obj.SPbuffersize); %number of bytes in input buffer
            fopen(obj.serialport);
            
            % make sure all the default settings are ok
            obj.laserstate=false(obj.numsrc,1);
            obj.laserpwr=ones(obj.numsrc,1);
            obj.detgains=ones(obj.numdet,1);
            %% 
            
            for i=1:obj.numsrc
                obj.setLaserState(i,obj.laserstate(i));
                obj.setSrcPower(i,obj.laserpwr(i));
            end
            %% 
            for i=1:obj.numdet
                obj.setDetectorGain(i,obj.detgains(i));
            end
            obj.usefilter=false;
            obj.Setfilter(obj.usefilter);
            
            % order of measurements in data stream
            byte1=[6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 64 66 68]';
            byte2=[7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 41 43 45 47 49 51 53 55 57 59 61 63 65 67 69]';
            
            %probe type4
            source    =[1 3 1 3 2 4 2 4 1 3 1 3 2 4 2 4 1 3 1 3 2 4 2 4 NaN NaN NaN NaN NaN NaN NaN NaN]';
            detector=  [1 5 1 5 1 5 1 5 3 7 3 7 3 7 3 7 2 6 2 6 4 8 4 8 NaN NaN NaN NaN NaN NaN NaN NaN]';
            type=      [1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 NaN NaN NaN NaN NaN NaN NaN NaN]';
            type(type==1)=730; type(type==2)=850;
            obj.DAQMeasList=table(source,detector,type,byte1,byte2);
        end
        
        %% laser states
        function obj=setLaserState(obj,lIdx,state)
            if(lIdx<1 || lIdx>obj.numsrc)
                return
            end
            %init LEDs
            if(~islogical(state))
                state=(state==1);
            end
            
            fprintf(obj.serialport, sprintf('SSO %d %d\r',lIdx, 1*(state))); %not state is a bool
            obj.laserstate(lIdx)=state;
            pause(0.1);
        end
        
        %% laser powers
        
        function obj = setSrcPower(obj,sIdx,pwr)
            if(sIdx<1 || sIdx>obj.numsrc)
                return
            end
            pwr=max(min(pwr,127),1);  % must be between 1-100
            fprintf(obj.serialport, sprintf('SLE %d %2d\r',sIdx,pwr));%\n
            obj.laserpwr(sIdx)=pwr;
            pause(0.1);
            
        end
        
        %% detector gains
        function obj=setDetectorGain(obj,dIdx,gain)
            if(dIdx<1 || dIdx>obj.numdet)
                return
            end
            gain=max(min(gain,127),1);  % must be between 1-127
            fprintf(obj.serialport, sprintf('SDG %d %2d\r',dIdx,gain));%\n
            obj.detgains(dIdx)=gain;
            pause(0.1);
        end
        
        %% set filter
        function obj = Setfilter(obj,state)
            if(~islogical(state))
                state=(state==1);
            end
            fprintf(obj.serialport, sprintf('SFT %d\r',1*(state)));%\n
            obj.usefilter=state;
        end
        
        %% START ACQ
        function obj = Start(obj)
            obj.isrunning=true;
            obj.cnt=0;
            flushinput(obj.serialport);
            fprintf(obj.serialport, sprintf('RUN\r'));%\n
            pause(0.25); %v1.3 rcd-added 01/10/2017
            
        end
        
        %% STOP ACQ
        function obj= Stop(obj);
            obj.isrunning=false;
            fprintf(obj.serialport, sprintf('STP\r'));  %sprintf('STP \r\n '))\n
            
        end
        
        
        function n = get.samples_avaliable(obj)
            n=floor(get(obj.serialport,'BytesAvailable')/obj.WordsPerRecord);
        end
        
        
        %% set the probe
        function obj = sendMLinfo(obj,probe)
            % for consistency with the other instruments, the measurement
            % channel reordering is handled inside the device class.  This
            % sets the probe to measurement info
            
            obj.probe=probe;
            [obj.listML1,obj.listML2]=ismember(probe.link,obj.DAQMeasList(:,1:3));
            
        end
        
        
        
        function [d,t]=get_samples(obj,nsamples)
            if(nargin==1)
                nsamples=1;
            end
            nsamples=min(nsamples,obj.samples_avaliable);
            
            
            d=nan(nsamples,length(obj.listML1));
            
            for i=1:nsamples
%                 startpack = dec2hex(256*fread(obj.serialport, 1, 'uint8')+fread(obj.serialport, 1, 'uint8'));  % should be A0A2
%                 SeqNum = fread(obj.serialport, 1, 'uint8');
%                 LenPack = 256*fread(obj.serialport, 1, 'uint8')+fread(obj.serialport, 1, 'uint8');
%                 nsamp = (LenPack - 16)/64;
%                 NIRSdata = fread(obj.serialport, 64*nsamp, 'char');
%                 Bat= fread(obj.serialport, 1, 'uint8');
%                 Temp = fread(obj.serialport, 1, 'char');
%                 Reserve = fread(obj.serialport, 1, 'uint8');
%                 Reserve = fread(obj.serialport, 1, 'uint8');
%                 AccX = fread(obj.serialport, 1, 'uint8');
%                 AccY = fread(obj.serialport, 1, 'uint8');
%                 AccZ = fread(obj.serialport, 1, 'uint8');
%                 CRC = 256*fread(obj.serialport, 1, 'uint8')+fread(obj.serialport, 1, 'uint8');
%                 endpack = dec2hex(256*fread(obj.serialport, 1, 'uint8')+fread(obj.serialport, 1, 'uint8'));  % should be B0B3
%                 bkey=[0 10 20 30 40 50 55 60 65 70 75 80 85 90 95 100];
%                 bat = dec2bin(Bat);
%                 stim = bin2dec(bat(5:end));
%                 bat = bkey(bin2dec(bat(1:4))+1);             
%                 d(i,1:32)=NIRSdata(1:2:end)+256*NIRSdata(2:2:end);
                
                  a =   fread(obj.serialport, 80, 'char');
                  d(i,obj.listML1) = a(obj.DAQMeasList.byte1(obj.listML2))*256+a(obj.DAQMeasList.byte2(obj.listML2));  
                  

            end
            % note any measurement requested in the probe but not possible
            % with this system will stay an NaN
            t=(obj.cnt+[1:nsamples]')/obj.sample_rate;
            obj.cnt=obj.cnt+nsamples;
            
        end
        
    end
end
