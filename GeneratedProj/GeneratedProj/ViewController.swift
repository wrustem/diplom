import UIKit

class ViewController: UIViewController {
    var width: CGFloat {
        view.frame.width
    }
    var height: CGFloat {
        view.frame.height
    }
    
    func createText(box: CGRect, text: String) {
        let v = UILabel()
        v.text = text
        v.font = UIFont.systemFont(ofSize: 10)
        
        v.frame = CGRect(
            x: width * box.minX,
            y: view.frame.height - height * box.maxY,
            width: width * box.width,
            height: height * box.height
        )
        
        view.addSubview(v)
    }
    
    func createUIView(box: CGRect, color: UIColor) {
        let v = UIView()
        v.backgroundColor = color
        v.frame = CGRect(
            x: width * box.minX,
            y: view.frame.height - height * box.maxY,
            width: width * box.width,
            height: height * box.height
        )
        view.addSubview(v)
    }
    
    func createSwitch(box: CGRect) {
        let v = UISwitch()
        v.frame = CGRect(
            x: width * box.minX,
            y: view.frame.height - height * box.maxY,
            width: width * box.width,
            height: height * box.height
        )
        view.addSubview(v)
    }
    
    func createSlider(box: CGRect) {
        let v = UISlider()
        v.frame = CGRect(
            x: width * box.minX,
            y: view.frame.height - height * box.maxY,
            width: width * box.width,
            height: height * box.height
        )
        view.addSubview(v)
    }
    
    func createUImage(box: CGRect, name: String) {
        let v = UIImageView()
        v.image = UIImage(named: name)!
        v.contentMode = .scaleAspectFit
        v.frame = CGRect(
            x: width * box.minX,
            y: view.frame.height - height * box.maxY,
            width: width * box.width,
            height: height * box.height
        )
        view.addSubview(v)
    }
    
