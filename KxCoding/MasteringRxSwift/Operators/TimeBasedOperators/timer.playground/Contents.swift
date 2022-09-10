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
 # timer
 */
// 정수를 반복적으로 방출하는 Observable을 생성
// 지연시간과 반복주기를 지정할 수 있음. 두 값에 따라 동작방식이 달라짐

let bag = DisposeBag()

/*
Observable<Int>.timer(.seconds(1), scheduler: MainScheduler.instance) // 첫번째 파라미터는 첫번째 요소가 방출되는 시점까지의 상대적인 시간. 구독을 시작하고 첫번째 요소가 구독자에게 전달되는 시간. 두번째 파라미터는 반복주기이며 기본값이 nil. 생략되어 있는 경우 하나의 요소만 방출
    .subscribe { print($0) }
    .disposed(by: bag)

/*
 next(0)
 completed
 */
*/

Observable<Int>.timer(.seconds(1), period: .milliseconds(500), scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: bag)
// 무한정 방출하기 때문에 타이머를 중지하고자 할 경우 직접 dispose 해야함
