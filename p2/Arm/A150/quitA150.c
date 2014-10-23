/*
 * quitA150.c
 * Quit communication with the A150 arm.
 *
 */


/***************************************************************************
 ** File "serialport.c"
 ** low level tty code for the robot arm
 **
 ** version 15/09/1998 by Michael Jenkin, modified from irix, sun4 to
 **                    generate solaris code
 **         01/09/1998 by Ho Ng, modified to support native methods in Java
 ***************************************************************************/
#include "mex.h"
#include <stdlib.h>
#include <stdio.h>

#include <errno.h>
#include <sys/types.h>
#include <sys/file.h>
#include <sys/termios.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <time.h>
#include <unistd.h>
#include <termio.h>
#include <string.h>


#define SERIALPORTNAME "/dev/ttyS0"
#define CHARPAUSEINMICROSEC 5
/*#define DEBUG*/


/***************************************************************************
 ** Function : quitA150
 ** Purpose  : close the connection to the arm
 ***************************************************************************/
void quitA150(int fd)
{
  close(fd);
}


/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
  /* quitA150 has one input (the handle) and zero output */
  if (nrhs != 1) {
    mexErrMsgIdAndTxt(":quitA150:nrhs",
                      "One input required.");
  }
  if (nlhs != 0) {
    mexErrMsgIdAndTxt(":quitA150:nlhs",
                      "Zero output required.");
  }
  
  /* check that input is a double scalar */
  if(!mxIsDouble(prhs[0]) ||
      mxIsComplex(prhs[0]) ||
      mxGetNumberOfElements(prhs[0]) != 1 ) {

    mexErrMsgIdAndTxt(":quitA150:notScalar",
                      "Input must be a scalar");
  }

  double handle = mxGetScalar(prhs[0]);
  quitA150((int)handle);
}
