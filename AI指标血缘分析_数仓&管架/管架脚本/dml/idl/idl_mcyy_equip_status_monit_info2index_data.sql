/*
Purpose:    指标应用层-设备状态监控信息日报表，清空目标表当天分区数据，把当天数据与目标表进行分区交换.此脚本由生成引擎自动生成.
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_equip_status_monit_info2index_data
CreateDate: 20210705
修改记录：

    郑沛隆 2021-07-05 新建脚本 
    
*/   
/*
    依赖于基础数据表：
    BASE_D_EQUIP_STATUS_MONIT_INFO
    生成数据表:
    BASE_D_TO_INDEX_DATA
    生成指标列表  
	1	WD041016	网点作业	自助设备管理(ATM/CRS)		统计吞卡张数	原始值	张               
	2	WD041017	网点作业	自助设备管理(ATM/CRS)		设备故障率		计算值	%               
	3	WD041018	网点作业	自助设备管理(ATM/CRS)		故障时长		  原始值	分钟            
	4	WD041019	网点作业	自助设备管理(ATM/CRS)		故障次数		  原始值  次            
	5	WD041020	网点作业	自助设备管理(ATM/CRS)		维护停机占比	计算值	%               
	6	WD041021	网点作业	自助设备管理(ATM/CRS)		故障停机占比	计算值	%               
	7	WD041022	网点作业	自助设备管理(ATM/CRS)		离线停机占比	计算值	%               
	8	WD041023	网点作业	自助设备管理(ATM/CRS)		缺纸时长		  原始值	分钟            
  9	WD041024	网点作业	自助设备管理(ATM/CRS)		缺钞时长		  原始值	分钟            
 10	WD041025	网点作业	自助设备管理(ATM/CRS)		钞满时长		  原始值	分钟            
 11	WD041026	网点作业	自助设备管理(ATM/CRS)		缺纸次数		  原始值	次             
 12	WD041027	网点作业	自助设备管理(ATM/CRS)		缺钞次数		  原始值	次             
 13	WD041028	网点作业	自助设备管理(ATM/CRS)		钞满次数		  原始值	次             

*/  


set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${idl_schema}.base_d_to_index_data_${batch_date}_status_monit_info purge ;
alter table ${idl_schema}.base_d_to_index_data add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
        subpartition p_${batch_date}_base_d_equip_status_monit_info values ('BASE_D_EQUIP_STATUS_MONIT_INFO'))
;

alter table ${idl_schema}.base_d_to_index_data modify partition p_${batch_date}
    add subpartition p_${batch_date}_base_d_equip_status_monit_info values ('BASE_D_EQUIP_STATUS_MONIT_INFO')
;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.base_d_to_index_data_${batch_date}_status_monit_info
compress ${option_switch} for query high
as
select
    *
from ${idl_schema}.base_d_to_index_data
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- WD041016  统计吞卡张数
INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_status_monit_info
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041016' AS index_no --指标编号 
          ,t1.equip_id AS org_no --指标主体号 
          ,t1.equip_belong_org_code AS super_org_no -- 上级机构号 
          ,NULL bu_type --VARCHAR2(30)分类     
          ,t1.capture_bin_count AS index_value --指标值   
          ,'BASE_D_EQUIP_STATUS_MONIT_INFO' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_equip_status_monit_info t1
    WHERE  etl_dt = to_date('${batch_date}'
                           ,'yyyymmdd')
    AND T1.self_equip_type  IN ('ATM','CRS');

COMMIT;


--WD041018 故障时长

INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_status_monit_info
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041018' AS index_no --指标编号 
          ,t1.equip_id AS org_no --指标主体号 
          ,t1.equip_belong_org_code AS super_org_no -- 上级机构号 
          ,NULL bu_type --VARCHAR2(30)分类     
          ,t1.fault_tot_tm AS index_value --指标值   
          ,'BASE_D_EQUIP_STATUS_MONIT_INFO' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_equip_status_monit_info t1
    WHERE  etl_dt = to_date('${batch_date}'
                           ,'yyyymmdd')
    AND T1.self_equip_type  IN ('ATM','CRS');
                           

COMMIT;

--WD041019 故障次数

INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_status_monit_info
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041019' AS index_no --指标编号 
          ,t1.equip_id AS org_no --指标主体号 
          ,t1.equip_belong_org_code AS super_org_no -- 上级机构号 
          ,NULL bu_type --VARCHAR2(30)分类     
          ,t1.fault_tot_cnt AS index_value --指标值   
          ,'BASE_D_EQUIP_STATUS_MONIT_INFO' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_equip_status_monit_info t1
    WHERE  etl_dt = to_date('${batch_date}'
                           ,'yyyymmdd')
    AND T1.self_equip_type  IN ('ATM','CRS');
                           

COMMIT;

--WD041020	维护停机占比	   

INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_status_monit_info
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041020' AS index_no --指标编号 
          ,t1.equip_id AS org_no --指标主体号 
          ,t1.equip_belong_org_code AS super_org_no -- 上级机构号 
          ,NULL bu_type --VARCHAR2(30)分类     
          ,(case when t1.denom=0 then 0 
           else t1.matn_stop_duran/t1.denom
           end) AS index_value --指标值   
          ,'BASE_D_EQUIP_STATUS_MONIT_INFO' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_equip_status_monit_info t1
    WHERE  etl_dt = to_date('${batch_date}'
                           ,'yyyymmdd')
    AND T1.self_equip_type  IN ('ATM','CRS');
                           

COMMIT;
      
--WD041021	故障停机占比	  

INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_status_monit_info
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041021' AS index_no --指标编号 
          ,t1.equip_id AS org_no --指标主体号 
          ,t1.equip_belong_org_code AS super_org_no -- 上级机构号 
          ,NULL bu_type --VARCHAR2(30)分类     
          ,(case when t1.denom=0 then 0 
           else t1.fault_stop_duran/t1.denom
           end) AS index_value --指标值   
          ,'BASE_D_EQUIP_STATUS_MONIT_INFO' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_equip_status_monit_info t1
    WHERE  etl_dt = to_date('${batch_date}'
                           ,'yyyymmdd')
    AND T1.self_equip_type  IN ('ATM','CRS');

COMMIT;    
   
--WD041022	离线停机占比	   

INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_status_monit_info
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041022' AS index_no --指标编号 
          ,t1.equip_id AS org_no --指标主体号 
          ,t1.equip_belong_org_code AS super_org_no -- 上级机构号 
          ,NULL bu_type --VARCHAR2(30)分类     
          ,(case when t1.denom=0 then 0 
           else t1.offline_stop_duran/t1.denom
           end) AS index_value --指标值   
          ,'BASE_D_EQUIP_STATUS_MONIT_INFO' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_equip_status_monit_info t1
    WHERE  etl_dt = to_date('${batch_date}'
                           ,'yyyymmdd')
    AND T1.self_equip_type  IN ('ATM','CRS');
                           

COMMIT;  

-- WD041017 设备故障率  
INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_status_monit_info
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041017' AS index_no --指标编号 
          ,t1.equip_id AS org_no --指标主体号 
          ,t1.equip_belong_org_code AS super_org_no -- 上级机构号 
          ,NULL bu_type --VARCHAR2(30)分类     
          ,(case when t1.denom=0 then 0 
           else t1.fault_tot_tm/t1.denom
           end)  AS index_value --指标值   
          ,'BASE_D_EQUIP_STATUS_MONIT_INFO' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_equip_status_monit_info t1
    WHERE  etl_dt = to_date('${batch_date}'
                           ,'yyyymmdd')
    AND T1.self_equip_type  IN ('ATM','CRS');


COMMIT;

      
--WD041023	缺纸时长	

INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_status_monit_info
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )
    SELECT 'WD041023' AS index_no --指标编号 
          ,t1.equip_id AS org_no --指标主体号 
          ,t1.equip_belong_org_code AS super_org_no -- 上级机构号 
          ,NULL bu_type --VARCHAR2(30)分类     
          ,t1.qz_duran AS index_value --指标值   
          ,'BASE_D_EQUIP_STATUS_MONIT_INFO' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_equip_status_monit_info t1
    WHERE  etl_dt = to_date('${batch_date}'
                           ,'yyyymmdd')
    AND T1.self_equip_type  IN ('ATM','CRS');
                           

COMMIT;  	 
        
--WD041024	缺钞时长
INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_status_monit_info
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )
    SELECT 'WD041024' AS index_no --指标编号 
          ,t1.equip_id AS org_no --指标主体号 
          ,t1.equip_belong_org_code AS super_org_no -- 上级机构号 
          ,NULL bu_type --VARCHAR2(30)分类     
          ,t1.qc_duran AS index_value --指标值   
          ,'BASE_D_EQUIP_STATUS_MONIT_INFO' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_equip_status_monit_info t1
    WHERE  etl_dt = to_date('${batch_date}'
                           ,'yyyymmdd')
    AND T1.self_equip_type  IN ('ATM','CRS');
                           

COMMIT;  	
		         
--WD041025	钞满时长		  

INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_status_monit_info
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )
    SELECT 'WD041025' AS index_no --指标编号 
          ,t1.equip_id AS org_no --指标主体号 
          ,t1.equip_belong_org_code AS super_org_no -- 上级机构号 
          ,NULL bu_type --VARCHAR2(30)分类     
          ,t1.cm_duran AS index_value --指标值   
          ,'BASE_D_EQUIP_STATUS_MONIT_INFO' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_equip_status_monit_info t1
    WHERE  etl_dt = to_date('${batch_date}'
                           ,'yyyymmdd')
    AND T1.self_equip_type  IN ('ATM','CRS');
                           

COMMIT;   
     
--WD041026	缺纸次数	

INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_status_monit_info
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )
    SELECT 'WD041026' AS index_no --指标编号 
          ,t1.equip_id AS org_no --指标主体号 
          ,t1.equip_belong_org_code AS super_org_no -- 上级机构号 
          ,NULL bu_type --VARCHAR2(30)分类     
          ,t1.qz_cnt AS index_value --指标值   
          ,'BASE_D_EQUIP_STATUS_MONIT_INFO' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_equip_status_monit_info t1
    WHERE  etl_dt = to_date('${batch_date}'
                           ,'yyyymmdd')
    AND T1.self_equip_type  IN ('ATM','CRS');
                           

COMMIT;  	    
     
--WD041027	缺钞次数	

INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_status_monit_info
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )
    SELECT 'WD041027' AS index_no --指标编号 
          ,t1.equip_id AS org_no --指标主体号 
          ,t1.equip_belong_org_code AS super_org_no -- 上级机构号 
          ,NULL bu_type --VARCHAR2(30)分类     
          ,t1.qc_cnt AS index_value --指标值   
          ,'BASE_D_EQUIP_STATUS_MONIT_INFO' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_equip_status_monit_info t1
    WHERE  etl_dt = to_date('${batch_date}'
                           ,'yyyymmdd')
    AND T1.self_equip_type  IN ('ATM','CRS');
                          

COMMIT; 	   
      
--WD041028	钞满次数	

INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_status_monit_info
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )
    SELECT 'WD041028' AS index_no --指标编号 
          ,t1.equip_id AS org_no --指标主体号 
          ,t1.equip_belong_org_code AS super_org_no -- 上级机构号 
          ,NULL bu_type --VARCHAR2(30)分类     
          ,t1.cm_cnt AS index_value --指标值   
          ,'BASE_D_EQUIP_STATUS_MONIT_INFO' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_equip_status_monit_info t1
    WHERE  etl_dt = to_date('${batch_date}'
                           ,'yyyymmdd')
    AND T1.self_equip_type  IN ('ATM','CRS');
                           

COMMIT; 

	  
-- 3.2 truncate target table batch_date partition
alter table ${idl_schema}.base_d_to_index_data truncate subpartition p_${batch_date}_base_d_equip_status_monit_info reuse storage;


-- 3.3 exchage tm table and target table
alter table ${idl_schema}.base_d_to_index_data exchange subpartition p_${batch_date}_base_d_equip_status_monit_info with table ${idl_schema}.base_d_to_index_data_${batch_date}_status_monit_info;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.base_d_to_index_data to ${idl_schema};

-- 4.2 drop tm table
drop table ${idl_schema}.base_d_to_index_data_${batch_date}_status_monit_info purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'base_d_to_index_data', partname => 'p_${batch_date}_base_d_equip_status_monit_info', granularity => 'SUBPARTITION', degree => 8, cascade => true);

-- 6
whenever sqlerror continue none;

alter table ${idl_schema}.mcyy_bu_analysis truncate subpartition p_${batch_date}_equip_status_monit_info;

alter table ${idl_schema}.mcyy_bu_analysis add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
                                              subpartition p_${batch_date}_equip_status_monit_info values ('BASE_D_EQUIP_STATUS_MONIT_INFO')
                                              )
