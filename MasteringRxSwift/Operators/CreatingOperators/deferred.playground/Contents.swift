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
 # deferred
 */
// deferred 연산자를 활용하면 특정 조건에 따라 observable 생성

let disposeBag = DisposeBag()
let animals = ["🐶", "🐱", "🐹", "🐰", "🦊", "🐻", "🐯"]
let fruits = ["🍎", "🍐", "🍋", "🍇", "🍈", "🍓", "🍑"]
var flag = true

let factory: Observable<String> = Observable.deferred {
    flag.toggle()
    
    if flag {
        return Observable.from(animals) // 배열에 있는 요소들이 개별적으로 방출
    } else {
        return Observable.from(fruits)
    }
} // deferred 연산자는 observable을 리턴하는 클로저를 파라미터로 받음

factory
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*
 next(🍎)
 next(🍐)
 next(🍋)
 next(🍇)
 next(🍈)
 next(🍓)
 next(🍑)
 completed
 */


factory
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*
 next(🐶)
 next(🐱)
 next(🐹)
 next(🐰)
 next(🦊)
 next(🐻)
 next(🐯)
 completed
 */

