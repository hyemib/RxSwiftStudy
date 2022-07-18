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
 # Observables
 */
// Observable은 Observer에 이벤트를 전달한다. Observer은 Observable을 감시(Subscribe)하고 있다가 전달되는 이벤트를 처리한다.

// Observable은 3가지 이벤트를 전달한다.
// 1. Next => Emission(방출)
// - Next 이벤트가 하나도 전달되지 않을 수도 있고 하나 이상 전달되는 경우도 있다.
// 2. Error or Completed  => Notification
// - Life cycle에서 가장 마지막에 전달


// # Observable 생성
// 1. create
// create 연산자는 Observable 타입 프로토콜에 선언되어 있는 타입 메소드이다. => 연산자
Observable<Int>.create { (observer) -> Disposable in
    observer.on(.next(0))
    observer.onNext(1)
    
    observer.onCompleted() // 종료
    
    return Disposables.create() // Disposables은 메모리 정의에 필요한 객체
}

// 2. from
Observable.from([0, 1])


// observable이 생성만 된 상태. 정수가 방출되거나 이벤트가 전달x
// observable은 이벤트가 어떤 순서로 전달되는지 정의
// 이벤트가 전달되는 시점은 observer가 observable을 구독(Subscribe)하는 시점
