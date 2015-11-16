//
//  DULocalisation.m
//  DevedUp
//
//  Created by David Casserly on 28/06/2012.
//  Copyright (c) 2012 DevedUp Ltd. All rights reserved.
//

#define BUILD_STRINGS_FILE 0

#import "DULocalisation.h"

NSString * const DULocalizationMissing = @"DULocalizationMissing";

@implementation DULocalisation

+ (DULocalisation *) sharedController {
    static dispatch_once_t onceToken;
    static DULocalisation * __sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        __sharedManager = [[self alloc] init];
    });
    
    return __sharedManager;
}

+ (NSArray *) localizationTables
{
    static NSArray *tables = nil;
    if (tables == nil) {
        tables = @[@"Localizable", @"Accessibility"];
    }
    
    return tables;
}


- (NSString *) localizedString:(NSString *)string {
    if (!string || string.length == 0) {
        return @""; //don't translate blank
    }
    
    NSString *defaultValue = @"";
    // If we're in debug mode, we prefix with TRANSLATE to flag up on the UI strings we haven't tranlated.
    // I know there is a built in equivalent of this - NSShowNonLocalizedStrings - which puts them in capitals
    // You can also use NSDoubleLocalizedStrings to make them twice as long to see how your UI behaves
#if DEBUG
    defaultValue = [NSString stringWithFormat:@"TRANSLATE: %@", string];
    if ([string hasPrefix:@"TRANSLATE:"]) {
        //don't translate twice
        return string;
    }
#endif
#ifndef DEBUG
    [self.analytics logEvent:@"Missing Translation" withKey:string value:nil];
#endif

    NSBundle *bundle = [NSBundle mainBundle];
    
    //First look for a target specific string - default here is blank
    NSString *translated = [bundle localizedStringForKey:string value:DULocalizationMissing table:@"TargetSpecific"];
    if ([DULocalizationMissing isEqualToString:translated]) {
        //try the default strings file, and use default if it doesn't exist
        translated = [bundle localizedStringForKey:string value:defaultValue table:@"Localizable"];
    }
    
#if BUILD_STRINGS_FILE
    [self logStringToFile:string value:translated];
#endif
    
    return translated;
}

#if BUILD_STRINGS_FILE

- (void) logStringToFile:(NSString *)key value:(NSString *)value {
    static NSString *fileName = nil;
    static NSMutableArray *generatedAlready = nil;
    if (!fileName) {
        fileName = [self createStringsFileToBuild];
        generatedAlready = [NSMutableArray.alloc init];
        NSArray *currentFileContents = [self currentStringsTranslatedInFile:fileName];
        [generatedAlready addObjectsFromArray:currentFileContents];
    }
    
    NSString *message = [NSString stringWithFormat:@"\"%@\" = \"%@\";", key, value];
    if ([generatedAlready containsObject:message]) {
        return;
    } else {
        // Write it to the file
        NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
        [file seekToEndOfFile];
        [file writeData:[message dataUsingEncoding:NSUTF8StringEncoding]];
        [file writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [file closeFile];
        [generatedAlready addObject:message];
    }
}

- (NSArray *) currentStringsTranslatedInFile:(NSString *)file {
    NSCharacterSet *newlineCharSet = [NSCharacterSet newlineCharacterSet];
    NSString *fileContents = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:newlineCharSet];
    return lines;
}


- (NSString *) createStringsFileToBuild {
    //Get file path /Users/dave/Desktop
    NSString *directory = @"/Users/dave/Desktop";
    
    //create file if it doesn't exist
    NSString *filename = [directory stringByAppendingPathComponent:@"GeneratedStrings.strings"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:filename])
        [[NSFileManager defaultManager] createFileAtPath:filename contents:nil attributes:nil];
    
    return filename;
}

#endif

- (void) localizeViewHierarchy:(UIView *)view
{
    if ([view isKindOfClass:[UILabel class]])
    {
        UILabel *label = (UILabel*)view;
        label.text = [self localizedString:label.text];
    }
    else if ([view isKindOfClass:[UIButton class]])
    {
        UIButton *button = (UIButton*)view;
        [button setTitle:[self localizedString:[button titleForState:UIControlStateSelected]] forState:UIControlStateSelected];
        [button setTitle:[self localizedString:[button titleForState:UIControlStateDisabled]] forState:UIControlStateDisabled];
        [button setTitle:[self localizedString:[button titleForState:UIControlStateHighlighted]] forState:UIControlStateHighlighted];
        [button setTitle:[self localizedString:[button titleForState:UIControlStateNormal]] forState:UIControlStateNormal];
    }
    else if ([view isKindOfClass:[UISegmentedControl class]])
    {
        UISegmentedControl *segmentedControl = (UISegmentedControl*)view;
        for (int i = 0; i < segmentedControl.numberOfSegments; i++) {
            if (![segmentedControl imageForSegmentAtIndex:i]) {
                [segmentedControl setTitle:[self localizedString:[segmentedControl titleForSegmentAtIndex:i]] forSegmentAtIndex:i];
            }
        }
    }
    else if ([view isKindOfClass:[UITextField class]])
    {
        UITextField *textField = (UITextField*)view;
        textField.placeholder = [self localizedString:textField.placeholder];
    }
    else if ([view isKindOfClass:UITextView.class])
    {
        UITextView *textView = (UITextView *)view;
        textView.text = [self localizedString:textView.text];
    }
    
    // UIAccessibility - don't wrap in UIAccessibilityIsVoiceOverRunning() as this method runs
    // in viewDidLoad normally, so if you turn on accessibility after view loads, the strings won't
    // be loaded
    view.accessibilityLabel = [self localizedString:[view accessibilityLabel]];
    view.accessibilityHint = [self localizedString:[view accessibilityHint]];
    
    //Now do the subviews
    for (UIView *subview in [view subviews])
    {
        if (![subview isKindOfClass:UIDatePicker.class]) {
            [self localizeViewHierarchy:subview];
        }
    }
}

@end
