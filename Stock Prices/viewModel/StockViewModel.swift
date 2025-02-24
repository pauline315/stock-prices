import Foundation
import RxSwift
import RxCocoa

class StockViewModel {
    private var apiService = APIService()
    
    let triggerfetch = PublishSubject<Void>()
    
    //let subject = BehaviorSubject(value: 4)
    let stockAPIData = PublishSubject<[Stock]>()
    private let disposeBag = DisposeBag()
    
    init(apiService:APIService = APIService()){
        self.apiService = apiService
        
        apiService
            .fetchStockPrice()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { stocks in
                    print(stocks)
                self.stockAPIData.on(.next(stocks))
            }, onError: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        // behave()
    }
}
    //private func behave() {
     //   subject.onNext(3)
     //   subject.onNext(5)
      //  subject.subscribe(onNext: { value in
       //     print(value)
      //  })
      //  .disposed(by: disposeBag)
      //  subject.onNext(6)
   // }
//}
