function Lab9_gui_tank_pid_builtin_fdfwd 
clear;
 a = open_scope('COM3');  %open the serial interface to the scope
 motor_scope(a,0);        %brake the motor 
 dac0out_scope(a,5.0)
 fig1 = figure('CloseRequestFcn',@my_closereq);
% fig1 = figure;
 fig1.Position = [20,100,1150,500];
 fig1.Name = 'GUI PID Tank Height Controller';
 %Add one chart to the figure
 ax1 = axes('Box','on','Units','pixels','Position',[70,180,500,300]);
 ax2 = axes('Box','on','Units','pixels','Position',[630,180,500,300]);
 xlabel(ax1,'Seconds');
 xlabel(ax2,'Seconds');
 ylabel(ax1,'Height cm');
 ylabel(ax2,'Valve Angle Degrees');
 
 %Add a checkbox for PID On/Off
 cb = uicontrol('Parent', fig1,'Style','checkbox');
 cb.Position = [10,100,85,20];
 cb.String = 'Check to Run';  %Write on the check box
 cb.Callback = @cb_Callback;  %Add a function to chart and run servo
 
 %Add a checkbox for Adaptive Control
 cb2 = uicontrol('Parent', fig1,'Style','checkbox');
 cb2.Position = [10,65,100,20];
 cb2.String = 'Feedforward Control';  

 %Add a slider 300x25 pixels Left=120 Bottom=50 Height cm
 sd = uicontrol('Parent', fig1,'Style','slider');
 sd.Position = [100,100,200,20];
 sd.Value = 0;
 sd.Max = 50;     %use slider to set height 0 to 50cm
 sd.Min = 0;
 sd.Callback = @sd_Callback;  %Add a function to update the text value
 tx = uicontrol('Style', 'text'); %Add text for control
 tx.Position = [100,80,200,20];
 tx.String = "Height in cm " + num2str(sd.Value,4);
 
 %Add a slider for Prop gain 
 sd2 = uicontrol('Parent', fig1,'Style','slider');
 sd2.Position = [350,100,200,20];
 sd2.Value = 1200;           %use slider to set gain 0 to 5000  
 sd2.Max = 5000;
 sd2.Min = 0;
 sd2.Callback = @sd2_Callback;  %Add a function to update the text value
 tx2 = uicontrol('Style','text');
 tx2.Position = [350,80,200,20];
 tx2.String = "Prop " + num2str(sd2.Value,4);
 
  %Add a slider for Intg gain
 sd3 = uicontrol('Parent', fig1,'Style','slider');
 sd3.Position = [350,60,200,20];
 sd3.Value = 15;      %use slider to set gain 0 to 200 
 sd3.Max = 200;
 sd3.Min = 0;
 sd3.Callback = @sd3_Callback; 
 tx3 = uicontrol('Style','text');
 tx3.Position = [350,40,200,20];
 tx3.String = "Intg " + num2str(sd3.Value,4);

 %Add a slider for Diff gain
 sd4 = uicontrol('Parent', fig1,'Style','slider');
 sd4.Position = [350,20,200,20];
 sd4.Value = 0;     %use slider to set gain 0 to 10000  
 sd4.Max = 9999;
 sd4.Min = 0;
 sd4.Callback = @sd4_Callback; 
 tx4 = uicontrol('Style','text');
 tx4.Position = [350,0,200,20];
 tx4.String = "Diff " + num2str(sd4.Value,5);
 
 %Add a slider for Intg + limit
 sd6 = uicontrol('Parent', fig1,'Style','slider');
 sd6.Position = [600,100,200,20];
 sd6.Value = 40;  %use slider to set limit 0 to 500
 sd6.Max = 500;
 sd6.Min = 0;
 sd6.Callback = @sd6_Callback; 
 tx6 = uicontrol('Style','text');
 tx6.Position = [600,80,200,20];
 tx6.String = "Integrator +Limit " + num2str(sd6.Value,4);

  %Add a slider for Intg - limit
 sd7 = uicontrol('Parent', fig1,'Style','slider');
 sd7.Position = [600,60,200,20];
 sd7.Value = 40;  %use slider to set limit 0 to 5000
 sd7.Max = 500;
 sd7.Min = 0;
 sd7.Callback = @sd7_Callback; 
 tx7 = uicontrol('Style','text');
 tx7.Position = [600,40,200,20];
 tx7.String = "Integrator -Limit " + num2str(-sd7.Value,4);

  %Add a slider for Controller Offset
 sd8 = uicontrol('Parent', fig1,'Style','slider');
 sd8.Position = [600,20,200,20];
 sd8.Value = 1750;  %use slider to set limit 0 to 2500
 sd8.Max = 2500;
 sd8.Min = 0;
 sd8.Callback = @sd8_Callback; 
 tx8 = uicontrol('Style','text');
 tx8.Position = [600,0,200,20];
 tx8.String = "Offset Degrees " + num2str(sd8.Value,4);

 %Add a slider for Valve Control Loop Gain
 sd9 = uicontrol('Parent', fig1,'Style','slider');
 sd9.Position = [850,100,200,20];
 sd9.Value = 0.01;  %use slider to set limit 0 to 0.1
 sd9.Max = 0.1;
 sd9.Min = 0.0;
 sd9.Callback = @sd9_Callback; 
 tx9 = uicontrol('Style','text');
 tx9.Position = [850,80,200,20];
 tx9.String = "Valve Gain " + num2str(sd9.Value,4);

  %Add a slider for Valve Plus Limit
 sd10 = uicontrol('Parent', fig1,'Style','slider');
 sd10.Position = [850,60,200,20];
 sd10.Value = 2520;  %use slider to set limit 0 to 2880
 sd10.Max = 2880;
 sd10.Min = 0;
 sd10.Callback = @sd10_Callback; 
 tx10 = uicontrol('Style','text');
 tx10.Position = [850,40,200,20];
 tx10.String = "Valve Max Deg " + num2str(sd10.Value,4);

  %Add a slider for Valve minimum limit
 sd11 = uicontrol('Parent', fig1,'Style','slider');
 sd11.Position = [850,20,200,20];
 sd11.Value = 500;  %use slider to set limit 0 to 2880
 sd11.Max = 2880;
 sd11.Min = 0;
 sd11.Callback = @sd11_Callback; 
 tx11 = uicontrol('Style','text');
 tx11.Position = [850,0,200,20];
 tx11.String = "Valve Min Deg " + num2str(sd11.Value,4);
  
  %Add a slider for Valve dead band degrees
 sd12 = uicontrol('Parent', fig1,'Style','slider');
 sd12.Position = [1060,100,80,20];
 sd12.Value = 10;  %use slider to set limit 0 to 100
 sd12.Max = 100;
 sd12.Min = 0;
 sd12.Callback = @sd12_Callback; 
 tx12 = uicontrol('Style','text');
 tx12.Position = [1060,80,80,20];
 tx12.String = "Dead Band " + num2str(sd12.Value,4);

 tx121 = uicontrol('Style','text');
 tx121.Position = [1060,20,80,60];
 tx121.String = num2str(0,2);

 pb = uicontrol('Parent', fig1,'Style','pushbutton');
 pb.Position = [10,30,100,20];
 pb.String = 'Set Valve Zero';               %Write Run on the button
 pb.Callback = @pb_Callback;      %Add a function to do something

 sd9.Value
