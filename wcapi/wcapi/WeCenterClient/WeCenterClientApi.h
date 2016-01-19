//
//  WeCenterClientApi.h
//
//  Created by 吴忠信 on 16/1/7.
//  微信: wzx3188675 微博: 老吴_WZX
//  Licence MIT
//

// 说明:
// 该SDK基于AFNetworking3.0封装, 基于cocopods进行依赖管理
// 封装该SDK对原API有调整有增加, 调整主要包含以下方面:
// 1、对获取列表API无分页的添加分页支持;
// 2、对有分页而没有每页条数的API，增加每页条数支持;
// 3、增加必要API接口
// 对原有API的增加涉及的API目录文件的修改，涉及WeCenterModel文件的修改

#import <Foundation/Foundation.h>
#import "WeCenterClientModel.h"
#import "AFNetworking.h"

//api访问签名 - 具体规则参照api说明
#define wecenter_host @"http://we/index.php/"
#define wecenter_sign @"?mobile_sign=55bf0ab8439c514d12af0f0acdedd23b"
#define wecenter_people_sign @"?mobile_sign=611accea76c53e37c722158436626616"
#define wecenter_explore_sign @"?mobile_sign=3718be96f2fe3ea992462d3d7ed82197"
#define wecenter_home_sign @"?mobile_sign=73e85192aac08bec7494db783c14fb93"
#define wecenter_search_sign @"?mobile_sign=fe7b71612e8892cb3bfbb61d38f4d041"
#define wecenter_publish_sign @"?mobile_sign=c07bc3859f30c0cda29dfca030985aae"
#define wecenter_topic_sign @"?mobile_sign=f31e9c41759c4cc593e764fdc6970edd"
#define wecenter_article_sign @"?mobile_sign=3051da8e8bbaf0b295269901f61abacf"
#define wecenter_question_sign @"?mobile_sign=2e8bf6f8ec2cba45913d7052ae09aeac"
#define wecenter_inbox_sign @"?mobile_sign=a4ac79c9ee6ecb5f6c22978745a16ba1"

