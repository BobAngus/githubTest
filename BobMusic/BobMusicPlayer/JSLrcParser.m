//
//  JSLrcParser.m
//  JLyric
//
//  Created by Jey on 8/8/12.
//  Copyright (c) 2012 Jey. All rights reserved.
//
//    http://www.apache.org/licenses/LICENSE-2.0

#import "JSLrcParser.h"

@implementation JSLrcParser

+ (__autoreleasing JSLrc *)lrcValue:(NSString *)file 
{
    if (file == nil) {
        return nil;
    }
//    if (![[NSFileManager defaultManager] fileExistsAtPath:file isDirectory:NO]) {
//        return nil;
//    }
//    NSData *data = [NSData dataWithContentsOfFile:file];
//    NSMutableString *lString = [[NSMutableString alloc] initWithData:data
//                                                            encoding:NSUTF8StringEncoding];
    NSMutableString *lString = [[NSMutableString alloc]initWithFormat:file];
//    NSMutableString *lString  = [[NSMutableString alloc]initWithFormat:lStringTemp]; 
    JSLrc *lrc = [JSLrc lrc];
#if DEBUG
    
#endif
    while (lString && lString.length > 0) 
    {
        // get lrc info
        if ([lString hasPrefix:@"[ti:"]
            || [lString hasPrefix:@"[ar:"]
            || [lString hasPrefix:@"[al:"]
            || [lString hasPrefix:@"[by:"]) 
        {
            NSRange r = [lString rangeOfString:@"]"];
            NSAssert(r.location!=NSNotFound, @"lrc format error.. please check..");
            NSString __autoreleasing *ti = [lString substringWithRange:(NSRange){4, r.location-4}];
            [lrc.tags addObject:ti];
            [lString deleteCharactersInRange:(NSRange){0, r.location+r.length}];
            r = [lString rangeOfString:@"["];
            if (r.location != NSNotFound) 
            {
                [lString deleteCharactersInRange:(NSRange){0, r.location}];
            }
            continue;
        } 
        else if ([lString hasPrefix:@"[offset:"]) 
        {
            NSRange r = [lString rangeOfString:@"]"];
            NSAssert(r.location!=NSNotFound, @"lrc format error.. please check..");
            NSString __autoreleasing *o = [lString substringWithRange:(NSRange){8, r.location-8}];
            NSLog(@"t : %@", o);
            lrc.offset = o;
            [lString deleteCharactersInRange:(NSRange){0, r.location+r.length}];
            r = [lString rangeOfString:@"["];
            if (r.location != NSNotFound) 
            {
                [lString deleteCharactersInRange:(NSRange){0, r.location}];
            }
            continue;
        }
        else 
        {
            NSAssert([lString hasPrefix:@"["], @"lrc format error.. please check..");
            NSMutableArray __autoreleasing *keys = [NSMutableArray array];
            NSRange r;
            while ([lString hasPrefix:@"["]) 
            {
                r = [lString rangeOfString:@"]"];
                NSAssert(r.location!=NSNotFound, @"lrc format error.. please check..");
                NSString __autoreleasing *key = [lString substringWithRange:(NSRange){1, r.location-1}];
                [keys addObject:key];
                [lString deleteCharactersInRange:(NSRange){0, r.location+r.length}];
            }
            r = [lString rangeOfString:@"["];
            NSString __autoreleasing *value = nil;
            if (r.location != NSNotFound) 
            {
                value = [lString substringToIndex:r.location-1];
            }
            else 
            {
                value = [lString substringToIndex:lString.length];
                r.location = lString.length;
            }
            [lString deleteCharactersInRange:(NSRange){0, r.location}];
            NSAssert(value!=nil, @"lrc format error.. please check..");
            for (NSString *key in keys) 
            {
                if (!key
                    || [key length] < 3
                    || [key rangeOfString:@":"].location==NSNotFound) 
                {
                    continue;
                }
                float k = [[key substringToIndex:2] intValue]*60+[[key substringFromIndex:3] floatValue];
                if (k < 0.01) 
                {
                    continue;
                }
                [lrc.lyric setObject:value forKey:[NSNumber numberWithFloat:k]];
            }
            continue;
        }
    }
//    NSLog(@"lrc string : \n%@", lString);
    return lrc;
}

@end
//@synthesize songLrcUrl,songLrcDownload,songLrcConnection;


//##################################### JSLrc ##################################
@implementation JSLrc

@synthesize lyric = _lyric, tags = _tags, offset = _offset;


+ (__autoreleasing JSLrc *)lrc 
{
    return [[JSLrc alloc] init];
}

- (__autoreleasing NSMutableArray *)tags 
{
    if (_tags == nil) 
    {
        _tags = [[NSMutableArray alloc] init];
    }
    return _tags;
}

- (__autoreleasing NSMutableDictionary *)lyric 
{
    if (_lyric == nil) 
    {
        _lyric = [[NSMutableDictionary alloc] init];
    }
    return _lyric;
}

- (__autoreleasing NSString *)description 
{
    return [NSString stringWithFormat:@"\n{\nlyric:%@,\ntags:%@,\noffset:%@", _lyric, _tags, _offset];
}

@end



