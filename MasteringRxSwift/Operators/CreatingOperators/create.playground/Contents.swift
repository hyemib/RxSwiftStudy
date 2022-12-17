//
//  Mastering RxSwift
//  Copyright (c) KxCoding <help@kxcoding.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import RxSwift

/*:
 # create
 */
// Observable이 동작하는 방식을 직접 구현하고 싶은 경우 사용

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

// create 연산자는 Observable을 파라미터로 받아서 disposable을 리턴하는 클로저를 전달
Observable<String>.create { (observer) -> Disposable in
    guard let url = URL(string: "https://www.apple.com")
    else {
        observer.onError(MyError.error)
        return Disposables.create() // return 형에 Disaposable이 아닌 Disposables
    }
    guard let html = try? String(contentsOf: url, encoding: .utf8) else {
        observer.onError(MyError.error)
        return Disposables.create()
    }
    observer.onNext(html) // 요소를 방출할 때는 onNext() 사용. 방출할 요소를 파라미터로 전달
    observer.onCompleted() // Observer로 completed()가 전달. observable을 종료하기 위해서는 onError or onCompleted()를 반드시 호출해야 함.
    
    //observer.onNext("After completed") // observerble은 error or completed 이벤트를 전달한 후에 더이상 이벤트를 전달하지 않음 -> 마지막에 방출한 문자열은 어떤 경우에도 방출되지 않음
    
    return Disposables.create()
}
.subscribe { print($0) }
.disposed(by: disposeBag)