//api接口定义
#define login_rest @"api/account/login_process/"
#define get_user_rest(sign, uid) ([NSString stringWithFormat:@"api/account/get_userinfo/%@&uid=%zd", sign, uid])
#define logout_rest(host, sign) ([NSString stringWithFormat:@"%@api/account/logout/%@", host, sign])
#define register_rest(host, sign) ([NSString stringWithFormat:@"%@api/account/register_process/%@", host, sign])
#define upload_avatar_rest(host, sign) ([NSString stringWithFormat:@"%@api/account/avatar_upload/%@", host, sign])
#define get_uid_rest(host, sign) ([NSString stringWithFormat:@"%@api/account/get_uid/%@", host, sign])
#define modify_password_rest(host, sign) ([NSString stringWithFormat:@"%@api/account/modify_password/%@", host, sign])
#define follow_rest(host, sign) ([NSString stringWithFormat:@"%@follow/ajax/follow_people/%@", host, sign])
#define get_follows_fans_rest(host, sign) ([NSString stringWithFormat:@"%@api/people/follows/%@", host, sign])
#define follow_topics_rest(host, sign) ([NSString stringWithFormat:@"%@api/people/topics/%@", host, sign])
#define user_actions_rest(host, sign) ([NSString stringWithFormat:@"%@api/people/user_actions/%@", host, sign])
#define profile_setting_rest(host, sign) ([NSString stringWithFormat:@"%@api/people/profile_setting/%@", host, sign])
#define explore_rest(host, sign) ([NSString stringWithFormat:@"%@api/explore/%@", host, sign])
#define home_rest(host, sign) ([NSString stringWithFormat:@"%@api/home/%@", host, sign])
#define search_rest(host, sign) ([NSString stringWithFormat:@"%@api/search/%@", host, sign])
#define attach_upload(host, sign) ([NSString stringWithFormat:@"%@api/publish/attach_upload/%@", host, sign])
#define publish_question_rest(host, sign) ([NSString stringWithFormat:@"%@api/publish/publish_question/%@", host, sign])
#define publish_article_rest(host, sign) ([NSString stringWithFormat:@"%@api/publish/publish_article/%@", host, sign])
#define focus_topic_rest(host) ([NSString stringWithFormat:@"%@topic/ajax/focus_topic/", host])
#define topic_rest(host, sign) ([NSString stringWithFormat:@"%@api/topic/topic/%@", host, sign])
#define topics_rest(host, sign) ([NSString stringWithFormat:@"%@api/topic/topics/%@", host, sign])
#define parent_topic_rest(host, sign) ([NSString stringWithFormat:@"%@api/topic/parent_topics/%@", host, sign])
#define child_topic_rest(host, sign) ([NSString stringWithFormat:@"%@api/topic/child_topics/%@", host, sign])
#define topic_best_answer_rest(host, sign) ([NSString stringWithFormat:@"%@api/topic/topic_best_answer_list/%@", host, sign])
#define hot_topics_rest(host, sign) ([NSString stringWithFormat:@"%@api/topic/hot_topics/%@", host, sign])
#define article_rest(host, sign) ([NSString stringWithFormat:@"%@api/article/%@", host, sign])
#define article_comments_rest(host, sign) ([NSString stringWithFormat:@"%@api/article/article_comments/%@", host, sign])
#define favorite_tag_rest(host) ([NSString stringWithFormat:@"%@favorite/ajax/update_favorite_tag/", host])
#define remove_favorite_rest(host) ([NSString stringWithFormat:@"%@favorite/ajax/remove_favorite_item/", host])
#define save_comment_rest(host, sign) ([NSString stringWithFormat:@"%@api/article/save_comment/%@", host, sign])
#define remove_comment_rest(host, sign) ([NSString stringWithFormat:@"%@api/article/remove_comment/%@", host, sign])
#define remove_article_rest(host, sign) ([NSString stringWithFormat:@"%@api/article/remove_article/%@", host, sign])
#define vote_item_rest(host) ([NSString stringWithFormat:@"%@article/ajax/article_vote/", host])
#define question_rest(host, sign) ([NSString stringWithFormat:@"%@api/question/%@", host, sign])
#define focus_question_rest(host) ([NSString stringWithFormat:@"%@question/ajax/focus/", host])
#define thanks_question_rest(host) ([NSString stringWithFormat:@"%@question/ajax/question_thanks/", host])
#define answer_vote_rest(host) ([NSString stringWithFormat:@"%@question/ajax/answer_vote/", host])
#define question_answer_rate_rest(host) ([NSString stringWithFormat:@"%@question/ajax/question_answer_rate/", host])
#define save_invite_rest(host) ([NSString stringWithFormat:@"%@question/ajax/save_invite/", host])
#define remove_answer_comment_rest(host) ([NSString stringWithFormat:@"%@question/ajax/remove_comment/", host])
#define save_answer_rest(host, sign) ([NSString stringWithFormat:@"%@api/publish/save_answer/%@", host, sign])
#define save_answer_comment_rest(host, sign) ([NSString stringWithFormat:@"%@api/question/save_answer_comment/%@", host, sign])
#define remove_question_rest(host, sign) ([NSString stringWithFormat:@"%@api/question/remove_question/%@", host, sign])
#define get_answer_rest(host, sign) ([NSString stringWithFormat:@"%@api/question/answer/%@", host, sign])
#define update_answer_rest(host, sign) ([NSString stringWithFormat:@"%@api/question/update_answer/%@", host, sign])
#define answer_comments_rest(host, sign) ([NSString stringWithFormat:@"%@api/question/answer_comments/%@", host, sign])
#define inbox_send_rest(host, sign) ([NSString stringWithFormat:@"%@api/inbox/send/%@", host, sign])
#define inbox_rest(host, sign) ([NSString stringWithFormat:@"%@api/inbox/%@", host, sign])
#define inbox_read_rest(host, sign) ([NSString stringWithFormat:@"%@api/inbox/read/%@", host, sign])
#define notifications_rest(host) ([NSString stringWithFormat:@"%@home/ajax/notifications/", host])
#define remove_dialog_rest(host, sign) ([NSString stringWithFormat:@"%@api/inbox/remove_dialog/%@", host, sign])


@interface WeCenterClientApi : NSObject

//AFNetworking对象单例
@property(nonatomic, copy) AFHTTPSessionManager *manager;

//用户注册
- (void)weCenterRegisterWithUserName:(NSString*)userName
                password:(NSString*)password
                   email:(NSString*)email
                   icode:(NSString*)icode
                 success:(void(^)(WeCenterUserInfo* userInfo))success
                 failure:(void(^)(NSError* error))failure;

//用户登录
- (void)weCenterLoginWithUserName:(NSString*)userName
             password:(NSString*)password
              success:(void(^)(WeCenterUserInfo* userInfo))success
              failure:(void(^)(NSError* error))failure;

