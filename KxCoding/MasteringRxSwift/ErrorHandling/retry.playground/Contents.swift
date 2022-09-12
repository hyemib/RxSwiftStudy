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
 # retry
 */
// Source Observable에서 에러가 발생하면 Observable에 대한 구독을 해지하고 새로운 구독을 시작. 새로운 구독이 시작되기 때문에 Observable에 대한 모든 작업은 처음부터 다시 시작함. Observable에서 에러가 발생하지 않으면 정상적으로 종료되고 에러가 발생하면 또다시 새로운 구독을 시작.

// retry 연산자가 파리미터 없이 호출하면 Observable이 정상적으로 완료될 때 까지 재시도. Observable에서 반복적으로 에러가 발생하면 재시도 횟수가 늘어나고 그만큼 리소스를 낭비함.
// retry(_ maxAttemptCount: Int) 재시도 횟수 지정

let bag = DisposeBag()

enum MyError: Error {
    case error
}

var attempts = 1
/*
let source = Observable<Int>.create { observer in
    let currentAttempts = attempts
    print("#\(currentAttempts) START")
    
    if attempts < 3 {
        observer.onError(MyError.error)
        attempts += 1
    }
    
    observer.onNext(1)
    observer.onNext(2)
    observer.onCompleted()
    
    return Disposables.create {
        print("#\(currentAttempts) END")
    }
}

source
    .retry()
    .subscribe { print($0) }
    .disposed(by: bag)

/*
 #1 START
 #1 END
 #2 START
 #2 END
 #3 START
 next(1)
 next(2)
 completed
 #3 END
 */
*/


let source = Observable<Int>.create { observer in
    let currentAttempts = attempts
    print("#\(currentAttempts) START")
    
    if attempts > 0 {
        observer.onError(MyError.error)
        attempts += 1
    }
    
    observer.onNext(1)
    observer.onNext(2)
    observer.onCompleted()
    
    return Disposables.create {
        print("#\(currentAttempts) END")
    }
}

source
    .retry(7)
    .subscribe { print($0) }
    .disposed(by: bag)

/*
 #1 START
 #1 END
 #2 START
 #2 END
 #3 START
 #3 END
 #4 START
 #4 END
 #5 START
 #5 END
 #6 START
 #6 END
 #7 START
 #7 END
 error(error)
 */
