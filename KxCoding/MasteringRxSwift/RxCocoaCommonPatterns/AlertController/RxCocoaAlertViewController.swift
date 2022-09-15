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

class RxCocoaAlertViewController: UIViewController {
    
    let bag = DisposeBag()
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var oneActionAlertButton: UIButton!
    
    @IBOutlet weak var twoActionsAlertButton: UIButton!
    
    @IBOutlet weak var actionSheetButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 버튼을 탭하면 경고창 표시
        oneActionAlertButton.rx.tap
            .flatMap { [unowned self] in self.info(title: "Current Color", message: self.colorView.backgroundColor?.rgbHexString)}
            .subscribe(onNext: { [unowned self] ActionType in
                switch ActionType {
                case .ok :
                    print(self.colorView.backgroundColor?.rgbHexString ?? "")
                default :
                    break
                }
            })
            .disposed(by: bag)
        
        twoActionsAlertButton.rx.tap
            .flatMap { [unowned self] in self.alert(title: "Reset Color", message: "Reset to black color?") }
            .subscribe(onNext: { [unowned self] actionType in
                switch actionType {
                case .ok :
                    self.colorView.backgroundColor = UIColor.black
                default :
                    break
                }
            })
            .disposed(by: bag)
        
        actionSheetButton.rx.tap
            .flatMap { [unowned self] in
                self.colorActionSheet(colors: MaterialBlue.allColors, title: "Change Color", message: "Choose one")
            }
            .subscribe(onNext: { [unowned self] color in
                self.colorView.backgroundColor = color
            })
            .disposed(by: bag)
    }
}

enum ActionType {
    case ok
    case cancel
}

extension UIViewController {
    func info(title: String, message: String? = nil) ->
    Observable<ActionType> {
        return Observable.create { [weak self] observer in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                // cocoaTouch와 다른점 2. 액션과 관련된 기능을 구현하는 것이 아니라 이벤트를 전달하도록 구현
                observer.onNext(.ok) // 경고창은 액션을 선택한 후 사라지기 때문에 또다를 next 이벤트를 전달하지 않음. 바로 completed 이벤트를 전달하고 종료.
                observer.onCompleted()
            }
            alert.addAction(okAction)
            self?.present(alert, animated: true, completion: nil)
        
            // cocoaTouch와 다른점 1. 생성시점에 클로저를 전달하고 AlertController를 dismiss
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // 경고창에 액션 추가
    func alert(title: String, message: String? = nil) -> Observable<ActionType> {
        return Observable.create { [weak self] observer in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
               
                observer.onNext(.ok)
                observer.onCompleted()
            }
            alert.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                observer.onNext(.cancel)
                observer.onCompleted()
            }
            alert.addAction(cancelAction)
            
            self?.present(alert, animated: true, completion: nil)
        
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func colorActionSheet(colors: [UIColor], title: String, message: String? = nil) -> Observable<UIColor> {
        return Observable.create { [weak self] observer in
            let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            for color in colors {
                let colorAction = UIAlertAction(title: color.rgbHexString, style: .default) { _ in
                    observer.onNext(color)
                    observer.onCompleted()
                }
                actionSheet.addAction(colorAction)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                observer.onCompleted()
            }
            actionSheet.addAction(cancelAction)
            
            self?.present(actionSheet, animated: true, completion: nil)
        
            return Disposables.create {
                actionSheet.dismiss(animated: true, completion: nil)
            }
        }
    }
}

