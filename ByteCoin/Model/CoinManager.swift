//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didFailWithError(error: Error)
    func didUpdateCurrency(_ currency: String, rate: Double)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "63A67A0C-8ADD-469D-A755-62067318988F"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String){
        let url = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        //print(url)
        performFetch(urlString: url, currency: currency)
    }
    
    //Generate the URL
    //Create the URL Session
    //Assing a task for the url session
    //Perform the task for the url session
    func performFetch(urlString: String, currency: String){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                //let dataAsString = String(data: data!, encoding: .utf8)
                //print(dataAsString)
                if let safeData = data {
                    if let rate = self.parseJSON(safeData){
                        self.delegate?.didUpdateCurrency(currency, rate: rate)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let rate = decodedData.rate
            //print(rate)
            return rate
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
