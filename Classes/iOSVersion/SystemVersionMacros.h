//
//  SystemVersionMacros.h
//  FilmFlexMovies
//
//  Created by Casserlys on 17/07/2012.
//  Copyright (c) 2012 FilmFlex Movies Ltd. All rights reserved.
//

#ifndef FilmFlexMovies_SystemVersionMacros_h
#define FilmFlexMovies_SystemVersionMacros_h

/*
 *  System Versioning Preprocessor Macros
 */ 

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define iOS_7_or_later SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#define iOS_6 SYSTEM_VERSION_LESS_THAN(@"7.0")

/*
 *  Usage
  

if (SYSTEM_VERSION_LESS_THAN(@"4.0")) {
    ...
}

if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"3.1.1")) {
    ...
}
*/

#endif
