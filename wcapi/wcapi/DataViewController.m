//
//  DataViewController.m
//  wcapi
//
//  Created by 吴忠信 on 16/1/7.
//  Copyright © 2016年 吴忠信. All rights reserved.
//

#import "DataViewController.h"
#import "WeCenterClientApi.h"
#import "WeCenterClientModel.h"
#import "NSString+MD5.h"

@interface DataViewController ()
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, assign) NSInteger homePage;
@end

@implementation DataViewController

- (WeCenterClientApi*)api{
    if(!_api){
        _api = [[WeCenterClientApi alloc] init];
    }
    
    return _api;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.page = 1;
    self.homePage = 0;
}
- (IBAction)myModPwd:(id)sender {
    [self.api weCenterModifyPassword:@"admin" newPassword:@"admin" repeatNewPassword:@"admin" success:^{
        NSLog(@"mod success!");
    } failure:^(NSError *error) {
        NSLog(@"mod error: %@", error);
    }];
}
- (IBAction)myGetUID:(id)sender {
    [self.api weCenterGetCurrentUserId:^(NSInteger uid) {
        NSLog(@"current user id: %zd", uid);
    } failure:^(NSError *error) {
        NSLog(@"get current user id: %@", error);
    }];
}
- (IBAction)myGetFollows:(id)sender {
    [self.api weCenterGetFollowsOrFansWithId:1 type:@"follows" page:1 perPage:1 success:^(NSArray *infos) {
        NSLog(@"follow users: %@", infos);
    } failure:^(NSError *error) {
        NSLog(@"get follow users: %@", error);
    }];
}
- (IBAction)myGetUserArticles:(id)sender {
    [self.api weCenterGetUserContentsWithId:1 actions:501 page:self.page perPage:1 success:^(NSArray *infos) {
        if(infos && [infos count] > 0){
            WeCenterUserArticleInfo *info = (id)[infos objectAtIndex:0];
            NSLog(@"follow topics: %@", info.articleInfo.title);
            self.page = self.page + 1;
        }
    } failure:^(NSError *error) {
        NSLog(@"get user articles error: %@", error);
    }];
}
- (IBAction)myGetFollowTopics:(id)sender {
    [self.api weCenterGetFollowTopicsWithId:1 page:self.page perPage:1 success:^(NSArray *infos) {
        if(infos && [infos count] > 0){
            WeCenterTopicInfo *info = (id)[infos objectAtIndex:0];
            NSLog(@"follow topics: %@", info.topicTitle);
            self.page = self.page + 1;
        }
        
    } failure:^(NSError *error) {
        NSLog(@"get follow topics error: %@", error);
    }];
}
- (IBAction)myGetFans:(id)sender {
    [self.api weCenterGetFollowsOrFansWithId:1 type:@"fans" page:1 perPage:10 success:^(NSArray *infos) {
        NSLog(@"follow users: %@", infos);
    } failure:^(NSError *error) {
        NSLog(@"get follow users: %@", error);
    }];
}
- (IBAction)myUploadAvatar:(id)sender {
    UIImage * image = [UIImage imageNamed:@"113491870"];
    NSData* imageData = UIImagePNGRepresentation(image);
    
    [self.api weCenterUploadAvatar:imageData success:^(NSString *previewAvatar) {
        NSLog(@"upload avatar: %@", previewAvatar);
    } failure:^(NSError *error) {
        NSLog(@"upload avatar error: %@", error);
    }];
}
- (IBAction)myFollowUser:(id)sender {
    [self.api weCenterFollowUserWithId:2 success:^(NSString *type) {
        NSLog(@"follow type: %@", type);
    } failure:^(NSError *error) {
        NSLog(@"follow user error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)myLogout:(id)sender {
    [self.api weCenterLogout:^{
        NSLog(@"logout success");
    } failure:^(NSError *error) {
        NSLog(@"logout error: %@", error);
    }];
}
- (IBAction)myGetUserInfo:(id)sender {
    NSInteger uid = 1;
    [self.api weCenterGetUserInfoWithId:uid success:^(WeCenterUserInfo *userInfo) {
        NSLog(@"user info: %@", userInfo);
    } failure:^(NSError *error) {
        NSLog(@"get user info error: %@", error);
    }];
}
- (IBAction)myReg:(id)sender {
    [self.api weCenterRegisterWithUserName:@"风雨无阻" password:@"111111" email:@"test1@test.com" icode:@"" success:^(WeCenterUserInfo *userInfo) {
        NSLog(@"reg user info: %@", userInfo);
    } failure:^(NSError *error) {
        NSLog(@"reg error: %@", error);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}

- (IBAction)myButtonClick:(id)sender {
    [self.api weCenterLoginWithUserName:@"admin" password:@"admin" success:^(WeCenterUserInfo *userInfo) {
        NSLog(@"uid: %zd", userInfo.uid);
        [self.api weCenterGetUserInfoWithId:userInfo.uid success:^(WeCenterUserInfo *userInfo) {
            
        } failure:^(NSError *error) {
            
        }];
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)myGetUserQuestions:(id)sender {
    [self.api weCenterGetUserContentsWithId:1 actions:101 page:self.page perPage:1 success:^(NSArray *infos) {
        if(infos && [infos count] > 0){
            WeCenterUserQuestionInfo *info = (id)[infos objectAtIndex:0];
            NSLog(@"get user questions: %@", info.questionInfo.questionContent);
            self.page = self.page + 1;
        }
    } failure:^(NSError *error) {
        NSLog(@"get user questions error: %@", error);
    }];
}

- (IBAction)myGetUserAnswers:(id)sender {
    [self.api weCenterGetUserContentsWithId:1 actions:201 page:self.page perPage:1 success:^(NSArray *infos) {
        if(infos && [infos count] > 0){
            WeCenterUserAnswerInfo *info = (id)[infos objectAtIndex:0];
            NSLog(@"get user answers: %@", info.answerInfo.answerContent);
            self.page = self.page + 1;
        }
    } failure:^(NSError *error) {
        NSLog(@"get user answers error: %@", error);
    }];
}

- (IBAction)myModUserInfo:(id)sender {
    NSDictionary * params = @{@"sex": @"1"};
    [self.api weCenterSetUserProfile:params success:^{
        NSLog(@"set user profile success.");
    } failure:^(NSError *error) {
        NSLog(@"set user profile error: %@", error);
    }];
}

- (IBAction)myExplore:(id)sender {
    [self.api weCenterExplore:self.page perPage:20 topicId:0 day:30 isRecommend:1 sortType:@"new" success:^(NSArray *infos) {
        if([infos count] > 0){
            for(int i = 0; i < [infos count]; i++){
                if([infos[i] isKindOfClass:[WeCenterArticleInfo class]]){
                    WeCenterArticleInfo * ai = infos[i];
                    NSLog(@"article title: %@", ai.title);
                    NSLog(@"article user info: %@", ai.userInfo.userName);
                    
                }
                if([infos[i] isKindOfClass:[WeCenterQuestionInfo class]]){
                    WeCenterQuestionInfo * qi = infos[i];
                    NSLog(@"question content: %@", qi.questionContent);
                    NSLog(@"question answer user info: %@", qi.answerUsers);
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"explore error: %@", error);
    }];
}

- (IBAction)myHome:(id)sender {
    [self.api weCenterHome:self.homePage perPage:10 success:^(NSArray *infos) {
        if([infos count] > 0){
            for(int i = 0; i < [infos count]; i++){
                if([infos[i] isKindOfClass:[WeCenterHomeArticleInfo class]]){
                    WeCenterHomeArticleInfo * ai = infos[i];
                    NSLog(@"article title: %@", ai.articleInfo.title);
                    NSLog(@"article user info: %@", ai.userInfo.userName);
                    
                }
                if([infos[i] isKindOfClass:[WeCenterHomeQuestionInfo class]]){
                    WeCenterHomeQuestionInfo * qi = infos[i];
                    NSLog(@"question content: %@", qi.questionInfo.questionContent);
                    NSLog(@"answer content: %@", qi.answerInfo.answerContent);
                    NSLog(@"home quesion user info: %@", qi.userInfo);
                }
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"home error: %@", error);
    }];
}

- (IBAction)mySearch:(id)sender {
    [self.api weCenterSearch:@"测试" type:@"" page:self.page perPage:10 success:^(NSArray *infos) {
        if([infos count] > 0){
            for(int i = 0; i < [infos count]; i++){
                WeCenterSearchInfo * info = infos[i];
                NSLog(@"search name: %@", info.name);
                NSLog(@"search type: %@", info.type);
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"search error: %@", error);
    }];
}


- (IBAction)myAttachUpload:(id)sender {
    UIImage * image = [UIImage imageNamed:@"113491870"];
    NSData* imageData = UIImagePNGRepresentation(image);

    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    NSString * timestampStr = [NSString stringWithFormat:@"%f", timestamp];

    NSLog(@"access key: %@", [timestampStr MD5]);
    [self.api weCenterAttachUploadImage:@"article" attachAccessKey:timestampStr imageData:imageData success:^(WeCenterAttachInfo *info) {
        NSLog(@"attach info: %@", info);
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)myPublishArticle:(id)sender {
    [self.api weCenterPublishArticle:@"风雨无阻发个文章来看看" attachAccessKey:@"" message:@"偷得浮生半日闲" topics:@"默认话题" categoryId:1 success:^(NSInteger articleId) {
        NSLog(@"publish article id: %zd", articleId);
    } failure:^(NSError *error) {
        NSLog(@"publish article error: %@", error);
    }];
}

- (IBAction)myPubArtWithImg:(id)sender {
    UIImage * image = [UIImage imageNamed:@"113491870"];
    NSData* imageData = UIImagePNGRepresentation(image);
    
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    NSString * timestampStr = [NSString stringWithFormat:@"%f", timestamp];
    timestampStr = [timestampStr MD5];
    NSLog(@"access key: %@", [timestampStr MD5]);
    [self.api weCenterAttachUploadImage:@"article" attachAccessKey:timestampStr imageData:imageData success:^(WeCenterAttachInfo *info) {
        NSLog(@"attach info: %@", info.attachAccessKey);
        
        
        [self.api weCenterPublishArticle:@"发个文章来看看2" attachAccessKey:info.attachAccessKey message:@"偷得浮生半日闲" topics:@"默认话题" categoryId:1 success:^(NSInteger articleId) {
            NSLog(@"publish article id: %zd", articleId);
        } failure:^(NSError *error) {
            NSLog(@"publish article error: %@", error);
        }];
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)myPubQuestion:(id)sender {
    [self.api weCenterPublishQuestion:@"发个问题测试一下看看" questionDetail:@"猜猜我是谁" attachAccessKey:@"" topics:@"默认话题" categoryId:1 success:^(NSInteger questionId) {
        NSLog(@"question id: %zd", questionId);
    } failure:^(NSError *error) {
        NSLog(@"publish question error: %@", error);
    }];
}


- (IBAction)myPubQuestionWithImage:(id)sender {
    UIImage * image = [UIImage imageNamed:@"113491870"];
    NSData* imageData = UIImagePNGRepresentation(image);
    
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    NSString * timestampStr = [NSString stringWithFormat:@"%f", timestamp];
    timestampStr = [timestampStr MD5];
    NSLog(@"access key: %@", [timestampStr MD5]);
    [self.api weCenterAttachUploadImage:@"question" attachAccessKey:timestampStr imageData:imageData success:^(WeCenterAttachInfo *info) {
        NSLog(@"attach info: %@", info.attachAccessKey);
        
        [self.api weCenterPublishQuestion:@"发个问题测试一下看看3" questionDetail:@"猜猜我是谁，偷得浮生半日闲！" attachAccessKey:info.attachAccessKey topics:@"默认话题" categoryId:1 success:^(NSInteger questionId) {
            NSLog(@"question id: %zd", questionId);
        } failure:^(NSError *error) {
            NSLog(@"publish question error: %@", error);
        }];
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)myFocusTopic:(id)sender {
    [self.api weCenterFocusTopicWithId:4 success:^(NSString *type) {
        NSLog(@"focus topic: %@", type);
    } failure:^(NSError *error) {
        NSLog(@"focus topic error: %@", error);
    }];
}

- (IBAction)myTopicInfo:(id)sender {
    [self.api weCenterGetTopicInfoWithId:1 success:^(WeCenterTopicInfo *info) {
        NSLog(@"topic info title: %@", info.topicTitle);
    } failure:^(NSError *error) {
        NSLog(@"get topic info with id error: %@", error);
    }];
}

- (IBAction)myGetParentTopics:(id)sender {
    [self.api weCenterGetParentTopicsWithId:0 page:1 perPage:20 success:^(NSArray *infos) {
        if([infos count] > 0){
            for(int i = 0; i < [infos count]; i++){
                WeCenterTopicInfo * info = infos[i];
                NSLog(@"topic title: %@", info.topicTitle);
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"get parent topics error: %@", error);
    }];
}

- (IBAction)myGetChildTopics:(id)sender {
    [self.api weCenterGetChildTopicsWithId:3 page:1 perPage:20 success:^(NSArray *infos) {
        if([infos count] > 0){
            for(int i = 0; i < [infos count]; i++){
                WeCenterTopicInfo * info = infos[i];
                NSLog(@"topic title: %@", info.topicTitle);
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"get child topics error: %@", error);        
    }];
}

- (IBAction)myTopics:(id)sender {
    NSMutableArray * ids = [[NSMutableArray alloc] init];
    [ids addObject:@"1"];
    [ids addObject:@"2"];
    [ids addObject:@"3"];
    [ids addObject:@"4"];
    [self.api weCenterGetTopicsWithIds:ids success:^(NSArray *infos) {
        if([infos count] > 0){
            for(int i = 0; i < [infos count]; i++){
                WeCenterTopicInfo * info = infos[i];
                NSLog(@"topic title: %@", info.topicTitle);
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"get topics info error: %@", error);         
    }];
}

- (IBAction)myTopicBestAnswer:(id)sender {
    [self.api weCenterGetTopicBestAnswerWithId:1 page:self.page perPage:10 success:^(NSArray *infos) {
        if([infos count] > 0){
            for(int i = 0; i < [infos count]; i++){
                WeCenterTopicBestAnswer * info = infos[i];
                NSLog(@"topic title: %@", info.questionInfo.questionContent);
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"get topic best answer error: %@", error);
    }];
}

- (IBAction)myHotTopics:(id)sender {
    [self.api weCenterGetHotTopicsWithDay:@"" page:1 perPage:2 success:^(NSArray *infos) {
        if([infos count] > 0){
            for(int i = 0; i < [infos count]; i++){
                WeCenterTopicInfo * info = infos[i];
                NSLog(@"topic title: %@", info.topicTitle);
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"get hot topics info error: %@", error);
    }];
}

- (IBAction)myGetArticleInfo:(id)sender {
    [self.api weCenterGetArticleInfoWithId:10 commentPage:1 commentPerPage:3 success:^(WeCenterArticleInfo *info) {
        NSLog(@"article title: %@", info.title);
    } failure:^(NSError *error) {
        NSLog(@"get article info error: %@", error);
    }];
}


- (IBAction)myComments:(id)sender {
    [self.api weCenterGetArticleCommentsWithId:8 page:1 perPage:5 success:^(NSArray *infos) {
        if([infos count] >0){
            for(int i = 0; i < [infos count]; i++){
                WeCenterCommentInfo * info = infos[i];
                NSLog(@"comment info: %@", info.message);
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"get article comments error: %@", error);
    }];
}

- (IBAction)myFavorite:(id)sender {
    [self.api weCenterGetArticleInfoWithId:8 commentPage:1 commentPerPage:3 success:^(WeCenterArticleInfo *info) {
        NSLog(@"article title: %@", info.title);
        [self.api weCenterFavoriteItemWithId:info.aid itemType:@"article" tags:@"" success:^{
            
        } failure:^(NSError *error) {
            
        }];
    } failure:^(NSError *error) {
        NSLog(@"get article info error: %@", error);
    }];
}

- (IBAction)myRemoveFav:(id)sender {
    [self.api weCenterGetArticleInfoWithId:8 commentPage:1 commentPerPage:3 success:^(WeCenterArticleInfo *info) {
        NSLog(@"article title: %@", info.title);
        [self.api weCenterRemoveFavoriteItemWithId:info.aid itemType:@"article" success:^{
            
        } failure:^(NSError *error) {
            
        }];
    } failure:^(NSError *error) {
        NSLog(@"get article info error: %@", error);
    }];
}

- (IBAction)mySaveArtComment:(id)sender {
    [self.api weCenterSaveArticleCommentWithId:8 message:@"你猜猜我是谁，我就是我不一样的烟火" atUid:0 success:^(NSInteger commentId) {
        NSLog(@"save article comment id: %zd", commentId);
    } failure:^(NSError *error) {
        NSLog(@"save article comment error: %@", error);
    }];
}

- (IBAction)myRemoveArtComment:(id)sender {
    [self.api weCenterRemoveArticleCommentWithId:5 success:^{
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)myRemoveArticle:(id)sender {
    [self.api weCenterRemoveArticleWithId:7 success:^{
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)myVote:(id)sender {
    [self.api weCenterVoteItemWithId:9 itemType:@"article" rating:@"1" success:^{
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)myQuestionInfo:(id)sender {
    [self.api weCenterGetQuestionInfoWithId:14 answerPage:2 answerPerPage:1 sortKey:@"" sort:@"DESC" success:^(WeCenterQuestionInfo *info) {
        NSLog(@"question content: %@", info.questionContent);
        NSArray * answers = info.answers;
        if([answers count] > 0){
            for(int i = 0; i < [answers count]; i++){
                WeCenterAnswerInfo * info = answers[i];
                NSLog(@"answer content: %@", info.answerContent);
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"get question info error: %@", error);
    }];
}

- (IBAction)myFocusQuestion:(id)sender {
    [self.api weCenterFocusQuestionWithId:3 success:^(NSString *type) {
        NSLog(@"focus question type: %@", type);
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)myThanksQuestion:(id)sender {
    [self.api weCenterThanksQuestionWithId:3 success:^(NSString *action) {
        NSLog(@"thanks question type: %@", action);
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)myAnswerVote:(id)sender {
    [self.api weCenterAnswerVoteWithId:4 value:1 success:^{
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)mySaveAnswer:(id)sender {
    [self.api weCenterSaveAnswerWithId:3 answerContent:@"你猜猜我是谁啊" attachAccessKey:@"" autoFocus:1 success:^(WeCenterAnswerInfo *info) {
        NSLog(@"save question answer: %zd", info.answerId);
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)myRateQuestionAnswer:(id)sender {
    [self.api weCenterRateQuestionAnswerWithId:7 success:^(NSString *action) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)myInvite:(id)sender {
    [self.api weCenterSaveQuestionInviteWithId:14 uid:3 success:^{
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)myRemoveQuestion:(id)sender {
   [self.api weCenterRemoveQuestionWithId:16 success:^{
       
   } failure:^(NSError *error) {
       
   }];
}

- (IBAction)myGetAnswerInfo:(id)sender {
    [self.api weCenterGetAnswerInfoWithId:7 success:^(WeCenterAnswerInfo *info) {
        NSLog(@"get answer title: %@", info.answerContent);
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)myUpdateAnswer:(id)sender {
    [self.api weCenterUpdateAnswerWithId:3 answerContent:@"修改问题答案内容" success:^{
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)myRemoveAnswer:(id)sender {
    [self.api weCenterRemoveAnswerWithId:3 success:^{
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)myGetAnswerComments:(id)sender {
   [self.api weCenterGetAnswerCommentsWithId:4 page:1 perPage:1 success:^(NSArray *infos) {
       if([infos count] >0){
           for(WeCenterCommentInfo * info in infos){
               NSLog(@"answer content: %@", info.message);
           }
       }
   } failure:^(NSError *error) {
       
   }];
}

- (IBAction)myAnserComments:(id)sender {
    [self.api weCenterSaveAnswerCommentWithId:7 message:@"哇哈哈哇哈哈" success:^(NSInteger itemId, NSString *typeName) {
        NSLog(@"save answer comment id: %zd", itemId);
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)myRemoveAnswerComment:(id)sender {
    [self.api weCenterRemoveAnswerCommentWithId:6 type:@"answer" success:^{
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)mySendMessage:(id)sender {
    [self.api weCenterSendMessageWithUserName:@"风雨无阻" message:@"hello!" success:^{

    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)myInbox:(id)sender {
    [self.api weCenterInboxWithPage:1 perPage:2 success:^(NSArray *infos) {
        if([infos count] > 0){
            for(WeCenterMessageInfo * info in infos){
                NSLog(@"message: %@", info.lastMessage);
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)myMessageDialog:(id)sender {
    [self.api weCenterGetDialogMessagesWithId:1 success:^(WeCenterDialogInfo *info) {
        if([info.dialogMessages count] > 0){
            for(WeCenterDialogMessageInfo * dmInfo in info.dialogMessages){
                NSLog(@"dialog message: %@", dmInfo.message);
            }
        }
    } failure:^(NSError *error) {
        
    }];
}


- (IBAction)myUnreadMessageNum:(id)sender {
    [self.api weCenterGetUnreadNotificationsNum:^(NSInteger inboxNum, NSInteger notificationsNum) {
        NSLog(@"inbox unread count: %zd, notification unread count: %zd", inboxNum, notificationsNum);
    } failure:^(NSError *error) {
        
    }];
}


- (IBAction)myRemoveDialog:(id)sender {
    [self.api weCenterRemoveDialogWithId:1 success:^{
        NSLog(@"remove dialog success!");
    } failure:^(NSError *error) {
        NSLog(@"remove dialog error: %@", error);
    }];
}


@end
