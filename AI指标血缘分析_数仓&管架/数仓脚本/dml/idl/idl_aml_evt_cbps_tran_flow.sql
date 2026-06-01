/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_evt_cbps_tran_flow
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
alter table ${idl_schema}.aml_evt_cbps_tran_flow drop partition p_${last_date};
alter table ${idl_schema}.aml_evt_cbps_tran_flow drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_evt_cbps_tran_flow add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_evt_cbps_tran_flow (
    etl_dt  -- 数据日期
    ,evt_id  -- 事件编号
    ,lp_id  -- 法人编号
    ,sys_id  -- 系统编号
    ,midgrod_flow_num  -- 中台流水号
    ,midgrod_tran_dt  -- 中台交易日期
    ,midgrod_tran_tm  -- 中台交易时间
    ,msg_type_id  -- 报文类型编号
    ,origi_bank_no  -- 发起行行号
    ,init_clear_bk_no  -- 发起清算行行号
    ,recv_bank_no  -- 接收行行号
    ,recv_clear_bk_no  -- 接收清算行行号
    ,entr_dt  -- 委托日期
    ,msg_idf_id  -- 报文标识编号
    ,dtl_idf_id  -- 明细标识编号
    ,bank_int_bus_seq_num  -- 行内业务序号
    ,midgrod_tran_code  -- 中台交易码
    ,curr_cd  -- 币种代码
    ,tran_amt  -- 交易金额
    ,nostro_cd  -- 往来账代码
    ,debit_crdt_dir_cd  -- 借贷方向代码
    ,core_tran_code  -- 核心交易码
    ,core_tran_dt  -- 核心交易日期
    ,core_flow_num  -- 核心流水号
    ,entr_tm  -- 委托时间
    ,payer_open_belong_city_cd  -- 付款人开户行所属城市代码
    ,pay_clear_bk_no  -- 付款清算行行号
    ,payer_open_dept_id  -- 付款人开户行部门编号
    ,payer_open_no  -- 付款人开户行行号
    ,payer_open_bank_name  -- 付款人开户行名称
    ,payer_acct_type_cd  -- 付款人账户类型代码
    ,payer_acct_num  -- 付款人账号
    ,payer_name  -- 付款人名称
    ,payer_addr  -- 付款人地址
    ,recver_open_belong_city_cd  -- 收款人开户行所属城市代码
    ,recver_open_bank_no  -- 收款人开户行行号
    ,recvbl_clear_bk_no  -- 收款清算行行号
    ,recver_open_bank_name  -- 收款人开户行名称
    ,recver_acct_type_cd  -- 收款人账户类型代码
    ,recver_acct_num  -- 收款人账号
    ,recver_name  -- 收款人名称
    ,recver_addr  -- 收款人地址
    ,bus_type_cd  -- 业务类型代码
    ,bus_kind_cd  -- 业务种类代码
    ,init_entr_dt  -- 原委托日期
    ,init_msg_idf_id  -- 原报文标识编号
    ,init_origi_bank_no  -- 原发起行行号
    ,init_msg_type_id  -- 原报文类型编号
    ,mode_pay_cd  -- 支付方式代码
    ,vouch_type_cd  -- 凭证类型代码
    ,vouch_dt  -- 凭证日期
    ,vouch_no  -- 凭证号码
    ,prior_level  -- 优先级别
    ,tran_org_id  -- 交易机构编号
    ,tran_teller_id  -- 交易柜员编号
    ,refund_rs_descb  -- 退汇原因描述
    ,tran_chn_cd  -- 交易渠道代码
    ,tran_lmt  -- 转账限额
    ,err_return_code  -- 错误返回码
    ,err_info_desc  -- 错误信息描述
    ,recv_tm  -- 接收时间
    ,rtn_rcpt_msg_idf_id  -- 回执报文标识编号
    ,cbps_bus_status_cd  -- 城银清算业务状态代码
    ,offs_bal_num_site  -- 轧差场次
    ,offs_bal_dt  -- 轧差日期
    ,cbps_bus_process_cd  -- 城银清算业务处理码
    ,clear_dt  -- 清算日期
    ,bus_check_entry_status_cd  -- 业务对账状态代码
    ,core_check_entry_status_cd  -- 核心对账状态代码
    ,tran_status_cd  -- 交易状态代码
    ,tran_rest_descb  -- 交易结果描述
    ,update_tm  -- 更新时间
    ,mgmt_org_id  -- 管理机构编号
    ,on_acct_rs_cd  -- 挂账原因代码
    ,on_acct_rs_comnt  -- 挂账原因说明
    ,on_acct_dt  -- 挂账日期
    ,on_acct_teller_id  -- 挂账柜员编号
    ,on_acct_org_id  -- 挂账机构编号
    ,on_acct_acct_num  -- 挂账账号
    ,on_acct_acct_name  -- 挂账账户名称
    ,matn_enter_acct_dt  -- 维护入账日期
    ,matn_enter_acct_teller_id  -- 维护入账柜员编号
    ,matn_enter_acct_org_id  -- 维护入账机构编号
    ,matn_enter_acct_num  -- 维护入账账号
    ,matn_enter_name  -- 维护入账账户名称
    ,revs_teller_id  -- 冲正柜员编号
    ,revs_tran_flow_num  -- 冲正交易流水号
    ,revs_dt  -- 冲正日期
    ,intnal_acct_flg  -- 内部账标志
    ,actl_deduct_acct_num  -- 实际扣账账号
    ,actl_deduct_acct_name  -- 实际扣账账户名称
    ,e_acct_flg  -- 电子账户标志
    ,acct_type_cd  -- 账户类型代码
    ,ova_flow_num  -- 全局流水号
    ,unify_pay_chn_flow_num  -- 统一支付渠道流水号
    ,happ_od_flg  -- 发生透支标志
    ,od_amt  -- 透支金额
    ,lmt_order_no  -- 限额订单号
    ,e_acct_prod_acct_num  -- 电子账户产品账号
    ,e_acct_entry_memo  -- 电子账户记账摘要
    ,pay_check_midgrod_flow_num  -- 支付对账中台流水号
    ,pay_check_midgrod_tran_dt  -- 支付对账中台交易日期
    ,tran_type_cd  -- 交易类型代码
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.evt_id,chr(13),''),chr(10),'')  -- 事件编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.sys_id,chr(13),''),chr(10),'')  -- 系统编号
    ,replace(replace(t1.midgrod_flow_num,chr(13),''),chr(10),'')  -- 中台流水号
    ,t1.midgrod_tran_dt  -- 中台交易日期
    ,replace(replace(t1.midgrod_tran_tm,chr(13),''),chr(10),'')  -- 中台交易时间
    ,replace(replace(t1.msg_type_id,chr(13),''),chr(10),'')  -- 报文类型编号
    ,replace(replace(t1.origi_bank_no,chr(13),''),chr(10),'')  -- 发起行行号
    ,replace(replace(t1.init_clear_bk_no,chr(13),''),chr(10),'')  -- 发起清算行行号
    ,replace(replace(t1.recv_bank_no,chr(13),''),chr(10),'')  -- 接收行行号
    ,replace(replace(t1.recv_clear_bk_no,chr(13),''),chr(10),'')  -- 接收清算行行号
    ,t1.entr_dt  -- 委托日期
    ,replace(replace(t1.msg_idf_id,chr(13),''),chr(10),'')  -- 报文标识编号
    ,replace(replace(t1.dtl_idf_id,chr(13),''),chr(10),'')  -- 明细标识编号
    ,replace(replace(t1.bank_int_bus_seq_num,chr(13),''),chr(10),'')  -- 行内业务序号
    ,replace(replace(t1.midgrod_tran_code,chr(13),''),chr(10),'')  -- 中台交易码
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.tran_amt  -- 交易金额
    ,replace(replace(t1.nostro_cd,chr(13),''),chr(10),'')  -- 往来账代码
    ,replace(replace(t1.debit_crdt_dir_cd,chr(13),''),chr(10),'')  -- 借贷方向代码
    ,replace(replace(t1.core_tran_code,chr(13),''),chr(10),'')  -- 核心交易码
    ,t1.core_tran_dt  -- 核心交易日期
    ,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'')  -- 核心流水号
    ,t1.entr_tm  -- 委托时间
    ,replace(replace(t1.payer_open_belong_city_cd,chr(13),''),chr(10),'')  -- 付款人开户行所属城市代码
    ,replace(replace(t1.pay_clear_bk_no,chr(13),''),chr(10),'')  -- 付款清算行行号
    ,replace(replace(t1.payer_open_dept_id,chr(13),''),chr(10),'')  -- 付款人开户行部门编号
    ,replace(replace(t1.payer_open_no,chr(13),''),chr(10),'')  -- 付款人开户行行号
    ,replace(replace(t1.payer_open_bank_name,chr(13),''),chr(10),'')  -- 付款人开户行名称
    ,replace(replace(t1.payer_acct_type_cd,chr(13),''),chr(10),'')  -- 付款人账户类型代码
    ,replace(replace(t1.payer_acct_num,chr(13),''),chr(10),'')  -- 付款人账号
    ,replace(replace(t1.payer_name,chr(13),''),chr(10),'')  -- 付款人名称
    ,replace(replace(t1.payer_addr,chr(13),''),chr(10),'')  -- 付款人地址
    ,replace(replace(t1.recver_open_belong_city_cd,chr(13),''),chr(10),'')  -- 收款人开户行所属城市代码
    ,replace(replace(t1.recver_open_bank_no,chr(13),''),chr(10),'')  -- 收款人开户行行号
    ,replace(replace(t1.recvbl_clear_bk_no,chr(13),''),chr(10),'')  -- 收款清算行行号
    ,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'')  -- 收款人开户行名称
    ,replace(replace(t1.recver_acct_type_cd,chr(13),''),chr(10),'')  -- 收款人账户类型代码
    ,replace(replace(t1.recver_acct_num,chr(13),''),chr(10),'')  -- 收款人账号
    ,replace(replace(t1.recver_name,chr(13),''),chr(10),'')  -- 收款人名称
    ,replace(replace(t1.recver_addr,chr(13),''),chr(10),'')  -- 收款人地址
    ,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'')  -- 业务类型代码
    ,replace(replace(t1.bus_kind_cd,chr(13),''),chr(10),'')  -- 业务种类代码
    ,t1.init_entr_dt  -- 原委托日期
    ,replace(replace(t1.init_msg_idf_id,chr(13),''),chr(10),'')  -- 原报文标识编号
    ,replace(replace(t1.init_origi_bank_no,chr(13),''),chr(10),'')  -- 原发起行行号
    ,replace(replace(t1.init_msg_type_id,chr(13),''),chr(10),'')  -- 原报文类型编号
    ,replace(replace(t1.mode_pay_cd,chr(13),''),chr(10),'')  -- 支付方式代码
    ,replace(replace(t1.vouch_type_cd,chr(13),''),chr(10),'')  -- 凭证类型代码
    ,t1.vouch_dt  -- 凭证日期
    ,replace(replace(t1.vouch_no,chr(13),''),chr(10),'')  -- 凭证号码
    ,replace(replace(t1.prior_level,chr(13),''),chr(10),'')  -- 优先级别
    ,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'')  -- 交易机构编号
    ,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'')  -- 交易柜员编号
    ,replace(replace(t1.refund_rs_descb,chr(13),''),chr(10),'')  -- 退汇原因描述
    ,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'')  -- 交易渠道代码
    ,t1.tran_lmt  -- 转账限额
    ,replace(replace(t1.err_return_code,chr(13),''),chr(10),'')  -- 错误返回码
    ,replace(replace(t1.err_info_desc,chr(13),''),chr(10),'')  -- 错误信息描述
    ,t1.recv_tm  -- 接收时间
    ,replace(replace(t1.rtn_rcpt_msg_idf_id,chr(13),''),chr(10),'')  -- 回执报文标识编号
    ,replace(replace(t1.cbps_bus_status_cd,chr(13),''),chr(10),'')  -- 城银清算业务状态代码
    ,replace(replace(t1.offs_bal_num_site,chr(13),''),chr(10),'')  -- 轧差场次
    ,t1.offs_bal_dt  -- 轧差日期
    ,replace(replace(t1.cbps_bus_process_cd,chr(13),''),chr(10),'')  -- 城银清算业务处理码
    ,t1.clear_dt  -- 清算日期
    ,replace(replace(t1.bus_check_entry_status_cd,chr(13),''),chr(10),'')  -- 业务对账状态代码
    ,replace(replace(t1.core_check_entry_status_cd,chr(13),''),chr(10),'')  -- 核心对账状态代码
    ,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'')  -- 交易状态代码
    ,replace(replace(t1.tran_rest_descb,chr(13),''),chr(10),'')  -- 交易结果描述
    ,t1.update_tm  -- 更新时间
    ,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'')  -- 管理机构编号
    ,replace(replace(t1.on_acct_rs_cd,chr(13),''),chr(10),'')  -- 挂账原因代码
    ,replace(replace(t1.on_acct_rs_comnt,chr(13),''),chr(10),'')  -- 挂账原因说明
    ,t1.on_acct_dt  -- 挂账日期
    ,replace(replace(t1.on_acct_teller_id,chr(13),''),chr(10),'')  -- 挂账柜员编号
    ,replace(replace(t1.on_acct_org_id,chr(13),''),chr(10),'')  -- 挂账机构编号
    ,replace(replace(t1.on_acct_acct_num,chr(13),''),chr(10),'')  -- 挂账账号
    ,replace(replace(t1.on_acct_acct_name,chr(13),''),chr(10),'')  -- 挂账账户名称
    ,t1.matn_enter_acct_dt  -- 维护入账日期
    ,replace(replace(t1.matn_enter_acct_teller_id,chr(13),''),chr(10),'')  -- 维护入账柜员编号
    ,replace(replace(t1.matn_enter_acct_org_id,chr(13),''),chr(10),'')  -- 维护入账机构编号
    ,replace(replace(t1.matn_enter_acct_num,chr(13),''),chr(10),'')  -- 维护入账账号
    ,replace(replace(t1.matn_enter_name,chr(13),''),chr(10),'')  -- 维护入账账户名称
    ,replace(replace(t1.revs_teller_id,chr(13),''),chr(10),'')  -- 冲正柜员编号
    ,replace(replace(t1.revs_tran_flow_num,chr(13),''),chr(10),'')  -- 冲正交易流水号
    ,t1.revs_dt  -- 冲正日期
    ,replace(replace(t1.intnal_acct_flg,chr(13),''),chr(10),'')  -- 内部账标志
    ,replace(replace(t1.actl_deduct_acct_num,chr(13),''),chr(10),'')  -- 实际扣账账号
    ,replace(replace(t1.actl_deduct_acct_name,chr(13),''),chr(10),'')  -- 实际扣账账户名称
    ,replace(replace(t1.e_acct_flg,chr(13),''),chr(10),'')  -- 电子账户标志
    ,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'')  -- 账户类型代码
    ,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'')  -- 全局流水号
    ,replace(replace(t1.unify_pay_chn_flow_num,chr(13),''),chr(10),'')  -- 统一支付渠道流水号
    ,replace(replace(t1.happ_od_flg,chr(13),''),chr(10),'')  -- 发生透支标志
    ,t1.od_amt  -- 透支金额
    ,replace(replace(t1.lmt_order_no,chr(13),''),chr(10),'')  -- 限额订单号
    ,replace(replace(t1.e_acct_prod_acct_num,chr(13),''),chr(10),'')  -- 电子账户产品账号
    ,replace(replace(t1.e_acct_entry_memo,chr(13),''),chr(10),'')  -- 电子账户记账摘要
    ,replace(replace(t1.pay_check_midgrod_flow_num,chr(13),''),chr(10),'')  -- 支付对账中台流水号
    ,t1.pay_check_midgrod_tran_dt  -- 支付对账中台交易日期
    ,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'')  -- 交易类型代码
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.evt_cbps_tran_flow t1    --城银清算交易流水
where t1.midgrod_tran_dt >= to_date('${batch_date}','yyyymmdd') - 14 and t1.midgrod_tran_dt <= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_evt_cbps_tran_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);