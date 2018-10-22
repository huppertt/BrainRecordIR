/*=================================================================
This function runs the real-time FIR filter on a data set
 *
 * The calling syntax is:
 *
 *		[data] = rtfir(data,filterorder,fa,fb)
 *=================================================================*/
/* $Revision: 1.10 $ */
#include <math.h>
#include "mex.h"

/* Input Arguments */

#define	DATA_IN	prhs[0]
#define	FILTERORDER_IN	prhs[1]
#define	FA_IN	prhs[2]
#define	FB_IN	prhs[3]

/* Output Arguments */

#define	DATA_OUT    plhs[0]


static void rtfir(
		   double data[],
		   int	filterorder,
 		   double	fa[],
           double	fb[],
           double datap[]
		   )
{
    //Do computations here
    datap[1]=1;
    datap[2]=2;
    datap[3]=3;
    return;
}

void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray*prhs[] )
{ 
    double *datap; 
    double *data,*fa,*fb; 
    unsigned int filterorder; 
     unsigned int m,n;
    
    /* Check for proper number of arguments */
    
    if (nrhs != 4) { 
	mexErrMsgTxt("four input arguments required."); 
    } else if (nlhs > 1) {
	mexErrMsgTxt("Too many output arguments."); 
    } 
    
    /* Check the dimensions of Y.  Y can be 4 X 1 or 1 X 4. */ 
    
    m = mxGetM(DATA_IN); 
    n = mxGetN(DATA_IN);
       
    /* Create a matrix for the return argument */ 
    DATA_OUT = mxCreateDoubleMatrix(1, 3, mxREAL); 
    
    /* Assign pointers to the various parameters */ 
    datap = mxGetPr(DATA_OUT);
    
    data = mxGetPr(DATA_IN); 
    fa = mxGetPr(FA_IN); 
    fb = mxGetPr(FB_IN); 
    filterorder = mxGetPr(FILTERORDER_IN);
        
    /* Do the actual computations in a subroutine */
    rtfir(data,filterorder,fa,fb,datap); 
    return;
    
}