//用户注销
- (void)weCenterLogout:(void(^)())success
               failure:(void(^)(NSError* error))failure;

//获取用户信息
- (void)weCenterGetUserInfoWithId:(NSInteger)uid
                    success:(void(^)(WeCenterUserInfo* userInfo))success
                    failure:(void(^)(NSError* error))failure;

//获取当前用户ID
- (void)weCenterGetCurrentUserId:(void(^)(NSInteger uid))success
                         failure:(void(^)(NSError * error))failure;

//上传用户头像
- (void)weCenterUploadAvatar:(NSData *)imageData
                     success:(void(^)(NSString * previewAvatar))success
                     failure:(void(^)(NSError * error))failure;
//修改口令接口
- (void)weCenterModifyPassword:(NSString*)oldPassword
                   newPassword:(NSString*)newPassword
             repeatNewPassword:(NSString*)repeatNewPassword
                       success:(void(^)())success
                       failure:(void(^)(NSError * error))failure;

//关注用户
- (void)weCenterFollowUserWithId:(NSInteger)uid
                   success:(void(^)(NSString * type))success
                   failure:(void(^)(NSError * error))failure;

//获取关注用户/粉丝列表
- (void)weCenterGetFollowsOrFansWithId:(NSInteger)uid
                            type:(NSString*)type
                            page:(NSInteger)page
                         perPage:(NSInteger)perPage
                         success:(void(^)(NSArray * infos))success
                         failure:(void(^)(NSError * error))failure;

//获取关注的话题列表
- (void)weCenterGetFollowTopicsWithId:(NSInteger)uid
                           page:(NSInteger)page
                        perPage:(NSInteger)perPage
                        success:(void(^)(NSArray * infos))success
                        failure:(void(^)(NSError * error))failure;

//获取用户文章/问题/回答 - 501:文章，101:问题，201:回答
- (void)weCenterGetUserContentsWithId:(NSInteger)uid
                        actions:(NSInteger)actions
                           page:(NSInteger)page
                        perPage:(NSInteger)perPage
                        success:(void(^)(NSArray * infos))success
                        failure:(void(^)(NSError * error))failure;
//修改用户信息
//param - {@"user_name": @"admin"} or {@"sex": 1} or {@"user_name": @"admin", @"sex": 1}
- (void)weCenterSetUserProfile:(NSDictionary *)param
                       success:(void(^)())success
                       failure:(void(^)(NSError * error))failure;

//发现
- (void)weCenterExplore:(NSInteger)page
                perPage:(NSInteger)perPage
                topicId:(NSInteger)topicId
                    day:(NSInteger)day
            isRecommend:(NSInteger)isRecommend
               sortType:(NSString*)sortType
                success:(void(^)(NSArray * infos))success
                failure:(void(^)(NSError * error))failure;
//热点
- (void)weCenterHome:(NSInteger)page
             perPage:(NSInteger)perPage
             success:(void(^)(NSArray * infos))success
             failure:(void(^)(NSError * error))failure;

//检索
- (void)weCenterSearch:(NSString *)q
                  type:(NSString *)type
                  page:(NSInteger)page
               perPage:(NSInteger)perPage
               success:(void(^)(NSArray * infos))success
               failure:(void(^)(NSError * error))failure;

//上传一个附件图片 - 如果上传多需要多次调用, 切插入不能使用attachAccessKey
//要使用[attach]attachId[/attach]直接插入到message或者content
- (void)weCenterAttachUploadImage:(NSString *)auId
             attachAccessKey:(NSString *)attachAccessKey
                        imageData:(NSData *)imageData
                          success:(void(^)(WeCenterAttachInfo * info))success
                          failure:(void(^)(NSError * error))failure;

//发布文章
- (void)weCenterPublishArticle:(NSString *)title
               attachAccessKey:(NSString *)attachAccessKey
                       message:(NSString *)message
                        topics:(NSString *)topics
                    categoryId:(NSInteger)categoryId
                       success:(void(^)(NSInteger articleId))success
                       failure:(void(^)(NSError * error))failure;
//提问
- (void)weCenterPublishQuestion:(NSString *)questionContent
                 questionDetail:(NSString *)questionDetail
               attachAccessKey:(NSString *)attachAccessKey
                        topics:(NSString *)topics
                    categoryId:(NSInteger)categoryId
                       success:(void(^)(NSInteger questionId))success
                       failure:(void(^)(NSError * error))failure;

