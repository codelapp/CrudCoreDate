import UIKit
import CoreData

class EditarViewController: UIViewController {

    @IBOutlet weak var editartxtNombre: UITextField!
    @IBOutlet weak var editartxtEdad: UITextField!
    @IBOutlet weak var editarSwitch: UISwitch!
    
    var personaEditar: Personas! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        editartxtNombre.text = personaEditar.nombre
        editartxtEdad.text = "\(personaEditar.edad)"
        
        if personaEditar.activo {
            editarSwitch.isOn = true
        } else {
            editarSwitch.isOn = false
        }
    }
    
    func conexion() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    @IBAction func btnEditar(_ sender: UIButton) {
        let contexto = conexion()

        let edadPersona = Int16(editartxtEdad.text!)
        personaEditar.setValue(editartxtNombre.text, forKey: "nombre")
        personaEditar.setValue(edadPersona, forKey: "edad")
        personaEditar.setValue(editarSwitch.isOn, forKey: "activo")
        
        do {
            try contexto.save()
            print("Registro actualizado")
            performSegue(withIdentifier: "volverTabla", sender: self)
        } catch let error as Error {
            print("Error al guardar: ", error)
        }
    }
    
}
