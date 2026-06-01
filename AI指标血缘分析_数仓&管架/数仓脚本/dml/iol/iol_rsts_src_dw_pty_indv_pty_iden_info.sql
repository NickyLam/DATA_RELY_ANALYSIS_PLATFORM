/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rsts_src_dw_pty_indv_pty_iden_info
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
drop table ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info_ex purge;
alter table ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info where 0=1;

insert /*+ append */ into ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info_ex(
    pty_id -- 客户编号
    ,etl_dt_ora -- 数据日期
    ,iden_typ_cd -- 证件类型代码
    ,iden_num -- 证件号码
    ,iden_eff_dt -- 证件生效日期
    ,iden_due_dt -- 证件到期日期
    ,iden_issue_org -- 证件签发机关
    ,iden_issue_pla -- 证件签发地
    ,iden_issue_cty_cd -- 证件签发国家代码
    ,open_iden_flg -- 开户证件标志
    ,prim_iden_flg -- 主证件标志
    ,iden_status_cd -- 证件状态代码
    ,data_src_cd -- 数据来源代码
    ,del_flg -- 删除标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    pty_id -- 客户编号
    ,etl_dt_ora -- 数据日期
    ,iden_typ_cd -- 证件类型代码
    ,iden_num -- 证件号码
    ,iden_eff_dt -- 证件生效日期
    ,iden_due_dt -- 证件到期日期
    ,iden_issue_org -- 证件签发机关
    ,iden_issue_pla -- 证件签发地
    ,iden_issue_cty_cd -- 证件签发国家代码
    ,open_iden_flg -- 开户证件标志
    ,prim_iden_flg -- 主证件标志
    ,iden_status_cd -- 证件状态代码
    ,data_src_cd -- 数据来源代码
    ,del_flg -- 删除标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rsts_src_dw_pty_indv_pty_iden_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info exchange partition p_${batch_date} with table ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rsts_src_dw_pty_indv_pty_iden_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);