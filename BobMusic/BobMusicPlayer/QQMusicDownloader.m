//
//  QQMusicDownloader.m
//  BobMusic
//
//  Created by Angus Bob on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QQMusicDownloader.h"

@implementation QQMusicDownloader
@synthesize receivedData;       //接收到的数据
@synthesize downloadConnection; //下载连接
@synthesize delegate;

-(id)init{
    if(self=[super init]){
        //
    }
    return self;
}



//方法类型：自定义方法
//编   写：
//方法功能：启动下载(根据URL地址)
-(void)startDownloadWithURLString:(NSString *)urlString
{    
    if(self.downloadConnection==nil){
        self.receivedData=[NSMutableData data];
        NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] delegate:self];
        self.downloadConnection=connection;
        if(downloadConnection == nil)
        {
            return;
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];//开启状态栏风火轮
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：取消下载
-(void)cancelDownload{
    [self.downloadConnection cancel];
    self.downloadConnection=nil;
    self.receivedData=nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];//关闭状态栏风火轮
}

//方法类型：自定义方法
//编   写：
//方法功能：通过response的响应，判断是否连接存在
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"链接不存在");    
}


//方法类型：自定义方法
//编   写：
//方法功能：通过data获得请求后，返回的数据，数据类型NSData
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

//方法类型：自定义方法
//编   写：
//方法功能：返回的错误信息
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.receivedData=nil;
    self.downloadConnection=nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];//关闭状态栏风火轮
}


//方法类型：自定义方法
//编   写：
//方法功能：数据请求完毕，这个时候，用法是多线程的时候，通过这个通知，关部子线程
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000); 
    NSString*string = [[NSString alloc] initWithData:receivedData encoding:gbkEncoding];
//    NSLog(@"数据请求完毕 %@",string);
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];//关闭状态栏风火轮 
    if(self.delegate){
        [delegate QQMusicdownloadFinishedWithResult:string];
    }else {
        NSLog(@"Nil");
    }
    self.receivedData=nil;
    self.downloadConnection=nil;
}
@end
