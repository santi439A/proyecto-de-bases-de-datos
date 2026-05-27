import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import api from '../../services/api'

export default function AdminDashboard() {
  const [stats, setStats] = useState(null)

  useEffect(() => {
    fetchDashboard()
  }, [])

  const fetchDashboard = async () => {
    try {
      const { data } = await api.get('/admin/dashboard')
      if (data.success) {
        setStats(data.data)
      }
    } catch (err) {
      console.error('Error:', err)
    }
  }

  return (
    <div className="min-h-screen p-6">
      <h1 className="text-2xl font-bold mb-6">Panel de Administración</h1>
      
      <div className="grid grid-cols-2 md:grid-cols-4 gap-6 mb-8">
        <div className="bg-zinc-800 p-6 rounded-lg">
          <p className="text-gray-400 text-sm">Total Usuarios</p>
          <p className="text-3xl font-bold">{stats?.total_usuarios || 0}</p>
        </div>
        <div className="bg-zinc-800 p-6 rounded-lg">
          <p className="text-gray-400 text-sm">Total Contenido</p>
          <p className="text-3xl font-bold">{stats?.total_contenido || 0}</p>
        </div>
        <div className="bg-zinc-800 p-6 rounded-lg">
          <p className="text-gray-400 text-sm">Reproducciones</p>
          <p className="text-3xl font-bold">{stats?.total_reproducciones || 0}</p>
        </div>
        <div className="bg-zinc-800 p-6 rounded-lg">
          <p className="text-gray-400 text-sm">Reportes Pendientes</p>
          <p className="text-3xl font-bold text-yellow-400">{stats?.reportes_pendientes || 0}</p>
        </div>
      </div>

      <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
        <Link to="/admin/contenido" className="bg-zinc-800 p-6 rounded-lg hover:bg-zinc-700">
          <h3 className="font-bold text-lg mb-2">🎬 Gestión de Contenido</h3>
          <p className="text-gray-400 text-sm">Crear, editar y eliminar películas y series</p>
        </Link>
        <Link to="/admin/reportes" className="bg-zinc-800 p-6 rounded-lg hover:bg-zinc-700">
          <h3 className="font-bold text-lg mb-2">📋 Gestión de Reportes</h3>
          <p className="text-gray-400 text-sm">Revisar y resolver reportes de usuarios</p>
        </Link>
        
        <Link to="/admin/empleados" className="bg-zinc-800 p-6 rounded-lg hover:bg-zinc-700">
          <h3 className="font-bold text-lg mb-2">👥 Gestión de Empleados</h3>
          <p className="text-gray-400 text-sm">Administrar empleados y supervisores</p>
        </Link>
        
        <Link to="/admin/departamentos" className="bg-zinc-800 p-6 rounded-lg hover:bg-zinc-700">
          <h3 className="font-bold text-lg mb-2">🏢 Gestión de Departamentos</h3>
          <p className="text-gray-400 text-sm">Administrar departamentos y asignar jefes</p>
        </Link>
      </div>
    </div>
  )
}