/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_dsvp_dsvp_bussiness_info_statistics
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.dsvp_dsvp_bussiness_info_statistics_ex purge;
alter table ${iol_schema}.dsvp_dsvp_bussiness_info_statistics add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.dsvp_dsvp_bussiness_info_statistics;

-- 2.3 insert data to ex table
create table ${iol_schema}.dsvp_dsvp_bussiness_info_statistics_ex nologging
compress
as
select * from ${iol_schema}.dsvp_dsvp_bussiness_info_statistics where 0=1;

insert /*+ append */ into ${iol_schema}.dsvp_dsvp_bussiness_info_statistics_ex(
    id -- 序列号
    ,txn_dt -- 交易日期
    ,txn_tm -- 交易时间
    ,blng_org_id -- 机构号
    ,oper_teller_id -- 操作柜员号
    ,oper_teller_name -- 操作柜员名称
    ,auth_teller_id -- 授权柜员号
    ,auth_teller_name -- 授权柜员名称
    ,txn_num -- 操作类型编码
    ,txn_desc -- 操作名称描述
    ,biz_sys_evt_id -- 无实际数据
    ,bcs_evt_id -- 无实际数据
    ,data_src_cd -- 数据来源标识（默认SDVP）
    ,pay_agt_id -- 无实际数据
    ,rcv_agt_id -- 无实际数据
    ,txn_amt -- 无实际数据
    ,etl_dt_ora -- 结束时间（与操作时间一致）
    ,menuid -- 无实际数据
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 序列号
    ,txn_dt -- 交易日期
    ,txn_tm -- 交易时间
    ,blng_org_id -- 机构号
    ,oper_teller_id -- 操作柜员号
    ,oper_teller_name -- 操作柜员名称
    ,auth_teller_id -- 授权柜员号
    ,auth_teller_name -- 授权柜员名称
    ,txn_num -- 操作类型编码
    ,txn_desc -- 操作名称描述
    ,biz_sys_evt_id -- 无实际数据
    ,bcs_evt_id -- 无实际数据
    ,data_src_cd -- 数据来源标识（默认SDVP）
    ,pay_agt_id -- 无实际数据
    ,rcv_agt_id -- 无实际数据
    ,txn_amt -- 无实际数据
    ,etl_dt_ora -- 结束时间（与操作时间一致）
    ,menuid -- 无实际数据
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.dsvp_dsvp_bussiness_info_statistics
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.dsvp_dsvp_bussiness_info_statistics exchange partition p_${batch_date} with table ${iol_schema}.dsvp_dsvp_bussiness_info_statistics_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.dsvp_dsvp_bussiness_info_statistics to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.dsvp_dsvp_bussiness_info_statistics_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'dsvp_dsvp_bussiness_info_statistics',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);