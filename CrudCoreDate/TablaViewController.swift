import UIKit
import CoreData

class TablaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    
    var personas: [Personas] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabla.reloadData()
        tabla.delegate = self
        tabla.dataSource = self
        mostrarDatos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // METODOS RELACIONADOS CON LA CARGA DE DATOS EN LA TABLA
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let persona = personas[indexPath.row]
        
        if persona.activo {
            cell.textLabel?.text = "💚 \(persona.nombre!)"
            cell.detailTextLabel?.text = "\(persona.edad)"
        } else {
            cell.textLabel?.text = "❤️ \(persona.nombre!)"
            cell.detailTextLabel?.text = "\(persona.edad)"
        }
        
        return cell
    }
    
    // METODO RELACIONADO CON LA EDICION DE LAS FILAS
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let contexto = conexion()
        let persona = personas[indexPath.row]
        
        if editingStyle == .delete {
            contexto.delete(persona)
            
            do {
                try contexto.save()
            }catch let error as Error {
                print(error)
            }
        }
        
        mostrarDatos()
        tabla.reloadData()
    }
    
    // METODO RELACIONADO CON LA PULSACION SOBRE UNA FILA
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editar", sender: self)
    }
    
    // METODO QUE SE EJECUTA CUANDO NAVEGAMOS A OTRO VIEWCONTROLLER
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editar" {
            if let id = tabla.indexPathForSelectedRow {
                let fila = personas[id.row]
                let destino = segue.destination as! EditarViewController
                destino.personaEditar = fila
            }
        }
    }
    
    func conexion() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    func mostrarDatos() {
        let contexto = conexion()
        let fetchRequest: NSFetchRequest<Personas> = Personas.fetchRequest()
        do {
            personas = try contexto.fetch(fetchRequest)
        } catch let error as Error {
            print(error)
        }
    }

}
