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
 # catch(_:)
 */
// Error 처리방법
// Observable에서 Error 이벤트를 방출하면 구독이 종료되고 구독자는 더이상 새로운 이벤트를 받지 못함.
// 예를들어 Observable이 네트워크 요청을 처리하고 구독자가 UI를 업데이트하는 경우, UI를 업데이트하는 코드는 next 이벤트에서 실행하는데 에러이벤트가 전달되면 구독이 종료되고 더이상 next 이벤트가 전달되지 않음. 그래서 UI를 업데이트하는 코드는 실행되지 않음. RxSwift는 2가지 방법으로 이 문제를 해결함. 첫번재는 에러이벤트가 전달되면 새로운 Observable을 리턴(catch 연산자를 사용). catch 연산자는 next 이벤트와 completed 이벤트를 구독자에게 그대로 전달. 반면 Observable에서 에러 이벤트를 방출하면 새로운 Observable로 바꿔서 구독자에게 전달. 두번째 방법은 에러가 발생하면 Observable을 다시 구독(retry 연산자 사용). 에러가 발생하지 않을때까지 무한정 재시도하거나 재시도 횟수를 제한하는 방법을 제공.


// catch 연산자는 Source Observable이 방출한 Error를 새로운 Observable로 교체하는 방식으로 처리

let bag = DisposeBag()

enum MyError: Error {
    case error
}

let subject = PublishSubject<Int>()
let recovery = PublishSubject<Int>()

subject
    .catch { _ in recovery }
    .subscribe { print($0) }
    .disposed(by: bag)

subject.onError(MyError.error)
subject.onNext(123)
subject.onNext(11)

// 구독자로 에러이벤트가 전달x
// catch 연산자가 원본 subject를 recovery subject로 교체.
// subject는 더이상 다른 이벤트를 전달하지 못함. 그래서 이 값은 구독자에게 전달되지 않음. 반면 recovery subject는 전달할 수 있음.

recovery.onNext(30)

/*
 next(30)
 */

recovery.onCompleted()

/*
 next(30)
 completed
 */
