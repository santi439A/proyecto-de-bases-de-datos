import { Link, useNavigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'

export default function Navbar() {
  const { user, isAuthenticated, isAdmin, logout, perfilActivo } = useAuth()
  const navigate = useNavigate()

  const handleLogout = () => {
    logout()
    navigate('/login')
  }

  return (
    <nav className="bg-secondary sticky top-0 z-50 px-6 py-4 flex items-center justify-between">
      <div className="flex items-center gap-8">
        <Link to={isAdmin ? "/admin" : "/"} className="text-primary text-2xl font-bold">QuindioFlix</Link>
        {isAuthenticated && !isAdmin && (
          <div className="flex gap-6">
            <Link to="/catalogo" className="hover:text-gray-300">Catálogo</Link>
            <Link to="/favoritos" className="hover:text-gray-300">Favoritos</Link>
            <Link to="/perfiles" className="hover:text-gray-300">Perfiles</Link>
          </div>
        )}
        {isAuthenticated && isAdmin && (
          <div className="flex gap-6">
            <Link to="/admin" className="hover:text-gray-300">Dashboard</Link>
            <Link to="/admin/contenido" className="hover:text-gray-300">Contenido</Link>
            <Link to="/admin/empleados" className="hover:text-gray-300">Empleados</Link>
            <Link to="/admin/departamentos" className="hover:text-gray-300">Departamentos</Link>
            <Link to="/admin/reportes" className="hover:text-gray-300">Reportes</Link>
          </div>
        )}
      </div>
      
      <div className="flex items-center gap-4">
        {isAuthenticated ? (
          <>
            {perfilActivo && !isAdmin && (
              <span className="text-sm text-gray-400">
                Perfil: {perfilActivo.NOMBRE || perfilActivo.nombre}
              </span>
            )}
            {isAdmin && (
              <span className="text-sm text-primary font-semibold">Admin</span>
            )}
            <button 
              onClick={handleLogout}
              className="bg-primary px-4 py-2 rounded hover:bg-red-700"
            >
              Cerrar Sesión
            </button>
          </>
        ) : (
          <>
            <Link to="/login" className="hover:text-gray-300">Iniciar Sesión</Link>
            <Link to="/registro" className="bg-primary px-4 py-2 rounded hover:bg-red-700">
              Registrarse
            </Link>
          </>
        )}
      </div>
    </nav>
  )
}