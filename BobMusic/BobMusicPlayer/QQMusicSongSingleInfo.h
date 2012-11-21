//
//  QQMusicSongSingleInfo.h
//  BobMusic
//
//  Created by Angus Bob on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QQMusicSongSingleInfo : NSObject

@property(retain,nonatomic)NSString *mSongUrl;      //链接URL
@property(retain,nonatomic)NSString *mSongName;     //歌曲名称
@property(retain,nonatomic)NSString *mSingerName;   //歌手姓名
@property(retain,nonatomic)NSString *mAlbumName;    //专辑链接
@property(retain,nonatomic)NSString *mAlbumLink;    //专辑链接
@property(retain,nonatomic)NSString *mSongLrcUrl;   //链接URL
@property(retain,nonatomic)NSString *mPlaytime;     //时长

@end