//关注话题
- (void)weCenterFocusTopicWithId:(NSInteger)topicId
                         success:(void(^)(NSString * type))success
                         failure:(void(^)(NSError * error))failure;
//根据topicId获取话题数据
- (void)weCenterGetTopicInfoWithId:(NSInteger)topicId
                            success:(void(^)(WeCenterTopicInfo * info))success
                            failure:(void(^)(NSError * error))failure;
//根据topicTitle获取话题数据
- (void)weCenterGetTopicInfoWithTitle:(NSString *)topicTitle
                            success:(void(^)(WeCenterTopicInfo * info))success
                            failure:(void(^)(NSError * error))failure;
//根据topicIds批量获取话题
- (void)weCenterGetTopicsWithIds:(NSArray *)topicIds
                         success:(void(^)(NSArray * infos))success
                         failure:(void(^)(NSError * error))failure;

//根据topicId获取所有父话题 - 该接口由吴忠信(@老吴_WZX)添加
//topicId=0时获取所有父话题
- (void)weCenterGetParentTopicsWithId:(NSInteger)topicId
                                 page:(NSInteger)page
                              perPage:(NSInteger)perPage
                              success:(void(^)(NSArray * infos))success
                              failure:(void(^)(NSError * error))failure;

//根据topicId获取子话题 - 该接口由吴忠信(@老吴_WZX)添加
- (void)weCenterGetChildTopicsWithId:(NSInteger)topicId
                                 page:(NSInteger)page
                              perPage:(NSInteger)perPage
                              success:(void(^)(NSArray * infos))success
                              failure:(void(^)(NSError * error))failure;

//获取话题最佳答案
- (void)weCenterGetTopicBestAnswerWithId:(NSInteger)topicId
                                    page:(NSInteger)page
                                 perPage:(NSInteger)perPage
                                 success:(void(^)(NSArray * infos))success
                                 failure:(void(^)(NSError * error))failure;
//获取话题热帖
- (void)weCenterGetHotTopicsWithDay:(NSString*)day
                               page:(NSInteger)page
                            perPage:(NSInteger)perPage
                            success:(void(^)(NSArray * infos))success
                            failure:(void(^)(NSError * error))failure;

//获取文章信息
- (void)weCenterGetArticleInfoWithId:(NSInteger)articleId
                                commentPage:(NSInteger)commentPage
                             commentPerPage:(NSInteger)commentPerPage
                             success:(void(^)(WeCenterArticleInfo * info))success
                             failure:(void(^)(NSError * error))failure;

//获取文章评论
//个人感觉该接口功能与获取文章信息接口功能同质化
- (void)weCenterGetArticleCommentsWithId:(NSInteger)articleId
                             page:(NSInteger)page
                          perPage:(NSInteger)perPage
                          success:(void(^)(NSArray * infos))success
                          failure:(void(^)(NSError * error))failure;

//收藏文章/话题/答案
- (void)weCenterFavoriteItemWithId:(NSInteger)itemId
                          itemType:(NSString *)itemType
                              tags:(NSString *)tags
                           success:(void(^)())success
                           failure:(void(^)(NSError * error))failure;

//删除收藏内容
- (void)weCenterRemoveFavoriteItemWithId:(NSInteger)itemId
                                itemType:(NSString *)itemType
                                 success:(void(^)())success
                                 failure:(void(^)(NSError * error))failure;
//发表文章评论
- (void)weCenterSaveArticleCommentWithId:(NSInteger)articleId
                                 message:(NSString *)message
                                   atUid:(NSInteger)atUid
                                 success:(void(^)(NSInteger commentId))success
                                 failure:(void(^)(NSError * error))failure;

//删除文章评论
- (void)weCenterRemoveArticleCommentWithId:(NSInteger)commentId
                                   success:(void(^)())success
                                   failure:(void(^)(NSError * error))failure;

//删除文章
- (void)weCenterRemoveArticleWithId:(NSInteger)articleId
                            success:(void(^)())success
                            failure:(void(^)(NSError * error))failure;

//顶踩文章/问题/答案
- (void)weCenterVoteItemWithId:(NSInteger)itemId
                      itemType:(NSString *)itemType
                        rating:(NSString *)rating
                       success:(void(^)())success
                       failure:(void(^)(NSError * error))failure;

