//
//  WeCenterClientModel.h
//  wcapi
//
//  Created by 吴忠信 on 16/1/7.
//  Copyright © 2016年 吴忠信. All rights reserved.
//

//  封装API数据结构

#import <Foundation/Foundation.h>

//封装AssociateAction, 接口中暂未使用, 在使用SDK开发时会用到该type
typedef NS_ENUM(NSInteger, WeCenterAssociateAction) {
    WeCenterAssociateActionAddQuestion = 101,
    WeCenterAssociateActionModQuestionTitle = 102,
    WeCenterAssociateActionModQuestionDescri = 103,
    WeCenterAssociateActionAddQuestionFocus = 105,
    WeCenterAssociateActionRedirectQuestion = 107,
    WeCenterAssociateActionModQuestionCategory = 108,
    WeCenterAssociateActionModQuestionAttach = 109,
    WeCenterAssociateActionDelRedirectQuestion = 110,
    WeCenterAssociateActionAnswerQuestion = 201,
    WeCenterAssociateActionAddAgree = 204,
    WeCenterAssociateActionAddUseful = 206,
    WeCenterAssociateActionAddUnuseful = 207,
    WeCenterAssociateActionAddTopic = 401,
    WeCenterAssociateActionModTopic = 402,
    WeCenterAssociateActionModTopicDescri = 403,
    WeCenterAssociateActionModTopicPic = 404,
    WeCenterAssociateActionDeleteTopic = 405,
    WeCenterAssociateActionAddTopicFocus = 406,
    WeCenterAssociateActionAddRelatedTopic = 410,
    WeCenterAssociateActionDeleteRelatedTopic = 411,
    WeCenterAssociateActionAddArticle = 501,
    WeCenterAssociateActionAddAgreeArticle = 502,
    WeCenterAssociateActionAddCommentArticle = 503
};

@class WeCenterUserInfo;
@class WeCenterArticleInfo;
@class WeCenterQuestionInfo;
@class WeCenterAnswerInfo;
@class WeCenterVoteInfo;

//私信对话信息对象
@interface WeCenterDialogInfo : NSObject
@property(nonatomic, strong) WeCenterUserInfo * toUserInfo;
@property(nonatomic, strong) NSArray * dialogMessages;
@end

//对话信息数据结构
@interface WeCenterDialogMessageInfo : NSObject
@property(nonatomic, assign) NSInteger did;
@property(nonatomic, assign) NSInteger uid;
@property(nonatomic, assign) NSInteger dialogId;
@property(nonatomic, copy) NSString * message;
@property(nonatomic, strong) NSNumber * addTime;
@property(nonatomic, assign) NSInteger senderRemove;
@property(nonatomic, assign) NSInteger recipientRemove;
@property(nonatomic, strong) NSNumber * receipt;
@property(nonatomic, copy) NSString * userName;
@property(nonatomic, copy) NSString * urlToken;
@end

//私信数据结构
@interface WeCenterMessageInfo : NSObject
@property(nonatomic, assign) NSInteger mid;
@property(nonatomic, copy) NSString * userName;
@property(nonatomic, copy) NSString * urlToken;
@property(nonatomic, assign) NSInteger unread;
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, assign) NSInteger uid;
@property(nonatomic, copy) NSString * lastMessage;
@property(nonatomic, strong) NSNumber * updateTime;
@end

//最佳答案对象
@interface WeCenterTopicBestAnswer : NSObject
@property(nonatomic, strong) WeCenterUserInfo * userInfo;
@property(nonatomic, strong) WeCenterQuestionInfo * questionInfo;
@property(nonatomic, strong) WeCenterAnswerInfo * answerInfo;
@end

//附件数据结构
@interface WeCenterAttachInfo : NSObject
@property(nonatomic, assign) NSInteger attachId;
@property(nonatomic, copy) NSString * attachAccessKey;
@property(nonatomic, copy) NSString * thumb;
@property(nonatomic, copy) NSString * fileLocation;
@property(nonatomic, assign) NSInteger isImage;
@property(nonatomic, copy) NSString * fileName;
@property(nonatomic, copy) NSString * path;
@property(nonatomic, copy) NSString * attachment;
@end

