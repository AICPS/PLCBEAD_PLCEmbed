This sample project demonstrates a simple program targeted to run in a Arduino2560 Mega board.

You should compile-run-debug this project using the device "ArduinoMega2560"

To transfer the binary to the device, you need connect the device to this machine
(usually va USB) and identify its pseudo serial port (for example, in the Device Manager).
This data will be filled in the "target adresss" field, in the GEB IDE.

First time setup instructions: 
Check, and if necessary edit, the file setenv.bat in your device dir 
(eg C:\geb3\devices\arduino2560) to point to your AVR8 GNU toolchain,
typically included in your the Arduino Software. 
If, for example, you have installed the Arduino ide at c:\Program Files (x86)\Arduino\arduino.exe
then you would set in setenv.bat :
   set arduino.path=c:\Program Files (x86)\Arduino

This device currently supports binary generation and transfering to the device 
(which automatically triggers running).
It does not currently support run-debug-stop from the IDE.

The mapped variables %IX1.2-53 and %QX1.2-53 correspond respectively to digital inputs and outputs.
So, for example %IX1.6  is the digital input (pin) 6.

See sample circuit in schema.jpg .

  