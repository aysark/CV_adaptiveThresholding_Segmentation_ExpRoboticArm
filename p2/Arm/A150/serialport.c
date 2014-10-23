/***************************************************************************
 ** File "serialport.c"
 ** low level tty code for the robot arm
 **
 ** version 15/09/1998 by Michael Jenkin, modified from irix, sun4 to
 **                    generate solaris code
 **         01/09/1998 by Ho Ng, modified to support native methods in Java
 ***************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <jni.h>

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

#include "Armtty.h"

#define SERIALPORTNAME "/dev/ttyS0"
#define CHARPAUSEINMICROSEC 5
//#define DEBUG

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
	printf("bad read\n");
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
 ** Function : init
 ** Purpose  : open the serial port to communicate with the arm. It
 **            initializes the line to the robot at 9600 baud using the line
 **            specified. This is 'text-line' currently
 ** Output   : the file input stream number, or -1 if it can't open the port
 ***************************************************************************/
JNIEXPORT jint JNICALL Java_Armtty_init(JNIEnv* env, jobject obj)
{
  struct termio newterm;
  int fd;

  fprintf(stderr,"JNICALL init\n");
  fd = open(SERIALPORTNAME, O_RDWR);
  if (fd < 0)
    {
      fprintf(stderr, "Unable to open %s\n", SERIALPORTNAME);
      return (-1);
    }

  if (ioctl(fd, TCGETA, &newterm) < 0)
    {
      fprintf(stderr, "TCGETA ioctl failure\n");
      close(fd);
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
      fprintf(stderr, "TCSETA ioctl failure\n");
      close(fd);
      return (-1);
    }

  fprintf(stderr,"open completes\n");
  return fd;
}

/***************************************************************************
 ** Function : quit
 ** Purpose  : close the connection to the arm
 ***************************************************************************/
JNIEXPORT jint JNICALL Java_Armtty_quit(JNIEnv* env, jobject obj, jint fd)
{
  close(fd);
  return 1;
}

/***************************************************************************
 ** Function : send
 ** Purpose  : send a command to the output port
 ***************************************************************************/
JNIEXPORT jstring JNICALL Java_Armtty_send(JNIEnv* env, jobject obj, jint fd,
					jstring command)
{
  struct timespec t;
  const char* input = ((*env)->GetStringUTFChars(env, command, 0));
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
  char empty[0];
  for (ptr = cmnd; (*ptr) != '\0'; ptr++)
    {
      if (write(fd, ptr, 1) != 1) {
	printf("incomplete write\n");
	return (*env)->NewStringUTF(env, empty);
      }
      while(1) {
	if(read(fd, &resp, 1) != 1) {
	  printf("no good echo\n");
	  return (*env)->NewStringUTF(env, empty);
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
      printf("can't write cr\n");
      return (*env)->NewStringUTF(env, empty);
    }
# ifdef DEBUG
  fprintf(stderr,"send: end of line sent too\n");
# endif

  char response[1024];
  done = read_resp(fd, cmnd, response);

# ifdef DEBUG
  fprintf(stderr,"send: response received\n");
# endif

  /* (*env)->ReleaseStringUTFChars(env, command, cmnd); */

# ifdef DEBUG
  fprintf(stderr,"send: returning\n");
# endif
  return (*env)->NewStringUTF(env, response);
}