%Set PID controller values
   sth_scope(a,sd.Value);  %tank height setting
   pro_scope(a,sd2.Value); %proportional gain
   int_scope(a,sd3.Value); %integrator gain
   dif_scope(a,sd4.Value); %differentiator gain
   ipl_scope(a,sd6.Value); %integrator plus limit
   inl_scope(a,sd7.Value); %integrator negative limit
   vml_scope(a,sd10.Value);      %valve max limit in degrees
   vll_scope(a,sd11.Value);       %valve lower limit in degrees
   ofs_scope(a,sd8.Value);      %valve position offset in degrees
   vga_scope(a,sd9.Value);      %valve control loop proportional gain
   vdb_scope(a,sd12.Value);      %valve control dead band in degrees
   ved_scope(a,13.384);      %valve encoder pulses per degree
   psg_scope(a,34.7636);  %pressure sensor gain calibration
   pso_scope(a,89.8811);  %pressure sensor offset calibration
  psg_scope(a,35.4);  %pressure sensor gain calibration
  pso_scope(a,97.70);  %pressure sensor offset calibration
 
 %call back function for the check box
  function cb_Callback(h, eventdata)
   fid = fopen("pid"+ datestr(now,30) +".txt",'w+'); %open file for overwrite data
   fprintf(fid,'%s\n', 'Seconds Command_cm Tank_cm Command_degrees Valve_degrees P I D');
