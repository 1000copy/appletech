/*============================================================================*
 * 出力フラグ
 *		IPMSG_DEBUGがメインスイッチ（定義がない場合全レベル強制OFF）
 *		※ Xcodeのビルドスタイルにて定義されている
 *			・Release ビルドスタイル：出力しない（定義なし）
 *			・Debug   ビルドスタイル：出力する（定義あり）
 *============================================================================*/

// レベル別出力フラグ
//		0:出力しない
//		1:出力する
#ifndef IPMSG_LOG_TRC
#define IPMSG_LOG_TRC	0
#endif

#ifndef IPMSG_LOG_DBG
#define IPMSG_LOG_DBG	1
#endif

#ifndef IPMSG_LOG_WRN
#define IPMSG_LOG_WRN	1
#endif

#ifndef IPMSG_LOG_ERR
#define IPMSG_LOG_ERR	1
#endif

/*============================================================================*
 * トレースレベルログ
 *============================================================================*/

#if defined(IPMSG_DEBUG) && (IPMSG_LOG_TRC == 1)
#define _LOG_TRC	@"T ",__FILE__,__LINE__,__FUNCTION__
#define TRC(...)	IPMsgLog(_LOG_TRC,[NSString stringWithFormat:__VA_ARGS__])
#else
#define TRC(...)
#endif

/*============================================================================*
 * デバッグレベルログ
 *============================================================================*/

#if defined(IPMSG_DEBUG) && (IPMSG_LOG_DBG == 1)
#define _LOG_DBG	@"D ",__FILE__,__LINE__,__FUNCTION__
#define DBG(...)	IPMsgLog(_LOG_DBG,[NSString stringWithFormat:__VA_ARGS__])
#else
#define DBG(...)
#endif

/*============================================================================*
 * 警告レベルログ
 *============================================================================*/

#if defined(IPMSG_DEBUG) && (IPMSG_LOG_WRN == 1)
#define _LOG_WRN	@"W-",__FILE__,__LINE__,__FUNCTION__
#define WRN(...)	IPMsgLog(_LOG_WRN,[NSString stringWithFormat:__VA_ARGS__])
#else
#define WRN(...)
#endif

/*============================================================================*
 * エラーレベルログ
 *============================================================================*/

#if defined(IPMSG_DEBUG) && (IPMSG_LOG_ERR == 1)
#define _LOG_ERR	@"E*",__FILE__,__LINE__,__FUNCTION__
#define ERR(...)	IPMsgLog(_LOG_ERR,[NSString stringWithFormat:__VA_ARGS__])
#else
#define ERR(...)
#endif

/*============================================================================*
 * 関数プロトタイプ
 *============================================================================*/

#import <Foundation/Foundation.h>


/*============================================================================*
 * (C) 2001-2011 G.Ishiwata, All Rights Reserved.
 *
 *	Project		: IP Messenger for Mac OS X
 *	File		: MessageCenter.h
 *	Module		: メッセージ送受信管理クラス
 *============================================================================*/

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SCDynamicStore.h>

//void _DEBUG(char*a){}
//void _ERR(char*a){}
/*============================================================================*
 * Notification キー
 *============================================================================*/

// ホスト名変更
#define NOTICE_HOSTNAME_CHANGED		@"IPMsgHostNameChanged"
// ネットワーク検出/喪失
#define NOTICE_NETWORK_GAINED		@"IPMsgNetworkGained"
#define NOTICE_NETWORK_LOST			@"IPMsgNetworkLost"

/*============================================================================*
 * 構造体定義
 *============================================================================*/

// IPMsg受信パケット解析構造体
typedef struct
{
    unsigned	version;			// バージョン番号
    unsigned	packetNo;			// パケット番号
    char		userName[256];		// ログインユーザ名
    char		hostName[256];		// ホスト名
    unsigned	command;			// コマンド番号
    char		extension[4096];	// 拡張部
    
} IPMsgData;

