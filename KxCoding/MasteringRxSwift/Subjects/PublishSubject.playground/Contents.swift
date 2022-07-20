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
 # PublishSubject
 */
// observable은 observar에 이벤트를 전달
// observar는 observable을 구독하고 전달되는 이벤트를 처리
// observable은 다른 observable을 구독하지 못함
// observar는 다른 observar로 이벤트 전달을 하지 못함

// subject는 다른 observable로부터 이벤트를 받아 구독자로 전달할 수 있음
// subject는 observable인 동시에 observal이다.
// publishSubject, BehaviorSubject, ReplaySubject, AsyncSubject

// PublishSubject는 subject로 전달되는 새로운 이벤트를 구독자로 전달
// BehaviorSubject는 생성 시점에 시작 이벤트를 지정. subject로 전달되는 이벤트 중에서 가장 마지막에 전달된 최신 이벤트를 저장했다가 새로운 구독자에게 최신 이벤트를 전달
// ReplaySubject는 하나 이상의 최신 이벤트를 버퍼에 저장. observer가 구독을 시작하면 버퍼에 있는 모든 이벤트를 전달
// AsyncSubject는 subject로 completed 이벤트가 전달되는 시점에 마지막으로 전달된 next 이벤트를 구독자로 전달

// RxSwift는 subject를 래핑하고 있는 두가지 relay를 제공
// PublishRelay, BehaviorRelay

// PublishRelay는 PublishSubject를 래핑한 것
// BehaviorRelay는 BehaviorSubjet를 래핑한 것
// relay는 일반적인 subject와 달리 next 이벤트만 받는다.(completed, error 받지 않음)
// 주로 종료 없이 계속 전달되는 이벤트 시퀀스를 처리할 때 활용



// PublishSubject는 subject로 전달되는 이벤트를 observer에게 전달하는 가장 기본적인 형태의 subject

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

let subject = PublishSubject<String>() // 문자열이 포함된 next 이벤트를 받아서 다른 observer에게 전달할 수 있음
// 생성자를 호출할 때는 파라미터를 전달하지 않음. 비어있는 상태로 생성. subject가 생성되는 시점에는 내부에 아무런 이벤트도 저장되어 있지 않음. 그래서 생성 직후에 observer가 구독을 시작하면 아무런 이벤트도 전달되지 않음
// subject는 observerble인 동시에 observer이다.
// observer와 마찬가지로 onNext 메소드를 호출할 수 있다.

subject.onNext("Hello")


let o1 = subject.subscribe{ print(">> 1", $0) }
o1.disposed(by: disposeBag)
// PublishSubject는 구독 이후에 전달되는 새로운 이벤트만 구독자로 전달. 구독자가 구독하기 전에 전달되었던 next는 전달되지 않음

subject.onNext("RxSwift") // subject로 전달됨. subject는 이 이벤트를 구독자로 전달.

/*
 1 next(RxSwift)
 */



let o2 = subject.subscribe { print(">> 2", $0) }
o2.disposed(by: disposeBag)

subject.onNext("Subject")

/*
 1 next(RxSwift)
 1 next(Subject)
 2 next(Subject)
 */

subject.onCompleted()

/*
 1 next(RxSwift)
 1 next(Subject)
 2 next(Subject)
 1 completed
 2 completed
 */

let o3 = subject.subscribe{ print(">> 3", $0) }
o3.disposed(by: disposeBag)

// observerble&subject에서 completed 이벤트가 전달된 이후에는 더이상 next 이벤트가 전달되지 않음
/*
 1 next(RxSwift)
 1 next(Subject)
 2 next(Subject)
 1 completed
 2 completed
 3 completed
 */
