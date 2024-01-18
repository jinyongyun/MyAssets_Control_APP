# MyAssets_Control_APP
SwiftUI 활용 자산관리 앱 만들기!
저번에 만든 넷플릭스 풍 영화 추천 앱 혹시 기억이 나는지 모르겠다.

그때 우리는 storyboard를 사용하지 않고, 오직 코드로만 앱을 만들었다. 게다가 previewer로 즉시 UI의 변동사항을 확인할 수도 있었다.

이처럼 앱의 UI를 만드는 방법은 storyboard만 있는 것이 아니다!

- storyboard
- 코드로만…
- SwiftUI

애플은 WWDC 2019에서 SwiftUI를 처음 소개했는데, 발표 당시

**[The shortest path to a great app. The shortest path to a great UI]** 라고 소개한 바 있다.

최단 경로로 앱을 구축할 수 있다니 가슴이 두근거리지 않는가??

또한 SwiftUI는 완전히 새로운 프레임워크이지만, 동시에 친숙하다고 표현했다.

그 이유는 UI 프레임워크에서 기대할 수 있는 모든 구성요소를 포함하고 있기 때문이다!

버튼, 텍스트와 같은 컨트롤이 있고

스택, 리스트와 같은 레이아웃 컨테이너도 존재한다.

사실 SwiftUI를 이용해 구현한 앱과, 기존 UIKit을 이용해 구현한 앱을 소비자 입장에서 구분하기는 굉장히 어렵다. 그럼 과연 어디에서 차이가 나느냐…바로 **코드와 앱의 성능**면에서 큰 차이가 발생한다.

SwiftUI는 우리가 익숙한 명령형 프로그래밍 방식이 아니라 **선언형 프로그래밍 방식**으로 코드를 작성하게 된다.

예를 들어 흰 배경 view에 ‘Hello, world!’라고 쓰인 라벨과 그 아래 START 버튼을 넣어 구현한다고 해보자.

```swift
 //명령형
let view = UIView()
view.backgroundColor = .white

let label = UILabel()
label.text = "Hello, world!"
label.font = .preferredFont(forTextStyle: .title1)

let button = UIButton()
button.setTitle("START", for: .normal)
button.addTarget(self, action: #selector(action),
for: .touchUpInside)

view.addSubview(label)
iew.addSubview(button)

//set autolayout constraints
```

```swift
//선언형은 이렇게!
struct ContentView: View {
  var body: some View {
    VStack {
       Text("Hello, world!")
              .font(.title)
       Button("START", action: {})
      } 
   }
}
```

**우리가 만들려는 뷰가 무엇인지 구조체 형태로 바로 [선언]하고 있다!**

아래에서 SwiftUI에 대해 더 자세하게 알아보자.

## SwiftUI 알아보기

SwiftUI는 iOS, TvOS, WatchOS 등 애플이 제공하는 모든 플랫폼에서 앱의 사용자 인터페이스와 동작을 선언하게 된다. 

SwfitUI는 앱의 사용자 인터페이스를 선언하기 위한 뷰, 컨트롤, 레이아웃을 구조체 형태로 제공하게 된다.

이 프레임워크는 탭이나 제스처, 기타 유형의 입력을 앱에 전달하기 위한 ***이벤트 핸들러***와 앱 모델에서 사용자가 보고 상호작용 할 ***뷰***, 컨트롤에 대한 데이터 흐름을 관리하는 도구를 제공하게 된다.

SwiftUI는 위에서 봤던 것처럼, 선언형 코드를 통해 뷰를 표현하게 된다.

여기서 뷰라고 하는 건, 우리가 UIKit에서 봤던 뷰와는 조금 다르다.

UIKit의 뷰는 UI 컴포넌트 중에 하나일 뿐이지만, SwiftUI에서의 뷰는 **function of state**

즉 ***상태의 함수***라고 표현하고 있다.

이게 무슨 말이냐면, 표현하고자 하는 뷰 → UI의 속성은 상태로 표현되고

이러한 상태를 함수 형태의 인자로 전달을 하면 세세한 건 SwiftUI 프레임워크가 알아서 해석해서 뷰로 표현할거다~라는 말이다.

SwiftUI에서의 뷰는 데이터 흐름의 일원화와 그러한 데이터를 뿌려주는 뷰의 역할은 무엇일까-를 고민하다 만들어졌다고 한다. 따라서 데이터 흐름 기준으로 여러 PropertyWrapper라는 개념을 도입하였는데

여기서 데이터 흐름이 뷰의 내부냐 외부냐에 따라

- @State : View-local  &&  Value-type && Framework-Managed
- @ObservableObject : External  &&  Reference type && Developer-Managed

State와 ObservableObject로 나눌 수 있다. State는 값 타입이고 ObservableObject는 참조타입이다. 또 State로 선언할 경우 프레임워크 자체적으로 관리해주는 반면, ObservableObject는 개발자가 직접 선언체를 관리해줘야한다.

이렇게 글로만 나열하면 감이 안잡힐 것 같으니, 데이터 플로우를 도식화해서 큰 그림을 살펴보도록 하자.

![Untitled (Draft)-4 2](https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/9f9a2c97-f78c-4812-8d01-0387e12b8b08)


외부 디펜던시가 없는 단일 뷰라고 했을 때, 

발생한 어떤 이벤트는 user interaction을 통한 어떤 액션이 있을 것이다.

이렇게 user interaction을 통한 Action이 발생하면, 

이런 Action을 통한 변화는 State 상태를 변화시킬 것이고, 그에 대한 update가 뷰에 전달된다.

최종적으로 update에 따라서 뷰는 새롭게 Rendering하고 유저에게 보여진다.

이젠 SwiftUI로 간단한 화면을 만들어보자, 만들면서 조금씩 SwiftUI 사용법에 익숙해져 가보자

SwiftUI는 사용자 인터페이스 디자인에 대한 선언적 접근방식을 제공한다-라고 말했다.

기존의 명령적 접근방식을 사용하면 컨트롤러 코드가 뷰를 인스턴스화 하고 레이아웃하고 구성할 뿐만 아니라 

조건이 변경됨에 따라 지속적으로 업데이트 해야 하는 부담이 있다.

대조적으로 선언적 접근방식에서는 인터페이스가 원하는 레이아웃을 미러링하는 계층구조에서 뷰를 선언하고, 사용자 인터페이스에 대한 간단한 설명을 만들게 된다. 그런 다음 SwiftUI는 사용자 입력, 상태 변경과 같은 이벤트에 대한 응답으로 이러한 뷰를 그리고 업데이트 하는 걸 관리하게 된다. 

SwiftUI는 사용자 인터페이스에서 뷰를 정의하고 구성하기 위한 도구를 제공한다.

구체적으로 이게 어떻게 표현 되는지 코드로 한 번 살펴보자.
<img width="732" alt="스크린샷 2024-01-14 오전 11 51 51" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/7ee7fe24-69c7-47a3-b113-3fe1f870aeb9">



프로젝트를 구성하는데, 드디어 인터페이스로 SwiftUI를 선택하게 되었다.

<img width="1393" alt="스크린샷 2024-01-14 오전 11 53 00" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/e9bfced7-d57b-4682-b22b-3f9db81631c0">
<img width="691" alt="스크린샷 2024-01-14 오전 11 54 10" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/9f3f4c34-7ea1-4d2f-a6b3-1fdf89bc16a6">


기본적으로 ContentView가 나오는데, 우리는 여기서 하나 더 만들어보려고 한다.

MyView라는 뷰를 하나 더 만들어줬다. 새 파일로 SwiftUI View를 선택해서 만들면 

View 프로토콜을 준수하는 struct를 정의해서 커스텀 뷰를 선언할 수 있다.

다른 Swift Protocol과 마찬가지로 View protocol은 기능에 대한 청사진을 제공하는데

이 경우 SwiftUI가 화면에 그리는 요소의 동작을 나타내게 된다.

프로토콜에는 뷰가 충족해야만 하는 요구사항과 프로토콜이 제공하는 기능이 모두 포함된다.

요구사항을 충족한 다음에 사용자 정의 뷰를 뷰 heirarchitecture에 삽입해서 앱 사용자 인터페이스의 일부가 되도록 할 수 있다.

먼저 이 뷰 프로토콜의 필수사항은 body라는 걸 정의해야한다.

SwiftUI의 뷰는 뷰를 업데이트 할 때마다 바디 속성의 값을 읽게 되는데,

업데이트 되는 뷰는 일반적으로 사용자의 입력 또는 시스템 이벤트에 대한 응답으로 뷰 life cycle 동안 반복적으로 발생할 수 있다. 

그래서 뷰가 반환하는 값은 곧 SwiftUI가 화면에 그리는 요소가 된다.

view의 body 속성에 따라 컨텐츠를 추가를 해서 뷰의 모양을 설명해보겠다.

SwiftUI가 제공하는 기본 뷰와 다른 곳에서 정의한 사용자 정의 뷰에서 바디를 구성할 수 있다.

기본으로 바디 내에 나타난 Text나, 토글, ProgressView와 같은 특정 종류의 컨텐츠 또는 컨트롤 이런 것에 관한 뷰 외에도 다른 뷰를 정렬하는데 사용하는 기본 뷰도 존재한다.

한가지 예로 VStack이라는 것을 사용해서 두 개의 컴포넌츠를 쌓을 수 있다.

```swift
//  MyView.swift
//  SwiftUIPractice
//
//  Created by jinyong yun on 1/14/24.
//

import SwiftUI

struct MyView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
            Text("만나서 반가워요!")
          }
        }
}

#Preview {
    MyView()
}
```
<img width="475" alt="스크린샷 2024-01-14 오후 3 09 58" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/d2fdf8f4-384d-4e1a-a8df-4a08507941fb">


이렇게 두 개의 문자열이 세로로 쌓이는 것을 볼 수 있다. 

둘 다 본문 글꼴 값으로 렌더링 된다.

이렇게 VStack과 같이 여러 서브뷰를 사용하는 뷰는 일반적으로 뷰 빌더 속성으로 표시된 클로저를 사용해서 나타나게 된다.

위에서처럼 VStack안에 클로저가 있고 클로저 내부에서 구현하게 되는 것이다!

이렇게 하면 VStack외에도 다양하게 다중으로 클로저 작성이 가능하다.

단순하게 입력하고 싶은 뷰를 연속해서 나열만 하면 된다. VStack을 연속으로 정의할 수도 있고, 또다른 VStack으로 묶을 수도 있다.

이렇게 뷰 바디에서 뷰를 구성하려면 ViewModifier를 적용할 수 있다.

modifier는 특정 뷰에서 호출되는 메서드라고 보면 된다.

메서드이기 때문에 뷰 계층구조에서 기존의 뷰를 대체하여 변경된 새로운 뷰를 반환한다.

SwiftUI는 이러한 목적을 위해 많은 메서드 set으로 뷰 프로토콜을 확장하게 됐는데…

뷰 프로토콜을 준수하는 모든 요소들은, 어떤 방식으로든 뷰의 동작을 변경하는 이런 메서드에 접근이 가능하다.

예를 들어서 폰트를 적용해서 텍스트 뷰에 글꼴을 적용할 수 있는데

위의 예시에서 우리가 만약 Hello, World! 라는 텍스트 컴포넌트의 폰트를 바꾸고 싶다면, .font modifier를 사용해서 바꿀 수 있다.

