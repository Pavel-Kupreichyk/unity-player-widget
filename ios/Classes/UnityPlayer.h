//
//  UnityPlayer.h
//  unity_player_widget
//
//  Created by Pavel Kupreichyk on 2/27/20.
//

#import <UIKit/UIKit.h>

@interface UnityPlayer : NSObject

+ (void)initUnityPlayer: (int)argc argv: (char**)argv pauseDelay: (int)delay;

+ (void)addViewId: (int64_t)viewId;

+ (void)removeViewId: (int64_t)viewId;

+ (UIView*)getUnityView;

+ (int)getPauseDelay;

+ (void)sendMessageToUnityObject: (NSString*)object function: (NSString*)function message: (NSString*) message;

@end
