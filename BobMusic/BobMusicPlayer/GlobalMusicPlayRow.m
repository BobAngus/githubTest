//
//  GlobalMusicPlayRow.m
//  BobMusic
//
//  Created by Angus Bob on 12-10-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GlobalMusicPlayRow.h"

@implementation GlobalMusicPlayRow
@synthesize musicPlayRow;
@synthesize musicTableViewArray;
@synthesize playStatus;
@synthesize nNewmusicPlayRow;
@synthesize streamer;
@synthesize qqMusicHitList;

@synthesize musicLrcArray;
@synthesize _lrc;

//方法类型：自定义全局方法
//编   写：
//方法功能：存储当前网络音乐信息
+ (GlobalMusicPlayRow *)sharedSingleton  
{  
    static GlobalMusicPlayRow *sharedSingleton;  
    @synchronized(self)  
    {  
        if (!sharedSingleton)  
            sharedSingleton = [[GlobalMusicPlayRow alloc] init];  
        
        return sharedSingleton;  
    }  
} 
@end
