//
//  MediaPlayer.h
//  DevedUp
//
//  Created by David Casserly on 19/09/2009.
//  Copyright 2010 devedup.com. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>


@interface DUMediaPlayer : NSObject {

	MPMusicPlayerController *mediaPlayerController;
	
	BOOL isPlaying;
}

@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) MPMusicPlayerController *mediaPlayerController;

- (void) playMediaItem:(MPMediaItem *)mediaItem;
- (void) stopPlayingCurrentItem;
- (MPMediaItem *) loadSongFromLibraryWithID:(NSNumber *)songId;

@end

