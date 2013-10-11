//
//  MediaPlayer.m
//  DevedUp
//
//  Created by David Casserly on 19/09/2009.
//  Copyright 2010 devedup.com. All rights reserved.
//



#import "DUMediaPlayer.h"
#import "UIAlertView+Extensions.h"


@implementation DUMediaPlayer

@synthesize isPlaying;
@synthesize mediaPlayerController;

#pragma mark -
#pragma mark Release


- (id) init {
	if (self = [super init]) {		
		#if (TARGET_IPHONE_SIMULATOR)

		#else
			mediaPlayerController = [MPMusicPlayerController applicationMusicPlayer];
			[mediaPlayerController setShuffleMode:MPMusicShuffleModeOff];
			//[mediaPlayerController setRepeatMode:MPMusicRepeatModeAll];
		#endif
	}
	return self;
}


- (void) playMediaItem:(MPMediaItem *)mediaItem {	
	NSArray *items = @[mediaItem];
	MPMediaItemCollection *collection = [[MPMediaItemCollection alloc] initWithItems:items];
	[mediaPlayerController setQueueWithItemCollection:collection];
	[mediaPlayerController play];
	isPlaying = YES;
}

- (void) stopPlayingCurrentItem {
	[mediaPlayerController stop];
	isPlaying = NO;
}

- (MPMediaItem *) loadSongFromLibraryWithID:(NSNumber *)songId {
#if (TARGET_IPHONE_SIMULATOR)
	return nil;
#else
	
	if (!songId) {
		//show warning - 
		[UIAlertView showAlert:@"You haven't chosen a song to play from the song menu"];
		return nil;
	} else {
		MPMediaPropertyPredicate *songIdPredicate = [MPMediaPropertyPredicate predicateWithValue:songId
																					 forProperty:MPMediaItemPropertyPersistentID];
		
		MPMediaQuery *songQuery = [[MPMediaQuery alloc] init];
		[songQuery addFilterPredicate:songIdPredicate];
		
		NSArray *itemsFromIdQuery = [songQuery items];
		if(itemsFromIdQuery && [itemsFromIdQuery count] > 0 ) {
			MPMediaItem *song = [itemsFromIdQuery objectAtIndex:0];
			return song;
		}else {
			//nothing was found!!
			return nil;
		}
	}
	
	
#endif
}

@end


