//
//  UIToolbar+Extensions.m
//  DevedUp
//
//  Created by David Casserly on 05/12/2011.
//  Copyright (c) 2011 Ground Floor. All rights reserved.
//

#import "UIToolbar+Extensions.h"
#import <objc/runtime.h>

// Keep track of default implementation
//static void (*_origDrawRect)(id, SEL, CGRect);
//static void (*_origDrawLayerInContext)(id, SEL, CALayer*, CGContextRef);





@implementation UIToolbar (Extensions)

//// Override for drawRect:
//static void OverrideDrawRect(UIToolbar *self, SEL _cmd, CGRect r) {
//    if ( [[self tintColor] isEqual:[UIColor clearColor]] ) {
//        // Do nothing
//    } else {
//        // Call default method
//        _origDrawRect(self, _cmd, r);
//    }
//}
//
//// Override for drawLayer:inContext:
//static void OverrideDrawLayerInContext(UIToolbar *self, SEL _cmd, CALayer *layer, CGContextRef context) {
//    if ( [[self tintColor] isEqual:[UIColor clearColor]] ) {
//        // Do nothing
//    } else {
//        // Call default method
//        _origDrawLayerInContext(self, _cmd, layer, context);
//    }
//}
//
//+ (void)load {
//    // Replace methods, keeping originals
//    Method origMethod = class_getInstanceMethod(self, @selector(drawRect:));
//    _origDrawRect = (void *)method_getImplementation(origMethod);
//    
//    if(!class_addMethod(self, @selector(drawRect:), (IMP)OverrideDrawRect, method_getTypeEncoding(origMethod)))
//        method_setImplementation(origMethod, (IMP)OverrideDrawRect);
//    
//    origMethod = class_getInstanceMethod(self, @selector(drawLayer:inContext:));
//    _origDrawLayerInContext = (void *)method_getImplementation(origMethod);
//    
//    if(!class_addMethod(self, @selector(drawLayer:inContext:), (IMP)OverrideDrawLayerInContext, method_getTypeEncoding(origMethod)))
//        method_setImplementation(origMethod, (IMP)OverrideDrawLayerInContext);
//}

@end
