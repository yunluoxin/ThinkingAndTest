//
//  CrashKiller.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/7/18.
//  Copyright © 2019 dadong. All rights reserved.
//

#import "CrashKiller.h"
#import <objc/runtime.h>

static BOOL shouldHookClass(Class clazz) {
    if (!clazz) {
        return NO;
    }
    
    NSString *className = NSStringFromClass(clazz);
    if ([className hasPrefix:@"UI"]
        || [className hasPrefix:@"_"]
        ) {
        return NO;
    }
    return YES;
}

static void ck_exchangeMethod(Class originCls, SEL originSel, Class targetCls, SEL targetSel) {
    if (!originCls || !targetCls) {
        return;
    }
    
    // 系统的就不Hook了
    if (shouldHookClass(originCls) == NO) {
        return;
    }
    
    // 原方法
    Method originMethod = class_getInstanceMethod(originCls, originSel);
    // 替换的方法
    Method targetMethod = class_getInstanceMethod(targetCls, targetSel);
    const char *typeEncoding = method_getTypeEncoding(originMethod);
    // 如果原来就没有实现协议，就手动动态增加
    if (!originMethod) {
        targetMethod = class_getInstanceMethod(targetCls, @selector(ck_origin_tableView:didSelectRowAtIndexPath:));
        BOOL didAddMethod = class_addMethod(originCls, originSel, method_getImplementation(targetMethod), typeEncoding);
        NSCAssert(didAddMethod, @"未知错误, 没有的方法却添加失败！");
        return;
    }
    
    // 往里面添加新方法
    BOOL didAddMethod = class_addMethod(originCls, targetSel, method_getImplementation(targetMethod), typeEncoding);
    if (didAddMethod) {
        targetMethod = class_getInstanceMethod(originCls, targetSel);
        // 实现方法交换
        method_exchangeImplementations(originMethod, targetMethod);
    } else {
        // 添加失败，则说明已经hook过该类的delegate方法，防止多次交换
    }
}

/* 格式化对象到需要的字符串 */
static inline NSString* formatObj(id obj) {
    NSString *temp = [NSString stringWithFormat:@"%@", obj];
    temp = [[[temp componentsSeparatedByString:@";"] firstObject] substringFromIndex:1]; // 只要类名:对象地址
    return temp;
}


@interface NSDate (CK_Add)
+ (NSString *)ck_now;
+ (NSString *)ck_today;
@end

@implementation NSDate (CK_Add)
+ (NSString *)ck_today {
    return [[self ck_now] substringWithRange:NSMakeRange(0, 10)];
}

+ (NSString *)ck_now {
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss.SSS";
    }
    return [formatter stringFromDate:[NSDate date]];
}
/**
 获得当前的时间戳（单位ms）
 */
+ (NSTimeInterval)ck_timestamp {
    return [[NSDate date] timeIntervalSince1970] * 1000;
}
@end

#pragma mark - Logger区域

@interface CKFileLogger : NSObject <CKLogger>
@property (nonatomic, strong) NSFileHandle *file;
@end

@implementation CKFileLogger
- (void)readyToLog {
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    DDLog(@"%@", document);
    NSString *path = [document stringByAppendingFormat:@"/%@.log", [NSDate ck_today]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    self.file = [NSFileHandle fileHandleForUpdatingAtPath:path];
    if (!self.file) {
        NSAssert(false, @"创建FileHandler失败,%@", path);
        return;
    }
    
    // 把文件指针移到尾部
    [self.file seekToEndOfFile];
    
    [self appentText:@"\n\n\n\n--- CrashKiller Log Start ---\n\n\n\n"];
}

- (void)logText:(NSString *)txt {
    [self appentText:txt];
}

- (void)stopLog {
    [self.file closeFile];
}

- (void)appentText:(NSString *)txt {
    NSData *data = [txt dataUsingEncoding:NSUTF8StringEncoding];
    [self.file writeData:data];
}
@end

@interface CKConsoleLogger : NSObject <CKLogger>
@end

@implementation CKConsoleLogger
- (void)readyToLog {
    printf("\n\n\n\n--- CrashKiller Log Start ---\n\n\n\n");
}

- (void)logText:(NSString *)txt {
    printf("%s", txt.UTF8String);
}

- (void)stopLog {
    printf("\n\n\n\n--- CrashKiller Log End ---\n\n\n\n");
}
@end

@interface CKFabricLogger : NSObject <CKLogger>
@end

@implementation CKFabricLogger
- (void)logText:(NSString *)txt {}
@end

@interface CrashKillerEvent : NSObject
@property (nonatomic, assign) long ckId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *onScreenPageName;
@property (nonatomic, copy) NSString *createTime;
@end

@implementation CrashKillerEvent
- (instancetype)init {
    static long i = 0;
    if (self = [super init]) {
        self.ckId = ++i;
        self.createTime = [NSDate ck_now];
    }
    return self;
}
@end

@interface CrashKiller ()
@property (nonatomic, assign) BOOL enabled;             /**< 是否允许工作 */
@property (nonatomic, strong) NSMutableArray *loggers;  /**< 日志输出器s */

@property (nonatomic, strong) dispatch_queue_t queue;   /**< 工作线程(串行) */
@property (nonatomic, strong) NSMutableArray *events;   /**< 要输出的事件的队列 */

@property (nonatomic, copy) NSString *onScreenPageName; /**< 当前最新展示的vc名 */
@property (nonatomic, copy) NSString *previousPageName; /**< 上一次展示的vc名 */
@end

@implementation CrashKiller

+ (instancetype)shared {
    static CrashKiller *ck;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ck = [self new];
    });
    return ck;
}

