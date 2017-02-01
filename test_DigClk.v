`timescale 1s / 1s
module test_DigClk;

reg clk; //Clock is input
reg switch; //Input for 12- or 24-hour

//Set time
reg[5:0] setMin;
reg[4:0] setHrs;
reg [5:0]alarmmin;
reg [4:0]alarmhr;
reg snooze;
reg alarmPM,alarmAM;
reg setAM,setPM,setTime;

//Output clock
wire[5:0] min;
wire[4:0] hrs;
wire AM;
wire PM;

//Instantiate in Unit Under Test
Advanced_DigitalClock_2 uut (
.AM(AM),
.PM(PM),
.min(min),
.hrs(hrs),
.clk(clk),
.switch(switch),
.setAM(setAM),
.setPM(setPM),
.setMin(setMin),
.setHrs(setHrs),
.setTime(setTime),
.alarmhr(alarmhr),
.alarmmin(alarmmin),.alarmPM(alarmPM),.alarmAM(alarmAM),.snooze(snooze));

initial begin
clk = 0; switch = 0; //Clock is initially 24-hour
alarmmin = 6'd24; alarmhr = 5'd11; alarmPM =1'b0; alarmAM =1'b1;
snooze = 1'b1;
#201 setTime = 1; setMin = 6'b011001; setHrs = 5'b01101; setAM = 0; setPM = 0;
#1 setTime = 0;
#100.5 switch = 1;
end
 
always #0.5 clk = ~clk; //Every .5 second toggle clock

endmodule
