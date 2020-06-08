import Foundation
import UIKit
import LocalAuthentication
import RESideMenu

class BaseController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
}

//MARK:- Helper Methods
extension BaseController{
    func setNavigationBar(){
        
        let currentClassName = Utilities.main.topViewController()?.className
        guard let navControllerCount = self.navigationController?.viewControllers.count else {return}
        
        if currentClassName == "RESideMenu" && navControllerCount == 1{
            self.navigationController?.navigationBar.isHidden = false
            self.addSideMenuBarButtonItem()
            
            return
        }
        
        else if navControllerCount > 1 {
            self.navigationController?.navigationBar.isHidden = true
            self.addBackBarButtonItem()

            //return
            
        } else {
            self.navigationController?.navigationBar.isHidden = false
            
        }

        self.resetNavigationBar()
    }
    
    func resetNavigationBar(){
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.black
    
    }
}

//MARK:- Navigation items
extension BaseController{
    func addBackBarButtonItem() {
        let image = UIImage(named: "Back")
        let backItem = UIBarButtonItem(image: image,
                                       style: .plain,
                                       target: self,
                                       action: #selector(self.onBtnBack))
        self.navigationItem.leftBarButtonItem = backItem
    }
    private func addSideMenuBarButtonItem() {
        let image = UIImage(named: "Menu")
        let sideMenuItem = UIBarButtonItem(image: image,
                                           style: .plain,
                                           target: self,
                                           action: #selector(self.onBtnSideMenu))
        
        self.navigationItem.leftBarButtonItem = sideMenuItem
    }
}

//MARK:- @objc Methods
extension BaseController{
    @objc func onBtnBack() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func onBtnSideMenu(){
        self.sideMenuViewController.presentLeftMenuViewController()
    }
}

//MARK:- Application flow
extension BaseController{
    //push and preseneted methods
}
extension UIViewController {
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!;
    }
}
