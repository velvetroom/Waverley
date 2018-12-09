import AppKit
import Desktop

class Presenter {
    weak var selected:ItemView! {
        willSet {
            if let previous = selected {
                previous.selected = false
            }
        }
        didSet {
            selected.selected = true
            saveIfNeeded()
        }
    }
    
    var notes:(([Note]) -> Void)!
    var select:((Note) -> Void)!
    private weak var timer:Timer?
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
        Application.window.beginSheet(DeleteView()) { response in
            if response == .continue {
                self.repository.delete(self.selected.note)
                self.updateAndSelect()
            }
        }
    }
    
    func share() {
        saveIfNeeded()
        Application.window.beginSheet(PreviewView(selected.note))
    }
    
    func next() {
        repository.next(selected.note)
    }
    
    func previous() {
        repository.previous(selected.note)
    }
    
    func saveIfNeeded() {
        timer?.fire()
    }
    
    private func updateAndSelect() {
//        notes(notesSorted)
//        select(note)
    }
    
    private func update(_ note:Note, content:String) {
        timer = Timer.scheduledTimer(withTimeInterval:5, repeats:false) { timer in
            if timer.isValid {
                self.repository.update(note, content:content)
            }
        }
    }
}
