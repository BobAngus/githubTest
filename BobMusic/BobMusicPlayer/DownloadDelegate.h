//
//  DownloadDelegate.h
//  BobMusic
//
//  Created by Angus Bob on 12-11-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

//方法类型：自定义方法
//编   写：
//方法功能：下载委托
@protocol DownloadDelegate <NSObject>
-(void)startDownload:(ASIHTTPRequest *)request;
-(void)updateCellProgress:(ASIHTTPRequest *)request FileSize:(NSString*)musicFileSize;
-(void)finishedDownload:(ASIHTTPRequest *)request;

@end