//检索结果数据结构
@interface WeCenterSearchInfo : NSObject
@property(nonatomic, assign) NSInteger searchId;
@property(nonatomic, copy) NSString * type;
@property(nonatomic, copy) NSString * name;
@property(nonatomic, strong) NSObject * detail;
@end

//动态问题对象
@interface WeCenterHomeQuestionInfo : NSObject
@property(nonatomic, assign) NSInteger historyId;
@property(nonatomic, assign) NSInteger associateAction;
@property(nonatomic, strong) NSNumber * addTime;
@property(nonatomic, strong) WeCenterUserInfo * userInfo;
@property(nonatomic, strong) WeCenterQuestionInfo * questionInfo;
@property(nonatomic, strong) WeCenterAnswerInfo * answerInfo;
@end

//动态文章对象
@interface WeCenterHomeArticleInfo : NSObject
@property(nonatomic, assign) NSInteger historyId;
@property(nonatomic, assign) NSInteger associateAction;
@property(nonatomic, strong) NSNumber * addTime;
@property(nonatomic, strong) WeCenterUserInfo * userInfo;
@property(nonatomic, strong) WeCenterArticleInfo * articleInfo;
@end


//用户回答信息
@interface WeCenterUserAnswerInfo : NSObject
@property(nonatomic, assign) NSInteger historyId;
@property(nonatomic, assign) NSInteger associateAction;
@property(nonatomic, strong) NSNumber * addTime;
@property(nonatomic, strong) WeCenterAnswerInfo * answerInfo;
@end

//回答信息
@interface WeCenterAnswerInfo : NSObject
@property(nonatomic, assign) NSInteger answerId; //回答编号
@property(nonatomic, copy) NSString * answerContent; //回答内容
@property(nonatomic, strong) NSNumber * addTime; //回答添加时间
@property(nonatomic, assign) NSInteger agreeCount; //回答赞同数
@property(nonatomic, assign) NSInteger againstCount; //
@property(nonatomic, assign) NSInteger questionId; //问题ID
@property(nonatomic, assign) NSInteger uid;
@property(nonatomic, assign) NSInteger commentCount;
@property(nonatomic, assign) NSInteger uninterestedCount;
@property(nonatomic, assign) NSInteger thanksCount;
@property(nonatomic, assign) NSInteger categoryId;
@property(nonatomic, assign) NSInteger hasAttach;
@property(nonatomic, assign) NSInteger ip;
@property(nonatomic, assign) NSInteger forceFold;
@property(nonatomic, assign) NSInteger anonymous;
@property(nonatomic, copy) NSString * publishSource;
@property(nonatomic, assign) NSInteger userVoteStatus;
@property(nonatomic, assign) NSInteger userThanksStatus;
@property(nonatomic, strong) WeCenterUserInfo * userInfo; //用户信息
@property(nonatomic, copy) NSString * questionContent;
@property(nonatomic, assign) NSInteger userRatedThanks;
@property(nonatomic, assign) NSInteger userRatedUninterested;
@property(nonatomic, assign) NSInteger agreeStatus;
@end

//用户问题信息
@interface WeCenterUserQuestionInfo : NSObject
@property(nonatomic, assign) NSInteger historyId;
@property(nonatomic, assign) NSInteger associateAction;
@property(nonatomic, strong) NSNumber * addTime;
@property(nonatomic, strong) WeCenterQuestionInfo * questionInfo;
@end

//问题信息
@interface WeCenterQuestionInfo : NSObject
@property(nonatomic, assign) NSInteger questionId; //问题编号
@property(nonatomic, copy) NSString * questionContent; //问题标题
@property(nonatomic, copy) NSString * questionDetail; //问题详情
@property(nonatomic, assign) NSInteger answerCount; //回答数目
@property(nonatomic, assign) NSInteger viewCount; //浏览数目
@property(nonatomic, assign) NSInteger agreeCount;
@property(nonatomic, strong) NSNumber * addTime; //创建时间
@property(nonatomic, strong) NSNumber * updateTime; //更新时间
@property(nonatomic, strong) NSArray * answerUsers; //回答用户列表
@property(nonatomic, assign) NSInteger againstCount;
@property(nonatomic, copy) NSString * postType;
@property(nonatomic, strong) NSArray * topics;
@property(nonatomic, strong) WeCenterUserInfo * userInfo;
@property(nonatomic, assign) NSInteger userAnswered;
@property(nonatomic, assign) NSInteger bestAnswer;
@property(nonatomic, assign) NSInteger commentCount;
@property(nonatomic, assign) NSInteger focusCount;
@property(nonatomic, assign) NSInteger thanksCount;

