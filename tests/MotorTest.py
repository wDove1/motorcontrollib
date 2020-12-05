from motorcontrollib import Motor
#from MotorControl import Motors

M=Motor('28BJY-48','ULN2003','RPi-4-B',{'GPIOPins':[17,22,23,24]})
M.runVelocityT(40,5)
