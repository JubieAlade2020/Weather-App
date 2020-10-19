struct Overview: Decodable {
    let lat: Double
    let lon: Double
    let current: Current
}

struct Current: Decodable {
    let temp: Double
    let feels_like: Double
    let humidity: Double
    let pressure: Double
    let uvi: Double
    let visibility: Double
    let wind_speed: Double
    let clouds: Double
}
