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
 # AsyncSubject
 */
// PublishSubject, BehaviorSubject, ReplaySubject는 subject로 이벤트가 전달되면 즉시 구독자에게 전달함
// AsyncSubject는 subject로 completed 이벤트가 전달되기 전까지 어떤 이벤트도 구독자로 전달하지 않음
// completed 이벤트가 전달되면 그 시점에 가장 최근에 전달된 next 이벤트 하나를 구독자에게 전달

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let subject = AsyncSubject<Int>()

subject
    .subscribe{ print($0) }
    .disposed(by: bag)

subject.onNext(1) // subject로 commpleted 이벤트가 전달되지 않은 상태 -> 해당 시점의 전달한 next 이벤트는 구독자에게 전달되지 않음

subject.onNext(2)
subject.onNext(3)

// 가장 최근에 전달된 next 이벤트가 구독자로 전달됨
subject.onCompleted()

/*
 next(3)
 completed
 */

// error 이벤트는 next 이벤트가 구독자에게 전달되지 않음. error 이벤트만 전달됨
subject.onError(MyError.error)

/*
 error(error)
 */
