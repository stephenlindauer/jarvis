//
//  JiTunesController.m
//  Jarvis
//
//  Created by Frank on 5/15/16.
//  Copyright © 2016 Lindauer, LLC. All rights reserved.
//

#import "JiTunesController.h"
#import "iTunes.h"


@implementation JiTunesController

+ (void)getPlayback
{
    iTunesApplication* iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];

    NSLog(@"playback: %f", iTunes.playerPosition);
    
    iTunes.playerPosition = 50;
    [iTunes playpause];
    
    // check if iTunes is running (Q1)
    if ([iTunes isRunning])
    {
//        // pause iTunes if it is currently playing (Q2 and Q3)
//        if (iTunesEPlSPlaying == [iTunes playerState])
//            [iTunes playpause];
//        
//        // do your stuff
//        
//        // start playing again (Q4)
//        [iTunes playpause];
    }

}

@end