;
alter table ${idl_schema}.mcyy_bu_analysis modify partition p_${batch_date} 
                                             add subpartition p_${batch_date}_equip_status_monit_info values ('BASE_D_EQUIP_STATUS_MONIT_INFO')
;

whenever sqlerror exit sql.sqlcode;


call pkg_mcyy_ind_share_intfc.prc_get_sorc_sys_data('BASE_D_EQUIP_STATUS_MONIT_INFO',${batch_date});


-----涉及到率的指标需要单独处理
	/*
	1	WD041017	网点作业	自助设备管理(ATM/CRS)		设备故障率		计算值	%                 
	2	WD041020	网点作业	自助设备管理(ATM/CRS)		维护停机占比	计算值	%               
	3	WD041021	网点作业	自助设备管理(ATM/CRS)		故障停机占比	计算值	%               
	4	WD041022	网点作业	自助设备管理(ATM/CRS)		离线停机占比	计算值	% 
	 */
--2.1.1 先将设备数据插入到表

--2.1.1.1 第一组 WD041017 设备故障率

whenever sqlerror exit sql.sqlcode;
INSERT INTO ${idl_schema}.mcyy_bu_analysis
    (etl_dt -- 数据日期
    ,etl_timestamp -- ETL处理时间戳
    ,index_no -- 指标编码
    ,index_name -- 指标名称
    ,org_no -- 机构编码
    ,org_name -- 机构名称
    ,super_org_no -- 上级机构编码
    ,accu_index_value_d -- 当日累计
    ,accu_index_value_m -- 当月累计
    ,accu_index_value_q -- 当季累计
    ,accu_index_value_y -- 当年累计
    ,unit -- 单位
    ,frequency -- 频度
    ,measure_no --- 度量编号
    ,index_measure -- 度量名称
    ,source_sys --来源系统
     )

    WITH tmp_atm_fault_rat_data_d AS
     (SELECT (CASE
                 WHEN t1.denom = 0 THEN
                  0
                 ELSE
                  t1.fault_tot_tm / t1.denom
             END) AS fault_rat
            ,t1.equip_id AS org_no
            ,t1.equip_belong_org_code AS super_org_no
      FROM   base_d_equip_status_monit_info t1
      WHERE  t1.etl_dt = to_date('${batch_date}'
                                ,'yyyymmdd')
      AND    t1.self_equip_type IN ('ATM'
                                   ,'CRS')
      
      ),
    tmp_atm_fault_rat_data_m AS
     (SELECT (CASE
                 WHEN SUM(t1.denom) = 0 THEN
                  0
                 ELSE
                  SUM(t1.fault_tot_tm) / SUM(t1.denom)
             END) AS fault_rat
            ,t1.equip_id AS org_no
            ,t1.equip_belong_org_code AS super_org_no
      FROM   base_d_equip_status_monit_info t1
      WHERE  t1.etl_dt >= trunc(to_date('${batch_date}'
                                       ,'yyyyMMdd')
                               ,'MM')
      AND    t1.etl_dt <= to_date('${batch_date}'
                                 ,'yyyyMMdd')
      AND    t1.self_equip_type IN ('ATM'
                                   ,'CRS')
      GROUP  BY t1.equip_id, t1.equip_belong_org_code
      
      ),
    
    tmp_atm_fault_rat_data_q AS
     (SELECT (CASE
                 WHEN SUM(t1.denom) = 0 THEN
                  0
                 ELSE
                  SUM(t1.fault_tot_tm) / SUM(t1.denom)
             END) AS fault_rat
            ,t1.equip_id AS org_no
            ,t1.equip_belong_org_code AS super_org_no
      FROM   base_d_equip_status_monit_info t1
      
      WHERE  t1.etl_dt >= trunc(to_date('${batch_date}'
                                       ,'yyyymmdd')
                               ,'Q')
      AND    t1.etl_dt <= to_date('${batch_date}'
                                 ,'yyyyMMdd')
      AND    t1.self_equip_type IN ('ATM'
                                   ,'CRS')
      GROUP  BY t1.equip_id, t1.equip_belong_org_code),
    tmp_atm_fault_rat_data_y AS
     (SELECT (CASE
                 WHEN SUM(t1.denom) = 0 THEN
                  0
                 ELSE
                  SUM(t1.fault_tot_tm) / SUM(t1.denom)
             END) AS fault_rat
            ,t1.equip_id AS org_no
            ,t1.equip_belong_org_code AS super_org_no
      FROM   base_d_equip_status_monit_info t1
      
      WHERE  t1.etl_dt >= trunc(to_date('${batch_date}'
                                       ,'yyyymmdd')
                               ,'YYYY')
      AND    t1.etl_dt <= to_date('${batch_date}'
                                 ,'yyyyMMdd')
      AND    t1.self_equip_type IN ('ATM'
                                   ,'CRS')
      GROUP  BY t1.equip_id, t1.equip_belong_org_code
      
      ),
    tmp_td_initza AS
    --当日数据初始化
     (SELECT t6.index_no
            , --指标编码
             t6.index_name_mcs AS index_name
            , --指标名称
             t2.org_no AS org_no --柜员号
            ,t2.org_no AS org_name
            , --存在柜员名称为空的情况，所以统一用柜员号标识
             t2.super_org_no AS super_org_no
            , --柜员所属支行机构编码
             t2.fault_rat AS accu_index_value_d --当日累计
            ,coalesce(t3.fault_rat
                     ,0) AS accu_index_value_m --当月累计
            ,coalesce(t4.fault_rat
                     ,0) AS accu_index_value_q --当季累计 
            ,coalesce(t5.fault_rat
                     ,0) AS accu_index_value_y --当年累计
            ,t6.unit
            , -- 单位
             t6.frequency
            , -- 频度
             NULL measure_no
            , --- 度量编号
             t6.index_measure -- 度量名称
      FROM   ${idl_schema}.mcyy_orga_para t1
      LEFT   JOIN tmp_atm_fault_rat_data_d t2 --当日
      ON     t1.org_no = t2.super_org_no
      LEFT   JOIN tmp_atm_fault_rat_data_m t3 --当月
      ON     t2.org_no = t3.org_no
      AND    t2.super_org_no = t3.super_org_no
      LEFT   JOIN tmp_atm_fault_rat_data_q t4 --当季
      ON     t2.org_no = t4.org_no
      AND    t2.super_org_no = t4.super_org_no
      LEFT   JOIN tmp_atm_fault_rat_data_y t5 --当年
      ON     t2.org_no = t5.org_no
      AND    t2.super_org_no = t5.super_org_no
      INNER  JOIN ${idl_schema}.mcyy_index_define t6
      ON     'WD041017' = t6.index_no_mcs
      WHERE  length(t1.super_org_no) = 3 --只关联支行
      AND    t2.super_org_no IS NOT NULL)
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') etl_dt -- 数据日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp -- ETL处理时间戳
          ,mcyy_bu_analysis_tmp.index_no -- 指标编码
          ,mcyy_bu_analysis_tmp.index_name -- 指标名称
          ,mcyy_bu_analysis_tmp.org_no -- 机构编码
          ,mcyy_bu_analysis_tmp.org_name -- 机构名称
          ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_d) -- 当日累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_m) -- 当月累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_q) -- 当季累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_y) -- 当年累计          
          ,mcyy_bu_analysis_tmp.unit -- 单位
          ,mcyy_bu_analysis_tmp.frequency -- 频度
          ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
          ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
          ,'BASE_D_EQUIP_STATUS_MONIT_INFO' source_sys --来源系统
    FROM   (SELECT index_no
                  ,index_name
                  ,org_no
                  ,org_name
                  ,super_org_no
                  ,accu_index_value_d
                  ,accu_index_value_m
                  ,accu_index_value_q
                  ,accu_index_value_y
                  ,unit
                  ,frequency
                  ,measure_no
                  ,index_measure
            FROM   tmp_td_initza
            
            ) mcyy_bu_analysis_tmp
    
    GROUP  BY mcyy_bu_analysis_tmp.index_no -- 指标编码
             ,mcyy_bu_analysis_tmp.index_name -- 指标名称
             ,mcyy_bu_analysis_tmp.org_no -- 机构编码
             ,mcyy_bu_analysis_tmp.org_name -- 机构名称
             ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
             ,mcyy_bu_analysis_tmp.unit -- 单位
             ,mcyy_bu_analysis_tmp.frequency -- 频度
             ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
             ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
    
    ;