```swift
//  MyView.swift
//  SwiftUIPractice
//
//  Created by jinyong yun on 1/14/24.
//

import SwiftUI

struct MyView: View {
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .font(.title)
            Text("만나서 반가워요!")
        }
    }
}

#Preview {
    MyView()
}
```
<img width="504" alt="스크린샷 2024-01-14 오후 3 18 03" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/f982e69c-5ee5-4f23-8857-4db5d7732a97">



또는 이 뷰 자체에 속성을 추가해서 입력값을 가질 수도 있는데

뷰 구조체에 helloFont라는 상수 프로퍼티를 하나 추가하고, .font modifier에 인자로 해당 helloFont를 넣어준다. 이렇게 입력값이 변경되면 SwiftUI는 이제 변경사항을 감지해서 인터페이스에 영향을 받는 부분만 다시 그리게 된다. 전체 뷰를 초기화 할수도 있지만 이건 SwiftUI가 알아서 관리하는 영역이다.

그래서 뷰 안에 init 메서드를 넣어서 굳이 초기화를 복잡하게 구성할 필요도 없다는 거다!!

어차피 SwiftUI가 언제든지 초기화를 하면서 관리할테니까!!! (Not my business)

또 뭐가 가능할까

우리가 만든 커스텀 뷰를 다른 뷰에 추가하고 통합할 수 있다.

우리가 앞에서 만든 커스텀 뷰 MyView처럼 뷰를 정의한 후에

기본 뷰로 나왔던 ContentView와 통합할 수도 있다는 것이다!

뷰를 통합하고 싶은 계층의 지점에서 커스텀 뷰를 선언하면 되는데 

```swift
//
//  ContentView.swift
//  SwiftUIPractice
//
//  Created by jinyong yun on 1/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MyView(helloFont: .title)
    }
}

#Preview {
    ContentView()
}
```
<img width="504" alt="스크린샷 2024-01-14 오후 3 18 03" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/e0ce48f8-bae4-4d02-8496-35aa496d3880">


다음과 같이 rootView인 ContentView에 MyView를 선언하면 오른쪽 프리뷰에 MyView의 뷰가 나타나는 것을 볼 수 있다. 정확히는 MyView가 감싸지는 형태로 표현된것이다.

## SwiftUI 더 자세히 알아보기

**SwiftUI를 사용하고 있지만 기존의 UIKit 컴포넌트를 활용하고 싶을 때**

또는 반대로

**UIKit을 사용하고 있는데 앞으로는 SwiftUI로 개발하고 싶을 때** 

어떻게 해야할까?

기존의 앱을 모두 SwiftUI로 리팩토링 하는 건 너무 코스트가 크다. (상상도 하기 싫다)

그렇다고 시작을 SwiftUI를 안했다고 계속 못하는 것도 억울하다…

분명히 SwiftUI는 UIKit을 감싸고 있어 호환 가능하다고 위에서 말했다.

SwiftUI는 모든 애플 플랫폼의 기존 UI Framework와 원활하게 작동한다.

예를 들어서 UIKit의 뷰와 뷰 컨트롤러를 위에서 처럼 SwiftUI 뷰 안에 배치할 수도 있고

그 반대의 경우도 가능하다.(이게 어떻게…?!)

그래 당연히 궁금할 것이다. 반대의 경우는 대체 어떻게 작동하는가?!

지금부터 그 내용을 파헤쳐보자!

위에서도 같은 질문을 했었다. 혹시 예전에 만들었던 [넷플릭스 풍 영화 추천 앱]이 기억나는가?

우리는 이번에 해당 앱을 SwiftUI로 감싸고 연결해주는 작업을 해 볼 것이다.

우리는 기존의 루트 뷰, HomeViewController 앞에 새로운 SwiftUI로 만든 루트 뷰를 만들어서

그 뷰 안에 리스트를 만들어서, 그 리스트의 어떤 셀을 선택하면 우리가 기존에 만들었던 HomeViewController가 나오도록 할 것이다. 그리고 이 HomeViewController에서 특정 화면을 선택했을 때 해당 영화 컨텐츠를 나타내는 상세 화면이 뜨도록 할 건데, 이 상세 화면은 SwiftUI로 제작할 것이다.

정리하자면 

새로운 루트 뷰(SwiftUI) - 기존 HomeViewController(UIKit) - 영화 상세화면(SwiftUI)

```swift
////SwiftUI를 활용한 미리보기
struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewControllerRepresentable().edgesIgnoringSafeArea(.all)
    }
}

struct HomeViewControllerRepresentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) ->
        UIViewController {
            let layout = UICollectionViewLayout()
            let homeViewController = HomeViewController(collectionViewLayout: layout)
            return UINavigationController(rootViewController: homeViewController)
        }

        func updateUIViewController(_ uiViewController:
                                    UIViewController, context: Context) {}

        typealias UIViewControllerType = UIViewController
    }
```

그때 PreviewProvider를 사용하기 위해, UIViewControllerRepresentable 타입의 Container 구조체를 HomeViewController_Previews 구조체 안에 넣어놓았다(그때 이 프로젝트의 유일한 SwiftUI 부분이었다.)

이 Container 구조체를 밖으로 빼주고 이름을 HomeViewControllerRepresentable로 설정한다.

그리고 이제 새로운 뷰 컨트롤러를 만들기 위한, SwiftUI 뷰를 만들 것이다.

이제는 파일 형식으로 SwiftUI View를 표시해야 한다는 것에 주의해라!! (한편으론 뿌듯하기도 했다)
<img width="1792" alt="스크린샷 2024-01-14 오후 4 56 23" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/c3bf1501-a28f-404e-a38c-ae7ca53efcd4">



```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {return}
        self.window = UIWindow(windowScene: windowScene)
        
        let layout = UICollectionViewFlowLayout()
        let homeViewController = HomeViewController(collectionViewLayout: layout)
        let rootNavigationController = UINavigationController(rootViewController: homeViewController)
        
        self.window?.rootViewController = rootNavigationController
        self.window?.makeKeyAndVisible()
    }
```

그리고 원래 우리는 SceneDelegate에서 homeViewController를 UINavigationController로 감싸서 rootNavigationController를 설정했는데, 이걸 전부 삭제해주고

```swift
import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = ContentView()
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView) //SwiftUI에서 제공하는 뷰를 루트 뷰로 두기 위해!
            self.window = window
            window.makeKeyAndVisible()
        }
    }
```

이렇게 바꿔준다.

만들어줬던 ContentView로 이동해서. (지금은 빈 공백 뷰겠지만…끝은 창대하리라)

NavigationView를 넣어줘라. 이 위에 리스트를 만들려고 하는데, 흔히 우리가 지금까지 만들어왔던 UITableView와 유사하다.

List를 적고, initializing 하기 위해 여기 안에 어떠한 데이터 또는 어떠한 low value가 들어갈지를 array 형태로 적어줘야 한다. 

```swift
//
//  ContentView.swift
//  MovieRecommand
//
//  Created by jinyong yun on 1/14/24.
//

import SwiftUI

struct ContentView: View {
    let titles = ["NetFlix Sample App"] //이러한 타이틀을 갖는 row 만들기
    var body: some View {
        NavigationView {
            List(titles, id: \.self) { //title 배열 갖고, id는 sequence id 가져오도록!
                let netflixVC = HomeViewControllerRepresentable()
                    .navigationBarHidden(true) //리스트의 네비게이션 바가 뜨지 않도록
                    .edgesIgnoringSafeArea(.all) //전체화면 뜨도록
                NavigationLink($0, destination: netflixVC) //기존에 push show와 같은 역할
            }
            .navigationTitle("SwiftUI to UIKit")
        }
    }
}

#Preview {
    ContentView()
}
```


https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/11b3f249-5f5d-4e2c-8782-8f133990010a



아주 간단한 방식으로 잘 동작하는 것을 알 수 있다.

원래 테이블 뷰로 만들려면 Delegate와 DataSource를 활용했어야 하는데,

아주 간단한 방식으로 List 내에 배열을 집어넣었더니 나타났다!!(신세게)

이렇게 SwiftUI에서 기존의 UIKit 기반의 뷰로 연결하는 것을 확인할 수 있다.

이제 두 번째로 영화 포스터를 누르면 상세 화면으로 넘어가도록 해 볼 것이다.

해당하는 상세페이지를 SwiftUI로 만들어보자.

ContentDetailView라는 SwiftUI View를 만들고, PropertyWrapper를 사용해서 

이 뷰에 외부 자극 없이 내부의 어떤 상태가 어떻게 변화될 것인지를 표시해 볼 것이다.

```swift
//
//  ContentDetailView.swift
//  MovieRecommand
//
//  Created by jinyong yun on 1/15/24.
//

import SwiftUI

struct ContentDetailView: View {
    
    /* Item은 Content 구조체에서 쓰였던 인스턴스
     struct Item: Decodable {
         let description: String
         let imageName: String
         
         var image: UIImage {
             return UIImage(named: imageName) ?? UIImage()
             //바로 imageName을 이미지로 리턴
         }
     */
    
    @State var item: Item? // item이라는 걸로 설정될 것이다!
    
    var body: some View {
        VStack {
            if let item = item { //아이템 있다면
                Image(uiImage: item.image)
                    .aspectRatio(contentMode: .fit)
                
                Text(item.description)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding()
                
            } else { // 아이템 없으면 흰색 바탕만...
                Color.white
            }
        }
    }
}

struct ContentDetailView_Previews:
    PreviewProvider {
    static var previews: some View {
        let item0 = Item(description: "흥미진진, 판타지, 애니메이션, 액션, 멀티캐스팅", imageName: "poster0") //일단 더미 데이터
        ContentDetailView(item: item0)
    }
}
```

밑에 프리뷰가 설정이 안되어있을땐 아마 프리뷰가 나오질 않을 것이다. 

원래는 Preview 매크로로 되어있었는데, 근본은 PreviewProvider고 또 필자는 이게 더 익숙해서 아예 이걸로 써버렸다.

<img width="1251" alt="스크린샷 2024-01-15 오후 6 42 27" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/a13f2e68-babc-4343-baeb-0d0b2e5cc9a6">


이렇게 간단한 상세 화면을 만들어보았다.

문제는 이 디테일 뷰를 어디서 띄우느냐

분명 우리는 기존의 HomeViewController에서 각 영화 포스터 뷰를 선택했을 때 뜨도록 하자고 했다.

HomeViewController 여기서 포스터를 클릭했을 때 작동하게 하려면 어디를 만져야 할까?

분명 우리는 Delegate를 통해서 정확히는 didSelectItemAt을 통해서 알 수 있을 것이다.

여기서 ContentDetailView로 넘어갈 수 있도록 해 줄 것이다.

```swift
// 셀 선택했을때
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionName = contents[indexPath.section].sectionName
        print("TEST: \(sectionName) 섹션의 \(indexPath.row + 1)번째 컨텐츠")
    }
```

원래 이렇게 써 있던 걸…

```swift
// 셀 선택했을때
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let isFirstSection = indexPath.section == 0
        let selectedItem = isFirstSection ? mainItem : contents[indexPath.section].contentItem[indexPath.row]
        
        let contentDetailView = ContentDetailView(item: selectedItem)
        
        let hostingVC = UIHostingController(rootView: contentDetailView)
        self.show(hostingVC, sender: nil)
    }
```

코드를 보면 가장 큰 섹션을 클릭했을 때는 상세 화면을 보여주지 않기로 해서

isFirstSection bool 상수를 만들었고

선택한 섹션이 이 첫번째 섹션이면 mainItem을 보여주고 아니면 선택한 섹션의 contentItem을 보여줄 것이다. 

