# Double-pendulum

This repository has been created for the project of the course "Control Systems" with <a href="https://people.epfl.ch/alexandre.schmid">Prof. Alexandre Schmid</a> in BA4. The purpose of the project is to control a double pendulum by stabilizing it in 2 equilibrium positions and rejecting the input disturbance. 

## [Control desciption](Project_brief/Control_Systems_Lab_report.pdf)

### White Box model
The first step is to create a model of the real system using the right parameters. This involves calibrating the model through a Non-Linear Least-Square Optimization process. This helps in comparing and adjusting the model's output data to match the data collected from the real pendulum.

### Equilibrium points
The 2 equilibrium positions chosen are up-up and down-down. This implies of using a linear controller for both positions.

#### Up-Up Position
For this position, the chosen layout for the controller is a LQR (to simplify pole placement) coupled with a Luenberg observer (in order to reconstruct the full state). The design of the controller ended up with the following weights:  
$$ Q=\begin{bmatrix}
10 & 0 & 0 & 0 & 0 \\
0 & 20 & 0 & 0 & 0 \\
0 & 0 & 200 & 0 & 0 \\
0 & 0 & 0 & 110 & 0 \\
0 & 0 & 0 & 0 & 10 \\
\end{bmatrix}, R=350$$
<div style="display: flex; justify-content: center; align-items: center; height: 100vh;">
  <div style="text-align:center;">
    <img src="img/GIF/Up_Up.gif" alt="UPUP" width="200"/>
    <img src="img/LQR_up_up.png" alt="LQR" width="650"/> 
  </div>
</div>

#### Down-Down Position
This position aims to reject input disturbances. The desgin has been achieved by implementing two cascaded PID controllers in series to individually regulate the two variables of the SIMO sytem. The best parameters found so far are listed below: 

$$ P=1, I=0, D=-0.4$$

<div style="display: flex; justify-content: center; align-items: center; height: 100vh;">
  <div style="text-align:center;">
    <img src="img/GIF/Down_Down.gif" alt="DOWNDOWN" width="200"/>
    <img src="img/pid_down_down.png" alt="PID" width="650"/> 
  </div>
</div>

