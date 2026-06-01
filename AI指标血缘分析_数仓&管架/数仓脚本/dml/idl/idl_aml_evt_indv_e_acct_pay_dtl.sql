/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_evt_indv_e_acct_pay_dtl
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
alter table ${idl_schema}.aml_evt_indv_e_acct_pay_dtl drop partition p_${last_date};
alter table ${idl_schema}.aml_evt_indv_e_acct_pay_dtl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_evt_indv_e_acct_pay_dtl add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_evt_indv_e_acct_pay_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,evt_id  -- 事件编号
    ,lp_id  -- 法人编号
    ,pay_id  -- 支付编号
    ,fin_acct_tran_dtl_id  -- 金融账户交易明细编号
    ,prod_acct_id  -- 产品账户编号
    ,tran_org_id  -- 交易机构编号
    ,init_pay_id  -- 原支付编号
    ,payment_flow_num  -- 前台流水号
    ,pay_type_cd  -- 支付类型代码
    ,mode_pay_type_cd  -- 支付方式类型代码
    ,from_mem_cd  -- 自会员代码
    ,status_cd  -- 状态代码
    ,mode_pay_flg  -- 支付方式标志
    ,curr_cd  -- 币种代码
    ,tran_kind_cd  -- 交易种类代码
    ,acct_tm  -- 账务时间
    ,tran_tm  -- 交易时间
    ,tran_amt  -- 交易金额
    ,actl_amt  -- 实际金额
    ,actl_bal  -- 实际余额
    ,aval_bal  -- 可用余额
    ,cntpty_acct_num  -- 对方账号
    ,cntpty_acct_name  -- 对方户名称
    ,cntpty_acct_open_bank_num  -- 对方账户开户行号
    ,cntpty_acct_open_bank_name  -- 对方账户开户行名称
    ,final_update_tm  -- 最后更新时间
    ,remark  -- 备注
    ,memo  -- 摘要
    ,postsc  -- 附言
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.evt_id,chr(13),''),chr(10),'')  -- 事件编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.pay_id,chr(13),''),chr(10),'')  -- 支付编号
    ,replace(replace(t1.fin_acct_tran_dtl_id,chr(13),''),chr(10),'')  -- 金融账户交易明细编号
    ,replace(replace(t1.prod_acct_id,chr(13),''),chr(10),'')  -- 产品账户编号
    ,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'')  -- 交易机构编号
    ,replace(replace(t1.init_pay_id,chr(13),''),chr(10),'')  -- 原支付编号
    ,replace(replace(t1.payment_flow_num,chr(13),''),chr(10),'')  -- 前台流水号
    ,replace(replace(t1.pay_type_cd,chr(13),''),chr(10),'')  -- 支付类型代码
    ,replace(replace(t1.mode_pay_type_cd,chr(13),''),chr(10),'')  -- 支付方式类型代码
    ,replace(replace(t1.from_mem_cd,chr(13),''),chr(10),'')  -- 自会员代码
    ,replace(replace(t1.status_cd,chr(13),''),chr(10),'')  -- 状态代码
    ,replace(replace(t1.mode_pay_flg,chr(13),''),chr(10),'')  -- 支付方式标志
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,replace(replace(t1.tran_kind_cd,chr(13),''),chr(10),'')  -- 交易种类代码
    ,t1.acct_tm  -- 账务时间
    ,t1.tran_tm  -- 交易时间
    ,t1.tran_amt  -- 交易金额
    ,t1.actl_amt  -- 实际金额
    ,t1.actl_bal  -- 实际余额
    ,t1.aval_bal  -- 可用余额
    ,replace(replace(t1.cntpty_acct_num,chr(13),''),chr(10),'')  -- 对方账号
    ,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'')  -- 对方户名称
    ,replace(replace(t1.cntpty_acct_open_bank_num,chr(13),''),chr(10),'')  -- 对方账户开户行号
    ,replace(replace(t1.cntpty_acct_open_bank_name,chr(13),''),chr(10),'')  -- 对方账户开户行名称
    ,t1.final_update_tm  -- 最后更新时间
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(t1.memo,chr(13),''),chr(10),'')  -- 摘要
    ,replace(replace(t1.postsc,chr(13),''),chr(10),'')  -- 附言
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.evt_indv_e_acct_pay_dtl t1    --个人电子账户支付明细
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_evt_indv_e_acct_pay_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);