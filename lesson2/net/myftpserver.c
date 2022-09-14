#include "myftp.h"

void str_echo(int sockfd);

int main(int argc, char **argv){
    int listenfd, connfd;
    socklen_t clilen;
    struct sockaddr_in cliaddr, servaddr;

    listenfd = socket(AF_INET, SOCK_STREAM, 0);
    bzero(&servaddr, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
    servaddr.sin_port = htons(4000);

    bind(listenfd, (struct sockaddr *)&servaddr, sizeof(servaddr));
    listen(listenfd, LISTENQ);

    for(;;){
        clilen = sizeof(cliaddr);
        connfd = accept(listenfd, (struct sockaddr *)&cliaddr, &clilen);
        str_echo(connfd);
    }
}

void str_echo(int sockfd){
    ssize_t n;
    char buf[MAXLINE];

again:
    while((n = read(sockfd, buf, MAXLINE)) > 0){
        buf[n] = 0;
        printf("receive bitstream: ");
        for(int i = 0; i < n; i++){
            printf("%02x", buf[i]);
        }
        printf("\n");
        write(sockfd, buf, n);
    }
    if (n < 0 && errno == EINTR)
        goto again; //soft interrupt, try again
    else if (n < 0){
        perror("fail to read");
        exit(1);
    }
}