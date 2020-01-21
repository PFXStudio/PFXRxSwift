//: A UIKit based Playground for presenting user interface
  
import UIKit
import RxSwift
import RxCocoa

print("///////////////////")
print("1. Observable Sequence")
print("emission -> next")
print("notification -> error, completed")
print("///////////////////")

// 1. create
Observable<Int>.create { (observer) -> Disposable in
    observer.on(.next(0))
    observer.onNext(1)
    
    observer.onCompleted()
    
    return Disposables.create()
}

// 2. from
Observable.from([0, 1])

var loadImageDisposeBag = DisposeBag()

func observableLoadImage(imageUrl: String) -> Observable<UIImage?> {
    return Observable.create { observer in
        asyncLoadImage(imageUrl: imageUrl) { image in
            observer.onNext(image)
            observer.onCompleted()
        }
        
        return Disposables.create()
    }
}

func asyncLoadImage(imageUrl: String, completed: @escaping (UIImage?) -> Void) {
    DispatchQueue.global().async {
        guard let url = URL(string: imageUrl) else {
            completed(nil)
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            completed(nil)
            return
        }
        
        let image = UIImage(data: data)
        completed(image)
    }
}

let imagePath = "https://icon.foundation/resources/image/og-img.png"
observableLoadImage(imageUrl: imagePath).observeOn(MainScheduler.instance).subscribe ({ (result) in
    switch result {
    case let .next(image):
        print("image \(String(describing: image))")
    case let .error(err):
        print(err.localizedDescription)
    case .completed:
        break
    }
    }).disposed(by: loadImageDisposeBag)

// DisposeBag은 취소 함수가 없다. 새로 DisposeBag을 생성하여 전달하면 취소가 된다.
loadImageDisposeBag = DisposeBag()

print("///////////////////")
print("2. Operators")
print("///////////////////")

func useJustWithString() {
    let disposeBag = DisposeBag()
    Observable.just("My name is just").subscribe(onNext: { str in
        print(str)
    })
    .disposed(by: disposeBag)
}

useJustWithString()

func useJustWithArray() {
    let disposeBag = DisposeBag()
    Observable.just(["First Param", "Second Param"]).subscribe(onNext: { str in
        print(str)
    })
    .disposed(by: disposeBag)
}

useJustWithArray()

func useFrom() {
    let disposeBag = DisposeBag()
    Observable.from(["RxSwift", "is", "my", "best", "friend"]).subscribe(onNext: { str in
        print(str)
    })
    .disposed(by: disposeBag)

}

useFrom()

func useMapWithString() {
    let disposeBag = DisposeBag()
    Observable.just("Hello").map { value in
        return "\(value) RxSwift!"
    }.subscribe(onNext: { value in
        print(value)
    }).disposed(by: disposeBag)
}

useMapWithString()

func useMapWithArray() {
    let disposeBag = DisposeBag()
    Observable
        .from(["ABCDEFGHIJK", "EASY"])
        .map { "length is \($0.count)" }
        .subscribe(onNext: { value in
        print(value)
    }).disposed(by: disposeBag)
}

useMapWithArray()

func useWithFilter() {
    let disposeBag = DisposeBag()
    Observable
        .from([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
        .filter { (value) -> Bool in
            return value % 2 == 0
    }
    .subscribe(onNext: { (value) in
        print(value)
    })
    .disposed(by: disposeBag)
}

useWithFilter()

func useMapWithStream() {
    let disposeBag = DisposeBag()
    Observable
        .just("800x600")
        .map { $0.replacingOccurrences(of: "x", with: "/") }
        .map { "http://picsum.photos/\($0)/?random" }
        .map { URL(string: $0) }
        .filter { print("\(String(describing: $0))")
            return $0 != nil }
        .map { $0! }
        .map { try Data(contentsOf: $0) }
        .map { UIImage(data: $0) }
        .subscribe(onNext: { (image) in
            print("image \(String(describing: image))")
        })
        .disposed(by: disposeBag)
}

//useMapWithStream()

func useScheduler() {
    let disposeBag = DisposeBag()
    Observable
        .just("800x600")
        .map { $0.replacingOccurrences(of: "x", with: "/") }
        .map { "http://picsum.photos/\($0)/?random" }
        .map { URL(string: $0) }
        .filter { print("background \(String(describing: $0))")
            return $0 != nil }
        .map { $0! }
        // playground라 반영 안되는 것이오?!
        .subscribeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()))
//        .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
        .map { try Data(contentsOf: $0) }
        .map { UIImage(data: $0) }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { (image) in
            print("main queue image \(String(describing: image))")
        })
        .disposed(by: disposeBag)
}

useScheduler()

print("///////////////////")
print("3. RxCocoa")
print("///////////////////")
print("go to Lecture12ViewController.swift")

