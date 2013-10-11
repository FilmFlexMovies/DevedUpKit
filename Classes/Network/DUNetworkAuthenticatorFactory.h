//
//  DUNetworkAuthenticatorFactory.h
//
//  Created by Casserly on 30/04/2013.
//

@protocol DUNetworkAuthenticator <NSObject>
- (void) authenticationHeaderForURLRequest:(NSMutableURLRequest *)request;
@end

@interface DUNetworkAuthenticatorFactory : NSObject

+ (id<DUNetworkAuthenticator>) defaultAuthenticator;

@end
