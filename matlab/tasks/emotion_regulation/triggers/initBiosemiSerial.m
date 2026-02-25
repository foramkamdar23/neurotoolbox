function [sp, useLegacySerial] = initBiosemiSerial(portName, baudRate, dataBits, stopBits, parity, lowVal)

sp = [];
useLegacySerial = false;

if exist('serialport','class')
    sp = serialport(portName, baudRate);
    configureTerminator(sp, "none");
    try, sp.DataBits = dataBits; end
    try, sp.StopBits = stopBits; end
    try, sp.Parity   = parity;   end
    write(sp, lowVal, 'uint8');
else
    useLegacySerial = true;
    sp = serial(portName, ...
        'BaudRate',    baudRate, ...
        'DataBits',    dataBits, ...
        'StopBits',    stopBits, ...
        'Parity',      parity, ...
        'FlowControl', 'none');
    fopen(sp);
    fwrite(sp, lowVal);
end
end
