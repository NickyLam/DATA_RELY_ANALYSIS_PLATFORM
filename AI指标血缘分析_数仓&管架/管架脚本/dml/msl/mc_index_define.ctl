options(bindsize=2097152,readsize=2097152,errors=0,rows=5000)
load data
infile '/mcs/data/input/20200630/msl/mc_index_define.dat'
truncate into table mcs.mc_index_define
fields terminated by '|' 
trailing nullcols
(
  INDEX_NO           VARCHAR(60)   nullif  index_no=blanks         
 ,INDEX_CLSAA_F     VARCHAR(200)  nullif  index_clsaa_f=blanks    
 ,INDEX_CLSAA_S     VARCHAR(200)  nullif  index_clsaa_s=blanks    
 ,INDEX_NO_MCS      VARCHAR(60)   nullif  index_no_mcs=blanks     
 ,INDEX_CLSAA_F_MCS VARCHAR(200)  nullif  index_clsaa_f_mcs=blanks
 ,INDEX_CLSAA_S_MCS VARCHAR(200)  nullif  index_clsaa_s_mcs=blanks
 ,INDEX_CLSAA_T_MCS VARCHAR(200)  nullif  index_clsaa_t_mcs=blanks
 ,INDEX_NAME_MCS    VARCHAR(200) nullif   index_name_mcs=blanks   
 ,INDEX_NAME        VARCHAR(200)  nullif  index_name=blanks       
 ,SOURCE_SYSTEM     VARCHAR(200)  nullif  source_system=blanks    
 ,DEPT_MG           VARCHAR(200)  nullif  dept_mg=blanks          
 ,DEPT_USE          VARCHAR(200)  nullif  dept_use=blanks         
 ,REGULATORY_FLAG   VARCHAR(10)   nullif  regulatory_flag=blanks  
 ,INDEX_TYPE        VARCHAR(60)   nullif  index_type=blanks       
 ,FREQUENCY         VARCHAR(10)   nullif  frequency=blanks        
 ,DIMENSION         VARCHAR(200)  nullif  dimension=blanks        
 ,UNIT              VARCHAR(60)  nullif   unit=blanks             
 ,MANUAL_ADJ_FLAG   VARCHAR(10)  nullif   manual_adj_flag=blanks  
 ,INDEX_STATE       VARCHAR(10)  nullif   index_state=blanks      
 ,ETL_DT            date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks          
 ,ETL_TIMESTAMP     date "yyyy-mm-dd hh24:mi:ss" nullif etl_timestamp=blanks 
)