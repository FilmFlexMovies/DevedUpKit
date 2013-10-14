//
//  DUBlocks.h
//  FilmFlexMovies
//
//  Created by Casserly on 23/04/2013.
//  Copyright (c) 2013 FilmFlex Movies Ltd. All rights reserved.
//

typedef void (^BasicBlock)(void);
typedef void (^BasicBlockWithError)(NSError *error);

void executeBlockOnThread(NSThread *thread, BasicBlock block);