//获取问题信息
- (void)weCenterGetQuestionInfoWithId:(NSInteger)questionId
                                 answerPage:(NSInteger)answerPage
                              answerPerPage:(NSInteger)answerPerPage
                                    sortKey:(NSString *)sortKey
                                       sort:(NSString *)sort
                                    success:(void(^)(WeCenterQuestionInfo * info))success
                                    failure:(void(^)(NSError * error))failure;

//关注问题
- (void)weCenterFocusQuestionWithId:(NSInteger)questionId
                            success:(void(^)(NSString * type))success
                            failure:(void(^)(NSError * error))failure;

//感谢问题
- (void)weCenterThanksQuestionWithId:(NSInteger)questionId
                             success:(void(^)(NSString * action))success
                             failure:(void(^)(NSError * error))failure;

//顶踩问题答案
- (void)weCenterAnswerVoteWithId:(NSInteger)answerId
                           value:(NSInteger)value
                         success:(void(^)())success
                         failure:(void(^)(NSError * error))failure;

//回答问题
- (void)weCenterSaveAnswerWithId:(NSInteger)questionId
                   answerContent:(NSString *)answerContent
                 attachAccessKey:(NSString *)attachAccessKey
                       autoFocus:(NSInteger)autoFocus
                         success:(void(^)(WeCenterAnswerInfo* info))success
                         failure:(void(^)(NSError * error))failure;

//评价问题答案
- (void)weCenterRateQuestionAnswerWithId:(NSInteger)answerId
                                 success:(void(^)(NSString * action))success
                                 failure:(void(^)(NSError * error))failure;

//邀请回答问题
- (void)weCenterSaveQuestionInviteWithId:(NSInteger)questionId
                                     uid:(NSInteger)uid
                                 success:(void(^)())success
                                 failure:(void(^)(NSError * error))failure;
//删除问题
- (void)weCenterRemoveQuestionWithId:(NSInteger)questionId
                             success:(void(^)())success
                             failure:(void(^)(NSError * error))failure;
//获取答案信息
- (void)weCenterGetAnswerInfoWithId:(NSInteger)answerId
                            success:(void(^)(WeCenterAnswerInfo * info))success
                            failure:(void(^)(NSError * error))failure;
//删除答案
- (void)weCenterRemoveAnswerWithId:(NSInteger)answerId
                           success:(void(^)())success
                           failure:(void(^)(NSError * error))failure;
//更新答案
- (void)weCenterUpdateAnswerWithId:(NSInteger)answerId
                     answerContent:(NSString *)answerContent
                           success:(void(^)())success
                           failure:(void(^)(NSError * error))failure;

//获取答案评论 - 分页由吴忠信(@老吴_WZX)添加
- (void)weCenterGetAnswerCommentsWithId:(NSInteger)answerId
                                   page:(NSInteger)page
                                perPage:(NSInteger)perPage
                                success:(void(^)(NSArray * infos))success
                                failure:(void(^)(NSError * error))failure;

//发表答案评论
- (void)weCenterSaveAnswerCommentWithId:(NSInteger)answerId
                                message:(NSString *)message
                                success:(void(^)(NSInteger itemId, NSString * typeName))success
                                failure:(void(^)(NSError * error))failure;

//删除答案评论
- (void)weCenterRemoveAnswerCommentWithId:(NSInteger)commentId
                                     type:(NSString *)type
                                  success:(void(^)())success
                                  failure:(void(^)(NSError * error))failure;

//发私信
- (void)weCenterSendMessageWithUserName:(NSString *)recipient
                                message:(NSString*)message
                                success:(void(^)())success
                                failure:(void(^)(NSError * error))failure;

//获取私信列表
- (void)weCenterInboxWithPage:(NSInteger)page
                      perPage:(NSInteger)perPage
                      success:(void(^)(NSArray * infos))success
                      failure:(void(^)(NSError * error))failure;

//获取私信对话列表
- (void)weCenterGetDialogMessagesWithId:(NSInteger)dialogId
                                success:(void(^)(WeCenterDialogInfo * info))success
                                failure:(void(^)(NSError * error))failure;

//获取未读通知
- (void)weCenterGetUnreadNotificationsNum:(void(^)(NSInteger inboxNum, NSInteger notificationsNum))success
                                failure:(void(^)(NSError * error))failure;

//删除私信对话 - 该接口由吴忠信(@老吴_WZX)添加
- (void)weCenterRemoveDialogWithId:(NSInteger)dialogId
                           success:(void(^)())success
                           failure:(void(^)(NSError * error))failure;

@end