그리고 UIHosting을 사용하면 UIViewController와 연결할 수 있는데(왜 우리 SceneDelegate에서도 같은 방식으로 rootViewController로 contentView를 설정했다.)

contentDetailView를 hostingVC에 연결하고 보여줬다.



https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/b7242d98-80c4-44fa-93d7-afd330930d3b



자 전체적인 기능을 영상으로 한 번 살펴보자!

## ContainerView에 대해서…

UIkit에서 반복되는 컨텐츠를 grouping하고 나타내는 방법들이 있었다.

ScrollView와 StackView를 결합하거나

테이블 뷰 또는 컬렉션 뷰를 이용해서 만들었다.

SwiftUI에서도 역시 뷰를 grouping하고 반복되는 다양한 데이터에 대한 컨테이너 뷰를 제공한다.

StackView, LazyStack뷰 Grid뷰와 같이 순수하게 레이아웃만 나타내는 항목도 있고

List나 form 처럼 우리가 기존에 배웠던 테이블 뷰나 컬렉션 뷰를 떠오르게 하는 것들도 있다.

(이런 녀석들은 레이아웃 뿐만 아니라, 데이터에 따른 상호작용을 제공한다!!)

이와 같이 SwiftUI에서도 여러가지 형태의 데이터를 grouping 해주는 뷰를 제공한다.

앱 사용자 인터페이스의 각 부분의 특성에 따라서 겉으로 사용자에게 보이는 모습은 같더라도

앱의 성능을 모두 고려해서, 가장 적합한 컨테이너 뷰를 선택하는 것이 아아주 중요하다!

가장 단순하게 두 개의 뷰를 나란히 배치하는 것부터

수백개의 요소로 복잡한 레이아웃을 만드는 것까지

다양하게 SwiftUI에서도 표현을 할 수 있다.

지금부터 하나씩 그 요소와 방법을 살펴보도록 하자!

[이미지 & 정보 출처 - developer.apple] https://developer.apple.com/documentation/swiftui/building-layouts-with-stack-views

### Stack 뷰

SwiftUI에서 사용할 수 있는 가장 기본적인 레이아웃 컨테이너이다.

스택을 사용해서 뷰 컬렉션을 수직 수평으로 그룹화하거나 쌓을 수 있다.

<img width="706" alt="스크린샷 2024-01-16 오후 5 28 58" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/8f831671-c8b2-4451-bde2-576ca507b985">


보면 HStack을 사용해서 중간 크기의 뷰를 수평으로 배치했고, 그리고 VStack을 사용해서 안에 있는 회색 뷰 두 개를 수직으로 배치했다.
또 ZStack을 사용해서 뷰를 겹쳐 놓을수도 있다.

그런 다음 모든 스택뷰를 결합해서 더 복잡한 레이아웃을 구성할 수 있을 것이다.

실제 왼쪽에 나온 사진 화면을 보면, Rachael과 그 밑에 Ceo 텍스트는 VStack으로 묶었고

이게 좌측에 정렬될 수 있게 우측에 보이지 않는 스페이서를 둬서 HStack으로 정렬한 것 같다.

그리고 아래 이미지 뷰와 흰색 뷰를 ZStack으로 결합해서 하나의 평면적인 뷰로 보이도록 레이아웃을 잡을 것 같다!

이러한 세 가지 종류의 스택은 정렬, 간격에 대한 속성, 뷰 modifier, spacer와 같은 뷰 등과 결합되어서 다양한  형태의 레이아웃을 표현할 수 있고, 굉장히 유연하게 표현할 수 있다.

다른 컨테이너 내부의 빌딩 블록으로 이런 스택 뷰를 많이 사용하는데

예를 들어 앞에서 만들었던 [넷플릭스 풍 영화 추천 앱]에 SwiftUI를 도입하는 과정에서 사용했던 List와 같은 경우에서도 이번 경우에는 바로 텍스트로 표현했지만, 안에 스택뷰를 삽입함으로써 더욱 다양한 레이아웃을 표현할 수 있다!

<img width="727" alt="스크린샷 2024-01-16 오후 5 40 44" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/cf1d6bef-d3e4-4b61-be5d-34800bafd558">


HStack은 뷰를 수평으로 배치하고, VStack은 뷰를 수직으로 배치하고, ZStack은 뷰를 겹치는 형태로 배치하는데(오버레이) 기본 매개변수로 초기화하면 스택뷰가 컨텐츠를 가운데 정렬한 다음, 그 안에 포함된 각 뷰 사이에 위에 그림처럼 약간의 간격을 자동적으로 설정하는데

ViewModifier, Spacer, DividerView 등을 사용해서 스택을 결합하고 

사용자 정의를 할 수 있다. 즉 이런 간격을 당연히 조정할 수 있단 얘기다.

### Stack, LazyStack

<img width="624" alt="스크린샷 2024-01-16 오후 5 47 24" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/0dfdda39-ac58-42d5-bd74-788d9f64a7ef">


HStack, VStack, LazyHStack 및 LazyVStack을 사용해서 뷰 또는 뷰 그룹을 반복할 수 있다.

마치 스크롤 뷰와 결합해서 사용했을 때의 모습을 볼 수 있다.

컨텐츠가 이렇게 컨테이너 범위를 넘어서서 확장될 수 있도록 스크롤 뷰 내부에 스택뷰를 배치한다.

사용자는 위의 그림처럼 VStack이나 HStack을 사용해서 수평, 수직 또는 양방향으로 동시에 스크롤을 할 수 있다.

StackView와 LazyView는 기능이 비슷하고 상호 교환 가능하다고 생각하기 쉽지만…

서로 다른 상황에서 각각의 장점이 존재한다!

스택 뷰는 자식 뷰를 한번에 모두 로드하기 때문에 레이아웃을 좀 빠르고 안정적으로 보이게 만들 수 있다.

왜냐면 시스템 단에서 로드를 할 때 하위 뷰의 크기와 모양을 전부 알고 있기 때문이다.

반면 레이지 스택 뷰는 성능을 위해 어느정도 레이아웃 정확성을 좀…포기한 느낌

Lazy의 경우에는 하위 뷰가 표시 될 때만 그 크기와 위치를 계산하게 된다.

그때 그때 Lazy하게 컨테이너 안에 들어왔을 때만 정확한 위치와 크기를 계산한다!

애플은 사용할 스택뷰 유형을 선택할 때, 기본적으로는 기본 스택을 사용하고

코드를 프로파일링 할 때, 성능 향상에 의미가 있는 경우에

예를 들면 자식 뷰가 너무 많을 경우 (즉 예측 불가능 할 정도로 많을 경우)에만 LazyStack을 사용하는 것을 추천하고 있다.

### Grid

<img width="514" alt="스크린샷 2024-01-16 오후 6 07 37" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/bdd4ca20-1279-4e60-9be6-5644467750c9">


뷰를 수평, 수직 동시에 배치하려면 LazyVGrid 또는 LazyHGrid를 사용하라고 공식문서에선 말한다.

Grid는 어떤 면에선 테이블 뷰와 비슷하고, 어떤 면에선 컬렉션 뷰와 비슷한데,

그리드는 이미지 갤러리처럼 정사각형의 컨테이너에 자연스럽게 표시되는 컨텐츠를 레이아웃 하는데 적합하다!

그리드는 더 큰 장치에 표시하기 위해서 사용자 인터페이스 레이아웃을 확장하기 위해 잘 사용된다.

예를 들어 아이폰에 있는 연락처 정보 디렉토리는 아이폰에 어떤 목록 또는 수집 스택에 적합할 수 있지만

아이패드나 맥과 같은 화면이 더 큰 디바이스로 확장할 땐 그리드 형태(컬렉션 뷰 형태)가 더 자연스러울 수 있다.

스택뷰와 마찬가지로 SwiftUI의 그리드 뷰는 본질적으로 스크롤 뷰를 자동적으로 포함하고 있지 않다.

자동적으로 컨테이너 범위를 컨텐츠가 넘어간다고 해서 저절로 스크롤링이 되지 않는다.

이는 그리드도 스택도 똑같다.

만약 넘어서는 범위에 컨텐츠가 더 있다면 먼저 스크롤 뷰를 설정하고, 그 안에 그리드나 스택뷰를 포함 해야만 스크롤이 가능하다.

### List

<img width="352" alt="스크린샷 2024-01-16 오후 6 13 06" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/0f588206-44ef-4d7d-b1cc-3c8c06ca532b">


익숙한 화면인 List

위에서 만들었던 넷플릭스 풍 (생략)에서도 HomeViewController 앞에 연결시켰다.

SwiftUI의 리스트 뷰는 개념적으로 LazyVStack이나 ScrollView의 조합과 유사해 보인다. 

하지만 기본적으로 포함된 항목 주변과 항목 사이에 플랫폼에 적합한 시각적 스타일이 포함된다.

예를 들면 디바이더 역할을 하는 선이라던지, 아니면 상세 페이지로 넘어가는 꺽쇠 표시(DiclosureIndicator)라던지…

리스트는 항목을 삽입하고 재정렬하고 제거하는 것과 같은 일반적인 작업에 대한 플랫폼에 적합한 상호작용도 지원한다. 예를 들면 목록 내부에 ForEach()에onDelete() 수정자를 추가하면 우리가 셀을 왼쪽으로 스와이프 했을 때 삭제할 수 있는 UiKit에선 delegate로 표현할 수 있던 것을 간단한 메서드로 나타나게 할 수 있다.

LazyHStack과 LazyVStack과 마찬가지로 SwiftUI 리스트 내부의 행도 말 그대로 lazy하게 로드된다.

리스트는 본질적으로 필요할 때 스크롤이 되고, 만약에 스크롤 액션을 주면 자동적으로 스크롤이 된다. 즉 스크롤 뷰 안에 리스트를 넣을 필요가 없다!

따라서 기존의 Stack과 Grid 보단 리스트가 스크롤이 필요한 레이아웃과 구성에는 더 적합한 것을 알 수 있다. 

### Form
<img width="382" alt="스크린샷 2024-01-16 오후 6 22 22" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/a799641a-a3c2-433f-9c34-be0e45200efb">

<img width="422" alt="스크린샷 2024-01-16 오후 6 23 22" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/beaefd69-cc9d-4757-96e9-69ac9dd61d82">


Form을 사용하면, 시스템 표준 컨트롤을 사용하는 데이터 입력 인터페이스, 기본 설정 화면을 구축하는데

굉장히 용이하다.

위에 보여진 두 설정화면 모두, 안에 내용은 같은 것을 알 수 있다.

SwiftUI의 Form을 사용하면 왼쪽 화면 별도, 오른쪽 화면 별도로 따로 표현할 필요가 없고

그저 Form 하나로 플랫폼에 적합한 방식으로 자동적으로 내용을 표시하게 할 수 있다.

그래서 Form 내부의 컨트롤 레이아웃은 플랫폼에 따라 다르게 보일 수 있다.

예를 들어서 맥 OS의 Preference 창의 Play notification sounds 같은 경우

오른쪽 그림과 같이 체크 박스로 표현되지만

아이폰이나 아이패드 같은 경우 왼쪽 그림의 스위치로 대체되는 것이다.

놀라운 점은 이를 코드로 뭘 주고 그래서 그런 것이 아니라

그저 Form만 이용하면 시스템 단에서 알아서 플랫폼을 추적해서 골라준다는 점이다. (외쳐 갓애플!)

## 구현 과정

## 기본 탭 바 구현하기

이제 본격적으로 자산 관리 앱을 SwiftUI을 통해서 만들어보려고 한다.

