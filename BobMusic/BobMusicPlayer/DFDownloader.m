//
//  DFDownloader.m
//  MusicPlayer
//
//  Created by Bill on 12-7-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DFDownloader.h"

@implementation DFDownloader

@synthesize receivedData;       //接收到的数据
@synthesize downloadConnection; //下载连接
@synthesize key;
@synthesize delegate;

//方法类型：系统方法
//编   写：
//方法功能：init
-(id)init{
    if(self=[super init]){
        
    }
    return self;
}


//方法类型：自定义方法
//编   写：
//方法功能：启动下载(根据URL地址)
-(void)startDownloadWithURLString:(NSString *)urlString Key:(NSString*)theKey Encoding:(NSStringEncoding)encoding
{
    if(self.downloadConnection==nil){
        usingEncoding=encoding;
        self.receivedData=[NSMutableData data];
        self.key=[NSString stringWithString:theKey];
        
        NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] delegate:self];
        self.downloadConnection=connection;
        [connection release];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];//开启状态栏风火轮
    }
}

//方法类型：自定义方法
//编   写：
//方法功能取消下载
-(void)cancelDownload
{
    [self.downloadConnection cancel];
    self.downloadConnection=nil;
    self.receivedData=nil;
    self.key=nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];//关闭状态栏风火轮
}


//方法类型：自定义方法
//编   写：
//方法功能：接收到数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}


//方法类型：自定义方法
//编   写：
//方法功能：接受数据错误
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.receivedData=nil;
    self.downloadConnection=nil;
    self.key=nil;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];//关闭状态栏风火轮
    
//    NSLog(@"%@",[error description]);
}


//方法类型：自定义方法
//编   写：
//方法功能：完成连接加载
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *string=[[NSString alloc]initWithData:receivedData encoding:usingEncoding];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];//关闭状态栏风火轮 
    if(self.delegate){
        [delegate downloadFinishedWithResult:[string autorelease] Key:key];
    }else {
        NSLog(@"Nil");
        [string autorelease];
    }
    self.receivedData=nil;
    self.downloadConnection=nil;
    self.key=nil;
}

@end
