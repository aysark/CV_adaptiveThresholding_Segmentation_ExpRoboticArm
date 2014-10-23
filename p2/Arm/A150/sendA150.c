/*
 * serialportA150Matlab.c
 * Provides serial port communication to the CRS A150 arm.
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
 **
 ***************************************************************************/
int compare_resp(char* buf, char* cmnd)
{
  int count;

  for(count = 0; buf[count] != '\n'; count++);
  count++;  

  if (buf[count] != '>')
    return (-1);
  else
    return (0);
}

/***************************************************************************
 **
 ***************************************************************************/
int read_resp(int fd, char* cmnd, char* resp)
{
  char *ptr, *tempPtr, buf[1024], temp[1024];
  int nump;

  /* A response is signalled by reading a ready prompt from the tty
     port. There may be an error message in front of it.            */

  for (nump = 0, ptr = buf; nump < 2; ptr++)
    {
      if (read(fd, ptr, 1) != 1)
	      mexWarnMsgTxt("bad read getting response from A150");
# ifdef DEBUG
      fprintf(stderr,"Read a %c\n", *ptr);
# endif
      if (*ptr == '>')
	nump++;
    }
  *ptr = '\0';
  strncpy(resp, buf, 1024);
		
  /* check to see if there is any response */
  if (buf[0] != '>')
    return (compare_resp(buf, cmnd));
  return (strncmp(cmnd, buf, strlen(cmnd)));
}




/***************************************************************************
 ** Function : sendA150
 ** Purpose  : send a command to the output port
 ***************************************************************************/
void sendA150(int fd, const char* command, char* response)
{
  struct timespec t;
  const char* input = command;
  char* ptr;
  char cmnd[512], resp;
  int ret, done = 1;

# ifdef DEBUG
  fprintf(stderr,"send: Sending the string %s\n",input);
# endif

  strcpy(cmnd, input);
  t.tv_sec = (time_t) 0;
  t.tv_nsec = 10000;

  /* The serial interface on the robot sucks. It can't work very
     fast and it drops chars. Best to write one at a time.       */
  for (ptr = cmnd; (*ptr) != '\0'; ptr++) {
    if (write(fd, ptr, 1) != 1) {
      mexWarnMsgTxt("incomplete write");
      response[0] = '\0';
      return;
    }
    while(1) {
	   if(read(fd, &resp, 1) != 1) {
	     mexWarnMsgTxt("no good echo");
             response[0] = '\0';
	     return;
	   }
# ifdef DEBUG
	   printf("wrote |%c| read |%c|\n",*ptr,resp);
# endif
	   if(resp == *ptr) 
	     break;
    }
  }

# ifdef DEBUG
  fprintf(stderr,"send: sent\n");
# endif

  if (write(fd, "\r", 1) != 1)
  {
    mexWarnMsgTxt("can't write CR");
    response[0] = '\0';
    return;
  }
# ifdef DEBUG
  fprintf(stderr,"send: end of line sent too\n");
# endif

  done = read_resp(fd, cmnd, response);

# ifdef DEBUG
  fprintf(stderr,"send: response received\n");
# endif

# ifdef DEBUG
  fprintf(stderr,"send: returning\n");
# endif
}




/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
  /* send has two inputs (a file descriptor and the command)
     and one output (the result) */
  if (nrhs != 2) {
    mexErrMsgIdAndTxt(":sendA150:nrhs",
                      "Two inputs required.");
  }
  if (nlhs != 1) {
    mexErrMsgIdAndTxt(":sendA150:nlhs",
                      "One output required.");
  }
  
  /* check that input is a double scalar */
  if(!mxIsDouble(prhs[0]) ||
      mxIsComplex(prhs[0]) ||
      mxGetNumberOfElements(prhs[0]) != 1 ) {

    mexErrMsgIdAndTxt(":sendA150:notScalar",
                      "Input must be a scalar");
  }

  /* check that input 1 is one row of characters */
  if(!mxIsChar(prhs[1]) || mxGetM(prhs[1]) != 1) {
    mexErrMsgIdAndTxt(":sendA150:notRowVector",
                      "Input must be a row vector of char.");

  }

  /* input file descriptor */
  double handle = mxGetScalar(prhs[0]);

  /* input string */
  int length = mxGetN(prhs[1]) + 1;
  char *command = mxCalloc(length, sizeof(char));
  mxGetString(prhs[1], command, length);

  /* output string */
  char result[1024];
  sendA150((int)handle, command, result);
  plhs[0] = mxCreateString(result);
}
