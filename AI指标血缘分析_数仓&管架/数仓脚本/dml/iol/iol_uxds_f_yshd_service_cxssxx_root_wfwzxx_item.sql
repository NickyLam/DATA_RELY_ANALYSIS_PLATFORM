/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_f_yshd_service_cxssxx_root_wfwzxx_item
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
drop table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item_ex purge;
alter table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item_ex(
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,djrq -- 登记日期
    ,wfss -- 违法事实
    ,ajly -- 案件来源
    ,sswfsdmc -- 违法手段名称
    ,sswflxmc -- 违法类型名称
    ,ssqjz_1 -- 所属期止
    ,jcajbz -- 稽查案件标志
    ,item -- 关联标签
    ,qyxmmc -- 负债和所有者权益项目名称
    ,ssqjq_1 -- 所属期起
    ,sswfxwclztmc -- 违法处理状态名称
    ,sfsbfwf -- 是否社保费违法
    ,shxydm -- 社会信用代码
    ,wfxwmc -- 违法行为名称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,djrq -- 登记日期
    ,wfss -- 违法事实
    ,ajly -- 案件来源
    ,sswfsdmc -- 违法手段名称
    ,sswflxmc -- 违法类型名称
    ,ssqjz_1 -- 所属期止
    ,jcajbz -- 稽查案件标志
    ,item -- 关联标签
    ,qyxmmc -- 负债和所有者权益项目名称
    ,ssqjq_1 -- 所属期起
    ,sswfxwclztmc -- 违法处理状态名称
    ,sfsbfwf -- 是否社保费违法
    ,shxydm -- 社会信用代码
    ,wfxwmc -- 违法行为名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item exchange partition p_${batch_date} with table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_wfwzxx_item_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_f_yshd_service_cxssxx_root_wfwzxx_item',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);