**프로젝트 이름은 MyAssets, 인터페이스는 SwiftUI로 설정한다.**

우리가 기존에 UIKit으로 시작을 했을 때, 뷰 컨트롤러와 스토리 보드가 기본으로 나타났던 것처럼

ContentView가 기본으로 표현되어있다.

우리는 다크모드와 라이트모드에 상관없이 항상 밝은 화면을 보여주는 자산관리앱을 만들려고 한다.

현재 xcode 버전이 15 이상이기 때문에, info.plist가 아마 생성은 됐을텐데

보여지지 않을 것이다. 앱 설정의 info에서 내용을 수정하면 그때서야 노출될텐데

그냥 여기서 수정하도록 하자!

<img width="666" alt="스크린샷 2024-01-16 오후 7 43 31" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/238587e6-0582-4d82-afc2-d94b595c02bc">


Appearance 특성을 추가해서 값을 Light로 넣어주면 밝은 화면을 강제할 수 있다.

ContentView로 가서

@State **private** **var** selection: Tab = .asset

state를 추가해준다. 여기서 Tab이 뭐냐고 할 수 있는데…당연히 원래 있진 않다. 지금부터 만들테니까

Tab을 열거형으로 만들어줄건데, 이녀석은 화면 하단에 표시될 탭을 의미한다.

우리는 총 네가지 종류를 만들어줄텐데, asset과 recommand, alert, setting을 만들어준다.

그 다음 바디 영역에 기존에 있던 디폴트 코드를 전부 지우고

탭뷰를 집어넣을 것이다. 아래의 코드와 같이 TabView에다 괄호를 붙이면 아마 selection과 content가 뜰텐데, selection에다 우리가 아까 만들어줬던 selection state를 넣어주고 content는 클로저로 비슷하게 구현해본다. 색상은 white로 그리고 탭 바 내부에 아이템으로는 달러 표시의 시스템 이미지와 텍스트는 자산으로 표현했다.

```swift
import SwiftUI

struct ContentView: View {
    
    @State private var selection: Tab = .asset
    
    enum Tab { //화면 하단에 표시될 탭
        case asset
        case recommand
        case alert
        case setting
    }
    
    var body: some View {
        TabView(selection: $selection) {
            Color.white
                .tabItem {
                    Image(systemName: "dollarsign.circle.fill")
                    Text("자산")
                }
            
        }
    }
}

#Preview {
    
    ContentView()
}
```

<img width="443" alt="스크린샷 2024-01-16 오후 8 49 55" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/68cee3ed-861a-4fad-8d85-131a28220b7d">


위에 프리뷰에서 제대로 탭 뷰가 나타난 것을 알 수 있다. 

이제 만들어준 Tab 열거형에 맞게 4개의 탭 바 아이콘을 만들어주도록 하자.

```swift
import SwiftUI

struct ContentView: View {
    
    @State private var selection: Tab = .asset
    
    enum Tab { //화면 하단에 표시될 탭
        case asset
        case recommand
        case alert
        case setting
    }
    
    var body: some View {
        TabView(selection: $selection) {
            Color.white
                .tabItem {
                    Image(systemName: "dollarsign.circle.fill")
                    Text("자산")
                }
                .tag(Tab.asset)
            Color.blue
                .edgesIgnoringSafeArea(.all)
                .tabItem {
                    Image(systemName: "hand.thumbsup.fill")
                    Text("추천")
                }
                .tag(Tab.recommand)
            Color.yellow
                .edgesIgnoringSafeArea(.all)
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("알림")
                }
                .tag(Tab.alert)
            Color.red
//영상에서 빠짐    .edgesIgnoringSafeArea(.all)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("설정")
                }
                .tag(Tab.setting)
            
        }
    }
}

#Preview {
    
    ContentView()
}
```
<img width="455" alt="스크린샷 2024-01-16 오후 10 24 36" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/a3c33b9f-34e2-4e47-aaea-d51c1c98314f">



https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/1fc37547-2cee-4c9c-bdcc-87696feae325





색 전환도 정상적으로 동작한다!

물론 모든 탭을 개발하기엔…너무 큰 프로젝트가 되어버리고

사이드 프로젝트의 한계로 자산 탭에서만 우리의 화면을 구현해 볼 것이다.

## Navigation 만들기

우리가 만들 자산 화면의 네비게이션 바는 좌측에 큰 타이틀로 ‘내 자산’이라고 쓰여있고

오른쪽에 둥근 버튼 내부에 플러스 마크와 텍스트 ‘자산추가’가 있어야한다.

보통의 네비게이션 바 같은 경우 제목이 가운데 있을텐데…당연히 커스텀이 필요해 보인다.

따라서 네비게이션 바 전체를 뷰 modifier를 통해 별도의 구조체로 만들어 준 다음에

우리가 이 네비게이션 바를 사용하려고 하는 뷰에 적용하므로써 이러한 뷰를 표현해보려고 한다.

네비게이션 바 구조체를 만들기 위해 NavigationBarWithButton 파일을 새로 만들어준다.

구조체 타입으로 View로 되어있을텐데, 우리는 ViewModifier로 설정해야한다.

ViewModifier 같은 경우, 뷰에 바로 NavigationBarWithButton을 함수처럼 적용해서 

이 ViewModifier가 표현하고자 하는 내용을 그대로 적용할 수 있다!

어쨌든 View를 ViewModifier로 수정하면 아마 에러가 날텐데, 구현해줘야 하는 프로토콜 메서드를 준수하지 않아서 발생한 것이다.

```swift
//
//  NavigationBarWithButton.swift
//  MyAssets
//
//  Created by jinyong yun on 1/16/24.
//

import SwiftUI

struct NavigationBarWithButton: ViewModifier {
    func body(content: Content) -> some View {
        return content
    }
    
}

struct NavigationBarWithButton_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            Color.gray.edgesIgnoringSafeArea(.all)
   //             .navigationBarWithButtonStyle
        }
        
    }
}
```

초기 설정은 이렇게 해줬다.

먼저 만족 안된다는 그 프로토콜은 View를 리턴하는 body(content:Content) 메서드를 통해 구현할 수 있고, Modifier를 한 경우에는 프리뷰를 볼 때 NavigationBarWithButton() 인스턴스를 바로 실행하는 것이 아니라, 뷰 안에 네비게이션뷰를 넣어주고, 해당 네비게이션 뷰의 navigationBarWithButtonStyle함수를 추가해서 표현할 수 있다.(일단 이 부분은 차후에 구현하도록 해보자)

그 다음에 할 일은 우리가 구현하고자 하는 Modifier 스타일을 만들어야 한다.

return content 뒤에다 content에 어떤 설정을 할 것인지 붙여주면 된다.

```swift
import SwiftUI

struct NavigationBarWithButton: ViewModifier {
    
    var title: String = ""
    
    func body(content: Content) -> some View {
        return content
            .navigationBarItems(
                leading: Text(title)
                 .font(.system(size: 24, weight: .bold))
                 .padding(),
                trailing: Button(
                    action: {
                        print("자산 추가 버튼 탭")
                    },
                    label: { // 라벨은 전체적 이미지와 텍스트 의미
                // 버튼 레이아웃 설정
                    Image(systemName: "plus")
                    Text("자산추가")
                            .font(.system(size: 12))
                      }
                    )
                .accentColor(.black)
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .overlay(
                   RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black) //테두리만 뽑아내기
                )
           )
     }
    
}

struct NavigationBarWithButton_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            Color.gray.edgesIgnoringSafeArea(.all)
   //             .navigationBarWithButtonStyle
        }
        
    }
}
```

자 갑작스럽게 긴 코드가 튀어나왔지만 당황하지 말자. 천천히 한 번 따라가보면 된다.

content에서 navigationBarItem(leading: trailing:)을 설정해주는데 (미래에 Deprecated될 예정이니 `[toolbar(content:)](https://developer.apple.com/documentation/swiftui/view/toolbar(content:)-5w0tj)` with `[navigationBarLeading](https://developer.apple.com/documentation/swiftui/toolbaritemplacement/navigationbarleading)` or `[navigationBarTrailing](https://developer.apple.com/documentation/swiftui/toolbaritemplacement/navigationbartrailing)` placement.를 되도록 사용하도록 하자. toolbar 메서드는 )

leading 먼저 설정해줄건데, 앞에서 설명한대로 여기엔 큰 텍스트를 넣어야한다(제목)

Text()를 통해 텍스트라고 지정해주는데, 안에는 리터럴을 쓰지 말고 넣을 문자열을 변수로 빼서 사용하자.

(크게 보면 모듈화와 응집성의 일종)

.font와 .padding을 지정해줬다.

trailing 오른쪽에는 버튼을 넣는다고 했다. Button(action: label:)을 통해 버튼을 만들어준다.

버튼을 눌렀을 때의 액션은 단순히 눌렀다고 프린트만 해줄 것이고

label 파라미터에서는 버튼의 레이아웃을 설정해준다.

“plus” 이미지와 Text를 넣어준다.

네비게이션 버튼의 설정도 추가해주는데

.accentColor(.black)을 통해 기본 버튼 색깔인 블루에서 벗어나 블랙으로 바꿔주고

padding을 줘서, top leading bottom trailing을 설정해준다.

마지막으로 버튼 테두리를 둥글게 하기 위해 .overlay 를 사용한다. 말 그대로 덮어씌우는 건데

이 안에 어떤 형태로 덧씌울거냐를 설정할 수 있다.  RoundedRectangle(cornerRadius: 10)으로 둥근 사각형을 덧씌운다음, .stroke를 통해 내부에 어떠한 채움 없이 전체 테두리만 뽑아낼 수 있도록 해준다.

여기까지 하면 버튼은 마무리 됐다.

content.navigationBarItems(…).navigationBarTitleDisplayMode(.inline)를 추가해서 
(Display the title within the standard bounds of the navigation bar) 타이틀을 inline 형태로 보여주도록 하고, 네비게이션 바의 백그라운드 컬러를 조절하고 알파값을 조절하기 위해  

마치 init 함수에서 super.init()을 해서 추가하는 상위 특성을 추가하는 것처럼

.onAppear(perform:)을 통해 performance를 추가할 수 있다.

네비게이션 바의 appearance를 조정하려면, UIKit의 정보를 활용하면 된다.

```swift
import SwiftUI

struct NavigationBarWithButton: ViewModifier {
    
    var title: String = ""
    
    func body(content: Content) -> some View {
        return content
            .navigationBarItems(
                ...
           )
            **.navigationBarTitleDisplayMode(.inline)
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground() // 투명
                appearance.backgroundColor = UIColor(white: 1, alpha: 0.5)
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance // 줄어들었을 때의 appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }**
     }
    
}
```

onAppear 클로저 내부에서 UINavigationBarAppearance()로 appearance 객체를 만들어주고

해당 객체에다 원하는 특성을 설정하고 UINavigationaBar.appearance()의 특정 상황에서의 appearance 속성에 해당 appearance 객체를 매핑해주면 된다!

```swift
**extension View {
    func navigationBarWithButtonStyle(_ title: String) -> some
    View {
        return self.modifier(NavigationBarWithButton(title: title))
    }
}**

struct NavigationBarWithButton_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            Color.gray.edgesIgnoringSafeArea(.all)
               **.navigationBarWithButtonStyle("내 자산")**
        }
        
    }
}
```

마지막엔 뷰에서 사용할 수 있는 메서드도 만들어줬다.

