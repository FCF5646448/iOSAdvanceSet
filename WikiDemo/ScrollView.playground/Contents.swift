//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class InfiniteScrollView: UIScrollView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var curr = contentOffset
        
        if curr.x < 0 {
            curr.x = contentSize.width - frame.width
            contentOffset = curr
        } else if curr.x >= contentSize.width - frame.width {
            curr.x = 0
            contentOffset = curr
        }
    }
}


class MyViewController : UIViewController {
    let infiniteScrollView = InfiniteScrollView()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infiniteScrollView.frame = CGRect(x: 0, y: 200, width: 375, height: 200)
        view.addSubview(infiniteScrollView)
        addVisualIndicators()
    }
    
    func addVisualIndicators() {
        let count = 20
        
        //the gap between indicators
        let gap = 150.0
        
        //initial offset because we're positioning from the center of each indicator's view
        let dx = 40.0
        
        //the calculated total width of the view's contentSize
        let width = Double(count + 1) * gap + dx
        
        //create main indicators
        for x in 0...count {
            //create a center point for the new indicator
            let point = CGPoint(x: Double(x) * gap, y: infiniteScrollView.center.y)
            //create a new indicator
            createIndicator("\(x)", at: point)
        }
        
        //create additional indicators
        var x : Int = 0
        
        //create an offset variable
        var offset: CGFloat = dx
        
        //The total width (including the last "view" of the infiniteScrollView is based on the width + screen width
        //So, the total width and count of how many "extra" indicators to add is somewhat arbitrary
        //This is why we use a while loop
        //while the offset is less than the view's width
        while offset < Double(infiniteScrollView.frame.size.width) {
            //create a center point whose x value starts is the total width + the current offset
            let point = CGPoint(x: CGFloat(width + offset), y: infiniteScrollView.center.y)
            //create the width
            createIndicator("\(x)", at: point)
            //increase the offset for the next point
            offset += gap
            //increate x to be used as the variable for the next indicator's number
            x += 1
        }
        
        //update infiniteScrollView contentSize
        infiniteScrollView.contentSize = CGSize(width: CGFloat(width) + infiniteScrollView.frame.size.width, height: 200)
    }
    
    func createIndicator(_ text: String, at point: CGPoint) {
        //create a textshape
        let ts = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 200))
        ts.text = text
        ts.font = UIFont.systemFont(ofSize: 20)
        ts.textColor = .red
        //center the shape
        ts.center = point
        //add it to the canvas
        infiniteScrollView.addSubview(ts)
    }
}




// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
