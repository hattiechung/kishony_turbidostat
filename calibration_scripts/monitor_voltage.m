figure(11);
Labels = {'CHL','DOXY','TMP','growth rate'}; %Drug label struct
SecType = 4*ones(1,15); %For i, matches the label of the secondary graph of i to SecType{i}
map = [.662 0.2 0.166; 0.54 0.133 0.36; 0.38 0.12 0.45; 0.29 0.14 0.46; 0.16 0.18 0.47; 0.14 0.25 0.45; 0.12 0.31 0.43; 0.10 0.41 0.40; 0.11 0.48 0.28; 0.27 0.58 0.14; 0.43 0.62 0.15; 0.54 0.65 0.16; 0.67 0.60 0.16; 0.67 0.44 0.16; 0.67 0.16 0.17];%Color for the primary graph.

tmp_0 = zeros(1,15);
Fig = FigCreate(Labels,SecType,tmp_0);

daqreset
ai = analoginput('mcc',0); %This line adds an analog device (USB-1616FS) with ID=1.

channels=addchannel(ai,0:14);%adds a channel, USB1616FS has 16 differential channels (0...15)

blockbg = 500;
durationbg = 1;
sampleRate = 1000;

set(ai,'sampleRate',sampleRate);
set(ai,'SamplesPerTrigger',blockbg*durationbg);


data = zeros(10000,15);
t=0;

while 1
    t = t+1;%t is the counter that's used for decision making
   
    start(ai);%fires the device to acquire ## of data points within each cycle
    rawdata=median(getdata(ai));%we use median of the ##500 data points acquired within 1 second in order to filter noise
    
    data(t,:) = rawdata;
    
    
    if mod(t,1)==0
        for j=1:15
            Fig.chMain{j} = get(Fig.Main{j},'Children');
            Fig.chSec{j} = get(Fig.Sec{j},'Children');
            Fig.MnewY(j) = data(1,j);
            Fig.MnewX(j) = t/3600;
            
            
            Fig.Mmark{j} = 'none';
                
        end
        
        
        for j=1:15
            set(Fig.chMain{j},'XData',[get(Fig.chMain{j},'XData') Fig.MnewX(j)],'YData',[get(Fig.chMain{j},'YData') Fig.MnewY(j)],'Marker',Fig.Mmark{j});
            %set(Fig.chMain{j},'XData',[get(Fig.chMain{j},'XData') Fig.MnewX(j)],'YData',[get(Fig.chMain{j},'YData') Fig.MnewY(j)]);
            %%set(Fig.chSec{j},'XData',[get(Fig.chSec{j},'XData') Fig.SnewX(j)],'YData',[get(Fig.chSec{j},'YData') Fig.SnewY(j)],'Color',Fig.SnewC{j},'Marker',Fig.Smark{j});
            %set(Fig.chSec{j},'XData',[get(Fig.chSec{j},'XData') Fig.SnewX(j)],'YData',[get(Fig.chSec{j},'YData') Fig.SnewY(j)]);
        end
        
        drawnow;
    end
end