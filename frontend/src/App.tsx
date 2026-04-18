import React from 'react'
import { Routes, Route } from 'react-router-dom'
import Layout from './components/Layout'
import SearchPage from './pages/SearchPage'
import LineagePage from './pages/LineagePage'
import FieldLineagePage from './pages/FieldLineagePage'
import ImpactPage from './pages/ImpactPage'
import DataSourcePage from './pages/DataSourcePage'

const App: React.FC = () => {
  return (
    <Routes>
      <Route path="/" element={<Layout />}>
        <Route index element={<SearchPage />} />
        <Route path="search" element={<SearchPage />} />
        <Route path="lineage/:tableId" element={<LineagePage />} />
        <Route path="field-lineage/:fieldId" element={<FieldLineagePage />} />
        <Route path="impact/:tableId" element={<ImpactPage />} />
        <Route path="data-sources" element={<DataSourcePage />} />
      </Route>
    </Routes>
  )
}

export default App