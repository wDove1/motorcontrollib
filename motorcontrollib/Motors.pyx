# distutils: language=c++
import time as t
import sys
import warnings
import RPi.GPIO as GPIO
import numpy
class MotorTemplate:
    """A template class for other motorcontrol classes"""
    maxSpeed: float = 0.0
    relativeDisplacement: float = 0.0
    
    def runDisplacement(self,degrees: float):
        pass

    def runVelocityD(self,degreesPs: float ,distance: float):
        pass

    def runVelocityT(self,degreesPs: float ,time: float):
        pass
 
    def getMaxSpeed(self):
        return self.maxSpeed 

    
    def setMaxSpeed(self,maxSpeed):
        self.maxSpeed=maxSpeed

    def getRelativePosition(self):
        return self.relativeDisplacment

    def resetRelativeDispacement(self):
        self.relativeDisplacement=0


class M_28BJY48_ULN2003_RPI(MotorTemplate):
    """A class to control the 28BYJ48 and ULN2003 motor
    Attributes: 
        motorDetails: A dictionary of specs
        sequence: The sequence the motor runs through
        maxSpeed: The max speed the motor can operate at
        maxWaitTime: The minimum time the motor can run stably at-needs renaming
        stepPins: The GPIO pins the motor will output on
    """
    #cdef:
    #    float x
    motorDetails: dict = {'motorName':'28BJY-48','controllerName':'ULN2003','voltage':5,'baseAngle':0.087890625,'useAngle1':0.703125,'useAngle2':0.3515625}#defines the details of the motor

    #sequence:list = [[1,0,0,1],[1,0,0,0],[1,1,0,0],[0,1,0,0],[0,1,1,0],[0,0,1,0],[0,0,1,1],[0,0,0,1]]
    maxSpeed: float = 48.0 #approximate experimental value
    minWaitTime: float = 0.0016#defines the corresponding minimum wait time
    stepPins=None

    def __init__(self,stepPins,maxSpeed=None,minWaitTime=None):
        import RPi.GPIO as GPIO
        warnings.warn('this class does not support high precision or realtime operation')
        
        if maxSpeed!=None:#checks defaults are not being used
            if isinstance(maxSpeed,(float,int)):#checks if maxSpeed is of type float or int as both must be checked for
                if maxSpeed>0:#checks the speed is positive
                    self.maxSpeed=maxSpeed#sets the speed
                else:
                    raise ValueError("maxSpeed must be greater than 0")#raises errors
            else:
                raise ValueError("maxSpeed must be float,int")

        if minWaitTime!=None:
            if isinstance(minWaitTime,(float,int)):
                if minWaitTime>0:
                    self.minWaitTime=minWaitTime
                else:
                    raise ValueError("minWaitTime must be greater than 0")
            else:
                raise ValueError("minWaitTime must be float,int")           
        
        # Use BCM GPIO references
        # instead of physical pin numbers
        GPIO.setmode(GPIO.BCM)
        # Define GPIO signals to use
        # Physical pins 11,15,16,18
        # GPIO17,GPIO22,GPIO23,GPIO24
        if not checkGPIOPins(stepPins):#checks if the pins are invalid
            raise ValueError("incorrect pins")#raises error
        self.stepPins = stepPins#assigns the pins
        
            
        # Set all pins as output
        for pin in self.stepPins:
            #print("Setup pins")
            GPIO.setup(pin,GPIO.OUT)#sets the pins as outputs
            GPIO.output(pin, False)
            

    def motor(self, float steps, float additionalWaitTime=0):
        """Runs the motor
        Args:
            steps: The number of steps the motor will turn
            additionalWaitTime: Used to slow down the motors


        """
        cdef int stepCount, stepDir, x, stepCounter, n #defines integer variables
        
        sequence = [[1,0,0,1],[1,0,0,0],[1,1,0,0],[0,1,0,0],[0,1,1,0],[0,0,1,0],[0,0,1,1],[0,0,0,1]]#defines the sequence


        stepCount = 8
        if steps<0:
            stepDir=-1#sets if the step direction is positive or negative
        else:
            stepDir=1

        x=round(steps)#the number of steps must always be a positive integer
        if x<=0:
            x=-x#must always be positive

        stepCounter = 0
        for i in range(0,x):#loops through the number of movements
            for n in range(0,4):
                currentPin = self.stepPins[n]
                if sequence[stepCounter][n]==1:
                    GPIO.output(currentPin,True)
                else:
                    GPIO.output(currentPin,False)

            stepCounter += stepDir

            if (stepCounter==stepCount):#goes back to the the start of the loop
                stepCounter = 0
                
            if (stepCounter<0):#goes to the end of the loop
                stepCounter = 7

            t.sleep(self.minWaitTime+additionalWaitTime)#delays the next movement
            

    def runDisplacement(self,degrees):
        """A method to run a set distance
        Args:
            distance:The angle to travel
        """
        if not isinstance(degrees,(float,int)):#checks the type of degrees
            raise ValueError("degrees must be float,int")
        steps=self.convertDegrees(degrees)
        #print(steps)
        self.motor(steps)
        
    
    def runVelocityD(self,degreesPs,distance):
        """A method to run at a set speed for a set distance
        Args:
            degreesPs:The angular velocity
            distance:The distance to run for
        """
        #checks the type of the variables
        if not isinstance(degreesPs,(float,int)):
            raise ValueError("degreesPs must be int,float")
        if not isinstance(distance,(float,int)):
            raise ValueError("distance must be int,float")
        #checks the variables are in range
        if degreesPs==0 or distance==0:
            raise ValueError('No zero values aloud')
        if degreesPs > self.maxSpeed or degreesPs < -self.maxSpeed:
            raise ValueError('Velocity to high')
        if distance<0:
            raise ValueError("distance must be positive")
        minTime=distance/self.maxSpeed#calculates the minimum time the motor can finish the rotation
        neededTime=distance/degreesPs#calculates the required time to run
        additionalWaitTime=(neededTime-minTime)/self.convertDegrees(distance)#calculates the differece in times and splits it so it is added across wait times
        if additionalWaitTime<0:#additionalWaitTime must be psoitive
            additionalWaitTime=-additionalWaitTime       
        self.motor(self.convertDegrees(distance),additionalWaitTime)#runs the motor


    def runVelocityT(self,degreesPs,time):#useful for time limited running in main program
        """A method to run at a set speed for a set time
        Args:
            degreesPs: The angular velocity
            time: The run time
        Todo:
            investigate what happens when there is a misalignment between wait time and speed
        """
        #print(self.maxSpeed)
        #print(degreesPs)
        if not isinstance(degreesPs,(float,int)):
            raise ValueError("degreesPs must be int,float")
        if not isinstance(time,(float,int)):
            raise ValueError("time must be int,float")
        if degreesPs==0 or time==0:
            raise ValueError('No zero values aloud')
        if degreesPs > self.maxSpeed or degreesPs < -self.maxSpeed:
            raise ValueError('Velocity to high')
        if time<0:
            raise ValueError("time must be positive")

        distance=degreesPs*time#calculates the distance
        minTime=distance/self.maxSpeed#calculates the minimum time the motor can finish the rotation
        additionalWaitTime=(time-minTime)/self.convertDegrees(distance)#calculates the differece in times and splits it so it is added across wait times
        if additionalWaitTime<0:
            additionalWaitTime=-additionalWaitTime
        self.motor(self.convertDegrees(distance),additionalWaitTime)#runs the motor
        self.relativeDisplacement+=distance

        

    def convertDegrees(self,float degrees):
        '''convers degrees to steps for internal use within the function'''
        return degrees/self.motorDetails['baseAngle']

    def setMinWaitTime(self,minWaitTime):
        self.minWaitTime=minWaitTime

    def setMaxSpeed(self,maxSpeed):
        self.maxSpeed=maxSpeed


