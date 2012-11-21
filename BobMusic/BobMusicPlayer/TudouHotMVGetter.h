//
//  TudouHotMVGetter.h
//  BobPlayer
//
//  Created by Bob Angus on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFDownloader.h"

struct mvInformation{//MV信息解析
    NSMutableArray __unsafe_unretained *information;
    int pagesCount;
};

@protocol HotMVGetterDelegate <NSObject>
-(void)downloadFinishedWithResult:(struct mvInformation)result AndKey:(NSString*)key;
@end

@interface TudouHotMVGetter : NSObject<DFDownloaderDelegate>

-(void)getHotMVWithPage:(int)page;
-(void)searchByString:(NSString *)theString AndPage:(int)page;

@property(retain,nonatomic)id<HotMVGetterDelegate>delegate;
@end
