/*
Purpose:    指标应用层-设备清机加钞信息表，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_equip_add_cash_info2index_data
CreateDate: 20210705
修改记录：

    郑沛隆 2021-07-05 新建脚本 
    
*/   
/*
    依赖于基础数据表：
    BASE_D_EQUIP_ADD_CASH_INFO
    生成数据表:
    BASE_D_TO_INDEX_DATA
    生成指标列表  
    1	WD041013	网点作业	自助设备管理(ATM/CRS)	设备清机加钞时长	原始值	分钟  20210705 郑沛隆
		2	WD041014	网点作业	自助设备管理(ATM/CRS)	设备清机加钞金额	原始值	元	 	20210705 郑沛隆
		3	WD041015	网点作业	自助设备管理(ATM/CRS)	设备清机次数			计算值	次	 	20210705 郑沛隆
*/  


set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${idl_schema}.base_d_to_index_data_${batch_date}_add_cash_info purge ;

alter table ${idl_schema}.base_d_to_index_data add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
        subpartition p_${batch_date}_base_d_equip_add_cash_info values ('BASE_D_EQUIP_ADD_CASH_INFO'))
;

alter table ${idl_schema}.base_d_to_index_data modify partition p_${batch_date}
    add subpartition p_${batch_date}_base_d_equip_add_cash_info values ('BASE_D_EQUIP_ADD_CASH_INFO')
;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.base_d_to_index_data_${batch_date}_add_cash_info
compress ${option_switch} for query high
as
select
    *
from ${idl_schema}.base_d_to_index_data
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- WD041013  设备清机加钞时长
INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_add_cash_info
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041013' AS index_no --指标编号 
          ,t1.equip_id AS org_no --指标主体号 
          ,t1.equip_belong_org_code AS super_org_no -- 上级机构号 
          ,NULL bu_type --VARCHAR2(30)分类     
          ,SUM(t1.cash_duran) AS index_value --指标值   
          ,'BASE_D_EQUIP_ADD_CASH_INFO' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_equip_add_cash_info t1
    WHERE  etl_dt = to_date('${batch_date}'
                           ,'yyyymmdd')
    GROUP  BY t1.equip_id, t1.equip_belong_org_code;

COMMIT;

-- WD041014  设备清机加钞金额
INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_add_cash_info
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041014' AS index_no --指标编号 
          ,t1.equip_id AS org_no --指标主体号 
          ,t1.equip_belong_org_code AS super_org_no -- 上级机构号 
          ,NULL bu_type --VARCHAR2(30)分类     
          ,SUM(t1.ths_tm_add_cash_tot) AS index_value --指标值   
          ,'BASE_D_EQUIP_ADD_CASH_INFO' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_equip_add_cash_info t1
    WHERE  etl_dt = to_date('${batch_date}'
                           ,'yyyymmdd')
    GROUP  BY t1.equip_id, t1.equip_belong_org_code;

COMMIT;

-- WD041015  设备清机次数
INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_add_cash_info
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041015' AS index_no --指标编号 
          ,t1.equip_id AS org_no --指标主体号 
          ,t1.equip_belong_org_code AS super_org_no -- 上级机构号 
          ,NULL bu_type --VARCHAR2(30)分类     
          ,count(distinct t1.add_cash_ind_no) AS index_value --指标值   
          ,'BASE_D_EQUIP_ADD_CASH_INFO' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_equip_add_cash_info t1
    WHERE  etl_dt = to_date('${batch_date}'
                           ,'yyyymmdd')
       and  t1.CASH_END_TM is not null
    GROUP  BY t1.equip_id, t1.equip_belong_org_code;

COMMIT;

-- 3.2 truncate target table batch_date partition
alter table ${idl_schema}.base_d_to_index_data truncate subpartition p_${batch_date}_base_d_equip_add_cash_info reuse storage;


-- 3.3 exchage tm table and target table
alter table ${idl_schema}.base_d_to_index_data exchange subpartition p_${batch_date}_base_d_equip_add_cash_info with table ${idl_schema}.base_d_to_index_data_${batch_date}_add_cash_info;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.base_d_to_index_data to ${idl_schema};

-- 4.2 drop tm table
drop table ${idl_schema}.base_d_to_index_data_${batch_date}_add_cash_info purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'base_d_to_index_data', partname => 'p_${batch_date}_base_d_equip_add_cash_info', granularity => 'SUBPARTITION', degree => 8, cascade => true);

-- 6 

whenever sqlerror continue none;

alter table ${idl_schema}.mcyy_bu_analysis truncate subpartition p_${batch_date}_add_cash_info;

alter table ${idl_schema}.mcyy_bu_analysis add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
                                              subpartition p_${batch_date}_add_cash_info values ('BASE_D_EQUIP_ADD_CASH_INFO')
                                              )
;
alter table ${idl_schema}.mcyy_bu_analysis modify partition p_${batch_date} 
                                             add subpartition p_${batch_date}_add_cash_info values ('BASE_D_EQUIP_ADD_CASH_INFO')
;

whenever sqlerror exit sql.sqlcode;

call pkg_mcyy_ind_share_intfc.prc_get_sorc_sys_data('BASE_D_EQUIP_ADD_CASH_INFO',${batch_date});

whenever sqlerror exit sql.sqlcode;

exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mcyy_bu_analysis',partname => 'p_${batch_date}_add_cash_info', granularity => 'SUBPARTITION', degree => 8, cascade => true);

