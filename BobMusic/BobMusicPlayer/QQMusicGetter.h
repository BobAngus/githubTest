//
//  QQMusicGetter.h
//  BobMusic
//
//  Created by Angus Bob on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QQMusicDownloader.h"
struct QQMusicInformation{//MV信息解析
    NSMutableArray __unsafe_unretained *QQMusicInfo;
};
@protocol QQMusicGetterDelegate <NSObject>
-(void)QQMusicInformation:(struct QQMusicInformation)result;
@end

@interface QQMusicGetter : NSObject<QQMusicDownloaderDelegate>

-(void)getQQMusicInfoData:(NSString *)urlString;
@property(retain,nonatomic)id<QQMusicGetterDelegate>delegate;
@end