class M_Virtual(MotorTemplate):
    """A virtual Motor to allow the library to be used for testing when a real motor is not available"""
    maxSpeed=48

    def __init__(self):
        pass


    def runVelocityT(self,degreesPs,time):
        """A method to run at a set speed for a set time
        Args:
            degreesPs:The angular velocity
            time:The run time
        """
        t1=t.time()
        print('distance: ',degreesPs*time)
        print('time: ',time)
        print('Velocity: ',degreesPs)
        t2=t.time()
        t.sleep(time-(t2-t1))

    def runVelocityD(self,degreesPs,distance):
        """A method to run at a set speed for a set distance
        Args:
            degreesPs:The angular velocity
            distance:The distance to run for
        """        
        t1=t.time()
        print('distance: ',distance)
        print('time: ',distance/degreesPs)
        print('Velocity: ',degreesPs)
        t2=t.time()
        t.sleep((distance/degreesPs)-(t2-t1))

    def runDisplacement(self,distance):
        """A method to run a set distance
        Args:
            distance:The angle to travel
        """
        t1=t.time()
        print('distance: ',distance)
        print('time: ',distance/self.maxSpeed)
        print('Velocity: ',self.maxSpeed)
        t2=t.time()
        t.sleep((distance/self.maxSpeed)-(t2-t1))

def checkGPIOPins(GPIOPins):
    if isinstance(GPIOPins,list):#checks the type of the data
        if len(GPIOPins)==4:#checks the lists length
            for j in range(4):
                if not isinstance(GPIOPins[j],(float,int)):#checks the type of the data in the list
                    return False
            #checks the uniqueness of the elements
            allUnique=True
            for i in range(4):
                value=GPIOPins[i]
                for n in range(0,4):
                    if n!=i and GPIOPins[n]==value:
                        allUnique=False
            return allUnique
        else:
            return False
    else:
        return False
		
	     
		

