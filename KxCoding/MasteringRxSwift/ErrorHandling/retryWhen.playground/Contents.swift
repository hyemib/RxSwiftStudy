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
 # retry(when:)
 */

// 재시도 시점 구현

let bag = DisposeBag()

enum MyError: Error {
    case error
}

var attempts = 1

let source = Observable<Int>.create { observer in
    let currentAttempts = attempts
    print("START #\(currentAttempts)")
    
    if attempts < 3 {
        observer.onError(MyError.error)
        attempts += 1
    }
    
    observer.onNext(1)
    observer.onNext(2)
    observer.onCompleted()
    
    return Disposables.create {
        print("END #\(currentAttempts)")
    }
}

let trigger = PublishSubject<Void>()

source
    .retry { _ in trigger } // retry와 다르게 바로 재시도하지 않고 trigger Observable이 next 이벤트를 방출하기 전까지 대기
    .subscribe { print($0) }
    .disposed(by: bag)

/*
 START #1
 END #1
 */

trigger.onNext(()) // trigger subject로 next 이벤트를 전달하면 Source Observable에서 새로운 구독을 시작.

// Source observable에서 에러 이벤트를 방출하기 때문에 다시 대기.
/*
START #1
END #1
START #2
END #2
*/

trigger.onNext(())

// 에러 발생x
/*
 START #1
 END #1
 START #2
 END #2
 START #3
 next(1)
 next(2)
 completed
 END #3
 */



