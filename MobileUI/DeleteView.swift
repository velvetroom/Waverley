import UIKit

class DeleteView:UIViewController {
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
        view.addSubview(blur)
        
        let back = UIControl()
        back.translatesAutoresizingMaskIntoConstraints = false
        back.addTarget(self, action:#selector(close), for:.touchUpInside)
        view.addSubview(back)
        
        let delete = UIButton()
        delete.setBackgroundImage(#imageLiteral(resourceName: "button.pdf"), for:[])
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.addTarget(self, action:#selector(remove), for:.touchUpInside)
        delete.setTitle(.local("DeleteView.delete"), for:.normal)
        delete.setTitleColor(.black, for:.normal)
        delete.setTitleColor(UIColor(white:0, alpha:0.3), for:.highlighted)
        delete.titleLabel!.font = .systemFont(ofSize:14, weight:.medium)
        view.addSubview(delete)
        
        let cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.addTarget(self, action:#selector(close), for:.touchUpInside)
        cancel.setTitle(.local("DeleteView.cancel"), for:.normal)
        cancel.setTitleColor(.white, for:.normal)
        cancel.setTitleColor(UIColor(white:1, alpha:0.3), for:.highlighted)
        cancel.titleLabel!.font = .systemFont(ofSize:13, weight:.medium)
        view.addSubview(cancel)
        
        blur.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        back.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        back.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        back.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        back.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        delete.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        delete.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        delete.widthAnchor.constraint(equalToConstant:92).isActive = true
        delete.heightAnchor.constraint(equalToConstant:34).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo:delete.bottomAnchor).isActive = true
        cancel.widthAnchor.constraint(equalToConstant:100).isActive = true
        cancel.heightAnchor.constraint(equalToConstant:60).isActive = true
    }
    
    @objc private func close() {
        view.isUserInteractionEnabled = false
        presentingViewController!.dismiss(animated:true)
    }
    
    @objc private func remove() {
        presenter.delete()
        close()
    }
}
