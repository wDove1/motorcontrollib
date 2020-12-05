from .Motors import *
from .Config import *

class Motor:
    """A class to create a motor"""

    motors=[M_28BJY48_ULN2003_RPI(),M_Virtual()]
    motor=None

    def __init__(self,motorName,controllerName,computerName,interfaceDetails,ID=None,extras=None):
        if motorName=='28BJY-48' and controllerName=='ULN2003' and computerName=='RPi-4-B':
            self.motor=self.motors[0]
            self.motor.setup(interfaceDetails['GPIOPins'])

        elif motorName=='virtual' and controllerName=='virtual' and computerName=='virtual':
            self.motor=self.motors[1]
            #self.motorA.setup()



        
        
        
        
        
    def runVelocityT(self,degreesPs,time):
        """A method to run at a set speed for a set time
        Args:
            degreesPs:The angular velocity
            time:The run time
        """
        self.motor.runVelocityT(degreesPs,time)

    def runDisplacement(self,distance):
        """A method to run a set distance
        Args:
            distance:The angle to travel
        """
        self.motor.runDisplacement(distance)

    def runVelocityD(self,degreesPs,distance):
        """A method to run at a set speed for a set distance
        Args:
            degreesPs:The angular velocity
            distance:The distance to run for
        """
        self.Motor.runVelocityD(degreesPS,distance)





    
