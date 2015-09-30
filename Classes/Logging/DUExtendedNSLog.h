//
//  DUExtendedNSLog.h
//  DevedUpKit
//
//  Created by David Casserly on 30/09/2015.
//  Copyright © 2015 DevedUp. All rights reserved.
//

#import <Foundation/Foundation.h>

#if defined(DEBUG) || defined(ENTERPRISE)
    #define NSLog(args...) DUExtendedNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#else
    #define NSLog(x...)
#endif

void DUExtendedNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...);

