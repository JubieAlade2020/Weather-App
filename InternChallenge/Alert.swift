import UIKit

extension UIViewController {
    func showAlert (title: String, message: String, handlerRefresh: ((UIAlertAction) -> Void)?, handlerCloseApp: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Retry", style: .default , handler: handlerRefresh)
        alert.addAction(action)
        let actionCancel = UIAlertAction(title: "Close App", style: .destructive, handler: handlerCloseApp)
        alert.addAction(actionCancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
