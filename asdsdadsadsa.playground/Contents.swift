import UIKit


class AnyWrapperEraser<T: AnyObject> {
    
    var store: T?
    
    init(instance: T?) {
        self.store = instance
    }
}

class SomeClass {
    var name: String
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("deinit")
    }
}
var instance: SomeClass? = SomeClass(name: "Name")
var obj: AnyWrapperEraser = AnyWrapperEraser(instance: instance)
let arr: [AnyWrapperEraser?] = [obj]
instance = nil
//obj?.name = "adsads"
print(arr[0]?.store?.name)