COMMIT;
--2.1.1.2 第二组 WD041020 维护停机占比

INSERT INTO ${idl_schema}.mcyy_bu_analysis
    (etl_dt -- 数据日期
    ,etl_timestamp -- ETL处理时间戳
    ,index_no -- 指标编码
    ,index_name -- 指标名称
    ,org_no -- 机构编码
    ,org_name -- 机构名称
    ,super_org_no -- 上级机构编码
    ,accu_index_value_d -- 当日累计
    ,accu_index_value_m -- 当月累计
    ,accu_index_value_q -- 当季累计
    ,accu_index_value_y -- 当年累计
    ,unit -- 单位
    ,frequency -- 频度
    ,measure_no --- 度量编号
    ,index_measure -- 度量名称
    ,source_sys --来源系统
     )

    WITH tmp_atm_matn_pct_data_d AS
     (SELECT (CASE
                 WHEN t1.denom = 0 THEN
                  0
                 ELSE
                  t1.matn_stop_duran / t1.denom
             END) AS matn_pct
            ,t1.equip_id AS org_no
            ,t1.equip_belong_org_code AS super_org_no
      FROM   base_d_equip_status_monit_info t1
      WHERE  t1.etl_dt = to_date('${batch_date}'
                                ,'yyyymmdd')
      AND    t1.self_equip_type IN ('ATM'
                                   ,'CRS')
      
      ),
    tmp_atm_matn_pct_data_m AS
     (SELECT (CASE
                 WHEN SUM(t1.denom) = 0 THEN
                  0
                 ELSE
                  SUM(t1.matn_stop_duran) / SUM(t1.denom)
             END) AS matn_pct
            ,t1.equip_id AS org_no
            ,t1.equip_belong_org_code AS super_org_no
      FROM   base_d_equip_status_monit_info t1
      WHERE  t1.etl_dt >= trunc(to_date('${batch_date}'
                                       ,'yyyyMMdd')
                               ,'MM')
      AND    t1.etl_dt <= to_date('${batch_date}'
                                 ,'yyyyMMdd')
      AND    t1.self_equip_type IN ('ATM'
                                   ,'CRS')
      GROUP  BY t1.equip_id, t1.equip_belong_org_code
      
      ),
    
    tmp_atm_matn_pct_data_q AS
     (SELECT (CASE
                 WHEN SUM(t1.denom) = 0 THEN
                  0
                 ELSE
                  SUM(t1.matn_stop_duran) / SUM(t1.denom)
             END) AS matn_pct
            ,t1.equip_id AS org_no
            ,t1.equip_belong_org_code AS super_org_no
      FROM   base_d_equip_status_monit_info t1
      
      WHERE  t1.etl_dt >= trunc(to_date('${batch_date}'
                                       ,'yyyymmdd')
                               ,'Q')
      AND    t1.etl_dt <= to_date('${batch_date}'
                                 ,'yyyyMMdd')
      AND    t1.self_equip_type IN ('ATM'
                                   ,'CRS')
      GROUP  BY t1.equip_id, t1.equip_belong_org_code),
    tmp_atm_matn_pct_data_y AS
     (SELECT (CASE
                 WHEN SUM(t1.denom) = 0 THEN
                  0
                 ELSE
                  SUM(t1.matn_stop_duran) / SUM(t1.denom)
             END) AS matn_pct
            ,t1.equip_id AS org_no
            ,t1.equip_belong_org_code AS super_org_no
      FROM   base_d_equip_status_monit_info t1
      
      WHERE  t1.etl_dt >= trunc(to_date('${batch_date}'
                                       ,'yyyymmdd')
                               ,'YYYY')
      AND    t1.etl_dt <= to_date('${batch_date}'
                                 ,'yyyyMMdd')
      AND    t1.self_equip_type IN ('ATM'
                                   ,'CRS')
      GROUP  BY t1.equip_id, t1.equip_belong_org_code
      
      ),
    tmp_td_initza AS
    --当日数据初始化
     (SELECT t6.index_no
            , --指标编码
             t6.index_name_mcs AS index_name
            , --指标名称
             t2.org_no AS org_no --柜员号
            ,t2.org_no AS org_name
            , --存在柜员名称为空的情况，所以统一用柜员号标识
             t2.super_org_no AS super_org_no
            , --柜员所属支行机构编码
             t2.matn_pct AS accu_index_value_d --当日累计
            ,coalesce(t3.matn_pct
                     ,0) AS accu_index_value_m --当月累计
            ,coalesce(t4.matn_pct
                     ,0) AS accu_index_value_q --当季累计 
            ,coalesce(t5.matn_pct
                     ,0) AS accu_index_value_y --当年累计
            ,t6.unit
            , -- 单位
             t6.frequency
            , -- 频度
             NULL measure_no
            , --- 度量编号
             t6.index_measure -- 度量名称
      FROM   ${idl_schema}.mcyy_orga_para t1
      LEFT   JOIN tmp_atm_matn_pct_data_d t2 --当日
      ON     t1.org_no = t2.super_org_no
      LEFT   JOIN tmp_atm_matn_pct_data_m t3 --当月
      ON     t2.org_no = t3.org_no
      AND    t2.super_org_no = t3.super_org_no
      LEFT   JOIN tmp_atm_matn_pct_data_q t4 --当季
      ON     t2.org_no = t4.org_no
      AND    t2.super_org_no = t4.super_org_no
      LEFT   JOIN tmp_atm_matn_pct_data_y t5 --当年
      ON     t2.org_no = t5.org_no
      AND    t2.super_org_no = t5.super_org_no
      INNER  JOIN ${idl_schema}.mcyy_index_define t6
      ON     'WD041020' = t6.index_no_mcs
      WHERE  length(t1.super_org_no) = 3 --只关联支行
      AND    t2.super_org_no IS NOT NULL)
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') etl_dt -- 数据日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp -- ETL处理时间戳
          ,mcyy_bu_analysis_tmp.index_no -- 指标编码
          ,mcyy_bu_analysis_tmp.index_name -- 指标名称
          ,mcyy_bu_analysis_tmp.org_no -- 机构编码
          ,mcyy_bu_analysis_tmp.org_name -- 机构名称
          ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_d) -- 当日累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_m) -- 当月累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_q) -- 当季累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_y) -- 当年累计          
          ,mcyy_bu_analysis_tmp.unit -- 单位
          ,mcyy_bu_analysis_tmp.frequency -- 频度
          ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
          ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
          ,'BASE_D_EQUIP_STATUS_MONIT_INFO' source_sys --来源系统
    FROM   (SELECT index_no
                  ,index_name
                  ,org_no
                  ,org_name
                  ,super_org_no
                  ,accu_index_value_d
                  ,accu_index_value_m
                  ,accu_index_value_q
                  ,accu_index_value_y
                  ,unit
                  ,frequency
                  ,measure_no
                  ,index_measure
            FROM   tmp_td_initza
            
            ) mcyy_bu_analysis_tmp
    
    GROUP  BY mcyy_bu_analysis_tmp.index_no -- 指标编码
             ,mcyy_bu_analysis_tmp.index_name -- 指标名称
             ,mcyy_bu_analysis_tmp.org_no -- 机构编码
             ,mcyy_bu_analysis_tmp.org_name -- 机构名称
             ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
             ,mcyy_bu_analysis_tmp.unit -- 单位
             ,mcyy_bu_analysis_tmp.frequency -- 频度
             ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
             ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
    
    ;

