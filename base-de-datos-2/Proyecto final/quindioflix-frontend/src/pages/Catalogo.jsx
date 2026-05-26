import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import api from '../services/api'

export default function Catalogo() {
  const [contenido, setContenido] = useState([])
  const [generos, setGeneros] = useState([])
  const [categorias, setCategorias] = useState([])
  const [filtros, setFiltros] = useState({
    categoria_id: '',
    genero_id: '',
    clasificacion: '',
    busqueda: ''
  })
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [gen, cat] = await Promise.all([
          api.get('/generos'),
          api.get('/categorias')
        ])
        setGeneros(gen.data.data || [])
        setCategorias(cat.data.data || [])
      } catch (err) {
        console.error('Error cargando filtros:', err)
      }
    }
    fetchData()
  }, [])

  useEffect(() => {
    const fetchContenido = async () => {
      setLoading(true)
      try {
        const params = new URLSearchParams()
        if (filtros.categoria_id) params.append('categoria_id', filtros.categoria_id)
        if (filtros.genero_id) params.append('genero_id', filtros.genero_id)
        if (filtros.clasificacion) params.append('clasificacion', filtros.clasificacion)
        if (filtros.busqueda) params.append('busqueda', filtros.busqueda)

        const { data } = await api.get(`/contenido?${params.toString()}`)
        setContenido(data.data || [])
      } catch (err) {
        console.error('Error cargando contenido:', err)
      } finally {
        setLoading(false)
      }
    }
    fetchContenido()
  }, [filtros])

  const handleFiltro = (key, value) => {
    setFiltros({ ...filtros, [key]: value })
  }

  return (
    <div className="min-h-screen flex">
      <aside className="w-64 bg-zinc-900 p-4 sticky top-16 h-fit">
        <h3 className="font-bold mb-4">Filtros</h3>
        
        <div className="space-y-4">
          <div>
            <label className="block text-sm mb-1">Género</label>
            <select 
              value={filtros.genero_id}
              onChange={(e) => handleFiltro('genero_id', e.target.value)}
              className="w-full bg-zinc-800 border border-zinc-700 rounded px-2 py-1 text-sm"
            >
              <option value="">Todos</option>
              {generos.map((g) => (
                <option key={g.GENERO_ID || g.genero_id} value={g.GENERO_ID || g.genero_id}>
                  {g.NOMBRE || g.nombre}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-sm mb-1">Categoría</label>
            <select 
              value={filtros.categoria_id}
              onChange={(e) => handleFiltro('categoria_id', e.target.value)}
              className="w-full bg-zinc-800 border border-zinc-700 rounded px-2 py-1 text-sm"
            >
              <option value="">Todas</option>
              {categorias.map((c) => (
                <option key={c.CATEGORIA_ID || c.categoria_id} value={c.CATEGORIA_ID || c.categoria_id}>
                  {c.NOMBRE || c.nombre}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-sm mb-1">Clasificación</label>
            <select 
              value={filtros.clasificacion}
              onChange={(e) => handleFiltro('clasificacion', e.target.value)}
              className="w-full bg-zinc-800 border border-zinc-700 rounded px-2 py-1 text-sm"
            >
              <option value="">Todas</option>
              <option value="TP">TP</option>
              <option value="+7">+7</option>
              <option value="+13">+13</option>
              <option value="+16">+16</option>
              <option value="+18">+18</option>
            </select>
          </div>

          <div>
            <label className="block text-sm mb-1">Buscar</label>
            <input
              type="text"
              placeholder="Buscar título..."
              value={filtros.busqueda}
              onChange={(e) => handleFiltro('busqueda', e.target.value)}
              className="w-full bg-zinc-800 border border-zinc-700 rounded px-2 py-1 text-sm"
            />
          </div>
        </div>
      </aside>

      <main className="flex-1 p-6">
        <h1 className="text-2xl font-bold mb-6">Catálogo</h1>
        
        {loading ? (
          <div className="text-center py-20">Cargando...</div>
        ) : (
          <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-4">
            {contenido.map((item) => (
              <Link key={item.CONTENIDO_ID || item.contenido_id} to={`/detalle/${item.CONTENIDO_ID || item.contenido_id}`}>
                <div className="bg-zinc-800 rounded-lg overflow-hidden hover:scale-105 transition-transform">
                  <div className="aspect-video bg-zinc-700 flex items-center justify-center">
                    <span className="text-4xl">🎬</span>
                  </div>
                  <div className="p-3">
                    <h3 className="font-semibold text-sm truncate">{item.TITULO || item.titulo}</h3>
                    <div className="flex justify-between text-xs text-gray-400 mt-1">
                      <span>{item.CATEGORIA || item.categoria}</span>
                      <span>{item.CLASIFICACION_EDAD || item.clasificacion_edad}</span>
                    </div>
                    {item.GENEROS && (
                      <p className="text-xs text-gray-500 mt-1 truncate">
                        {Array.isArray(item.GENEROS) ? item.GENEROS.join(', ') : item.GENEROS}
                      </p>
                    )}
                  </div>
                </div>
              </Link>
            ))}
          </div>
        )}

        {!loading && contenido.length === 0 && (
          <div className="text-center py-20 text-gray-400">
            No se encontró contenido con los filtros seleccionados
          </div>
        )}
      </main>
    </div>
  )
}