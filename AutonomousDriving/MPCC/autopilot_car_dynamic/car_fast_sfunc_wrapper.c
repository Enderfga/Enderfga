
/*
 * Include Files
 *
 */
#if defined(MATLAB_MEX_FILE)
#include "tmwtypes.h"
#include "simstruc_types.h"
#else
#include "rtwtypes.h"
#endif



/* %%%-SFUNWIZ_wrapper_includes_Changes_BEGIN --- EDIT HERE TO _END */
#include <math.h>
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 8
#define y_width 1

/*
 * Create external references here.  
 *
 */
/* %%%-SFUNWIZ_wrapper_externs_Changes_BEGIN --- EDIT HERE TO _END */
/* extern double func(double a); */
/* %%%-SFUNWIZ_wrapper_externs_Changes_END --- EDIT HERE TO _BEGIN */

/*
 * Start function
 *
 */
void car_fast_sfunc_Start_wrapper(real_T *xC)
{
/* %%%-SFUNWIZ_wrapper_Start_Changes_BEGIN --- EDIT HERE TO _END */
/*
    * Custom Start code goes here.
    */
    xC[0] = 0;
    xC[1] = 0;
    xC[2] = 0;
    xC[3] = 1.0;
    xC[4] = 0;
    xC[5] = 0;
    xC[6] = 0;
    xC[7] = 0;
/* %%%-SFUNWIZ_wrapper_Start_Changes_END --- EDIT HERE TO _BEGIN */
}
/*
 * Output function
 *
 */
void car_fast_sfunc_Outputs_wrapper(const real_T *disturbance,
			const real_T *throttle_delta,
			real_T *y0,
			const real_T *xC)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
/* This sample sets the output equal to the input */
    y0[0] = xC[0];
    y0[1] = xC[1];
    y0[2] = xC[2];
    y0[3] = xC[3];
    y0[4] = xC[4];
    y0[5] = xC[5];
    y0[6] = xC[6];
    y0[7] = xC[7];
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}

/*
 * Derivatives function
 *
 */
void car_fast_sfunc_Derivatives_wrapper(const real_T *disturbance,
			const real_T *throttle_delta,
			real_T *y0,
			real_T *dx,
			real_T *xC)
{
/* %%%-SFUNWIZ_wrapper_Derivatives_Changes_BEGIN --- EDIT HERE TO _END */
double Cm1=0.287;
double Cm2=0.0545;
double Cr0=0.0218;
double Cr2=0.00035;
double B_r = 3.3852;
double C_r = 1.2691;
double D_r = 0.1737;
double B_f = 2.579;
double C_f = 1.2;
double D_f = 0.192;
    
double m = 0.041;
double Iz = 27.8e-6;
double l_f = 0.029;
double l_r = 0.033;
double g = 9.8;

double Nf = m*g*l_r/(l_f+l_r);
double Nr = m*g*l_f/(l_f+l_r);

double phi    =xC[2];
double v_x    =xC[3];
double v_y    =xC[4];
double omega  =xC[5];
double D      =throttle_delta[0];
double delta  =throttle_delta[1];
    
//         double alpha_f = 0;
//         double alpha_r = 0;
//     
//         if(abs(v_x)>0.001)
//         {
//             alpha_f = atan2((l_f*omega + v_y), abs(v_x))-delta;
//             alpha_r = atan2((v_y-l_r*omega),abs(v_x));
//         }
//         else
//         {
//             alpha_f = 0;
//             alpha_r = 0;
//         }
    
    double alpha_f = atan2((l_f*omega + v_y), abs(v_x))-delta;
    double alpha_r = atan2((v_y-l_r*omega),abs(v_x));
    double F_fy = D_f*sin(C_f*atan(-B_f*alpha_f));
    double F_fx = -Cr0*Nf-Cr2*v_x*v_x;
    double F_ry = D_r*sin(C_r*atan(-B_r*alpha_r));
    double F_rx = (Cm1*D-Cm2*D*v_x-Cr0*Nr-Cr2*v_x*v_x);
    
    dx[0] = v_x*cos(phi) - v_y*sin(phi);
    dx[1] = v_y*cos(phi) + v_x*sin(phi);
    dx[2] = omega;
    dx[3] = 1/m*(F_rx + F_fx*cos(delta) - F_fy*sin(delta) + m*v_y*omega);
    dx[4] = 1/m*(F_ry + F_fx*sin(delta) + F_fy*cos(delta) - m*v_x*omega);
    dx[5] = 1/Iz*(F_fx*sin(delta)*l_f + F_fy*l_f*cos(delta)- F_ry*l_r);
    dx[6] = v_x;
    dx[7] = v_y;
/* %%%-SFUNWIZ_wrapper_Derivatives_Changes_END --- EDIT HERE TO _BEGIN */
}
/*
 * Terminate function
 *
 */
void car_fast_sfunc_Terminate_wrapper(real_T *xC)
{
/* %%%-SFUNWIZ_wrapper_Terminate_Changes_BEGIN --- EDIT HERE TO _END */
/*
    * Custom Terminate code goes here.
    */
/* %%%-SFUNWIZ_wrapper_Terminate_Changes_END --- EDIT HERE TO _BEGIN */
}