COMMIT;

--2.1.1.3 第三组 WD041021 故障停机占比

INSERT INTO ${idl_schema}.mcyy_bu_analysis
    (etl_dt -- 数据日期
    ,etl_timestamp -- ETL处理时间戳
    ,index_no -- 指标编码
    ,index_name -- 指标名称
    ,org_no -- 机构编码
    ,org_name -- 机构名称
    ,super_org_no -- 上级机构编码
    ,accu_index_value_d -- 当日累计
    ,accu_index_value_m -- 当月累计
    ,accu_index_value_q -- 当季累计
    ,accu_index_value_y -- 当年累计
    ,unit -- 单位
    ,frequency -- 频度
    ,measure_no --- 度量编号
    ,index_measure -- 度量名称
    ,source_sys --来源系统
     )

    WITH tmp_atm_FAULT_PCT_data_d AS
     (SELECT (CASE
                 WHEN t1.denom = 0 THEN
                  0
                 ELSE
                  t1.fault_stop_duran / t1.denom
             END) AS FAULT_PCT
            ,t1.equip_id AS org_no
            ,t1.equip_belong_org_code AS super_org_no
      FROM   base_d_equip_status_monit_info t1
      WHERE  t1.etl_dt = to_date('${batch_date}'
                                ,'yyyymmdd')
      AND    t1.self_equip_type IN ('ATM'
                                   ,'CRS')
      
      ),
    tmp_atm_FAULT_PCT_data_m AS
     (SELECT (CASE
                 WHEN SUM(t1.denom) = 0 THEN
                  0
                 ELSE
                  SUM(t1.fault_stop_duran) / SUM(t1.denom)
             END) AS FAULT_PCT
            ,t1.equip_id AS org_no
            ,t1.equip_belong_org_code AS super_org_no
      FROM   base_d_equip_status_monit_info t1
      WHERE  t1.etl_dt >= trunc(to_date('${batch_date}'
                                       ,'yyyyMMdd')
                               ,'MM')
      AND    t1.etl_dt <= to_date('${batch_date}'
                                 ,'yyyyMMdd')
      AND    t1.self_equip_type IN ('ATM'
                                   ,'CRS')
      GROUP  BY t1.equip_id, t1.equip_belong_org_code
      
      ),
    
    tmp_atm_FAULT_PCT_data_q AS
     (SELECT (CASE
                 WHEN SUM(t1.denom) = 0 THEN
                  0
                 ELSE
                  SUM(t1.fault_stop_duran) / SUM(t1.denom)
             END) AS FAULT_PCT
            ,t1.equip_id AS org_no
            ,t1.equip_belong_org_code AS super_org_no
      FROM   base_d_equip_status_monit_info t1
      
      WHERE  t1.etl_dt >= trunc(to_date('${batch_date}'
                                       ,'yyyymmdd')
                               ,'Q')
      AND    t1.etl_dt <= to_date('${batch_date}'
                                 ,'yyyyMMdd')
      AND    t1.self_equip_type IN ('ATM'
                                   ,'CRS')
      GROUP  BY t1.equip_id, t1.equip_belong_org_code),
    tmp_atm_FAULT_PCT_data_y AS
     (SELECT (CASE
                 WHEN SUM(t1.denom) = 0 THEN
                  0
                 ELSE
                  SUM(t1.fault_stop_duran) / SUM(t1.denom)
             END) AS FAULT_PCT
            ,t1.equip_id AS org_no
            ,t1.equip_belong_org_code AS super_org_no
      FROM   base_d_equip_status_monit_info t1
      
      WHERE  t1.etl_dt >= trunc(to_date('${batch_date}'
                                       ,'yyyymmdd')
                               ,'YYYY')
      AND    t1.etl_dt <= to_date('${batch_date}'
                                 ,'yyyyMMdd')
      AND    t1.self_equip_type IN ('ATM'
                                   ,'CRS')
      GROUP  BY t1.equip_id, t1.equip_belong_org_code
      
      ),
    tmp_td_initza AS
    --当日数据初始化
     (SELECT t6.index_no
            , --指标编码
             t6.index_name_mcs AS index_name
            , --指标名称
             t2.org_no AS org_no --柜员号
            ,t2.org_no AS org_name
            , --存在柜员名称为空的情况，所以统一用柜员号标识
             t2.super_org_no AS super_org_no
            , --柜员所属支行机构编码
             t2.FAULT_PCT AS accu_index_value_d --当日累计
            ,coalesce(t3.FAULT_PCT
                     ,0) AS accu_index_value_m --当月累计
            ,coalesce(t4.FAULT_PCT
                     ,0) AS accu_index_value_q --当季累计 
            ,coalesce(t5.FAULT_PCT
                     ,0) AS accu_index_value_y --当年累计
            ,t6.unit
            , -- 单位
             t6.frequency
            , -- 频度
             NULL measure_no
            , --- 度量编号
             t6.index_measure -- 度量名称
      FROM   ${idl_schema}.mcyy_orga_para t1
      LEFT   JOIN tmp_atm_FAULT_PCT_data_d t2 --当日
      ON     t1.org_no = t2.super_org_no
      LEFT   JOIN tmp_atm_FAULT_PCT_data_m t3 --当月
      ON     t2.org_no = t3.org_no
      AND    t2.super_org_no = t3.super_org_no
      LEFT   JOIN tmp_atm_FAULT_PCT_data_q t4 --当季
      ON     t2.org_no = t4.org_no
      AND    t2.super_org_no = t4.super_org_no
      LEFT   JOIN tmp_atm_FAULT_PCT_data_y t5 --当年
      ON     t2.org_no = t5.org_no
      AND    t2.super_org_no = t5.super_org_no
      INNER  JOIN ${idl_schema}.mcyy_index_define t6
      ON     'WD041021' = t6.index_no_mcs
      WHERE  length(t1.super_org_no) = 3 --只关联支行
      AND    t2.super_org_no IS NOT NULL)
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') etl_dt -- 数据日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp -- ETL处理时间戳
          ,mcyy_bu_analysis_tmp.index_no -- 指标编码
          ,mcyy_bu_analysis_tmp.index_name -- 指标名称
          ,mcyy_bu_analysis_tmp.org_no -- 机构编码
          ,mcyy_bu_analysis_tmp.org_name -- 机构名称
          ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_d) -- 当日累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_m) -- 当月累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_q) -- 当季累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_y) -- 当年累计          
          ,mcyy_bu_analysis_tmp.unit -- 单位
          ,mcyy_bu_analysis_tmp.frequency -- 频度
          ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
          ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
          ,'BASE_D_EQUIP_STATUS_MONIT_INFO' source_sys --来源系统
    FROM   (SELECT index_no
                  ,index_name
                  ,org_no
                  ,org_name
                  ,super_org_no
                  ,accu_index_value_d
                  ,accu_index_value_m
                  ,accu_index_value_q
                  ,accu_index_value_y
                  ,unit
                  ,frequency
                  ,measure_no
                  ,index_measure
            FROM   tmp_td_initza
            
            ) mcyy_bu_analysis_tmp
    
    GROUP  BY mcyy_bu_analysis_tmp.index_no -- 指标编码
             ,mcyy_bu_analysis_tmp.index_name -- 指标名称
             ,mcyy_bu_analysis_tmp.org_no -- 机构编码
             ,mcyy_bu_analysis_tmp.org_name -- 机构名称
             ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
             ,mcyy_bu_analysis_tmp.unit -- 单位
             ,mcyy_bu_analysis_tmp.frequency -- 频度
             ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
             ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
    
    ;

