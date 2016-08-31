//
//  IAPHelper.mm
//
//  Created by 陈彦龙 on 16/8/26.
//
//
#import "IAPHelper.h"

// 接口声明属性
@interface IAPHelper() {
    NSMutableArray *productIds;
}

@end

@implementation IAPHelper

// 恢复购买（静态函数，供JS调用）
+ (void) restorePurchases {
    IAPHelper *ipa = [IAPHelper alloc];
    [ipa restorePurchasesReal];
}


// 开始恢复购买
- (void) restorePurchasesReal {
    // 初始化商品ID数组
    productIds = [[NSMutableArray alloc] init];
    
    SKPaymentQueue *paymentQueue = [SKPaymentQueue defaultQueue];
    // 设置支付观察者（类似于代理），通过观察者来监控购买情况
    [paymentQueue addTransactionObserver: self];
    // 恢复所有非消耗品
    [paymentQueue restoreCompletedTransactions];
}

// 事件监听
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            //case SKPaymentTransactionStatePurchased://交易完成
                //break;
            //case SKPaymentTransactionStateFailed://交易失败
                //break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                break;
            //case SKPaymentTransactionStatePurchasing://商品添加进列表
                //break;
            default:
                break;
        }
    }
}

// 对已购商品，处理恢复购买的逻辑
- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    // 恢复成功，对于非消耗品才能恢复,如果恢复成功则transaction中记录的恢复的产品交易
    // 把商品ID存起来
    [productIds addObject: transaction.payment.productIdentifier];
    // 结束支付交易
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

// 恢复购买完成
- (void)paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentQueue *) queue {
	// 将商品ID用逗号分隔连接成字符串
    NSString *ids = [productIds componentsJoinedByString:@","];
    // 需要调用的JS函数：require('SDKHelpers').restorePurchasesEnd 是引用 SDKHelpers.js 文件里的 restorePurchasesEnd 函数  ('%@') 就是把商品ID当初参数传递过去
    NSString *function = [NSString stringWithFormat: @"require('SDKHelpers').restorePurchasesEnd('%@')", ids];
    // 转为C风格字符串
    const char *stringFunc = [function UTF8String];
    jsval *outVal;
    // OC调用JS，传回商品ID
    ScriptingCore::getInstance()->evalString(stringFunc, outVal);
}

@end
