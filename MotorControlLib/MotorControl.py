from .Motors import *
from .Config import *

class Motor:


    motors=[M_28BJY48_ULN2003_RPI(),M_Virtual()]
    motor=None

    def __init__(self,motorName,controllerName,computerName,interfaceDetails,ID=None,extras=None):
        if motorName=='28BJY-48' and controllerName=='ULN2003' and computerName=='RPi-4-B':
            self.motor=self.motors[0]
            self.motor.setup(interfaceDetails['GPIOPins'])

        if motorName=='virtual' and controllerName=='virtual' and computerName=='virtual':
            self.motor=self.motors[1]
            #self.motorA.setup()



        
        
        
        
        
    def runVelocityT(self,degreesPs,time):
        self.motor.runVelocityT(degreesPs,time)

    def runDisplacement(self,distance):
        self.motor.runDisplacement(distance)

    def runVelocityD(self,degreesPs,Time):
        self.Motor.runVelocityD(degrresPS,time)





    
