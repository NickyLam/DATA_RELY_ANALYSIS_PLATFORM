import axios from 'axios'

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000/api/v1'

export interface LineageNode {
  id: string
  name: string
  type: string
  properties?: Record<string, unknown>
}

export interface LineageEdge {
  source_id: string
  target_id: string
  edge_type: string
  properties?: Record<string, unknown>
  transformation_type?: string
  expression?: string
  confidence_score?: number
}

export interface LineageGraph {
  nodes: LineageNode[]
  edges: LineageEdge[]
  depth?: number
  total_nodes: number
  total_edges: number
}

export interface LineagePath {
  nodes: LineageNode[]
  edges: LineageEdge[]
  path_length: number
}

export type DirectionType = 'upstream' | 'downstream' | 'both'

export const lineageApi = {
  getTableLineage: async (
    tableId: string,
    depth: number = 5,
    direction: DirectionType = 'upstream'
  ): Promise<LineageGraph> => {
    const response = await axios.get<LineageGraph>(`${API_BASE_URL}/lineage/table/${tableId}`, {
      params: { depth, direction },
    })
    return response.data
  },

  getTableDetails: async (tableId: string): Promise<LineageNode> => {
    const response = await axios.get<LineageNode>(`${API_BASE_URL}/lineage/table/${tableId}/details`)
    return response.data
  },

  getFieldLineage: async (fieldId: string): Promise<LineagePath> => {
    const response = await axios.get<LineagePath>(`${API_BASE_URL}/lineage/field/${fieldId}`)
    return response.data
  },

  getImpactAnalysis: async (tableId: string, depth: number = 5): Promise<LineageGraph> => {
    const response = await axios.get<LineageGraph>(`${API_BASE_URL}/lineage/impact/${tableId}`, {
      params: { depth },
    })
    return response.data
  },

  searchTables: async (
    name?: string,
    exactName?: string,
    dataSourceId?: string,
    limit: number = 20,
    offset: number = 0
  ): Promise<LineageNode[]> => {
    const response = await axios.get<LineageNode[]>(`${API_BASE_URL}/lineage/search`, {
      params: {
        name,
        exact_name: exactName,
        data_source_id: dataSourceId,
        limit,
        offset,
      },
    })
    return response.data
  },
}