import { Link } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import api from '../services/api'
import { useState, useEffect } from 'react'

export default function Home() {
  const { isAuthenticated } = useAuth()
  const [contenidoDestacado, setContenidoDestacado] = useState([])

  useEffect(() => {
    const fetchDestacado = async () => {
      try {
        const { data } = await api.get('/contenido')
        if (data.success) {
          setContenidoDestacado(data.data.slice(0, 5))
        }
      } catch (err) {
        console.error('Error cargando contenido:', err)
      }
    }
    fetchDestacado()
  }, [])

  return (
    <div className="min-h-screen">
      <div className="relative bg-gradient-to-b from-black/70 to-secondary py-20 px-6">
        <div className="max-w-4xl mx-auto text-center">
          <h1 className="text-5xl font-bold mb-4">
            Bienvenido a <span className="text-primary">QuindioFlix</span>
          </h1>
          <p className="text-xl text-gray-300 mb-8">
            Tu plataforma de streaming favorita con películas, series, documentales y más
          </p>
          
          {!isAuthenticated ? (
            <div className="flex gap-4 justify-center">
              <Link 
                to="/registro" 
                className="bg-primary px-8 py-3 rounded-lg font-bold text-lg hover:bg-red-700 transition"
              >
                Regístrate Ahora
              </Link>
              <Link 
                to="/login" 
                className="bg-zinc-800 px-8 py-3 rounded-lg font-bold text-lg hover:bg-zinc-700 transition"
              >
                Iniciar Sesión
              </Link>
            </div>
          ) : (
            <Link 
              to="/catalogo" 
              className="bg-primary px-8 py-3 rounded-lg font-bold text-lg hover:bg-red-700 transition"
            >
              Ver Catálogo
            </Link>
          )}
        </div>
      </div>

      <div className="max-w-6xl mx-auto py-12 px-6">
        <h2 className="text-2xl font-bold mb-6">Contenido Destacado</h2>
        <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
          {contenidoDestacado.map((item) => (
            <Link key={item.CONTENIDO_ID || item.contenido_id} to={`/detalle/${item.CONTENIDO_ID || item.contenido_id}`}>
              <div className="bg-zinc-800 rounded-lg overflow-hidden hover:scale-105 transition-transform">
                <div className="aspect-video bg-zinc-700 flex items-center justify-center">
                  <span className="text-4xl">🎬</span>
                </div>
                <div className="p-3">
                  <h3 className="font-semibold text-sm truncate">{item.TITULO || item.titulo}</h3>
                  <p className="text-xs text-gray-400">{item.CLASIFICACION_EDAD || item.clasificacion_edad}</p>
                </div>
              </div>
            </Link>
          ))}
        </div>
      </div>

      <div className="bg-zinc-900 py-12 px-6">
        <div className="max-w-6xl mx-auto">
          <h2 className="text-2xl font-bold mb-6 text-center">Planes Disponibles</h2>
          <div className="grid md:grid-cols-3 gap-6">
            <div className="bg-zinc-800 p-6 rounded-lg text-center">
              <h3 className="text-xl font-bold mb-2">Básico</h3>
              <p className="text-3xl font-bold text-primary mb-4">$14.900<span className="text-sm font-normal">/mes</span></p>
              <ul className="text-sm text-gray-400 space-y-2 mb-4">
                <li>1 pantalla simultánea</li>
                <li>Calidad SD</li>
                <li>2 perfiles máximo</li>
              </ul>
              <Link to="/registro" className="bg-primary px-6 py-2 rounded hover:bg-red-700 block">
                Elegir Plan
              </Link>
            </div>
            
            <div className="bg-zinc-800 p-6 rounded-lg text-center border-2 border-primary">
              <h3 className="text-xl font-bold mb-2">Estándar</h3>
              <p className="text-3xl font-bold text-primary mb-4">$24.900<span className="text-sm font-normal">/mes</span></p>
              <ul className="text-sm text-gray-400 space-y-2 mb-4">
                <li>2 pantallas simultáneas</li>
                <li>Calidad HD</li>
                <li>3 perfiles máximo</li>
              </ul>
              <Link to="/registro" className="bg-primary px-6 py-2 rounded hover:bg-red-700 block">
                Elegir Plan
              </Link>
            </div>
            
            <div className="bg-zinc-800 p-6 rounded-lg text-center">
              <h3 className="text-xl font-bold mb-2">Premium</h3>
              <p className="text-3xl font-bold text-primary mb-4">$34.900<span className="text-sm font-normal">/mes</span></p>
              <ul className="text-sm text-gray-400 space-y-2 mb-4">
                <li>4 pantallas simultáneas</li>
                <li>Calidad 4K</li>
                <li>5 perfiles máximo</li>
              </ul>
              <Link to="/registro" className="bg-primary px-6 py-2 rounded hover:bg-red-700 block">
                Elegir Plan
              </Link>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}