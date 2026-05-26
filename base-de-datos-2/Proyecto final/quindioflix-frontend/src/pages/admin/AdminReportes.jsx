import { useState, useEffect } from 'react'
import api from '../../services/api'

export default function AdminReportes() {
  const [reportes, setReportes] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchReportes()
  }, [])

  const fetchReportes = async () => {
    try {
      const { data } = await api.get('/admin/reportes')
      if (data.success) {
        setReportes(data.data)
      }
    } catch (err) {
      console.error('Error:', err)
    } finally {
      setLoading(false)
    }
  }

  const handleResolver = async (reporteId, estado) => {
    try {
      await api.put(`/admin/reporte/${reporteId}/resolver`, { estado })
      fetchReportes()
    } catch (err) {
      console.error('Error:', err)
    }
  }

  const getEstadoColor = (estado) => {
    switch (estado) {
      case 'PENDIENTE': return 'bg-yellow-600'
      case 'EN_REVISION': return 'bg-blue-600'
      case 'APROBADO': return 'bg-green-600'
      case 'RECHAZADO': return 'bg-red-600'
      default: return 'bg-gray-600'
    }
  }

  return (
    <div className="min-h-screen p-6">
      <h1 className="text-2xl font-bold mb-6">Gestión de Reportes</h1>
      
      {loading ? (
        <div className="text-center py-20">Cargando...</div>
      ) : (
        <div className="bg-zinc-800 rounded-lg overflow-hidden">
          <table className="w-full">
            <thead className="bg-zinc-900">
              <tr>
                <th className="px-4 py-3 text-left">ID</th>
                <th className="px-4 py-3 text-left">Contenido</th>
                <th className="px-4 py-3 text-left">Perfil</th>
                <th className="px-4 py-3 text-left">Motivo</th>
                <th className="px-4 py-3 text-left">Estado</th>
                <th className="px-4 py-3 text-left">Acciones</th>
              </tr>
            </thead>
            <tbody>
              {reportes.map((reporte) => (
                <tr key={reporte.REPORTE_ID || reporte.reporte_id} className="border-t border-zinc-700">
                  <td className="px-4 py-3">{reporte.REPORTE_ID || reporte.reporte_id}</td>
                  <td className="px-4 py-3">{reporte.CONTENIDO_TITULO || reporte.contenido_titulo}</td>
                  <td className="px-4 py-3">{reporte.PERFIL_NOMBRE || reporte.perfil_nombre}</td>
                  <td className="px-4 py-3 max-w-xs truncate">{reporte.MOTIVO || reporte.motivo}</td>
                  <td className="px-4 py-3">
                    <span className={`px-2 py-1 rounded text-xs ${getEstadoColor(reporte.ESTADO || reporte.estado)}`}>
                      {reporte.ESTADO || reporte.estado}
                    </span>
                  </td>
                  <td className="px-4 py-3">
                    {(reporte.ESTADO || reporte.estado) === 'PENDIENTE' && (
                      <div className="flex gap-2">
                        <button 
                          onClick={() => handleResolver(reporte.REPORTE_ID || reporte.reporte_id, 'APROBADO')}
                          className="bg-green-600 px-3 py-1 rounded text-sm hover:bg-green-700"
                        >
                          Aprobar
                        </button>
                        <button 
                          onClick={() => handleResolver(reporte.REPORTE_ID || reporte.reporte_id, 'RECHAZADO')}
                          className="bg-red-600 px-3 py-1 rounded text-sm hover:bg-red-700"
                        >
                          Rechazar
                        </button>
                      </div>
                    )}
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