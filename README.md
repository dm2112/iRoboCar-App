# iRoboCar-App
This app was designed as the companion control system for iRoboCar - a senior design project (CU-Boulder 2019).
There are four modes: Discover, Adventure, Programming, and Education.

Discover mode allows users to control iRoboCar with two joysticks. A speed slider determines the maximum speed of the car when the joysticks are pushed to their limits. Bluetooth commands are triggered from the joystick movement and firmware onboard iRoboCar adjusts speed and direction.

Adventure mode is the same as Discover but utilizes iRoboCar's camera to enable video streaming from the car to the app. The video stream is over UDP.

Programming mode allows users to program a path that iRoboCar will follow. Sequential instructions will be carried out after their speed & duration fields have been properly populated.

Education mode is a simple tap-to-learn page where young children and teens can learn about what makes iRoboCar function.

Since the app was designed to work in combination with the physical iRoboCar itself, the app's joysticks will crash since there is no Bluetooth connection if iRoboCar is not nearby. 


