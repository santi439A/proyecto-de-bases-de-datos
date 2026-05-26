import { createContext, useState, useContext, useEffect } from 'react'

const AuthContext = createContext(null)

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null)
  const [token, setToken] = useState(localStorage.getItem('token'))
  const [perfilActivo, setPerfilActivo] = useState(null)
  const [perfiles, setPerfiles] = useState([])

  useEffect(() => {
    if (token) {
      const userData = localStorage.getItem('user')
      if (userData) {
        setUser(JSON.parse(userData))
      }
    }
  }, [token])

  const login = (userData, userToken) => {
    setUser(userData)
    setToken(userToken)
    localStorage.setItem('token', userToken)
    localStorage.setItem('user', JSON.stringify(userData))
  }

  const logout = () => {
    setUser(null)
    setToken(null)
    setPerfilActivo(null)
    setPerfiles([])
    localStorage.removeItem('token')
    localStorage.removeItem('user')
  }

  const selectPerfil = (perfil) => {
    setPerfilActivo(perfil)
    localStorage.setItem('perfil_activo', JSON.stringify(perfil))
  }

  const isAuthenticated = !!token && !!user

  return (
    <AuthContext.Provider value={{
      user,
      token,
      perfilActivo,
      perfiles,
      setPerfiles,
      selectPerfil,
      login,
      logout,
      isAuthenticated
    }}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  const context = useContext(AuthContext)
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider')
  }
  return context
}