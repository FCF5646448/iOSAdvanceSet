1、UITextView 控件可以识别出URL，但是有时候也会不准。比如："哈哈www.baidu.com哈哈"，有可能会识别成 "www.baidu.com哈哈" 。

textView.dataDetectorTypes = UIDataDetectorTypeLink; //打开链接识别。

解决方案：在点击回调的时候用正则表达式匹配一下，然后截取到有用的url字符串：

```objective-c
//添加个正则匹配链接，然后取出可用的url字符串。避免UITextView识别出错的问题，比如：哈哈www.baidu.com哈哈，有可能会识别成www.baidu.com哈哈 。
- (NSString *)getNewUrlStr:(NSString *)oldUrlStr {
    
    NSError *error;
    NSString * regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"; //((http[s]{0,1}|ftp)://[a-zA-Z0-9\.\-]+\.([a-zA-Z]{2,4})(:\d+)?(/[a-zA-Z0-9\.\-~!@#%^&+?:_/=<>])?)
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:oldUrlStr options:0 range:NSMakeRange(0, [oldUrlStr length])];

    NSString* substringForMatch = @"";
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        substringForMatch = [oldUrlStr substringWithRange:match.range];
    }
    
    return substringForMatch;
}
```



2、UITextView 链接的点击与长按事件的冲突问题。



