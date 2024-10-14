/* Sender program. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

#define MSGSIZE 63
#define FIFO_MODE 0666

char *fifo = "FIFO"; /* Name of FIFO. */

int main(int argc, char *argv[]) {

  int fd, j , nwrite;
  char msgbuf[MSGSIZE+1]; /* Messages to fifo will be at most 63 bytes long. */

  if (argc < 2) {
    fprintf(stderr, "Usage: send m1 m2 ... \n"); exit(1);
  }

  /* The sender assumes that the fifo will be created by the receiver. */
  /* Open the fifo for non-blocking writes. */
  if ((fd = open(fifo, O_WRONLY | O_NONBLOCK)) == -1) {
    fprintf(stderr, "Sender: FIFO open failed.\n"); exit(1);
  }

  /* Send messages. */
  for (j = 1; j < argc; j++) {
    if (strlen(argv[j]) > MSGSIZE) {
      fprintf(stderr, "Sender: Message too long -- %s\n", argv[j]); exit(1);
    }

    strcpy(msgbuf, argv[j]);
    if ((nwrite = write(fd, msgbuf, MSGSIZE+1)) == -1) {
      fprintf(stderr, "Sender: Write to fifo failed.\n"); exit(1);
    }

  } /* End of for loop. */

return 0;

} /* End of main for sender. */
