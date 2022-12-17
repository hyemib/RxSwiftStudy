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
import RxCocoa

/*:
 # Relay
 */
// RxSwift는 3가지 Relay를 제공
// PublishRelay, BehaviorRelay, ReplayRelay
// Relay는 subject와 유사한 특징을 가지고 있고 내부에 subject(PublishSubject, BehaviorSubject, ReplaySubject)를 래핑하고 있다
// Relay는 subject와 마찬가지로 다른 소스로부터 이벤트를 받아서 구독자에게 전달
// next 이벤트만 전달, completed&error x -> subject와 다르게 종료되지 않음, 구독자가 dispose 되기 전까지 계속해서 이벤트를 처리, 주로 UI 이벤트를 처리할 때 활용

// Relay는 RxSwift 프레임워크가 아닌 RxCocoa 프레임워크를 통해 제공

let bag = DisposeBag()

let prelay = PublishRelay<Int>()

prelay.subscribe {print("1: \($0)")}
.disposed(by: bag)

prelay.accept(1) // Relay로 next 이벤트를 전달할 때는 onNext()가 아닌 accept() 사용

/*
 1: next(1)
 */



let brelay = BehaviorRelay<Int>(value: 1)

brelay.accept(2)

brelay.subscribe { print("2: \($0)") }
.disposed(by: bag)

// 가장 최근 next 이벤트가 구독자에게 전달
/*
 1: next(1)
 2: next(2)
 */

brelay.accept(3)

/*
1: next(1)
2: next(2)
2: next(3)
*/

// BehaviorRelay는 value 속성 제공.
// value는 Relay가 저장하고 있는 next 이벤트에 접근해 저장되어 있는 값을 리턴
// value는 읽기전용
print(brelay.value)

/*
 1: next(1)
 2: next(2)
 2: next(3)
 3
 */



let rrelay = ReplayRelay<Int>.create(bufferSize: 3) // 버퍼 크기 생성

(1...10).forEach { rrelay.accept($0) }

rrelay.subscribe { print("3: \($0)") }
.disposed(by: bag)

// Relay로 전달한 마지막 값 3개가 구독자에게 전달됨
/*
 3: next(8)
 3: next(9)
 3: next(10)
 */
