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
 # interval
 */
// 특정 주기마다 정수를 방출하는 Observable이 필요할 때 사용

let i = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance) // 첫번째 파라미터는 반복주기. 연산자가 리턴하는 Observable은 지정된 주기마다 정수를 반복적으로 방출. 종료시점을 지정하지 않기 때문에 직접 dispose 하기 전까지 계속해서 방출. 방출하는 정수의 형식은 Int로 제한x. Int를 포함한 다른 정수형식을 모두 사용할 수 있음. double이나 문자형 형식은 사용x.

let subscription1 = i.subscribe { print("1 >> \($0)") }

DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    subscription1.dispose()
}

/*
 1 >> next(0)
 1 >> next(1)
 1 >> next(2)
 1 >> next(3)
 1 >> next(4)
 */

// Interval 연산자가 생성하는 Observable은 내부에 타이머를 가지고 있음
// 타이머가 시작되는 시점은 생성시점이 아님. 구독자가 구독을 시작하는 시점
// Observable에서 새로운 구독자가 추가될 때마다 새로운 타이머가 생성

var subscription2: Disposable?

DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    subscription2 = i.subscribe { print("2 >> \($0)") }
}

DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
    subscription2?.dispose()
}

// 새로운 구독이 추가되는 시점에 내부에 있는 타이머가 시작
/*
 1 >> next(0)
 1 >> next(1)
 1 >> next(2)
 2 >> next(0)
 1 >> next(3)
 2 >> next(1)
 1 >> next(4)
 2 >> next(2)
 2 >> next(3)
 */
