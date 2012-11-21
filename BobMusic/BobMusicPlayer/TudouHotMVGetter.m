//
//  TudouHotMVGetter.m
//  BobPlayer
//
//  Created by Bob Angus on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TudouHotMVGetter.h"
#import "TudouMvInfo.h"


@implementation TudouHotMVGetter
@synthesize delegate;

//方法类型：自定义方法
//编   写：
//方法功能：获取热门MV
-(void)getHotMVWithPage:(int)page
{
    NSString *urlString=[NSString stringWithFormat:@"http://api.tudou.com/v3/gw?method=item.ranking&format=xml&appKey=2aaf400b13fc9bad&pageNo=%i&pageSize=20&channelId=14&sort=v",page];
    
    DFDownloader *downloader=[[DFDownloader alloc]init];
    downloader.delegate=self;
    [downloader startDownloadWithURLString:urlString Key:@"hotMVXML" Encoding:NSUTF8StringEncoding];
    [downloader release];
}

//方法类型：自定义方法
//编   写：
//方法功能：取出xml文件的土豆排行榜信息 存入数组tudouMvInfo
- (void)downloadFinishedWithResult:(NSString *)result Key:(NSString *)theKey{
    NSMutableArray *resultArray = [NSMutableArray array];
    int pages = 0;
    
    NSArray *array = [result componentsSeparatedByString:@"<ItemInfo>"];//将string字符串转换为array数组
    
    for (int i = 1; i < [array count]; i++) {
        
        TudouMvInfo *tudouMvInfo = [[TudouMvInfo alloc]init];   //MV 信息类
        NSString *itemInformation = [array objectAtIndex:i];    //取出第一条信息
        
        //视频信息
        itemInformation = [[itemInformation componentsSeparatedByString:@"</ItemInfo>"] objectAtIndex:0];
        
        //标题
        NSString *title=[[itemInformation componentsSeparatedByString:@"<title>"]objectAtIndex:1];
        title=[[title componentsSeparatedByString:@"</title>"]objectAtIndex:0];
        tudouMvInfo.title=title;
        
        //视频描述
        NSString *description = nil;
        description = [[itemInformation componentsSeparatedByString:@"<description>"]objectAtIndex:1];
        description = [[description componentsSeparatedByString:@"</description>"]objectAtIndex:0];
        
        description=[description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去空白
        
        if (!description || [description isEqualToString:@""]) {
            description =@"暂无描述 ... ...";
        }else {
            description = [NSString stringWithFormat:@"      %@",description];
        }
        
        tudouMvInfo.information = description;
        
        //图片地址
        NSString *picUrl = [[itemInformation componentsSeparatedByString:@"<picUrl>"]objectAtIndex:1];
        picUrl = [[picUrl componentsSeparatedByString:@"</picUrl>"]objectAtIndex:0];
        
        //下载图片
        NSURL *picDownloadUrl = [[NSURL alloc]initWithString:picUrl];
        NSData *imageDate = [[NSData alloc]initWithContentsOfURL:picDownloadUrl];
        UIImage *picture = [UIImage imageWithData:imageDate];
        [picDownloadUrl release];
        [imageDate release];
        tudouMvInfo.picture = picture;
        
        //播放地址
        NSArray *playUrlArray = [picUrl componentsSeparatedByString:@"/"];
        NSString *playUrl = [NSString string];
        
        for (int i = 3; i < [playUrlArray count]-1; i++) {
            playUrl = [playUrl stringByAppendingFormat:@"%@/",[playUrlArray objectAtIndex:i]];
        }
        
        playUrl = [NSString stringWithFormat:@"http://m3u8.tdimg.com/%@2.m3u8",playUrl];
        tudouMvInfo.playURL = playUrl;
        
        //存入数组
        [resultArray addObject:[tudouMvInfo autorelease]];
    }
    //总页数
    if([theKey isEqualToString:@"searchXML"]||[theKey isEqualToString:@"hotMVXML"]){
        
        NSString *count=[[result componentsSeparatedByString:@"<page>"]objectAtIndex:1];
        
        count=[[count componentsSeparatedByString:@"<totalCount>"]objectAtIndex:1];
        count=[[count componentsSeparatedByString:@"</totalCount>"]objectAtIndex:0];
        
        if([count intValue]>0){
            pages=[count intValue]/20;
        }
    }
    if(delegate){
        
        struct mvInformation information;
        
        information.pagesCount=pages;
        information.information=resultArray;
        
        [delegate downloadFinishedWithResult:information AndKey:theKey];
    }
    [self autorelease];
}

//方法类型：自定义方法
//编   写：
//方法功能：搜索
-(void)searchByString:(NSString *)theString AndPage:(int)page{ //2aaf400b13fc9bad 江南    
     NSString *urlString=[NSString stringWithFormat:@"http://api.tudou.com/v3/gw?method=item.search&appKey=2aaf400b13fc9bad&format=xml&kw=%@&pageNo=%i&pageSize=20&channelId=14&sort=v",theString,page];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    DFDownloader *downloader = [[DFDownloader alloc]init];
    downloader.delegate = self;
    
    NSString *theKey = (page == 1)?@"searchXML":@"searchMoreXML";
    [downloader startDownloadWithURLString:urlString Key:theKey Encoding:NSUTF8StringEncoding];
    [downloader release];
}
@end
