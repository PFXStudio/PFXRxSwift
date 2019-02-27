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

class Lecture03ViewController: UIViewController {

    let timer = Observable<Int>.interval(3.0, scheduler: MainScheduler.instance)
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.publicSubject()
        self.behaviorSubject()
        self.replaySubject()
        // Deprecated!!!!!!!
        // self.variableSubject()
        
    }
    
    func publicSubject() {
        // 구독 이후부터 전송 함
        let subject = PublishSubject<String>()
        subject.onNext("is anyone??")
        let subscriptionOne = subject.debug().subscribe(onNext: { (string) in
            print("subscriptionOne : " + string)
        })
        
        subject.on(.next("1"))
        subject.onNext("2")
        
        let subscriptionTwo = subject.debug().subscribe(onNext: { (string) in
            print("subscriptionTwo : " + string)
        })
        
        subject.onNext("3")
        subject.onNext("4")
        
        subscriptionOne.dispose()
        
        subject.onNext("5")
        subject.onNext("6")
        
        subscriptionTwo.dispose()
        subject.subscribe( {
            print("3)", $0.element ?? $0)
        }).disposed(by: disposeBag)
        
        subject.onNext("???")

    }
    
    enum MyError: Error {
        case anError
    }
    
    func printSubject<T: CustomStringConvertible>(label: String, event: Event<T>) {
        print(label, event.element ?? (event.error ?? (event as! Error))!)
    }
    
    func behaviorSubject() {
        // 첫 구독자에게만 보냈던 이벤트를 전송함
        let subject = BehaviorSubject(value: "initialize value")
        // subscribe를 안했는데 이게 뜨네
        subject.onNext("X")
        subject.onNext("Y")
        subject.onNext("Z")
        subject.subscribe {
            self.printSubject(label: "behavior 1 : ", event: $0)
        }.disposed(by: disposeBag)
        
        subject.onError(MyError.anError)
        subject.subscribe {
            self.printSubject(label: "behavior 2 : ", event: $0)
        }.disposed(by: disposeBag)
        
        
    }
    
    func replaySubject() {
        // 그 동안 보낸 이벤트를 새로운 구독자가 있으면 다 보내줌 굿굿
        let subject = ReplaySubject<String>.create(bufferSize: 3)
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        subject.onNext("4")
        subject.onNext("5")
        subject.onNext("6")

        subject.subscribe {
            self.printSubject(label: "replaySubject 1 : ", event: $0)
        }.disposed(by: disposeBag)
        
        subject.subscribe {
            self.printSubject(label: "replaySubject 2 : ", event: $0)
        }.disposed(by: disposeBag)
        
        subject.onNext("7")
        subject.onError(MyError.anError)
        subject.dispose()
        
        subject.subscribe {
            self.printSubject(label: "replaySubject 3 : ", event: $0)
        }.disposed(by: disposeBag)
    }
    
    func variableSubject() {
        // Deprecated!!!!!!!
        let variable = Variable("initialize value")
        variable.value = "new initialize value"
        
        variable.asObservable().subscribe {
            self.printSubject(label: "variableSubject 1 : ", event: $0)
        }.disposed(by: disposeBag)
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
