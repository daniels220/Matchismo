//
//  MGSetGame.h
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGGame.h"

@interface MGSetGame : MGGame

@property (nonatomic,readwrite) NSInteger score;
-(NSArray*)findSet;

@end
