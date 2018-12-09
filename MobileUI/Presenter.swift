import Foundation
import Mobile

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
    
    var notes:(([Note]) -> Void)!
    var select:((Note) -> Void)!
    var scrollToTop:(() -> Void)!
    private weak var timer:Timer?
    private var notesSorted:[Note] { return repository.notes.values.sorted(by: { $0.created > $1.created }) }
    private let repository = Factory.makeRepository()
    
    func load() {
        DispatchQueue.global(qos:.background).async {
            self.repository.load()
            DispatchQueue.main.async {
                self.updateAndSelect()
            }
        }
    }
    
    func update(_ content:String) {
        timer?.invalidate()
        selected.update(content)
        update(selected.note, content:content)
    }
    
    func new() {
        saveIfNeeded()
        updateAndSelect()
    }
    
    func delete() {
        repository.delete(selected.note)
        updateAndSelect()
        scrollToTop()
    }
    
    func saveIfNeeded() {
        timer?.fire()
    }
    
    private func updateAndSelect() {
        let note = repository.editing()
        notes(notesSorted)
        select(note)
    }
    
    private func update(_ note:Note, content:String) {
        timer = Timer.scheduledTimer(timeInterval:0.9, target:self, selector:#selector(timeout(timer:)), userInfo:
            ["note":note, "content":content], repeats:false)
    }
    
    @objc private func timeout(timer:Timer) {
        if timer.isValid {
            let info = timer.userInfo as! [String:Any]
            repository.update(info["note"] as! Note, content:info["content"] as! String)
        }
    }
}
