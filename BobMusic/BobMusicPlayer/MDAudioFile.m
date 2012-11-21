//
//  AudioFile.m
//  MobileTheatre
//
//  Created by Matt Donnelly on 28/06/2010.
//  Copyright 2010 Matt Donnelly. All rights reserved.
//

#import "MDAudioFile.h"


@implementation MDAudioFile

@synthesize filePath;
@synthesize fileInfoDict;

- (MDAudioFile *)initWithPath:(NSURL *)path
{
	if (self = [super init]) 
	{
		self.filePath = path;
		self.fileInfoDict = [self songID3Tags];
	}
	
	return self;
}

- (NSDictionary *)songID3Tags
{	
	AudioFileID fileID = nil;
	OSStatus error = noErr;
	
	error = AudioFileOpenURL((CFURLRef)self.filePath, kAudioFileReadPermission, 0, &fileID);
	if (error != noErr) {
        NSLog(@"AudioFileOpenURL failed");
    }
	
	UInt32 id3DataSize  = 0;
    char *rawID3Tag    = NULL;
	
    error = AudioFileGetPropertyInfo(fileID, kAudioFilePropertyID3Tag, &id3DataSize, NULL);
    if (error != noErr)
        NSLog(@"AudioFileGetPropertyInfo failed for ID3 tag");
	
    rawID3Tag = (char *)malloc(id3DataSize);
    if (rawID3Tag == NULL)
        NSLog(@"could not allocate %lu bytes of memory for ID3 tag", id3DataSize);
    
    error = AudioFileGetProperty(fileID, kAudioFilePropertyID3Tag, &id3DataSize, rawID3Tag);
    if( error != noErr )
        NSLog(@"AudioFileGetPropertyID3Tag failed");
	
	UInt32 id3TagSize = 0;
    UInt32 id3TagSizeLength = 0;
	
	error = AudioFormatGetProperty(kAudioFormatProperty_ID3TagSize, id3DataSize, rawID3Tag, &id3TagSizeLength, &id3TagSize);
	
    if (error != noErr) {
        NSLog( @"AudioFormatGetProperty_ID3TagSize failed" );
        switch(error) {
            case kAudioFormatUnspecifiedError:
                NSLog( @"Error: audio format unspecified error" ); 
                break;
            case kAudioFormatUnsupportedPropertyError:
                NSLog( @"Error: audio format unsupported property error" ); 
                break;
            case kAudioFormatBadPropertySizeError:
                NSLog( @"Error: audio format bad property size error" ); 
                break;
            case kAudioFormatBadSpecifierSizeError:
                NSLog( @"Error: audio format bad specifier size error" ); 
                break;
            case kAudioFormatUnsupportedDataFormatError:
                NSLog( @"Error: audio format unsupported data format error" ); 
                break;
            case kAudioFormatUnknownFormatError:
                NSLog( @"Error: audio format unknown format error" ); 
                break;
            default:
                NSLog( @"Error: unknown audio format error" ); 
                break;
        }
    }	
	
	CFDictionaryRef piDict = nil;
    UInt32 piDataSize = sizeof(piDict);
	
    error = AudioFileGetProperty(fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &piDict);
    if (error != noErr)
        NSLog(@"AudioFileGetProperty failed for property info dictionary");
	
	free(rawID3Tag);
	
	return (NSDictionary*)piDict;
}

- (NSString *)title
{
	if ([fileInfoDict objectForKey:[NSString stringWithUTF8String:kAFInfoDictionary_Title]]) {
		return [fileInfoDict objectForKey:[NSString stringWithUTF8String:kAFInfoDictionary_Title]];
	}
	
	else {
		NSString *url = [filePath absoluteString];
		NSArray *parts = [url componentsSeparatedByString:@"/"];
		return [parts objectAtIndex:[parts count]-1];
	}
	
	return nil;
}

- (NSString *)artist
{
	if ([fileInfoDict objectForKey:[NSString stringWithUTF8String:kAFInfoDictionary_Artist]])
		return [fileInfoDict objectForKey:[NSString stringWithUTF8String:kAFInfoDictionary_Artist]];
	else
		return @"";
}

- (NSString *)album
{
	if ([fileInfoDict objectForKey:[NSString stringWithUTF8String:kAFInfoDictionary_Album]])
		return [fileInfoDict objectForKey:[NSString stringWithUTF8String:kAFInfoDictionary_Album]];
	else
		return @"";
}

- (float)duration
{
	if ([fileInfoDict objectForKey:[NSString stringWithUTF8String:kAFInfoDictionary_ApproximateDurationInSeconds]])
		return [[fileInfoDict objectForKey:[NSString stringWithUTF8String:kAFInfoDictionary_ApproximateDurationInSeconds]] floatValue];
	else
		return 0;
}

- (NSString *)durationInMinutes
{	
	return [NSString stringWithFormat:@"%d:%02d", (int)[self duration] / 60, (int)[self duration] % 60, nil];
}

- (UIImage *)coverImage
{
	return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerNoArtwork" ofType:@"png"]];
}

@end
