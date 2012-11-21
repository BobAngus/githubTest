//
//  TudouMvInfo.m
//  BobPlayer
//
//  Created by Bob Angus on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TudouMvInfo.h"

@implementation TudouMvInfo
@synthesize title;      //标题
@synthesize actor;      //演唱者
@synthesize information;//简介
@synthesize picture;    //图片
@synthesize playURL;    //播放地址

//方法类型：自定义方法
//编   写：
//方法功能：设置mv图片信息
-(void)setPicture:(UIImage *)thePicture{
    if(![picture isEqual:thePicture]){
        picture=[thePicture copy];
    }
}
@end
