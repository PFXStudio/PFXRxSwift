//
//  Lecture01ViewController.swift
//  PFXRxSwift
//
//  Created by succorer on 2019. 1. 23..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Lecture02ViewController: UIViewController {

    let timer = Observable<Int>.interval(3.0, scheduler: MainScheduler.instance)
    let dispaseBag = DisposeBag()
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let empty = Observable<Any>.empty()
        empty.subscribe(onNext: { (element) in
            print(element)
        }, onError: { (error) in
            
        }, onCompleted: {
            print("empty completed")
        })
        
        let never = Observable<Any>.never()
        never.subscribe(onNext: { (value) in
            print(value)
        }, onError: { (error) in
            
        }, onCompleted: {
            print("never completed")
        })
        
        let range = Observable<Int>.range(start: 1, count: 10)
        range.subscribe(onNext: { (value) in
            print(value)
        }, onError: { (error) in
            
        }, onCompleted: {
            print("range completed")
        })
        
        let dispose = Observable.of("a", "b", "c", "d")
        let disposeSubscribe = dispose.subscribe { (event) in
            print("dispose : \(event)")
        }
        
        let disposeBag = DisposeBag()
        Observable.of("b", "a", "g").subscribe {
            print($0)
        }.disposed(by: disposeBag)
        
        let create = Observable<String>.create ({ (observer) -> Disposable in
            observer.onNext("create 1")
            observer.onNext("create 2")
            observer.onNext("create 3")
            observer.onCompleted()
            observer.onNext("create ?")
            
            return Disposables.create()
        }).subscribe(onNext: { (value) in
            print(value)
        }, onError: { (error) in
            
        }, onCompleted: {
            print("create completed")
        }, onDisposed: {
            print("create disposed")
        })
        
        enum MyError: Error {
            case anError
        }

        let errorCreate = Observable<String>.create ({ (observer) -> Disposable in
            observer.onNext("errorCreate 1")
            observer.onNext("errorCreate 2")
            observer.onNext("errorCreate 3")
            observer.onError(MyError.anError)
            observer.onCompleted()
            observer.onNext("errorCreate ?")
            
            return Disposables.create()
        }).subscribe(onNext: { (value) in
            print(value)
        }, onError: { (error) in
            print("errorCreate \(error)")

        }, onCompleted: {
            print("errorCreate completed")
        }, onDisposed: {
            print("errorCreate disposed")
        })

        var flip = false
        let factory: Observable<Int> = Observable.deferred { () -> Observable<Int> in
            flip = !flip
            if flip {
                return Observable.of(1, 2, 3)
            }

            return Observable.of(4, 5, 6)
        }
        
        for _ in 0...3 {
            factory.subscribe(onNext: { (value) in
                print(value, terminator: "")
            }, onError: { (error) in
                
            }, onCompleted: {
                
            }).disposed(by: disposeBag)
            
            print("\ndeferred")
        }
        
        self.loadText(from: "test").subscribe {
            switch $0 {
            case .success(let string):
                print(string)
            case .error(let error):
                print(error)
            }
            
        }.disposed(by: disposeBag)
        
        never.debug("확인").do(
            onSubscribe: { print("do subscribe")}
        ).subscribe(
            onNext: { (element) in
                print(element)
            },
            onCompleted: {
                print("do completed")
            }
        ).disposed(by: disposeBag)
    }
    
    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }
    
    func loadText(from name: String) -> Single<String> {
        // 4
        return Single.create{ single in
            // 4 - 1
            let disposable = Disposables.create()
            
            // 4 - 2
            guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                single(.error(FileReadError.fileNotFound))
                return disposable
            }
            
            // 4 - 3
            guard let data = FileManager.default.contents(atPath: path) else {
                single(.error(FileReadError.unreadable))
                return disposable
            }
            
            // 4 - 4
            guard let contents = String(data: data, encoding: .utf8) else {
                single(.error(FileReadError.encodingFailed))
                return disposable
            }
            
            // 4 - 5
            single(.success(contents))
            return disposable
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
