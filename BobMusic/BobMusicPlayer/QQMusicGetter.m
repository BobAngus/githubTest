//
//  QQMusicGetter.m
//  BobMusic
//
//  Created by Angus Bob on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QQMusicGetter.h"
#import "SBJson.h"
#import "QQMusicSongSingleInfo.h"

@implementation QQMusicGetter
@synthesize delegate;

//方法类型：自定义方法
//编   写：
//方法功能：设置获取音乐排行榜的链接
-(void)getQQMusicInfoData:(NSString *)urlString
{
    QQMusicDownloader *downloader=[[QQMusicDownloader alloc]init];
    downloader.delegate=self;
    [downloader startDownloadWithURLString:urlString];
}

//方法类型：自定义方法
//编   写：
//方法功能：获取返回json，并解析
-(void)QQMusicdownloadFinishedWithResult:(NSString*)result
{
    
    NSRange temprange1 = [result rangeOfString:@"songlist:[{"];                 //获取 [ 的位置
    NSString *jsonTemp1 = [result substringFromIndex:temprange1.location ];    //开始截取    + temprange1.length    
    NSRange temprange2 = [jsonTemp1 rangeOfString:@"}]"];                    //获取 ] 的位置        
    NSString *jsonTemp2 = [jsonTemp1 substringToIndex:temprange2.location + 3];       //截取下标range2之前的字符串
    
//    NSLog(@"result = %@",jsonTemp2);
    NSMutableString * tempjson = [[NSMutableString alloc]initWithString:jsonTemp2];
    NSRange rangeOne = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@"songlist:[" withString:@"{\"songlist\":[" options:NSCaseInsensitiveSearch range:rangeOne];
    NSRange rangeThree = NSMakeRange(0, [tempjson length]);
    
    [tempjson replaceOccurrencesOfString:@"{id:\"" withString:@"{\"id\":\"" options:NSCaseInsensitiveSearch range:rangeThree];
    NSRange rangeFour = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@", type:" withString:@",\"type\":\"" options:NSCaseInsensitiveSearch range:rangeFour];
    NSRange rangeFive = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@", url:" withString:@"\",\"url\":" options:NSCaseInsensitiveSearch range:rangeFive];
    NSRange rangeSix = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@", songName:\"" withString:@",\"songName\":\"" options:NSCaseInsensitiveSearch range:rangeSix];
    NSRange rangeSeven = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@"\", singerId:" withString:@"\",\"singerId\":" options:NSCaseInsensitiveSearch range:rangeSeven];
    NSRange rangeEight = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@"\", singerName:\"" withString:@"\",\"singerName\":\"" options:NSCaseInsensitiveSearch range:rangeEight];
    NSRange rangeNine = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@"\", albumId:\"" withString:@"\",\"albumId\":\"" options:NSCaseInsensitiveSearch range:rangeNine];
    NSRange rangeTen = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@"\", albumName:\"" withString:@"\",\"albumName\":\"" options:NSCaseInsensitiveSearch range:rangeTen];
    NSRange rangeEleven = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@"\", albumLink:\"" withString:@"\",\"albumLink\":\"" options:NSCaseInsensitiveSearch range:rangeEleven];
    NSRange rangeTwelve = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@"\", playtime:\"" withString:@"\",\"playtime\":\"" options:NSCaseInsensitiveSearch range:rangeTwelve];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    SBJsonParser *parse = [[SBJsonParser alloc]init];
    NSError *error = nil;
    
    
    NSMutableDictionary *rootDic = [parse objectWithString:tempjson error:&error];
    NSMutableArray *songArray = [rootDic objectForKey:@"songlist"];     
    for(NSMutableDictionary *member in songArray){
        QQMusicSongSingleInfo *qqMusicInfo = [[QQMusicSongSingleInfo alloc]init];
        NSString *tempId = [member objectForKey:@"id"];
        NSString *tempType = [member objectForKey:@"type"];
        NSString *tempSongName = [member objectForKey:@"songName"];
        NSString *tempSingerName = [member objectForKey:@"singerName"];
        NSString *tempAlbumId = [member objectForKey:@"albumId"];
        NSString *tempPlaytime = [member objectForKey:@"playtime"];
        NSString *tempAlbumName = [member objectForKey:@"albumName"];
        
        qqMusicInfo.mSongName = tempSongName;       //歌曲名称
        qqMusicInfo.mSingerName = tempSingerName;   //歌手
        
        NSString *songIdTemp;
        if (tempId.length < 7) {
            NSInteger songLength = tempId.length;
            if (songLength == 6) {
                songIdTemp = [NSString stringWithFormat:@"0%@",tempId];
            }else if (songLength == 5) {
                songIdTemp = [NSString stringWithFormat:@"00%@",tempId];
            }else if (songLength == 4) {
                songIdTemp = [NSString stringWithFormat:@"000%@",tempId];
            }else if (songLength == 3) {
                songIdTemp = [NSString stringWithFormat:@"0000%@",tempId];
            }else if (songLength == 2) {
                songIdTemp = [NSString stringWithFormat:@"00000%@",tempId];
            }
        }else {
            songIdTemp = tempId;
        }
        
        NSString *mSongUrlTemp = [NSString stringWithFormat:@"http://stream1%@.qqmusic.qq.com/3%@.mp3",tempType,songIdTemp];
        qqMusicInfo.mSongUrl = mSongUrlTemp;        //歌曲链接
//        NSLog(@"mSongUrlTemp = %@",mSongUrlTemp);
        NSInteger iTemptempAlbumId = [tempAlbumId integerValue];
        NSInteger iTempAlbum = fmod(iTemptempAlbumId,100);
        NSString *itempAlbumFmod = [NSString stringWithFormat:@"%d",iTempAlbum];
        
        NSString *mAlbumLinkTemp = [NSString stringWithFormat:@"http://imgcache.qq.com/music/photo/album/%@/albumpic_%@_0.jpg",itempAlbumFmod,tempAlbumId];
        qqMusicInfo.mAlbumLink = mAlbumLinkTemp;    //专辑封面链接
        
        
        NSInteger iTemptsongIdTemp = [songIdTemp integerValue];
        NSInteger iTempsong = fmod(iTemptsongIdTemp,100);
        NSString *itempsongFmod = [NSString stringWithFormat:@"%d",iTempsong];        
        NSString *mSongLrcUrlTemp = [[NSString alloc]initWithFormat:@"http://music.qq.com/miniportal/static/lyric/%@/%@.xml",itempsongFmod,songIdTemp];
        qqMusicInfo.mSongLrcUrl = mSongLrcUrlTemp;  //歌词链接
        
        qqMusicInfo.mPlaytime = tempPlaytime;       //时长
        qqMusicInfo.mAlbumName = tempAlbumName;     //专辑名称
        
        [resultArray addObject:qqMusicInfo];
    }
    if(delegate){
        struct QQMusicInformation QQMusicInfo;
        QQMusicInfo.QQMusicInfo= resultArray;
        [delegate QQMusicInformation:QQMusicInfo];
    }
}

@end
