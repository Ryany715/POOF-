//Moves the motors the a user defined poosition in terms of an angle.  The turn of the motor can only be defiend as an angle therefore, if the input is distance
// than a translation in terms of angle needs to be considered.  Intially the code was written in terms on an input, however the arduino has no way to process
// a user input so I commented those out.  The code thats left simply has the user to define the angle of rotation, or if a distance is needed, the user must take in the inout and translate it into an angle
// Thinking of writing a matlab function in order to change this input so that all the user has to do is input the distance and it can output the angle.


//#include "stdio.h" //loads user input
#include <Servo.h> //loads servo library
Servo myservo1;  //creates 3 servo objects for each servo
Servo myservo2;
Servo myservo3;
int pos1 =0;    // intializes 3 positions for the servos, all starting at 0, this is representative of the degress of turn
int pos2=0;
int pos3=0;

void setup() {
  myservo1.attach(A1); // attaches the servos to the needed pins on the arduino. Be sure to attch them to the correct pins, or modify the pins I used 
  myservo2.attach(A2);
    myservo3.attach(A3); 
    myservo1.write(90); // puts the servos at a atrsting postion of 0 degrees in order for the program to operate in the appropriate way, the motors must be returned to the 90 degree postions 
    myservo2.write(90);
    myservo3.write(90);
}
//int main(void)//THE FOLLOWING COMMENTED PORTIONS DONT WORK WITH ARDUINO AS THERE IS NO WAY THE THE USER TO INPUT INTO THE CONTROLLER

  //int x;
  //int y;
  //int z;
  //printf("input x in cm:"); 
  //scanf("%d", &x);
  //printf("input y in cm:");
  //scanf("%d", &y);
  //printf("input z in cm:");
  //scanf("%d", &z);
  //convert from cm to degrees movement needed, need the length of the arm protrusuion to find the distance needed
  int xdeg=90; // operations on the x to transform it, comes from matlab code, run the matlab code in order to find the needed angles in degrees 
  int ydeg=90 ; //these variables will change based on the values output from the matlab code
  int zdeg= 90;

//LETs ASSUME SERVO 1 == X, SERVO 2== Y, SERVO 3 ==Z 

void loop() { 
if (myservo1.read()!= xdeg){    //intializes that if the staring position  is the input, then no movement is needed 
  myservo1.write(xdeg); 
}
if (myservo2.read()!= ydeg){
  myservo2.write(ydeg);
}
if (myservo2.read()!= zdeg){
  myservo3.write(zdeg);
}
}
/////////////////////////////////////////////////


