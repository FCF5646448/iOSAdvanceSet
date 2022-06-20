//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

class TPScrollStackView: UIView {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.spacing = self.spacing
        stackView.alignment = self.alignment
        stackView.axis = self.axis
        stackView.distribution = .equalSpacing
        return stackView
    }()
    /// StackVie的设置
    let spacing: CGFloat // stackView.spacing
    let alignment: UIStackView.Alignment // Alignment
    let axis: NSLayoutConstraint.Axis // 默认左右滑
    let height: CGFloat
    
    init(height: CGFloat,
         spacing: CGFloat = 0.0,
         alignment: UIStackView.Alignment = .leading,
         axis: NSLayoutConstraint.Axis = .horizontal) {
        self.height = height
        self.spacing = spacing
        self.alignment = alignment
        self.axis = axis
        super.init(frame: .zero)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(self.height)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.left.right.equalToSuperview()
        }
    }
}
