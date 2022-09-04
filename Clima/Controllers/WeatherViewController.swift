//
//  WeatherViewController.swift
//  Clima
//
//  Created by Victor Tejeda on 3/9/22.
//

import UIKit
import CoreLocation


// aqui trabajamos con el delegado y protocolos.
class WeatherViewController: UIViewController {
    
    @IBOutlet weak var condiciónImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var busquedaTextField: UITextField!
    
    var administradorClima = AdministradorClima()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        administradorClima.delegate = self
        busquedaTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    @IBAction func locationPressed(_ sender: UIButton) {
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func buscarPressed(_ sender: UIButton) {
        busquedaTextField.endEditing(true)
        
    }
    //esta funcion es para que nos impprima en la consola lo que no nosotros digitemos en nuestro sponlait de buscar.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        busquedaTextField.endEditing(true)
        return true
    }
    // esta funcion es para que retorne el teclado es decir cuando pongamos algo.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Escribe algo"
            return false
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let ciudad = busquedaTextField.text {
            administradorClima.tiempoReal(nombreCiudad: ciudad)
        }
        
        // sea lo que sea que el usuario haya ingresado aquI PARA conocer el clima de esta ciudad.
        busquedaTextField.text = ""
    }
}

//MARK: - administradorClimaDelegate

extension WeatherViewController: AdministradorClimaDelegate {
    
    func didUpdateWeather(_ administradorClima: AdministradorClima, weather: ModeloMeteorológico) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.condiciónImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      if  let location = locations.last {
          locationManager.startUpdatingLocation()
            let lat = location.coordinate.longitude
            let lon = location.coordinate.latitude
          administradorClima.tiempoReal(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