navigationBarWithButtonStyle이라는 메서드로 단순하게 View의 Modifier로 NavigationBarWithButton(title:) 인스턴스를 추가해줘서

PreviewProvider에서 볼 수 있듯이 SwiftUI에서 제공하는 뷰 위에서 바로 우리가 만들어줬던 NavigationBarWithButton Modifer를 적용할 수 있다.

프리뷰를 돌려보면 다음과 같이 나온다.


 <img width="431" alt="스크린샷 2024-01-16 오후 11 46 38" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/72e356b9-0066-4c67-bb74-8ee6bda78b10">


 

## Grid View 만들기

위에서 네비게이션 바까지 잘 만들었으니, 두 번째로 만들어야 하는 것은 그리드 형식의 뷰를 만들어야 한다.

네비게이션 바 바로 아래에 나타나는 형태로 만들면 되고, 총 8개의 작은 박스 안에 아이콘과 텍스트가 나타나는 형태를 만들어보자. 당연히 collectionView나 compositional collection을 이용하는 것이 아니라

SwiftUI의 그리드 뷰로 만들어야 한다.

안에 블럭 여러 개가 들어가니까, 이 데이터를 enum으로 만들어서 데이터를 관리해보도록 하자.

AssetMenu란 이름의 파일을 만들어주고, 이번에는 일반 Swift 파일로 만들도록 하자(enum을 넣을 파일)

```swift
 //
//  AssetMenu.swift
//  MyAssets
//
//  Created by jinyong yun on 1/17/24.
//

import Foundation

//Identifiable로 만들었을 땐 반드시 아이디 설정해줘야 프로토콜 만족
enum AssetMenu: String, Identifiable, Decodable {
    case creditScore
    case bankAccount
    case investment
    case loan
    case insurance
    case creditCard
    case cash
    case realEstate
    
    
    var id: String { //아이디 원시값으로 설정
        return self.rawValue
    }
    
    var systemImageName: String { // 블럭 안에 들어갈 이미지
        switch self {
        case .creditScore:
            return "number.circle"
        case .bankAccount:
            return "banknote"
        case .investment:
            return "bitcoinsign.circle"
        case .loan:
            return "hand.wave"
        case .insurance:
            return "lock.shield"
        case .creditCard:
            return "creditcard"
        case .cash:
            return "dollarsign.circle"
        case .realEstate:
            return "house.fill"
        }
    }
    
    
    var title: String { //블럭 안에 들어갈 텍스트
        switch self {
        case .creditScore:
            return "신용점수"
        case .bankAccount:
            return "계좌"
        case .investment:
            return "투자"
        case .loan:
            return "대출"
        case .insurance:
            return "보험"
        case .creditCard:
            return "카드"
        case .cash:
            return "현금영수증"
        case .realEstate:
            return "부동산"
        }
    }
}
```

String, Identifiable, Decodable를 설정해준다. 여기서 Decodable은 나중에 임의로 가져올 plist에서 AssetMenu를 디코드 할 용도이다. String은 뭐 원시값이고, Identifiable은 말 그대로 아이디를 만들어주는 건데 우리는 원시값으로 설정해 줄 것이다.

아이디 설정하고, 하나의 블럭 안에 들어갈 이미지와 라벨을 스위치 문으로 설정해주면 끝!

매번 여러 개의 버튼에 대한 레이아웃과 UI를 결정할 수는 없고, 재사용 가능하도록 파일을 따로 만들어 준다.

SwiftUI에서 제공하는 ButtonStyle로 만들어보자.

AssetMenuButtonStyle 파일을 SwiftUI View 형식으로 만들고, 해당 구조체의 타입은 ButtonStyle이다.(놀랍게도 SwiftUI에서 제공해준다.)

```swift
//  AssetMenuButtonStyle.swift
//  MyAssets
//
//  Created by jinyong yun on 1/17/24.
//

import SwiftUI

struct AssetMenuButtonStyle: ButtonStyle {
    let menu: AssetMenu // 받는 AssetMenu 값에 따라 이미지와 라벨 달라짐
    
    func makeBody(configuration: Configuration) -> some View { // makeBody로 진짜 바디 만들어주기!
        return VStack {
            
        }
    }
}
```

일단 기본 세팅은 이렇게 하고, 프리뷰를 미리 보기 위해 다음과 같이 설정해줬다.

```swift
struct AssetMenuButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 24) {
            Button("") { //액션은...
                print("")
            }
            .buttonStyle(AssetMenuButtonStyle(menu: .creditScore))
            Button("") { //액션은...
                print("")
            }
            .buttonStyle(AssetMenuButtonStyle(menu: .bankAccount))
            Button("") { //액션은...
                print("")
            }
            .buttonStyle(AssetMenuButtonStyle(menu: .investment))
            Button("") { //액션은...
                print("")
            }
            .buttonStyle(AssetMenuButtonStyle(menu: .loan))
            Button("") { //액션은...
                print("")
            }
            .buttonStyle(AssetMenuButtonStyle(menu: .insurance))
            Button("") { //액션은...
                print("")
            }
            .buttonStyle(AssetMenuButtonStyle(menu: .creditCard))
            Button("") { //액션은...
                print("")
            }
            .buttonStyle(AssetMenuButtonStyle(menu: .cash))
            Button("") { //액션은...
                print("")
            }
            .buttonStyle(AssetMenuButtonStyle(menu: .realEstate))
        }
    }
}
```

24 간격으로 Hstack안에서 8개의 버튼을 전부 보여줄 것이다.

Button(title: action:) 메서드를 이용해서 (액션 부분은 클로저로…)

일단 제목과 액션을 임시적으로 비워놓았다.

프리뷰도 다져놓았으니, 이제 본격적으로 바디를 만들어보자!

```swift
struct AssetMenuButtonStyle: ButtonStyle {
    let menu: AssetMenu // 받는 AssetMenu 값에 따라 이미지와 라벨 달라짐
    
    func makeBody(configuration: Configuration) -> some View { //makeBody로 진짜 바디 만들어주기!
        return VStack { //블럭마다 이미지가 위, 텍스트가 아래
            Image(systemName: menu.systemImageName)
                .resizable()
                .frame(width: 30, height: 30)
                .padding([.leading, .trailing], 10)
            Text(menu.title)
                .font(.system(size:12, weight: .bold))
        }
        .padding()
        .foregroundColor(.blue)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10)) //말 그대로 전체 모양을 오려내듯이 표현
    }
}
```

블럭에 들어갈 이미지와 텍스트를 각각 설정해주고, 이미지의 사이즈는 30으로 static하게 설정해줬다.

패딩은 leading과 trailing을 설정하도록 해줬고, 각각 10씩 줬다.

VStack 전부의 padding을 설정하고 안쪽 색깔은 파란색, 블럭의 배경색은 하얀색으로 해줬고

clipShape라는 특이한 녀석도 나오는데, 저번에 사용했던 stroke와 달리 이녀석은 만약 이미지가 있다면 이녀석을 지정해준 형태로 오려내는 느낌. stroke은 도형의 윤곽을 색 또는 그라디언트로 추적(Trace)?해주는 함수이다. 쉽게 생각하면...도형의 윤곽을 추적해서 그려주는 것이다. 그래서 네비게이션 바에서도 검은 테두리만 생겼다는 것! 

프리뷰에서는 아마 뷰의 백그라운드도 하얀색으로 나와서 블럭 내부와 외부의 경계가 잘 보이지 않을 것을 대비해 .background(Color.gray.opacity(0.2))를 HStack에 붙여주도록 하자.

<img width="436" alt="스크린샷 2024-01-17 오후 10 06 44" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/447ca13d-13c7-44db-9388-9bfa841dd91b">


요런식으로 프리뷰에 나타난다.

설정해준 이미지와 텍스트 라벨 모두 잘 나타나는 것을 확인할 수 있다. clipShape로 만들어 준 RoundedRectangle도 잘 나타난다.

그 다음으로 만들어줘야 하는 건, 우리가 만든 버튼 스타일을 실제 그리드 뷰에 적용하기 위해서 

AssetMenuGridView를 따로 만든 다음(여기에 버튼 스타일 적용하고) ContentView에다가 추가할 것이다.

AssetMenuGridView 파일을 만들어준다.

당연히 SwiftUI 뷰 파일로 만들어주고,

타입은 뷰 그대로 유지!

AssetMenu로 이루어진 2차원 배열을 만들어준다.

```swift
let menuList: [[AssetMenu]] = [
        [.creditScore, .bankAccount, .investment, .loan],
        [.insurance, .creditCard, .cash, .realEstate]
    ]
```

이제 바디를 구성하면서 2차원 배열인 AssetMenu들을 잘 뿌리면 되겠다.

```swift
//  AssetMenuGridView.swift
//  MyAssets
//
//  Created by jinyong yun on 1/17/24.
//

import SwiftUI

struct AssetMenuGridView: View {
    
    let menuList: [[AssetMenu]] = [
        [.creditScore, .bankAccount, .investment, .loan],
        [.insurance, .creditCard, .cash, .realEstate]
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(menuList, id: \.self) { row in //menuList에서 ForEach를 통해 각각의 row를 가져옴
                HStack(spacing: 10){
                    ForEach(row) { menu in
                        Button("") {
                            print("\(menu.title)버튼 tapped")
                        }
                        .buttonStyle(AssetMenuButtonStyle(menu: menu))
                    }
                }
            }
        }
    }
}

struct AssetMenuGridView_Previews: PreviewProvider {
    static var previews: some View {
        AssetMenuGridView()
    }
}
```
<img width="433" alt="스크린샷 2024-01-17 오후 10 22 43" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/010966bf-6404-4b0f-9a91-4d1977d9b903">


바디에서는 VStack에서 ForEach를 이용해서 먼저 row를 뿌려주고, ForEach 내부에서 HStack 즉 가로로 각각의 AssetMenu를 뿌려준 것이다. 각 Button(블럭)을 눌렀을 때의 액션은 간단하게 프린트로 해줬다.

이제 이렇게 만든 그리드 뷰를  AssetView에 추가할 건데, 우린 아직 AssetView를 만들지 않았다.

우리가 아까 만들었던, ContentView에 

```swift
var body: some View {
        TabView(selection: $selection) {
            Color.white // 여기에 AssetView를 추가해 줄 예정!
                .tabItem {
                    Image(systemName: "dollarsign.circle.fill")
                    Text("자산")
                }
                .tag(Tab.asset)
//...
```

바디 영역에서 white로 지금은 표시되어 있지만, 원래 여기에 AssetView가 나타나야 한다.

그런 의미에서 AssetView를 만들어준다.

제일 먼저 바디 내에 만들어줘야 하는 건 뭘까?

바로 우리가 만든 NavigationView가 아니겠는가.

그리고 지금은 네비게이션 바와 에셋 그리드 뷰까지만 만들었는데…배너 뷰나 기타 등등 또한 VStack안에 넣어줄 예정이다. But! 혹시 기억나는가,  **VStack은  스크롤 뷰를 포함하고 있지 않다.**

자연스럽게 이 뷰 전체가 스크롤을 통해 내려가게 하려면 스크롤 뷰 안에다 스택 또는 그리드를 넣어줘야 한다.

그래서 네비게이션 뷰 안에 스크롤 뷰를 먼저 넣어주고, 그 안에 VStack을 넣어준다.

```swift
import SwiftUI

struct AssetView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    Spacer() //공간 좀 넣어주고
                    AssetMenuGridView()
                }
            }
            .background(Color.gray.opacity(0.2))
            .navigationBarWithButtonStyle("내 자산")
        }
    }
}

#Preview {
    AssetView()
}
```
<img width="437" alt="스크린샷 2024-01-17 오후 10 36 20" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/9b6ed909-f670-4b50-bce0-6a66fd0565f2">



