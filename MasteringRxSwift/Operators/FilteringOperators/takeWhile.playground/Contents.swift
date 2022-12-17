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
 # take(while:)
 */

let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

Observable.from(numbers)
    .take(while: {!$0.isMultiple(of: 2) }) // while 파라미터는 true를 리턴하면 next 이벤트를 방출. behavior 파라미터는 마지막에 확인한 값을 방출할지 말지를 결정. 기본 값은 .exclusive로 선언되어 있음. 마지막에 확인한 값이 true이면 방출하지만 나머지 경우에는 무시. 이 값을 inclusive로 바꾸면 마지막에 확인한 값이 조건을 충족시키지 않더라도 방출
    .subscribe{ print($0) }
    .disposed(by: disposeBag)

// 2는 false를 리턴하므로 전달하지 않고 completed 이벤트를 전달한 다음 끝남
/*
 next(1)
 completed
 */



Observable.from(numbers)
    .take(while: {!$0.isMultiple(of: 2) }, behavior: .inclusive)
    .subscribe{ print($0) }
    .disposed(by: disposeBag)

// 2도 함께 방출. 조건에서 false이지만 behavior 파라미터로 inclusive를 전달하면 마지막에 확인한 값도 함께 방출함. 
/*
 next(1)
 next(2)
 completed
 */
