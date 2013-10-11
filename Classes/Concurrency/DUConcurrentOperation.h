//
//  DUConcurrentOperation.h
//  FilmFlexMovies
//
//  Created by Casserly on 19/04/2013.
//  Copyright (c) 2013 FilmFlex Movies Ltd. All rights reserved.
//

/**
    
    This operation object will live on after you create a asyn network connection.
    i.e. A usual operation would die if you spawn a background thread
 
 */
@interface DUConcurrentOperation : NSOperation

- (void) finish;

@end

/*
	Usage... overide finish and start:
 
 - (void) start {
	if ([self isCancelled]) {
		// Must move the operation to the finished state if it is canceled.
		[self finish];
		return;
	}
	[super start];

 
	//do your stuff...
 }
 
 - (void) finish {
	
	//do your stuff...
 
	[super finish];
 }
 
 */
