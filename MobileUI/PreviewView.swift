import UIKit

class PreviewView:UIViewController {
    private weak var presenter:Presenter!
    private weak var text:UITextView!
    
    init(_ presenter:Presenter) {
        self.presenter = presenter
        super.init(nibName:nil, bundle:nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        makeOutlets()
    }
    
    private func makeOutlets() {
        let blur = UIVisualEffectView(effect:UIBlurEffect(style:.dark))
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.isUserInteractionEnabled = false
        view.addSubview(blur)
        
        let back = UIControl()
        back.translatesAutoresizingMaskIntoConstraints = false
        back.addTarget(self, action:#selector(self.close), for:.touchUpInside)
        view.addSubview(back)
        
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .scottShade
        text.text = presenter.selected.note.content
        text.isEditable = false
        text.alwaysBounceVertical = true
        text.indicatorStyle = .white
        text.contentInset = .zero
        text.textContainerInset = UIEdgeInsets(top:40, left:20, bottom:40, right:20)
        text.attributedText = Printer.print(presenter.selected.note.content, size:16)
        text.textColor = .white
        view.addSubview(text)
        self.text = text
        
        let border = UIView()
        border.isUserInteractionEnabled = false
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = .black
        view.addSubview(border)
        
        let pdf = UIButton()
        pdf.backgroundColor = .scottBlue
        pdf.translatesAutoresizingMaskIntoConstraints = false
        pdf.addTarget(self, action:#selector(self.pdf), for:.touchUpInside)
        pdf.setTitle(.local("PreviewView.pdf"), for:.normal)
        pdf.setTitleColor(.black, for:.normal)
        pdf.setTitleColor(UIColor(white:0, alpha:0.3), for:.highlighted)
        pdf.titleLabel!.font = .systemFont(ofSize:13, weight:.bold)
        pdf.layer.cornerRadius = 25
        view.addSubview(pdf)
        
        let close = UIButton()
        close.translatesAutoresizingMaskIntoConstraints = false
        close.addTarget(self, action:#selector(self.close), for:.touchUpInside)
        close.setTitle(.local("PreviewView.close"), for:.normal)
        close.setTitleColor(.white, for:.normal)
        close.setTitleColor(UIColor(white:1, alpha:0.3), for:.highlighted)
        close.titleLabel!.font = .systemFont(ofSize:13, weight:.regular)
        view.addSubview(close)
        
        blur.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        back.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        back.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        back.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        back.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        text.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        text.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        text.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        text.bottomAnchor.constraint(equalTo:pdf.topAnchor, constant:-30).isActive = true
        
        border.topAnchor.constraint(equalTo:text.bottomAnchor).isActive = true
        border.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        border.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant:1).isActive = true
        
        pdf.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        pdf.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant:-30).isActive = true
        pdf.widthAnchor.constraint(equalToConstant:50).isActive = true
        pdf.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        close.rightAnchor.constraint(equalTo:pdf.leftAnchor).isActive = true
        close.centerYAnchor.constraint(equalTo:pdf.centerYAnchor).isActive = true
        close.widthAnchor.constraint(equalToConstant:100).isActive = true
        close.heightAnchor.constraint(equalToConstant:40).isActive = true
        
        if #available(iOS 11.0, *) {
            text.contentInsetAdjustmentBehavior = .never
        }
    }
    
    private func save() -> URL {
        let formatter = UISimpleTextPrintFormatter(attributedText:text.attributedText)
        formatter.color = .black
        let renderer = UIPrintPageRenderer()
        renderer.addPrintFormatter(formatter, startingAtPageAt:0)
        
        let size = CGSize(width:612, height:792)
        let margins = UIEdgeInsets(top:71, left:71, bottom:71, right:71)
        let rect = CGRect(x:0, y:0, width:size.width, height:size.height)
        renderer.setValue(NSValue(cgRect:rect), forKey:"paperRect")
        renderer.setValue(NSValue(cgRect:CGRect(x:margins.left, y:margins.top, width:size.width - margins.left -
            margins.right, height:size.height - margins.top - margins.bottom)), forKey:"printableRect")
        
        let data = NSMutableData()
        UIGraphicsBeginPDFContextToData(data, rect, nil)
        renderer.prepare(forDrawingPages:NSMakeRange(0, renderer.numberOfPages))
        let bounds = UIGraphicsGetPDFContextBounds()
        for i in 0 ..< renderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            renderer.drawPage(at:i, in:bounds)
        }
        UIGraphicsEndPDFContext()
        
        let url = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("waverley.pdf")
        try! data.write(to:url)
        return url
    }
    
    @objc private func close() {
        presentingViewController!.dismiss(animated:true)
    }
    
    @objc private func pdf() {
        let activity = UIActivityViewController(activityItems:[save()], applicationActivities:nil)
        if let popover = activity.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = .zero
            popover.permittedArrowDirections = .any
        }
        let view = presentingViewController!
        view.dismiss(animated:true) {
            view.present(activity, animated:true)
        }
    }
}
