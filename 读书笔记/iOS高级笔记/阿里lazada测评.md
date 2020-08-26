写一个单例类。假如有一个类GlobalSys，请写出这个类的单例的懒汉式实现方法：
注意：假定此类为高频使用的基础类，且尽量减少使用方的约束；另外不能使用dispatch_once

```
Class GlobalSys {
	static let shareInstance = GlobalSys()
    private override init() {
    	super.init()
    }
}

@interface GlobalSys : NSObject {
+(instance)shareInstance;
}

@implementation GlobalSys {
	+(instance)shareInstance {
		

​```
}
​```

}
```




已知两个升序列表,L1,L2,请将两个有序列表合并成一个升序列表

```
@interface Node : NSObject
@property (nonatomic, assign) int value; 
@property (nonatomic, strong) Node *nextNode;
@end

- (Node *)merge:(Node *)orderedList with:(Node *)orderedList2 {
  //TODO: 合并orderedList1, orderedList2返回合并后的orderedList
    Node * dummy = [[Node alloc] init];

    Node * first = orderedList;
    Node * second = orderedList2;
    Node * p = dummy;
    while first != nil && second != nil {
    	if (first.value <= second.value) {
        	p.nextNode = first;
            first = first.nextNode;
        }else{
        	p.nextNode = second;
            second = second.nextNode;
        }
        p = p.nextNode;
    }

    if first == nil {
    	p.nextNode = second;
    }else{
    	p.nextNode = first;
    }

    return dummy.nextNode;
  }
```




给定两个二叉树，编写一个函数来检验它们是否相同，要求：
1. 如果val相等，并且各级子树对齐的val也完全相等，则认为它们是相同的

```
@interface TreeNode : NSObject
@property (nonatomic, assign) int val; 
@property (nonatomic, strong) TreeNode *left; 
@property (nonatomic, strong) TreeNode *right;
@end

- (boolean)isSameTree:(TreeNode *)p with:(TreeNode *)q {
  //TODO: 实现判断逻辑
  if (p == nil && q == nil) {
  	return false;
  }else if (p == nil || q == nil) {
  	return false;
  }else{
  	//两个都不为nil
      if (q.val != p.val) {
      	return false;
      }
      

  ```
  return [self isSameTree:p.left with:q.left] && 
  [self isSameTree:p.right with:q.right];
  ```

  }
 }
```

