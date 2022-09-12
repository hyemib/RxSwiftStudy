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












