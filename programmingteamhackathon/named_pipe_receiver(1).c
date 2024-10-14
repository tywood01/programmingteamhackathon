/* Receiver program. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>

#define MSGSIZE 63
#define FIFO_MODE 0666

char *fifo = "FIFO"; /* Name of FIFO. */

int main(void) {

  int fd;
  char msgbuf[MSGSIZE+1]; /* Messages to fifo will be at most 63 byteslong. */

  /* Create fifo if it does not already exist. */
  if (mkfifo(fifo, FIFO_MODE) == -1) {
    if (errno != EEXIST) {
      fprintf(stderr, "Receiver: Could not create fifo.\n"); exit(1);
    }
  }

  /* Open the fifo for read and write. */
  if ((fd = open(fifo, O_RDWR)) == -1) {
    fprintf(stderr, "Receiver: FIFO open failed.\n"); exit(1);
  }

  /* Receive messages. */
  for (;;) {
    if (read(fd, msgbuf, MSGSIZE+1) == -1) {
    fprintf(stderr, "Receiver: Reading from fifo failed.\n"); exit(1);
    }

    /* Print the message. */
    printf("Received message: %s\n", msgbuf);
  } /* End of for loop. */
  
  return 0;

} /* End of main for receiver. */
