//
//  WeCenterClientApi.m
//  wcapi
//
//  Created by 吴忠信 on 16/1/7.
//  Copyright © 2016年 吴忠信. All rights reserved.
//

#import "WeCenterClientApi.h"
#import "AFNetworking.h"

@implementation WeCenterClientApi

-(AFHTTPSessionManager*)manager{//AFN对象单例,保证cookie和session的一致性
    if(!_manager){
        _manager = [AFHTTPSessionManager manager];
    }
    
    return _manager;
}

- (void)weCenterRegisterWithUserName:(NSString*)userName
                password:(NSString*)password
                   email:(NSString*)email
                   icode:(NSString*)icode
                 success:(void(^)(WeCenterUserInfo* userInfo))success
                 failure:(void(^)(NSError* error))failure{
    NSString * url = register_rest(wecenter_host, wecenter_sign);
    
    NSDictionary *params = @{@"user_name": userName, @"password": password, @"email": email, @"icode": icode};
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            WeCenterUserInfo * userInfo = [[WeCenterUserInfo alloc] init];
            userInfo.uid = [rsmObj[@"uid"] integerValue];
            userInfo.userName = rsmObj[@"user_name"];
            userInfo.validEmail = [rsmObj[@"valid_email"] integerValue];
            
            success(userInfo);
        }
        else{//failure
            NSString * err = responseJson[@"err"];
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

- (void)weCenterLoginWithUserName:(NSString*)userName
             password:(NSString*)password
              success:(void(^)(WeCenterUserInfo* userInfo))success
              failure:(void(^)(NSError* error))failure{
    
    NSString* url = [NSString stringWithFormat:@"%@%@%@",wecenter_host, login_rest, wecenter_sign];
    
    NSDictionary *params = @{@"user_name": userName, @"password": password};
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            WeCenterUserInfo * userInfo = [[WeCenterUserInfo alloc] init];
            userInfo.uid = [rsmObj[@"uid"] integerValue];
            userInfo.userName = rsmObj[@"user_name"];
            userInfo.avatarFile = rsmObj[@"avatar_file"];
            userInfo.isFirstLogin = [rsmObj[@"is_first_login"] integerValue];
            userInfo.validEmail = [rsmObj[@"valid_email"] integerValue];
            
            success(userInfo);
        }
        else{//failure
            NSString * err = responseJson[@"err"];
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterLogout:(void(^)())success
               failure:(void(^)(NSError* error))failure{
    NSString * url = logout_rest(wecenter_host, wecenter_sign);
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            success();
        }
        else{//failure
            NSString * err = responseJson[@"err"];
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


- (void)weCenterGetUserInfoWithId:(NSInteger)uid
                    success:(void(^)(WeCenterUserInfo* userInfo))success
                    failure:(void(^)(NSError* error))failure{
    NSString * url = get_user_rest(wecenter_sign, uid);
    url = [NSString stringWithFormat:@"%@%@", wecenter_host, url];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            WeCenterUserInfo * userInfo = [[WeCenterUserInfo alloc] init];
            
            userInfo.uid = [rsmObj[@"uid"] integerValue];
            userInfo.userName = rsmObj[@"user_name"];
            userInfo.avatarFile = rsmObj[@"avatar_file"];
            userInfo.sex = [rsmObj[@"sex"] integerValue];
            userInfo.signature = rsmObj[@"signature"];
            userInfo.province = rsmObj[@"province"];
            userInfo.city = rsmObj[@"city"];
            userInfo.fansCount = [rsmObj[@"fans_count"] integerValue];
            userInfo.friendCount = [rsmObj[@"friend_count"] integerValue];
            userInfo.articleCount = [rsmObj[@"article_count"] integerValue];
            userInfo.questionCount = [rsmObj[@"question_count"] integerValue];
            userInfo.answerCount = [rsmObj[@"answer_count"] integerValue];
            userInfo.topicFocusCount = [rsmObj[@"topic_focus_count"] integerValue];
            userInfo.agreeCount = [rsmObj[@"agree_count"] integerValue];
            userInfo.thanksCount = [rsmObj[@"thanks_count"] integerValue];
            userInfo.viewsCount = [rsmObj[@"views_count"] integerValue];
            userInfo.answerFavoriteCount = [rsmObj[@"answer_favorite_count"] integerValue];
            userInfo.hasFocus = [rsmObj[@"has_focus"] integerValue];

            success(userInfo);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterGetCurrentUserId:(void(^)(NSInteger uid))success
                         failure:(void(^)(NSError * error))failure{
    NSString * url = get_uid_rest(wecenter_host, wecenter_sign);
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSInteger uid = [rsmObj[@"uid"] integerValue];
            success(uid);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterUploadAvatar:(NSData *)imageData
                     success:(void(^)(NSString * previewAvatar))success
                     failure:(void(^)(NSError * error))failure{

    NSString * url = upload_avatar_rest(wecenter_host, wecenter_sign);
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [self.manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"user_avatar" fileName:@"user_avatar.png" mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSLog(@"weCenterUploadAvatar: %@", responseJson);
            NSString * previewAvatar = responseJson[@"rsm"][@"preview"];
            success(previewAvatar);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterModifyPassword:(NSString*)oldPassword
                   newPassword:(NSString*)newPassword
             repeatNewPassword:(NSString*)repeatNewPassword
                       success:(void(^)())success
                       failure:(void(^)(NSError * error))failure{
    NSString * url = modify_password_rest(wecenter_host, wecenter_sign);
    NSDictionary *params = @{@"old_password": oldPassword, @"password": newPassword, @"re_password": repeatNewPassword};
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            success();
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterFollowUserWithId:(NSInteger)uid
                   success:(void(^)(NSString * type))success
                   failure:(void(^)(NSError * error))failure{
    NSString * url = follow_rest(wecenter_host, wecenter_sign);
    NSString * uidStr = [NSString stringWithFormat: @"%ld", (long)uid];
    NSDictionary *params = @{@"uid": uidStr};
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSString * type = rsmObj[@"type"];
            success(type);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterGetFollowsOrFansWithId:(NSInteger)uid
                            type:(NSString*)type
                            page:(NSInteger)page
                         perPage:(NSInteger)perPage
                         success:(void(^)(NSArray * infos))success
                         failure:(void(^)(NSError * error))failure{
    NSString * url = get_follows_fans_rest(wecenter_host, wecenter_people_sign);
    url = [NSString stringWithFormat:@"%@&uid=%ld&type=%@&page=%ld&per_page=%ld", url, (long)uid, type, (long)page, (long)perPage];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSArray * items = rsmObj[@"rows"];
            NSMutableArray * infos = [[NSMutableArray alloc] init];
            if(![items isKindOfClass:[NSArray class]]){
                success(infos);
                return;
            }
            
            for (NSDictionary * item in items) {
                
                WeCenterFollowInfo * info = [[WeCenterFollowInfo alloc] init];
                info.uid = [item[@"uid"] integerValue];
                info.userName = item[@"user_name"];
                info.agreeCount = [item[@"agree_count"] integerValue];
                info.thanksCount = [item[@"thanks_count"] integerValue];
                info.reputation = [item[@"reputation"] integerValue];
                info.signature = item[@"signature"];
                info.avatarFile = item[@"avatar_file"];
                [infos addObject:info];
            }
            success(infos);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


- (void)weCenterGetFollowTopicsWithId:(NSInteger)uid
                           page:(NSInteger)page
                        perPage:(NSInteger)perPage
                        success:(void(^)(NSArray * infos))success
                        failure:(void(^)(NSError * error))failure{
    
    NSString * url = follow_topics_rest(wecenter_host, wecenter_people_sign);
    url = [NSString stringWithFormat:@"%@&uid=%ld&page=%ld&per_page=%ld", url, (long)uid, (long)page, (long)perPage];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSArray * items = rsmObj[@"rows"];
            NSMutableArray * infos = [[NSMutableArray alloc] init];
            if(![items isKindOfClass:[NSArray class]]){
                success(infos);
                return;
            }
            for (NSDictionary * item in items) {
                WeCenterTopicInfo * info = [[WeCenterTopicInfo alloc] init];
                
                info.topicId = [item[@"topic_id"] integerValue];
                info.topicTitle = item[@"topic_title"];
                info.addTime = item[@"add_time"];
                info.discussCount = [item[@"discuss_count"] integerValue];
                info.topicDescription = item[@"topic_description"];
                info.topicPic = item[@"topic_pic"];
                info.topicLock = [item[@"topic_lock"] integerValue];
                info.focusCount = [item[@"focus_count"] integerValue];
                info.userRelated = [item[@"user_related"] integerValue];
                info.urlToken = item[@"url_token"];
                info.mergedId = [item[@"merged_id"] integerValue];
                info.seoTitle = item[@"seo_title"];
                info.parentId = [item[@"parent_id"] integerValue];
                info.isParent = [item[@"is_parent"] integerValue];
                info.discussCountLastWeek = [item[@"discuss_count_last_week"] integerValue];
                info.discussCountLastMonth = [item[@"discuss_count_last_month"] integerValue];
                info.discussCountUpdate = item[@"discuss_count_update"];
                info.hasFocus = [item[@"has_focus"] integerValue];
                
                [infos addObject:info];
            }
            success(infos);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


- (void)weCenterGetUserContentsWithId:(NSInteger)uid
                        actions:(NSInteger)actions
                           page:(NSInteger)page
                        perPage:(NSInteger)perPage
                        success:(void(^)(NSArray * infos))success
                        failure:(void(^)(NSError * error))failure{
    
    NSString * url = user_actions_rest(wecenter_host, wecenter_people_sign);
    url = [NSString stringWithFormat:@"%@&uid=%ld&actions=%ld&page=%ld&per_page=%ld", url, (long)uid, (long)actions, (long)page, (long)perPage];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSArray * items = rsmObj[@"rows"];
            NSMutableArray * infos = [[NSMutableArray alloc] init];
            if(![items isKindOfClass:[NSArray class]]){
                success(infos);
                return;
            }
            for (NSDictionary * item in items) {
                if(501 == actions){//文章
                    WeCenterUserArticleInfo * info = [[WeCenterUserArticleInfo alloc] init];
                    WeCenterArticleInfo * articleInfo = [[WeCenterArticleInfo alloc] init];
                    NSDictionary * dictInfo = item[@"article_info"];
                    info.historyId = [item[@"history_id"] integerValue];
                    info.associateAction = [item[@"associate_action"] integerValue];
                    info.addTime = item[@"add_time"];
                    articleInfo.aid = [dictInfo[@"id"] integerValue];
                    articleInfo.addTime = dictInfo[@"add_time"];
                    articleInfo.title = dictInfo[@"title"];
                    articleInfo.message = dictInfo[@"message"];
                    articleInfo.views = [dictInfo[@"view"] integerValue];
                    articleInfo.comments = [dictInfo[@"comments"] integerValue];
                    info.articleInfo = articleInfo;
                    
                    [infos addObject:info];
                }
                if(101 == actions){//问题
                    WeCenterUserQuestionInfo * info = [[WeCenterUserQuestionInfo alloc] init];
                    WeCenterQuestionInfo * questionInfo = [[WeCenterQuestionInfo alloc] init];
                    NSDictionary * dictInfo = item[@"question_info"];
                    info.historyId = [item[@"history_id"] integerValue];
                    info.associateAction = [item[@"associate_action"] integerValue];
                    info.addTime = item[@"add_time"];
                    questionInfo.questionContent = dictInfo[@"question_content"];
                    questionInfo.addTime = dictInfo[@"add_time"];
                    questionInfo.answerCount = [dictInfo[@"answer_count"] integerValue];
                    questionInfo.questionId = [dictInfo[@"question_id"] integerValue];
                    questionInfo.agreeCount = [dictInfo[@"agree_count"] integerValue];
                    questionInfo.updateTime = dictInfo[@"update_time"];
                    info.questionInfo = questionInfo;
                    [infos addObject:info];
                }
                if(201 == actions){//回答
                    WeCenterUserAnswerInfo * info = [[WeCenterUserAnswerInfo alloc] init];
                    WeCenterAnswerInfo * answerInfo = [[WeCenterAnswerInfo alloc] init];
                    NSDictionary * dictInfo = item[@"answer_info"];
                    info.historyId = [item[@"history_id"] integerValue];
                    info.associateAction = [item[@"associate_action"] integerValue];
                    info.addTime = item[@"add_time"];
                    answerInfo.answerId = [dictInfo[@"answer_id"] integerValue];
                    answerInfo.answerContent = dictInfo[@"answer_content"];
                    answerInfo.againstCount = [dictInfo[@"against_count"] integerValue];
                    answerInfo.agreeCount = [dictInfo[@"agree_count"] integerValue];
                    answerInfo.addTime = dictInfo[@"add_time"];
                    answerInfo.questionId = [item[@"question_info"][@"question_id"] integerValue];
                    info.answerInfo = answerInfo;
                    
                    [infos addObject:info];
                }
            }
            success(infos);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterSetUserProfile:(NSDictionary *)param
                       success:(void(^)())success
                       failure:(void(^)(NSError * error))failure{
    NSString * url = profile_setting_rest(wecenter_host, wecenter_people_sign);
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            success();
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterExplore:(NSInteger)page
                perPage:(NSInteger)perPage
                topicId:(NSInteger)topicId
                    day:(NSInteger)day
            isRecommend:(NSInteger)isRecommend
               sortType:(NSString*)sortType
                success:(void(^)(NSArray * infos))success
                failure:(void(^)(NSError * error))failure{
    
    NSString * url = explore_rest(wecenter_host, wecenter_explore_sign);
    url = [NSString stringWithFormat:@"%@&page=%ld&per_page=%ld&day=%ld&sort_type=%@&topic_id=%ld", url, (long)page, (long)perPage, (long)day, sortType, (long)topicId];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSArray * items = rsmObj[@"rows"];
            NSMutableArray * infos = [[NSMutableArray alloc] init];
            if(![items isKindOfClass:[NSArray class]]){
                success(infos);
                return;
            }
            if(![items isKindOfClass:[NSArray class]]){
                success(infos);
                return;
            }
            for (NSDictionary * item in items) {
                NSString * postType = item[@"post_type"];
                if([postType isEqualToString:@"question"]){
                    WeCenterQuestionInfo * info = [[WeCenterQuestionInfo alloc] init];
                    info.postType = postType;
                    info.questionId = [item[@"question_id"] integerValue];
                    info.questionContent = item[@"question_content"];
                    info.answerCount = [item[@"answer_count"] integerValue];
                    info.againstCount = [item[@"against_count"] integerValue];
                    info.agreeCount = [item[@"agree_count"] integerValue];
                    info.viewCount = [item[@"view_count"] integerValue];
                    info.addTime = item[@"add_time"];
                    
                    WeCenterUserInfo * userInfo = [[WeCenterUserInfo alloc] init];
                    NSDictionary * dictUserInfo = item[@"user_info"];
                    userInfo.uid = [dictUserInfo[@"uid"] integerValue];
                    userInfo.userName = dictUserInfo[@"user_name"];
                    userInfo.avatarFile = dictUserInfo[@"avatar_file"];
                    info.userInfo = userInfo;
                    
                    NSMutableArray * topics = [[NSMutableArray alloc] init];
                    NSArray * topicInfoList = item[@"topics"];
                    if(![topicInfoList isEqual:[NSNull null]]){
                        for(NSDictionary * topicItem in topicInfoList){
                            WeCenterTopicInfo * topicInfo = [[WeCenterTopicInfo alloc] init];
                            topicInfo.topicId = [topicItem[@"topic_id"] integerValue];
                            topicInfo.topicTitle = topicItem[@"topic_title"];
                            
                            [topics addObject:topicInfo];
                        }
                        info.topics = topics;
                    }
                    
                    NSMutableArray * answerUsers = [[NSMutableArray alloc] init];
                    NSArray * answerUserInfoList = item[@"answer_users"];
                    if(![answerUserInfoList isEqual:[NSNull null]]){
                        for(NSDictionary * answerUserItem in answerUserInfoList){
                            WeCenterUserInfo * userInfo = [[WeCenterUserInfo alloc] init];
                            userInfo.uid = [answerUserItem[@"uid"] integerValue];
                            userInfo.userName = answerUserItem[@"user_name"];
                            userInfo.avatarFile = answerUserItem[@"avatar_file"];
                            [answerUsers addObject:userInfo];
                        }
                    }
                    
                    info.answerUsers = answerUsers;
                    [infos addObject:info];
                }
                if([postType isEqualToString:@"article"]){
                    WeCenterArticleInfo * info = [[WeCenterArticleInfo alloc] init];
                    info.postType = postType;
                    info.aid = [item[@"id"] integerValue];
                    info.votes = [item[@"vote"] integerValue];
                    info.title = item[@"title"];
                    info.message = item[@"message"];
                    WeCenterUserInfo * userInfo = [[WeCenterUserInfo alloc] init];
                    NSDictionary * dictUserInfo = item[@"user_info"];
                    userInfo.uid = [dictUserInfo[@"uid"] integerValue];
                    userInfo.userName = dictUserInfo[@"user_name"];
                    userInfo.avatarFile = dictUserInfo[@"avatar_file"];
                    info.userInfo = userInfo;
                    info.views = [dictUserInfo[@"views"] integerValue];
                    info.addTime = dictUserInfo[@"add_time"];
                    info.answerUsers = dictUserInfo[@"answer_users"];
                    NSMutableArray * topics = [[NSMutableArray alloc] init];
                    NSArray * topicInfoList = item[@"topics"];
                    if(![topicInfoList isEqual:[NSNull null]]){
                        for(NSDictionary * topicItem in topicInfoList){
                            WeCenterTopicInfo * topicInfo = [[WeCenterTopicInfo alloc] init];
                            topicInfo.topicId = [topicItem[@"topic_id"] integerValue];
                            topicInfo.topicTitle = topicItem[@"topic_title"];
                            
                            [topics addObject:topicInfo];
                        }
                    }
                    
                    info.topics = topics;
                    [infos addObject:info];
                }
            }

            success(infos);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterHome:(NSInteger)page
             perPage:(NSInteger)perPage
             success:(void(^)(NSArray * infos))success
             failure:(void(^)(NSError * error))failure{
    NSString * url = home_rest(wecenter_host, wecenter_home_sign);
    url = [NSString stringWithFormat:@"%@&page=%ld&per_page=%ld", url, (long)page, (long)perPage];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSArray * items = rsmObj[@"rows"];
            NSMutableArray * infos = [[NSMutableArray alloc] init];
            if(![items isKindOfClass:[NSArray class]]){
                success(infos);
                return;
            }
            
            for (NSDictionary * item in items) {
                NSInteger associateAction = [item[@"associate_action"] integerValue];
                if(associateAction > 100 && associateAction < 300){//question
                    WeCenterHomeQuestionInfo * info = [[WeCenterHomeQuestionInfo alloc] init];
                    info.associateAction = associateAction;
                    info.historyId = [item[@"history_id"] integerValue];
                    info.addTime = item[@"add_time"];
                    
                    WeCenterUserInfo * userInfo = [[WeCenterUserInfo alloc] init];
                    NSDictionary * dictUserInfo = item[@"user_info"];
                    userInfo.uid = [dictUserInfo[@"uid"] integerValue];
                    userInfo.userName = dictUserInfo[@"user_name"];
                    userInfo.avatarFile = dictUserInfo[@"avatar_file"];
                    userInfo.signature = dictUserInfo[@"signature"];
                    info.userInfo = userInfo;
                    
                    WeCenterQuestionInfo * questionInfo = [[WeCenterQuestionInfo alloc] init];
                    NSDictionary * dictQuestionInfo = item[@"question_info"];
                    questionInfo.questionId = [dictQuestionInfo[@"question_id"] integerValue];
                    questionInfo.questionContent = dictQuestionInfo[@"question_content"];
                    questionInfo.answerCount = [dictQuestionInfo[@"answer_count"] integerValue];
                    questionInfo.agreeCount = [dictQuestionInfo[@"agree_count"] integerValue];
                    questionInfo.addTime = dictQuestionInfo[@"add_time"];
                    questionInfo.updateTime = dictQuestionInfo[@"update_time"];
                    info.questionInfo = questionInfo;
                    
                    WeCenterAnswerInfo * answerInfo = [[WeCenterAnswerInfo alloc] init];
                    NSDictionary * dictAnswerInfo = item[@"answer_info"];
                    answerInfo.answerId = [dictAnswerInfo[@"answer_id"] integerValue];
                    answerInfo.answerContent = dictAnswerInfo[@"answer_content"];
                    answerInfo.agreeCount = [dictAnswerInfo[@"answer_count"] integerValue];
                    answerInfo.againstCount = [dictAnswerInfo[@"against_count"] integerValue];
                    answerInfo.addTime = dictAnswerInfo[@"add_time"];
                    info.answerInfo = answerInfo;
                    
                    [infos addObject:info];
                }
                
                if(associateAction > 500){//article
                    WeCenterHomeArticleInfo * info = [[WeCenterHomeArticleInfo alloc] init];
                    info.associateAction = associateAction;
                    info.historyId = [item[@"history_id"] integerValue];
                    info.addTime = item[@"add_time"];
                    
                    WeCenterUserInfo * userInfo = [[WeCenterUserInfo alloc] init];
                    NSDictionary * dictUserInfo = item[@"user_info"];
                    userInfo.uid = [dictUserInfo[@"uid"] integerValue];
                    userInfo.userName = dictUserInfo[@"user_name"];
                    userInfo.avatarFile = dictUserInfo[@"avatar_file"];
                    userInfo.signature = dictUserInfo[@"signature"];
                    info.userInfo = userInfo;
                    
                    NSDictionary * dictArticleInfo = item[@"article_info"];
                    
                    WeCenterArticleInfo * articleInfo = [[WeCenterArticleInfo alloc] init];
                    articleInfo.aid = [dictArticleInfo[@"id"] integerValue];
                    articleInfo.addTime = dictArticleInfo[@"add_time"];
                    articleInfo.title = dictArticleInfo[@"title"];
                    articleInfo.message = dictArticleInfo[@"message"];
                    articleInfo.views = [dictArticleInfo[@"views"] integerValue];
                    articleInfo.comments = [dictArticleInfo[@"comments"] integerValue];
                    
                    info.articleInfo = articleInfo;
                    [infos addObject:info];                    
                }
            }
            
            success(infos);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterSearch:(NSString *)q
                  type:(NSString *)type
                  page:(NSInteger)page
               perPage:(NSInteger)perPage
               success:(void(^)(NSArray * infos))success
               failure:(void(^)(NSError * error))failure{
    
    NSString * url = search_rest(wecenter_host, wecenter_search_sign);
    NSString * encodeQ = [q stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    url = [NSString stringWithFormat:@"%@&q=%@&type=%@&page=%ld&per_page=%ld", url, encodeQ, type, (long)page, (long)perPage];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSArray * items = rsmObj[@"rows"];
            NSMutableArray * infos = [[NSMutableArray alloc] init];
            if(![items isKindOfClass:[NSArray class]]){
                success(infos);
                return;
            }
            
            for (NSDictionary * item in items) {
                NSString * type = item[@"type"];
                WeCenterSearchInfo * info = [[WeCenterSearchInfo alloc] init];
                info.searchId = [item[@"search_id"] integerValue];
                info.type = type;
                info.name = item[@"name"];
                NSDictionary * dictDetail = item[@"detail"];
                if([type isEqualToString:@"topics"]){
                    WeCenterTopicInfo * topicInfo = [[WeCenterTopicInfo alloc] init];
                    topicInfo.topicId = [dictDetail[@"topic_id"] integerValue];
                    topicInfo.topicPic = dictDetail[@"topic_pic"];
                    topicInfo.focusCount = [dictDetail[@"focus_count"] integerValue];
                    topicInfo.discussCount = [dictDetail[@"discuss_count"] integerValue];
                    topicInfo.topicDescription = dictDetail[@"topic_description"];
                    info.detail = topicInfo;
                    [infos addObject:info];
                }
                
                if([type isEqualToString:@"articles"]){
                    WeCenterArticleInfo * articleInfo = [[WeCenterArticleInfo alloc] init];
                    articleInfo.comments = [dictDetail[@"comments"] integerValue];
                    articleInfo.views = [dictDetail[@"views"] integerValue];
                    info.detail = articleInfo;
                    [infos addObject:info];
                }
                
                if([type isEqualToString:@"questions"]){
                    WeCenterQuestionInfo * questionInfo = [[WeCenterQuestionInfo alloc] init];
                    questionInfo.bestAnswer = [dictDetail[@"best_answer"] integerValue];
                    questionInfo.answerCount = [dictDetail[@"answer_count"] integerValue];
                    questionInfo.commentCount = [dictDetail[@"comment_count"] integerValue];
                    questionInfo.focusCount = [dictDetail[@"focus_count"] integerValue];
                    questionInfo.agreeCount = [dictDetail[@"agree_count"] integerValue];
                    info.detail = questionInfo;
                    [infos addObject:info];
                }
                
                if([type isEqualToString:@"users"]){
                    WeCenterUserInfo * userInfo = [[WeCenterUserInfo alloc] init];
                    userInfo.avatarFile = dictDetail[@"avatar_file"];
                    userInfo.reputation = [dictDetail[@"reputation"] integerValue];
                    userInfo.agreeCount = [dictDetail[@"agree_count"] integerValue];
                    userInfo.thanksCount = [dictDetail[@"thanks_count"] integerValue];
                    userInfo.fansCount = [dictDetail[@"fans_count"] integerValue];
                    userInfo.signature = dictDetail[@"signature"];
                    info.detail = userInfo;
                    [infos addObject:info];
                }
            }
            
            success(infos);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterAttachUploadImage:(NSString *)auId
                  attachAccessKey:(NSString *)attachAccessKey
                        imageData:(NSData *)imageData
                          success:(void(^)(WeCenterAttachInfo * info))success
                          failure:(void(^)(NSError * error))failure{
    
    NSString * url = attach_upload(wecenter_host, wecenter_publish_sign);
    url = [NSString stringWithFormat:@"%@&id=%@&attach_access_key=%@", url, auId, attachAccessKey];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [self.manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"qqfile" fileName:@"qqfile.png" mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSLog(@"weCenterAttachUploadImage: %@", responseJson);
            NSDictionary * item = responseJson[@"rsm"];
            WeCenterAttachInfo * attachInfo = [[WeCenterAttachInfo alloc] init];
            attachInfo.attachId = [item[@"attach_id"] integerValue];
            attachInfo.attachAccessKey = item[@"attach_access_key"];
            attachInfo.thumb = item[@"thumb"];
            success(attachInfo);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterPublishArticle:(NSString *)title
               attachAccessKey:(NSString *)attachAccessKey
                       message:(NSString *)message
                        topics:(NSString *)topics
                    categoryId:(NSInteger)categoryId
                       success:(void(^)(NSInteger articleId))success
                       failure:(void(^)(NSError * error))failure{

    NSString * url = publish_article_rest(wecenter_host, wecenter_publish_sign);
    NSString * categoryIdStr = [NSString stringWithFormat:@"%zd", categoryId];
    NSDictionary *params = @{@"title": title, @"attach_access_key": attachAccessKey, @"message": message, @"topics": topics, @"category_id": categoryIdStr};
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSInteger articleId = [responseJson[@"rsm"][@"article_id"] integerValue];
            success(articleId);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterPublishQuestion:(NSString *)questionContent
                 questionDetail:(NSString *)questionDetail
                attachAccessKey:(NSString *)attachAccessKey
                         topics:(NSString *)topics
                     categoryId:(NSInteger)categoryId
                        success:(void(^)(NSInteger questionId))success
                        failure:(void(^)(NSError * error))failure{
    
    NSString * url = publish_question_rest(wecenter_host, wecenter_publish_sign);
    NSString * categoryIdStr = [NSString stringWithFormat:@"%zd", categoryId];
    NSDictionary *params = @{@"question_content": questionContent, @"question_detail": questionDetail, @"attach_access_key": attachAccessKey, @"topics": topics, @"category_id": categoryIdStr};
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSInteger questionId = [responseJson[@"rsm"][@"question_id"] integerValue];
            success(questionId);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

- (void)weCenterFocusTopicWithId:(NSInteger)topicId
                         success:(void(^)(NSString * type))success
                         failure:(void(^)(NSError * error))failure{
    
    NSString * url = focus_topic_rest(wecenter_host);
    NSString * topicIdStr = [NSString stringWithFormat:@"%ld", (long)topicId];
    NSDictionary * params = @{@"topic_id": topicIdStr};
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSString * type = rsmObj[@"type"];
            success(type);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterGetTopicInfoWithId:(NSInteger)topicId
                            success:(void(^)(WeCenterTopicInfo * info))success
                            failure:(void(^)(NSError * error))failure{
    
    NSString * url = topic_rest(wecenter_host, wecenter_topic_sign);
    url = [NSString stringWithFormat:@"%@&id=%ld", url, (long)topicId];

    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            WeCenterTopicInfo * info = [[WeCenterTopicInfo alloc] init];
            info.topicId = [rsmObj[@"topic_id"] integerValue];
            info.topicTitle = rsmObj[@"topic_title"];
            info.addTime = rsmObj[@"add_time"];
            info.discussCount = [rsmObj[@"discuss_count"] integerValue];
            info.topicDescription = rsmObj[@"topic_description"];
            info.topicPic = rsmObj[@"topic_pic"];
            info.topicLock = [rsmObj[@"topic_lock"] integerValue];
            info.focusCount = [rsmObj[@"focus_count"] integerValue];
            info.userRelated = [rsmObj[@"user_related"] integerValue];
            info.urlToken = rsmObj[@"url_token"];
            info.mergedId = [rsmObj[@"merged_id"] integerValue];
            info.seoTitle = rsmObj[@"seo_title"];
            info.parentId = [rsmObj[@"parent_id"] integerValue];
            info.isParent = [rsmObj[@"is_parent"] integerValue];
            info.discussCountLastWeek = [rsmObj[@"discuss_count_last_week"] integerValue];
            info.discussCountLastMonth = [rsmObj[@"discuss_count_last_month"] integerValue];
            info.discussCountUpdate = rsmObj[@"discuss_count_update"];
            info.mergedTip = rsmObj[@"merged_tip"];
            info.hasFocus = [rsmObj[@"has_focus"] integerValue];
            success(info);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

- (void)weCenterGetTopicInfoWithTitle:(NSString *)topicTitle
                               success:(void(^)(WeCenterTopicInfo * info))success
                               failure:(void(^)(NSError * error))failure{
    
    NSString * url = topic_rest(wecenter_host, wecenter_topic_sign);
    url = [NSString stringWithFormat:@"%@&id=%@", url, topicTitle];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            WeCenterTopicInfo * info = [[WeCenterTopicInfo alloc] init];
            info.topicId = [rsmObj[@"topic_id"] integerValue];
            info.topicTitle = rsmObj[@"topic_title"];
            info.addTime = rsmObj[@"add_time"];
            info.discussCount = [rsmObj[@"discuss_count"] integerValue];
            info.topicDescription = rsmObj[@"topic_description"];
            info.topicPic = rsmObj[@"topic_pic"];
            info.topicLock = [rsmObj[@"topic_lock"] integerValue];
            info.focusCount = [rsmObj[@"focus_count"] integerValue];
            info.userRelated = [rsmObj[@"user_related"] integerValue];
            info.urlToken = rsmObj[@"url_token"];
            info.mergedId = [rsmObj[@"merged_id"] integerValue];
            info.seoTitle = rsmObj[@"seo_title"];
            info.parentId = [rsmObj[@"parent_id"] integerValue];
            info.isParent = [rsmObj[@"is_parent"] integerValue];
            info.discussCountLastWeek = [rsmObj[@"discuss_count_last_week"] integerValue];
            info.discussCountLastMonth = [rsmObj[@"discuss_count_last_month"] integerValue];
            info.discussCountUpdate = rsmObj[@"discuss_count_update"];
            info.mergedTip = rsmObj[@"merged_tip"];
            info.hasFocus = [rsmObj[@"has_focus"] integerValue];
            success(info);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterGetTopicsWithIds:(NSArray *)topicIds
                         success:(void(^)(NSArray * infos))success
                         failure:(void(^)(NSError * error))failure{
    
    NSString * url = topics_rest(wecenter_host, wecenter_topic_sign);
    NSDictionary *params = @{@"topics": topicIds};
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSArray * items = rsmObj[@"rows"];
            NSMutableArray * infos = [[NSMutableArray alloc] init];
            if(![items isKindOfClass:[NSArray class]]){
                success(infos);
                return;
            }
            for (NSDictionary * item in items) {
                WeCenterTopicInfo * info = [[WeCenterTopicInfo alloc] init];
                info.topicId = [item[@"topic_id"] integerValue];
                info.topicTitle = item[@"topic_title"];
                info.addTime = item[@"add_time"];
                info.discussCount = [item[@"discuss_count"] integerValue];
                info.topicDescription = item[@"topic_description"];
                info.topicPic = item[@"topic_pic"];
                info.topicLock = [item[@"topic_lock"] integerValue];
                info.focusCount = [item[@"focus_count"] integerValue];
                info.userRelated = [item[@"user_related"] integerValue];
                info.urlToken = item[@"url_token"];
                info.mergedId = [item[@"merged_id"] integerValue];
                info.seoTitle = item[@"seo_title"];
                info.parentId = [item[@"parent_id"] integerValue];
                info.isParent = [item[@"is_parent"] integerValue];
                info.discussCountLastWeek = [item[@"discuss_count_last_week"] integerValue];
                info.discussCountLastMonth = [item[@"discuss_count_last_month"] integerValue];
                info.discussCountUpdate = item[@"discuss_count_update"];
                info.mergedTip = item[@"merged_tip"];
                info.hasFocus = [item[@"has_focus"] integerValue];
                [infos addObject:info];
            }
            success(infos);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

- (void)weCenterGetParentTopicsWithId:(NSInteger)topicId
                                 page:(NSInteger)page
                              perPage:(NSInteger)perPage
                              success:(void(^)(NSArray * infos))success
                              failure:(void(^)(NSError * error))failure{
    
    NSString * url = parent_topic_rest(wecenter_host, wecenter_topic_sign);

    NSString * topicIdStr = [NSString stringWithFormat:@"%ld", topicId];
    NSString * pageStr = [NSString stringWithFormat:@"%ld", page];
    NSString * perPageStr = [NSString stringWithFormat:@"%ld", perPage];
    NSDictionary *params = @{@"topic_id": topicIdStr, @"page": pageStr, @"per_page": perPageStr};
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSArray * items = rsmObj[@"rows"];
            NSMutableArray * infos = [[NSMutableArray alloc] init];
            if(![items isKindOfClass:[NSArray class]]){
                success(infos);
                return;
            }
            for (NSDictionary * item in items) {
                WeCenterTopicInfo * info = [[WeCenterTopicInfo alloc] init];
                info.topicId = [item[@"topic_id"] integerValue];
                info.topicTitle = item[@"topic_title"];
                info.addTime = item[@"add_time"];
                info.discussCount = [item[@"discuss_count"] integerValue];
                info.topicDescription = item[@"topic_description"];
                info.topicPic = item[@"topic_pic"];
                info.topicLock = [item[@"topic_lock"] integerValue];
                info.focusCount = [item[@"focus_count"] integerValue];
                info.userRelated = [item[@"user_related"] integerValue];
                info.urlToken = item[@"url_token"];
                info.mergedId = [item[@"merged_id"] integerValue];
                info.seoTitle = item[@"seo_title"];
                info.parentId = [item[@"parent_id"] integerValue];
                info.isParent = [item[@"is_parent"] integerValue];
                info.discussCountLastWeek = [item[@"discuss_count_last_week"] integerValue];
                info.discussCountLastMonth = [item[@"discuss_count_last_month"] integerValue];
                info.discussCountUpdate = item[@"discuss_count_update"];
                info.mergedTip = item[@"merged_tip"];
                info.hasFocus = [item[@"has_focus"] integerValue];
                [infos addObject:info];
            }
            success(infos);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterGetChildTopicsWithId:(NSInteger)topicId
                                page:(NSInteger)page
                             perPage:(NSInteger)perPage
                             success:(void(^)(NSArray * infos))success
                             failure:(void(^)(NSError * error))failure{
    
    NSString * url = child_topic_rest(wecenter_host, wecenter_topic_sign);
    
    NSString * topicIdStr = [NSString stringWithFormat:@"%ld", topicId];
    NSString * pageStr = [NSString stringWithFormat:@"%ld", page];
    NSString * perPageStr = [NSString stringWithFormat:@"%ld", perPage];
    NSDictionary *params = @{@"topic_id": topicIdStr, @"page": pageStr, @"per_page": perPageStr};
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSArray * items = rsmObj[@"rows"];
            NSMutableArray * infos = [[NSMutableArray alloc] init];
            if(![items isKindOfClass:[NSArray class]]){
                success(infos);
                return;
            }
            for (NSDictionary * item in items) {
                WeCenterTopicInfo * info = [[WeCenterTopicInfo alloc] init];
                info.topicId = [item[@"topic_id"] integerValue];
                info.topicTitle = item[@"topic_title"];
                info.addTime = item[@"add_time"];
                info.discussCount = [item[@"discuss_count"] integerValue];
                info.topicDescription = item[@"topic_description"];
                info.topicPic = item[@"topic_pic"];
                info.topicLock = [item[@"topic_lock"] integerValue];
                info.focusCount = [item[@"focus_count"] integerValue];
                info.userRelated = [item[@"user_related"] integerValue];
                info.urlToken = item[@"url_token"];
                info.mergedId = [item[@"merged_id"] integerValue];
                info.seoTitle = item[@"seo_title"];
                info.parentId = [item[@"parent_id"] integerValue];
                info.isParent = [item[@"is_parent"] integerValue];
                info.discussCountLastWeek = [item[@"discuss_count_last_week"] integerValue];
                info.discussCountLastMonth = [item[@"discuss_count_last_month"] integerValue];
                info.discussCountUpdate = item[@"discuss_count_update"];
                info.mergedTip = item[@"merged_tip"];
                info.hasFocus = [item[@"has_focus"] integerValue];
                [infos addObject:info];
            }
            success(infos);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterGetTopicBestAnswerWithId:(NSInteger)topicId
                                    page:(NSInteger)page
                                 perPage:(NSInteger)perPage
                                 success:(void(^)(NSArray * infos))success
                                 failure:(void(^)(NSError * error))failure{
    
    NSString * url = topic_best_answer_rest(wecenter_host, wecenter_topic_sign);
    url = [NSString stringWithFormat:@"%@&topic_id=%ld&page=%ld&per_page=%ld", url, (long)topicId, (long)page, (long)perPage];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSArray * items = rsmObj[@"rows"];
            NSMutableArray * infos = [[NSMutableArray alloc] init];
            if(![items isKindOfClass:[NSArray class]]){
                success(infos);
                return;
            }
            
            for (NSDictionary * item in items) {
                WeCenterTopicBestAnswer * info = [[WeCenterTopicBestAnswer alloc] init];
                    
                WeCenterUserInfo * userInfo = [[WeCenterUserInfo alloc] init];
                NSDictionary * dictUserInfo = item[@"user_info"];
                userInfo.uid = [dictUserInfo[@"uid"] integerValue];
                userInfo.userName = dictUserInfo[@"user_name"];
                userInfo.avatarFile = dictUserInfo[@"avatar_file"];
                userInfo.signature = dictUserInfo[@"signature"];
                info.userInfo = userInfo;
                
                WeCenterQuestionInfo * questionInfo = [[WeCenterQuestionInfo alloc] init];
                NSDictionary * dictQuestionInfo = item[@"question_info"];
                questionInfo.questionId = [dictQuestionInfo[@"question_id"] integerValue];
                questionInfo.questionContent = dictQuestionInfo[@"question_content"];
                questionInfo.answerCount = [dictQuestionInfo[@"answer_count"] integerValue];
                questionInfo.agreeCount = [dictQuestionInfo[@"agree_count"] integerValue];
                questionInfo.addTime = dictQuestionInfo[@"add_time"];
                questionInfo.updateTime = dictQuestionInfo[@"update_time"];
                info.questionInfo = questionInfo;
                
                WeCenterAnswerInfo * answerInfo = [[WeCenterAnswerInfo alloc] init];
                NSDictionary * dictAnswerInfo = item[@"answer_info"];
                answerInfo.answerId = [dictAnswerInfo[@"answer_id"] integerValue];
                answerInfo.answerContent = dictAnswerInfo[@"answer_content"];
                answerInfo.agreeCount = [dictAnswerInfo[@"answer_count"] integerValue];
                answerInfo.againstCount = [dictAnswerInfo[@"against_count"] integerValue];
                answerInfo.addTime = dictAnswerInfo[@"add_time"];
                info.answerInfo = answerInfo;
                
                [infos addObject:info];
            }
            
            success(infos);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterGetHotTopicsWithDay:(NSString*)day
                               page:(NSInteger)page
                            perPage:(NSInteger)perPage
                            success:(void(^)(NSArray * infos))success
                            failure:(void(^)(NSError * error))failure{
    NSString * url = hot_topics_rest(wecenter_host, wecenter_topic_sign);
    url = [NSString stringWithFormat:@"%@&day=%@&page=%ld&per_page=%ld", url, day, (long)page, (long)perPage];

    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSArray * items = rsmObj[@"rows"];
            NSMutableArray * infos = [[NSMutableArray alloc] init];
            if(![items isKindOfClass:[NSArray class]]){
                success(infos);
                return;
            }
            for (NSDictionary * item in items) {
                WeCenterTopicInfo * info = [[WeCenterTopicInfo alloc] init];
                info.topicId = [item[@"topic_id"] integerValue];
                info.topicTitle = item[@"topic_title"];
                info.addTime = item[@"add_time"];
                info.discussCount = [item[@"discuss_count"] integerValue];
                info.topicDescription = item[@"topic_description"];
                info.topicPic = item[@"topic_pic"];
                info.topicLock = [item[@"topic_lock"] integerValue];
                info.focusCount = [item[@"focus_count"] integerValue];
                info.userRelated = [item[@"user_related"] integerValue];
                info.urlToken = item[@"url_token"];
                info.mergedId = [item[@"merged_id"] integerValue];
                info.seoTitle = item[@"seo_title"];
                info.parentId = [item[@"parent_id"] integerValue];
                info.isParent = [item[@"is_parent"] integerValue];
                info.discussCountLastWeek = [item[@"discuss_count_last_week"] integerValue];
                info.discussCountLastMonth = [item[@"discuss_count_last_month"] integerValue];
                info.discussCountUpdate = item[@"discuss_count_update"];
                info.mergedTip = item[@"merged_tip"];
                info.hasFocus = [item[@"has_focus"] integerValue];
                [infos addObject:info];
            }
            success(infos);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterGetArticleInfoWithId:(NSInteger)articleId
                         commentPage:(NSInteger)commentPage
                      commentPerPage:(NSInteger)commentPerPage
                             success:(void(^)(WeCenterArticleInfo * info))success
                             failure:(void(^)(NSError * error))failure{
    
    
    NSString * url = article_rest(wecenter_host, wecenter_article_sign);
    url = [NSString stringWithFormat:@"%@&id=%ld&page=%ld&per_page=%ld", url, articleId, (long)commentPage, (long)commentPerPage];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSDictionary * dictArticleInfo = rsmObj[@"article_info"];
            WeCenterArticleInfo * info = [[WeCenterArticleInfo alloc] init];
            info.aid = [dictArticleInfo[@"id"] integerValue];
            info.uid = [dictArticleInfo[@"uid"] integerValue];
            info.title = dictArticleInfo[@"title"];
            info.message = dictArticleInfo[@"message"];
            info.comments = [dictArticleInfo[@"comments"] integerValue];
            info.views = [dictArticleInfo[@"views"] integerValue];
            info.addTime = dictArticleInfo[@"add_time"];
            info.hasAttach = [dictArticleInfo[@"has_attach"] integerValue];
            info.lock = [dictArticleInfo[@"lock"] integerValue];
            info.votes = [dictArticleInfo[@"votes"] integerValue];
            info.titleFulltext = dictArticleInfo[@"title_fulltext"];
            info.categoryId = [dictArticleInfo[@"category_id"] integerValue];
            info.isRecommend = [dictArticleInfo[@"is_recommend"] integerValue];
            if([dictArticleInfo[@"chapter_id"] isEqual:[NSNull null]]){
                info.chapterId = 0;
            }
            else{
                info.chapterId = [dictArticleInfo[@"chapter_id"] integerValue];
            }

            info.sort = [dictArticleInfo[@"sort"] integerValue];
            
            NSDictionary * dictUserInfo = dictArticleInfo[@"user_info"];
            if(![dictUserInfo isEqual:[NSNull null]]){
                WeCenterUserInfo * userInfo = [[WeCenterUserInfo alloc] init];
                userInfo.uid = [dictUserInfo[@"uid"] integerValue];
                userInfo.userName = dictUserInfo[@"user_name"];
                userInfo.signature = dictUserInfo[@"signature"];
                userInfo.avatarFile = dictUserInfo[@"avatar_file"];
                info.userInfo = userInfo;
            }
            
            NSDictionary * dictVoteInfo = dictArticleInfo[@"vote_info"];
            if(![dictVoteInfo isEqual:[NSNull null]]){
                WeCenterVoteInfo * voteInfo = [[WeCenterVoteInfo alloc] init];
                voteInfo.vid = [dictVoteInfo[@"id"] integerValue];
                voteInfo.type = dictVoteInfo[@"type"];
                voteInfo.itemId = [dictVoteInfo[@"item_id"] integerValue];
                voteInfo.rating = [dictVoteInfo[@"rating"] integerValue];
                voteInfo.time = dictVoteInfo[@"time"];
                voteInfo.reputationFactor = [dictVoteInfo[@"reputation_factor"] integerValue];
                voteInfo.itemUid = [dictVoteInfo[@"item_uid"] integerValue];
                
                info.voteInfo = voteInfo;
            }
            
            NSDictionary * dictVoteUsers = dictArticleInfo[@"vote_users"];
            if(![dictVoteUsers isEqual:[NSNull null]]){
                NSMutableArray * voteUsers = [[NSMutableArray alloc] init];
                for (NSString * key in dictVoteUsers) {
                    NSDictionary * voteUser = dictVoteUsers[key];
                    WeCenterUserInfo * voteUserInfo = [[WeCenterUserInfo alloc] init];
                    voteUserInfo.uid = [voteUser[@"uid"] integerValue];
                    voteUserInfo.userName = voteUser[@"user_name"];
                    voteUserInfo.avatarFile = voteUser[@"avatar_file"];
                    
                    [voteUsers addObject:voteUser];
                }
                
                info.voteUsers = voteUsers;
            }
            
            NSArray * articleTopics = rsmObj[@"article_topics"];
            if(![articleTopics isEqual:[NSNull null]]){
                NSMutableArray * topics = [[NSMutableArray alloc] init];
                for (NSDictionary * topic in articleTopics) {
                    WeCenterTopicInfo * artTopic = [[WeCenterTopicInfo alloc] init];
                    artTopic.topicId = [topic[@"topic_id"] integerValue];
                    artTopic.topicTitle = topic[@"topic_title"];
                    [topics addObject:artTopic];
                }
                
                info.topics = topics;
            }
            
            NSDictionary * attachList = dictArticleInfo[@"attachs"];
            if(![attachList isEqual:[NSNull null]]){
                NSMutableArray * attachs = [[NSMutableArray alloc] init];
                for(NSString * key in attachList){
                    NSDictionary * aItem = attachList[key];

                    WeCenterAttachInfo * aInfo = [[WeCenterAttachInfo alloc] init];
                    aInfo.attachId = [aItem[@"id"] integerValue];
                    aInfo.fileLocation = aItem[@"file_location"];
                    aInfo.isImage = [aItem[@"is_image"] integerValue];
                    aInfo.fileName = aItem[@"file_name"];
                    aInfo.thumb = aItem[@"thumb"];
                    aInfo.path = aItem[@"path"];
                    aInfo.attachAccessKey = aItem[@"access_key"];
                    aInfo.attachment = aItem[@"attachment"];
                    [attachs addObject:aInfo];
                }
                info.attachs = attachs;
            }
            
            NSArray * commentList = rsmObj[@"comments"];
            if(![commentList isEqual:[NSNull null]]){
                NSMutableArray * comments = [[NSMutableArray alloc] init];
                for (NSDictionary * comment in commentList){
                    WeCenterCommentInfo * commentInfo = [[WeCenterCommentInfo alloc] init];
                    commentInfo.cid = [comment[@"id"] integerValue];
                    commentInfo.uid = [comment[@"uid"] integerValue];
                    commentInfo.articleId = [comment[@"article_id"] integerValue];
                    commentInfo.message = comment[@"message"];
                    commentInfo.addTime = comment[@"addTime"];
                    commentInfo.atUid = [comment[@"at_uid"] integerValue];
                    commentInfo.votes = [comment[@"votes"] integerValue];
                    
                    NSDictionary * dictCommentUserInfo = comment[@"user_info"];
                    if(![dictCommentUserInfo isEqual:[NSNull null]]){
                        WeCenterUserInfo * commentUserInfo = [[WeCenterUserInfo alloc] init];
                        commentUserInfo.uid = [dictCommentUserInfo[@"uid"] integerValue];
                        commentUserInfo.userName = dictCommentUserInfo[@"user_name"];
                        commentUserInfo.avatarFile = dictCommentUserInfo[@"avatar_file"];
                        commentInfo.userInfo = commentUserInfo;
                    }
                    
                    NSDictionary * dictAtUserInfo = comment[@"at_user_info"];
                    if(![dictAtUserInfo isEqual:[NSNull null]]){
                        WeCenterUserInfo * atUserInfo = [[WeCenterUserInfo alloc] init];
                        atUserInfo.uid = [dictAtUserInfo[@"uid"] integerValue];
                        atUserInfo.userName = dictAtUserInfo[@"user_name"];
                        atUserInfo.avatarFile = dictAtUserInfo[@"avatar_file"];
                        commentInfo.atUserInfo = atUserInfo;
                    }
                    
                    [comments addObject:commentInfo];
                }
                
                info.commentList = comments;
            }
            success(info);

        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterGetArticleCommentsWithId:(NSInteger)articleId
                                    page:(NSInteger)page
                                 perPage:(NSInteger)perPage
                                 success:(void(^)(NSArray * infos))success
                                 failure:(void(^)(NSError * error))failure{
    
    NSString * url = article_comments_rest(wecenter_host, wecenter_article_sign);
    url = [NSString stringWithFormat:@"%@&id=%ld&page=%ld&per_page=%ld", url, (long)articleId, (long)page, (long)perPage];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSArray * items = rsmObj[@"rows"];
            NSMutableArray * infos = [[NSMutableArray alloc] init];
            if(![items isKindOfClass:[NSArray class]]){
                success(infos);
                return;
            }
            
            for (NSDictionary * item in items) {
                WeCenterCommentInfo * info = [[WeCenterCommentInfo alloc] init];
                info.cid = [item[@"id"] integerValue];
                info.uid = [item[@"uid"] integerValue];
                info.articleId = [item[@"article_id"] integerValue];
                info.message = item[@"message"];
                info.addTime = item[@"addTime"];
                info.atUid = [item[@"at_uid"] integerValue];
                info.votes = [item[@"votes"] integerValue];
                
                NSDictionary * dictCommentUserInfo = item[@"user_info"];
                if(![dictCommentUserInfo isEqual:[NSNull null]]){
                    WeCenterUserInfo * commentUserInfo = [[WeCenterUserInfo alloc] init];
                    commentUserInfo.uid = [dictCommentUserInfo[@"uid"] integerValue];
                    commentUserInfo.userName = dictCommentUserInfo[@"user_name"];
                    commentUserInfo.avatarFile = dictCommentUserInfo[@"avatar_file"];
                    info.userInfo = commentUserInfo;
                }
                
                NSDictionary * dictAtUserInfo = item[@"at_user_info"];
                if(![dictAtUserInfo isEqual:[NSNull null]]){
                    WeCenterUserInfo * atUserInfo = [[WeCenterUserInfo alloc] init];
                    atUserInfo.uid = [dictAtUserInfo[@"uid"] integerValue];
                    atUserInfo.userName = dictAtUserInfo[@"user_name"];
                    atUserInfo.avatarFile = dictAtUserInfo[@"avatar_file"];
                    info.atUserInfo = atUserInfo;
                }
                
                [infos addObject:info];
            }
            
            success(infos);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterFavoriteItemWithId:(NSInteger)itemId
                          itemType:(NSString *)itemType
                              tags:(NSString *)tags
                           success:(void(^)())success
                           failure:(void(^)(NSError * error))failure{
    NSString * url = favorite_tag_rest(wecenter_host);
    NSString * itemIdStr = [NSString stringWithFormat:@"%ld", (long)itemId];
    NSDictionary * params = @{@"item_id": itemIdStr, @"item_type": itemType, @"tags": tags};
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            success();
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterRemoveFavoriteItemWithId:(NSInteger)itemId
                                itemType:(NSString *)itemType
                                 success:(void(^)())success
                                 failure:(void(^)(NSError * error))failure{
    
    NSString * url = remove_favorite_rest(wecenter_host);
    NSString * itemIdStr = [NSString stringWithFormat:@"%ld", (long)itemId];
    NSDictionary * params = @{@"item_id": itemIdStr, @"item_type": itemType};
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            success();
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterSaveArticleCommentWithId:(NSInteger)articleId
                                 message:(NSString *)message
                                   atUid:(NSInteger)atUid
                                 success:(void(^)(NSInteger commentId))success
                                 failure:(void(^)(NSError * error))failure{
    
    NSString * url = save_comment_rest(wecenter_host, wecenter_article_sign);
    NSString * articleIdStr = [NSString stringWithFormat:@"%ld", (long)articleId];
    NSString * atUidStr = [NSString stringWithFormat:@"%ld", (long)atUid];
    NSDictionary * params = @{@"article_id": articleIdStr, @"message": message, @"at_uid": atUidStr};
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSInteger commentId = [rsmObj[@"comment_id"] integerValue];
            success(commentId);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterRemoveArticleCommentWithId:(NSInteger)commentId
                                   success:(void(^)())success
                                   failure:(void(^)(NSError * error))failure{
    
    NSString * url = remove_comment_rest(wecenter_host, wecenter_article_sign);
    NSString * commentIdStr = [NSString stringWithFormat:@"%ld", (long)commentId];
    NSDictionary * params = @{@"comment_id": commentIdStr};
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            success();
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterRemoveArticleWithId:(NSInteger)articleId
                            success:(void(^)())success
                            failure:(void(^)(NSError * error))failure{
    NSString * url = remove_article_rest(wecenter_host, wecenter_article_sign);
    NSString * articleIdStr = [NSString stringWithFormat:@"%ld", (long)articleId];
    NSDictionary * params = @{@"article_id": articleIdStr};
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            success();
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterVoteItemWithId:(NSInteger)itemId
                      itemType:(NSString *)itemType
                        rating:(NSString *)rating
                       success:(void(^)())success
                       failure:(void(^)(NSError * error))failure{
    
    NSString * url = vote_item_rest(wecenter_host);
    NSString * itemIdStr = [NSString stringWithFormat:@"%ld", (long)itemId];
    NSDictionary * params = @{@"item_id": itemIdStr, @"type": itemType, @"rating": rating};
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            success();
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterGetQuestionInfoWithId:(NSInteger)questionId
                           answerPage:(NSInteger)answerPage
                        answerPerPage:(NSInteger)answerPerPage
                              sortKey:(NSString *)sortKey
                                 sort:(NSString *)sort
                              success:(void(^)(WeCenterQuestionInfo * info))success
                              failure:(void(^)(NSError * error))failure{
    
    NSString * url = question_rest(wecenter_host, wecenter_question_sign);
    url = [NSString stringWithFormat:@"%@&id=%ld&page=%ld&per_page=%ld&sort_key=%@&sort=%@", url, (long)questionId, (long)answerPage, (long)answerPerPage, sortKey, sort];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSDictionary * dictQuestionInfo = rsmObj[@"question_info"];
            WeCenterQuestionInfo * info = [[WeCenterQuestionInfo alloc] init];
            info.questionId = [dictQuestionInfo[@"question_id"] integerValue];
            info.questionContent = dictQuestionInfo[@"question_content"];
            info.questionDetail = dictQuestionInfo[@"question_detail"];
            info.addTime = dictQuestionInfo[@"add_time"];
            info.updateTime = dictQuestionInfo[@"update_time"];
            info.answerCount = [dictQuestionInfo[@"answer_count"] integerValue];
            info.viewCount = [dictQuestionInfo[@"view_count"] integerValue];
            info.focusCount = [dictQuestionInfo[@"focus_count"] integerValue];
            info.commentCount = [dictQuestionInfo[@"comment_count"] integerValue];
            info.agreeCount = [dictQuestionInfo[@"agree_count"] integerValue];
            info.againstCount = [dictQuestionInfo[@"against_count"] integerValue];
            info.thanksCount = [dictQuestionInfo[@"thanks_count"] integerValue];
            info.userAnswered = [dictQuestionInfo[@"user_answered"] integerValue];
            info.userFollowCheck = [dictQuestionInfo[@"user_follow_check"] integerValue];
            info.userQuestionFocus = [dictQuestionInfo[@"user_question_focus"] integerValue];
            info.userThanks = [dictQuestionInfo[@"user_thanks"] integerValue];
            
            NSDictionary * dictUserInfo = dictQuestionInfo[@"user_info"];
            if(![dictUserInfo isEqual:[NSNull null]]){
                WeCenterUserInfo * userInfo = [[WeCenterUserInfo alloc] init];
                userInfo.uid = [dictUserInfo[@"uid"] integerValue];
                userInfo.userName = dictUserInfo[@"user_name"];
                userInfo.signature = dictUserInfo[@"signature"];
                userInfo.avatarFile = dictUserInfo[@"avatar_file"];
                info.userInfo = userInfo;
            }
            
            NSArray * questionTopics = rsmObj[@"question_topics"];
            if(![questionTopics isEqual:[NSNull null]]){
                NSMutableArray * topics = [[NSMutableArray alloc] init];
                for(NSDictionary * item in questionTopics){
                    WeCenterTopicInfo * topic = [[WeCenterTopicInfo alloc] init];
                    topic.topicId = [item[@"topic_id"] integerValue];
                    topic.topicTitle = item[@"topic_title"];
                    [topics addObject:topic];
                }
                info.topics = topics;
            }
            
            NSArray * answersArray = rsmObj[@"answers"];
            if(![answersArray isEqual:[NSNull null]]){
                NSMutableArray * answers = [[NSMutableArray alloc] init];
                for(NSDictionary * item in answersArray){
                    WeCenterAnswerInfo * answer = [[WeCenterAnswerInfo alloc] init];
                    answer.answerId = [item[@"answer_id"] integerValue];
                    answer.questionId = [item[@"question_id"] integerValue];
                    answer.answerContent = item[@"answer_content"];
                    answer.addTime = item[@"add_time"];
                    answer.againstCount = [item[@"against_count"] integerValue];
                    answer.agreeCount = [item[@"agree_count"] integerValue];
                    answer.uid = [item[@"uid"] integerValue];
                    answer.commentCount = [item[@"comment_count"] integerValue];
                    answer.uninterestedCount = [item[@"uninterested_count"] integerValue];
                    answer.thanksCount = [item[@"thanks_count"] integerValue];
                    answer.categoryId = [item[@"category_id"] integerValue];
                    answer.hasAttach = [item[@"has_attach"] integerValue];
                    answer.ip = [item[@"ip"] integerValue];
                    answer.forceFold = [item[@"force_fold"] integerValue];
                    answer.anonymous = [item[@"anonymous"] integerValue];
                    answer.publishSource = item[@"publish_source"];
                    if(![item[@"user_rated_thanks"] isEqual:[NSNull null]]){
                        answer.userRatedThanks = [item[@"user_rated_thanks"] integerValue];
                    }
                    if(![item[@"user_rated_uninterested"] isEqual:[NSNull null]]){
                        answer.userRatedUninterested = [item[@"user_rated_uninterested"] integerValue];
                    }
                    answer.agreeStatus = [item[@"agree_status"] integerValue];
                    WeCenterUserInfo * answerUserInfo = [[WeCenterUserInfo alloc] init];
                    NSDictionary * dictUserInfo = item[@"user_info"];
                    if(![dictUserInfo isEqual:[NSNull null]]){
                        answerUserInfo.uid = [dictUserInfo[@"uid"] integerValue];
                        answerUserInfo.userName = dictUserInfo[@"user_name"];
                        answerUserInfo.signature = dictUserInfo[@"signature"];
                        answerUserInfo.avatarFile = dictUserInfo[@"avatar_file"];
                        
                        answer.userInfo = answerUserInfo;
                    }
                    [answers addObject:answer];
                }
                info.answers = answers;
            }
            
            success(info);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterFocusQuestionWithId:(NSInteger)questionId
                            success:(void(^)(NSString * type))success
                            failure:(void(^)(NSError * error))failure{
    
    NSString * url = focus_question_rest(wecenter_host);
    NSString * questionIdStr = [NSString stringWithFormat:@"%ld", (long)questionId];
    NSDictionary * params = @{@"question_id": questionIdStr};
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSString * type = rsmObj[@"type"];
            success(type);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterThanksQuestionWithId:(NSInteger)questionId
                             success:(void(^)(NSString * action))success
                             failure:(void(^)(NSError * error))failure{
    
    NSString * url = thanks_question_rest(wecenter_host);
    NSString * questionIdStr = [NSString stringWithFormat:@"%ld", (long)questionId];
    NSDictionary * params = @{@"question_id": questionIdStr};
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSString * type = rsmObj[@"action"];
            success(type);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterAnswerVoteWithId:(NSInteger)answerId
                           value:(NSInteger)value
                         success:(void(^)())success
                         failure:(void(^)(NSError * error))failure{
    
    NSString * url = answer_vote_rest(wecenter_host);
    NSString * answerIdStr = [NSString stringWithFormat:@"%ld", (long)answerId];
    NSString * valueStr = [NSString stringWithFormat:@"%ld", (long)value];
    NSDictionary * params = @{@"answer_id": answerIdStr, @"value": valueStr};
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            
            success();
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterSaveAnswerWithId:(NSInteger)questionId
                   answerContent:(NSString *)answerContent
                 attachAccessKey:(NSString *)attachAccessKey
                       autoFocus:(NSInteger)autoFocus
                         success:(void(^)(WeCenterAnswerInfo* info))success
                         failure:(void(^)(NSError * error))failure{
    
    NSString * url = save_answer_rest(wecenter_host, wecenter_publish_sign);
    NSString * questionIdStr = [NSString stringWithFormat:@"%ld", (long)questionId];
    NSString * autoFocusStr = [NSString stringWithFormat:@"%ld", (long)autoFocus];

    NSDictionary * params = @{@"question_id": questionIdStr, @"answer_content": answerContent, @"attach_access_key": attachAccessKey, @"auto_focus":  autoFocusStr};
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            WeCenterAnswerInfo * info = [[WeCenterAnswerInfo alloc] init];
            NSDictionary * item = rsmObj[@"answer_info"];
            if(![item isEqual:[NSNull null]]){
                info.answerId = [item[@"answer_id"] integerValue];
                info.questionId = [item[@"question_id"] integerValue];
                info.answerContent = item[@"answer_content"];
                info.addTime = item[@"add_time"];
                info.againstCount = [item[@"against_count"] integerValue];
                info.agreeCount = [item[@"agree_count"] integerValue];
                info.uid = [item[@"uid"] integerValue];
                info.commentCount = [item[@"comment_count"] integerValue];
                info.uninterestedCount = [item[@"uninterested_count"] integerValue];
                info.thanksCount = [item[@"thanks_count"] integerValue];
                info.categoryId = [item[@"category_id"] integerValue];
                info.hasAttach = [item[@"has_attach"] integerValue];
                info.ip = [item[@"ip"] integerValue];
                info.forceFold = [item[@"force_fold"] integerValue];
                info.anonymous = [item[@"anonymous"] integerValue];
                info.publishSource = item[@"publish_source"];
            }
            success(info);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterRateQuestionAnswerWithId:(NSInteger)answerId
                                 success:(void(^)(NSString * action))success
                                 failure:(void(^)(NSError * error))failure{
    
    NSString * url = question_answer_rate_rest(wecenter_host);
    NSString * answerIdStr = [NSString stringWithFormat:@"%ld", (long)answerId];
    NSDictionary * params = @{@"answer_id": answerIdStr, @"type": @"thanks"};
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSString * type = rsmObj[@"action"];
            success(type);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterSaveQuestionInviteWithId:(NSInteger)questionId
                                     uid:(NSInteger)uid
                                 success:(void(^)())success
                                 failure:(void(^)(NSError * error))failure{
    
    NSString * url = save_invite_rest(wecenter_host);
    NSString * questionIdStr = [NSString stringWithFormat:@"%ld", (long)questionId];
    NSString * uidStr = [NSString stringWithFormat:@"%ld", (long)uid];
    NSDictionary * params = @{@"question_id": questionIdStr, @"uid": uidStr};
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            success();
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterRemoveQuestionWithId:(NSInteger)questionId
                             success:(void(^)())success
                             failure:(void(^)(NSError * error))failure{
    NSString * url = remove_question_rest(wecenter_host, wecenter_question_sign);
    
    NSString * questionIdStr = [NSString stringWithFormat:@"%ld", (long)questionId];
    NSDictionary * params = @{@"question_id": questionIdStr};
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            success();
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterGetAnswerInfoWithId:(NSInteger)answerId
                            success:(void(^)(WeCenterAnswerInfo * info))success
                            failure:(void(^)(NSError * error))failure{
    
    NSString * url = get_answer_rest(wecenter_host, wecenter_question_sign);
    url = [NSString stringWithFormat:@"%@&answer_id=%ld", url, (long)answerId];

    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSDictionary * item = rsmObj[@"answer"];
            
            WeCenterAnswerInfo * answer = [[WeCenterAnswerInfo alloc] init];
            answer.answerId = [item[@"answer_id"] integerValue];
            answer.questionId = [item[@"question_id"] integerValue];
            answer.answerContent = item[@"answer_content"];
            answer.addTime = item[@"add_time"];
            answer.againstCount = [item[@"against_count"] integerValue];
            answer.agreeCount = [item[@"agree_count"] integerValue];
            answer.uid = [item[@"uid"] integerValue];
            answer.commentCount = [item[@"comment_count"] integerValue];
            answer.uninterestedCount = [item[@"uninterested_count"] integerValue];
            answer.thanksCount = [item[@"thanks_count"] integerValue];
            answer.categoryId = [item[@"category_id"] integerValue];
            answer.hasAttach = [item[@"has_attach"] integerValue];
            answer.ip = [item[@"ip"] integerValue];
            answer.forceFold = [item[@"force_fold"] integerValue];
            answer.anonymous = [item[@"anonymous"] integerValue];
            answer.publishSource = item[@"publish_source"];
            answer.userVoteStatus = [item[@"user_vote_status"] integerValue];
            answer.userThanksStatus = [item[@"user_thanks_status"] integerValue];
            answer.questionContent = item[@"question_content"];
            
            WeCenterUserInfo * answerUserInfo = [[WeCenterUserInfo alloc] init];
            NSDictionary * dictUserInfo = item[@"user_info"];
            if(![dictUserInfo isEqual:[NSNull null]]){
                answerUserInfo.uid = [dictUserInfo[@"uid"] integerValue];
                answerUserInfo.userName = dictUserInfo[@"user_name"];
                answerUserInfo.signature = dictUserInfo[@"signature"];
                answerUserInfo.avatarFile = dictUserInfo[@"avatar_file"];
                
                answer.userInfo = answerUserInfo;
            }
            
            success(answer);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterRemoveAnswerWithId:(NSInteger)answerId
                           success:(void(^)())success
                           failure:(void(^)(NSError * error))failure{
    
    NSString * url = update_answer_rest(wecenter_host, wecenter_question_sign);
    NSString * answerIdStr = [NSString stringWithFormat:@"%ld", (long)answerId];
    NSDictionary * params = @{@"answer_id": answerIdStr, @"do_delete":@"1"};
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            success();
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterUpdateAnswerWithId:(NSInteger)answerId
                     answerContent:(NSString *)answerContent
                           success:(void(^)())success
                           failure:(void(^)(NSError * error))failure{
    NSString * url = update_answer_rest(wecenter_host, wecenter_question_sign);
    NSString * answerIdStr = [NSString stringWithFormat:@"%ld", (long)answerId];
    
    NSDictionary * params = @{@"answer_id": answerIdStr, @"answer_content":answerContent};
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            success();
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterGetAnswerCommentsWithId:(NSInteger)answerId
                                   page:(NSInteger)page
                                perPage:(NSInteger)perPage
                                success:(void(^)(NSArray * infos))success
                                failure:(void(^)(NSError * error))failure{
    
    NSString * url = answer_comments_rest(wecenter_host, wecenter_question_sign);
    url = [NSString stringWithFormat:@"%@&answer_id=%ld&page=%ld&per_page=%ld", url, answerId, (long)page, (long)perPage];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSArray * rsmObj = responseJson[@"rsm"];
            NSMutableArray * infos = [[NSMutableArray alloc] init];
            if(![rsmObj isEqual:[NSNull null]]){
                for(NSDictionary * item in rsmObj){
                    WeCenterCommentInfo * info = [[WeCenterCommentInfo alloc] init];
                    info.cid = [item[@"id"] integerValue];
                    info.answerId = [item[@"answer_id"] integerValue];
                    info.uid = [item[@"uid"] integerValue];
                    info.message = item[@"message"];
                    info.addTime = item[@"time"];
                    
                    NSDictionary * dictCommentUserInfo = item[@"user_info"];
                    if(![dictCommentUserInfo isEqual:[NSNull null]]){
                        WeCenterUserInfo * commentUserInfo = [[WeCenterUserInfo alloc] init];
                        commentUserInfo.uid = [dictCommentUserInfo[@"uid"] integerValue];
                        commentUserInfo.userName = dictCommentUserInfo[@"user_name"];
                        commentUserInfo.avatarFile = dictCommentUserInfo[@"avatar_file"];
                        info.userInfo = commentUserInfo;
                    }
                    
                    NSDictionary * atUserInfos = item[@"at_user"];
                    if(![atUserInfos isEqual:[NSNull null]]){
                        NSMutableArray * atUserInfoList = [[NSMutableArray alloc] init];
                        for(NSString * key in atUserInfos){
                            NSDictionary * dictUser = atUserInfos[key];
                            WeCenterUserInfo * atUserInfo = [[WeCenterUserInfo alloc] init];
                            atUserInfo.uid = [dictUser[@"uid"] integerValue];
                            atUserInfo.userName = dictUser[@"user_name"];
                            atUserInfo.avatarFile = dictUser[@"avatar_file"];
                            [atUserInfoList addObject:atUserInfo];
                        }
                        
                        info.atUserInfoList = atUserInfoList;
                    }
                    
                    [infos addObject:info];
                }
            }
            success(infos);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
    
}

- (void)weCenterSaveAnswerCommentWithId:(NSInteger)answerId
                                message:(NSString *)message
                                success:(void(^)(NSInteger itemId, NSString * typeName))success
                                failure:(void(^)(NSError * error))failure{
    
    NSString * url = save_answer_comment_rest(wecenter_host, wecenter_question_sign);
    NSString * answerIdStr = [NSString stringWithFormat:@"%ld", (long)answerId];
    NSDictionary * params = @{@"answer_id": answerIdStr, @"message": message};
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            if(![rsmObj isEqual:[NSNull null]]){
                NSInteger itemId = [rsmObj[@"item_id"] integerValue];
                NSString * typeName = rsmObj[@"type_name"];
                success(itemId, typeName);
            }
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterRemoveAnswerCommentWithId:(NSInteger)commentId
                                     type:(NSString *)type
                                  success:(void(^)())success
                                  failure:(void(^)(NSError * error))failure{
    
    NSString * url = remove_answer_comment_rest(wecenter_host);
    url = [NSString stringWithFormat:@"%@?comment_id=%ld&type=%@", url , commentId, type];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            success();
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterSendMessageWithUserName:(NSString *)recipient
                                message:(NSString*)message
                                success:(void(^)())success
                                failure:(void(^)(NSError * error))failure{
    NSString * url = inbox_send_rest(wecenter_host, wecenter_inbox_sign);
    NSDictionary * params = @{@"recipient": recipient, @"message": message};
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            success();
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterInboxWithPage:(NSInteger)page
                      perPage:(NSInteger)perPage
                      success:(void(^)(NSArray * infos))success
                      failure:(void(^)(NSError * error))failure{
    
    NSString * url = inbox_rest(wecenter_host, wecenter_inbox_sign);
    url = [NSString stringWithFormat:@"%@&page=%ld&per_page=%ld", url, page, perPage];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSMutableArray * infos = [[NSMutableArray alloc] init];
            NSArray * items = rsmObj[@"rows"];
            if(![items isEqual:[NSNull null]]){
                for(NSDictionary * item in items){
                    WeCenterMessageInfo * info = [[WeCenterMessageInfo alloc] init];
                    info.mid = [item[@"id"] integerValue];
                    info.userName = item[@"user_name"];
                    info.urlToken = item[@"url_token"];
                    info.unread = [item[@"unread"] integerValue];
                    info.count = [item[@"count"] integerValue];
                    info.uid = [item[@"uid"] integerValue];
                    info.lastMessage = item[@"last_message"];
                    info.updateTime = item[@"update_time"];
                    [infos addObject:info];
                }
            }
            success(infos);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterGetDialogMessagesWithId:(NSInteger)dialogId
                                success:(void(^)(WeCenterDialogInfo * info))success
                                failure:(void(^)(NSError * error))failure{
    
    NSString * url = inbox_read_rest(wecenter_host, wecenter_inbox_sign);
    url = [NSString stringWithFormat:@"%@&id=%ld", url, (long)dialogId];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSDictionary * dictUserInfo = rsmObj[@"recipient_user"];
            WeCenterDialogInfo * info = [[WeCenterDialogInfo alloc] init];
            if(![dictUserInfo isEqual:[NSNull null]]){
                WeCenterUserInfo * toUserInfo = [[WeCenterUserInfo alloc] init];
                toUserInfo.uid = [dictUserInfo[@"uid"] integerValue];
                toUserInfo.userName = dictUserInfo[@"user_name"];
                toUserInfo.avatarFile = dictUserInfo[@"avatar_file"];
            }
            
            NSDictionary * items = rsmObj[@"rows"];
            if(![items isEqual:[NSNull null]]){
                NSMutableArray * dmInfos = [[NSMutableArray alloc] init];
                for(NSString * key in items){
                    NSDictionary * dInfo = items[key];
                    WeCenterDialogMessageInfo * dmInfo = [[WeCenterDialogMessageInfo alloc] init];
                    dmInfo.did = [dInfo[@"id"] integerValue];
                    dmInfo.recipientRemove = [dInfo[@"recipient_remove"] integerValue];
                    dmInfo.senderRemove = [dInfo[@"sender_remove"] integerValue];
                    dmInfo.dialogId = [dInfo[@"dialog_id"] integerValue];
                    dmInfo.receipt = dInfo[@"receipt"];
                    dmInfo.message = dInfo[@"message"];
                    dmInfo.urlToken = dInfo[@"url_token"];
                    dmInfo.userName = dInfo[@"user_name"];
                    dmInfo.addTime = dInfo[@"add_time"];
                    [dmInfos addObject:dmInfo];
                }
                info.dialogMessages = dmInfos;
            }
            
            success(info);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterGetUnreadNotificationsNum:(void(^)(NSInteger inboxNum, NSInteger notificationsNum))success
                                  failure:(void(^)(NSError * error))failure{
    
    NSString * url = notifications_rest(wecenter_host);
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            NSDictionary * rsmObj = responseJson[@"rsm"];
            NSInteger inboxNum = [rsmObj[@"inbox_num"] integerValue];
            NSInteger notificationsNum = [rsmObj[@"notifications_num"] integerValue];
            
            success(inboxNum, notificationsNum);
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)weCenterRemoveDialogWithId:(NSInteger)dialogId
                           success:(void(^)())success
                           failure:(void(^)(NSError * error))failure{
    
    NSString * url = remove_dialog_rest(wecenter_host, wecenter_inbox_sign);
    url = [NSString stringWithFormat:@"%@&dialog_id=%ld", url, (long)dialogId];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger errNo = [responseJson[@"errno"] integerValue];
        if(1 == errNo){//success
            success();
        }
        else{//failure
            NSString * err = @"";
            if(responseJson){
                err = responseJson[@"err"];
            }
            else{
                err = @"请登录先";
            }
            NSError * error = [NSError errorWithDomain:err code:errNo userInfo:nil];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

@end
