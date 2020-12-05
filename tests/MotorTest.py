##from motorcontrollib import Motor
###from MotorControl import Motors
##import threading
##
##M=Motor('28BJY-48','ULN2003','RPi-4-B',{'GPIOPins':[17,22,23,24]})
##M=Motor('virtual','virtual','virtual','virtual',{})
##while True:
##
##    M.runVelocityT(40,5)


#modified for compatability with new motor1 class

import threading
import time
from motorcontrollib import Motor
class MotorControl:
    """A class to control the motors operation
    Attributes:
        M1: The first motor (x axis)
        M2: The second motor (y axis)
        timeUnit: How frequently the velocity will be updated etc
        xVelocity: The velocity M1 will run at
        yVelocity: The velocity M2 will run at
        xAcceleration: Currently unused
        yAcceleration: Currently unused
        q: The queue used for transmitting velocity information
    Todo:
        *rename q to dataQueue
        *investigate adding acceleration support
    """
    
    M1=Motor('28BJY-48','ULN2003','RPi-4-B',{'GPIOPins':[17,22,23,24]})
    #M1=Motor('virtual','virtual','virtual',{})
    M2=Motor('virtual','virtual','virtual',{})
    #Config=Config()
    timeUnit: float = 2.0#test value instead of 0.25 for issue with loop
    xVelocity: float = 20
    yVelocity: float = 0
    xAcceleration: float = 0
    yAcceleration: float = 0
    q=None
    




                

    def xMotor(self):
        """The method to control the motor that moves on the x axis
        Args:
            controlQueue: Used for shutting down the program
        """
        while True:
            #print(self.xVelocity)
            if self.xVelocity !=0:
                print('running')#keeps printimng while motor is meant to be running
                self.M1.runVelocityT(self.xVelocity,self.timeUnit)




    def main(self):
        """The main method that starts the threads to allow the motors to run
        Args:
            q:The queue for transmitting velocity data
            controlQueue: Used for shutting down the program
        """


        t2=threading.Thread(target=self.xMotor,args=())

        t2.start()





x=MotorControl()
x.main()