- (instancetype)init {
    if (self = [super init]) {
        self.queue = dispatch_queue_create("queue.serial.crash_killer", DISPATCH_QUEUE_SERIAL);
        self.events = @[].mutableCopy;
        self.loggers = @[].mutableCopy;
    }
    return self;
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - API

- (void)startWithOptions:(CKLogOptions)options {
    dispatch_async(self.queue, ^{
        if (self.enabled) return;
        self.enabled = YES;
        
        [CrashKiller swizzlingUIViewController];
        [CrashKiller swizzlingUIControl];
        [CrashKiller swizzlingUIGestureRecgonizer];
        [CrashKiller swizzlingUITableView];
        
        // 监听一些通知事件
        [self addNotifications];
        
        // 配置logger
        if (options & CKLogConsole) {
            [self.loggers addObject:[CKConsoleLogger new]];
        }
        
        if (options & CKLogFile) {
            [self.loggers addObject:[CKFileLogger new]];
        }
        
        if (options & CKLogFabric) {
            [self.loggers addObject:[CKFabricLogger new]];
        }
    });
}

- (void)addLogger:(id<CKLogger>)logger {
    dispatch_async(self.queue, ^{
        NSAssert(logger && [logger conformsToProtocol:@protocol(CKLogger)], @"logger不能为空且必须遵循CKLogger协议");
        [self.loggers addObject:logger];
    });
}

- (void)beginPage:(NSString *)pageName {
    dispatch_async(self.queue, ^{
        if (!self.enabled) return;

        if (![self p_isOnlyViewController:pageName]) return;
        
        self.previousPageName = self.onScreenPageName;
        self.onScreenPageName = pageName;
        
        CrashKillerEvent *event = [CrashKillerEvent new];
        event.content = @"[PageShow]";
        event.onScreenPageName = self.onScreenPageName;
        [self.events addObject:event];
        
        [self p_log];
    });
}

- (void)endPage:(NSString *)pageName {
    dispatch_async(self.queue, ^{
        if (!self.enabled) return;

        if (![self p_isOnlyViewController:pageName]) return;
        
        CrashKillerEvent *event = [CrashKillerEvent new];
        event.content = @"[PageHide]";
        event.onScreenPageName = self.onScreenPageName;
        [self.events addObject:event];
        
        [self p_log];
    });
}

- (void)ck_log:(NSString *)content {
    if (!self.enabled) return;
    
    if (!content) return;
    
    dispatch_async(self.queue, ^{
        CrashKillerEvent *event = [CrashKillerEvent new];
        event.content = content;
        event.onScreenPageName = self.onScreenPageName;
        [self.events addObject:event];
        
        [self p_log];
    });
}


#pragma mark - Notifications

- (void)applicationDidBecomeActive:(id)n {
    [self ck_log:@"[即将进入前台]"];
}

- (void)applicationWillResignActive:(id)n {
    [self ck_log:@"[即将进入后台]"];
}

- (void)onKeyboardWillShow:(id)n {
    [self ck_log:@"[KeyboardShow]"];
}

- (void)onKeyboardWillHide:(id)n {
    [self ck_log:@"[KeyboardHide]"];
}

- (void)p_log {
    for (CrashKillerEvent *e in self.events) {
        for (id<CKLogger> logger in self.loggers) {
            if (e.ckId == 1) {
                [logger readyToLog];
            }
            NSString *txt = [NSString stringWithFormat:@"\n[%ld] %@ %@ (当前页:%@)\n", e.ckId, e.createTime, e.content, e.onScreenPageName];
            [logger logText:txt];
        }
    }
    [self.events removeAllObjects];
}


#pragma mark - Utils

+ (void)swizzlingUIViewController {
    Class clazz = UIViewController.class;
    [self swizzlingClass:clazz
               originSel:@selector(viewWillAppear:)
           withTargetSel:@selector(ck_swizzling_viewWillAppear:)];
    
    [self swizzlingClass:clazz
               originSel:@selector(viewWillDisappear:)
           withTargetSel:@selector(ck_swizzling_viewWillDisappear:)];
}

+ (void)swizzlingUIControl {
    Class clazz = UIControl.class;
    [self swizzlingClass:clazz
               originSel:@selector(sendAction:to:forEvent:)
           withTargetSel:@selector(ck_swizzling_sendAction:to:forEvent:)];
}

+ (void)swizzlingUIGestureRecgonizer {
    Class clazz = UIGestureRecognizer.class;
    [self swizzlingClass:clazz
               originSel:@selector(initWithTarget:action:)
           withTargetSel:@selector(ck_swizzling_initWithTarget:action:)];
}

+ (void)swizzlingUITableView {
    Class clazz = UITableView.class;
    [self swizzlingClass:clazz
               originSel:@selector(setDelegate:)
           withTargetSel:@selector(ck_swizzling_setDelegate:)];
}

+ (void)swizzlingClass:(Class)clazz originSel:(SEL)originSel withTargetSel:(SEL)targetSel {
    Method originMethod = class_getInstanceMethod(clazz, originSel);
    Method targetMethod = class_getInstanceMethod(clazz, targetSel);
    if (class_addMethod(clazz, originSel, method_getImplementation(targetMethod), method_getTypeEncoding(originMethod))) {
        class_replaceMethod(clazz, targetSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, targetMethod);
    }
}


/**
 是否只是`UIViewController`
 @param pageName VC的名字
 @return YES: 只是UIViewController， 其他情况都是NO
 */
- (BOOL)p_isOnlyViewController:(NSString *)pageName {
    if (!pageName) return NO;
    Class pageClass = NSClassFromString(pageName);
    if (!pageClass) return NO;
    if ([pageClass isSubclassOfClass:UINavigationController.class] == NO &&
        [pageClass isSubclassOfClass:UITabBarController.class] == NO &&
        [pageClass isSubclassOfClass:UIViewController.class] &&
        [self p_isSystemVC:pageName] == NO  /**< 系统控制器不考虑 */
        ) {
        return YES;
    }
    return NO;
}

- (BOOL)p_isSystemVC:(NSString *)pageName {
    if ([pageName hasPrefix:@"_"] || [pageName hasPrefix:@"UI"]) {
        return YES;
    }
    return NO;
}
@end

@interface UIViewController (CK_Add)
@end

@implementation UIViewController (CK_Add)
- (void)ck_swizzling_viewWillAppear:(BOOL)animated {
    [[CrashKiller shared] beginPage:NSStringFromClass(self.class)];
    [self ck_swizzling_viewWillAppear:animated];
}

- (void)ck_swizzling_viewWillDisappear:(BOOL)animated {
    [[CrashKiller shared] endPage:NSStringFromClass(self.class)];
    [self ck_swizzling_viewWillDisappear:animated];
}

@end

@interface UIControl (CK_Add)
@end

@implementation UIControl (CK_Add)
- (BOOL)ck_swizzling_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    NSString *e = nil;
    switch (event.type) {
        case UIEventTypeMotion:
            e = @"移动";
            break;
        case UIEventTypeTouches:
            e = @"点击";
            break;
        case UIEventTypePresses:
            e = @"按压";
            break;
        case UIEventTypeRemoteControl:
            e = @"远程";
            break;
        default:
            e = @"点击";
            break;
    }
    
    NSString *content = [NSString stringWithFormat:@"[%@事件] 对象:%@, 动作:%@", e, formatObj(target), NSStringFromSelector(action)];
    [[CrashKiller shared] ck_log:content];
    return [self ck_swizzling_sendAction:action to:target forEvent:event];
}