아까 만들어준 AssetMenuGridView()를 VStack안에 추가하고, 스크롤 뷰의 백그라운드 색상을 설정한 뒤

NavigationBarWithButton에서 작성해준 View에서 extension 해 준 그녀석! navigationBarWithButtonStyle 메서드를 통해 네비게이션 바 또한 추가해준다.

패딩이 제대로 표현되지 않는 것을 알 수 있는데, 일단 다른 서브뷰를 완성하고 제대로 맞춰주도록 하자.

## 배너 만들기

ContentView에서 Color.white 대신 위에서 만들었던, AssetView를 추가해준다.

```swift
var body: some View {
        TabView(selection: $selection) {
           AssetView()
                .tabItem {
                    Image(systemName: "dollarsign.circle.fill")
                    Text("자산")
                }
```
<img width="428" alt="스크린샷 2024-01-17 오후 10 59 06" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/cea7a2c6-cb58-472b-b4d8-f183e589220d">



이제 또다른 서브뷰로 그리드 뷰 아래에 좌우로 움직일 수 있는 배너(흔히 앱스토어에서 볼 수 있는…)를 만들어 줄 것이다. 

총 4개의 페이지를 갖는 배너를 만들어 줄 것이다.

먼저 배너의 엔티티를 만들어 줄 것이다.

AssetBanner를 만들어주고 (파일은 그냥 기본 스위프트 파일) 헷갈리지 않게 AssetMenu와 함께 디렉토리로 묶어줬다. 

```swift
//  AssetBanner.swift
//  MyAssets
//
//  Created by jinyong yun on 1/17/24.
//

import UIKit

struct AssetBanner {
    let title: String
    let description: String
    let backgroundColor: UIColor
}
```

일단 하나의 배너 구조체에는 타이틀과 설명 그리고 백그라운드 컬러로 이루어지도록 했다.

UIColor가 UIKit에 속하기 때문에 Foundation 프레임워크에서 바꿔주는 걸 잊지 말도록 하자!

만들어 준 배너 구조체를 하나로 묶을 수 있는 BannerCard 뷰를 만들어주자.

새로운 파일로 BannerCard.swift 만들어주고 당연히 파일 타입은 swiftUI view로 하자.

<img width="1241" alt="스크린샷 2024-01-17 오후 11 08 52" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/5526a541-ac4a-4f00-9e81-71ec482899a8">


생각보다 간단하게 만들 수 있다. 바디 안에 overlay로 VStack을 넣고 타이틀과 설명을 넣어준 것이 전부…

이걸 나중에 슈퍼 뷰에서 크기를 설정해주면 된다.

지금같이 표현한 overlay 대신 ZStack을 사용해도 같은 효과가 난다.

```swift
ZStack {
   Color(banner.backgroundColor)
   VStack {
                    Text(banner.title)
                        .font(.title)
                    Text(banner.description)
                        .font(.subheadline)
          }
     }
```

이렇게 해줘도 똑같이 나온다!

일단 각각의 배너에 표현될 카드에 해당하는 뷰는 완성되었다.

이걸 좌우로 움직이는 페이지 컨트롤러처럼 만들 수 있게 배너 형태의 페이지 뷰 컨트롤러를 만들거다.

이미 UIKit에는 pageController라는 아아주 좋은 컨트롤러가 있다.

그래서 굳이 SwiftUI로 전부 구현하지 말고 이걸 이용할 것이다.

<img width="931" alt="스크린샷 2024-01-17 오후 11 15 41" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/b20b0a97-4c59-4d17-be39-de094850d3be">


PageViewController는 페이지의 역할을 할 View를 받고

타입은 UIViewControllerRepresentable로 한다. 당연히 프로토콜 준수를 요청하는데!!

UIViewControllerRepresentable에 대한 간략한 설명을 아래에 적어놓았다.

- SwiftUI에서 UIKit에 있는 뷰를 사용할때 이용
    - makeUIView에 UIKit 인스턴스를 리턴
    - updateUIView은 SwiftUI에서 뷰가 업데이트 될때 불리는 메소드로, 이곳에서 delegate와 같은 처리

```swift
//
//  PageViewController.swift
//  MyAssets
//
//  Created by jinyong yun on 1/17/24.
//

import SwiftUI
import UIKit

struct PageViewController<Page: View>: UIViewControllerRepresentable {
    var pages: [Page]
    @Binding var currentPage: Int //현재 어떤 페이지가 보여지고 있는지
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        
        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            [context.coordinator.controllers[currentPage]],
            direction: .forward,
            animated: true
        )
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        var controllers = [UIViewController]()
        
        init(_ pageViewController: PageViewController) {
            parent = pageViewController
            controllers = parent.pages.map { UIHostingController(rootView: $0) }
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else { return nil }
            if index == 0 {
                return controllers.last
            }
            
            return controllers[index - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else { return nil }
            if index + 1 == controllers.count {
                return controllers.first
            }
            return controllers[index + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = controllers.firstIndex(of: visibleViewController) {
                parent.currentPage = index
            }
        }
        
    }
    
}
```

자 수많은 코드가 나와서 당황했을텐데…천천히 따라가보자.

var pages: [Page]
    @Binding var currentPage: Int //현재 어떤 페이지가 보여지고 있는지

먼저 이 부분은 당연히 페이지를 보여줘야 하니까 Page 배열을 만들어줬고

Wrapper를 이용해서 현재 어떤 페이지를 보여주고 있는지 알 수 있게 했다. 

<aside>
💡 @Binding property의 경우 SwiftUI에서 뭐 뷰가 나타났을때 세팅을 해준다던가, 버튼을 클릭했을때 토글을 해준다던가 등의 형태로 @State를 설정해주면, UIKit코드에서 이 값을 readOnly로 읽어들일 수 있었다. read-only라는점이 중요하다.                                                                        바인딩 프로퍼티로는 반대입장, 즉 UIKit의 변수를 SwiftUI로 전달할 수 없다는 것이다.                이 반대의 개념은 UIKit와 SwiftUI를 섞어쓰다보면 필수적이다.                                                  만약 테이블뷰를 UIKit으로 생성했다면, 테이블뷰의 칼럼 값을 SwiftUI로 전달해서 띄워야 할 필요가 있을수도 있다. 이를 위해서 존재하는게 바로 Coordinator다.                                                       요약하자면, @Binding property는 SwiftUI -> UIKit 으로의 변수 전달이고,                Coordinator의 경우 UIKit -> SwiftUI로의 데이터 전달이라고 생각하면 쉽다.               Coordinator라고 해서 새로운 개념 같지만, 사실상 "delegate"의 역할을 한다고 봐도 무방하다.

</aside>

makeCoordinator는 프로토콜 준수 사항 중 하나로써, 말그대로 Cooridnator를 만드는 함수고, 

코디네이터 클래스는 UIKit -> SwiftUI로의 브릿지 역할을 하는 delegate라고 보면 된다.

makeUIViewController는 말 그대로 UIKit의 UIViewController를 생성해주는 메서드이다.

updateUIViewController는 ViewController의 업데이트가 필요할 때 호출된다.

따라서 이 두 메서드에서는 ViewController에서 필요한 데이터 또는 정보를 갱신해줘야 한다.

makeUIViewController에서 우리는 명시적으로 some UIViewController가 아닌 UIPageViewController를 생성해 줄 것이고, 이녀석의 초기 상태는 

수평으로 스크롤 할 수 있도록, UIPageViewController의 인자값인 transitionStyle과 navigationOrientation에 각각 .scroll과 .horizontal을 넣어준다.

여기서 pageViewController의 dataSource와 delegate를 context.coordinator가 가져간다. 위에서도 말했듯이 UIKit과 SwiftUI의 delegate 역할을 해주는 것이 coordinator이며, 당연히 데이터를 뿌려주는 주체도 coordinator가 된다.

updateUIViewController에서는 pageViewController.setViewControllers를 이용해서 view Controller 들이 담긴 배열의 첫번째 요소를 디스플레이에 표시해준다. 

그 다음 구현은 대망의 Coordinator이다. (UIKit → SwiftUI)

Coordinator는 NSObject 타입이고, makeUIViewController에서 설정했듯이 UIPageViewControllerDelegate와 UIPageViewControllerDataSource를 준수하여 구현해줘야 한다.

parent로 PageViewController를 선언해줬다.

일종의 계층 구조를 정의해 준 건데, 우리는 PageViewController를 부모로써 여기로 (즉 UIKit에서) 전달해줘야 하고

그 다음 위에서 만들어 준 UIPageViewController를 담을 수 있게 UIViewController 배열을 만들어주고

Coordinator ***클래스***니까 init을 만들어줘야 한다.

parent 프로퍼티는 매개변수로 받는 pageViewController로 설정하고, controllers 프로퍼티는 parent즉 pageViewController의 pages 배열을 (그니까 Page 즉 View죠!) UIHostingController()로 감싸줘서 넘겨준다. 

여기서 ***UIHostingController***란??

<aside>
💡 UIKit에서 SwiftUI 뷰를 사용하고 싶을때 사용

</aside>

<aside>
💡 UIHostingController 코드를 보면 UIViewController를 상속받고 있는 형태

</aside>

<aside>
💡 동시에 SwiftUI의 View형태를 준수

</aside>

<aside>
💡 UIKit에서 SwiftUI 사용 원리

- SwiftUI 뷰를 생성
- HostingController를 만들고, 이곳의 제네릭스 타입에 위에서 생성한 뷰로 지정 (SwiftUI를 UIKit에서 접근 할 수 있도록 wrapping하는 작업)
- UIKit에서 HostingController를 불러와서 사용
</aside>

그 다음은 viewControllerBefore과 viewControllerAfter를 구현한다.

이녀석들은 델리게이트 함수로, 우리가 배너를 좌우로 움직일 때 순서에 상관없이 자연스럽게 움직이게 하기 위해서 설정해준 것이다. Before는 왼쪽, After는 오른쪽을 설정하는 것이다.

그래서 viewControllerBefore에서 페이지 리스트의 인덱스가 0이고 왼쪽으로 넘겼을 때 페이지 리스트의 끝 인덱스가 자연스럽게 나오게 하기 위해서 controllers 즉 페이지 리스트의 마지막 인덱스가 리턴되도록 한 것이다. viewControllerBefore를 이해했다면 After는 더욱 쉽다.

didFinishAnimating 델리게이트 메서드는 말 그대로 애니메이션이 종료됐을 때 호출되는 메서드이다.

만약 완료되고, 보여지는 뷰 컨트롤러가 pageViewController의 첫 번째 뷰 컨트롤러이고,

컨트롤러의 볼 수 있는 컨트롤러의 인덱스를 뽑아내어, 이녀석을 parent 즉 pageViewController의 currentPage에 넣어준다. 즉 우리가 맨 처음에 binding 프로퍼티 wrapper로 설정해 준 currentPage에

각각 보여지는 페이지를 완벽하게 매칭시키는 구문이다. 완전히 애니메이션이 끝났을 때 인덱스를 가져갈 수 있도록 설정했다.

여기까지 하면 기존에 UIKit에 들어가 있던 pageViewController를 SwiftUI에서 사용하기 위한 기본적인 설정이 끝났다!

배너 하면 떠오르는 게 또 있지 않은가…?

바로 배너를 넘길 때 같이 겹쳐 있는 동그라미들(?)