%   tig_scope(a,0.46115); %set tank area normal is 0.115
   motor_scope(a,0.0);    %PWM 0% 
   %clear and allocate arrays for plotting
   clear count2
   count2 = zeros(2000,1); %motor posisiton count
   clear t
   t = zeros(2000,1);   %time in seconds
   clear av
   av = zeros(2000,1);  %analog voltage => water height cm
   clear cmdcm           %commanded position in cm
   cmdcm = zeros(2000,1);              
   clear pcmd           %commanded position in cm
   pcmd = zeros(2000,1);              
   %initialize variables
   p = 0;
   count = 0.0;
   tankcm = 0.0;

   if h.Value == 1  %If box is checked, do continuous ADC sampling
    pid_scope(a,1);   
    tv = tic;       %Mark start time
    while true
                tx121.String = string(rnt_scope(a));
                pause(0.15);         %needed for other buttons interrupting loop
                count = vav_scope(a);           %convert to degrees
                count2(2000) = count;           %save motor count
                t(2000) = toc(tv);              %time per loop is about 200ms
                tankcm = hcm_scope(a);          %read cm
                av(2000) = tankcm;              %save for plotting 
                cmdcm(2000) = sd.Value;         %save cm position command
                pcmd(2000) = cmd_scope(a,0);    %read valve command from PID controller            

            axes(ax1);       %assign plotting to ax1   
            axis([t(1) t(2000) 0 100]);  %force limits on plot
            plot(t,av,t,cmdcm);                   %update plots
            axes(ax2);       %assign plotting to ax1  
            axis([t(1) t(2000) 0 1500]);  %force limits on plot
            plot(t,count2,t,pcmd);
            t(1:1999) = t(2:2000);              %shift data to keepa arrays at 2000  
            cmdcm(1:1999) = cmdcm(2:2000);
            pcmd(1:1999) = pcmd(2:2000);
            av(1:1999) = av(2:2000);
            count2(1:1999) = count2(2:2000);
       
            %save the data to a formatted text file space delimited 
            fprintf(fid,'%4.2f  %3.1f %3.1f %3.1f %3.1f %3.0f %2.0f %2.0f\n', t(2000), cmdcm(2000), av(2000),  pcmd(2000), count2(2000), sd2.Value, sd3.Value, sd4.Value);
                       
      if  h.Value == 0      
       pid_scope(a,0)
       motor_scope(a,0);           %brake the motor
       fclose(fid);
       save ('controller_data','t','av','count2','cmdcm', 'pcmd'); %save as .mat file for last 2000 values
       grid(ax1, 'On');
       grid(ax2, 'On');
       xlabel(ax1,'Seconds');
       xlabel(ax2,'Seconds');
       ylabel(ax1,'Height cm');
       ylabel(ax2,'Valve Angle Degrees');
       break;                     %Exit loop if box gets un-checked
     end    
    end 
   end
 end

 function sd_Callback(h, eventdata)
     tx.String = "Height in cm " + num2str(h.Value,4);
     sth_scope(a,h.Value)
     if cb2.Value == 1
      sd8.Value = h.Value * 14.6 + 1918;
      tx8.String = "Offset Degrees " + num2str(sd8.Value,4);
      ofs_scope(a,sd8.Value)
     end 
 end

 function sd2_Callback(h, eventdata)
     tx2.String = "Prop " + num2str(h.Value,4);
     pro_scope(a,h.Value)
 end  

 function sd3_Callback(h, eventdata)
     tx3.String = "Intg " + num2str(h.Value,4);
     int_scope(a,h.Value)
 end  

 function sd4_Callback(h, eventdata)
     tx4.String = "Diff " + num2str(h.Value,5);
     dif_scope(a,h.Value)
 end  

 function sd6_Callback(h, eventdata)
     tx6.String = "Integrator +Limit " + num2str(h.Value,4);
     ipl_scope(a,h.Value)
 end  

 function sd7_Callback(h, eventdata)
     tx7.String = "Integrator -Limit " + num2str(-h.Value,4);
     inl_scope(a,h.Value)
 end 

 function sd8_Callback(h, eventdata)
     tx8.String = "Offset Degrees " + num2str(h.Value,4);
     ofs_scope(a,h.Value)
 end

 function sd9_Callback(h, eventdata)
     tx9.String = "Valve Gain " + num2str(h.Value,4);
     vga_scope(a,h.Value)
 end 

 function sd10_Callback(h, eventdata)
     tx10.String = "Valve Max Deg " + num2str(h.Value,4);
     vml_scope(a,h.Value)
 end 

 function sd11_Callback(h, eventdata)
     tx11.String = "Valve Min Deg " + num2str(h.Value,4);
     vll_scope(a,h.Value)
 end 

 function sd12_Callback(h, eventdata)
     tx12.String = "Dead Band " + num2str(h.Value,4);
     vdb_scope(a,h.Value)
 end

 function pb_Callback(h, eventdata)
   selection = questdlg('Reset Valve?','','Yes','No','Yes'); 
   switch selection, 
      case 'Yes',
       enczero_scope(a);        %encoder count set to zero
      case 'No'
       return 
   end   
 end

 function my_closereq(src,callbackdata)
   selection = questdlg('Close Controller App?','','Yes','No','Yes'); 
   switch selection, 
      case 'Yes',
         pid_scope(a,0)
         motor_scope(a,0);           %brake the motor
         close_scope(a);           %close the serial file
         clear a;                  %remove the serial handle
         delete(gcf)
      case 'No'
      return 
   end
 end

end