/*============================================================================*
 * クラス定義
 *============================================================================*/

@interface MessageCenter : NSObject
{
    // 送受信関連
    int						sockUDP;			// ソケットディスクリプタ
    NSLock*					sockLock;			// ソケット送信排他ロック
    NSMutableDictionary*	sendList;			// 応答待ちメッセージ一覧（再送用）
    // 受信サーバ関連
    NSConnection*			serverConnection;	// メッセージ受信スレッドとのコネクション
    NSLock*					serverLock;			// サーバ待ち合わせ用ロック
    BOOL					serverShutdown;		// サーバ停止フラグ
    // 現在値
    NSString*				primaryNIC;			// 有線ネットワークインタフェース
    unsigned long			myIPAddress;		// ローカルホストアドレス
    NSInteger				myPortNo;			// ソケットポート番号
    NSString*				myHostName;			// コンピュータ名
    // DynamicStore関連
    CFRunLoopSourceRef		runLoopSource;		// Run Loop Source Obj for SC Notification
    SCDynamicStoreRef		scDynStore;			// DynamicStore
    SCDynamicStoreContext	scDSContext;		// DynamicStoreContext
    NSString*				scKeyHostName;		// DynamicStore Key [for LocalHostName]
    NSString*				scKeyNetIPv4;		// DynamicStore Key [for Global IPv4]
    NSString*				scKeyIFIPv4;		// DynamicStore Key [for IF IPv4 Address]
}

// ファクトリ
//+ (MessageCenter*)sharedCenter;
//
//// クラスメソッド
//+ (long)nextMessageID;
//+ (BOOL)isNetworkLinked;
//
//// 受信Rawデータの分解
//+ (BOOL)parseReceiveData:(char*)buffer length:(int)len into:(IPMsgData*)data;
//
//// メッセージ送信（ブロードキャスト）
//- (void)broadcastEntry;
//- (void)broadcastAbsence;
//- (void)broadcastExit;
//
//// メッセージ送信（通常）
//- (void)sendMessage:(SendMessage*)msg to:(NSArray*)to;
//- (void)sendOpenSealMessage:(RecvMessage*)info;
//- (void)sendReleaseAttachmentMessage:(RecvMessage*)info;

// 情報取得
- (int)myPortNo;
- (NSString*)myHostName;

@end



/*============================================================================*
 * (C) 2001-2014 G.Ishiwata, All Rights Reserved.
 *
 *	Project		: IP Messenger for Mac OS X
 *	File		: MessageCenter.m
 *	Module		: メッセージ送受信管理クラス
 *============================================================================*/

#import <Cocoa/Cocoa.h>
#import <SystemConfiguration/SCDynamicStoreKey.h>
#import <SystemConfiguration/SCSchemaDefinitions.h>


//#import "AppControl.h"
//#import "Config.h"
//#import "PortChangeControl.h"
//#import "UserManager.h"
//#import "UserInfo.h"
//#import "RecvMessage.h"
//#import "SendMessage.h"
//#import "RetryInfo.h"
//#import "NoticeControl.h"
//#import "AttachmentServer.h"
//#import "Attachment.h"
//#import "AttachmentFile.h"
//#import "NSStringIPMessenger.h"
//#import	"DebugLog.h"

// UNIXソケット関連
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

/*============================================================================*
 * 定数定義
 *============================================================================*/

#define RETRY_INTERVAL	(2.0)
#define RETRY_MAX		(3)

typedef enum
{
    _NET_NO_CHANGE_IN_LINK,
    _NET_NO_CHANGE_IN_UNLINK,
    _NET_LINK_GAINED,
    _NET_LINK_LOST,
    _NET_PRIMARY_IF_CHANGED,
    _NET_IP_ADDRESS_CHANGED
    
} _NetUpdateState;

/*============================================================================*
 * プライベートメソッド
 *============================================================================*/