이녀석은 정식 명칭으로 PageControl이라고 불리는데 이녀석을 만들어 줄 것이다.

PageControl이란 SwiftUI View 파일을 만들어준다.

지금까지 만들었던 건 PageViewController에 대한 Representable이라면,

PageControl은 각각의 페이지 컨트롤러 안에 들어갈 해당 뷰에 대한 Representable이다.

```swift
//  PageControl.swift
//  MyAssets
//
//  Created by jinyong yun on 1/18/24.
//

import SwiftUI
import UIKit

struct PageControl: UIViewRepresentable {
    var numberOfPages: Int // 페이지 수를 받는다.
    @Binding var currentPage: Int //동그라미에다 안에 색깔 넣으려면 당연히 현재 페이지 알아야...
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    } // 여기까진 위와 같고...
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl() //UIViewRepresentable 인스턴스를 만들고
        control.numberOfPages = numberOfPages //프로퍼티를 초기화
        control.addTarget( // UIViewRepresentable에 액션을 추가해준다. 이래야 색깔 칠해주기
            context.coordinator, //대상은 coordinator
            action: #selector(Coordinator.updateCurrentPage(sender:)), //selector 메서드는 Coordinator 내부 정의
            for: .valueChanged //값이 바뀔 때 일어나!
        )
        
        return control
    }
    
    
    func updateUIView(_ uiView: UIPageControl, context: Context) { //뷰가 업데이트 될 때 일어나!
        uiView.currentPage = currentPage
    }
    
    class Coordinator: NSObject { //Coordinator 정의하는데
        var control: PageControl //UIViewRepresentable 변수
        
        init(_ control: PageControl){ // Coordinator 생성자로 control 넣어주기
            self.control = control
        }
        
        @objc func updateCurrentPage(sender: UIPageControl) { //selector 구현
            //현재 페이지를 업데이트 할 수 있다.
            control.currentPage = sender.currentPage
        }
        
    }
    
}
```

주석을 보면 UIViewControllerRepresentable 과정과 상당히 비슷하기에 쉽게 이해할 수 있을 것이다.

여기까지 하면, pageViewController와 pageControl이라는 UIKit에 있는 프레임 워크 상의 컴포넌트를 SwiftUI에서 사용할 준비가 끝났다.

이제 우리가 이전에 만들어놓은 AssetView의 그리드 뷰 아래에 해당 배너가 표시될 수 있도록 해보겠다.

```swift
//  AssetBannerView.swift
//  MyAssets
//
//  Created by jinyong yun on 1/18/24.
//

import SwiftUI

struct AssetBannerView: View {
    let bannerList: [AssetBanner] = [
        AssetBanner(title: "공지사항", description: "추가된 공지사항을 확인하세요", backgroundColor: .red),
        AssetBanner(title: "주말 이벤트", description: "주말 이벤트 놓치지 마세요", backgroundColor: .yellow),
        AssetBanner(title: "아침 이벤트", description: "아침 이벤트 놓치지 마세요", backgroundColor: .gray),
        AssetBanner(title: "점심 이벤트", description: "점심 이벤트 놓치지 마세요", backgroundColor: .brown)
    ]
    
    @State private var currentPage = 0
    
    var body: some View {
        let bannerCards = bannerList.map { BannerCard(banner: $0) }
        
        ZStack(alignment: .bottomTrailing) { //page Control 오버레이
            PageViewController(pages: bannerCards, currentPage: $currentPage)
            PageControl(numberOfPages: bannerList.count, currentPage: $currentPage)
                .frame(width: CGFloat(bannerCards.count * 18))
                .padding(.trailing)
        }
    }
}

struct AssetBannerView_Previews: PreviewProvider {
    static var previews: some View {
        AssetBannerView()
            .aspectRatio(5/2, contentMode: .fit)
    }
}
```

AssetBanner로 이루어진 배열 bannerList를 만들어주고,

 @State private var currentPage = 0

를 설정해서 binding 으로부터 받을 수 있도록 해준다.

AssetBanner로 이루어졌던 bannerList를 BannerCard(뷰)로 매핑시켜주고

배너의 오른쪽 하단 부분에 pageControl이 나타나게 하려고 ZStack을 사용하여 오버레이 효과를 내다.

만들어줬던  PageViewController, PageControl를 ZStack에 추가하는데 .frame과 .padding을 설정해 PageControl의 크기를 제한한다.



https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/a3de10b0-5a77-4b21-8ee1-5e91ff36d938



좌우로 잘 동작하는 것을 알 수 있다.

이제 AssetView로 이동해서 

AssetBannerView()
.aspectRatio(5/2, contentMode: .fit)

이렇게 VStack에 추가해주면!

<img width="1239" alt="스크린샷 2024-01-18 오전 1 23 19" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/111a8b37-9ae5-4a50-b058-ef04ad45a89c">


AssetView에도 잘 나타나는 것을 알 수 있다!

## 자산 관리 리스트 만들기

상단의 grid뷰와 배너 뷰까지는 완성시켰다.

이제 그 아래부분, 각각의 자산에 맞는 리스트 부분을 구현할 것이다.

미리 만들어뒀던 asset.json 파일을 가져와 프로젝트에 추가해준다.

- asset.json
    
    ```swift
    [
        {
            "id": 0,
            "type": "creditScore",
            "data": [
                {
                    "id": 0,
                    "title": "신용점수",
                    "amount": "999점"
                }
            ]
        },
        {
            "id": 1,
            "type": "bankAccount",
            "data": [
                {
                    "id": 0,
                    "title": "신한은행",
                    "amount": "42,000원"
                },
                {
                    "id": 1,
                    "title": "국민은행",
                    "amount": "9,263,000원"
                },
                {
                    "id": 2,
                    "title": "카카오뱅크",
                    "amount": "2,255,900원"
                }
            ]
        },
        {
            "id": 2,
            "type": "investment",
            "data": [
                {
                    "id": 0,
                    "title": "카카오페이",
                    "amount": "5,003,370원"
                },
                {
                    "id": 1,
                    "title": "한국투자",
                    "amount": "5,675,236원"
                }
            ]
        },
        {
            "id": 3,
            "type": "loan",
            "data": [
                {
                    "id": 0,
                    "title": "카카오뱅크",
                    "amount": "-67,333,000원"
                },
                {
                    "id": 1,
                    "title": "하나은행",
                    "amount": "-4,000,000,000원"
                }
            ]
        },
        {
            "id": 4,
            "type": "insurance",
            "data": [
                {
                    "id": 0,
                    "title": "삼성화재",
                    "amount": "월 20,000원"
                },
                {
                    "id": 1,
                    "title": "한화손해보험",
                    "amount": "월 77,400원"
                },
                {
                    "id": 2,
                    "title": "메리츠화재보험",
                    "amount": "월 10,000원"
                },
                {
                    "id": 3,
                    "title": "롯데손해보험",
                    "amount": "월 84,900원"
                }
            ]
        },
        {
            "id": 5,
            "type": "creditCard",
            "data": [
                {
                    "id": 0,
                    "title": "현대카드",
                    "amount": "0원",
                    "creditCardAmounts": [
                        {
                            "previousMonth": "10,000원"
                        },
                        {
                            "currentMonth": "45,000원"
                            
                        },
                        {
                            "nextMonth": "100,400원"
                        }
                    ]
                },
                {
                    "id": 1,
                    "title": "우리카드",
                    "amount": "9,000원",
                    "creditCardAmounts": [
                        {
                            "previousMonth": "40,000원"
                        },
                        {
                            "currentMonth": "95,000원"
                            
                        },
                        {
                            "nextMonth": "2,150,400원"
                        }
                    ]
                }
            ]
        },
        {
            "id": 6,
            "type": "cash",
            "data": [
                {
                    "id": 0,
                    "title": "이번 달 사용금액",
                    "amount": "472,890원"
                }
            ]
        },
        {
            "id": 7,
            "type": "realEstate",
            "data": [
                {
                    "id": 0,
                    "title": "한강현대아파트",
                    "amount": "16억 9천만원"
                },
                {
                    "id": 1,
                    "title": "여의도오피스텔",
                    "amount": "2억 9천만원"
                }
            ]
        }
    ]
    ```
    

json 파일을 확인해보면, id가 있고, 어떤 타입의 자산인지 명시해주고 있고, 그 타입의 자산이 가지는 상세 데이터들을 배열로 담는 형태이다.

우리는 이러한 json 형태로 데이터를 서버에서 받았다고 가정하고 

디코딩을 해서 화면에 잘 뿌려줘야 한다.

뿌려주려면 뭐가 필요하다?

데이터 모델에 맞는 엔티티가 필요하다!

```swift
//
//  Asset.swift
//  MyAssets
//
//  Created by jinyong yun on 1/18/24.
//

import Foundation

class Asset: Identifiable, ObservableObject, Decodable {
    let id: Int
    let type: AssetMenu
    let data: [AssetData]
    
    init(id: Int, type: AssetMenu, data: [AssetData]){
        self.id = id
        self.type = type
        self.data = data
    }
    
}

class AssetData: Identifiable, ObservableObject, Decodable {
    let id: Int
    let title: String
    let amount: String
    
    init(id: Int, title: String, amount: String){
        self.id = id
        self.title = title
        self.amount = amount
    }
}
```

이런식으로 만들어줬다. 타입은 기존에 만들어줬던 enum 타입 AssetMenu를 활용했고, 

data를 위해서 AssetData 클래스도 만들어줬다.

데이터 모델을 위한 엔티티 설정은 끝냈다.

이제 진짜 데이터 모델을 만들어야 한다.

일단 하나의 새로운 SwiftUI 파일을 만들고 이름은 AssetSummaryData로 설정해줬다.

여기서 뭘 할거냐면

기존에는 뷰 컨트롤러나 뷰 안에서 모든 데이터 흐름이 완성되었지..

외부에서 어떻게 정제된 데이터가 들어오는 형식을 하지 않았다.

하지만 이번에는 이걸 시도해보려고 한다.

어떻게?? 바로 ObservableObject 형식을 이용해서!

외부에서 별도의 데이터 모델을 이용해서(Asset도 ObservableObject로 설정했던 걸 기억해라!)

데이터를 디코딩 한 다음 그걸 뷰에 뿌려줄 거다.

Published 프로퍼티 래퍼를 이용해서 어떤 데이터를 내보낼 지 표현해준다.

```swift
//
//  AssetSummaryData.swift
//  MyAssets
//
//  Created by jinyong yun on 1/18/24.
//

import SwiftUI

class AssetSummaryData: ObservableObject {
    @Published var assets: [Asset] = load("assets.json")//디코딩 된 Asset을 내보낼 거다.
}

func load<T: Decodable>(_ filename: String) -> T { //어떠한 파일 이름을 입력하면 내가 원하는 형태로 디코딩
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("\(filename) 을 찾을 수 없습니다!")
    }
            
    //만약 잘 통과 후 파일 찾으면
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError(filename + "을 찾을 수 없습니다!")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError(filename + "을 \(T.self)로 디코딩 할 수 없다!!")
    }
}
```

어떠한 파일 이름을 입력하면 내가 원하는 형태로 디코딩 해주는 load 메서드를 따로 작성해줬다.

디코딩은 이제는 너무나 익숙한 JSONDecoder로 진행했다.

이렇게 만들어주면 데이터 모델이 완성됐다.

이녀석을 어떻게 사용할까?

바로 헤더 뷰를 만들면서 사용할 것이다.

헤더뷰와 섹션 뷰로 나누어서, 헤더 뷰를 먼저 만들고

