import AppKit
import Desktop

class PreviewView:NSWindow {
    private weak var text:NSTextView!
    override var canBecomeKey:Bool { return true }
    
    init(_ note:Note) {
        super.init(contentRect:NSRect(x:0, y:0, width:550, height:Application.window!.frame.height),
                   styleMask:[], backing:.buffered, defer:false)
        
        let background = NSView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.wantsLayer = true
        background.layer!.backgroundColor = NSColor.textBackgroundColor.withAlphaComponent(0.5).cgColor
        contentView!.addSubview(background)
        
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
        text.textStorage!.append(Printer.print(note.content, size:12))
        text.textColor = .textColor
        scroll.documentView = text
        self.text = text
        
        background.topAnchor.constraint(equalTo:contentView!.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-80).isActive = true
        background.leftAnchor.constraint(equalTo:contentView!.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo:contentView!.rightAnchor).isActive = true
        
        scroll.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:30).isActive = true
        scroll.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-80).isActive = true
        scroll.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:40).isActive = true
        scroll.rightAnchor.constraint(equalTo:contentView!.rightAnchor, constant:-40).isActive = true
        
        cancel.rightAnchor.constraint(equalTo:pdf.leftAnchor, constant:-40).isActive = true
        cancel.centerYAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-40).isActive = true
        
        pdf.rightAnchor.constraint(equalTo:contentView!.rightAnchor, constant:-30).isActive = true
        pdf.centerYAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-40).isActive = true
    }
    
    @objc private func cancel() {
        Application.window.endSheet(self)
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
        let print = NSPrintOperation(view:text, printInfo:NSPrintInfo(dictionary:[.jobSavingURL:url]))
        print.printInfo.paperSize = NSMakeSize(612, 792)
        print.printInfo.jobDisposition = .save
        print.printInfo.topMargin = 71
        print.printInfo.leftMargin = 71
        print.printInfo.rightMargin = 71
        print.printInfo.bottomMargin = 71
        print.printInfo.isVerticallyCentered = false
        print.printInfo.isHorizontallyCentered = false
        print.showsPrintPanel = false
        print.showsProgressPanel = false
        print.run()
    }
}