@end

@interface UITableView (CK_Add)
@end

@implementation UITableView (CK_Add)
- (void)ck_swizzling_setDelegate:(id<UITableViewDelegate>)delegate {
    // 只有能响应didSelectRowAtIndexPath的才hook
    if (delegate) {
        [UITableView exchangeUITableViewDelegateMethod:delegate];
    }
    [self ck_swizzling_setDelegate:delegate];
}

+ (void)exchangeUITableViewDelegateMethod:(id)delegate {
    ck_exchangeMethod([delegate class], @selector(tableView:didSelectRowAtIndexPath:), self.class, @selector(ck_swizzling_tableView:didSelectRowAtIndexPath:));
}

- (void)ck_swizzling_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *content = [NSString stringWithFormat:@"[点击Cell] 目标:%@, indexPath:(%d,%d)", formatObj(self), (int)indexPath.section, (int)indexPath.row];
    [[CrashKiller shared] ck_log:content];
    
    [self ck_swizzling_tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)ck_origin_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *content = [NSString stringWithFormat:@"[点击Cell] 目标:%@, indexPath:(%d,%d)", formatObj(self), (int)indexPath.section, (int)indexPath.row];
    [[CrashKiller shared] ck_log:content];
}
@end


@interface UIGestureRecognizer (CK_Add)
@end

