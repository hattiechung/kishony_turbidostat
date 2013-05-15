function [ai, relayboxes] = initializemorbidostat()

%Add analog device (USB-1616FS) with ID=1.
ai=analoginput('mcc',0);
%Add channel, USB1616FS has 16 differential channels (0...15)
channels=addchannel(ai,0:14);
%Set sampling rate to 1Khz
set(ai,'SampleRate',100)

%Add digital I/O device (USB-ERB24) with ID=2.
relayboxes.box1 = digitalio('mcc',1);
addline(relayboxes.box1, 0:7,0, 'out');
addline(relayboxes.box1, 0:7,1, 'out');
addline(relayboxes.box1, 0:3,2, 'out');
addline(relayboxes.box1, 0:3,3, 'out');

%Add digital I/O device (USB-ERB24) with ID=2.
relayboxes.box2 = digitalio('mcc',2);
addline(relayboxes.box2, 0:7,0, 'out');
addline(relayboxes.box2, 0:7,1, 'out');
addline(relayboxes.box2, 0:3,2, 'out');
addline(relayboxes.box2, 0:3,3, 'out');

%Set both relayboxes to all zeros.
putvalue(relayboxes.box1.Line(1:24), 0)
putvalue(relayboxes.box2.Line(1:24), 0)

end