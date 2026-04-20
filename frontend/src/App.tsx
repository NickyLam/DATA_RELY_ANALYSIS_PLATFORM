import React from 'react'
import { Routes, Route, Navigate } from 'react-router-dom'
import Layout from './components/Layout'
import ProtectedRoute from './components/ProtectedRoute'
import LoginPage from './pages/LoginPage'
import SearchPage from './pages/SearchPage'
import LineagePage from './pages/LineagePage'
import FieldLineagePage from './pages/FieldLineagePage'
import ImpactPage from './pages/ImpactPage'
import DataSourcePage from './pages/DataSourcePage'

const App: React.FC = () => {
  return (
    <Routes>
      <Route path="/login" element={<LoginPage />} />
      <Route
        path="/"
        element={
          <ProtectedRoute>
            <Layout />
          </ProtectedRoute>
        }
      >
        <Route index element={<Navigate to="/search" replace />} />
        <Route path="search" element={<SearchPage />} />
        <Route path="lineage/:tableId" element={<LineagePage />} />
        <Route path="lineage" element={<Navigate to="/search" replace />} />
        <Route path="field-lineage/:fieldId" element={<FieldLineagePage />} />
        <Route path="field-lineage" element={<FieldLineagePage />} />
        <Route path="impact/:tableId" element={<ImpactPage />} />
        <Route path="data-sources" element={<DataSourcePage />} />
      </Route>
      <Route path="*" element={<Navigate to="/login" replace />} />
    </Routes>
  )
}

export default App