##### 什么是Socket？
socket是使用标准Unix文件描述符与其他程序进行通讯的方式。概括地来说socket并不是一个协议，它只是处于会话层中对TCP/IP协议进行封装的一个抽象层(也就是说可以使用socket API接口直接访问更底层的TCP/UDP协议)。一个socket由一个IP地址和端口号唯一确定。应用程序通常通过套接字向网络发出请求和应答。

套接字通讯有很多种，比如Internet套接字和Unix套接字；

##### Internet套接字
Internet套接字有两种主流的类型。
* Stream sockets(流格式)：是可靠的双向通讯数据流；按序到达；实际是使用了TCP传输控制协议
* Datagram Sockets(数据包格式)：也叫“无连接套接字”；使用UDP用户数据报协议；那这种无连接的丢包了咋办呢？**实际上大部分使用UDP的应用程序在发送出数据包之后，必须在一定时间内回复一个ACK确认包**。

##### 数据封装
也就是网络分层上对数据进行的封装。一个应用层的数据包，首先被第一个协议进行封装(比如TFTP)；然后，被传输层协议进行封装(比如UDP)，然后下一个网络层协议(IP)进行包装，之后是数据链路层...
当另一台机器收到之后，就开始逐层往上剥去头部，直到应用层。

##### socket 与 HTTP
由socket定义可知，socket只是一个调用接口，是为了更方便地使用TCP/IP协议栈。
而HTTP是一个应用层的超文本传输协议，是基于TCP之上的。HTTP连接一种“短连接”，每次请求结束后，都会主动释放连接。
“socket长连接”并不是说socket是一个长连接，按定义来说，socket不存在所谓的什么连接，因为它不是协议。

##### socket 打洞流程






