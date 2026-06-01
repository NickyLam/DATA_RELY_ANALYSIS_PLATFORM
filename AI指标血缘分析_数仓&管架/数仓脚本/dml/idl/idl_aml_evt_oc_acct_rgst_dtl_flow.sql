/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_evt_oc_acct_rgst_dtl_flow
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow drop partition p_${last_date};
alter table ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_evt_oc_acct_rgst_dtl_flow (
    etl_dt  -- 数据日期
    ,evt_id  -- 事件编号
    ,lp_id  -- 法人编号
    ,oc_acct_dt  -- 开销户日期
    ,oc_acct_flow  -- 开销户流水
    ,tran_flow  -- 交易流水
    ,oc_acct_flg  -- 开销户标志
    ,acct_clear_opera_flg  -- 冲账作业标志
    ,opera_org_id  -- 作业机构编号
    ,acct_org_line_id  -- 账户机构编号
    ,dep_acct_id  -- 存款账户编号
    ,dep_sub_acct_id  -- 存款子户编号
    ,acct_name  -- 账户名称
    ,curr_cd  -- 币种代码
    ,ec_flg  -- 钞汇标志
    ,sav_type_cd  -- 储种代码
    ,dep_term_cd  -- 存期代码
    ,open_acct_vouch_cd  -- 开户凭证代码
    ,open_acct_vouch_no  -- 开户凭证号码
    ,src_vouch_mgmt_id  -- 源凭证管理编号
    ,amt  -- 金额
    ,edu_saving_proof_cd  -- 教育储蓄证明代码
    ,int_amt  -- 利息金额
    ,int_tax_lmt  -- 利息税金额
    ,in_cust_acct_int  -- 入客户账利息
    ,in_trdpty_int  -- 入第三方利息
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.evt_id,chr(13),''),chr(10),'')  -- 事件编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,t1.oc_acct_dt  -- 开销户日期
    ,replace(replace(t1.oc_acct_flow,chr(13),''),chr(10),'')  -- 开销户流水
    ,replace(replace(t1.tran_flow,chr(13),''),chr(10),'')  -- 交易流水
    ,replace(replace(t1.oc_acct_flg,chr(13),''),chr(10),'')  -- 开销户标志
    ,replace(replace(t1.acct_clear_opera_flg,chr(13),''),chr(10),'')  -- 冲账作业标志
    ,replace(replace(t1.opera_org_id,chr(13),''),chr(10),'')  -- 作业机构编号
    ,replace(replace(t1.acct_org_line_id,chr(13),''),chr(10),'')  -- 账户机构编号
    ,replace(replace(t1.dep_acct_id,chr(13),''),chr(10),'')  -- 存款账户编号
    ,replace(replace(t1.dep_sub_acct_id,chr(13),''),chr(10),'')  -- 存款子户编号
    ,replace(replace(t1.acct_name,chr(13),''),chr(10),'')  -- 账户名称
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,replace(replace(t1.ec_flg,chr(13),''),chr(10),'')  -- 钞汇标志
    ,replace(replace(t1.sav_type_cd,chr(13),''),chr(10),'')  -- 储种代码
    ,replace(replace(t1.dep_term_cd,chr(13),''),chr(10),'')  -- 存期代码
    ,replace(replace(t1.open_acct_vouch_cd,chr(13),''),chr(10),'')  -- 开户凭证代码
    ,replace(replace(t1.open_acct_vouch_no,chr(13),''),chr(10),'')  -- 开户凭证号码
    ,replace(replace(t1.src_vouch_mgmt_id,chr(13),''),chr(10),'')  -- 源凭证管理编号
    ,t1.amt  -- 金额
    ,replace(replace(t1.edu_saving_proof_cd,chr(13),''),chr(10),'')  -- 教育储蓄证明代码
    ,t1.int_amt  -- 利息金额
    ,t1.int_tax_lmt  -- 利息税金额
    ,t1.in_cust_acct_int  -- 入客户账利息
    ,t1.in_trdpty_int  -- 入第三方利息
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.evt_oc_acct_rgst_dtl_flow t1    --开销户登记明细流水
where t1.oc_acct_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_evt_oc_acct_rgst_dtl_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);