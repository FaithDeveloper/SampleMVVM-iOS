# iOS MVVM 패턴 RxSwift로 적용해보자

어떤 패턴이 모바일 앱을 개발하는데 도움을 줄 수 있을지 많은 연구가 나오고 있습니다. Android 는 MVP 패턴에 대해서 언급되다가 함수형 언어인 코틀린이 Android 공식언어로 되면서 MVVM 패턴으로 전환해야한다는 목소리가 나오고 있습니다. iOS 의 Swift 언어 또한 함수형 언어이며 MVVM 패턴에 대해서 언급하고 있습니다. 그렇다면 MVVM 패턴이 무엇이기에 그렇게 언급이 되고 있는 것일까요?

# MVVM 이란?

[MVVM](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel) 패턴은 Model - View- View Model 로 구성된 소트트웨어 아키테처 패턴(softsare architectural pattern)입니다.

## View

Model - View- Controller (MVC), Model - View - Presenter (MVP) 의 View 의 역할과 동일합니다. 사용자에게 레이아웃, 구조, 보여지는 부분인 view 에 대한 직접적인 접근을 담당합니다.  

<br/>

## View Model

View Model 은 공통 속성 및 명령을 표시하는 뷰의 추상화 입니다. 뷰와 데이터 바인더 사이의 통신을 조정합니다. MVP 패턴과 차이점은 MVP 패턴은 Presenter 가 View 에 대한 참조를 갖고 있으나 MVVP 패턴의 View Model은 View 에 대한 참조를 갖고 있지 않습니다. View 가 View Model 에 대해서 직접적인 Bind 되어 있어 View Model의 변화에 대한 업데이트를 즉각적으로 받게 됩니다.옵저버 패턴으로 View Model가 상태 변화를 관찰하는 관찰 대상, View는 옵저버로 구성 하였다는 것으로 이해하시면 쉬울 것입니다.