@interface MessageCenter()
//- (NSData*)entryMessageData;
//- (void)shutdownServer;
//- (void)serverThread:(NSArray*)portArray;
- (BOOL)updateHostName;
- (_NetUpdateState)updateIPAddress;
- (_NetUpdateState)updatePrimaryNIC;
- (void)systemConfigurationUpdated:(NSArray*)changedKeys;
@end

/*============================================================================*
 * ローカル関数
 *============================================================================*/

// DynamicStore Callback Func
static void _DynamicStoreCallback(SCDynamicStoreRef	store,
                                  CFArrayRef		changedKeys,
                                  void*				info);

/*============================================================================*
 * クラス実装
 *============================================================================*/

@implementation MessageCenter

/*----------------------------------------------------------------------------*
 * ファクトリ
 *----------------------------------------------------------------------------*/

// 共有インスタンスを返す
+ (MessageCenter*)sharedCenter
{
    static MessageCenter* sharedCenter = nil;
    if (!sharedCenter) {
        sharedCenter = [[MessageCenter alloc] init];
    }
    return sharedCenter;
}

// 次のメッセージIDを返す
+ (long)nextMessageID {
    static long messageID = 0;
    return ++messageID;
}

// ネットワークに接続しているかを返す
+ (BOOL)isNetworkLinked {
    MessageCenter* me = [MessageCenter sharedCenter];
    if (me) {
        return (BOOL)(me->myIPAddress != 0);
    }
    return NO;
}

/*----------------------------------------------------------------------------*
 * 初期化／解放
 *----------------------------------------------------------------------------*/

// 初期化
- (id)init
{
    NSArray*			keys	= nil;
//    int					sockopt	= 1;
//    struct sockaddr_in	addr;
    
    self				= [super init];
//    sockUDP				= -1;
//    sockLock			= [[NSLock alloc] init];
//    sendList			= [[NSMutableDictionary alloc] init];
//    serverConnection	= nil;
//    serverLock			= [[NSLock alloc] init];
//    serverShutdown		= FALSE;
    runLoopSource		= nil;
    scDynStore			= nil;
    scKeyHostName		= nil;
    scKeyNetIPv4		= nil;
    scKeyIFIPv4			= nil;
    primaryNIC			= nil;
    myIPAddress			= 0;
    myHostName			= nil;
    memset(&scDSContext, 0, sizeof(scDSContext));
    

    // DynaimcStore生成
    scDSContext.info	= self;
    scDynStore	= SCDynamicStoreCreate(NULL,
                                       (CFStringRef)@"net.ishwt.IPMessenger",
                                       _DynamicStoreCallback,
                                       &scDSContext);
    if (!scDynStore) {
        // Dockアイコンバウンド
        [NSApp requestUserAttention:NSCriticalRequest];
        // エラーダイアログ表示
        // プログラム終了
        [NSApp terminate:self];
        [self autorelease];
        return nil;
    }
    
    // DynamicStore更新通知設定
    scKeyHostName	= (NSString*)SCDynamicStoreKeyCreateHostNames(NULL);
    scKeyNetIPv4	= (NSString*)SCDynamicStoreKeyCreateNetworkGlobalEntity(
                                                                            NULL, kSCDynamicStoreDomainState, kSCEntNetIPv4);
    keys = [NSArray arrayWithObjects:scKeyHostName, scKeyNetIPv4, nil];
    
    if (!SCDynamicStoreSetNotificationKeys(scDynStore, (CFArrayRef)keys, NULL)) {
        ERR(@"dynamic store notification set error");
    }
    runLoopSource = SCDynamicStoreCreateRunLoopSource(NULL, scDynStore, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopDefaultMode);
    
    // DynamicStoreからの情報取得
    [self updateHostName];
    [self updateIPAddress];
    if (myIPAddress == 0) {
        // Dockアイコンバウンド
        [NSApp requestUserAttention:NSCriticalRequest];
        // エラーダイアログ表示
        NSRunCriticalAlertPanel(NSLocalizedString(@"Err.NetCheck.title", nil),
                                NSLocalizedString(@"Err.NetCheck.msg", nil),
                                @"OK", nil, nil);
    }
    
    // 乱数初期化
    srand(time(NULL));
    
    // ソケットオープン
    if ((sockUDP = socket(AF_INET, SOCK_DGRAM, 0)) == -1) {
        // Dockアイコンバウンド
        [NSApp requestUserAttention:NSCriticalRequest];
        // エラーダイアログ表示
        NSRunCriticalAlertPanel(NSLocalizedString(@"Err.UDPSocketOpen.title", nil),
                                NSLocalizedString(@"Err.UDPSocketOpen.msg", nil),
                                @"OK", nil, nil);
        // プログラム終了
        [NSApp terminate:self];
        [self autorelease];
        return nil;
    }
    
    
    return self;
}

