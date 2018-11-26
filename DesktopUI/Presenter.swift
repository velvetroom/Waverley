import Cocoa
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
    
    init() {
        Factory.storage = Storage()
    }
    
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
        saveIfNeeded()
        Application.window.beginSheet(DeleteView()) { response in
            if response == .continue {
                self.repository.delete(self.selected.note)
                self.updateAndSelect()
            }
        }
    }
    
    func share() {
        saveIfNeeded()
        let save = NSSavePanel()
        save.nameFieldStringValue = "Waverley"
        save.allowedFileTypes = ["pdf"]
        save.beginSheetModal(for:Application.window) { response in
            if response == .OK {
                self.exportPdf(save.url!)
            }
        }
    }
    
    func saveIfNeeded() {
        timer?.fire()
    }
    
    private func updateAndSelect() {
        let note = repository.editing()
        updateNotes()
        select(note)
    }
    
    private func updateNotes() {
        notes(repository.notes.values.sorted(by: { $0.created > $1.created }))
    }
    
    private func update(_ note:Note, content:String) {
        timer = Timer.scheduledTimer(withTimeInterval:5, repeats:false) { timer in
            if timer.isValid {
                self.repository.update(note, content:content)
            }
        }
    }
    
    private func exportPdf(_ url:URL) {
        let text = NSTextView(frame:NSRect(x:0, y:0, width:470, height:0))
        text.isVerticallyResizable = true
        text.isHorizontallyResizable = false
        text.textStorage!.append(Markdown().parse(string:selected.note.content))
        
        let printInfo = NSPrintInfo(dictionary:[.jobSavingURL:url])
        let printOp = NSPrintOperation(view:text, printInfo:printInfo)
        printOp.printInfo.paperSize = NSMakeSize(612, 792)
        printOp.printInfo.jobDisposition = .save
        printOp.printInfo.topMargin = 71
        printOp.printInfo.leftMargin = 71
        printOp.printInfo.rightMargin = 71
        printOp.printInfo.bottomMargin = 71
        printOp.printInfo.isVerticallyCentered = false
        printOp.printInfo.isHorizontallyCentered = false
        printOp.showsPrintPanel = false
        printOp.showsProgressPanel = false
        printOp.run()
    }
}
