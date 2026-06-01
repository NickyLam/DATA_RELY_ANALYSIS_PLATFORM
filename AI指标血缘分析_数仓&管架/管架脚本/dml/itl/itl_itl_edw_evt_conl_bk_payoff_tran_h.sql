/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_evt_conl_bk_payoff_tran_h
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
alter table ${itl_schema}.itl_edw_evt_conl_bk_payoff_tran_h drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_evt_conl_bk_payoff_tran_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_evt_conl_bk_payoff_tran_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_evt_conl_bk_payoff_tran_h partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,evt_id  -- 事件编号
    ,lp_id  -- 法人编号
    ,batch_id  -- 批次编号
    ,seq_num  -- 序号
    ,cust_id  -- 客户编号
    ,recver_name  -- 收款人名称
    ,recver_acct_id  -- 收款人账户编号
    ,payer_name  -- 付款人名称
    ,payer_acct_id  -- 付款人账户编号
    ,tran_amt  -- 交易金额
    ,curr_cd  -- 币种代码
    ,tran_status_cd  -- 交易状态代码
    ,tran_dt  -- 交易日期
    ,core_tran_dt  -- 核心交易日期
    ,core_batch_id  -- 核心批次编号
    ,core_flow_num  -- 核心流水号
    ,remark  -- 备注
    ,recver_ibank_no  -- 收款方联行号
    ,recver_open_brac_name  -- 收款方开户网点名称
    ,mobile_no  -- 手机号码
    ,return_code  -- 返回码
    ,return_info  -- 返回信息
    ,err_info  -- 错误信息
    ,bank_int_flg  -- 行内标志
    ,emply_id  -- 员工编号
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.evt_id,chr(13),''),chr(10),'')  -- 事件编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.batch_id,chr(13),''),chr(10),'')  -- 批次编号
    ,replace(replace(t1.seq_num,chr(13),''),chr(10),'')  -- 序号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.recver_name,chr(13),''),chr(10),'')  -- 收款人名称
    ,replace(replace(t1.recver_acct_id,chr(13),''),chr(10),'')  -- 收款人账户编号
    ,replace(replace(t1.payer_name,chr(13),''),chr(10),'')  -- 付款人名称
    ,replace(replace(t1.payer_acct_id,chr(13),''),chr(10),'')  -- 付款人账户编号
    ,t1.tran_amt  -- 交易金额
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'')  -- 交易状态代码
    ,t1.tran_dt  -- 交易日期
    ,t1.core_tran_dt  -- 核心交易日期
    ,replace(replace(t1.core_batch_id,chr(13),''),chr(10),'')  -- 核心批次编号
    ,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'')  -- 核心流水号
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(t1.recver_ibank_no,chr(13),''),chr(10),'')  -- 收款方联行号
    ,replace(replace(t1.recver_open_brac_name,chr(13),''),chr(10),'')  -- 收款方开户网点名称
    ,replace(replace(t1.mobile_no,chr(13),''),chr(10),'')  -- 手机号码
    ,replace(replace(t1.return_code,chr(13),''),chr(10),'')  -- 返回码
    ,replace(replace(t1.return_info,chr(13),''),chr(10),'')  -- 返回信息
    ,replace(replace(t1.err_info,chr(13),''),chr(10),'')  -- 错误信息
    ,replace(replace(t1.bank_int_flg,chr(13),''),chr(10),'')  -- 行内标志
    ,replace(replace(t1.emply_id,chr(13),''),chr(10),'')  -- 员工编号
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from ${msl_schema}.msl_edw_evt_conl_bk_payoff_tran_h t1    --企业网银代发工资交易明细历史
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_evt_conl_bk_payoff_tran_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);