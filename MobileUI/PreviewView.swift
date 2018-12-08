import UIKit

class PreviewView:UIViewController {
    private weak var presenter:Presenter!
    
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
        blur.alpha = 0.9
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
        text.layer.cornerRadius = 6
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.black.cgColor
        text.alwaysBounceVertical = true
        text.indicatorStyle = .white
        text.contentInset = .zero
        text.textContainerInset = UIEdgeInsets(top:20, left:20, bottom:20, right:20)
        text.attributedText = Printer.print(presenter.selected.note.content, size:12)
        text.textColor = .white
        view.addSubview(text)
        
        let pdf = UIButton()
        pdf.backgroundColor = .scottBlue
        pdf.translatesAutoresizingMaskIntoConstraints = false
        pdf.addTarget(self, action:#selector(self.pdf), for:.touchUpInside)
        pdf.setTitle(.local("PreviewView.pdf"), for:.normal)
        pdf.setTitleColor(.black, for:.normal)
        pdf.setTitleColor(UIColor(white:0, alpha:0.3), for:.highlighted)
        pdf.titleLabel!.font = .systemFont(ofSize:15, weight:.bold)
        pdf.layer.cornerRadius = 4
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
        
        text.leftAnchor.constraint(equalTo:view.leftAnchor, constant:5).isActive = true
        text.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-5).isActive = true
        text.bottomAnchor.constraint(equalTo:pdf.topAnchor, constant:-30).isActive = true
        
        pdf.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        pdf.bottomAnchor.constraint(equalTo:close.topAnchor, constant:-10).isActive = true
        pdf.widthAnchor.constraint(equalToConstant:100).isActive = true
        pdf.heightAnchor.constraint(equalToConstant:40).isActive = true
        
        close.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        close.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant:-20).isActive = true
        close.widthAnchor.constraint(equalTo:pdf.widthAnchor).isActive = true
        close.heightAnchor.constraint(equalTo:pdf.heightAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            text.contentInsetAdjustmentBehavior = .never
            text.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant:20).isActive = true
        } else {
            text.topAnchor.constraint(equalTo:view.topAnchor, constant:20).isActive = true
        }
    }
    
    @objc private func close() {
        view.isUserInteractionEnabled = false
        presentingViewController!.dismiss(animated:true)
    }
    
    @objc private func pdf() {

    }
}
