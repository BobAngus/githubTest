//
//  MusicModel.h
//  BobMusic
//
//  Created by Angus Bob on 12-11-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface FileModel : NSObject {
    
}

@property(nonatomic,retain)NSString *fileID;
@property(nonatomic,retain)NSString *fileName;
@property(nonatomic,retain)NSString *fileSize;
@property(nonatomic,retain)NSString *fileAlbumName;
@property(nonatomic)BOOL isFistReceived;
            //是否是第一次接受数据，如果是则不累加第一次返回的数据长度，之后变累加
@property(nonatomic,retain)NSString *fileReceivedSize;
@property(nonatomic,retain)NSString *fileURL;
@property(nonatomic)BOOL isDownloading;//是否正在下载
@property(nonatomic,retain)NSString *fileRoute;
@end
