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
import Combine

/*:
 # Disposables
 */
// Disposable은 파라미터로 클로저를 전달하면 observerble과 관련된 모든 리소스가 제거된 후 호출 됨

Observable.from([1, 2, 3])
    .subscribe(onNext: { elem in
        print("Next", elem)
    },onError: { error in
        print("Error", error)
    }, onCompleted: {
        print("Completed")
    }, onDisposed: {
        print("Disposed")
    })

/*
Next 1
Next 2
Next 3
Completed
Disposed
*/

Observable.from([1, 2, 3])
    .subscribe{
        print($0)
    }

/*
next(1)
next(2)
next(3)
completed
*/
// Completed 다음에 completed가 출력되지 않은 형태
// Disposed은 observable이 전달하는 이벤트가 아님



let subscription1 = Observable.from([1, 2, 3])
    .subscribe(onNext: { elem in
        print("Next", elem)
    }, onError: { error in
        print("Error", error)
    }, onCompleted: {
        print("Completed")
    }, onDisposed: {
        print("Disposed")
    })

subscription1.dispose() // 리소스 해지

var bag = DisposeBag() // 리소스 해지(위에 방법보다 권고)
               
Observable.from([1, 2, 3])
    .subscribe{
        print($0)
    }.disposed(by: bag) // 변수 bag이 해지되는 시점에 disposeBag이 해지됨
// 원하는 시점에 해지
bag = DisposeBag() // 새로운 disposeBag을 만들면 이전에 있던 disposBag이 해지됨



// 실행취소
let subscription2 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .subscribe(onNext: { elem in
        print("Next", elem)
    }, onError: { error in
        print("Error", error)
    }, onCompleted: {
        print("Completed")
    }, onDisposed: {
        print("Disposed")
    })

/*
Next 0
Next 1
Next 2
Next 3
Next 4
*/
// 1씩 증가하는 정수를 1초 간격으로 방출. 무한정 반출. 여기서 사용하는 메소드가 disposed 메소드

DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    subscription2.dispose()
}

/*
Next 0
Next 1
Next 2
Disposed
*/
// 2까지 실행된 후 실행 취소됨
