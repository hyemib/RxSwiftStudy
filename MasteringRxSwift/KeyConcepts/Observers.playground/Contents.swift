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
 # Observers
 */
// observer가 구독하는 방법 observable에서 subscribe 메소드를 호출해야 함
// subscribe 메소드를 subscribe 연산자라고도 함
// subscribe 메소드는 observable과 observer을 연결한다.


let o1 = Observable<Int>.create { (observer) -> Disposable in
   observer.on(.next(0))
   observer.onNext(1)
   
   observer.onCompleted()
   
   return Disposables.create()
}

// subscribe 메소드 호출
// #1
o1.subscribe{
    print($0)
        
      // 이벤트에 저장되어 있는 값은 element 속성을 통해 얻을 수 있음
      // 형식이 optinal이기 때문에 optinal binding이 필요함
    if let elem = $0.element {
        print(elem)
    }
}

/*
next(0)
0
next(1)
1
completed
*/

// #2
// 개별 이벤트를 별도의 클로저에서 처리하고 싶을 때 사용. 파라미터는 기본 값이 nil 이므로 처리하지 않을 이벤트에 해당하는 파라미터는 생략 가능
//o1.subscribe(onNext: , onError: , onCompleted: , onDisposed: )

// 클로저 파라미터로 next이벤트에 대한 저장된 요소가 바로 전달됨. element로 접근할 필요 없음
o1.subscribe(onNext: { elem in
    print(elem)
})

/*
0
1
*/


// observer는 동시에 두개 이상의 이벤트를 처리하지 않음
// observable은 observer가 하나의 이벤트를 처리한 후 이어지는 이벤트를 전달한다. 여러 이벤트를 동시에 전달하지 않는다.
o1.subscribe{
    print("== Start ==")
    print($0)
    
    if let elem = $0.element {
        print(elem)
    }
    print("== end ==")
}

/*
== Start ==
next(0)
0
== end ==
== Start ==
next(1)
1
== end ==
== Start ==
completed
== end ==
*/
