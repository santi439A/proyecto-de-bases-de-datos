import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { AuthProvider, useAuth } from './context/AuthContext'
import Login from './pages/Login'
import Registro from './pages/Registro'
import Home from './pages/Home'
import Catalogo from './pages/Catalogo'
import Detalle from './pages/Detalle'
import Favoritos from './pages/Favoritos'
import Perfiles from './pages/Perfiles'
import AdminDashboard from './pages/admin/AdminDashboard'
import AdminReportes from './pages/admin/AdminReportes'
import AdminEmpleados from './pages/admin/AdminEmpleados'
import AdminDepartamentos from './pages/admin/AdminDepartamentos'
import Navbar from './components/Navbar'

function ProtectedRoute({ children }) {
  const { isAuthenticated } = useAuth()
  return isAuthenticated ? children : <Navigate to="/login" />
}

function AppRoutes() {
  return (
    <>
      <Navbar />
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/registro" element={<Registro />} />
        <Route path="/" element={<Home />} />
        <Route path="/catalogo" element={<ProtectedRoute><Catalogo /></ProtectedRoute>} />
        <Route path="/detalle/:id" element={<ProtectedRoute><Detalle /></ProtectedRoute>} />
        <Route path="/favoritos" element={<ProtectedRoute><Favoritos /></ProtectedRoute>} />
        <Route path="/perfiles" element={<ProtectedRoute><Perfiles /></ProtectedRoute>} />
        <Route path="/admin" element={<ProtectedRoute><AdminDashboard /></ProtectedRoute>} />
        <Route path="/admin/reportes" element={<ProtectedRoute><AdminReportes /></ProtectedRoute>} />
        <Route path="/admin/empleados" element={<ProtectedRoute><AdminEmpleados /></ProtectedRoute>} />
        <Route path="/admin/departamentos" element={<ProtectedRoute><AdminDepartamentos /></ProtectedRoute>} />
      </Routes>
    </>
  )
}

function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <AppRoutes />
      </BrowserRouter>
    </AuthProvider>
  )
}

export default App