    func createButton(box: CGRect, tag: Int, color: UIColor) {
        let v = UIButton()
        v.addTarget(self, action: #selector(openNewScreen(_:)), for: .touchUpInside)
        v.tag = tag
        v.backgroundColor = color
        v.frame = CGRect(
            x: width * box.minX,
            y: view.frame.height - height * box.maxY,
            width: width * box.width,
            height: height * box.height
        )
        view.addSubview(v)
    }
    
    @objc func openNewScreen(_ button: UIButton) {
        switch button.tag {
        case 0:
            present(ViewController(), animated: true)
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUIView(box: CGRect(x: 0.0, y: 0.832, width: 1.0, height: 0.200), color: UIColor.fromHex("#023C99", alpha: 1.0))
        createUImage(box: CGRect(x: 0.77, y: 0.905, width: 0.074, height: 0.035), name: "im9")
        createUImage(box: CGRect(x: 0.87, y: 0.905, width: 0.084, height: 0.035), name: "im8")
        createText(box:  CGRect(x: 0.367, y: 0.915, width: 0.254, height: 0.019), text: "Booking.com")
        createText(box:  CGRect(x: 0.075, y: 0.863, width: 0.162, height: 0.016), text: "3 Жилье")
        createText(box:  CGRect(x: 0.313, y: 0.863, width: 0.371, height: 0.016), text: "2 Аренда автомобилей")
        createText(box:  CGRect(x: 0.767, y: 0.863, width: 0.15, height: 0.014), text: "TAXI Такси")
        createUIView(box: CGRect(x: 0.017, y: 0.561, width: 0.967, height: 0.267), color: UIColor.fromHex("#FFFEFF", alpha: 1.0))
        createUIView(box: CGRect(x: 0.047, y: 0.579, width: 0.905, height: 0.06), color: UIColor.fromHex("#016DE7", alpha: 1.0))
        createUImage(box: CGRect(x: 0.050, y: 0.647, width: 0.054, height: 0.025), name: "im2")
        createText(box:  CGRect(x: 0.083, y: 0.647, width: 0.554, height: 0.027), text: "Я 1 номер. 2 взрослых. Без детей")
        createUIView(box: CGRect(x: 0.047, y: 0.755, width: 0.905, height: 0.06), color: UIColor.fromHex("#FFFEFF", alpha: 1.0))
        createText(box:  CGRect(x: 0.095, y: 0.774, width: 0.333, height: 0.025), text: "О Рядом со мной")
        createUImage(box: CGRect(x: 0.050, y: 0.774, width: 0.054, height: 0.025), name: "im2")
        createUIView(box: CGRect(x: 0.047, y: 0.693, width: 0.905, height: 0.06), color: UIColor.fromHex("#FFFEFF", alpha: 1.0))
        createUIView(box: CGRect(x: 0.083, y: 0.71, width: 0.059, height: 0.027), color: UIColor.fromHex("#FFFDFF", alpha: 1.0))
        createText(box:  CGRect(x: 0.108, y: 0.715, width: 0.437, height: 0.016), text: "- Чт, 15 июня - Пт, 16 июня")
        createUImage(box: CGRect(x: 0.050, y: 0.715, width: 0.054, height: 0.025), name: "im1")
        createText(box:  CGRect(x: 0.437, y: 0.599, width: 0.113, height: 0.016), text: "Найти")
        createUIView(box: CGRect(x: 0.626, y: 0.363, width: 0.374, height: 0.133), color: UIColor.fromHex("#FFFEFF", alpha: 1.0))
        createText(box:  CGRect(x: 0.654, y: 0.445, width: 0.237, height: 0.013), text: "Скидки 10-15%")
        createText(box:  CGRect(x: 0.654, y: 0.42, width: 0.342, height: 0.008), text: "Экономьте на вариантах жи")
        createText(box:  CGRect(x: 0.654, y: 0.399, width: 0.342, height: 0.012), text: "миру, участвующих в прогрі")
        createText(box:  CGRect(x: 0.654, y: 0.399, width: 0.342, height: 0.012), text: "миру, участвующих в прогрі")
        createUIView(box: CGRect(x: 0.037, y: 0.364, width: 0.563, height: 0.132), color: UIColor.fromHex("#023C99", alpha: 1.0))
        createText(box:  CGRect(x: 0.067, y: 0.455, width: 0.133, height: 0.019), text: "Genius")
        createText(box:  CGRect(x: 0.063, y: 0.428, width: 0.4, height: 0.014), text: "Rustem, ваш статус в нашей")
        createText(box:  CGRect(x: 0.063, y: 0.41, width: 0.471, height: 0.012), text: "программе лояльности - Genius")
        createText(box:  CGRect(x: 0.063, y: 0.391, width: 0.188, height: 0.012), text: "2-го уровня")
        createUIView(box: CGRect(x: 0.0, y: 0.089, width: 1.0, height: 0.206), color: UIColor.fromHex("#F7F4F7", alpha: 1.0))
        createUIView(box: CGRect(x: 0.519, y: 0.096, width: 0.443, height: 0.095), color: UIColor.fromHex("#FFFEFF", alpha: 1.0))
        createText(box:  CGRect(x: 0.529, y: 0.164, width: 0.358, height: 0.012), text: "-15% на жилье по миру")
        createUImage(box: CGRect(x: 0.519, y: 0.186, width: 0.443, height: 0.095), name: "im11")
        createUImage(box: CGRect(x: 0.019, y: 0.088, width: 0.443, height: 0.195), name: "im10")
        createText(box:  CGRect(x: 0.529, y: 0.146, width: 0.367, height: 0.012), text: "Сэкономьте на отпуске вашей")
        createText(box:  CGRect(x: 0.529, y: 0.146, width: 0.367, height: 0.012), text: "Сэкономьте на отпуске вашей")
        createText(box:  CGRect(x: 0.521, y: 0.129, width: 0.254, height: 0.012), text: "мечты с Сезонными")
        createText(box:  CGRect(x: 0.521, y: 0.129, width: 0.254, height: 0.012), text: "мечты с Сезонными")
        createText(box:  CGRect(x: 0.533, y: 0.112, width: 0.196, height: 0.01), text: "предложениями")
        createText(box:  CGRect(x: 0.533, y: 0.112, width: 0.196, height: 0.01), text: "предложениями")
        createUIView(box: CGRect(x: 0.345, y: 0.057, width: 0.058, height: 0.024), color: UIColor.fromHex("#FFFEFF", alpha: 1.0))
        createUIView(box: CGRect(x: 0.846, y: 0.056, width: 0.058, height: 0.027), color: UIColor.fromHex("#FFFEFF", alpha: 1.0))
        createUIView(box: CGRect(x: 0.092, y: 0.054, width: 0.061, height: 0.028), color: UIColor.fromHex("#FFFEFF", alpha: 1.0))
        createUIView(box: CGRect(x: 0.595, y: 0.057, width: 0.058, height: 0.025), color: UIColor.fromHex("#FFFDFF", alpha: 1.0))
        createUIView(box: CGRect(x: 0.32, y: 0.008, width: 0.36, height: 0.006), color: UIColor.fromHex("#020002", alpha: 1.0))
        createText(box:  CGRect(x: 0.013, y: 0.516, width: 0.842, height: 0.018), text: "Путешествуйте больше, тратьте меньше")
        createText(box:  CGRect(x: 0.654, y: 0.445, width: 0.237, height: 0.013), text: "Скидки 10-15%")
        createText(box:  CGRect(x: 0.029, y: 0.31, width: 0.163, height: 0.014), text: "Для вас")
        createUImage(box: CGRect(x: 0.095, y: 0.052, width:  0.084, height: 0.028), name: "im5")
        createText(box:  CGRect(x: 0.100, y: 0.042, width: 0.179, height: 0.008), text: "Найти")
        createUImage(box: CGRect(x: 0.329, y: 0.052, width:  0.084, height: 0.028), name: "im4")
        createText(box:  CGRect(x: 0.279, y: 0.042, width: 0.179, height: 0.008), text: "Сохраненное")
        createUImage(box: CGRect(x: 0.579, y: 0.052, width:  0.084, height: 0.028), name: "im6")
        createText(box:  CGRect(x: 0.529, y: 0.042, width: 0.199, height: 0.008), text: "Бронирования")
        createUImage(box: CGRect(x: 0.843, y: 0.052, width:  0.084, height: 0.028), name: "im7")
        createText(box:  CGRect(x: 0.813, y: 0.04, width: 0.117, height: 0.01), text: "Профиль")
    }
}

extension UIColor {
    static func fromHex(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        let hexString = hex.replacingOccurrences(of: "#", with: "").uppercased()
        var rgbValue: UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&rgbValue)
        
        let r = CGFloat((rgbValue >> 16) & 0xFF) / 255.0
        let g = CGFloat((rgbValue >> 8) & 0xFF) / 255.0
        let b = CGFloat(rgbValue & 0xFF) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}

import UIKit

class ThVC: UIViewController {
var width: CGFloat {
        view.frame.width
    }
    var height: CGFloat {
        view.frame.height
    }
    
    func createText(box: CGRect, text: String) {
        let v = UILabel()
        v.text = text
        v.font = UIFont.systemFont(ofSize: 10)
        
        v.frame = CGRect(
            x: width * box.minX,
            y: view.frame.height - height * box.maxY,
            width: width * box.width,
            height: height * box.height
        )
        
        view.addSubview(v)
    }
    
    func createUIView(box: CGRect, color: UIColor) {
        let v = UIView()
        v.backgroundColor = color
        v.frame = CGRect(
            x: width * box.minX,
            y: view.frame.height - height * box.maxY,
            width: width * box.width,
            height: height * box.height
        )
        view.addSubview(v)
    }
    
    func createSwitch(box: CGRect) {
        let v = UISwitch()
        v.frame = CGRect(
            x: width * box.minX,
            y: view.frame.height - height * box.maxY,
            width: width * box.width,
            height: height * box.height
        )
        view.addSubview(v)
    }
    
    func createSlider(box: CGRect) {
        let v = UISlider()
        v.frame = CGRect(
            x: width * box.minX,
            y: view.frame.height - height * box.maxY,
            width: width * box.width,
            height: height * box.height
        )
        view.addSubview(v)
    }
    
    func createUImage(box: CGRect, name: String) {
        let v = UIImageView()
        v.image = UIImage(named: name)!
        v.frame = CGRect(
            x: width * box.minX,
            y: view.frame.height - height * box.maxY,
            width: width * box.width,
            height: height * box.height
        )
        view.addSubview(v)
    }
    
    func createButton(box: CGRect, tag: Int, color: UIColor) {
        let v = UIButton()
        v.addTarget(self, action: #selector(openNewScreen(_:)), for: .touchUpInside)
        v.tag = tag
        v.backgroundColor = color
        v.frame = CGRect(
            x: width * box.minX,
            y: view.frame.height - height * box.maxY,
            width: width * box.width,
            height: height * box.height
        )
        view.addSubview(v)
    }
    
    @objc func openNewScreen(_ button: UIButton) {
        switch button.tag {
        case 0:
            break
        default:
            break
        }
    }

             override func viewDidLoad() {
              super.viewDidLoad()
             
createText(box:  CGRect(x: 0.367, y: 0.915, width: 0.254, height: 0.019), text: "Booking.com")
createText(box:  CGRect(x: 0.075, y: 0.863, width: 0.162, height: 0.016), text: "3 Жилье")
createText(box:  CGRect(x: 0.313, y: 0.863, width: 0.371, height: 0.016), text: "2 Аренда автомобилей")
createText(box:  CGRect(x: 0.767, y: 0.863, width: 0.15, height: 0.014), text: "TAXI Такси")
createUIView(box: CGRect(x: 0.017, y: 0.561, width: 0.967, height: 0.267), color: UIColor.fromHex("#FFFEFF", alpha: 1.0))
createUIView(box: CGRect(x: 0.047, y: 0.632, width: 0.905, height: 0.06), color: UIColor.fromHex("#949194", alpha: 1.0))
createText(box:  CGRect(x: 0.083, y: 0.647, width: 0.554, height: 0.027), text: "Я 1 номер. 2 взрослых. Без детей")
createUIView(box: CGRect(x: 0.047, y: 0.755, width: 0.905, height: 0.06), color: UIColor.fromHex("#FFFEFF", alpha: 1.0))
createText(box:  CGRect(x: 0.067, y: 0.774, width: 0.333, height: 0.025), text: "О Рядом со мной")
createUIView(box: CGRect(x: 0.047, y: 0.693, width: 0.905, height: 0.06), color: UIColor.fromHex("#FFFEFF", alpha: 1.0))
createUIView(box: CGRect(x: 0.083, y: 0.71, width: 0.059, height: 0.027), color: UIColor.fromHex("#FFFDFF", alpha: 1.0))
createText(box:  CGRect(x: 0.108, y: 0.715, width: 0.437, height: 0.016), text: "- Чт, 15 июня - Пт, 16 июня")
createText(box:  CGRect(x: 0.437, y: 0.599, width: 0.113, height: 0.016), text: "Найти")
createUIView(box: CGRect(x: 0.626, y: 0.363, width: 0.374, height: 0.133), color: UIColor.fromHex("#FFFEFF", alpha: 1.0))
createText(box:  CGRect(x: 0.654, y: 0.445, width: 0.237, height: 0.013), text: "Скидки 10-15%")
createText(box:  CGRect(x: 0.654, y: 0.42, width: 0.342, height: 0.008), text: "Экономьте на вариантах жи")
createText(box:  CGRect(x: 0.654, y: 0.399, width: 0.342, height: 0.012), text: "миру, участвующих в прогрі")
createText(box:  CGRect(x: 0.654, y: 0.399, width: 0.342, height: 0.012), text: "миру, участвующих в прогрі")
createUIView(box: CGRect(x: 0.037, y: 0.364, width: 0.563, height: 0.132), color: UIColor.fromHex("#B1BDD6", alpha: 1.0))
createText(box:  CGRect(x: 0.067, y: 0.455, width: 0.133, height: 0.019), text: "Genius")
createText(box:  CGRect(x: 0.063, y: 0.428, width: 0.4, height: 0.014), text: "Rustem, ваш статус в нашей")
createText(box:  CGRect(x: 0.063, y: 0.41, width: 0.471, height: 0.012), text: "программе лояльности - Genius")
createText(box:  CGRect(x: 0.063, y: 0.391, width: 0.188, height: 0.012), text: "2-го уровня")
createUIView(box: CGRect(x: 0.0, y: 0.089, width: 1.0, height: 0.206), color: UIColor.fromHex("#F7F4F7", alpha: 1.0))
createUIView(box: CGRect(x: 0.519, y: 0.096, width: 0.443, height: 0.095), color: UIColor.fromHex("#FFFEFF", alpha: 1.0))
createText(box:  CGRect(x: 0.529, y: 0.164, width: 0.358, height: 0.012), text: "-15% на жилье по миру")
createText(box:  CGRect(x: 0.529, y: 0.146, width: 0.367, height: 0.012), text: "Сэкономьте на отпуске вашей")
createText(box:  CGRect(x: 0.529, y: 0.146, width: 0.367, height: 0.012), text: "Сэкономьте на отпуске вашей")
createText(box:  CGRect(x: 0.521, y: 0.129, width: 0.254, height: 0.012), text: "мечты с Сезонными")
createText(box:  CGRect(x: 0.521, y: 0.129, width: 0.254, height: 0.012), text: "мечты с Сезонными")
createText(box:  CGRect(x: 0.533, y: 0.112, width: 0.196, height: 0.01), text: "предложениями")
createText(box:  CGRect(x: 0.533, y: 0.112, width: 0.196, height: 0.01), text: "предложениями")
createUIView(box: CGRect(x: 0.345, y: 0.057, width: 0.058, height: 0.024), color: UIColor.fromHex("#FFFEFF", alpha: 1.0))
createUIView(box: CGRect(x: 0.846, y: 0.056, width: 0.058, height: 0.027), color: UIColor.fromHex("#FFFEFF", alpha: 1.0))
createUIView(box: CGRect(x: 0.092, y: 0.054, width: 0.061, height: 0.028), color: UIColor.fromHex("#FFFEFF", alpha: 1.0))
createUIView(box: CGRect(x: 0.595, y: 0.057, width: 0.058, height: 0.025), color: UIColor.fromHex("#FFFDFF", alpha: 1.0))
createUIView(box: CGRect(x: 0.32, y: 0.008, width: 0.36, height: 0.006), color: UIColor.fromHex("#020002", alpha: 1.0))
createText(box:  CGRect(x: 0.013, y: 0.516, width: 0.842, height: 0.018), text: "Путешествуйте больше, тратьте меньше")
createText(box:  CGRect(x: 0.654, y: 0.445, width: 0.237, height: 0.013), text: "Скидки 10-15%")
createText(box:  CGRect(x: 0.029, y: 0.31, width: 0.163, height: 0.014), text: "Для вас")
createText(box:  CGRect(x: 0.529, y: 0.042, width: 0.179, height: 0.008), text: "Бронирования")
createText(box:  CGRect(x: 0.813, y: 0.04, width: 0.117, height: 0.01), text: "Профиль")
          }
          
      }