// 解放
-(void)dealloc
{
//    [sockLock release];
//    [sendList release];
//    [serverConnection release];
//    [serverLock release];
//    if (sockUDP != -1) {
//        close(sockUDP);
//    }
    if (runLoopSource) {
        CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopDefaultMode);
        CFRelease(runLoopSource);
    }
    [scKeyHostName release];
    [scKeyNetIPv4 release];
    [scKeyIFIPv4 release];
    if (scDynStore) {
        CFRelease(scDynStore);
    }
    [myHostName release];
    [primaryNIC release];
    [super dealloc];
}


/*----------------------------------------------------------------------------*
 * メッセージ受信
 *----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*
 * 情報取得関連
 *----------------------------------------------------------------------------*/

- (int)myPortNo {
    return myPortNo;
}

- (NSString*)myHostName {
    if (myHostName) {
        return myHostName;
    }
    return @"";
}

- (unsigned int )myIpAddress {
    if (myIPAddress) {
        return myIPAddress;
    }
    return 0;
}
/*----------------------------------------------------------------------------*
 * メッセージ解析関連
 *----------------------------------------------------------------------------*/

// 受信Rawデータの分解
+ (BOOL)parseReceiveData:(char*)buffer length:(int)len into:(IPMsgData*)data
{
    char* work	= buffer;
    char* ptr	= buffer;
    if (!buffer || !data || (len <= 0)) {
        return NO;
    }
    
    // バージョン番号
    data->version = strtoul(ptr, &work, 16);
    if (*work != ':') {
        return NO;
    }
    ptr = work + 1;
    
    // パケット番号
    data->packetNo = strtoul(ptr, &work, 16);
    if (*work != ':') {
        return NO;
    }
    ptr = work + 1;
    
    // ログインユーザ名
    work = strchr(ptr, ':');
    if (!work) {
        return NO;
    }
    *work = '\0';
    strncpy(data->userName, ptr, sizeof(data->userName) - 1);
    ptr = work + 1;
    
    // ホスト名
    work = strchr(ptr, ':');
    if (!work) {
        return NO;
    }
    *work = '\0';
    strncpy(data->hostName, ptr, sizeof(data->hostName) - 1);
    ptr = work + 1;
    
    // コマンド番号
    data->command = strtoul(ptr, &work, 10);
    if (*work != ':') {
        return NO;
    }
    ptr = work + 1;
    
    // 拡張部
    strncpy(data->extension, ptr, sizeof(data->extension) - 1);
    
    return YES;
}
-(NSString*)getHostName{
    CFStringRef		key		= SCDynamicStoreKeyCreateHostNames(NULL);
    NSDictionary*	newVal	= [(NSDictionary*)SCDynamicStoreCopyValue(scDynStore, key) autorelease];
    CFRelease(key);
    if (newVal) {
        NSString* newName = [newVal objectForKey:(NSString*)kSCPropNetLocalHostName];
        return newName;
    }
    return nil;

}
- (BOOL)updateHostName{
//{
//    CFStringRef		key		= SCDynamicStoreKeyCreateHostNames(NULL);
//    NSDictionary*	newVal	= [(NSDictionary*)SCDynamicStoreCopyValue(scDynStore, key) autorelease];
//    CFRelease(key);
//    if (newVal) {
//        NSString* newName = [newVal objectForKey:(NSString*)kSCPropNetLocalHostName];
        NSString* newName = [self getHostName];
        if (newName) {
            if (![newName isEqualToString:myHostName]) {
                [myHostName autorelease];
                myHostName = [newName copy];
                return YES;
            }
        }

    return NO;
}

