import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import api from '../services/api'

export default function Login() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const { login } = useAuth()
  const navigate = useNavigate()

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    try {
      const { data } = await api.post('/auth/login', { email, password })
      if (data.success) {
        login(data.data.user, data.data.token)
        if (data.data.user.rol === 'ADMIN') {
          navigate('/admin')
        } else {
          navigate('/catalogo')
        }
      }
    } catch (err) {
      setError(err.response?.data?.error || 'Error al iniciar sesión')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-black">
      <div className="bg-zinc-900 p-8 rounded-lg w-full max-w-md">
        <h1 className="text-3xl font-bold text-primary mb-6 text-center">QuindioFlix</h1>
        <h2 className="text-xl mb-6 text-center">Iniciar Sesión</h2>
        
        {error && (
          <div className="bg-red-900/50 border border-red-500 text-red-400 px-4 py-2 rounded mb-4">
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm mb-1">Email</label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full bg-zinc-800 border border-zinc-700 rounded px-3 py-2 focus:outline-none focus:border-primary"
              required
            />
          </div>
          
          <div>
            <label className="block text-sm mb-1">Contraseña</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full bg-zinc-800 border border-zinc-700 rounded px-3 py-2 focus:outline-none focus:border-primary"
              required
            />
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full bg-primary py-3 rounded font-bold hover:bg-red-700 disabled:opacity-50"
          >
            {loading ? 'Cargando...' : 'Iniciar Sesión'}
          </button>
        </form>

        <p className="mt-4 text-center text-sm text-gray-400">
          ¿No tienes cuenta? <a href="/registro" className="text-primary hover:underline">Regístrate</a>
        </p>
      </div>
    </div>
  )
}