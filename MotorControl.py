from Motors import *


class MotorControl:
    motorA=None
    motors=[M_28BJY48_ULN2003_RPI()]

        

    def __init__(self,motorName,controllerName,computerName,interfaceDetails,ID=None,extras=None):
        if motorName=='28BJY-48' and controllerName=='ULN2003' and computerName=='RPi-4-B':
            self.motorA=self.motors[0]
            self.motorA.setup(interfaceDetails['GPIOPins'])
        
        
        
        
        
    def runVelocityT(self,degreesPs,Time):
        self.motorA.runVelocityT(degreesPs,Time)
