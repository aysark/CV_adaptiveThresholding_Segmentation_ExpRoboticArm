/*
 * initA150.c
 * Initialize the serial port to communicate to the CRS A150 arm.
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
** Function : init
** Purpose  : open the serial port to communicate with the arm. It
**            initializes the line to the robot at 9600 baud using the line
**            specified. This is 'text-line' currently
** Output   : the file input stream number, or -1 if it can't open the port
***************************************************************************/
int initA150()
{
   struct termio newterm;
   int fd;
   
   fd = open(SERIALPORTNAME, O_RDWR);
   if (fd < 0)
   {
      mexErrMsgTxt("Unable to open serial port");
      return (-1);
   }
   
   if (ioctl(fd, TCGETA, &newterm) < 0)
   {
      close(fd);
      mexErrMsgTxt("TCGETA ioctl failure");
      return (-1);
   }
   
   newterm.c_iflag = newterm.c_oflag = newterm.c_lflag = (ushort) 0;
   newterm.c_cflag = (IGNPAR | IGNBRK | ISTRIP | CREAD | CLOCAL);
   newterm.c_cflag &= ~CBAUD;
   newterm.c_cflag |= B9600;
   newterm.c_cflag |= CSTOPB;
   newterm.c_cflag |= CS8;
   newterm.c_cc[VMIN] = 1;
   newterm.c_cc[VTIME] = 0;
   newterm.c_oflag |= INLCR;
   
   if (ioctl(fd, TCSETA, &newterm) < 0)
   {
      close(fd);
      mexErrMsgTxt("TCSETA ioctl failure");
      return (-1);
   }
   
   return fd;
}



/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
   int nrhs, const mxArray *prhs[])
{
  /* init has no input and one integer output */
   if (nrhs != 0) {
      mexErrMsgIdAndTxt(":initA150:nrhs",
         "Zero input required.");
   }
   if (nlhs != 1) {
      mexErrMsgIdAndTxt(":initA150:nlhs",
         "One output required.");
   }
   
   /* output integer */
   plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
   double *result = mxGetPr(plhs[0]);
   result[0] = initA150();
}
