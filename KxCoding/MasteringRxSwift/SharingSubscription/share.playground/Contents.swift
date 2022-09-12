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
 # share
 */

// share(replay: Int = 0, SubjectLifetimeScope = .whileConnected) -> Observable<Element>
// share 연산자는 두개의 파라미터를 받음. 첫번째 파라미터는 replay 버퍼의 크기. 파라미터로 0을 전달하면 multicast를 호출할 때 PublishSubject를 전달. 0보다 큰 값을 전달하면 ReplaySubject를 전달. 기본 값이 0으로 선언되어 있기 때문에 다른 값을 전달하지 않는다면 새로운 구독자는 구독 이후에 방출되는 이벤트만 전달받음. multicast 연산자를 호출하기 때문에 하나의 subject를 통해 시퀀스를 공유. multicast 연산자를 호출하고 refCount를 호출하므로 새로운 구독자가 추가되면 자동으로 connect되고 구독자가 더이상 없으면 disconnect.
// 두번째 파라미터는 subject의 수명을 결정. 기본 값이 whileConnected. 새로운 구독자가 추가(connect)되면 새로운 subject가 생성. 그리고 connection이 종료되면 subject는 사라짐. forever을 전달하면 모든 connection이 하나의 subject를 공유.
/*
let bag = DisposeBag()
let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).debug().share()

let observer1 = source
    .subscribe { print("🔵", $0) }

let observer2 = source
    .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe { print("🔴", $0) }

DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    observer1.dispose()
    observer2.dispose()
}

DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
    let observer3 = source.subscribe { print("⚫️", $0) }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        observer3.dispose()
    }
}

// share의 첫번째 파라미터의 기본 값이 0이므로 3초 뒤에 구독을 시작한 두번째 구독자는 이전에 전달된 3개의 이벤트는 받지 못함. 5초 뒤에 모든 구독이 중지되면 내부에 있는 ConnectableObservable도 중지됨. isDisposed가 출력되는데 share 연산자 내부에서 refCount 연산자를 호출하기 때문. 그리고 7초 뒤에 새로운 구독자가 추가되면 ConnectableObservable에서 새로운 시퀀스가 시작. 그래서 세번째 구독자가 처음받는 next 이벤트에는 0이 저장되어 있음.
// share의 두번째 파라미터는 ConnectableObservable 내부에 있는 subject의 수명을 결정하는데 기본 값이 whileConnected. 새로운 구독자가 추가되면 subject를 생성하고 이어지는 구독자들을 이 subject를 공유. 그래서 첫번째 구독자와 두번째 구독자는 동일한 subject로 부터 이벤트를 받음. 두번째 구독자가 처음으로 받는 next 이벤트에 0이 아니라 3이 저장되어 있는 이유. isDisposed가 출력되는 시점에 subject는 사라지고 subscribed가 출력되는 시점에 새로운 subject가 생성. 그래서 세번째 구독자가 처음으로 받는 next 이벤트에는 0이 저장되어 있음.

/*
 2022-09-12 23:56:14.834: share.playground:36 (__lldb_expr_11) -> subscribed
 2022-09-12 23:56:15.836: share.playground:36 (__lldb_expr_11) -> Event next(0)
 🔵 next(0)
 2022-09-12 23:56:16.835: share.playground:36 (__lldb_expr_11) -> Event next(1)
 🔵 next(1)
 2022-09-12 23:56:17.836: share.playground:36 (__lldb_expr_11) -> Event next(2)
 🔵 next(2)
 2022-09-12 23:56:18.836: share.playground:36 (__lldb_expr_11) -> Event next(3)
 🔵 next(3)
 🔴 next(3)
 2022-09-12 23:56:19.835: share.playground:36 (__lldb_expr_11) -> Event next(4)
 🔵 next(4)
 🔴 next(4)
 2022-09-12 23:56:20.357: share.playground:36 (__lldb_expr_11) -> isDisposed
 2022-09-12 23:56:22.557: share.playground:36 (__lldb_expr_11) -> subscribed
 2022-09-12 23:56:23.559: share.playground:36 (__lldb_expr_11) -> Event next(0)
 ⚫️ next(0)
 2022-09-12 23:56:24.559: share.playground:36 (__lldb_expr_11) -> Event next(1)
 ⚫️ next(1)
 2022-09-12 23:56:25.559: share.playground:36 (__lldb_expr_11) -> Event next(2)
 ⚫️ next(2)
 2022-09-12 23:56:25.857: share.playground:36 (__lldb_expr_11) -> isDisposed
 */
*/




