/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_cap_supv_tran_flow_fdpsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.evt_cap_supv_tran_flow add partition p_fdpsf1 values ('fdpsf1')(
        subpartition p_fdpsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_fdpsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_cap_supv_tran_flow partition for ('fdpsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_tm purge;
drop table ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_op purge;
drop table ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_tm -- 交易时间
    ,coprator_id -- 合作商编号
    ,intnal_cust_id -- 内部客户编号
    ,intnal_cust_name -- 内部客户名称
    ,vtual_acct_id -- 虚拟账户编号
    ,vtual_acct_type_cd -- 虚拟账户类型代码
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,trdpty_flow_num -- 第三方流水号
    ,init_tran_flow_num -- 原交易流水号
    ,payer_intnal_cust_id -- 付款人内部客户编号
    ,payer_vtual_acct_id -- 付款人虚拟账户编号
    ,payer_bank_acct_name -- 付款人银行账户名称
    ,payer_bank_acct_id -- 付款人银行账户编号
    ,payer_open_bank_name -- 付款人开户银行名称
    ,payer_open_bank_id -- 付款人开户银行编号
    ,payer_open_ghb_flg -- 付款人开户银行本行标志
    ,recver_intnal_cust_id -- 收款人内部客户编号
    ,recver_vtual_acct_id -- 收款人虚拟账户编号
    ,guar_amt -- 担保金额
    ,guar_surp_amt -- 担保剩余金额
    ,avl_amt -- 到账金额
    ,recver_bank_acct_name -- 收款人银行账户名称
    ,recver_bank_acct_id -- 收款人银行账户编号
    ,recver_open_bank_name -- 收款人开户银行名称
    ,recver_open_bank_id -- 收款人开户银行编号
    ,mode_pay -- 支付方式
    ,refund_idf_cd -- 退汇退款标识代码
    ,refund_src_flow_num -- 退汇退款源流水号
    ,refund_src_sub_flow_num -- 退汇退款源子流水号
    ,comm_fee -- 手续费
    ,pay_amt -- 支付金额
    ,actl_bal -- 实际余额
    ,aval_bal -- 可用余额
    ,mobile_no -- 手机号
    ,check_code -- 验证码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,clear_dt -- 清算日期
    ,core_tran_flow_num -- 核心交易流水号
    ,core_tran_dt -- 核心交易日期
    ,recge_rest_advise_cnt -- 充值结果通知次数
    ,recge_rest_advise_status_cd -- 充值结果通知状态代码
    ,recge_rest_advise_tm -- 充值结果通知时间
    ,bank_batch_id -- 银行批次编号
    ,trdpty_batch_id -- 第三方批次编号
    ,memo -- 摘要
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_cap_supv_tran_flow partition for ('fdpsf1')
where 0=1
;

create table ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_cap_supv_tran_flow partition for ('fdpsf1') where 0=1;

create table ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_cap_supv_tran_flow partition for ('fdpsf1') where 0=1;

-- 3.1 get new data into table
-- fdps_order_header-1
insert into ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_tm -- 交易时间
    ,coprator_id -- 合作商编号
    ,intnal_cust_id -- 内部客户编号
    ,intnal_cust_name -- 内部客户名称
    ,vtual_acct_id -- 虚拟账户编号
    ,vtual_acct_type_cd -- 虚拟账户类型代码
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,trdpty_flow_num -- 第三方流水号
    ,init_tran_flow_num -- 原交易流水号
    ,payer_intnal_cust_id -- 付款人内部客户编号
    ,payer_vtual_acct_id -- 付款人虚拟账户编号
    ,payer_bank_acct_name -- 付款人银行账户名称
    ,payer_bank_acct_id -- 付款人银行账户编号
    ,payer_open_bank_name -- 付款人开户银行名称
    ,payer_open_bank_id -- 付款人开户银行编号
    ,payer_open_ghb_flg -- 付款人开户银行本行标志
    ,recver_intnal_cust_id -- 收款人内部客户编号
    ,recver_vtual_acct_id -- 收款人虚拟账户编号
    ,guar_amt -- 担保金额
    ,guar_surp_amt -- 担保剩余金额
    ,avl_amt -- 到账金额
    ,recver_bank_acct_name -- 收款人银行账户名称
    ,recver_bank_acct_id -- 收款人银行账户编号
    ,recver_open_bank_name -- 收款人开户银行名称
    ,recver_open_bank_id -- 收款人开户银行编号
    ,mode_pay -- 支付方式
    ,refund_idf_cd -- 退汇退款标识代码
    ,refund_src_flow_num -- 退汇退款源流水号
    ,refund_src_sub_flow_num -- 退汇退款源子流水号
    ,comm_fee -- 手续费
    ,pay_amt -- 支付金额
    ,actl_bal -- 实际余额
    ,aval_bal -- 可用余额
    ,mobile_no -- 手机号
    ,check_code -- 验证码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,clear_dt -- 清算日期
    ,core_tran_flow_num -- 核心交易流水号
    ,core_tran_dt -- 核心交易日期
    ,recge_rest_advise_cnt -- 充值结果通知次数
    ,recge_rest_advise_status_cd -- 充值结果通知状态代码
    ,recge_rest_advise_tm -- 充值结果通知时间
    ,bank_batch_id -- 银行批次编号
    ,trdpty_batch_id -- 第三方批次编号
    ,memo -- 摘要
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104029'||P1.ORDER_ID_PK -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ORDER_ID -- 交易流水号
    ,P1.ORDER_TIME -- 交易时间
    ,P1.PARENT_MERCHANT_ID -- 合作商编号
    ,P1.MERCHANT_ID -- 内部客户编号
    ,P1.CUSTOMER_NAME -- 内部客户名称
    ,P1.ACCOUNT_NO -- 虚拟账户编号
    ,NVL(TRIM(P1.VIR_ACC_TYPE),'-') -- 虚拟账户类型代码
    ,NVL(TRIM(P1.TRAN_TYPE),'-') -- 交易码
    ,P1.TRAN_STATUS -- 交易状态代码
    ,P1.OLD_REQ_SEQ_NO -- 第三方流水号
    ,P1.ORG_ORDER_ID -- 原交易流水号
    ,P1.PAYER_MERCHANT_ID -- 付款人内部客户编号
    ,P1.PAYER_ACCOUNT_NO -- 付款人虚拟账户编号
    ,P1.PAYER_AC_NAME -- 付款人银行账户名称
    ,P1.PAYER_AC_NO -- 付款人银行账户编号
    ,P1.PAYER_BANK_NAME -- 付款人开户银行名称
    ,P1.PAYER_BANK_NO -- 付款人开户银行编号
    ,P1.OTHER_BANK_FLAG -- 付款人开户银行本行标志
    ,P1.PAYEE_MERCHANT_ID -- 收款人内部客户编号
    ,P1.PAYEE_ACCOUNT_NO -- 收款人虚拟账户编号
    ,P1.GUARANT_AMOUNT -- 担保金额
    ,P1.GUARANT_RE_AMOUNT -- 担保剩余金额
    ,P1.ARRIVAL_AMOUNT -- 到账金额
    ,P1.PAYEE_AC_NAME -- 收款人银行账户名称
    ,P1.PAYEE_AC_NO -- 收款人银行账户编号
    ,P1.PAYEE_BANK_NAME -- 收款人开户银行名称
    ,P1.PAYEE_BANK_NO -- 收款人开户银行编号
    ,P1.PAY_TYPE -- 支付方式
    ,nvl(trim（P1.RETREAT_SIGN）,'-') -- 退汇退款标识代码
    ,P1.RETREAT_SEQ_NO -- 退汇退款源流水号
    ,P1.RETREAT_SUB_SEQ_NO -- 退汇退款源子流水号
    ,P1.FEE_AMOUNT -- 手续费
    ,P1.AMOUNT -- 支付金额
    ,P1.ACTUAL_BALANCE -- 实际余额
    ,P1.AVAILABLE_BALANCE -- 可用余额
    ,P1.MOBILE -- 手机号
    ,' ' -- 验证码
    ,P1.RESP_CODE -- 返回码
    ,P1.RESP_MSG -- 返回信息
    ,${iml_schema}.dateformat_min(TRIM(P1.CLEAR_DATE)) -- 清算日期
    ,P1.HOST_SEQ_NO -- 核心交易流水号
    ,${iml_schema}.dateformat_min(TRIM(P1.HOST_DATE)) -- 核心交易日期
    ,P1.RET_REFORM_CNT -- 充值结果通知次数
    ,P1.RET_REFORM_STATUS -- 充值结果通知状态代码
    ,P1.RET_REFORM_TIME -- 充值结果通知时间
    ,P1.BATCH_ID -- 银行批次编号
    ,P1.THIRD_BATCH_ID -- 第三方批次编号
    ,P1.SUMMARY -- 摘要
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fdps_order_header' -- 源表名称
    ,'fdpsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fdps_order_header p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_tm 
  	                                group by 
  	                                        evt_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_tm -- 交易时间
    ,coprator_id -- 合作商编号
    ,intnal_cust_id -- 内部客户编号
    ,intnal_cust_name -- 内部客户名称
    ,vtual_acct_id -- 虚拟账户编号
    ,vtual_acct_type_cd -- 虚拟账户类型代码
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,trdpty_flow_num -- 第三方流水号
    ,init_tran_flow_num -- 原交易流水号
    ,payer_intnal_cust_id -- 付款人内部客户编号
    ,payer_vtual_acct_id -- 付款人虚拟账户编号
    ,payer_bank_acct_name -- 付款人银行账户名称
    ,payer_bank_acct_id -- 付款人银行账户编号
    ,payer_open_bank_name -- 付款人开户银行名称
    ,payer_open_bank_id -- 付款人开户银行编号
    ,payer_open_ghb_flg -- 付款人开户银行本行标志
    ,recver_intnal_cust_id -- 收款人内部客户编号
    ,recver_vtual_acct_id -- 收款人虚拟账户编号
    ,guar_amt -- 担保金额
    ,guar_surp_amt -- 担保剩余金额
    ,avl_amt -- 到账金额
    ,recver_bank_acct_name -- 收款人银行账户名称
    ,recver_bank_acct_id -- 收款人银行账户编号
    ,recver_open_bank_name -- 收款人开户银行名称
    ,recver_open_bank_id -- 收款人开户银行编号
    ,mode_pay -- 支付方式
    ,refund_idf_cd -- 退汇退款标识代码
    ,refund_src_flow_num -- 退汇退款源流水号
    ,refund_src_sub_flow_num -- 退汇退款源子流水号
    ,comm_fee -- 手续费
    ,pay_amt -- 支付金额
    ,actl_bal -- 实际余额
    ,aval_bal -- 可用余额
    ,mobile_no -- 手机号
    ,check_code -- 验证码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,clear_dt -- 清算日期
    ,core_tran_flow_num -- 核心交易流水号
    ,core_tran_dt -- 核心交易日期
    ,recge_rest_advise_cnt -- 充值结果通知次数
    ,recge_rest_advise_status_cd -- 充值结果通知状态代码
    ,recge_rest_advise_tm -- 充值结果通知时间
    ,bank_batch_id -- 银行批次编号
    ,trdpty_batch_id -- 第三方批次编号
    ,memo -- 摘要
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_tm -- 交易时间
    ,coprator_id -- 合作商编号
    ,intnal_cust_id -- 内部客户编号
    ,intnal_cust_name -- 内部客户名称
    ,vtual_acct_id -- 虚拟账户编号
    ,vtual_acct_type_cd -- 虚拟账户类型代码
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,trdpty_flow_num -- 第三方流水号
    ,init_tran_flow_num -- 原交易流水号
    ,payer_intnal_cust_id -- 付款人内部客户编号
    ,payer_vtual_acct_id -- 付款人虚拟账户编号
    ,payer_bank_acct_name -- 付款人银行账户名称
    ,payer_bank_acct_id -- 付款人银行账户编号
    ,payer_open_bank_name -- 付款人开户银行名称
    ,payer_open_bank_id -- 付款人开户银行编号
    ,payer_open_ghb_flg -- 付款人开户银行本行标志
    ,recver_intnal_cust_id -- 收款人内部客户编号
    ,recver_vtual_acct_id -- 收款人虚拟账户编号
    ,guar_amt -- 担保金额
    ,guar_surp_amt -- 担保剩余金额
    ,avl_amt -- 到账金额
    ,recver_bank_acct_name -- 收款人银行账户名称
    ,recver_bank_acct_id -- 收款人银行账户编号
    ,recver_open_bank_name -- 收款人开户银行名称
    ,recver_open_bank_id -- 收款人开户银行编号
    ,mode_pay -- 支付方式
    ,refund_idf_cd -- 退汇退款标识代码
    ,refund_src_flow_num -- 退汇退款源流水号
    ,refund_src_sub_flow_num -- 退汇退款源子流水号
    ,comm_fee -- 手续费
    ,pay_amt -- 支付金额
    ,actl_bal -- 实际余额
    ,aval_bal -- 可用余额
    ,mobile_no -- 手机号
    ,check_code -- 验证码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,clear_dt -- 清算日期
    ,core_tran_flow_num -- 核心交易流水号
    ,core_tran_dt -- 核心交易日期
    ,recge_rest_advise_cnt -- 充值结果通知次数
    ,recge_rest_advise_status_cd -- 充值结果通知状态代码
    ,recge_rest_advise_tm -- 充值结果通知时间
    ,bank_batch_id -- 银行批次编号
    ,trdpty_batch_id -- 第三方批次编号
    ,memo -- 摘要
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 事件编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.coprator_id, o.coprator_id) as coprator_id -- 合作商编号
    ,nvl(n.intnal_cust_id, o.intnal_cust_id) as intnal_cust_id -- 内部客户编号
    ,nvl(n.intnal_cust_name, o.intnal_cust_name) as intnal_cust_name -- 内部客户名称
    ,nvl(n.vtual_acct_id, o.vtual_acct_id) as vtual_acct_id -- 虚拟账户编号
    ,nvl(n.vtual_acct_type_cd, o.vtual_acct_type_cd) as vtual_acct_type_cd -- 虚拟账户类型代码
    ,nvl(n.tran_code, o.tran_code) as tran_code -- 交易码
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.trdpty_flow_num, o.trdpty_flow_num) as trdpty_flow_num -- 第三方流水号
    ,nvl(n.init_tran_flow_num, o.init_tran_flow_num) as init_tran_flow_num -- 原交易流水号
    ,nvl(n.payer_intnal_cust_id, o.payer_intnal_cust_id) as payer_intnal_cust_id -- 付款人内部客户编号
    ,nvl(n.payer_vtual_acct_id, o.payer_vtual_acct_id) as payer_vtual_acct_id -- 付款人虚拟账户编号
    ,nvl(n.payer_bank_acct_name, o.payer_bank_acct_name) as payer_bank_acct_name -- 付款人银行账户名称
    ,nvl(n.payer_bank_acct_id, o.payer_bank_acct_id) as payer_bank_acct_id -- 付款人银行账户编号
    ,nvl(n.payer_open_bank_name, o.payer_open_bank_name) as payer_open_bank_name -- 付款人开户银行名称
    ,nvl(n.payer_open_bank_id, o.payer_open_bank_id) as payer_open_bank_id -- 付款人开户银行编号
    ,nvl(n.payer_open_ghb_flg, o.payer_open_ghb_flg) as payer_open_ghb_flg -- 付款人开户银行本行标志
    ,nvl(n.recver_intnal_cust_id, o.recver_intnal_cust_id) as recver_intnal_cust_id -- 收款人内部客户编号
    ,nvl(n.recver_vtual_acct_id, o.recver_vtual_acct_id) as recver_vtual_acct_id -- 收款人虚拟账户编号
    ,nvl(n.guar_amt, o.guar_amt) as guar_amt -- 担保金额
    ,nvl(n.guar_surp_amt, o.guar_surp_amt) as guar_surp_amt -- 担保剩余金额
    ,nvl(n.avl_amt, o.avl_amt) as avl_amt -- 到账金额
    ,nvl(n.recver_bank_acct_name, o.recver_bank_acct_name) as recver_bank_acct_name -- 收款人银行账户名称
    ,nvl(n.recver_bank_acct_id, o.recver_bank_acct_id) as recver_bank_acct_id -- 收款人银行账户编号
    ,nvl(n.recver_open_bank_name, o.recver_open_bank_name) as recver_open_bank_name -- 收款人开户银行名称
    ,nvl(n.recver_open_bank_id, o.recver_open_bank_id) as recver_open_bank_id -- 收款人开户银行编号
    ,nvl(n.mode_pay, o.mode_pay) as mode_pay -- 支付方式
    ,nvl(n.refund_idf_cd, o.refund_idf_cd) as refund_idf_cd -- 退汇退款标识代码
    ,nvl(n.refund_src_flow_num, o.refund_src_flow_num) as refund_src_flow_num -- 退汇退款源流水号
    ,nvl(n.refund_src_sub_flow_num, o.refund_src_sub_flow_num) as refund_src_sub_flow_num -- 退汇退款源子流水号
    ,nvl(n.comm_fee, o.comm_fee) as comm_fee -- 手续费
    ,nvl(n.pay_amt, o.pay_amt) as pay_amt -- 支付金额
    ,nvl(n.actl_bal, o.actl_bal) as actl_bal -- 实际余额
    ,nvl(n.aval_bal, o.aval_bal) as aval_bal -- 可用余额
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号
    ,nvl(n.check_code, o.check_code) as check_code -- 验证码
    ,nvl(n.return_code, o.return_code) as return_code -- 返回码
    ,nvl(n.return_info, o.return_info) as return_info -- 返回信息
    ,nvl(n.clear_dt, o.clear_dt) as clear_dt -- 清算日期
    ,nvl(n.core_tran_flow_num, o.core_tran_flow_num) as core_tran_flow_num -- 核心交易流水号
    ,nvl(n.core_tran_dt, o.core_tran_dt) as core_tran_dt -- 核心交易日期
    ,nvl(n.recge_rest_advise_cnt, o.recge_rest_advise_cnt) as recge_rest_advise_cnt -- 充值结果通知次数
    ,nvl(n.recge_rest_advise_status_cd, o.recge_rest_advise_status_cd) as recge_rest_advise_status_cd -- 充值结果通知状态代码
    ,nvl(n.recge_rest_advise_tm, o.recge_rest_advise_tm) as recge_rest_advise_tm -- 充值结果通知时间
    ,nvl(n.bank_batch_id, o.bank_batch_id) as bank_batch_id -- 银行批次编号
    ,nvl(n.trdpty_batch_id, o.trdpty_batch_id) as trdpty_batch_id -- 第三方批次编号
    ,nvl(n.memo, o.memo) as memo -- 摘要
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_tm n
    full join (select * from ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
    )
    or (
        o.tran_flow_num <> n.tran_flow_num
        or o.tran_tm <> n.tran_tm
        or o.coprator_id <> n.coprator_id
        or o.intnal_cust_id <> n.intnal_cust_id
        or o.intnal_cust_name <> n.intnal_cust_name
        or o.vtual_acct_id <> n.vtual_acct_id
        or o.vtual_acct_type_cd <> n.vtual_acct_type_cd
        or o.tran_code <> n.tran_code
        or o.tran_status_cd <> n.tran_status_cd
        or o.trdpty_flow_num <> n.trdpty_flow_num
        or o.init_tran_flow_num <> n.init_tran_flow_num
        or o.payer_intnal_cust_id <> n.payer_intnal_cust_id
        or o.payer_vtual_acct_id <> n.payer_vtual_acct_id
        or o.payer_bank_acct_name <> n.payer_bank_acct_name
        or o.payer_bank_acct_id <> n.payer_bank_acct_id
        or o.payer_open_bank_name <> n.payer_open_bank_name
        or o.payer_open_bank_id <> n.payer_open_bank_id
        or o.payer_open_ghb_flg <> n.payer_open_ghb_flg
        or o.recver_intnal_cust_id <> n.recver_intnal_cust_id
        or o.recver_vtual_acct_id <> n.recver_vtual_acct_id
        or o.guar_amt <> n.guar_amt
        or o.guar_surp_amt <> n.guar_surp_amt
        or o.avl_amt <> n.avl_amt
        or o.recver_bank_acct_name <> n.recver_bank_acct_name
        or o.recver_bank_acct_id <> n.recver_bank_acct_id
        or o.recver_open_bank_name <> n.recver_open_bank_name
        or o.recver_open_bank_id <> n.recver_open_bank_id
        or o.mode_pay <> n.mode_pay
        or o.refund_idf_cd <> n.refund_idf_cd
        or o.refund_src_flow_num <> n.refund_src_flow_num
        or o.refund_src_sub_flow_num <> n.refund_src_sub_flow_num
        or o.comm_fee <> n.comm_fee
        or o.pay_amt <> n.pay_amt
        or o.actl_bal <> n.actl_bal
        or o.aval_bal <> n.aval_bal
        or o.mobile_no <> n.mobile_no
        or o.check_code <> n.check_code
        or o.return_code <> n.return_code
        or o.return_info <> n.return_info
        or o.clear_dt <> n.clear_dt
        or o.core_tran_flow_num <> n.core_tran_flow_num
        or o.core_tran_dt <> n.core_tran_dt
        or o.recge_rest_advise_cnt <> n.recge_rest_advise_cnt
        or o.recge_rest_advise_status_cd <> n.recge_rest_advise_status_cd
        or o.recge_rest_advise_tm <> n.recge_rest_advise_tm
        or o.bank_batch_id <> n.bank_batch_id
        or o.trdpty_batch_id <> n.trdpty_batch_id
        or o.memo <> n.memo
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_tm -- 交易时间
    ,coprator_id -- 合作商编号
    ,intnal_cust_id -- 内部客户编号
    ,intnal_cust_name -- 内部客户名称
    ,vtual_acct_id -- 虚拟账户编号
    ,vtual_acct_type_cd -- 虚拟账户类型代码
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,trdpty_flow_num -- 第三方流水号
    ,init_tran_flow_num -- 原交易流水号
    ,payer_intnal_cust_id -- 付款人内部客户编号
    ,payer_vtual_acct_id -- 付款人虚拟账户编号
    ,payer_bank_acct_name -- 付款人银行账户名称
    ,payer_bank_acct_id -- 付款人银行账户编号
    ,payer_open_bank_name -- 付款人开户银行名称
    ,payer_open_bank_id -- 付款人开户银行编号
    ,payer_open_ghb_flg -- 付款人开户银行本行标志
    ,recver_intnal_cust_id -- 收款人内部客户编号
    ,recver_vtual_acct_id -- 收款人虚拟账户编号
    ,guar_amt -- 担保金额
    ,guar_surp_amt -- 担保剩余金额
    ,avl_amt -- 到账金额
    ,recver_bank_acct_name -- 收款人银行账户名称
    ,recver_bank_acct_id -- 收款人银行账户编号
    ,recver_open_bank_name -- 收款人开户银行名称
    ,recver_open_bank_id -- 收款人开户银行编号
    ,mode_pay -- 支付方式
    ,refund_idf_cd -- 退汇退款标识代码
    ,refund_src_flow_num -- 退汇退款源流水号
    ,refund_src_sub_flow_num -- 退汇退款源子流水号
    ,comm_fee -- 手续费
    ,pay_amt -- 支付金额
    ,actl_bal -- 实际余额
    ,aval_bal -- 可用余额
    ,mobile_no -- 手机号
    ,check_code -- 验证码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,clear_dt -- 清算日期
    ,core_tran_flow_num -- 核心交易流水号
    ,core_tran_dt -- 核心交易日期
    ,recge_rest_advise_cnt -- 充值结果通知次数
    ,recge_rest_advise_status_cd -- 充值结果通知状态代码
    ,recge_rest_advise_tm -- 充值结果通知时间
    ,bank_batch_id -- 银行批次编号
    ,trdpty_batch_id -- 第三方批次编号
    ,memo -- 摘要
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_tm -- 交易时间
    ,coprator_id -- 合作商编号
    ,intnal_cust_id -- 内部客户编号
    ,intnal_cust_name -- 内部客户名称
    ,vtual_acct_id -- 虚拟账户编号
    ,vtual_acct_type_cd -- 虚拟账户类型代码
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,trdpty_flow_num -- 第三方流水号
    ,init_tran_flow_num -- 原交易流水号
    ,payer_intnal_cust_id -- 付款人内部客户编号
    ,payer_vtual_acct_id -- 付款人虚拟账户编号
    ,payer_bank_acct_name -- 付款人银行账户名称
    ,payer_bank_acct_id -- 付款人银行账户编号
    ,payer_open_bank_name -- 付款人开户银行名称
    ,payer_open_bank_id -- 付款人开户银行编号
    ,payer_open_ghb_flg -- 付款人开户银行本行标志
    ,recver_intnal_cust_id -- 收款人内部客户编号
    ,recver_vtual_acct_id -- 收款人虚拟账户编号
    ,guar_amt -- 担保金额
    ,guar_surp_amt -- 担保剩余金额
    ,avl_amt -- 到账金额
    ,recver_bank_acct_name -- 收款人银行账户名称
    ,recver_bank_acct_id -- 收款人银行账户编号
    ,recver_open_bank_name -- 收款人开户银行名称
    ,recver_open_bank_id -- 收款人开户银行编号
    ,mode_pay -- 支付方式
    ,refund_idf_cd -- 退汇退款标识代码
    ,refund_src_flow_num -- 退汇退款源流水号
    ,refund_src_sub_flow_num -- 退汇退款源子流水号
    ,comm_fee -- 手续费
    ,pay_amt -- 支付金额
    ,actl_bal -- 实际余额
    ,aval_bal -- 可用余额
    ,mobile_no -- 手机号
    ,check_code -- 验证码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,clear_dt -- 清算日期
    ,core_tran_flow_num -- 核心交易流水号
    ,core_tran_dt -- 核心交易日期
    ,recge_rest_advise_cnt -- 充值结果通知次数
    ,recge_rest_advise_status_cd -- 充值结果通知状态代码
    ,recge_rest_advise_tm -- 充值结果通知时间
    ,bank_batch_id -- 银行批次编号
    ,trdpty_batch_id -- 第三方批次编号
    ,memo -- 摘要
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.tran_flow_num -- 交易流水号
    ,o.tran_tm -- 交易时间
    ,o.coprator_id -- 合作商编号
    ,o.intnal_cust_id -- 内部客户编号
    ,o.intnal_cust_name -- 内部客户名称
    ,o.vtual_acct_id -- 虚拟账户编号
    ,o.vtual_acct_type_cd -- 虚拟账户类型代码
    ,o.tran_code -- 交易码
    ,o.tran_status_cd -- 交易状态代码
    ,o.trdpty_flow_num -- 第三方流水号
    ,o.init_tran_flow_num -- 原交易流水号
    ,o.payer_intnal_cust_id -- 付款人内部客户编号
    ,o.payer_vtual_acct_id -- 付款人虚拟账户编号
    ,o.payer_bank_acct_name -- 付款人银行账户名称
    ,o.payer_bank_acct_id -- 付款人银行账户编号
    ,o.payer_open_bank_name -- 付款人开户银行名称
    ,o.payer_open_bank_id -- 付款人开户银行编号
    ,o.payer_open_ghb_flg -- 付款人开户银行本行标志
    ,o.recver_intnal_cust_id -- 收款人内部客户编号
    ,o.recver_vtual_acct_id -- 收款人虚拟账户编号
    ,o.guar_amt -- 担保金额
    ,o.guar_surp_amt -- 担保剩余金额
    ,o.avl_amt -- 到账金额
    ,o.recver_bank_acct_name -- 收款人银行账户名称
    ,o.recver_bank_acct_id -- 收款人银行账户编号
    ,o.recver_open_bank_name -- 收款人开户银行名称
    ,o.recver_open_bank_id -- 收款人开户银行编号
    ,o.mode_pay -- 支付方式
    ,o.refund_idf_cd -- 退汇退款标识代码
    ,o.refund_src_flow_num -- 退汇退款源流水号
    ,o.refund_src_sub_flow_num -- 退汇退款源子流水号
    ,o.comm_fee -- 手续费
    ,o.pay_amt -- 支付金额
    ,o.actl_bal -- 实际余额
    ,o.aval_bal -- 可用余额
    ,o.mobile_no -- 手机号
    ,o.check_code -- 验证码
    ,o.return_code -- 返回码
    ,o.return_info -- 返回信息
    ,o.clear_dt -- 清算日期
    ,o.core_tran_flow_num -- 核心交易流水号
    ,o.core_tran_dt -- 核心交易日期
    ,o.recge_rest_advise_cnt -- 充值结果通知次数
    ,o.recge_rest_advise_status_cd -- 充值结果通知状态代码
    ,o.recge_rest_advise_tm -- 充值结果通知时间
    ,o.bank_batch_id -- 银行批次编号
    ,o.trdpty_batch_id -- 第三方批次编号
    ,o.memo -- 摘要
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_bk o
    left join ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_cap_supv_tran_flow;
alter table ${iml_schema}.evt_cap_supv_tran_flow truncate partition for ('fdpsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.evt_cap_supv_tran_flow exchange subpartition p_fdpsf1_19000101 with table ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_cl;
alter table ${iml_schema}.evt_cap_supv_tran_flow exchange subpartition p_fdpsf1_20991231 with table ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_cap_supv_tran_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_tm purge;
drop table ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_op purge;
drop table ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_cap_supv_tran_flow_fdpsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_cap_supv_tran_flow', partname => 'p_fdpsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
