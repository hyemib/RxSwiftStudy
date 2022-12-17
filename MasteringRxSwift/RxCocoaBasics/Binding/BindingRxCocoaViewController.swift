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
import RxCocoa

class BindingRxCocoaViewController: UIViewController {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var valueField: UITextField!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        valueLabel.text = ""
        valueField.becomeFirstResponder()
        
        
//        valueField.rx.text
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] str in
//                self?.valueLabel.text = str
//            })
//            .disposed(by: disposeBag)
        
        valueField.rx.text // RxCocoa가 확장한 text 속성이 입력한 값을 담아서 next 이벤트를 방출.
            .bind(to: valueLabel.rx.text)  // Observable이 방출한 이벤트를 Observer에게 전달.
            .disposed(by: disposeBag)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        valueField.resignFirstResponder()
    }
}


// Binding에는 데이터 생성자와 데이터 소비자가 있다.
 // 생성자는 Observable. 소비자는 UI Component
 // 생성자가 생성한 데이터는 소비자에게 전달되고 소비자는 적절한 방식으로 데이터를 소비.

 // Binder는 Binding에서 사용하는 특별한 Observer, 데이터 소비자
 // Observer이므로 Binder로 새로운 값을 전달할 수 있지만 Observable이 아니기 때문에 구독자를 추가하는 것은 불가능.
 // Binder는 에러이벤트를 받지 않음. Binding이 성공하면 UI가 업데이트 됨.
 // Binder는 스케줄러를 직접 지정하는 경우를 제외하고 메인 쓰레드에서 Binding을 실행.
