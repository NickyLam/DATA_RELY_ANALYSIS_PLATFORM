/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_agt_wl_distr_info
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
alter table ${idl_schema}.aml_agt_wl_distr_info drop partition p_${last_date};
alter table ${idl_schema}.aml_agt_wl_distr_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_agt_wl_distr_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_agt_wl_distr_info (
    etl_dt  -- 数据日期
    ,distr_id  -- 放款编号
    ,appl_id  -- 申请编号
    ,lp_id  -- 法人编号
    ,agt_id  -- 协议编号
    ,dubil_id  -- 借据编号
    ,prod_id  -- 产品编号
    ,cust_id  -- 客户编号
    ,cust_name  -- 客户名称
    ,appl_amt  -- 申请金额
    ,appl_dt  -- 申请日期
    ,distr_dt  -- 放款日期
    ,open_acct_bank_name  -- 开户银行名称
    ,open_acct_card_no  -- 开户卡号
    ,repay_acct_name  -- 还款账户名称
    ,repay_acct_card_no  -- 还款账户卡号
    ,loan_perds  -- 贷款期数
    ,loan_int_rat  -- 贷款利率
    ,serv_int_rat  -- 服务利率
    ,inst_comm_fee_rat  -- 分期手续费率
    ,serv_fee  -- 服务费用
    ,distr_amt  -- 放款金额
    ,inst_comm_fee_amt  -- 分期手续费金额
    ,distr_way_cd  -- 放款方式代码
    ,appl_status_cd  -- 申请状态代码
    ,tran_status_cd  -- 转账状态代码
    ,manu_apv_flg  -- 人工审批标志
    ,obank_card_flg  -- 他行卡标志
    ,fail_oper_flow_cd  -- 失败操作流程代码
    ,open_acct_bind_mobile_no  -- 开户绑定手机号码
    ,obank_card_tran_flow_num  -- 他行卡转账流水号
    ,pay_order_no  -- 支付订单号
    ,loan_tran_flow_num  -- 贷款交易流水号
    ,glob_tran_flow_num  -- 全局交易流水号
    ,host_crdt_flow_num  -- 主机贷记流水号
    ,host_debit_flow_num  -- 主机借记流水号
    ,froz_tran_dt  -- 冻结交易日期
    ,froz_tran_flow_id  -- 冻结交易流水编号
    ,distr_mode_cd  -- 放款模式代码
    ,noth_rpp_conti_old_dubil_id  -- 无还本续贷旧借据编号
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.distr_id,chr(13),''),chr(10),'')  -- 放款编号
    ,replace(replace(t1.appl_id,chr(13),''),chr(10),'')  -- 申请编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.agt_id,chr(13),''),chr(10),'')  -- 协议编号
    ,replace(replace(t1.dubil_id,chr(13),''),chr(10),'')  -- 借据编号
    ,replace(replace(t1.prod_id,chr(13),''),chr(10),'')  -- 产品编号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.cust_name,chr(13),''),chr(10),'')  -- 客户名称
    ,t1.appl_amt  -- 申请金额
    ,t1.appl_dt  -- 申请日期
    ,t1.distr_dt  -- 放款日期
    ,replace(replace(t1.open_acct_bank_name,chr(13),''),chr(10),'')  -- 开户银行名称
    ,replace(replace(t1.open_acct_card_no,chr(13),''),chr(10),'')  -- 开户卡号
    ,replace(replace(t1.repay_acct_name,chr(13),''),chr(10),'')  -- 还款账户名称
    ,replace(replace(t1.repay_acct_card_no,chr(13),''),chr(10),'')  -- 还款账户卡号
    ,t1.loan_perds  -- 贷款期数
    ,t1.loan_int_rat  -- 贷款利率
    ,t1.serv_int_rat  -- 服务利率
    ,t1.inst_comm_fee_rat  -- 分期手续费率
    ,t1.serv_fee  -- 服务费用
    ,t1.distr_amt  -- 放款金额
    ,t1.inst_comm_fee_amt  -- 分期手续费金额
    ,replace(replace(t1.distr_way_cd,chr(13),''),chr(10),'')  -- 放款方式代码
    ,replace(replace(t1.appl_status_cd,chr(13),''),chr(10),'')  -- 申请状态代码
    ,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'')  -- 转账状态代码
    ,replace(replace(t1.manu_apv_flg,chr(13),''),chr(10),'')  -- 人工审批标志
    ,replace(replace(t1.obank_card_flg,chr(13),''),chr(10),'')  -- 他行卡标志
    ,replace(replace(t1.fail_oper_flow_cd,chr(13),''),chr(10),'')  -- 失败操作流程代码
    ,replace(replace(t1.open_acct_bind_mobile_no,chr(13),''),chr(10),'')  -- 开户绑定手机号码
    ,replace(replace(t1.obank_card_tran_flow_num,chr(13),''),chr(10),'')  -- 他行卡转账流水号
    ,replace(replace(t1.pay_order_no,chr(13),''),chr(10),'')  -- 支付订单号
    ,replace(replace(t1.loan_tran_flow_num,chr(13),''),chr(10),'')  -- 贷款交易流水号
    ,replace(replace(t1.glob_tran_flow_num,chr(13),''),chr(10),'')  -- 全局交易流水号
    ,replace(replace(t1.host_crdt_flow_num,chr(13),''),chr(10),'')  -- 主机贷记流水号
    ,replace(replace(t1.host_debit_flow_num,chr(13),''),chr(10),'')  -- 主机借记流水号
    ,t1.froz_tran_dt  -- 冻结交易日期
    ,replace(replace(t1.froz_tran_flow_id,chr(13),''),chr(10),'')  -- 冻结交易流水编号
    ,replace(replace(t1.distr_mode_cd,chr(13),''),chr(10),'')  -- 放款模式代码
    ,replace(replace(t1.noth_rpp_conti_old_dubil_id,chr(13),''),chr(10),'')  -- 无还本续贷旧借据编号
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.agt_wl_distr_info t1    --网贷放款信息
where t1.create_dt <= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_agt_wl_distr_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);