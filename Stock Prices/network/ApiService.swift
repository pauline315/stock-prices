//
//  ApiService.swift
//  Stock Prices
//
//  Created by Gracie on 20/02/2025.
//

import Foundation
import RxSwift

class APIService {
    
    func fetchStockPrice() -> Observable <[Stock]>{
        return Observable.create{observer in
            let url = URL(string: "https://api.polygon.io/v2/aggs/grouped/locale/us/market/stocks/2024-01-09?adjusted=true&apiKey=3pL2UIOv5i5cnifAhOHuHt3hF1HqYTXx")
            let task = URLSession.shared.dataTask(with: url!){data,response,error in
                
                if let error = error{
                    observer.onError(error)
                    return
                }
                
                guard let data = data else{
                    observer.onError(NSError(domain: "Invalid data", code: 0, userInfo: nil))
                    return
                }
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode)else{
                    observer.onError(NSError(domain: "Invalid Response", code: 0, userInfo: nil))
                    return
                }
                do {
                    let decodeddata = try JSONDecoder().decode(StockResponse.self, from: data)
//                    print(decodeddata.results)
                    let modeldata = decodeddata.results.map { results -> Stock in
                        return Stock(open:results.open,
                                     close: results.close)
                    }
                    observer.onNext(modeldata)
                    observer.onCompleted()
                                    
           
                } catch {
                    observer.onError(error)
                }
            }
            
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
