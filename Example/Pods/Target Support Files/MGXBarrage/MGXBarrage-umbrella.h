#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MGXBarrageView.h"
#import "MGXBarrageCellDescriptor.h"
#import "MGXBarrageDisplay.h"
#import "MGXViewReusePool.h"
#import "MGXViewReusePoolManager.h"
#import "MGXBarrageTrackView.h"

FOUNDATION_EXPORT double MGXBarrageVersionNumber;
FOUNDATION_EXPORT const unsigned char MGXBarrageVersionString[];