그 다음 섹션 뷰에 데이터를 뿌려줄거다.

```swift
 
//
//  AssetSectionHeaderView.swift
//  MyAssets
//
//  Created by jinyong yun on 1/18/24.
//

import SwiftUI

struct AssetSectionHeaderView: View {
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.accentColor)
            Divider() //굵은 선 추가
                .frame(height: 2)
                .background(Color.primary)
                .foregroundColor(.accentColor)
            
        }
    }
}

struct AssetSectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AssetSectionHeaderView(title: "은행")
    }
}
```
<img width="432" alt="스크린샷 2024-01-18 오후 3 53 37" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/e7bcd116-85ea-41c2-a826-63a6928c1c94">



헤더 뷰는 다음과 같이 완성할 수 있다. VStack에서 제목을넣을 텍스트를 만들어주고,

Divider()를 추가해 제목 밑에 굵은 선을 넣어준다.

헤더 뷰와 합쳐질 섹션 뷰를 만들자.

AssetSectionView라고 이름지어줬다.

우리가 아까 AssetSummaryData를 Observable 오브젝트로 만들고, 얘를 실제 뷰에 데이터 모델을 연결해서 사용할 거라고 했다.

여기서 Observable 오브젝트를 연결해서 쓰려면, @**ObservedObject** 프로퍼티 래퍼를 사용해서 연결할 수 있다.

Asset 클래스가 이미 Observable로 선언되어있으니, 이녀석은 ‘나는 관찰할 수 있어!’라고 말하는 것이고

ObservedObject 프로퍼티는 ‘그럼 내가 그거 관찰할게!’라고 말하고 있는거다.
<img width="1209" alt="스크린샷 2024-01-18 오후 4 21 24" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/4081c064-e6ee-4611-9e54-369c82bf33d3">



이렇게 섹션 뷰를 완성하자.

지금 이 섹션 뷰는 계좌 하나에 대해서 나타내고 있는데, 우리에겐 총 8개 타입의 자산이 존재하므로(Asset 타입) 이걸 전부 담아주기 위한 부모 뷰가 필요하다.

```swift
//  AssetSummaryView.swift
//  MyAssets
//
//  Created by jinyong yun on 1/18/24.
//

import SwiftUI

struct AssetSummaryView: View {
    //외부에서 AssetSummaryData를 받아서 AssetSummaryView의 전체 상태를
    // 변경시키고 표현한다는 의미의 프로퍼티
    @EnvironmentObject var assetData: AssetSummaryData
    
    var assets: [Asset] {
        return assetData.assets
    }
    
    var body: some View {
        VStack(spacing: 20){
            ForEach(assets){ asset in
                AssetSectionView(assetSection: asset)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
        }
    }
}

struct AssetSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        AssetSummaryView()
            .environmentObject(AssetSummaryData())
            .background(Color.gray.opacity(0.2))
    }
}
```
<img width="409" alt="스크린샷 2024-01-18 오후 4 31 24" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/4b5d5f02-9577-46d9-bc11-1a798366926f">



우리가 방금 넣어준 Assets.json을 AssetSummaryData() 즉 우리가 만들었던 데이터 모델에서 @Published로 선언된 assets를 그대로 내뱉어줬고 그걸 받아서 environmentObject에서 표현해 준 것이다.

하지만 지금은 VStack 이지만 내부에 스크롤 뷰가 없어서 스크롤이 안될텐데

스크롤이 되게 하려면 AssetSummaryView의 부모 뷰인 AssetView에 넣어줘야 한다.

AssetView로 돌아가서, AssetBannerView() 설정 아래에 넣어주자!

```swift
//  AssetView.swift
//  MyAssets
//
//  Created by jinyong yun on 1/17/24.
//

import SwiftUI

struct AssetView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    Spacer() //공간 좀 넣어주고
                    AssetMenuGridView()
                    AssetBannerView()
                        .aspectRatio(5/2, contentMode: .fit)
                    AssetSummaryView()
                        .environmentObject(AssetSummaryData())
                }
            }
            .background(Color.gray.opacity(0.2))
            .navigationBarWithButtonStyle("내 자산")
        }
    }
}

#Preview {
    AssetView()
}
```

상단의 부모뷰엔 이미 스크롤 뷰가 있기 때문에 스크롤도 정상적으로 동작할 것이다.



https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/4d41aadb-2b19-441a-8bc2-5b4aaa2a2863



이제 대부분의 앱과 같은 형태는 완성이 됐다.

이제 요기서 조오금만 더 수정을 거쳐보자.(다 왔다 조금만 더 힘을 내자)

카드 섹션에 세 가지의 탭을 더 추가하고 싶다. 지금처럼 헤더와 리스트만 있는 것이 아니라, [지난달 결제, 이번달 결제, 다음달 결제] 이렇게 탭을 그 사이에 넣는 형태로 만들고 싶다.

이렇게 하기 위해 데이터부터 수정을 해야한다.
<img width="373" alt="스크린샷 2024-01-18 오후 4 41 45" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/ae1a35c9-8e31-4b3e-9d43-a996c25e4253">



먼저 이 assets.json이라는 곳에 가서 카드 영역을 보면, 우리는 creditCardAmounts라는 엔티티를 추가한 적이 없다. (id, type, data[AssetData] 만 있었다!)

그래서 여기에 creditCardAmounts라는 것을 추가해야 한다.

```swift
//
//  Asset.swift
//  MyAssets
//
//  Created by jinyong yun on 1/18/24.
//

import Foundation

class Asset: Identifiable, ObservableObject, Decodable {
    let id: Int
    let type: AssetMenu
    let data: [AssetData]
    
    init(id: Int, type: AssetMenu, data: [AssetData]){
        self.id = id
        self.type = type
        self.data = data
    }
    
}

class AssetData: Identifiable, ObservableObject, Decodable {
    let id: Int
    let title: String
    let amount: String
    let creditCardAmounts: [CreditCardAmounts]?
    
    init(id: Int, title: String, amount: String, creditCardAmounts: [CreditCardAmounts]? = nil){
        self.id = id
        self.title = title
        self.amount = amount
        self.creditCardAmounts = creditCardAmounts
    }
}

enum CreditCardAmounts : Identifiable, Decodable {
    case previousMonth(amount: String)
    case currentMonth(amount: String)
    case nextMonth(amount: String)
    
    var id: Int {
        switch self {
        case .previousMonth:
            return 0
        case .currentMonth:
            return 1
        case .nextMonth:
            return 2
        }
    }
    
    var amount: String {
        switch self {
        case .previousMonth(let amount),
                .currentMonth(let amount),
                .nextMonth(let amount):
            return amount
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case previousMonth
        case currentMonth
        case nextMonth
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try? values.decode(String.self, forKey: .previousMonth) {
            self = .previousMonth(amount: value)
        }
        
        if let value = try? values.decode(String.self, forKey: .currentMonth) {
            self = .currentMonth(amount: value)
            return
        }
        
        if let value = try? values.decode(String.self, forKey: .nextMonth) {
            self = .nextMonth(amount: value)
            return
        }
        
        throw fatalError("ERROR: CreditCardAmounts JSON Decoding")
    }
    
    
}
```

AssetData에  creditCardAmount 배열을 선언하고, creditCardAmount 열거형 타입을 정의해줬다.

각각의 타입에 따라 id와 amount를 가져올 수 있도록 switch 문으로 변수를 세팅해줬고

디코딩을 하기 위해 코딩 키도 설정해주고

생성자 내에서 디코딩을 할 수 있게 해준다.

이렇게 해주면 우리가 빠뜨렸던 creditCardAmounts에 대한 데이터 수정이 완료됐다.

이때 주의해야 할 점은 creditCardAmounts는 카드 외에는 없기 때문에 옵셔널로 처리해줘야 다른 타입에서 에러가 나지 않는다.

이제 탭 메뉴의 실제 UI를 만들어보려고 한다.

```swift
import SwiftUI

struct TabMenuView: View {
    var tabs: [String]
    @Binding var selectedTab: Int
    @Binding var updated: CreditCardAmounts?
    
    var body: some View {
        HStack {
            ForEach(0..<tabs.count, id:\.self) { row in
                Button(
                    action: {
                        selectedTab = row
                        UserDefaults.standard.set(true, forKey: "creditcard_update_checked: \(row)")
                    }, label: {
                        VStack(spacing: 0) {
                            HStack {
                                if updated?.id == row {
                                    let checked = UserDefaults.standard.bool(forKey: "creditcard_update_checked: \(row)")
                                    Circle()
                                        .fill(
                                            !checked ? Color.red : Color.clear
                                        )
                                        .frame(width: 6, height: 6)
                                        .offset(x: 2, y: -8)
                                } else {
                                    Circle()
                                        .fill(Color.clear)
                                        .frame(width: 6, height: 6)
                                        .offset(x: 2, y: -8)
                                }
                                
                                Text(tabs[row])
                                    .font(.system(.headline))
                                    .foregroundColor(
                                    selectedTab == row
                                    ? .accentColor : .gray
                                    )
                                    .offset(x: -4, y: 0)
                            }
                            .frame(height: 52)
                            Rectangle()
                                .fill(
                                selectedTab == row
                                ? Color.secondary : Color.clear
                                )
                                .frame(height: 3)
                                .offset(x: 4, y: 0)
                        }
                    }
                )
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(height: 55)
    }
}

struct TabMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TabMenuView(tabs: ["지난달 결제", "이번달 결제", "다음달 결제"], selectedTab: .constant(1), updated: .constant(.currentMonth(amount: "10,000원")))
    }
    
}
```
<img width="469" alt="스크린샷 2024-01-18 오후 7 01 57" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/eac9be67-5433-4a70-bdb4-ea8693916e44">

```swift
struct TabMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TabMenuView(tabs: ["지난달 결제", "이번달 결제", "다음달 결제"], selectedTab: .constant(1), updated: .constant(.currentMonth(amount: "10,000원")))
    }
    
} //프리뷰 프로바이더
```

코드가 그리 어렵지 않아서 읽어보면 이해가 쉽게 가능하다.

VStack과 HStack을 왜 저렇게 겹쳐서 사용했는지 헷갈릴 수도 있는데, VStack으로 텍스트와 밑에 현재 탭을 표시할 바를 표시하고 HStack으로 텍스트와 마찬가지로 현재 탭의 업데이트 여부를 나타낼 붉은 원을 표시한다.

이제 여기다가 카드 섹션 뷰를 만들 것이다.

나타난 저건 지금 헤더일 뿐이고

헤더의 선택에 따라 내용이 변하는 섹션 뷰가 필요하겠다.

<img width="1224" alt="스크린샷 2024-01-18 오후 7 25 21" src="https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/ee1bd0fb-0710-408e-87e8-627ccc1ef859">



https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/6f50716f-7766-49d1-8d45-5491c5986c5f



그리고 AssetSummaryView의 body에 asset.type이 카드일 때는 새로 만들어 준 AssetCardSectionView를 나타내도록 switch문을 통해 설정해준다.

```swift
 
var body: some View {
        VStack(spacing: 20) {
            ForEach(assets) { asset in
                **switch asset.type {
                case .creditCard:
                    AssetCardSectionView(asset: asset)
                        .frame(idealHeight: 250)
                default:
                    AssetSectionView(assetSection: asset)
                }
            }**
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
        }
    }
```

## 실제 구동 화면



https://github.com/jinyongyun/MyAssets_Control_APP/assets/102133961/77a24835-1619-4585-81b8-35f7a7db0161