- (_NetUpdateState)updateIPAddress
{
    _NetUpdateState	state;
    CFStringRef		key;
    CFDictionaryRef	value;
    CFArrayRef		addrs;
    NSString*		addr;
    struct in_addr	inAddr;
    unsigned long	newAddr = 0;
    unsigned long	oldAddr = myIPAddress;
    
    // PrimaryNetworkInterface更新
    state = [self updatePrimaryNIC];
    switch (state) {
        case _NET_LINK_LOST:
            // クリアして復帰
            [scKeyIFIPv4 release];
            scKeyIFIPv4	= nil;
            myIPAddress	= 0;
            return _NET_LINK_LOST;
        case _NET_NO_CHANGE_IN_UNLINK:
            // 変更はないがリンクしていないので復帰
            return _NET_NO_CHANGE_IN_UNLINK;
        case _NET_NO_CHANGE_IN_LINK:
            // 変更はないのでクリアせずに進む
            // (先での変更の可能性があるため）
            break;
        case _NET_LINK_GAINED:
        case _NET_PRIMARY_IF_CHANGED:
            // リンクの検出またはNICの切り替えが発生したので一度クリアする
            [scKeyIFIPv4 release];
            scKeyIFIPv4	= nil;
            myIPAddress	= 0;
            break;
        default:
            ERR(@"Invalid change status(%d)", state);
            [scKeyIFIPv4 release];
            scKeyIFIPv4	= nil;
            myIPAddress	= 0;
            if (!primaryNIC) {
                // リンク消失扱いにして復帰
                return _NET_LINK_LOST;
            } else {
                // 一応NICが変わったものとして扱う
                state = _NET_PRIMARY_IF_CHANGED;
            }
            break;
    }
    
    // State:/Network/Interface/<PrimaryNetworkInterface>/IPv4 キー編集
    if (!scKeyIFIPv4) {
        key = SCDynamicStoreKeyCreateNetworkInterfaceEntity(NULL,
                                                            kSCDynamicStoreDomainState,
                                                            (CFStringRef)primaryNIC,
                                                            kSCEntNetIPv4);
        if (!key) {
            // 内部エラー
            ERR(@"Edit Key error (if=%@)", primaryNIC);
            [primaryNIC release];
            primaryNIC	= nil;
            myIPAddress	= 0;
            return _NET_LINK_LOST;
        }
        scKeyIFIPv4 = (NSString*)key;
    }
    
    // State:/Network/Interface/<PrimaryNetworkInterface>/IPv4 取得
    value = (CFDictionaryRef)SCDynamicStoreCopyValue(scDynStore, (CFStringRef)scKeyIFIPv4);
    if (!value) {
        // 値なし（ありえないはず）
        ERR(@"value get error (%@)", scKeyIFIPv4);
        [primaryNIC release];
        [scKeyIFIPv4 release];
        primaryNIC	= nil;
        scKeyIFIPv4	= nil;
        myIPAddress	= 0;
        return _NET_LINK_LOST;
    }
    
    // Addressesプロパティ取得
    addrs = (CFArrayRef)CFDictionaryGetValue(value, kSCPropNetIPv4Addresses);
    if (!addrs) {
        // プロパティなし
        ERR(@"prop get error (%@ in %@)", (NSString*)kSCPropNetIPv4Addresses, scKeyIFIPv4);
        CFRelease(value);
        [primaryNIC release];
        [scKeyIFIPv4 release];
        primaryNIC	= nil;
        scKeyIFIPv4	= nil;
        myIPAddress	= 0;
        return _NET_LINK_LOST;
    }
    
    // IPアドレス([0])取得
    addr = (NSString*)CFArrayGetValueAtIndex(addrs, 0);
    if (!addr) {
        ERR(@"[0] not exist (in %@)", (NSString*)kSCPropNetIPv4Addresses);
        CFRelease(value);
        [primaryNIC release];
        [scKeyIFIPv4 release];
        primaryNIC	= nil;
        scKeyIFIPv4	= nil;
        myIPAddress	= 0;
        return _NET_LINK_LOST;
    }
    if (inet_aton([addr UTF8String], &inAddr) == 0) {
        ERR(@"IP Address format error(%@)", addr);
        CFRelease(value);
        [primaryNIC release];
        [scKeyIFIPv4 release];
        primaryNIC	= nil;
        scKeyIFIPv4	= nil;
        myIPAddress	= 0;
        return _NET_LINK_LOST;
    }
    newAddr = ntohl(inAddr.s_addr);
    
    CFRelease(value);
    
    if (myIPAddress != newAddr) {
        DBG(@"IPAddress changed (%lu.%lu.%lu.%lu -> %lu.%lu.%lu.%lu)",
            ((oldAddr >> 24) & 0x00FF), ((oldAddr >> 16) & 0x00FF),
            ((oldAddr >> 8) & 0x00FF), (oldAddr & 0x00FF),
            ((newAddr >> 24) & 0x00FF), ((newAddr >> 16) & 0x00FF),
            ((newAddr >> 8) & 0x00FF), (newAddr & 0x00FF));
        myIPAddress = newAddr;
        // ステータスチェック（必要に応じて変更）
        switch (state) {
            case _NET_LINK_GAINED:
            case _NET_PRIMARY_IF_CHANGED:
                // そのまま（より大きな変更なので）
                break;
            case _NET_NO_CHANGE_IN_LINK:
            default:
                // IPアドレスは変更になったのでステータス変更
                state = _NET_IP_ADDRESS_CHANGED;
                break;
        }
    }
    
    return state;
}

