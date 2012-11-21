//
//  GlobalMusicList.m
//  BobMusicPlayer
//
//  Created by Bob Angus on 12-10-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GlobalMusicList.h"

@implementation GlobalMusicList
@synthesize GNSMusicListName;
@synthesize GmediaItemCList;

@synthesize soundFiles;
@synthesize soundFilesPath;
@synthesize selectedIndex;

+ (GlobalMusicList *)sharedSingleton  
{  
    static GlobalMusicList *sharedSingleton;  
    @synchronized(self)  
    {  
        if (!sharedSingleton)  
            sharedSingleton = [[GlobalMusicList alloc] init];  
        
        return sharedSingleton;  
    }  
}  
@end