@implementation UIGestureRecognizer (CK_Add)

- (instancetype)ck_swizzling_initWithTarget:(id)target action:(SEL)action {
    if (![target isKindOfClass:UITableView.class]) {
        // pan的回调太多了. UIPanGestureRecognizer和UIScreenEdgePanGestureRecognizer都不需要
        if (![self isKindOfClass:UIPanGestureRecognizer.class]) {
            BOOL hasArg = [NSStringFromSelector(action) hasSuffix:@":"];
            SEL targetAction = hasArg ? @selector(ck_swizzling_gesture_action_with_arg:) : @selector(ck_swizzling_gesture_action_with_no_arg);
            ck_exchangeMethod([target class], action, self.class, targetAction);
        }
    }
    return [self ck_swizzling_initWithTarget:target action:action];
}

static NSString* eventNameByGestureRecognizer(UIGestureRecognizer *gesture) {
    NSString *e = nil;
    if (!gesture) {
        e = @"主动调用";
    } else if ([gesture isKindOfClass:UITapGestureRecognizer.class]) {
        switch ([(UITapGestureRecognizer *)gesture numberOfTapsRequired]) {
            case 1:
                e = @"单击手势";
                break;
            case 2:
                e = @"双击手势";
                break;
            default:
                e = @"多击手势";
                break;
        }
    } else if ([gesture isKindOfClass:UILongPressGestureRecognizer.class]) {
        e = @"长按手势";
    } else if ([gesture isKindOfClass:UISwipeGestureRecognizer.class]) {
        switch ([(UISwipeGestureRecognizer *)gesture direction]) {
            case UISwipeGestureRecognizerDirectionUp:
                e = @"上滑手势";
                break;
            case UISwipeGestureRecognizerDirectionDown:
                e = @"下滑手势";
                break;
            case UISwipeGestureRecognizerDirectionLeft:
                e = @"左滑手势";
                break;
            case UISwipeGestureRecognizerDirectionRight:
                e = @"右滑手势";
                break;
            default:
                break;
        }
    } else if ([gesture isKindOfClass:UIPinchGestureRecognizer.class]) {
        e = @"捏合手势";
    } else if ([gesture isKindOfClass:UIRotationGestureRecognizer.class]) {
        e = @"旋转手势";
    } else {
        e = @"未知手势";
    }
    return e;
}

- (void)ck_swizzling_gesture_action_with_arg:(id)gesture {
    NSString *e = eventNameByGestureRecognizer(gesture);
    NSString *content = [NSString stringWithFormat:@"[%@] 目标:%@, 动作:%@", e, formatObj(self), NSStringFromSelector(_cmd)];
    [[CrashKiller shared] ck_log:content];
    
    [self ck_swizzling_gesture_action_with_arg:gesture];
}

- (void)ck_swizzling_gesture_action_with_no_arg {
    NSString *content = [NSString stringWithFormat:@"[手势事件] 目标:%@, 动作:%@", formatObj(self), NSStringFromSelector(_cmd)];
    [[CrashKiller shared] ck_log:content];
    
    [self ck_swizzling_gesture_action_with_no_arg];
}
@end
