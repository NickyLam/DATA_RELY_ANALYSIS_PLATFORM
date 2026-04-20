import apiClient from './api'
import type { DirectionType, LineageGraph, LineageNode, LineagePath } from '../types/lineage'

export const lineageService = {
  async getTableLineage(
    tableId: string,
    depth: number = 5,
    direction: DirectionType = 'upstream'
  ): Promise<LineageGraph> {
    const response = await apiClient.get<LineageGraph>(`/lineage/table/${tableId}`, {
      params: { depth, direction },
    })
    return response.data
  },

  async getTableDetails(tableId: string): Promise<LineageNode> {
    const response = await apiClient.get<LineageNode>(`/lineage/table/${tableId}/details`)
    return response.data
  },

  async getFieldLineage(fieldId: string): Promise<LineagePath> {
    const response = await apiClient.get<LineagePath>(`/lineage/field/${fieldId}`)
    return response.data
  },

  async getImpactAnalysis(tableId: string, depth: number = 5): Promise<LineageGraph> {
    const response = await apiClient.get<LineageGraph>(`/lineage/impact/${tableId}`, {
      params: { depth },
    })
    return response.data
  },

  async searchTables(
    name?: string,
    exactName?: string,
    dataSourceId?: string,
    limit: number = 20,
    offset: number = 0
  ): Promise<LineageNode[]> {
    const response = await apiClient.get<LineageNode[]>('/lineage/search', {
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