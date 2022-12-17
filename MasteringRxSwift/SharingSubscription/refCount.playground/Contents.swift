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
 # refCount
 */

// ConnectableObservableType에서만 사용할 수 있음
// 파라미터x. Observable을 리턴
// 새로운 구독자가 추가되는 시점에 자동으로 connect 메소드를 호출. 구독자가 구독을 중지하고 더이상 다른 구독자가 없다면 ConnectableObservable에서 시퀀스를 중지. 새로운 구독자가 추가되면 다시 connect 메소드를 호출. 이때 ConnectableObservable에서는 새로운 시퀀스가 시작.

let bag = DisposeBag()
let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).debug().publish().refCount()

let observer1 = source
    .subscribe { print("🔵", $0) }

// source.connect() // refCount Observable은 내부에서 connect 메소드를 자동으로 호출하기 때문에 connect 호출 코드x

DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    observer1.dispose()
}

DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
    let observer2 = source.subscribe { print("🔴", $0) }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        observer2.dispose()
    }
}

// 첫번째 구독자가 추가되면 refCount Observable이 connect 메소드를 호출. ConnectableObsevable은 subject를 통해서 모든 구독자에게 이벤트를 전달.
// 3초 뒤에 첫번째 구독자가 구독을 중지함. 이 시점에 다른 구독자는 없으므로 ConectableObservable도 중지됨. 그래서 isDisposed가 출력(disconnect).
// 7초 뒤에 새로운 구독자가 추가됨(connect). ConnectableObservable에서 새로운 시퀀스가 시작됨. 구독자가 처음으로 받는 next 이벤트에는 7이 아닌 0이 저장되어 있음. 3초 뒤에 구독을 중지하면 ConnectableObservable 중지됨. 그래서 isDisposed가 출력됨.

/*
 2022-09-12 23:30:18.973: refCount.playground:36 (__lldb_expr_9) -> subscribed
 2022-09-12 23:30:19.975: refCount.playground:36 (__lldb_expr_9) -> Event next(0)
 🔵 next(0)
 2022-09-12 23:30:20.975: refCount.playground:36 (__lldb_expr_9) -> Event next(1)
 🔵 next(1)
 2022-09-12 23:30:21.975: refCount.playground:36 (__lldb_expr_9) -> Event next(2)
 🔵 next(2)
 2022-09-12 23:30:22.275: refCount.playground:36 (__lldb_expr_9) -> isDisposed
 2022-09-12 23:30:26.672: refCount.playground:36 (__lldb_expr_9) -> subscribed
 2022-09-12 23:30:27.674: refCount.playground:36 (__lldb_expr_9) -> Event next(0)
 🔴 next(0)
 2022-09-12 23:30:28.674: refCount.playground:36 (__lldb_expr_9) -> Event next(1)
 🔴 next(1)
 2022-09-12 23:30:29.674: refCount.playground:36 (__lldb_expr_9) -> Event next(2)
 🔴 next(2)
 2022-09-12 23:30:29.976: refCount.playground:36 (__lldb_expr_9) -> isDisposed
 */










