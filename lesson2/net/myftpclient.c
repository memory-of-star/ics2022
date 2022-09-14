#include "myftp.h"

void str_cli(FILE *fp, int sockfd);

int main(int argc, char **argv)
{
    int sockfd;
    struct sockaddr_in servaddr;

    if (argc != 2){
        fprintf(stderr, "%s\n", "usage: echoCli <IPaddress>");
        exit(1);
    }
    sockfd = socket(AF_INET, SOCK_STREAM, 0);

    bzero(&servaddr, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(4000);
    inet_pton(AF_INET, argv[1], &servaddr.sin_addr);
    connect(sockfd, (struct sockaddr *)&servaddr, sizeof(servaddr));
    str_cli(stdin, sockfd);
    exit(1);
}

void str_cli(FILE *fp, int sockfd){
    char sendline[MAXLINE], recvline[MAXLINE];
    int n;

    while(fgets(sendline, MAXLINE, fp) != NULL){
        write(sockfd, sendline, strlen(sendline));
        printf("send bitstream: ");
        for(int i = 0; i < strlen(sendline); i++){
            printf("%02x", sendline[i]);
        }
        printf("\n");
        //debug code
        //printf("strlen(sendline) = %d\n", (int)strlen(sendline));
        //

        if ((n = read(sockfd, recvline, MAXLINE)) == 0){
            fprintf(stderr, "%s\n", "server terminated prematurely");
            exit(1);
        }
        //debug code
        //printf("receive %d bytes\n", n);
        //
        recvline[n] = 0;
        printf("receive bitstream: ");
        for(int i = 0; i < n; i++){
            printf("%02x", recvline[i]);
        }
        printf("\n");
        // fputs(recvline, stdout);
    }
}