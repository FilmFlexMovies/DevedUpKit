//
//  DUCollectionViewFlowLayout.m
//  DevedUpKit
//
//  Created by David Casserly on 18/02/2014.
//  Copyright (c) 2014 DevedUp. All rights reserved.
//

#import "DUCollectionViewFlowLayout.h"

@implementation DUCollectionViewFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *newAttributes = [NSMutableArray arrayWithCapacity:attributes.count];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        if ((attribute.frame.origin.x + attribute.frame.size.width <= self.collectionViewContentSize.width) &&
            (attribute.frame.origin.y + attribute.frame.size.height <= self.collectionViewContentSize.height)) {
            [newAttributes addObject:attribute];
        }
    }
    return newAttributes;
}

@end
