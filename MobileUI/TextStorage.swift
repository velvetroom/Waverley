import UIKit

class TextStorage:NSTextStorage {
    weak var view:TextView!
    override var string:String { return storage.string }
    private var process = 0
    private let queue = DispatchQueue(label:String(), qos:.background, target:.global(qos:.background))
    private let storage = NSTextStorage()
    
    override func attributes(at location:Int, effectiveRange range:NSRangePointer?) -> [NSAttributedString.Key:Any] {
        return storage.attributes(at:location, effectiveRange:range)
    }
    
    override func replaceCharacters(in range:NSRange, with str:String) {
        storage.replaceCharacters(in:range, with:str)
        edited(.editedCharacters, range:range, changeInLength:(str as NSString).length - range.length)
    }
    
    override func setAttributes(_ attrs:[NSAttributedString.Key:Any]?, range:NSRange) {
        storage.setAttributes(attrs, range:range)
    }
    
    override func processEditing() {
        queue.suspend()
        process += 1
        super.processEditing()
        
        let current = process
        queue.async {
            let ranges = self.ranges(self.storage.string, process:current)
            self.queue.async {
                DispatchQueue.main.async {
                    self.updates(ranges, process:current)
                }
            }
        }
        queue.resume()
    }
    
    private func ranges(_ string:String, process:Int) -> ([NSRange], [NSRange]) {
        var lights = [NSRange]()
        var bolds = [NSRange]()
        var start = string.startIndex
        while process == self.process,
            let index = string[start...].firstIndex(of:"#") {
                lights.append(NSRange(start..<index, in:string))
                if let endHeading = string[index...].firstIndex(of:"\n") {
                    bolds.append(NSRange(index...endHeading, in:string))
                    start = endHeading
                } else {
                    bolds.append(NSRange(index..., in:string))
                    start = string.endIndex
                }
        }
        lights.append(NSRange(start..., in:string))
        return (lights, bolds)
    }
    
    private func updates(_ ranges:([NSRange], [NSRange]), process:Int) {
        if process == self.process {
            storage.removeAttribute(.font, range:NSMakeRange(0, storage.length))
            if process == self.process {
                ranges.0.forEach { storage.addAttribute(.font, value:UIFont.editorLight(16), range:$0) }
                if process == self.process {
                    ranges.1.forEach { storage.addAttribute(.font, value:UIFont.editorBold(16), range:$0) }
                    view.setNeedsDisplay()
                }
            }
        }
    }
}