COMMIT;

--2.1.1.4 第四组 WD041022 离线停机占比

INSERT INTO ${idl_schema}.mcyy_bu_analysis
    (etl_dt -- 数据日期
    ,etl_timestamp -- ETL处理时间戳
    ,index_no -- 指标编码
    ,index_name -- 指标名称
    ,org_no -- 机构编码
    ,org_name -- 机构名称
    ,super_org_no -- 上级机构编码
    ,accu_index_value_d -- 当日累计
    ,accu_index_value_m -- 当月累计
    ,accu_index_value_q -- 当季累计
    ,accu_index_value_y -- 当年累计
    ,unit -- 单位
    ,frequency -- 频度
    ,measure_no --- 度量编号
    ,index_measure -- 度量名称
    ,source_sys --来源系统
     )

    WITH tmp_atm_OFF_PCT_data_d AS
     (SELECT (CASE
                 WHEN t1.denom = 0 THEN
                  0
                 ELSE
                  t1.offline_stop_duran / t1.denom
             END) AS OFF_PCT
            ,t1.equip_id AS org_no
            ,t1.equip_belong_org_code AS super_org_no
      FROM   base_d_equip_status_monit_info t1
      WHERE  t1.etl_dt = to_date('${batch_date}'
                                ,'yyyymmdd')
      AND    t1.self_equip_type IN ('ATM'
                                   ,'CRS')
      
      ),
    tmp_atm_OFF_PCT_data_m AS
     (SELECT (CASE
                 WHEN SUM(t1.denom) = 0 THEN
                  0
                 ELSE
                  SUM(t1.offline_stop_duran) / SUM(t1.denom)
             END) AS OFF_PCT
            ,t1.equip_id AS org_no
            ,t1.equip_belong_org_code AS super_org_no
      FROM   base_d_equip_status_monit_info t1
      WHERE  t1.etl_dt >= trunc(to_date('${batch_date}'
                                       ,'yyyyMMdd')
                               ,'MM')
      AND    t1.etl_dt <= to_date('${batch_date}'
                                 ,'yyyyMMdd')
      AND    t1.self_equip_type IN ('ATM'
                                   ,'CRS')
      GROUP  BY t1.equip_id, t1.equip_belong_org_code
      
      ),
    
    tmp_atm_OFF_PCT_data_q AS
     (SELECT (CASE
                 WHEN SUM(t1.denom) = 0 THEN
                  0
                 ELSE
                  SUM(t1.offline_stop_duran) / SUM(t1.denom)
             END) AS OFF_PCT
            ,t1.equip_id AS org_no
            ,t1.equip_belong_org_code AS super_org_no
      FROM   base_d_equip_status_monit_info t1
      
      WHERE  t1.etl_dt >= trunc(to_date('${batch_date}'
                                       ,'yyyymmdd')
                               ,'Q')
      AND    t1.etl_dt <= to_date('${batch_date}'
                                 ,'yyyyMMdd')
      AND    t1.self_equip_type IN ('ATM'
                                   ,'CRS')
      GROUP  BY t1.equip_id, t1.equip_belong_org_code),
    tmp_atm_OFF_PCT_data_y AS
     (SELECT (CASE
                 WHEN SUM(t1.denom) = 0 THEN
                  0
                 ELSE
                  SUM(t1.offline_stop_duran) / SUM(t1.denom)
             END) AS OFF_PCT
            ,t1.equip_id AS org_no
            ,t1.equip_belong_org_code AS super_org_no
      FROM   base_d_equip_status_monit_info t1
      
      WHERE  t1.etl_dt >= trunc(to_date('${batch_date}'
                                       ,'yyyymmdd')
                               ,'YYYY')
      AND    t1.etl_dt <= to_date('${batch_date}'
                                 ,'yyyyMMdd')
      AND    t1.self_equip_type IN ('ATM'
                                   ,'CRS')
      GROUP  BY t1.equip_id, t1.equip_belong_org_code
      
      ),
    tmp_td_initza AS
    --当日数据初始化
     (SELECT t6.index_no
            , --指标编码
             t6.index_name_mcs AS index_name
            , --指标名称
             t2.org_no AS org_no --柜员号
            ,t2.org_no AS org_name
            , --存在柜员名称为空的情况，所以统一用柜员号标识
             t2.super_org_no AS super_org_no
            , --柜员所属支行机构编码
             t2.OFF_PCT AS accu_index_value_d --当日累计
            ,coalesce(t3.OFF_PCT
                     ,0) AS accu_index_value_m --当月累计
            ,coalesce(t4.OFF_PCT
                     ,0) AS accu_index_value_q --当季累计 
            ,coalesce(t5.OFF_PCT
                     ,0) AS accu_index_value_y --当年累计
            ,t6.unit
            , -- 单位
             t6.frequency
            , -- 频度
             NULL measure_no
            , --- 度量编号
             t6.index_measure -- 度量名称
      FROM   ${idl_schema}.mcyy_orga_para t1
      LEFT   JOIN tmp_atm_OFF_PCT_data_d t2 --当日
      ON     t1.org_no = t2.super_org_no
      LEFT   JOIN tmp_atm_OFF_PCT_data_m t3 --当月
      ON     t2.org_no = t3.org_no
      AND    t2.super_org_no = t3.super_org_no
      LEFT   JOIN tmp_atm_OFF_PCT_data_q t4 --当季
      ON     t2.org_no = t4.org_no
      AND    t2.super_org_no = t4.super_org_no
      LEFT   JOIN tmp_atm_OFF_PCT_data_y t5 --当年
      ON     t2.org_no = t5.org_no
      AND    t2.super_org_no = t5.super_org_no
      INNER  JOIN ${idl_schema}.mcyy_index_define t6
      ON     'WD041022' = t6.index_no_mcs
      WHERE  length(t1.super_org_no) = 3 --只关联支行
      AND    t2.super_org_no IS NOT NULL)
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') etl_dt -- 数据日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp -- ETL处理时间戳
          ,mcyy_bu_analysis_tmp.index_no -- 指标编码
          ,mcyy_bu_analysis_tmp.index_name -- 指标名称
          ,mcyy_bu_analysis_tmp.org_no -- 机构编码
          ,mcyy_bu_analysis_tmp.org_name -- 机构名称
          ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_d) -- 当日累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_m) -- 当月累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_q) -- 当季累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_y) -- 当年累计          
          ,mcyy_bu_analysis_tmp.unit -- 单位
          ,mcyy_bu_analysis_tmp.frequency -- 频度
          ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
          ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
          ,'BASE_D_EQUIP_STATUS_MONIT_INFO' source_sys --来源系统
    FROM   (SELECT index_no
                  ,index_name
                  ,org_no
                  ,org_name
                  ,super_org_no
                  ,accu_index_value_d
                  ,accu_index_value_m
                  ,accu_index_value_q
                  ,accu_index_value_y
                  ,unit
                  ,frequency
                  ,measure_no
                  ,index_measure
            FROM   tmp_td_initza
            
            ) mcyy_bu_analysis_tmp
    
    GROUP  BY mcyy_bu_analysis_tmp.index_no -- 指标编码
             ,mcyy_bu_analysis_tmp.index_name -- 指标名称
             ,mcyy_bu_analysis_tmp.org_no -- 机构编码
             ,mcyy_bu_analysis_tmp.org_name -- 机构名称
             ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
             ,mcyy_bu_analysis_tmp.unit -- 单位
             ,mcyy_bu_analysis_tmp.frequency -- 频度
             ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
             ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
    
    ;

