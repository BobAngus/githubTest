
#import "HHDebug.h"

#define kBufferDurationSeconds .5

// Device
#define kDeviceIPhone3G @"iPhone1,2"
#define kDeviceIPhone3GS @"iPhone2,1"
#define kDeviceIPhone4 @"iPhone3,1"
#define kDeviceVerizonIPhone4 @"iPhone3,3"

#define kDeviceIpod2G @"iPod2,1"
#define kDeviceIpod3G @"iPod3,1"
#define kDeviceIpod4G @"iPod4,1"

// ################################  不提倡使用的变量  #############################################
#define __HHDEPRECATED __attribute__((deprecated))


// ##################################  Release  ################################
#define HHRELEASE(property) { \
    [property release]; \
    property = nil; \
}

// ##############################  Notification  ###############################
// Notification name
#define kNotificationScheduleCRUD @"kNotificationScheduleCRUD"
#define kNotificationRefreshDetail @"kNotificationRefreshDetail"
#define kNotificationLoginSucsess @"kNotificationLoginSucsess"
#define kNotificationAddressBookSyncComplete @"kNotificationAddressBookSyncComplete"
#define kNotificationScheduleSyncComplete @"kNotificationScheduleSyncComplete"
#define kNotificationLogOutSuccess @"kNotificationLogOutSuccess"


// ##################################  Color  ##################################
#ifndef HHColor
    #define HHColor(r, g, b, al) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:al] 
#endif

// ###################################  PATH  ##################################
#define kHHDirectory [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, \
NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString: @"/hhere/"]

// ################################  SINGLETON  ################################
// about the - (oneway void)release {}
//http://stackoverflow.com/questions/5494981/use-case-of-oneway-void-in-objective-c
#define SINGLETON_INTERFACE(CLASSNAME)  \
+ (CLASSNAME *)shared;\
- (void)forceRelease;

#define SINGLETON_IMPLEMENTATION(CLASSNAME)         \
\
static CLASSNAME* g_shared##CLASSNAME = nil;        \
\
+ (CLASSNAME*)shared                                \
{                                                   \
    if (g_shared##CLASSNAME != nil) {                   \
        return g_shared##CLASSNAME;                         \
    }                                                   \
\
    @synchronized(self) {                               \
        if (g_shared##CLASSNAME == nil) {                   \
            g_shared##CLASSNAME = [[self alloc] init];      \
        }                                                   \
    }                                                       \
\
    return g_shared##CLASSNAME;                             \
}                                                           \
\
+ (id)allocWithZone:(NSZone*)zone                           \
{                                                           \
    @synchronized(self) {                                   \
        if (g_shared##CLASSNAME == nil) {                   \
            g_shared##CLASSNAME = [super allocWithZone:zone];    \
            return g_shared##CLASSNAME;                         \
        }                                                   \
    }                                                   \
    NSAssert(NO, @ "[" #CLASSNAME                       \
        " alloc] explicitly called on singleton class.");   \
    return nil;                                         \
}                                                   \
\
- (id)copyWithZone:(NSZone*)zone                    \
{                                                   \
    return self;                                        \
}                                                   \
\
- (id)retain                                        \
{                                                   \
    return self;                                        \
}                                                   \
\
- (oneway void)release                                     \
{                                                   \
}                                                   \
\
- (void)forceRelease {                              \
    NSLog(@"Force release "#CLASSNAME"");               \
    @synchronized(self) {                               \
        if (g_shared##CLASSNAME != nil) {                   \
            g_shared##CLASSNAME = nil;                          \
        }                                                   \
    }                                                   \
    [super release];                                    \
}                                                   \
\
- (id)autorelease {                                                   \
    return self;                                        \
}

//#import "HHUtil.h"
//#import "HHThemesManager.h"
