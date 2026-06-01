/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_mtl_fml_f99_int_org_info_new
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
-- alter table ${itl_schema}.mtl_fml_f99_int_org_info_new drop partition p_${retain_day}; 20200901去除删除策略，保留全部
alter table ${itl_schema}.mtl_fml_f99_int_org_info_new drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.mtl_fml_f99_int_org_info_new add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.mtl_fml_f99_int_org_info_new partition for (to_date('${batch_date}','yyyymmdd')) (
     ETL_DT                       -- 数据日期     
    ,LP_ID                        -- 法人编号     
    ,ORG_ID                       -- 机构编号     
    ,ORG_NAME                     -- 机构名称     
    ,ORG_ABBR                     -- 机构简称     
    ,PRINC_EMPLY_ID               -- 负责人员工编号  
    ,CBRC_FIN_INST_ID             -- 银监会金融机构编号
    ,UNIONPAY_FIN_INST_ID         -- 银联金融机构编号 
    ,FIN_INST_IDF_CODE            -- 金融机构标识码  
    ,BUS_LICS_NUM                 -- 营业执照号码   
    ,FIN_LICS_NUM                 -- 金融许可证号   
    ,PBC_PAY_BANK_NO              -- 人行支付行号   
    ,FIN_INST_CODE                -- 金融机构编码   
    ,HQ_ORG_ID                    -- 总行机构编号   
    ,HQ_ORG_NAME                  -- 总行机构名称   
    ,BRCH_ID                      -- 分行编号     
    ,BRCH_NAME                    -- 分行名称     
    ,SUBRCH_ID                    -- 支行编号     
    ,SUBRCH_NAME                  -- 支行名称     
    ,ORG_TYPE_CD                  -- 机构类型代码   
    ,ORG_LEV_CD                   -- 机构级别代码   
    ,ORG_HIBCHY_CD                -- 机构层级代码   
    ,ORG_STATUS_CD                -- 机构状态代码   
    ,BUS_STATUS_CD                -- 营业状态代码   
    ,BUS_ORG_FLG                  -- 营业机构标志   
    ,ENTY_ORG_FLG                 -- 实体机构标志   
    ,ACCTI_ORG_FLG                -- 核算机构标志   
    ,ADMIN_ORG_FLG                -- 行政机构标志   
    ,ACCT_INSTIT_FLG              -- 账务机构标志   
    ,VTUAL_ACCTI_ORG_FLG          -- 虚拟核算机构标志 
    ,ADMIN_SUPER_ORG_ID           -- 行政上级机构编号 
    ,ACCT_SUPER_ORG_ID            -- 账务上级机构编号 
    ,ACCTI_SUPER_ORG_ID           -- 核算上级机构编号 
    ,FUNC_ORG_ID                  -- 职能机构编号   
    ,FUNC_DEPT_ID                 -- 职能部门编号   
    ,CTY_RG_CD                    -- 国家和地区代码  
    ,PROV_CD                      -- 省代码      
    ,CITY_CD                      -- 市代码      
    ,COUNTY_CD                    -- 县代码      
    ,PHYS_ADDR                    -- 物理地址     
    ,DDD_AREA_CD                  -- 国内长途区号   
    ,PHONE                        -- 联系电话     
    ,ZIP_CD                       -- 邮政编码     
    ,ORG_FOUND_DT                 -- 机构成立日期   
    ,ORG_REVO_DT                  -- 机构撤销日期   
    ,ORG_START_BUS_TM             -- 机构开始营业时间 
    ,ORG_END_BUS_TM               -- 机构结束营业时间  
    ,ETL_TIMESTAMP                -- ETL处理时间戳
)
select
    TO_DATE('${batch_date}','yyyymmdd') as ETL_DT
    ,nvl(trim(LP_ID               ),'') as LP_ID                
    ,nvl(trim(ORG_ID              ),'') as ORG_ID               
    ,nvl(trim(ORG_NAME            ),'') as ORG_NAME             
    ,nvl(trim(ORG_ABBR            ),'') as ORG_ABBR             
    ,nvl(trim(PRINC_EMPLY_ID      ),'') as PRINC_EMPLY_ID       
    ,nvl(trim(CBRC_FIN_INST_ID    ),'') as CBRC_FIN_INST_ID     
    ,nvl(trim(UNIONPAY_FIN_INST_ID),'') as UNIONPAY_FIN_INST_ID 
    ,nvl(trim(FIN_INST_IDF_CODE   ),'') as FIN_INST_IDF_CODE    
    ,nvl(trim(BUS_LICS_NUM        ),'') as BUS_LICS_NUM         
    ,nvl(trim(FIN_LICS_NUM        ),'') as FIN_LICS_NUM         
    ,nvl(trim(PBC_PAY_BANK_NO     ),'') as PBC_PAY_BANK_NO      
    ,nvl(trim(FIN_INST_CODE       ),'') as FIN_INST_CODE        
    ,nvl(trim(HQ_ORG_ID           ),'') as HQ_ORG_ID            
    ,nvl(trim(HQ_ORG_NAME         ),'') as HQ_ORG_NAME          
    ,nvl(trim(BRCH_ID             ),'') as BRCH_ID              
    ,nvl(trim(BRCH_NAME           ),'') as BRCH_NAME            
    ,nvl(trim(SUBRCH_ID           ),'') as SUBRCH_ID            
    ,nvl(trim(SUBRCH_NAME         ),'') as SUBRCH_NAME          
    ,nvl(trim(ORG_TYPE_CD         ),'') as ORG_TYPE_CD          
    ,nvl(trim(ORG_LEV_CD          ),'') as ORG_LEV_CD           
    ,nvl(trim(ORG_HIBCHY_CD       ),'') as ORG_HIBCHY_CD        
    ,nvl(trim(ORG_STATUS_CD       ),'') as ORG_STATUS_CD        
    ,nvl(trim(BUS_STATUS_CD       ),'') as BUS_STATUS_CD        
    ,nvl(trim(BUS_ORG_FLG         ),'') as BUS_ORG_FLG          
    ,nvl(trim(ENTY_ORG_FLG        ),'') as ENTY_ORG_FLG         
    ,nvl(trim(ACCTI_ORG_FLG       ),'') as ACCTI_ORG_FLG        
    ,nvl(trim(ADMIN_ORG_FLG       ),'') as ADMIN_ORG_FLG        
    ,nvl(trim(ACCT_INSTIT_FLG     ),'') as ACCT_INSTIT_FLG      
    ,nvl(trim(VTUAL_ACCTI_ORG_FLG ),'') as VTUAL_ACCTI_ORG_FLG  
    ,nvl(trim(ADMIN_SUPER_ORG_ID  ),'') as ADMIN_SUPER_ORG_ID   
    ,nvl(trim(ACCT_SUPER_ORG_ID   ),'') as ACCT_SUPER_ORG_ID    
    ,nvl(trim(ACCTI_SUPER_ORG_ID  ),'') as ACCTI_SUPER_ORG_ID   
    ,nvl(trim(FUNC_ORG_ID         ),'') as FUNC_ORG_ID          
    ,nvl(trim(FUNC_DEPT_ID        ),'') as FUNC_DEPT_ID         
    ,nvl(trim(CTY_RG_CD           ),'') as CTY_RG_CD            
    ,nvl(trim(PROV_CD             ),'') as PROV_CD              
    ,nvl(trim(CITY_CD             ),'') as CITY_CD              
    ,nvl(trim(COUNTY_CD           ),'') as COUNTY_CD            
    ,nvl(trim(PHYS_ADDR           ),'') as PHYS_ADDR            
    ,nvl(trim(DDD_AREA_CD         ),'') as DDD_AREA_CD          
    ,nvl(trim(PHONE               ),'') as PHONE                
    ,nvl(trim(ZIP_CD              ),'') as ZIP_CD               
    ,nvl(ORG_FOUND_DT,null)             as ORG_FOUND_DT         
    ,nvl(ORG_REVO_DT ,null)             as ORG_REVO_DT          
    ,nvl(trim(ORG_START_BUS_TM),'')     as ORG_START_BUS_TM     
    ,nvl(trim(ORG_END_BUS_TM  ),'')     as ORG_END_BUS_TM       
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间

from ${msl_schema}.msl_fml_f99_int_org_info
where etl_dt = to_date('${batch_date}','yyyymmdd')
 ;
commit;


-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.mtl_fml_f99_int_org_info_new to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'mtl_fml_f99_int_org_info_new',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);