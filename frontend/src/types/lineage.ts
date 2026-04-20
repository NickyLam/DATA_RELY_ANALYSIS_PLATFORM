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