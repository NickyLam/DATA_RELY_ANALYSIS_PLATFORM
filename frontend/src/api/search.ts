import axios from 'axios'

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000/api/v1'

export interface TableSearchResult {
  id: string
  name: string
  schema_name: string
  database_name: string
  data_source_id: string
  data_source_name: string
  table_type: string
  description: string | null
  column_count: number
  lineage_count: number
  upstream_count: number
  downstream_count: number
  owner: string | null
  created_at: string
  updated_at: string
}

export interface FieldSearchResult {
  id: string
  name: string
  table_id: string
  table_name: string
  schema_name: string
  database_name: string
  data_source_id: string
  data_source_name: string
  data_type: string | null
  is_primary_key: boolean
  is_foreign_key: boolean
  is_nullable: boolean
  description: string | null
  position: number | null
  lineage_count: number
}

export interface SearchResult {
  tables: TableSearchResult[]
  fields: FieldSearchResult[]
  total_tables: number
  total_fields: number
  page: number
  page_size: number
  total_pages: number
}

export interface DataSourceOption {
  id: string
  name: string
  type: string
}

export interface FilterOptions {
  data_sources: DataSourceOption[]
  schemas: string[]
  table_types: string[]
  data_types: string[]
}

export type SearchType = 'all' | 'tables' | 'fields'
export type SortField = 'name' | 'created_at' | 'updated_at' | 'column_count' | 'lineage_count'
export type SortOrder = 'asc' | 'desc'

export interface SearchParams {
  keyword?: string
  exact_name?: string
  data_source_id?: string
  schema_name?: string
  table_type?: string
  owner?: string
  data_type?: string
  table_name?: string
  search_type?: SearchType
  sort_by?: SortField
  sort_order?: SortOrder
  page?: number
  page_size?: number
}

export const searchApi = {
  searchTables: async (params: SearchParams): Promise<SearchResult> => {
    const response = await axios.get<SearchResult>(`${API_BASE_URL}/search/tables`, { params })
    return response.data
  },

  searchFields: async (params: SearchParams): Promise<SearchResult> => {
    const response = await axios.get<SearchResult>(`${API_BASE_URL}/search/fields`, { params })
    return response.data
  },

  searchAll: async (params: SearchParams): Promise<SearchResult> => {
    const response = await axios.get<SearchResult>(`${API_BASE_URL}/search/all`, { params })
    return response.data
  },

  advancedSearch: async (params: SearchParams): Promise<SearchResult> => {
    const response = await axios.post<SearchResult>(`${API_BASE_URL}/search/search`, params)
    return response.data
  },

  getFilterOptions: async (dataSourceId?: string): Promise<FilterOptions> => {
    const response = await axios.get<FilterOptions>(`${API_BASE_URL}/search/filter-options`, {
      params: { data_source_id: dataSourceId },
    })
    return response.data
  },

  getDataSources: async (): Promise<DataSourceOption[]> => {
    const response = await axios.get<DataSourceOption[]>(`${API_BASE_URL}/search/data-sources`)
    return response.data
  },

  getSchemas: async (dataSourceId?: string): Promise<string[]> => {
    const response = await axios.get<string[]>(`${API_BASE_URL}/search/schemas`, {
      params: { data_source_id: dataSourceId },
    })
    return response.data
  },

  getTableTypes: async (): Promise<string[]> => {
    const response = await axios.get<string[]>(`${API_BASE_URL}/search/table-types`)
    return response.data
  },

  getDataTypes: async (): Promise<string[]> => {
    const response = await axios.get<string[]>(`${API_BASE_URL}/search/data-types`)
    return response.data
  },
}