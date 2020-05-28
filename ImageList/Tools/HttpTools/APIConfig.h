//
//  APIConfig.h
//  ClassSchedule
//
//  Created by Superme on 2019/10/25.
//  Copyright © 2019 Superme. All rights reserved.
//

#ifndef APIConfig_h
#define APIConfig_h

#define  BaseURL             @"http://kcb-api.qianr.com/finepic_v1"
#define  LoginBase           @"https://ubase.qianr.com/api/public/?service=CommonLogin.userLogin"
#define  NET_CACHE           @"NetCache"
#define API_UPLOAD_AVATAR    @"https://ubase.qianr.com/api/public/?service=user.updateAvatar" //上传头像


#define API_GET_TYPE                @"/ftype/list"  //首页获取分类
#define API_GET_IMAGE               @"/fimage/list" //首页获取图片
#define API_ADD_COLLECT             @"/fimage/favorite"//添加收藏
#define API_GET_COLLECT_LIST        @"/ffavorite/list" //获取收藏列表
#define API_CANEL_COLLECT           @"/ffavorite/remove-favorite" //取消收藏
#define API_GET_KEYWORDS_LIST       @"/fkeyword/list" //获取关键字列表
#define API_JUDGE_IMAGE             @"/fimage/is-favorite"   //判断图片是否收藏

#endif /* APIConfig_h */
