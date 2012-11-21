
// From Three20
#define HHLOGLEVEL_INFO     1
#define HHLOGLEVEL_WARNING  3
#define HHLOGLEVEL_ERROR    5

#ifndef HHMAXLOGLEVEL
    #define HHMAXLOGLEVEL HHLOGLEVEL_WARNING
#endif

// ##################################  Debug  ##################################
// The general purpose logger. This ignores logging levels.
#ifdef DEBUG
    #define HHDPRINT(xx, ...)  NSLog(@"打印开始: %s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#elif RELEASE
    #define HHDPRINT(xx, ...)  NSLog(@"打印开始: %s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define HHDPRINT(xx, ...)  ((void)0)
#endif // #ifdef DEBUG

// Prints the current method's name.
#define HHDPRINTMETHODNAME() HHDPRINT(@"%s", __PRETTY_FUNCTION__)

// Debug-only assertions.
#ifdef DEBUG

#import <TargetConditionals.h>

#if TARGET_IPHONE_SIMULATOR

  int HHIsInDebugger();
  // We leave the __asm__ in this macro so that when a break occurs, we don't have to step out of
  // a "breakInDebugger" function.
  #define HHDASSERT(xx) { if(!(xx)) { HHDPRINT(@"HHDASSERT failed: %s", #xx); \
                                      if(HHIsInDebugger()) { __asm__("int $3\n" : : ); }; } \
                        } ((void)0)
#else
  #define HHDASSERT(xx) { if(!(xx)) { HHDPRINT(@"HHDASSERT failed: %s", #xx); } } ((void)0)
#endif // #if TARGET_IPHONE_SIMULATOR

#else
  #define HHDASSERT(xx) ((void)0)
#endif // #ifdef DEBUG

// Log-level based logging macros.
#if HHLOGLEVEL_ERROR <= HHMAXLOGLEVEL
  #define HHDERROR(xx, ...)  HHDPRINT(xx, ##__VA_ARGS__)
#else
  #define HHDERROR(xx, ...)  ((void)0)
#endif // #if HHLOGLEVEL_ERROR <= HHMAXLOGLEVEL

#if HHLOGLEVEL_WARNING <= HHMAXLOGLEVEL
  #define HHDWARNING(xx, ...)  HHDPRINT(xx, ##__VA_ARGS__)
#else
  #define HHDWARNING(xx, ...)  ((void)0)
#endif // #if HHLOGLEVEL_WARNING <= HHMAXLOGLEVEL

#if HHLOGLEVEL_INFO <= HHMAXLOGLEVEL
  #define HHDINFO(xx, ...)  HHDPRINT(xx, ##__VA_ARGS__)
#else
  #define HHDINFO(xx, ...)  ((void)0)
#endif // #if HHLOGLEVEL_INFO <= HHMAXLOGLEVEL

#ifdef DEBUG
  #define HHDCONDITIONLOG(condition, xx, ...) { if ((condition)) { \
                                                  HHDPRINT(xx, ##__VA_ARGS__); \
                                                } \
                                              } ((void)0)
#else
  #define HHDCONDITIONLOG(condition, xx, ...) ((void)0)
#endif // #ifdef DEBUG
