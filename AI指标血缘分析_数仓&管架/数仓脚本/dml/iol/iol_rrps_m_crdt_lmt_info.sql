/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rrps_m_crdt_lmt_info
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
drop table ${iol_schema}.rrps_m_crdt_lmt_info_ex purge;
alter table ${iol_schema}.rrps_m_crdt_lmt_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rrps_m_crdt_lmt_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rrps_m_crdt_lmt_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rrps_m_crdt_lmt_info where 0=1;

insert /*+ append */ into ${iol_schema}.rrps_m_crdt_lmt_info_ex(
    data_dt -- 数据日期
    ,lgl_rep_id -- 法人编号
    ,prim_crdt_cont_id -- 主授信合同编号
    ,prim_crdt_cont_nm -- 主授信合同名称
    ,cust_id -- 客户编号
    ,org_id -- 机构编号
    ,cur -- 币种
    ,crdt_total_lmt -- 授信总额度
    ,aldy_use_lmt -- 已用额度
    ,exp_crdt_lmt -- 敞口授信额度
    ,exp_aldy_use_lmt -- 敞口已用额度
    ,opr_crdt_tot_amt -- 经营授信总额
    ,opr_aldy_use_crdt_tot_amt -- 经营已用授信总额
    ,hse_crdt_lmt -- 住房授信额度
    ,hse_aldy_use_crdt_lmt -- 住房已用授信额度
    ,car_loan_crdt_lmt -- 车贷授信额度
    ,car_loan_aldy_use_crdt_lmt -- 车贷已用授信额度
    ,sl_crdt_lmt -- 助学授信额度
    ,sl_aldy_use_crdt_lmt -- 助学已用授信额度
    ,oth_cnsmp_crdt_lmt -- 其他消费授信额度
    ,oth_cnsmp_aldy_use_crdt_lmt -- 其他消费已用授信额度
    ,crdt_stat -- 授信状态
    ,first_crdt_dt -- 首次授信日期
    ,dept_line -- 部门条线
    ,data_src -- 数据来源
    ,oth_in_crdt_amt -- 其他表内授信金额
    ,out_crdt_amt -- 表外授信金额
    ,bill_acpt_crdt_amt -- 票据承兑授信金额
    ,crdt_app_dt -- 授信申请日期
    ,crdt_start_dt -- 授信开始日期
    ,crdt_exp_dt -- 授信到期日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    data_dt -- 数据日期
    ,lgl_rep_id -- 法人编号
    ,prim_crdt_cont_id -- 主授信合同编号
    ,prim_crdt_cont_nm -- 主授信合同名称
    ,cust_id -- 客户编号
    ,org_id -- 机构编号
    ,cur -- 币种
    ,crdt_total_lmt -- 授信总额度
    ,aldy_use_lmt -- 已用额度
    ,exp_crdt_lmt -- 敞口授信额度
    ,exp_aldy_use_lmt -- 敞口已用额度
    ,opr_crdt_tot_amt -- 经营授信总额
    ,opr_aldy_use_crdt_tot_amt -- 经营已用授信总额
    ,hse_crdt_lmt -- 住房授信额度
    ,hse_aldy_use_crdt_lmt -- 住房已用授信额度
    ,car_loan_crdt_lmt -- 车贷授信额度
    ,car_loan_aldy_use_crdt_lmt -- 车贷已用授信额度
    ,sl_crdt_lmt -- 助学授信额度
    ,sl_aldy_use_crdt_lmt -- 助学已用授信额度
    ,oth_cnsmp_crdt_lmt -- 其他消费授信额度
    ,oth_cnsmp_aldy_use_crdt_lmt -- 其他消费已用授信额度
    ,crdt_stat -- 授信状态
    ,first_crdt_dt -- 首次授信日期
    ,dept_line -- 部门条线
    ,data_src -- 数据来源
    ,oth_in_crdt_amt -- 其他表内授信金额
    ,out_crdt_amt -- 表外授信金额
    ,bill_acpt_crdt_amt -- 票据承兑授信金额
    ,crdt_app_dt -- 授信申请日期
    ,crdt_start_dt -- 授信开始日期
    ,crdt_exp_dt -- 授信到期日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rrps_m_crdt_lmt_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rrps_m_crdt_lmt_info exchange partition p_${batch_date} with table ${iol_schema}.rrps_m_crdt_lmt_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rrps_m_crdt_lmt_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rrps_m_crdt_lmt_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rrps_m_crdt_lmt_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);