@property(nonatomic, assign) NSInteger userThanks;
@property(nonatomic, assign) NSInteger userFollowCheck;
@property(nonatomic, assign) NSInteger userQuestionFocus;
@property(nonatomic, strong) NSArray * answers;

@end

//用户文章信息
@interface WeCenterUserArticleInfo : NSObject
@property(nonatomic, assign) NSInteger historyId;
@property(nonatomic, assign) NSInteger associateAction;
@property(nonatomic, strong) NSNumber * addTime;
@property(nonatomic, strong) WeCenterArticleInfo * articleInfo;
@end

//文章信息
@interface WeCenterArticleInfo : NSObject
@property(nonatomic, assign) NSInteger aid; //文章ID
@property(nonatomic, assign) NSInteger uid; //用户ID
@property(nonatomic, copy) NSString * title;
@property(nonatomic, copy) NSString * message; //文章内容
@property(nonatomic, assign) NSInteger comments; //评论数
@property(nonatomic, assign) NSInteger views; //浏览数
@property(nonatomic, strong) NSNumber * addTime; //创建时间
@property(nonatomic, assign) NSInteger hasAttach; //是否有附件
@property(nonatomic, assign) NSInteger lock; //
@property(nonatomic, copy) NSString * titleFulltext;
@property(nonatomic, assign) NSInteger categoryId;
@property(nonatomic, assign) NSInteger isRecommend;
@property(nonatomic, assign) NSInteger chapterId;
@property(nonatomic, assign) NSInteger sort;
@property(nonatomic, copy) NSString * postType;
@property(nonatomic, assign) NSInteger votes;
@property(nonatomic, strong) NSArray * attachs;
@property(nonatomic, strong) NSArray * topics;
@property(nonatomic, strong) NSArray * answerUsers;
@property(nonatomic, strong) WeCenterUserInfo * userInfo;
@property(nonatomic, strong) WeCenterVoteInfo * voteInfo;
@property(nonatomic, strong) NSArray * voteUsers;
@property(nonatomic, strong) NSArray * commentList;
@property(nonatomic, assign) NSInteger userFollowCheck; //是否关注当前作者

@end

//评论信息
@interface WeCenterCommentInfo : NSObject
@property(nonatomic, assign) NSInteger cid;
@property(nonatomic, assign) NSInteger uid;
@property(nonatomic, assign) NSInteger articleId;
@property(nonatomic, assign) NSInteger answerId;
@property(nonatomic, copy) NSString * message;
@property(nonatomic, strong) NSNumber * addTime;
@property(nonatomic, assign) NSInteger atUid;
@property(nonatomic, assign) NSInteger votes;
@property(nonatomic, strong) WeCenterUserInfo * userInfo;
@property(nonatomic, strong) WeCenterUserInfo * atUserInfo;
@property(nonatomic, strong) WeCenterVoteInfo * voteInfo;
@property(nonatomic, strong) NSArray * atUserInfoList;
@end

//评价信息
@interface WeCenterVoteInfo : NSObject
@property(nonatomic, assign) NSInteger vid;
@property(nonatomic, assign) NSInteger uid;
@property(nonatomic, copy) NSString * type;
@property(nonatomic, copy) NSString * article;
@property(nonatomic, assign) NSInteger itemId;
@property(nonatomic, assign) NSInteger rating;
@property(nonatomic, strong) NSNumber * time;
@property(nonatomic, assign) NSInteger reputationFactor;
@property(nonatomic, assign) NSInteger itemUid;
@end

