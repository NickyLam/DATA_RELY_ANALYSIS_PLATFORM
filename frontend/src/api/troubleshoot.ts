import axios from 'axios'

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000/api/v1'

export interface QuickSearchResult {
  object_id: string
  object_name: string
  object_type: string
  database?: string
  schema?: string
  description?: string
  has_lineage: boolean
  lineage_count: number
}

export interface QuickSearchResponse {
  results: QuickSearchResult[]
  total_count: number
}

export interface LineageRelation {
  source_id: string
  source_name: string
  source_type: string
  target_id: string
  target_name: string
  target_type: string
  lineage_type: string
  sources: string[]
  confidence_score: number
  transformation_type?: string
  expression?: string
  execution_count: number
  first_seen?: string
  last_seen?: string
}

export interface BatchExecution {
  batch_id: string
  job_name: string
  job_type: string
  status: string
  start_time: string
  end_time?: string
  duration_seconds: number
  records_processed: number
  records_failed: number
  error_message?: string
  source_tables: string[]
  target_tables: string[]
}

export interface ChangeRecord {
  change_id: string
  change_type: string
  object_type: string
  object_name: string
  change_time: string
  change_user?: string
  change_description?: string
  before_value?: string
  after_value?: string
  related_job?: string
  impact_level: string
}

export interface TroubleshootResult {
  object_id: string
  object_name: string
  object_type: string
  data_source?: string
  upstream_lineages: LineageRelation[]
  downstream_lineages: LineageRelation[]
  recent_batches: BatchExecution[]
  change_history: ChangeRecord[]
  potential_issues: string[]
  recommendations: string[]
  statistics: Record<string, unknown>
}

export interface TroubleshootQueryRequest {
  object_name: string
  object_type?: string
  data_source_id?: string
  include_runtime?: boolean
  include_changes?: boolean
  days_limit?: number
}

export const troubleshootApi = {
  quickSearch: async (keyword: string, searchType: string = 'all', limit: number = 10): Promise<QuickSearchResponse> => {
    const response = await axios.get(`${API_BASE_URL}/troubleshoot/search`, {
      params: { keyword, search_type: searchType, limit },
    })
    return response.data
  },

  analyzeObject: async (request: TroubleshootQueryRequest): Promise<TroubleshootResult> => {
    const response = await axios.post(`${API_BASE_URL}/troubleshoot/analyze`, request)
    return response.data
  },

  analyzeObjectByName: async (
    objectName: string,
    objectType: string = 'table',
    includeRuntime: boolean = true,
    includeChanges: boolean = true,
    daysLimit: number = 7
  ): Promise<TroubleshootResult> => {
    const response = await axios.get(`${API_BASE_URL}/troubleshoot/analyze/${objectName}`, {
      params: {
        object_type: objectType,
        include_runtime: includeRuntime,
        include_changes: includeChanges,
        days_limit: daysLimit,
      },
    })
    return response.data
  },

  getStatistics: async (): Promise<Record<string, unknown>> => {
    const response = await axios.get(`${API_BASE_URL}/troubleshoot/statistics`)
    return response.data
  },
}