COMMIT;

--2.1.2 将设备数据汇总成总分支行数据
whenever sqlerror EXIT sql.sqlcode;
INSERT INTO ${idl_schema}.mcyy_bu_analysis
    (etl_dt -- 数据日期
    ,etl_timestamp -- ETL处理时间戳
    ,index_no -- 指标编码
    ,index_name -- 指标名称
    ,org_no -- 机构编码
    ,org_name -- 机构名称
    ,super_org_no -- 上级机构编码
    ,accu_index_value_d -- 当日累计
    ,accu_index_value_m -- 当月累计
    ,accu_index_value_q -- 当季累计
    ,accu_index_value_y -- 当年累计
    ,unit -- 单位
    ,frequency -- 频度
    ,measure_no --- 度量编号
    ,index_measure -- 度量名称
    ,source_sys --来源系统
     )

    WITH tmp_atm_rat_data AS
     (SELECT SUM(t.accu_index_value_d) AS index_value_d
            ,SUM(t.accu_index_value_m) AS index_value_m
            ,SUM(t.accu_index_value_q) AS index_value_q
            ,SUM(t.accu_index_value_y) AS index_value_y
            ,t.super_org_no org_no
            ,t.index_no
            ,COUNT(1) AS sums
      FROM   mcyy_bu_analysis t
      WHERE  to_char(t.etl_dt
                    ,'yyyymmdd') = to_date('${batch_date}'
                                          ,'yyyyMMdd')
      AND    t.index_no IN ('WD041017'
                           ,'WD041020'
                           ,'WD041021'
                           ,'WD041022')
      
      GROUP  BY t.super_org_no, t.index_no
      
      ),
    tmp_td_initza AS
    --当日数据初始化
     (SELECT t4.index_no
            , --指标编码
             t4.index_name_mcs AS index_name
            , --指标名称
             t1.org_no AS org_no --柜员号
            ,t1.org_name AS org_name
            , --柜员名称
             t1.super_org_no AS super_org_no
            , --柜员所属支行机构编码
              CASE
           WHEN t1.org_no = '000000' THEN
            SUM(coalesce(t2.index_value_d, 0))
            over(partition by t1.index_no) / SUM(sums)
            over(partition by t1.index_no)
           WHEN length(t1.org_no) = 3 THEN
            SUM(coalesce(t2.index_value_d, 0))
            over(PARTITION BY substr(t1.org_no, 1, 3), t1.index_no) /
            SUM(sums) over(PARTITION BY substr(t1.org_no, 1, 3), t1.index_no)
           ELSE
            coalesce(t2.index_value_d, 0) / t2.sums
         END AS accu_index_value_d --当日累计
        ,
         CASE
           WHEN t1.org_no = '000000' THEN
            SUM(coalesce(t2.index_value_m, 0))
            over(partition by t1.index_no) / SUM(sums)
            over(partition by t1.index_no)
           WHEN length(t1.org_no) = 3 THEN
            SUM(coalesce(t2.index_value_m, 0))
            over(PARTITION BY substr(t1.org_no, 1, 3), t1.index_no) /
            SUM(sums) over(PARTITION BY substr(t1.org_no, 1, 3), t1.index_no)
           ELSE
            coalesce(t2.index_value_m, 0) / t2.sums
         END AS accu_index_value_m --当月累计        
        ,
         CASE
           WHEN t1.org_no = '000000' THEN
            SUM(coalesce(t2.index_value_q, 0))
            over(partition by t1.index_no) / SUM(sums)
            over(partition by t1.index_no)
           WHEN length(t1.org_no) = 3 THEN
            SUM(coalesce(t2.index_value_q, 0))
            over(PARTITION BY substr(t1.org_no, 1, 3), t1.index_no) /
            SUM(sums) over(PARTITION BY substr(t1.org_no, 1, 3), t1.index_no)
           ELSE
            coalesce(t2.index_value_q, 0) / t2.sums
         END AS accu_index_value_q --当季累计        
        ,
         CASE
           WHEN t1.org_no = '000000' THEN
            SUM(coalesce(t2.index_value_y, 0))
            over(partition by t1.index_no) / SUM(sums)
            over(partition by t1.index_no)
           WHEN length(t1.org_no) = 3 THEN
            SUM(coalesce(t2.index_value_y, 0))
            over(PARTITION BY substr(t1.org_no, 1, 3), t1.index_no) /
            SUM(sums) over(PARTITION BY substr(t1.org_no, 1, 3), t1.index_no)
           ELSE
            coalesce(t2.index_value_y, 0) / t2.sums
         END AS accu_index_value_y --当年累计          
            ,t4.unit
            , -- 单位
             t4.frequency
            , -- 频度
             NULL measure_no
            , --- 度量编号
             t4.index_measure -- 度量名称
      FROM   (SELECT *
              FROM   mcyy_orga_para org_tab
                    ,(SELECT t1.index_no, t3.dim_class || dim_no AS bu_type
                      FROM   mcyy_index_define t1
                      LEFT   JOIN mcyy_dim_index t2
                      ON     t1.index_no = t2.index_no
                      LEFT   JOIN mcyy_dim_define t3
                      ON     t2.dim_class = t3.dim_class
                      AND    t3.dim_class_name IS NOT NULL
                      WHERE  t1.index_no IN  ('WD041017'
                                               ,'WD041020'
                                               ,'WD041021'
                                               ,'WD041022')) dim_tab) t1 --可以考虑放到with子句
      LEFT   JOIN tmp_atm_rat_data t2
      ON     t1.org_no = t2.org_no
      AND    t1.index_no = t2.index_no
      INNER  JOIN ${idl_schema}.mcyy_index_define t4
      ON     t1.index_no = t4.index_no_mcs)
    
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') etl_dt -- 数据日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp -- ETL处理时间戳
          ,mcyy_bu_analysis_tmp.index_no -- 指标编码
          ,mcyy_bu_analysis_tmp.index_name -- 指标名称
          ,mcyy_bu_analysis_tmp.org_no -- 机构编码
          ,mcyy_bu_analysis_tmp.org_name -- 机构名称
          ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_d) -- 当日累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_m) -- 当月累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_q) -- 当季累计
          ,SUM(mcyy_bu_analysis_tmp.accu_index_value_y) -- 当年累计       
          ,mcyy_bu_analysis_tmp.unit -- 单位
          ,mcyy_bu_analysis_tmp.frequency -- 频度
          ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
          ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
          ,'BASE_D_EQUIP_STATUS_MONIT_INFO' source_sys --来源系统
    FROM   (SELECT index_no
                  ,index_name
                  ,org_no
                  ,org_name
                  ,super_org_no
                  ,accu_index_value_d
                  ,accu_index_value_m
                  ,accu_index_value_q
                  ,accu_index_value_y
                  ,unit
                  ,frequency
                  ,measure_no
                  ,index_measure
            FROM   tmp_td_initza) mcyy_bu_analysis_tmp
    
    GROUP  BY mcyy_bu_analysis_tmp.index_no -- 指标编码
             ,mcyy_bu_analysis_tmp.index_name -- 指标名称
             ,mcyy_bu_analysis_tmp.org_no -- 机构编码
             ,mcyy_bu_analysis_tmp.org_name -- 机构名称
             ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码          
             ,mcyy_bu_analysis_tmp.unit -- 单位
             ,mcyy_bu_analysis_tmp.frequency -- 频度
             ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
             ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
    
    ;

COMMIT;



whenever sqlerror exit sql.sqlcode;

exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mcyy_bu_analysis',partname => 'p_${batch_date}_equip_status_monit_info', granularity => 'SUBPARTITION', degree => 8, cascade => true);

