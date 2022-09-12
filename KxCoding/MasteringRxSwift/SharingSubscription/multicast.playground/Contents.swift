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
 # multicast
 */

let bag = DisposeBag()
let subject = PublishSubject<Int>()
/*
let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).take(5)

source
    .subscribe { print("🔵", $0) }
    .disposed(by: bag)

source
    .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe { print("🔴", $0) }
    .disposed(by: bag)

// 두개의 sequence가 개별적으로 시작되었고 서로 공유하지 않음
/*
 🔵 next(0)
 🔵 next(1)
 🔵 next(2)
 🔵 next(3)
 🔴 next(0)
 🔵 next(4)
 🔵 completed
 🔴 next(1)
 🔴 next(2)
 🔴 next(3)
 🔴 next(4)
 🔴 completed
 */
*/

// multicast<Subject: SubjectType>(_ subject: Subject)
// 원본 Observable이 방출하는 이벤트는 구독자에게 전달되는게 아니라 파라미터의 subject로 전달. subject는 전달받은 이벤트를 등록된 다수의 구독자에게 전달
// 일반 Observable과 구독자가 추가되면 새로운 sequence가 시작
// ConnectableObservable은 구독자가 추가되어도 sequence가 시작되지 않음. Connect 메소드를 호출하는 시점에 sequence가 시작


let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).take(5).multicast(subject) // ConnectableObservable이 저장됨

source
    .subscribe { print("🔵", $0) }
    .disposed(by: bag)

source
    .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe { print("🔴", $0) }
    .disposed(by: bag)

source.connect() // connect 메소드를 명시적으로 호출해야 sequence가 시작됨. 원하는 시점에 dispose 메소드를 호출해서 공유 sequence를 중지할 수 있음. 그리고 disposebag에 넣어 리소스를 정리할 수도 있음.

// 모든 구독자가 원본 Observable을 공유
// 구독이 지연된 3초동안 원본 Observable이 전달한 두개의 이벤트는 두번째 구독자에게 전달되지 않음. 두번째 구독자가 처음으로 받게되는 이벤트는 2가 저장되어 있는 next 이벤트
/*
 🔵 next(0)
 🔵 next(1)
 🔵 next(2)
 🔴 next(2)
 🔵 next(3)
 🔴 next(3)
 🔵 next(4)
 🔴 next(4)
 🔵 completed
 🔴 completed
 */







