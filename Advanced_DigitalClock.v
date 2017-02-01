module Advanced_DigitalClock(AM, PM, min, hrs, clk, switch, setTime, setAM, setPM, setMin, setHrs, alarmhr, alarmmin, alarm, alarmPM, alarmAM, snooze);

input clk;
input switch; //Switch between 12- and 24-hour clock

//User input to set the time/alarm
input wire[5:0] setMin;
input wire[4:0] setHrs;
input wire setAM;
input wire setPM;
input setTime;
input [4:0]alarmhr;
input [5:0]alarmmin;
input alarmPM;
input alarmAM;
input snooze;

output reg[5:0] min;
output reg[4:0] hrs;
output reg AM, PM; //LEDs that will light up for 12-hour clock
output reg alarm;

//Initial time
initial begin
min = 6'b000000;
hrs = 5'b00001;
alarm = 1'b0;
AM = 1'b1;
PM = 1'b0;
end

//Digital Clock
always @(posedge clk) begin
   if(setTime) begin //If setTime is 1, the user will set the time
      min = setMin;
      hrs = setHrs;
      if(switch) begin //If user puts switch to 1 they will set AM/PM
	 AM = setAM;
	 PM = setPM;
      end
      else if(~switch) begin //If user set switch to 0 then AM/PM LEDs are off
	 AM = 0;
	 PM = 0;
      end
   end
   else
   if(switch) begin //If switch is 1, its a 12-hour clock
      if(clk) begin
	 min = min + 1;
	 if(min == 60) begin //When minutes reach 59 reset to 0 and increment hour by 1
	    min = 0;
	    hrs = hrs + 1;
	    if(hrs == 12) begin //When the hour is twelve it'll swtich to PM from AM and vice versa
	       AM = ~AM;
	       PM = ~PM;
	    end
	    else if(hrs == 13) begin //When hour is 12 reset to 1
	       hrs = 1;
	    end
	 end
	 else if (hrs > 12) begin //If when switching from 0 to 1 hours is greater than 12
	    hrs = hrs - 12;       //Subtract 12 from the number to get the value for 12-hour clock
	    PM = 1;
	 end
      end
 // alarm for 12h -----------------------------------------------------------------------------------------
      if((min == alarmmin)&&(hrs==alarmhr)&&(alarmPM==1)&&(PM==1))begin // alarm for PM clock
	 alarm = 1;
      end
      else if((min == alarmmin)&&(hrs==alarmhr)&&(alarmAM==1)&&(AM==1))begin // alarm for AM clock
	 alarm = 1;
      end
      if((alarm==1)&&(min == alarmmin+1)&&(hrs==alarmhr))begin //after one minute stop the alarm
	 alarm = 0;
      end  

//snooze the alarm after 10min  -------------------------------------------------------------------------------
      if((snooze==1)&&(min == alarmmin+10)&&(hrs==alarmhr)&&(alarmPM==1)&&(PM==1))begin // snooze for one condiion
	 alarm = 1;
      end
      else if((snooze==1)&&(min == alarmmin+10)&&(hrs==alarmhr)&&(alarmAM==1)&&(AM==1))begin // snooze for another condtition
 	 alarm = 1;
      end
      if((alarm==1)&&(min == alarmmin+11)&&(hrs==alarmhr))begin //after one minute stop the alarm
	 alarm = 0;
      end  
   end
   else if(~switch) begin //If switch is 0, its a 24-hour clock
      if(clk) begin
	 min = min + 1;
	 if(min == 60) begin //When minutes reach 59 reset to 0 and increment hour by 1
	    min = 0;
	    hrs = hrs + 1;
	    if(hrs == 24) begin //When hour is 23 reset to 0
	       hrs = 0;
	    end
	 end
	 else if(PM == 1) begin //When switching from 12-hour clock, if it is PM then 12 must be added
	    hrs = hrs + 12;     //to the hours to remain the same time b/w 12- 24-hour clocks.
	    PM = 0; //Turn of AM/PM LEDs
	    AM = 0;
	 end
	 else if(AM == 1) begin //If switching from 12-hour and it is AM, the hour will be the same
	    hrs = hrs;		 //in 24-hour. Turn off AM/PM LEDs
	    AM = 0;
	    PM = 0;
	 end
      end
   //alarm for 24h -----------------------------------------------------------------------------------------
      if((min == alarmmin)&&(hrs==alarmhr))begin
	 alarm = 1;
      end
      if((min == alarmmin+1)&&(hrs==alarmhr))begin //after one minute stop the alarm
	 alarm = 0;
      end
// snooze the alarm ---------------------------------------------------------------------------
      if((snooze==1)&&(min == alarmmin+10)&&(hrs==alarmhr))begin // snooze for 24 hr
	 alarm = 1;
      end
      if((min == alarmmin+11)&&(hrs==alarmhr))begin //after one minute stop the alarm
	 alarm = 0;
      end
  //-----------------------------------------------------------------------------------------------------------
   end
end

endmodule
