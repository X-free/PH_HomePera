//
//  LoanResponseModel.h
//  OPherame
//
//  Created by todesk on 2025/6/16.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
NS_ASSUME_NONNULL_BEGIN

// 子模型 - administering 中的 par 对象
@interface AdministeringParItem : NSObject
@property (nonatomic, copy) NSString *downright;
@property (nonatomic, assign) NSInteger harukos;
@property (nonatomic, copy) NSString *perspective;
@property (nonatomic, strong) id product_url;
@property (nonatomic, copy) NSString *shiny;
@property (nonatomic, assign) NSInteger strictly;
@end

// 子模型 - administering
@interface AdministeringModel : NSObject
@property (nonatomic, copy) NSString *imitation;
@property (nonatomic, strong) NSArray<AdministeringParItem *> *par;
@end

// 子模型 - bingo 中的 par 对象
@interface BingoParItem : NSObject
@property (nonatomic, copy) NSString *appealing;
@property (nonatomic, assign) NSInteger bgColor;
@property (nonatomic, assign) NSInteger bonus;
@property (nonatomic, copy) NSString *buttonExplain;
@property (nonatomic, copy) NSString *decide;
@property (nonatomic, assign) NSInteger exaggerating;
@property (nonatomic, copy) NSString *express;
@property (nonatomic, copy) NSString *future;
@property (nonatomic, copy) NSString *goodbye;
@property (nonatomic, assign) NSInteger happy;
@property (nonatomic, copy) NSString *heel;
@property (nonatomic, copy) NSString *ideals;
@property (nonatomic, assign) NSInteger isCopyPhone;
@property (nonatomic, copy) NSString *lowly;
@property (nonatomic, copy) NSString *marinate;
@property (nonatomic, copy) NSString *mewed;
@property (nonatomic, copy) NSString *paces;
@property (nonatomic, copy) NSString *pick;
@property (nonatomic, copy) NSString *rolls;
@property (nonatomic, copy) NSString *rushing;
@property (nonatomic, copy) NSString *safely;
@property (nonatomic, copy) NSString *shiny;
@property (nonatomic, strong) NSArray<NSString *> *stepping;
@property (nonatomic, assign) NSInteger sub;
@property (nonatomic, assign) NSInteger tend;
@property (nonatomic, assign) NSInteger todayApplyNum;
@property (nonatomic, assign) NSInteger todayClicked;
@property (nonatomic, copy) NSString *travel;
@property (nonatomic, strong) NSArray *understood;
@property (nonatomic, copy) NSString *wheeled;
@end


// 子模型 - drew 中的 par 对象
@interface DrewParItem : NSObject
@property (nonatomic, strong) NSString *daughters;
@property (nonatomic, strong) NSString *shiny;
@end
// 子模型 - drew
@interface DrewModel : NSObject
@property (nonatomic, copy) NSString *imitation;
@property (nonatomic, strong) NSArray<DrewParItem *> *par;
@end


// 子模型 - bingo
@interface BingoModel : NSObject
@property (nonatomic, copy) NSString *imitation;
@property (nonatomic, strong) NSArray<BingoParItem *> *par;
@end

// 子模型 - pill
@interface PillModel : NSObject
@property (nonatomic, copy) NSString *healthy;
@property (nonatomic, copy) NSString *swallow;
@end

// 子模型 - truly 中的 par 对象
@interface TrulyParItem : NSObject
@property (nonatomic, copy) NSString *exaggerating;
@property (nonatomic, copy) NSString *future;
@property (nonatomic, copy) NSString *heel;
@property (nonatomic, copy) NSString *loanRateImg;
@property (nonatomic, copy) NSString *loanRateUnit;
@property (nonatomic, copy) NSString *lowly;
@property (nonatomic, copy) NSString *marinate;
@property (nonatomic, copy) NSString *mewed;
@property (nonatomic, copy) NSString *pick;
@property (nonatomic, copy) NSString *power;
@property (nonatomic, copy) NSString *rolls;
@property (nonatomic, assign) NSInteger sub;
@property (nonatomic, copy) NSString *termInfoImg;
@property (nonatomic, copy) NSString *underestimate;
@end

// 子模型 - truly
@interface TrulyModel : NSObject
@property (nonatomic, copy) NSString *imitation;
@property (nonatomic, strong) NSArray<TrulyParItem *> *par;
@end



// 主模型
@interface LoanResponseModel : NSObject
@property (nonatomic, copy) NSString *BgvDvfhsNf;
@property (nonatomic, assign) NSInteger JIBdh6q28X;
@property (nonatomic, strong) id SIeuFJelv3zQ;
@property (nonatomic, copy) NSString *gx9N0Hz;
@property (nonatomic, strong) AdministeringModel *administering;
@property (nonatomic, assign) NSInteger answered;
@property (nonatomic, copy) NSString *bear;
@property (nonatomic, strong) BingoModel *bingo;
@property (nonatomic, copy) NSString *clearingbb;
@property (nonatomic, assign) NSInteger clearly;
@property (nonatomic, assign) BOOL eNuyKsjm;
@property (nonatomic, copy) NSString *nH63pOtdP;
@property (nonatomic, strong) PillModel *pill;
@property (nonatomic, copy) NSString *receiving;
@property (nonatomic, copy) NSString *remind;
@property (nonatomic, assign) NSInteger show_about;
@property (nonatomic, strong) id sw1fkOKk;
@property (nonatomic, strong) TrulyModel *truly;
@property (nonatomic, strong) id yj5IfqXRE;


@property (nonatomic, strong) DrewModel *drew;

@end

NS_ASSUME_NONNULL_END
