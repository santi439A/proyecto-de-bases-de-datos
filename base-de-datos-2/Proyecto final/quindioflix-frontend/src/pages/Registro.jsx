import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import api from '../services/api'

export default function Registro() {
  const [form, setForm] = useState({
    nombre: '',
    email: '',
    password: '',
    telefono: '',
    fecha_nacimiento: '',
    ciudad_residencia: '',
    plan_id: 1
  })
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const { login } = useAuth()
  const navigate = useNavigate()

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value })
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    try {
      const { data } = await api.post('/auth/register', form)
      if (data.success) {
        login(data.data.user, data.data.token)
        navigate('/catalogo')
      }
    } catch (err) {
      setError(err.response?.data?.error || 'Error al registrar')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-black py-8">
      <div className="bg-zinc-900 p-8 rounded-lg w-full max-w-md">
        <h1 className="text-3xl font-bold text-primary mb-6 text-center">QuindioFlix</h1>
        <h2 className="text-xl mb-6 text-center">Crear Cuenta</h2>

        {error && (
          <div className="bg-red-900/50 border border-red-500 text-red-400 px-4 py-2 rounded mb-4">
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm mb-1">Nombre completo</label>
            <input
              type="text"
              name="nombre"
              value={form.nombre}
              onChange={handleChange}
              className="w-full bg-zinc-800 border border-zinc-700 rounded px-3 py-2 focus:outline-none focus:border-primary"
              required
            />
          </div>

          <div>
            <label className="block text-sm mb-1">Email</label>
            <input
              type="email"
              name="email"
              value={form.email}
              onChange={handleChange}
              className="w-full bg-zinc-800 border border-zinc-700 rounded px-3 py-2 focus:outline-none focus:border-primary"
              required
            />
          </div>

          <div>
            <label className="block text-sm mb-1">Contraseña</label>
            <input
              type="password"
              name="password"
              value={form.password}
              onChange={handleChange}
              className="w-full bg-zinc-800 border border-zinc-700 rounded px-3 py-2 focus:outline-none focus:border-primary"
              required
            />
          </div>

          <div>
            <label className="block text-sm mb-1">Teléfono</label>
            <input
              type="tel"
              name="telefono"
              value={form.telefono}
              onChange={handleChange}
              className="w-full bg-zinc-800 border border-zinc-700 rounded px-3 py-2 focus:outline-none focus:border-primary"
              required
            />
          </div>

          <div>
            <label className="block text-sm mb-1">Fecha de nacimiento</label>
            <input
              type="date"
              name="fecha_nacimiento"
              value={form.fecha_nacimiento}
              onChange={handleChange}
              className="w-full bg-zinc-800 border border-zinc-700 rounded px-3 py-2 focus:outline-none focus:border-primary"
              required
            />
          </div>

          <div>
            <label className="block text-sm mb-1">Ciudad de residencia</label>
            <select
              name="ciudad_residencia"
              value={form.ciudad_residencia}
              onChange={handleChange}
              className="w-full bg-zinc-800 border border-zinc-700 rounded px-3 py-2 focus:outline-none focus:border-primary"
              required
            >
              <option value="">Seleccione ciudad</option>
              <option value="Armenia">Armenia</option>
              <option value="Bogota">Bogotá</option>
              <option value="Medellin">Medellín</option>
              <option value="Cali">Cali</option>
              <option value="Pereira">Pereira</option>
            </select>
          </div>

          <div>
            <label className="block text-sm mb-1">Plan de suscripción</label>
            <select
              name="plan_id"
              value={form.plan_id}
              onChange={handleChange}
              className="w-full bg-zinc-800 border border-zinc-700 rounded px-3 py-2 focus:outline-none focus:border-primary"
            >
              <option value="1">Básico - $14.900/mes</option>
              <option value="2">Estándar - $24.900/mes</option>
              <option value="3">Premium - $34.900/mes</option>
            </select>
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full bg-primary py-3 rounded font-bold hover:bg-red-700 disabled:opacity-50"
          >
            {loading ? 'Cargando...' : 'Crear Cuenta'}
          </button>
        </form>

        <p className="mt-4 text-center text-sm text-gray-400">
          ¿Ya tienes cuenta? <a href="/login" className="text-primary hover:underline">Inicia Sesión</a>
        </p>
      </div>
    </div>
  )
}