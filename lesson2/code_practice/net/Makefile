all: myftpserver myftpclient
.PHONY: all

myftpclient: myftpclient.o
	gcc -o myftpclient myftpclient.o

myftpserver: myftpserver.o
	gcc -o myftpserver myftpserver.o

myftpclient.o: myftp.h myftpclient.c
	gcc -c myftpclient.c

myftpserver.o: myftp.h myftpserver.c
	gcc -c myftpserver.c