- (_NetUpdateState)updatePrimaryNIC
{
    CFDictionaryRef	value		= NULL;
    CFStringRef		primaryIF	= NULL;
    
    // State:/Network/Global/IPv4 を取得
    value = (CFDictionaryRef)SCDynamicStoreCopyValue(scDynStore,
                                                     (CFStringRef)scKeyNetIPv4);
    if (!value) {
        // キー自体がないのは、すべてのネットワークI/FがUnlink状態
        if (primaryNIC) {
            // いままではあったのに無くなった
            DBG(@"All Network I/F becomes unlinked");
            [primaryNIC release];
            primaryNIC = nil;
            return _NET_LINK_LOST;
        }
        // もともと無いので変化なし
        return _NET_NO_CHANGE_IN_UNLINK;
    }
    
    // PrimaryNetwork プロパティを取得
    primaryIF = (CFStringRef)CFDictionaryGetValue(value,
                                                  kSCDynamicStorePropNetPrimaryInterface);
    if (!primaryIF) {
        // この状況が発生するのか不明（ありえないと思われる）
        ERR(@"Not exist prop %@", kSCDynamicStorePropNetPrimaryInterface);
        CFRelease(value);
        if (primaryNIC) {
            // いままではあったのに無くなった
            DBG(@"All Network I/F becomes unlinked");
            [primaryNIC release];
            primaryNIC = nil;
            return _NET_LINK_LOST;
        }
        // もともと無いので変化なし
        return _NET_NO_CHANGE_IN_UNLINK;
    }
    
    CFRetain(primaryIF);
    CFRelease(value);
    
    if (!primaryNIC) {
        // ネットワークが無い状態からある状態になった
        primaryNIC = (NSString*)primaryIF;
        DBG(@"A Network I/F becomes linked");
        return _NET_LINK_GAINED;
    }
    
    if (![primaryNIC isEqualToString:(NSString*)primaryIF]) {
        // 既にあるが変わった
        DBG(@"Primary Network I/F changed(%@ -> %@)", primaryNIC, (NSString*)primaryIF);
        [primaryNIC autorelease];
        primaryNIC = (NSString*)primaryIF;
        return _NET_PRIMARY_IF_CHANGED;
    }
    
    // これまでと同じ（接続済みで変化なし）
    CFRelease(primaryIF);
    
    return _NET_NO_CHANGE_IN_LINK;
}