> **옵서버 패턴**(observer pattern)
> [옵서버 패턴](https://ko.wikipedia.org/wiki/%EC%98%B5%EC%84%9C%EB%B2%84_%ED%8C%A8%ED%84%B4)은 상태 변화를 관찰하는 관찰자들, 즉 옵저버들의 목록을 객체에 등록하여 상태 변화가 있을 때마다 메서드등을 통해 객체가 직접 목록의 각 옵저버에게 통지하도록 하는 디자인 패턴이다.    - *위키백과*

<br/>

## Model

Model은 도메인 매소드를 참조하고 있습니다. 앱 데이터 및 상태에 대한 비지니스 로직을 수행합니다.  

<br/>

# RxSwift 로 MVVM 패턴 적용하기

MVVM 패턴을 어떻게 소스 코드에 녹혀넣을 수 있을까요? 저는 RxSwift 을 활용하여 MVVM 패턴을 구현하였습니다.

RxSwift 에 대한 내용은 [RxJava]()을 참고하시면 이해하는데 도움이 될거 같습니다.

<br/>

## 시나리오

RxSwift을 활용하여 MVVM 패턴 사용 시나리오를 공유하겠습니다.

```
1. 유저는 '시작' 버튼 클릭을 통하여 값의 변화를 확인합니다.
2. 값의 변화에 따라 사용자에게 색이 변화하는 것을 보여줍니다.
```

간단히 클릭에 대한 변화를 보여주는 소스 입니다. 

<br/>

### RxSwift Pod Install

------

Xcode 에서 RxSwift을 사용하기 위해서는 우선 imort RxSwift을 해야합니다. 

Pod을 통해 RxSwift 적용 방법은 Podfile 의 다음과 같이 적용합니다.

```swift
  use_frameworks!

  # Pods for SampleMVVM

  pod 'RxSwift', '~> 4.0'
  pod 'RxCocoa', '~> 4.0'
```

<br/>

### View-Model

------

우선 View-Model 을 구성하겠습니다. 시나리오를 보면 값의 변화에 따라서 사용자에게 다른 UI을 보여주게 됩니다. 따라서 값이라는 기준이 있으며 그 값이 변화 되었을 때를 이벤트로 받아서 UI 변경이 되어야합니다. RxSwift 을 활용하여 값을 Variable<Int> 로 대상을 정했습니다. 

<br/>

**RxModelView.swift**

```swift
var count = Variable<Int>(0)

func autoPlus(){
   DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
   let cnt = self.count.value
   if cnt < 3{
     print("count = \(cnt)")
     self.count.value = self.model.AddCount(value: cnt)
     self.autoPlus()
    }else{
     self.count.value = 0
    }
  }
}
```



**View Model**
Variable 로 count 라는 변수를 만들었으며 autoPlus() 에서 count 값을 변경하고 있습니다.

<br/>

### View

------

Variable<Int> 의 변화에 따른 이벤트는 Obserable 로 설정할 수 있습니다.  Obserable을 구현 하는 방식은 ViewModel에 설정한 Variable<Int> 변수인 count 값을 가져와 asObservable 함수를 활용하여 Obserable을 만들고 subscribe 을 통하여 값 변화에 따른 이벤트를 비동기처리합니다.

**RxViewController.swift**

```swift
let viewModel = RxViewModel()

@IBAction func actionPlay(_ sender: Any) {
        viewModel.autoPlus()
}

override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = viewModel.count.asObservable().subscribe({ (count) in
            if let cnt = count.element{
                if cnt < 1 {
                    self.viewTarget.backgroundColor = UIColor.gray
                }else if cnt < 2 {
                    self.viewTarget.backgroundColor = UIColor.red
                }else if cnt < 3 {
                    self.viewTarget.backgroundColor = UIColor.yellow
                }else {
                    self.viewTarget.backgroundColor = UIColor.green
                }
                self.txtCountValue.text = "\(cnt)"
            }
            }).disposed(by: bag)
}
```



**View**
viewDidLoad() 에서는 viewModel()에 선언된 `Variable` 데이터를 `Observe` 하고 있습니다. 

viewModel.count 은 Variable<Int>  로 viewModel.count 의 값이 변경 될 때마다 `subscribe` 의 onNext 로 데이터가 넘어오게 됩니다. 

```
Variable<Int>.asObservable().subscribe(onNext, onError, onCompleted, onDisposed)
```

<br/>

### Model

------

비지니스 로직으로 단순히 값을 증가된 값을 넘겨주고 있습니다. 예제에서는 REST 로 서버통신을 하고 있지 않기에 Model() 쪽에 간단한 메소드로 구성했으나 만약 REST 통신을 할 경우 Model 쪽에 구현하면 됩니다.

```swift
class Model {
    func AddCount(value: Int) -> Int{
        return value + 1
    }
}
```

<br/>

# 위젯을 활용한 Rx

RxSwift 로 Variable<> 뿐만 아니라 기본적인 위젯에서도 적용할 수 있습니다.

```
_textField.rx.text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind { (input) in
                 // Todo..
            }.disposed(by: bag)
```

TextField 타입을 갖은 _textField 을 Obserable로 만들어 0.3초 마다 체크하여 변화가 있는지 체크 할 수 있습니다. 글자 수 변경에 따른 변화는 .bind 을 통하여 전달되어 .bind{}  에서 이벤트 처리를 할 수 있습니다. .disposed는 `DisposeBag ` 을 구성한 것으로 옵서버블에서 만드는 이벤트 스트림과 필요한 리소스를 관리할 수 있게 설정합니다.

<br/>

# 정리

간략하게 Swift 에서 Rx을 사용하는 방법에 대해서 정리했습니다. 실제 프로젝트에서 Rx을 활용하여 MVVM 패턴을 적용했을 때에 유지보수 부분과 함께 비동기 처리 시 안정성 있게 동작하는 것을 경험하였습니다. MVVM 패턴을 활용하여 다양하고 안정성 있는 프로젝트 만들 수 있기를 기대합니다.
