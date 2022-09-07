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
 # sample
 */
// dataObservable.sample(triggerObservable)
// dataObservable에서 연산자를 호출하고 triggerObservable을 파라미터로 전달. triggerObservable에서 next 이벤트를 전달할 때 마다 dataObservable이 최신 이벤트를 방출
// withLatestFrom과 다르게 동일한 next 이벤트를 반복해서 방출하지 않음

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let trigger = PublishSubject<Void>()
let data = PublishSubject<String>()

data.sample(trigger)
    .subscribe { print($0) }
    .disposed(by: bag)

trigger.onNext(())
data.onNext("Hello")

trigger.onNext(())
trigger.onNext(())

data.onCompleted()
trigger.onNext(())

// withLatestFrom 연산자는 completed 이벤트 대신 최신 next 이벤트를 전달했지만 sample 연산자는 completed 이벤트를 그대로 전달
/*
 next(Hello)
 completed
 */

/*
data.onError(MyError.error)
 next(Hello)
 error(error)
*/
