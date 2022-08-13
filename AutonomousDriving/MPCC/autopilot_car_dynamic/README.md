# How to run the simulation

run init_car_dynamic.m

run car_sim.slx

modify the controller and trajectory strategy to finish the track ASAP !!

# Tips

1.  The car should drive between the left lane and right lane, no crash is permitted.
2.  The car can change longitudinal velocity anytime anywhere.
3.  The car doesn't have to follow the center line, you can build a smarter path/trajectory strategy to finish the track ASAP. (you can refer to: <https://github.com/alexliniger/MPCC> ) (you have known the whole track information, maybe, you can optimize the trajectory altogether).
4.  out.tout(end) shows the track finish time
5.  The original controller and trajectory are implemented in init_car_dynamic.m, you can create new files and use new methods to replace the original planning and control algorithm.

![](https://img.enderfga.cn/img/road.png)

![](<https://img.enderfga.cn/img/finish%20time.png>)

# Submission rules

1.  Use git to pull the code (https://github.com/SYSU-HI-LAB/Fundamentals-of-autopilot-project), commit the modification, and deliver the whole code package.
2.  Write the report and detail the key modification and track finish time. (less than 3 pages)