//话题信息
@interface WeCenterTopicInfo : NSObject
@property(nonatomic, assign) NSInteger topicId; //话题ID
@property(nonatomic, copy) NSString * topicTitle; //话题标题
@property(nonatomic, strong) NSNumber * addTime; //创建时间
@property(nonatomic, assign) NSInteger discussCount; //讨论数
@property(nonatomic, copy) NSString * topicDescription; //话题描述
@property(nonatomic, copy) NSString * topicPic;	//话题图片
@property(nonatomic, assign) NSInteger topicLock; //是否已锁定，1:已锁定 0:未锁定
@property(nonatomic, assign) NSInteger focusCount; //关注数
@property(nonatomic, assign) NSInteger discussCountLastWeek; //最近一周讨论次数
@property(nonatomic, assign) NSInteger discussCountLastMonth; //最近一月讨论次数
@property(nonatomic, strong) NSNumber * discussCountUpdate; //最近一次讨论时间
@property(nonatomic, assign) NSInteger hasFocus; //当前用户是否关注 1 - 关注 0 - 未关注
@property(nonatomic, assign) NSInteger userRelated;
@property(nonatomic, copy) NSString * urlToken;
@property(nonatomic, assign) NSInteger mergedId;
@property(nonatomic, copy) NSString * mergedTip;
@property(nonatomic, copy) NSString * seoTitle;
@property(nonatomic, assign) NSInteger parentId;
@property(nonatomic, assign) NSInteger isParent;
@end

//关注数据结构
@interface WeCenterFollowInfo : NSObject
@property(nonatomic, assign) NSInteger uid;
@property(nonatomic, copy) NSString * userName;
@property(nonatomic, assign) NSInteger agreeCount;
@property(nonatomic, assign) NSInteger thanksCount;
@property(nonatomic, assign) NSInteger reputation;
@property(nonatomic, copy) NSString* signature;
@property(nonatomic, copy) NSString* avatarFile;
@end

//用户信息数据结构
@interface WeCenterUserInfo : NSObject
@property(nonatomic, assign) NSInteger uid; //用户ID
@property(nonatomic, copy) NSString* userName; //当前登录用户名
@property(nonatomic, copy) NSString* email; //邮箱
@property(nonatomic, copy) NSString* mobile; //手机号
@property(nonatomic, copy) NSString* avatarFile; //头像地址
@property(nonatomic, assign) NSInteger sex; //性别
@property(nonatomic, copy) NSString* signature; //一句话签名
@property(nonatomic, copy) NSString* province; //省份或直辖市
@property(nonatomic, copy) NSString* city; //城市或地区
@property(nonatomic, assign) NSInteger reputation;
@property(nonatomic, assign) NSInteger fansCount; //粉丝数
@property(nonatomic, assign) NSInteger friendCount; //关注数
@property(nonatomic, assign) NSInteger articleCount; //文章数
@property(nonatomic, assign) NSInteger questionCount; //问题数
@property(nonatomic, assign) NSInteger answerCount; //回答数
@property(nonatomic, assign) NSInteger topicFocusCount; //关注话题数
@property(nonatomic, assign) NSInteger agreeCount; //获得赞同数
@property(nonatomic, assign) NSInteger thanksCount; //获得感谢数
@property(nonatomic, assign) NSInteger viewsCount; //个人首页查看数
@property(nonatomic, assign) NSInteger answerFavoriteCount; //答案被收藏数
@property(nonatomic, assign) NSInteger hasFocus; //是否关注当前用户 1 - 关注 0 - 未关注
@property(nonatomic, assign) NSInteger isFirstLogin; //是否第一次登录
@property(nonatomic, assign) NSInteger validEmail; //是否验证邮箱
@property(nonatomic, assign) NSInteger QQ; //QQ号
@property(nonatomic, assign) NSInteger birthdayYear; //生日年份
@property(nonatomic, assign) NSInteger birthdayMonth; //生日月份
@property(nonatomic, assign) NSInteger birthdayDay; //生日天
@property(nonatomic, copy) NSString * commonEmail; //常用邮箱
@property(nonatomic, copy) NSString * homepage; //个人主页
@property(nonatomic, assign) NSInteger jobId; //职业ID

@end

@interface WeCenterClientModel : NSObject

@end
