//
//  IAPHelper.h
//
//  Created by 陈彦龙 on 16/8/26.
//
//

#ifndef IAPHelper_h
#define IAPHelper_h

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "ScriptingCore.h"

@interface IAPHelper : NSObject<SKPaymentTransactionObserver>

+ (void) restorePurchases;
- (void) restorePurchasesReal;

- (void)paymentQueue: (SKPaymentQueue *) queue updatedTransactions: (NSArray *) transactions;
- (void)restoreTransaction: (SKPaymentTransaction *) transaction;
- (void)paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentQueue *) queue;

@end

#endif /* IAPHelper_h */
