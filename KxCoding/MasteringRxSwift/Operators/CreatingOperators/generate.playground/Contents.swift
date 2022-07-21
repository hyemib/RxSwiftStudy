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
 # generate
 */
// 1씩 증가하는 range와 다르게 generate는 증가되는 크기를 바꾸거나 감소되게 할 수 있음
let disposeBag = DisposeBag()
let red = "🔴"
let blue = "🔵"

Observable.generate(initialState: 0, condition: { $0 <= 10 }, iterate: { $0 + 2 }) // (initialState: 시작 값, condition: true를 return 하는 경우에만 요소가 방출됨. false를 return하면 completed 이벤트를 전달하고 바로 종료, iterate: 값을 바꾸는 코드. 값을 증가 or 감소). generate 연산자는 range와 다르게 파라미터 형식이 정수로 제한되지 않음
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*
 next(0)
 next(2)
 next(4)
 next(6)
 next(8)
 next(10)
 completed
 */

Observable.generate(initialState: 10, condition: { $0 >= 0 }, iterate: { $0 - 2})
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*
 next(10)
 next(8)
 next(6)
 next(4)
 next(2)
 next(0)
 completed
 */

Observable.generate(initialState: red, condition: { $0.count <= 15 }, iterate: { $0.count.isMultiple(of: 2) ? $0 + red : $0 + blue})
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*
 next(🔴)
 next(🔴🔵)
 next(🔴🔵🔴)
 next(🔴🔵🔴🔵)
 next(🔴🔵🔴🔵🔴)
 next(🔴🔵🔴🔵🔴🔵)
 next(🔴🔵🔴🔵🔴🔵🔴)
 next(🔴🔵🔴🔵🔴🔵🔴🔵)
 next(🔴🔵🔴🔵🔴🔵🔴🔵🔴)
 next(🔴🔵🔴🔵🔴🔵🔴🔵🔴🔵)
 next(🔴🔵🔴🔵🔴🔵🔴🔵🔴🔵🔴)
 next(🔴🔵🔴🔵🔴🔵🔴🔵🔴🔵🔴🔵)
 next(🔴🔵🔴🔵🔴🔵🔴🔵🔴🔵🔴🔵🔴)
 next(🔴🔵🔴🔵🔴🔵🔴🔵🔴🔵🔴🔵🔴🔵)
 next(🔴🔵🔴🔵🔴🔵🔴🔵🔴🔵🔴🔵🔴🔵🔴)
 completed
 */
