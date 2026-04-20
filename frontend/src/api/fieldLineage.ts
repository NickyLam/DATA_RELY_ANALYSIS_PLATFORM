import axios from 'axios'

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000/api/v1'

export interface FieldNode {
  id: string
  name: string
  table_name: string
  full_name: string
  data_type?: string
  expression?: string
  is_source: boolean
  properties: Record<string, unknown>
}

export interface ExpressionDetail {
  raw_expression: string
  parsed_expression: string
  transformation_type: string
  source_fields: string[]
  aggregation_type?: string
  join_condition?: string
  filter_condition?: string
  description?: string
}

export interface FieldEdge {
  source_id: string
  target_id: string
  transformation_type: string
  expression?: string
  confidence_score: number
  sql_statement?: string
  job_id?: string
  expression_detail?: ExpressionDetail
  properties: Record<string, unknown>
}

export interface ShortestPathResponse {
  nodes: FieldNode[]
  edges: FieldEdge[]
  path_length: number
  total_weight: number
  source_nodes: FieldNode[]
  multi_source_paths: Record<string, FieldNode[]>
  is_multi_source: boolean
}

export interface FieldDetail {
  id: string
  name: string
  full_name: string
  table_name?: string
  data_source?: string
  data_type?: string
  expression?: string
  is_source: boolean
  created_at?: string
  updated_at?: string
}

export interface FieldSearchResult {
  id: string
  name: string
  full_name: string
  table_name?: string
  data_type?: string
}

export interface FieldSearchParams {
  table_name?: string
  field_name?: string
  data_source_id?: string
  limit?: number
}

export interface ExportResponse {
  content: string
  format_type: string
  filename: string
  created_at: string
}

export const fieldLineageApi = {
  getShortestPath: async (
    fieldId: string,
    maxDepth: number = 10,
    includeExpression: boolean = true
  ): Promise<ShortestPathResponse> => {
    const response = await axios.get(`${API_BASE_URL}/field-lineage/shortest-path/${fieldId}`, {
      params: { max_depth: maxDepth, include_expression: includeExpression },
    })
    return response.data
  },

  getFieldDetail: async (fieldId: string): Promise<FieldDetail> => {
    const response = await axios.get(`${API_BASE_URL}/field-lineage/field/${fieldId}`)
    return response.data
  },

  searchFields: async (params: FieldSearchParams): Promise<FieldSearchResult[]> => {
    const response = await axios.get(`${API_BASE_URL}/field-lineage/search`, { params })
    return response.data
  },

  searchFieldsPost: async (params: FieldSearchParams): Promise<FieldSearchResult[]> => {
    const response = await axios.post(`${API_BASE_URL}/field-lineage/search`, params)
    return response.data
  },

  exportLineage: async (
    fieldId: string,
    formatType: string = 'json',
    maxDepth: number = 10
  ): Promise<ExportResponse> => {
    const response = await axios.post(
      `${API_BASE_URL}/field-lineage/export/${fieldId}`,
      { format_type: formatType },
      { params: { max_depth: maxDepth } }
    )
    return response.data
  },
}