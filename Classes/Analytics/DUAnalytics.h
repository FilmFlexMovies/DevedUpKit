//
//  DUAnalytics.h
//  DevedUp
//
//  Created by Casserly on 30/05/2013.
//
//

@protocol DUAnalytics <NSObject>

- (void) logEvent:(NSString *)event withParameters:(NSDictionary *)params;
- (void) logEvent:(NSString *)event;
- (void) logEvent:(NSString *)event withKey:(NSString *)key value:(NSString *)value;

- (void) logPageView:(NSString *)page;

- (void) logError:(NSString *)error message:(NSString *)message error:(NSError *)error;
- (void) logError:(NSString *)errorID message:(NSString *)message exception:(NSException *)exception;

@end
