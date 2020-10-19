import UIKit

class WeatherVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tempView: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    let weatherLabels = ["Feels Like",
                         "Humidity",
                         "Pressure",
                         "UV Index",
                         "Visibility",
                         "Wind Speed",
                         "Cloudiness"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func assignbackground() {
        let background = UIImage(named: "Sky")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
}


extension WeatherVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
        cell.stockLabel.text = weatherLabels[indexPath.row]
        var weatherData = [String]()
        let jsonurl = "https://api.openweathermap.org/data/2.5/onecall?lat=44.1778&lon=-93.2650&units=imperial&%20exclude=current&appid=d0171f12b190c65cc15b154c84ecabde"
        
        guard let url = URL(string: jsonurl) else {
            return cell
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data, err == nil else {
                self.showAlert(title: "Network Error", message: "Error Retrieving Data",
                               handlerRefresh: { action in
                                self.viewDidLoad() },
                               handlerCloseApp: { actionCancel in
                                exit(0) })
                return
            }
            do {
                let overall = try JSONDecoder().decode(Overview.self, from: data)
                weatherData.append(String(Int(overall.current.feels_like)) + "°")
                weatherData.append(String(Int(overall.current.humidity)) + "%")
                weatherData.append(String(Int(round(overall.current.pressure))) + " hPa")
                weatherData.append(String(Int(overall.current.uvi)))
                weatherData.append((String(Int(round((overall.current.visibility) * 0.000621371)))) + " mi")
                weatherData.append(String(overall.current.wind_speed) + " mph")
                weatherData.append(String(Int(overall.current.clouds)) + "%")
                
                DispatchQueue.main.async{
                    cell.stockDeux.text = weatherData[indexPath.row]
                    self.tempLabel.text = String(Int(overall.current.temp)) + "°"
                }
            }
            catch {
                self.showAlert(title: "Network Error",
                               message: "Error Retrieving Data",
                               handlerRefresh: { action in
                                self.viewDidLoad()
                               },
                               handlerCloseApp: { actionCancel in
                                exit(0) })
            }
        }.resume()
        return cell
    }
}

extension WeatherVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherLabels.count
    }
}

