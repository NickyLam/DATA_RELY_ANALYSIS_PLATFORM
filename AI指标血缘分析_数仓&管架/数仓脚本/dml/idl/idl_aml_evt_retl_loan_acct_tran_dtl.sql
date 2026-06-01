/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_evt_retl_loan_acct_tran_dtl
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
alter table ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl drop partition p_${last_date};
alter table ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl (
    etl_dt  -- 数据日期
    ,evt_id  -- 事件编号
    ,lp_id  -- 法人编号
    ,acct_dt  -- 账务日期
    ,dtl_id  -- 明细编号
    ,acct_id  -- 账户编号
    ,dubil_id  -- 借据编号
    ,prod_id  -- 产品编号
    ,acctnt_cate_cd  -- 会计类别代码
    ,cust_id  -- 客户编号
    ,curr_cd  -- 币种代码
    ,tran_dir_cd  -- 交易方向代码
    ,tran_amt  -- 交易金额
    ,acct_bal  -- 账户余额
    ,bal_field_name  -- 余额字段名
    ,bal_field_cn_name  -- 余额字段中文名
    ,tran_org_id  -- 交易机构编号
    ,tran_teller_id  -- 交易柜员编号
    ,tran_flow_num  -- 交易流水号
    ,tran_evt_cd  -- 交易事件代码
    ,evt_descb  -- 事件描述
    ,tran_cd  -- 交易代码
    ,revs_flg  -- 冲正标志
    ,brevs_flg  -- 被冲正标志
    ,tran_tm  -- 交易时间
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.evt_id,chr(13),''),chr(10),'')  -- 事件编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,t1.acct_dt  -- 账务日期
    ,replace(replace(t1.dtl_id,chr(13),''),chr(10),'')  -- 明细编号
    ,replace(replace(t1.acct_id,chr(13),''),chr(10),'')  -- 账户编号
    ,replace(replace(t1.dubil_id,chr(13),''),chr(10),'')  -- 借据编号
    ,replace(replace(t1.prod_id,chr(13),''),chr(10),'')  -- 产品编号
    ,replace(replace(t1.acctnt_cate_cd,chr(13),''),chr(10),'')  -- 会计类别代码
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'')  -- 交易方向代码
    ,t1.tran_amt  -- 交易金额
    ,t1.acct_bal  -- 账户余额
    ,replace(replace(t1.bal_field_name,chr(13),''),chr(10),'')  -- 余额字段名
    ,replace(replace(t1.bal_field_cn_name,chr(13),''),chr(10),'')  -- 余额字段中文名
    ,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'')  -- 交易机构编号
    ,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'')  -- 交易柜员编号
    ,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'')  -- 交易流水号
    ,replace(replace(t1.tran_evt_cd,chr(13),''),chr(10),'')  -- 交易事件代码
    ,replace(replace(t1.evt_descb,chr(13),''),chr(10),'')  -- 事件描述
    ,replace(replace(t1.tran_cd,chr(13),''),chr(10),'')  -- 交易代码
    ,replace(replace(t1.revs_flg,chr(13),''),chr(10),'')  -- 冲正标志
    ,replace(replace(t1.brevs_flg,chr(13),''),chr(10),'')  -- 被冲正标志
    ,t1.tran_tm  -- 交易时间
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.evt_retl_loan_acct_tran_dtl t1    --零售贷款账户交易明细
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_evt_retl_loan_acct_tran_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);