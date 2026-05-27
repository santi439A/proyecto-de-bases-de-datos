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
import AdminContenido from './pages/admin/AdminContenido'
import Navbar from './components/Navbar'

function ProtectedRoute({ children }) {
  const { isAuthenticated, isAdmin, user } = useAuth()
  if (!isAuthenticated) return <Navigate to="/login" />
  return children
}

function AdminRoute({ children }) {
  const { isAuthenticated, isAdmin } = useAuth()
  if (!isAuthenticated) return <Navigate to="/login" />
  if (!isAdmin) return <Navigate to="/catalogo" />
  return children
}

function UserRoute({ children }) {
  const { isAuthenticated, isAdmin } = useAuth()
  if (!isAuthenticated) return <Navigate to="/login" />
  if (isAdmin) return <Navigate to="/admin" />
  return children
}

function AppRoutes() {
  return (
    <>
      <Navbar />
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/registro" element={<Registro />} />
        <Route path="/" element={<Home />} />
        <Route path="/catalogo" element={<UserRoute><Catalogo /></UserRoute>} />
        <Route path="/detalle/:id" element={<UserRoute><Detalle /></UserRoute>} />
        <Route path="/favoritos" element={<UserRoute><Favoritos /></UserRoute>} />
        <Route path="/perfiles" element={<UserRoute><Perfiles /></UserRoute>} />
        <Route path="/admin" element={<AdminRoute><AdminDashboard /></AdminRoute>} />
        <Route path="/admin/contenido" element={<AdminRoute><AdminContenido /></AdminRoute>} />
        <Route path="/admin/reportes" element={<AdminRoute><AdminReportes /></AdminRoute>} />
        <Route path="/admin/empleados" element={<AdminRoute><AdminEmpleados /></AdminRoute>} />
        <Route path="/admin/departamentos" element={<AdminRoute><AdminDepartamentos /></AdminRoute>} />
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