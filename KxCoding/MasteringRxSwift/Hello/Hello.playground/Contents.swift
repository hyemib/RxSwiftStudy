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


// # Swift
/*
var a = 1
var b = 2

a + b

a = 12
*/

// a의 값을 변경해도 이전의 a+b의 값은 변경되지 않는다.
// 명령형 프로그래밍에서는 a와 b의 값이 변경될 때 마다 a+b의 결과가 바뀌도록 구현하는게 상대적으로 복잡하다.
// RxSwift에서는 값에 따라 새로운 결과를 도출하는 코드를 상대적으로 쉽게 구현할 수 있다. => Reactive Programming(반응형 프로그래밍)


// # RxSwift

let disposeBag = DisposeBag()

let a = BehaviorSubject(value: 1)
let b = BehaviorSubject(value: 2)

Observable.combineLatest(a, b) { $0 + $1 }
.subscribe(onNext: { print($0)} ) // 3
.disposed(by: disposeBag)

a.onNext(12) // 14
// 이전의 a+b의 값이 변경되어 출력
