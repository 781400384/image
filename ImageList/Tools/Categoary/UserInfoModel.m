//
//  UserInfoModel.m
//  ClassSchedule
//
//  Created by Superme on 2019/10/24.
//  Copyright © 2019 Superme. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    self = [super init];
    if (self) {
        
      
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.token=[aDecoder decodeObjectForKey:@"token"];
        self.birthday=[aDecoder decodeObjectForKey:@"birthday"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
   
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
  
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
   
    [aCoder encodeObject:self.token forKey:@"token"];
    
  [aCoder encodeObject:self.birthday forKey:@"birthday"];

}





@end
