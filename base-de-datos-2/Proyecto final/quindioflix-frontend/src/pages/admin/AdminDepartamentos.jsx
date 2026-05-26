import { useState, useEffect } from 'react'
import api from '../../services/api'

export default function AdminDepartamentos() {
  const [departamentos, setDepartamentos] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchDepartamentos()
  }, [])

  const fetchDepartamentos = async () => {
    try {
      const { data } = await api.get('/admin/departamentos')
      if (data.success) {
        setDepartamentos(data.data)
      }
    } catch (err) {
      console.error('Error:', err)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen p-6">
      <h1 className="text-2xl font-bold mb-6">Gestión de Departamentos</h1>
      
      {loading ? (
        <div className="text-center py-20">Cargando...</div>
      ) : (
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {departamentos.map((dept) => (
            <div key={dept.DEPARTAMENTO_ID || dept.departamento_id} className="bg-zinc-800 p-6 rounded-lg">
              <h3 className="font-bold text-lg mb-2">{dept.NOMBRE || dept.nombre}</h3>
              <p className="text-sm text-gray-400">
                Jefe: <span className="text-white">{dept.JEFE_NOMBRE || dept.jefe_nombre || 'No asignado'}</span>
              </p>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}