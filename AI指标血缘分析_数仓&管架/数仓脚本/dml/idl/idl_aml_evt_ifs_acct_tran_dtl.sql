/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_evt_ifs_acct_tran_dtl
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
alter table ${idl_schema}.aml_evt_ifs_acct_tran_dtl drop partition p_${last_date};
alter table ${idl_schema}.aml_evt_ifs_acct_tran_dtl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_evt_ifs_acct_tran_dtl add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_evt_ifs_acct_tran_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,evt_id  -- 事件编号
    ,lp_id  -- 法人编号
    ,tran_flow_id  -- 交易流水编号
    ,acct_id  -- 账户编号
    ,dep_sub_acct_id  -- 存款子户编号
    ,cust_id  -- 客户编号
    ,ext_prod_id  -- 外部产品编号
    ,tran_dt  -- 交易日期
    ,tran_tm  -- 交易时间
    ,tran_type_cd  -- 交易类型代码
    ,tran_chn_cd  -- 交易渠道代码
    ,tran_status_cd  -- 交易状态代码
    ,tran_org_id  -- 交易机构编号
    ,call_sys_id  -- 调用系统编号
    ,debit_crdt_dir_cd  -- 借贷方向代码
    ,tran_amt  -- 交易金额
    ,cntpty_acct_id  -- 交易对手方账户编号
    ,cntpty_acct_name  -- 交易对手方账户名
    ,cntpty_org_id  -- 交易对手方机构编号
    ,dep_rcpt_bal  -- 存单余额
    ,provi_flg_cd  -- 计提标志代码
    ,provi_tm  -- 计提时间
    ,ext_flow_id  -- 外部流水编号
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.evt_id,chr(13),''),chr(10),'')  -- 事件编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.tran_flow_id,chr(13),''),chr(10),'')  -- 交易流水编号
    ,replace(replace(t1.acct_id,chr(13),''),chr(10),'')  -- 账户编号
    ,replace(replace(t1.dep_sub_acct_id,chr(13),''),chr(10),'')  -- 存款子户编号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.ext_prod_id,chr(13),''),chr(10),'')  -- 外部产品编号
    ,t1.tran_dt  -- 交易日期
    ,replace(replace(t1.tran_tm,chr(13),''),chr(10),'')  -- 交易时间
    ,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'')  -- 交易类型代码
    ,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'')  -- 交易渠道代码
    ,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'')  -- 交易状态代码
    ,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'')  -- 交易机构编号
    ,replace(replace(t1.call_sys_id,chr(13),''),chr(10),'')  -- 调用系统编号
    ,replace(replace(t1.debit_crdt_dir_cd,chr(13),''),chr(10),'')  -- 借贷方向代码
    ,t1.tran_amt  -- 交易金额
    ,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'')  -- 交易对手方账户编号
    ,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'')  -- 交易对手方账户名
    ,replace(replace(t1.cntpty_org_id,chr(13),''),chr(10),'')  -- 交易对手方机构编号
    ,t1.dep_rcpt_bal  -- 存单余额
    ,replace(replace(t1.provi_flg_cd,chr(13),''),chr(10),'')  -- 计提标志代码
    ,t1.provi_tm  -- 计提时间
    ,replace(replace(t1.ext_flow_id,chr(13),''),chr(10),'')  -- 外部流水编号
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.evt_ifs_acct_tran_dtl t1    --联合存款账户交易明细
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_evt_ifs_acct_tran_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);