from Motors import *


class MotorControl:
    motorA=None
    motors=[M_28BJY48_ULN2003_RPI(),M_Virtual]

        

    def __init__(self,motorName,controllerName,computerName,interfaceDetails,ID=None,extras=None):
        if motorName=='28BJY-48' and controllerName=='ULN2003' and computerName=='RPi-4-B':
            self.motorA=self.motors[0]
            self.motorA.setup(interfaceDetails['GPIOPins'])

        if motorName=='virtual' and controllerName=='virtual' and computerName=='virtual':
            self.motorA==self.motors[1]
            self.motorA.setup()
        
        
        
        
        
    def runVelocityT(self,degreesPs,Time):
        self.motorA.runVelocityT(degreesPs,Time)



    
