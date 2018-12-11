import Foundation
import Mobile
import StoreKit

class Presenter {
    weak var selected:ItemView! {
        willSet {
            if let previous = selected {
                previous.isSelected = false
            }
        }
        didSet {
            selected.isSelected = true
            saveIfNeeded()
        }
    }
    
    var update:(([Note]) -> Void)!
    var select:((Note) -> Void)!
    var scrollToTop:(() -> Void)!
    private weak var timer:Timer?
    private let repository = Factory.makeRepository()
    
    init() {
        repository.update = { notes in DispatchQueue.main.async { self.update(notes) } }
        repository.select = { note in DispatchQueue.main.async { self.select(note) } }
    }
    
    func load() {
        DispatchQueue.global(qos:.background).async {
            self.repository.load()
            self.repository.startSynch()
        }
    }
    
    func update(_ content:String) {
        timer?.invalidate()
        selected.update(content)
        update(selected.note, content:content)
    }
    
    func new() {
        saveIfNeeded()
        repository.newNote()
        if repository.rate() { if #available(iOS 10.3, *) { SKStoreReviewController.requestReview() } }
    }
    
    func delete() {
        repository.delete(selected.note)
        scrollToTop()
    }
    
    func saveIfNeeded() {
        timer?.fire()
    }
    
    private func update(_ note:Note, content:String) {
        timer = Timer.scheduledTimer(timeInterval:5, target:self, selector:#selector(timeout(timer:)), userInfo:
            ["note":note, "content":content], repeats:false)
    }
    
    @objc private func timeout(timer:Timer) {
        if timer.isValid {
            let info = timer.userInfo as! [String:Any]
            repository.update(info["note"] as! Note, content:info["content"] as! String)
        }
    }
}
