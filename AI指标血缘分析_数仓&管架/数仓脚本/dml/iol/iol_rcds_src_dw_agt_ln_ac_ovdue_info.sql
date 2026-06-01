/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_src_dw_agt_ln_ac_ovdue_info
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
drop table ${iol_schema}.rcds_src_dw_agt_ln_ac_ovdue_info_ex purge;
alter table ${iol_schema}.rcds_src_dw_agt_ln_ac_ovdue_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.rcds_src_dw_agt_ln_ac_ovdue_info;

-- 2.3 insert data to ex table
create table ${iol_schema}.rcds_src_dw_agt_ln_ac_ovdue_info_ex nologging
compress
as
select * from ${iol_schema}.rcds_src_dw_agt_ln_ac_ovdue_info where 0=1;

insert /*+ append */ into ${iol_schema}.rcds_src_dw_agt_ln_ac_ovdue_info_ex(
    loan_acct_id -- 贷款账户编号
    ,etl_dt_ora -- 数据日期
    ,ovdue_flg -- 逾期标志
    ,ovdue_princp_amt -- 逾期本金金额
    ,ovdue_int_amt -- 逾期利息金额
    ,ovdue_int_compd_int -- 逾期利息复利
    ,rcva_owe_int_bal -- 欠息余额
    ,rcva_pnlt_bal -- 罚息余额
    ,princp_ovdue_dt -- 本金逾期日期
    ,int_ovdue_dt -- 利息逾期日期
    ,ovdue_term -- 逾期期数
    ,sub_term -- 子期数
    ,ovdue_days -- 逾期天数
    ,dull_bal -- 呆滞余额
    ,bad_debt_bal -- 呆账余额
    ,data_src_cd -- 数据来源代码
    ,del_flg -- 删除标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    loan_acct_id -- 贷款账户编号
    ,etl_dt_ora -- 数据日期
    ,ovdue_flg -- 逾期标志
    ,ovdue_princp_amt -- 逾期本金金额
    ,ovdue_int_amt -- 逾期利息金额
    ,ovdue_int_compd_int -- 逾期利息复利
    ,rcva_owe_int_bal -- 欠息余额
    ,rcva_pnlt_bal -- 罚息余额
    ,princp_ovdue_dt -- 本金逾期日期
    ,int_ovdue_dt -- 利息逾期日期
    ,ovdue_term -- 逾期期数
    ,sub_term -- 子期数
    ,ovdue_days -- 逾期天数
    ,dull_bal -- 呆滞余额
    ,bad_debt_bal -- 呆账余额
    ,data_src_cd -- 数据来源代码
    ,del_flg -- 删除标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rcds_src_dw_agt_ln_ac_ovdue_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rcds_src_dw_agt_ln_ac_ovdue_info exchange partition p_${batch_date} with table ${iol_schema}.rcds_src_dw_agt_ln_ac_ovdue_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_src_dw_agt_ln_ac_ovdue_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rcds_src_dw_agt_ln_ac_ovdue_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_src_dw_agt_ln_ac_ovdue_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);