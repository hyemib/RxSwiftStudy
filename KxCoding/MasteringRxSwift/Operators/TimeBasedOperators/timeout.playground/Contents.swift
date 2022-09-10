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
 # timeout
 */

// func timeout(_ dueTime: RxTimeInterval, scheduler: SchedulerType)
// 첫번째 파라미터로 timeout시간을 전달하는데 이시간 안에 next 이벤틀를 방출하지 않으면 에러 이벤트를 전달하고 종료
// func timeout(_ dueTime: RxTimeInterval, other: Source, scheduler: SchedulerType)
// timeout이 발생하면 에러이벤트를 전달하는 것이 아니라 구독대상을 두번째 파라미터로 전달한 Observable로 교체

let bag = DisposeBag()

let subject = PublishSubject<Int>()

/*
subject.timeout(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: bag)

Observable<Int>.timer(.seconds(1), period: .seconds(1), scheduler: MainScheduler.instance)
    .subscribe(onNext: {subject.onNext($0)})
    .disposed(by: bag)

/*
 next(0)
 next(1)
 next(2)
 next(3)
 next(4)
 next(5)
 next(6)
 next(7)
 .
 .
 */
// sconds(5)로 지정하면 error(Sequence timeout.)이 방출됨
*/

// error이벤트 대신 0을 방출하고자 할경우
subject.timeout(.seconds(3), other: Observable.just(0), scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: bag)

Observable<Int>.timer(.seconds(2), period: .seconds(5), scheduler: MainScheduler.instance)
    .subscribe(onNext: {subject.onNext($0)})
    .disposed(by: bag)

/*
 next(0) // subject가 전달한 이벤트
 next(0) // timeout
 completed
 */