- (void)systemConfigurationUpdated:(NSArray*)changedKeys
{
    unsigned i;
    for (i = 0; i < [changedKeys count]; i++) {
        NSString* key = (NSString*)[changedKeys objectAtIndex:i];
        if ([key isEqualToString:scKeyNetIPv4]) {
            _NetUpdateState			ret;
            NSNotificationCenter*	nc;
            DBG(@"<SC>NetIFStatus changed (key[%d]:%@)", i, key);
            ret = [self updateIPAddress];
            nc	= [NSNotificationCenter defaultCenter];
            switch (ret) {
                case _NET_NO_CHANGE_IN_LINK:
                    // なにもしない
                    DBG(@" no effects (in link status)");
                    break;
                case _NET_NO_CHANGE_IN_UNLINK:
                    // なにもしない
                    DBG(@" no effects (in unlink status)");
                    break;
                case _NET_PRIMARY_IF_CHANGED:
                    // NICが切り替わったたのでユーザリストを更新する
                    DBG(@" NIC Changed -> Referesh UserList");
//                    [[UserManager sharedManager] removeAllUsers];
                    break;
                case _NET_IP_ADDRESS_CHANGED:
                    // IPに変更があったのでユーザリストを更新する
                    DBG(@" IPAddress Changed -> Referesh UserList");
//                    [[UserManager sharedManager] removeAllUsers];
                    break;
                case _NET_LINK_GAINED:
                    // ネットワーク環境に繋がったので通知してユーザリストを更新する
                    [nc postNotificationName:NOTICE_NETWORK_GAINED object:nil];
                    DBG(@" Network Gained -> Referesh UserList");

                    break;
                case _NET_LINK_LOST:
                    // つながっていたが接続がなくなったので通知
                    [nc postNotificationName:NOTICE_NETWORK_LOST object:nil];
                    DBG(@" Network Lost -> Remove Users");
//                    [[UserManager sharedManager] removeAllUsers];
                    break;
                default:
                    ERR(@" Unknown Status(%d)", ret);
                    break;
            }
        } else if ([key isEqualToString:scKeyHostName]) {
            if ([self updateHostName]) {
                DBG(@"<SC>HostName changed (key[%d]:%@)", i, key);
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_HOSTNAME_CHANGED
                                                                    object:nil];
//                [self broadcastAbsence];
            }
        } else {
            DBG(@"<SC>No action defined for key[%d]:%@", i, key);
        }
    }
}

@end

/*============================================================================*
 * ローカル関数実装
 *============================================================================*/

void _DynamicStoreCallback(SCDynamicStoreRef	store,
                           CFArrayRef			changedKeys,
                           void*				info)
{
    MessageCenter* self = (MessageCenter*)info;
    [self systemConfigurationUpdated:(NSArray*)changedKeys];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        MessageCenter *m = [[MessageCenter alloc]init];
        NSLog(@"hostname:%@,ip:%d",[m myHostName],[m myIpAddress]);
        [[NSRunLoop currentRunLoop]run];
    }
    return 0;
}
