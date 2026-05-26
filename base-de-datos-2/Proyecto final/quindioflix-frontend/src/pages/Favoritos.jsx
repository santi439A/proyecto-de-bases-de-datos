import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import api from '../services/api'

export default function Favoritos() {
  const { perfilActivo } = useAuth()
  const [favoritos, setFavoritos] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    if (perfilActivo) {
      fetchFavoritos()
    }
  }, [perfilActivo])

  const fetchFavoritos = async () => {
    try {
      const { data } = await api.get(`/perfil/${perfilActivo.PERFIL_ID || perfilActivo.perfil_id}/favoritos`)
      setFavoritos(data.data || [])
    } catch (err) {
      console.error('Error:', err)
    } finally {
      setLoading(false)
    }
  }

  const handleEliminar = async (contenidoId) => {
    try {
      await api.delete(`/favorito/${perfilActivo.PERFIL_ID || perfilActivo.perfil_id}/${contenidoId}`)
      setFavoritos(favoritos.filter(f => (f.CONTENIDO_ID || f.contenido_id) !== contenidoId))
    } catch (err) {
      console.error('Error:', err)
    }
  }

  if (!perfilActivo) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <p>Selecciona un perfil primero</p>
      </div>
    )
  }

  return (
    <div className="min-h-screen p-6">
      <h1 className="text-2xl font-bold mb-6">Mis Favoritos</h1>
      
      {loading ? (
        <div className="text-center py-20">Cargando...</div>
      ) : favoritos.length === 0 ? (
        <div className="text-center py-20 text-gray-400">
          No tienes contenido en favoritos
        </div>
      ) : (
        <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-4">
          {favoritos.map((item) => (
            <div key={item.CONTENIDO_ID || item.contenido_id} className="bg-zinc-800 rounded-lg overflow-hidden">
              <Link to={`/detalle/${item.CONTENIDO_ID || item.contenido_id}`}>
                <div className="aspect-video bg-zinc-700 flex items-center justify-center">
                  <span className="text-4xl">🎬</span>
                </div>
                <div className="p-3">
                  <h3 className="font-semibold text-sm truncate">{item.TITULO || item.titulo}</h3>
                </div>
              </Link>
              <button
                onClick={() => handleEliminar(item.CONTENIDO_ID || item.contenido_id)}
                className="w-full bg-red-900/50 py-2 text-sm hover:bg-red-800"
              >
                Eliminar
              </button>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}