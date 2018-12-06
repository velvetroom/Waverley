import AppKit
import Desktop

class PreviewView:NSWindow {
    private weak var text:NSTextView!
    override var canBecomeKey:Bool { return true }
    
    init(_ note:Note) {
        super.init(contentRect:NSRect(x:0, y:0, width:550, height:400), styleMask:
            [.fullSizeContentView], backing:.buffered, defer:false)
        
        let cancel = NSButton(title:.local("PreviewView.cancel"), target:self, action:#selector(self.cancel))
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.isBordered = false
        cancel.font = .systemFont(ofSize:14, weight:.medium)
        cancel.keyEquivalent = "\u{1b}"
        contentView!.addSubview(cancel)
        
        let pdf = NSButton(image:NSImage(named:"button")!, target:self, action:#selector(self.pdf))
        pdf.isBordered = false
        pdf.translatesAutoresizingMaskIntoConstraints = false
        pdf.imageScaling = .scaleNone
        pdf.keyEquivalent = "\r"
        pdf.attributedTitle = NSAttributedString(string:.local("PreviewView.pdf"), attributes:
            [.font:NSFont.systemFont(ofSize:14, weight:.medium), .foregroundColor:NSColor.black])
        contentView!.addSubview(pdf)
        
        let scroll = NSScrollView(frame:.zero)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.drawsBackground = false
        contentView!.addSubview(scroll)
        
        let text = NSTextView(frame:NSRect(x:0, y:0, width:470, height:0))
        text.isVerticallyResizable = true
        text.isHorizontallyResizable = false
        text.drawsBackground = false
        text.isEditable = false
        text.isRichText = false
        text.isSelectable = false
        scroll.documentView = text
        self.text = text
        
        scroll.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:30).isActive = true
        scroll.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-90).isActive = true
        scroll.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:40).isActive = true
        scroll.rightAnchor.constraint(equalTo:contentView!.rightAnchor, constant:-40).isActive = true
        
        cancel.rightAnchor.constraint(equalTo:pdf.leftAnchor, constant:-40).isActive = true
        cancel.centerYAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-40).isActive = true
        
        pdf.rightAnchor.constraint(equalTo:contentView!.rightAnchor, constant:-30).isActive = true
        pdf.centerYAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-40).isActive = true
        
        text.textStorage!.append(Printer.print(note.content, size:12))
        text.textColor = .textColor
    }
    
    @objc private func cancel() {
        Application.window.endSheet(Application.window.attachedSheet!)
    }
    
    @objc private func pdf() {
        cancel()
        let save = NSSavePanel()
        save.nameFieldStringValue = "Waverley"
        save.allowedFileTypes = ["pdf"]
        save.beginSheetModal(for:Application.window) { response in
            if response == .OK {
                self.exportPdf(save.url!)
            }
        }
    }
    
    private func exportPdf(_ url:URL) {
        text.textColor = .black
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
