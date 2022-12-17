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
 # distinctUntilChanged
 */

struct Person {
    let name: String
    let age: Int
}

let disposeBag = DisposeBag()
let numbers = [1, 1, 3, 2, 2, 3, 1, 5, 5, 7, 7, 7]
let tuples = [(1, "하나"), (1, "일"), (1, "one")]
let persons = [
    Person(name: "Sam", age: 12),
    Person(name: "Paul", age: 12),
    Person(name: "Tim", age: 56)
]

// # distinctUntilChanged()
Observable.from(numbers)
    .distinctUntilChanged() // Observable에서 방출하는 이벤트를 순서대로 비교한 다음에 이전 이벤트와 동일하면 방출하지 않음. 비교연산자를 사용해 포함되어 있는 값을 비교
    .subscribe { print($0) }
    .disposed(by: disposeBag)
// 동일한 이벤트가 연속적으로 방출된 경우에만 무시
/*
 next(1)
 next(3)
 next(2)
 next(3)
 next(1)
 next(5)
 next(7)
 completed
 */


// # distinctUntilChanged(_: compare:)
Observable.from(numbers)
    .distinctUntilChanged{ !$0.isMultiple(of: 2) && !$1.isMultiple(of: 2) } // 클로저를 파라미터로 받음. Observable이 방출하는 next 이벤트에 포함된 값을 파라미터로 받음. 두 값이 같으면 true를 리턴하고 다르면 false를 리턴
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// 연속된 홀수를 방출하지 않음
// 짝수는 무조건 false이므로 그대로 방출
/*
 next(1)
 next(2)
 next(2)
 next(3)
 completed
 */


// # distinctUntilChanged(_ keySelectr: ((Int,String)) throws -> Equatable)
Observable.from(tuples)
    .distinctUntilChanged{ $0.0 }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// 첫번째 숫자가 모두 같으므로 이어지는 두 이벤트를 동일한 값으로 판단
/*
 next((1, "하나"))
 completed
 */

Observable.from(tuples)
    .distinctUntilChanged{ $0.1 }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

/*
 next((1, "하나"))
 next((1, "일"))
 next((1, "one"))
 completed
 */



// # distinctUntilChanged(at: KeyPath<Person, Equatable>)
Observable.from(persons)
    .distinctUntilChanged(at: \.age)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// 나이로 이벤트 비교
/*
 next(Person(name: "Sam", age: 12))
 next(Person(name: "Tim", age: 56))
 completed
 */
