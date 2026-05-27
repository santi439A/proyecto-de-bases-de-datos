import { useState, useEffect } from 'react'
import api from '../../services/api'

export default function AdminContenido() {
  const [contenido, setContenido] = useState([])
  const [loading, setLoading] = useState(true)
  const [showForm, setShowForm] = useState(false)
  const [editing, setEditing] = useState(null)
  const [form, setForm] = useState({
    titulo: '', categoria_id: 1, categoria_nombre: 'PELICULA',
    anno_lanzamiento: 2025, duracion_minutos: '',
    sinopsis: '', clasificacion_edad: 'TP'
  })

  useEffect(() => { fetchContenido() }, [])

  const fetchContenido = async () => {
    try {
      const { data } = await api.get('/contenido')
      if (data.success) setContenido(data.data)
    } catch (err) { console.error(err) }
    finally { setLoading(false) }
  }

  const handleDelete = async (id) => {
    if (!confirm('¿Eliminar este contenido?')) return
    try {
      await api.delete(`/admin/contenido/${id}`)
      fetchContenido()
    } catch (err) { console.error(err) }
  }

  const handleEdit = (item) => {
    setEditing(item.contenido_id || item.CONTENIDO_ID)
    setForm({
      titulo: item.titulo || item.TITULO || '',
      categoria_id: item.categoria_id || 1,
      categoria_nombre: item.categoria_nombre || item.CATEGORIA || 'PELICULA',
      anno_lanzamiento: item.anno_lanzamiento || item.ANNO_LANZAMIENTO || 2025,
      duracion_minutos: item.duracion_minutos || item.DURACION_MINUTOS || '',
      sinopsis: item.sinopsis || item.SINOPSIS || '',
      clasificacion_edad: item.clasificacion_edad || item.CLASIFICACION_EDAD || 'TP'
    })
    setShowForm(true)
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    const payload = { ...form, duracion_minutos: form.duracion_minutos ? parseInt(form.duracion_minutos) : null }
    try {
      if (editing) {
        await api.put(`/admin/contenido/${editing}`, payload)
      } else {
        await api.post('/admin/contenido', payload)
      }
      setShowForm(false)
      setEditing(null)
      setForm({ titulo: '', categoria_id: 1, categoria_nombre: 'PELICULA', anno_lanzamiento: 2025, duracion_minutos: '', sinopsis: '', clasificacion_edad: 'TP' })
      fetchContenido()
    } catch (err) { console.error(err) }
  }

  return (
    <div className="min-h-screen p-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold">Gestión de Contenido</h1>
        <button onClick={() => { setEditing(null); setForm({ titulo: '', categoria_id: 1, categoria_nombre: 'PELICULA', anno_lanzamiento: 2025, duracion_minutos: '', sinopsis: '', clasificacion_edad: 'TP' }); setShowForm(!showForm) }}
          className="bg-primary px-4 py-2 rounded hover:bg-red-700">
          {showForm ? 'Cancelar' : '+ Nuevo Contenido'}
        </button>
      </div>

      {showForm && (
        <form onSubmit={handleSubmit} className="bg-zinc-800 p-6 rounded-lg mb-8 max-w-2xl">
          <h3 className="font-bold mb-4">{editing ? 'Editar Contenido' : 'Nuevo Contenido'}</h3>
          <div className="grid grid-cols-2 gap-4">
            <div className="col-span-2">
              <label className="block text-sm mb-1">Título</label>
              <input type="text" value={form.titulo} onChange={e => setForm({...form, titulo: e.target.value})}
                className="w-full bg-zinc-700 border border-zinc-600 rounded px-3 py-2" required />
            </div>
            <div>
              <label className="block text-sm mb-1">Categoría</label>
              <select value={form.categoria_id} onChange={e => setForm({...form, categoria_id: parseInt(e.target.value)})}
                className="w-full bg-zinc-700 border border-zinc-600 rounded px-3 py-2">
                <option value={1}>PELICULA</option>
                <option value={2}>SERIE</option>
                <option value={3}>DOCUMENTAL</option>
                <option value={4}>MUSICA</option>
                <option value={5}>PODCAST</option>
              </select>
            </div>
            <div>
              <label className="block text-sm mb-1">Clasificación</label>
              <select value={form.clasificacion_edad} onChange={e => setForm({...form, clasificacion_edad: e.target.value})}
                className="w-full bg-zinc-700 border border-zinc-600 rounded px-3 py-2">
                <option value="TP">TP</option>
                <option value="+7">+7</option>
                <option value="+13">+13</option>
                <option value="+16">+16</option>
                <option value="+18">+18</option>
              </select>
            </div>
            <div>
              <label className="block text-sm mb-1">Año</label>
              <input type="number" value={form.anno_lanzamiento} onChange={e => setForm({...form, anno_lanzamiento: parseInt(e.target.value)})}
                className="w-full bg-zinc-700 border border-zinc-600 rounded px-3 py-2" />
            </div>
            <div>
              <label className="block text-sm mb-1">Duración (min)</label>
              <input type="number" value={form.duracion_minutos} onChange={e => setForm({...form, duracion_minutos: e.target.value})}
                className="w-full bg-zinc-700 border border-zinc-600 rounded px-3 py-2" />
            </div>
            <div className="col-span-2">
              <label className="block text-sm mb-1">Sinopsis</label>
              <textarea value={form.sinopsis} onChange={e => setForm({...form, sinopsis: e.target.value})}
                className="w-full bg-zinc-700 border border-zinc-600 rounded px-3 py-2 h-24" />
            </div>
          </div>
          <button type="submit" className="bg-primary px-6 py-2 rounded hover:bg-red-700 mt-4">
            {editing ? 'Actualizar' : 'Crear'}
          </button>
        </form>
      )}

      {loading ? <div className="text-center py-20">Cargando...</div> : (
        <div className="bg-zinc-800 rounded-lg overflow-hidden">
          <table className="w-full">
            <thead className="bg-zinc-900">
              <tr>
                <th className="px-4 py-3 text-left">ID</th>
                <th className="px-4 py-3 text-left">Título</th>
                <th className="px-4 py-3 text-left">Categoría</th>
                <th className="px-4 py-3 text-left">Año</th>
                <th className="px-4 py-3 text-left">Clasificación</th>
                <th className="px-4 py-3 text-left">Acciones</th>
              </tr>
            </thead>
            <tbody>
              {contenido.map((item) => (
                <tr key={item.contenido_id || item.CONTENIDO_ID} className="border-t border-zinc-700">
                  <td className="px-4 py-3">{item.contenido_id || item.CONTENIDO_ID}</td>
                  <td className="px-4 py-3">{item.titulo || item.TITULO}</td>
                  <td className="px-4 py-3">{item.categoria_nombre || item.CATEGORIA}</td>
                  <td className="px-4 py-3">{item.anno_lanzamiento || item.ANNO_LANZAMIENTO}</td>
                  <td className="px-4 py-3">{item.clasificacion_edad || item.CLASIFICACION_EDAD}</td>
                  <td className="px-4 py-3 flex gap-2">
                    <button onClick={() => handleEdit(item)} className="bg-blue-600 px-3 py-1 rounded text-sm hover:bg-blue-700">Editar</button>
                    <button onClick={() => handleDelete(item.contenido_id || item.CONTENIDO_ID)} className="bg-red-600 px-3 py-1 rounded text-sm hover:bg-red-700">Eliminar</button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}