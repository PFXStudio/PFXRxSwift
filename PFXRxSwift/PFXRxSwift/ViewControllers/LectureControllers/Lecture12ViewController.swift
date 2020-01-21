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

class Lecture12ViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var idValidButton: UIButton!
    @IBOutlet weak var pwValidButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    let idTextSubject = BehaviorSubject(value: "")
    let pwTextSubject = BehaviorSubject(value: "")
    let isIdValidSubject = BehaviorSubject(value: false)
    let isPwValidSubject = BehaviorSubject(value: false)
    
    let dispaseBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        initializeControllers()
        initializeControllers2()
    }
    
    func initializeControllers2() {
        self.idTextField.rx.text.orEmpty.bind(to: self.idTextSubject).disposed(by: dispaseBag)
        self.idTextSubject.map(validId).bind(to: self.isIdValidSubject).disposed(by: dispaseBag)
        
        self.pwTextField.rx.text.orEmpty.bind(to: self.pwTextSubject).disposed(by: dispaseBag)
        self.pwTextSubject.map(validPw).bind(to: self.isPwValidSubject).disposed(by: dispaseBag)
        
        self.isIdValidSubject
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                self?.idValidButton.isHidden = result
            })
            .disposed(by: dispaseBag)
        
        self.isPwValidSubject
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                self?.pwValidButton.isHidden = result
            })
            .disposed(by: dispaseBag)
        
        Observable.combineLatest(self.isIdValidSubject, self.isPwValidSubject, resultSelector: { $0 && $1 })
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                print(result)
                self?.loginButton.isEnabled = result
            })
            .disposed(by: self.dispaseBag)
    }

    func initializeControllers() {
        self.idTextField.rx.text.orEmpty
            .map(validId)
            .subscribe(onNext: { result in
                if result == false {
                    self.idValidButton.backgroundColor = UIColor.red
                    return
                }
                
                self.idValidButton.backgroundColor = UIColor.green
            })
            .disposed(by: self.dispaseBag)
        
        self.pwTextField.rx.text.orEmpty
            .map(validPw)
            .subscribe(onNext: { result in
                if result == false {
                    self.pwValidButton.backgroundColor = UIColor.red
                    return
                }
                
                self.pwValidButton.backgroundColor = UIColor.green
            })
            .disposed(by: self.dispaseBag)
        
        Observable.combineLatest(self.idTextField.rx.text.orEmpty
            .map(validId), self.pwTextField.rx.text.orEmpty
            .map(validPw), resultSelector: { $0 && $1 })
            .subscribe(onNext: { result in
                print("login enabeld : \(result)")
                self.loginButton.isEnabled = result
            })
            .disposed(by: self.dispaseBag)
    }
    
    func validId(_ text: String) -> Bool {
        print(text)
        return text.contains("@") && text.contains(".")
    }
    
    func validPw(text: String) -> Bool {
        return text.count > 5
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
