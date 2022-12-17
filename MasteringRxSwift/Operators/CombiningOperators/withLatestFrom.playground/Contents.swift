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
 # withLatestFrom
 */
// triggerObservable.withLatestFrom(dataObservable)
// 연산자를 호출하는 Observable을 trigger Observable이라 하고 파라미터로 전달하는 Observable을 data Observable이라 함
// triggerObservable이 next 이벤트를 방출하면 dataObservable이 가장 최근에 방출한 next 이벤트를 구독자에게 전달

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let trigger = PublishSubject<Void>()
let data = PublishSubject<String>()

trigger.withLatestFrom(data)
    .subscribe { print($0)}
    .disposed(by: bag)

data.onNext("Hello")
trigger.onNext(())
trigger.onNext(())

// # 1
data.onCompleted()
trigger.onNext(())

/*
 next(Hello)
 next(Hello)
 next(Hello)
 */

// # 2
/*
 trigger.onNext(())
 trigger.onColeted()
 
 /*
  next(Hello)
  next(Hello)
  completed
  */
 */


// # 3
/*
 data.onError(MyError.error)
 trigger.onNext(())
 
 /*
  next(Hello)
  next(Hello)
  error(error)
  */
 */

