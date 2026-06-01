/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t09_per_cust_info_modify_seq
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
drop table ${iol_schema}.eifs_t09_per_cust_info_modify_seq_ex purge;
alter table ${iol_schema}.eifs_t09_per_cust_info_modify_seq add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.eifs_t09_per_cust_info_modify_seq truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.eifs_t09_per_cust_info_modify_seq_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t09_per_cust_info_modify_seq where 0=1;

insert /*+ append */ into ${iol_schema}.eifs_t09_per_cust_info_modify_seq_ex(
    cust_oper_type -- 客户操作类型
    ,srv_seq_num -- 业务流水号
    ,glob_seq_num -- 全局流水号
    ,cust_num -- 客户编号
    ,cust_type_cd -- 客户类型
    ,type -- 类别
    ,tab_name -- 表名
    ,key_id -- 主键ID
    ,col_name -- 字段名
    ,col_chn_name -- 字段中文名
    ,before_change -- 修改前值
    ,now_value -- 当前值
    ,last_updated_te -- 更新柜员
    ,last_updated_org -- 更新机构
    ,last_system_id -- 更新渠道
    ,last_updated_ts -- 更新时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    cust_oper_type -- 客户操作类型
    ,srv_seq_num -- 业务流水号
    ,glob_seq_num -- 全局流水号
    ,cust_num -- 客户编号
    ,cust_type_cd -- 客户类型
    ,type -- 类别
    ,tab_name -- 表名
    ,key_id -- 主键ID
    ,col_name -- 字段名
    ,col_chn_name -- 字段中文名
    ,before_change -- 修改前值
    ,now_value -- 当前值
    ,last_updated_te -- 更新柜员
    ,last_updated_org -- 更新机构
    ,last_system_id -- 更新渠道
    ,last_updated_ts -- 更新时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.eifs_t09_per_cust_info_modify_seq
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.eifs_t09_per_cust_info_modify_seq exchange partition p_${batch_date} with table ${iol_schema}.eifs_t09_per_cust_info_modify_seq_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t09_per_cust_info_modify_seq to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.eifs_t09_per_cust_info_modify_seq_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t09_per_cust_info_modify_seq',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);