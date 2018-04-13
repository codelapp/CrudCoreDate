import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var switchActivo: UISwitch!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtEdad: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func conexion() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }

    @IBAction func btnGuardar(_ sender: UIButton) {
        let contexto = conexion()
        let entidadPersonas = NSEntityDescription.entity(forEntityName: "Personas", in: contexto)
        let nuevaPersona = NSManagedObject(entity: entidadPersonas!, insertInto: contexto)
        let edadPersona = Int16(txtEdad.text!)
        nuevaPersona.setValue(txtNombre.text, forKey: "nombre")
        nuevaPersona.setValue(edadPersona, forKey: "edad")
        nuevaPersona.setValue(switchActivo.isOn, forKey: "activo")
        
        do {
            try contexto.save()
            print("Registro guardado")
            txtNombre.text = ""
            txtEdad.text = ""
            switchActivo.isOn = false
        } catch let error as Error {
            print("Error al guardar: ", error)
        }
    }
    
    @IBAction func btnMostrar(_ sender: UIButton) {
    }
    
    
    @IBAction func btnBorrar(_ sender: UIButton) {
        let contexto = conexion()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Personas")
        let borrar = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try contexto.execute(borrar)
            print("Registros borrados")
        } catch let error as Error {
            print("Error:", error)
        }
    }
    
}