/*
let bag = DisposeBag()
let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).debug().share(replay: 5)

let observer1 = source
    .subscribe { print("🔵", $0) }

let observer2 = source
    .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe { print("🔴", $0) }

DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    observer1.dispose()
    observer2.dispose()
}

DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
    let observer3 = source.subscribe { print("⚫️", $0) }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        observer3.dispose()
    }
}

// 새로운 구독자는 구독이 시작되는 시점에 버퍼에 저장되어 있는 이벤트를 함께 전달받음. 그래서 두번째 구독자는 이전에 전달되었던 next 이벤트도 함께 전달받음. 하지만 세번째 구독자는 새로운 subject로부터 이벤트를 전달받기 때문에 구독시점에 하나의 next 이벤트만 받음.
/*
 2022-09-13 01:10:35.838: share.playground:92 (__lldb_expr_13) -> subscribed
 2022-09-13 01:10:36.848: share.playground:92 (__lldb_expr_13) -> Event next(0)
 🔵 next(0)
 2022-09-13 01:10:37.848: share.playground:92 (__lldb_expr_13) -> Event next(1)
 🔵 next(1)
 2022-09-13 01:10:38.848: share.playground:92 (__lldb_expr_13) -> Event next(2)
 🔵 next(2)
 🔴 next(0)
 🔴 next(1)
 🔴 next(2)
 2022-09-13 01:10:39.848: share.playground:92 (__lldb_expr_13) -> Event next(3)
 🔵 next(3)
 🔴 next(3)
 2022-09-13 01:10:40.848: share.playground:92 (__lldb_expr_13) -> Event next(4)
 🔵 next(4)
 🔴 next(4)
 2022-09-13 01:10:41.354: share.playground:92 (__lldb_expr_13) -> isDisposed
 2022-09-13 01:10:43.555: share.playground:92 (__lldb_expr_13) -> subscribed
 2022-09-13 01:10:44.558: share.playground:92 (__lldb_expr_13) -> Event next(0)
 ⚫️ next(0)
 2022-09-13 01:10:45.558: share.playground:92 (__lldb_expr_13) -> Event next(1)
 ⚫️ next(1)
 2022-09-13 01:10:46.557: share.playground:92 (__lldb_expr_13) -> Event next(2)
 ⚫️ next(2)
 2022-09-13 01:10:46.860: share.playground:92 (__lldb_expr_13) -> isDisposed
 */
*/



let bag = DisposeBag()
let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).debug().share(replay: 5, scope: .forever) // 모든 구독자가 하나의 subject를 공유.

let observer1 = source
    .subscribe { print("🔵", $0) }

let observer2 = source
    .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe { print("🔴", $0) }

DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    observer1.dispose()
    observer2.dispose()
}

DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
    let observer3 = source.subscribe { print("⚫️", $0) }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        observer3.dispose()
    }
}

// 세번째 구독자가 추가되는 시점에 버퍼에 저장되어 있는 5개의 이벤트가 함께 전달.
// 이어지는 next 이벤트에 5가 아닌 0이 저장되어 있음 -> 시퀀스가 중지된 다음에 새로운 구독자가 추가되면 새로운 시퀀스가 시작되기 때문. 
/*
 2022-09-13 01:15:21.920: share.playground:147 (__lldb_expr_15) -> subscribed
 2022-09-13 01:15:22.922: share.playground:147 (__lldb_expr_15) -> Event next(0)
 🔵 next(0)
 2022-09-13 01:15:23.922: share.playground:147 (__lldb_expr_15) -> Event next(1)
 🔵 next(1)
 2022-09-13 01:15:24.922: share.playground:147 (__lldb_expr_15) -> Event next(2)
 🔵 next(2)
 🔴 next(0)
 🔴 next(1)
 🔴 next(2)
 2022-09-13 01:15:25.922: share.playground:147 (__lldb_expr_15) -> Event next(3)
 🔵 next(3)
 🔴 next(3)
 2022-09-13 01:15:26.922: share.playground:147 (__lldb_expr_15) -> Event next(4)
 🔵 next(4)
 🔴 next(4)
 2022-09-13 01:15:27.447: share.playground:147 (__lldb_expr_15) -> isDisposed
 ⚫️ next(0)
 ⚫️ next(1)
 ⚫️ next(2)
 ⚫️ next(3)
 ⚫️ next(4)
 2022-09-13 01:15:29.645: share.playground:147 (__lldb_expr_15) -> subscribed
 2022-09-13 01:15:30.647: share.playground:147 (__lldb_expr_15) -> Event next(0)
 ⚫️ next(0)
 2022-09-13 01:15:31.647: share.playground:147 (__lldb_expr_15) -> Event next(1)
 ⚫️ next(1)
 2022-09-13 01:15:32.647: share.playground:147 (__lldb_expr_15) -> Event next(2)
 ⚫️ next(2)
 2022-09-13 01:15:32.946: share.playground:147 (__lldb_expr_15) -> isDisposed
 */
