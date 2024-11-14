//
//  Presenter.swift
//  CryptoViper
//
//  Created by Hatice Taşdemir on 7.11.2024.
//

import Foundation
//işleri hallettiğimiz
//class, protocol 

enum NetworError : Error {
    case NetworkFailed
    case ParsingFailed
}
protocol AnyPresenter {
    //presenter hepsi ile etkileşimde olduğu için tanımlarız.
    var router : AnyRouter? {get set}
    var interactor : AnyInteractor? {get set}
    var view : AnyView? {get set}
    //interactorda link down olduğunda, yeni veri geldi bana view kendini güncellemesini söylemek için oluşturulacak:
    func interactorDidDownloadCrypto(result: Result<[Crypto],Error>)
    
}
class CryptoPresenter : AnyPresenter {
    var router: (any AnyRouter)?
    
    var interactor: (any AnyInteractor)?{
        //uygulama açılınca herhangi bir şeye basmadan oto. veriyi çeksin diye :
        //interaactor ve presenter birbirine bağlandığında otomatik ataanacak download func
        didSet{
            interactor?.downloadCryptos()
        }
    }
    var view: (any AnyView)?
    
    func interactorDidDownloadCrypto(result: Result<[Crypto], any Error>) {
        switch result{
        case .success(let cryptos):
            view?.update(with: cryptos)
        case .failure(let error):
            view?.update(with: "try again later...")
            
        }
    }
    
    
}
