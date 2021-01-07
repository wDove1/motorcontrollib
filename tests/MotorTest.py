#modified for compatability with new motor1 class
import threading
import time
import queue
from motorcontrollib import M_28BJY48_ULN2003_RPI

import queue


M1=M_28BJY48_ULN2003_RPI(stepPins=[17,22,23,24],maxSpeed=67.5,minWaitTime=0.0012)

#t1=time.time()
#M1.runDisplacement(360)
#t2=time.time()
#print(t2-t1)

#t1=time.time()
#M1.runVelocityT(65,0)
#t2=time.time()
#print(t2-t1)

t1=time.time()
M1.runVelocityD(60,720)
t2=time.time()
t=t2-t1
print(720/t)
