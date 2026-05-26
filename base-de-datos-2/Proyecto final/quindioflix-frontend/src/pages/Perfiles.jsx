import { useState, useEffect } from 'react'
import { useAuth } from '../context/AuthContext'
import { useNavigate } from 'react-router-dom'
import api from '../services/api'

export default function Perfiles() {
  const { user, perfilActivo, selectPerfil, setPerfiles } = useAuth()
  const navigate = useNavigate()
  const [perfiles, setPerfilesLocal] = useState([])

  useEffect(() => {
    if (user) {
      fetchPerfiles()
    }
  }, [user])

  const fetchPerfiles = async () => {
    try {
      const { data } = await api.get(`/usuario/${user.id}/perfiles`)
      setPerfilesLocal(data.data || [])
      setPerfiles(data.data || [])
    } catch (err) {
      console.error('Error:', err)
    }
  }

  const handleSelect = (perfil) => {
    selectPerfil(perfil)
    navigate('/catalogo')
  }

  if (!user) {
    return <div className="min-h-screen flex items-center justify-center">Cargando...</div>
  }

  return (
    <div className="min-h-screen flex flex-col items-center justify-center py-12">
      <h1 className="text-2xl font-bold mb-8">¿Quién está viendo?</h1>
      
      <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
        {perfiles.map((perfil) => {
          const isActive = perfilActivo && (perfilActivo.PERFIL_ID || perfilActivo.perfil_id) === (perfil.PERFIL_ID || perfil.perfil_id)
          return (
            <button
              key={perfil.PERFIL_ID || perfil.perfil_id}
              onClick={() => handleSelect(perfil)}
              className={`flex flex-col items-center p-4 rounded-lg transition ${
                isActive ? 'bg-zinc-700 ring-2 ring-primary' : 'bg-zinc-800 hover:bg-zinc-700'
              }`}
            >
              <div className="w-24 h-24 bg-zinc-600 rounded-lg flex items-center justify-center text-4xl mb-3">
                {(perfil.TIPO || perfil.tipo) === 'INFANTIL' ? '👶' : '👤'}
              </div>
              <span className="font-semibold">{perfil.NOMBRE || perfil.nombre}</span>
              <span className="text-xs text-gray-400">{perfil.TIPO || perfil.tipo}</span>
            </button>
          )
        })}
      </div>
    </div>
  )
}