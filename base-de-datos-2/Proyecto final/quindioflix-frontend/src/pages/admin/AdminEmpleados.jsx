import { useState, useEffect } from 'react'
import api from '../../services/api'

export default function AdminEmpleados() {
  const [empleados, setEmpleados] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchEmpleados()
  }, [])

  const fetchEmpleados = async () => {
    try {
      const { data } = await api.get('/admin/empleados')
      if (data.success) {
        setEmpleados(data.data)
      }
    } catch (err) {
      console.error('Error:', err)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen p-6">
      <h1 className="text-2xl font-bold mb-6">Gestión de Empleados</h1>
      
      {loading ? (
        <div className="text-center py-20">Cargando...</div>
      ) : (
        <div className="bg-zinc-800 rounded-lg overflow-hidden">
          <table className="w-full">
            <thead className="bg-zinc-900">
              <tr>
                <th className="px-4 py-3 text-left">ID</th>
                <th className="px-4 py-3 text-left">Nombre</th>
                <th className="px-4 py-3 text-left">Email</th>
                <th className="px-4 py-3 text-left">Cargo</th>
                <th className="px-4 py-3 text-left">Departamento</th>
                <th className="px-4 py-3 text-left">Supervisor</th>
              </tr>
            </thead>
            <tbody>
              {empleados.map((emp) => (
                <tr key={emp.EMPLEADO_ID || emp.empleado_id} className="border-t border-zinc-700">
                  <td className="px-4 py-3">{emp.EMPLEADO_ID || emp.empleado_id}</td>
                  <td className="px-4 py-3">{emp.NOMBRE || emp.nombre}</td>
                  <td className="px-4 py-3">{emp.EMAIL || emp.email}</td>
                  <td className="px-4 py-3">{emp.CARGO || emp.cargo}</td>
                  <td className="px-4 py-3">{emp.DEPARTAMENTO_NOMBRE || emp.departamento_nombre}</td>
                  <td className="px-4 py-3">{emp.SUPERVISOR_NOMBRE || emp.supervisor_nombre || '-'}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}