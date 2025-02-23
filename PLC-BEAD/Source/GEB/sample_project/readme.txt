This is a sample project, included in GEB IDE for demonstration purposes.
It can be safely deleted, including this file. 

This project is designed for running with the WIN_LOCAL pseudo device.
When running-debugging the application (not in simulation mode), what is run is 
a Windows binary console program - (and the mapped variables correspond to files)

It includes several POU (programming unit files) in IEC 61131-3 languages:
 - prog1.st: a program in ST textual language; it calls another user define function in ST (func1.st)
 - proj2ld.fbd: a simple program in LD (Ladder) graphical language
 - semaphore.fbd: a more complex program in FBD (Fuction Block Diagram) graphical language

GEB Automation IDE allows you to compile ("build") the whole project and either
  1. run/debug it (the whole set of programs, or a single selected program) in the Simulator
  2. generate the C code, compile it to binary and run/debug it (the whole set of programs, 
     or a single selected program) in the selected target device
     
To run/debug using the Simulator:
 - First build the project (Ctrl-B, or Menu ->  Project -> Build project )
   IEC 61131-3 compilation errors and warnings will be shown in the "Problems" view, at the bottom.
 - To run: 
   -- Select the project, right click and "Run as -> GEB simulator" 
   -- You can use an existing/autocreated "Run configuration", modify it, duplicate it, etc.
   -- The configuration allows you to set several parameters. Select "show variables" to see the values
      of the program variables when the execution ends. 
 - To debug: 
   -- Before launching, after building, you can set breakpoints in  textual pous (click on the left of the line)
      or in graphical pous (right click on the node, select "Toggle breakpoint")
   -- Select the project, right click and "Debug as -> GEB simulator" 
   -- The same configurations are used - eventually with more parameters. 
   -- The "Debug IEC 61131" perspective should open automatically when debugging. This lets you 
      debug (step, resume, pause), see variables values, watch links states in graphical pous,
      and watch values of IO variables (and, in the Simulator, set inputs).

Hint: Simulate the "semaphore" program, setting 
   Times to run=0 (infinite loop)
   Cycle duration=200ms
While running in debug mode (no breakpoints, no stepping) try toggling the inputs in the IOVars view.
Try turning on the internal barrier (SI, bottom), then turning on the externa barrier (SE, top),
(then turning off them in the same sequence). The output light should turn on during 5 seconds.

To run/debug using the generated binary, the procedure is similar, except that:
  - You must select a target "device" (this can be done via project properties, or in the run configuration dialog).
     For this example, you should select the default "WIN_LOCAL" pseudo device (it generates a windows console program
     to be executed in the local machine)
     Some devices might need additional configuration or environment preparation.
  - You can explicitly invoke (via the menu or or toolbar) the following preliminary steps
   (this is not necessary, it's automatically done when runnning the application)
   -- Generate C code
   -- Compile binary
   -- Transfer binary (not needed for this device)
  - To run (debug) the binary, you select "Run as/Debug as -> GEB application" 
  - While debugging in this mode, the IO variables are not simulated, (they are the real hardware IO) 
    hence they cannot be modified in the "IO variables" view
    A script is provided to simulate the effect of the IO vars changing (run set_inputs_semaphore.bat)


   
 

  
     

