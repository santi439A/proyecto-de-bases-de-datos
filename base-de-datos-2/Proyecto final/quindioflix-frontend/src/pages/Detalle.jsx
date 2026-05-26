import { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import api from '../services/api'
import { useAuth } from '../context/AuthContext'

export default function Detalle() {
  const { id } = useParams()
  const navigate = useNavigate()
  const { perfilActivo } = useAuth()
  const [contenido, setContenido] = useState(null)
  const [loading, setLoading] = useState(true)
  const [reseñas, setReseñas] = useState([])
  const [calificacion, setCalificacion] = useState(0)
  const [textoResena, setTextoResena] = useState('')

  useEffect(() => {
    const fetchDetalle = async () => {
      try {
        const { data } = await api.get(`/contenido/${id}`)
        if (data.success) {
          setContenido(data.data)
        }
      } catch (err) {
        console.error('Error:', err)
      } finally {
        setLoading(false)
      }
    }
    fetchDetalle()
  }, [id])

  const handleReproducir = async () => {
    if (!perfilActivo) {
      alert('Selecciona un perfil primero')
      navigate('/perfiles')
      return
    }

    try {
      const { data } = await api.post('/reproduccion/iniciar', {
        perfil_id: perfilActivo.PERFIL_ID || perfilActivo.perfil_id,
        contenido_id: parseInt(id),
        dispositivo: 'COMPUTADOR'
      })
      if (data.success) {
        navigate(`/detalle/${id}`)
      }
    } catch (err) {
      console.error('Error iniciando reproducción:', err)
    }
  }

  const handleAgregarFavorito = async () => {
    if (!perfilActivo) {
      alert('Selecciona un perfil primero')
      return
    }

    try {
      await api.post('/favorito', {
        perfil_id: perfilActivo.PERFIL_ID || perfilActivo.perfil_id,
        contenido_id: parseInt(id)
      })
      alert('Agregado a favoritos')
    } catch (err) {
      console.error('Error:', err)
    }
  }

  const handleEnviarResena = async () => {
    if (!perfilActivo) {
      alert('Selecciona un perfil primero')
      return
    }

    if (calificacion === 0) {
      alert('Selecciona una calificación')
      return
    }

    try {
      await api.post('/resena', {
        perfil_id: perfilActivo.PERFIL_ID || perfilActivo.perfil_id,
        contenido_id: parseInt(id),
        calificacion,
        texto: textoResena
      })
      alert('Reseña enviada')
      setCalificacion(0)
      setTextoResena('')
    } catch (err) {
      console.error('Error:', err)
    }
  }

  if (loading) {
    return <div className="min-h-screen flex items-center justify-center">Cargando...</div>
  }

  if (!contenido) {
    return <div className="min-h-screen flex items-center justify-center">Contenido no encontrado</div>
  }

  return (
    <div className="min-h-screen">
      <div className="bg-gradient-to-r from-zinc-900 to-black p-6">
        <div className="max-w-6xl mx-auto flex gap-8">
          <div className="w-64 aspect-video bg-zinc-800 rounded-lg flex items-center justify-center text-6xl">
            🎬
          </div>
          
          <div className="flex-1">
            <h1 className="text-3xl font-bold mb-2">{contenido.TITULO || contenido.titulo}</h1>
            <div className="flex gap-4 text-sm text-gray-400 mb-4">
              <span>{contenido.ANNO_LANZAMIENTO || contenido.anno_lanzamiento}</span>
              <span>{contenido.CLASIFICACION_EDAD || contenido.clasificacion_edad}</span>
              <span>{contenido.DURACION_MINUTOS || contenido.duracion_minutos} min</span>
              <span>{contenido.CATEGORIA || contenido.categoria}</span>
            </div>
            <p className="text-gray-300 mb-6">{contenido.SINOPSIS || contenido.sinopsis}</p>
            
            <div className="flex gap-4">
              <button 
                onClick={handleReproducir}
                className="bg-primary px-8 py-3 rounded-lg font-bold hover:bg-red-700 flex items-center gap-2"
              >
                ▶ Reproducir
              </button>
              <button 
                onClick={handleAgregarFavorito}
                className="bg-zinc-700 px-8 py-3 rounded-lg font-bold hover:bg-zinc-600"
              >
                + Mi Favorito
              </button>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-6xl mx-auto p-6">
        {contenido.GENEROS && (
          <div className="mb-8">
            <h3 className="font-bold mb-2">Géneros</h3>
            <div className="flex gap-2">
              {contenido.GENEROS.map((g, i) => (
                <span key={i} className="bg-zinc-800 px-3 py-1 rounded text-sm">
                  {typeof g === 'object' ? g.NOMBRE || g.nombre : g}
                </span>
              ))}
            </div>
          </div>
        )}

        <div className="bg-zinc-900 p-6 rounded-lg">
          <h3 className="font-bold text-xl mb-4">Deja tu reseña</h3>
          
          <div className="flex items-center gap-2 mb-4">
            <span className="mr-2">Calificación:</span>
            {[1, 2, 3, 4, 5].map((star) => (
              <button
                key={star}
                onClick={() => setCalificacion(star)}
                className={`text-2xl ${star <= calificacion ? 'text-yellow-400' : 'text-gray-600'}`}
              >
                ★
              </button>
            ))}
          </div>

          <textarea
            value={textoResena}
            onChange={(e) => setTextoResena(e.target.value)}
            placeholder="Escribe tu opinión (opcional)"
            className="w-full bg-zinc-800 border border-zinc-700 rounded p-3 mb-4 h-24"
          />

          <button 
            onClick={handleEnviarResena}
            className="bg-primary px-6 py-2 rounded hover:bg-red-700"
          >
            Enviar Reseña
          </button>
        </div>
      </div>
    </div>
  )
}