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
 # startWith
 */
// Observable이 요소를 방출하기 전에 다른 항목들을 앞부분에 추가
// 주로 기본값이나 시작값을 지정할 때 사용

let bag = DisposeBag()
let numbers = [1, 2, 3, 4, 5]
/*
Observable.from(numbers)
    .startWith(0)
    .subscribe { print($0) }
    .disposed(by: bag)

/*
 next(0)
 next(1)
 next(2)
 next(3)
 next(4)
 next(5)
 completed
 */
*/
Observable.from(numbers)
    .startWith(0)
    .startWith(-1, -2)
    .startWith(-3)
    .subscribe { print($0) }
    .disposed(by: bag)

/*
 next(-3)
 next(-1)
 next(-2)
 next(0)
 next(1)
 next(2)
 next(3)
 next(4)
 next(5)
 completed
 */
