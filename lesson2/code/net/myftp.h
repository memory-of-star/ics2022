#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/signal.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/epoll.h>
#include <errno.h>
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <string.h>

#define MAXLINE 64
#define MAX_PACKET_SIZE   10240    // 数据包的最大长度,单位是sizeof(char)
#define MAXFILEDIRLENGTH 256     // 存放文件路径的最大长度
#define PORT     4096    // 端口号
#define SERVER_IP    "127.0.0.1" // server端的IP地址
#define LISTENQ 64

// 各种消息的宏定义
#define INVALID_MSG      -1   // 无效的消息标识
#define MSG_FILENAME     1   // 文件的名称
#define MSG_FILELENGTH     2   // 传送文件的长度
#define MSG_CLIENT_READY    3   // 客户端准备接收文件
#define MSG_FILE      4   // 传送文件
#define MSG_SENDFILESUCCESS    5   // 传送文件成功
#define MSG_OPENFILE_ERROR    10   // 打开文件失败,可能是文件路径错误找不到文件等原因
#define MSG_FILEALREADYEXIT_ERROR 11   // 要保存的文件已经存在了