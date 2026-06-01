/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl evt_scps_city_wide_bill_tx_bus_flow
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,evt_id  -- 事件编号
    ,lp_id  -- 法人编号
    ,ser_num  -- 序列号
    ,proc_id  -- 受理编号
    ,root_proc_id  -- 根受理编号
    ,flow_num  -- 流水号
    ,upper_tran_amt  -- 大写交易金额
    ,lower_tran_amt  -- 小写交易金额
    ,tran_org_id  -- 交易机构编号
    ,city_wide_bill_tran_status_cd  -- 同城票据交易状态代码
    ,tran_status_descb  -- 交易状态描述
    ,memo_code  -- 摘要码
    ,tran_dt  -- 交易日期
    ,tran_tm  -- 交易时间
    ,batch_proc_sync_proc_center_flg  -- 批量处理同步受理中心标志
    ,batch_tot  -- 批量总笔数
    ,splt_cnt  -- 拆分笔数
    ,teller_id  -- 柜员编号
    ,auth_teller_id  -- 授权柜员编号
    ,entry_msg_flow_num  -- 记账报文流水号
    ,entry_core_tran_flow_num  -- 记账核心交易流水号
    ,entry_core_tran_dt  -- 记账核心交易日期
    ,entry_status_cd  -- 记账状态代码
    ,entry_org_id  -- 记账机构编号
    ,city_wide_bill_tx_bus_cd  -- 同城票交业务代码
    ,city_wide_bill_tx_bus_kind_cd  -- 同城票交业务种类代码
    ,bus_attr_cd  -- 业务属性代码
    ,exch_chn_cd  -- 交换渠道代码
    ,exch_num_site  -- 交换场次
    ,exch_bank_no  -- 交换行号
    ,exch_dt  -- 交换日期
    ,bus_submit_status_cd  -- 业务提交状态代码
    ,vouch_kind_cd  -- 凭证种类代码
    ,vouch_id  -- 凭证编号
    ,cust_id  -- 客户编号
    ,cust_name  -- 客户名称
    ,curr_cd  -- 币种代码
    ,payer_name  -- 付款人名称
    ,payer_acct_id  -- 付款人账户编号
    ,payer_addr_desc  -- 付款人地址描述
    ,pay_bank_bank_no  -- 付款行行号
    ,pay_bank_name  -- 付款行名称
    ,intnal_acct_flg  -- 内部账户标志
    ,recver_name  -- 收款人名称
    ,recver_acct_id  -- 收款人账户编号
    ,recver_addr_desc  -- 收款人地址描述
    ,recvbl_bank_no  -- 收款行行号
    ,recv_bank_name  -- 收款行名称
    ,pay_msg_flow_num  -- 支付报文流水号
    ,pay_msg_tran_dt  -- 支付报文交易日期
    ,pay_host_flow_num  -- 支付主机流水号
    ,pay_host_tran_dt  -- 支付主机交易日期
    ,pay_bus_seq_num  -- 支付业务序号
    ,recver_info_rest_descb  -- 收款人信息处理结果描述
    ,recver_info_proc_tm  -- 收款人信息处理时间
    ,recver_info_proc_status_cd  -- 收款人信息处理状态代码
    ,bill_cnt  -- 票据张数
    ,endors_number  -- 背书人数
    ,endors_lt_descb  -- 背书清单描述
    ,draw_dt  -- 出票日期
    ,tax_bill_flg  -- 税票标志
    ,auto_seal_batch_id  -- 自动验印批次编号
    ,present_cfm_batch_id  -- 提出确认批次编号
    ,clear_num_site  -- 清算场次
    ,clear_dt  -- 清算日期
    ,city_wide_in_main_tran_flow_num  -- 同城提入主交易流水号
    ,main_acct_que_info_desc  -- 主账户查询信息描述
    ,acct_num_open_acct_org_id  -- 账号开户机构编号
    ,city_wide_bill_tx_acct_status_cd  -- 同城票交账户状态代码
    ,acct_num_bal_status_cd  -- 账号余额状态代码
    ,debit_crdt_flg  -- 借贷标志
    ,rela_flow_num  -- 关联流水号
    ,enter_acct_flg  -- 入账标志
    ,inacct_entry_status_cd  -- 收妥入账记账状态代码
    ,inacct_bus_submit_status_cd  -- 收妥入账业务提交状态代码
    ,inacct_entry_msg_flow_num  -- 收妥入账记账报文流水号
    ,inacct_entry_core_tran_flow  -- 收妥入账记账核心交易流水号
    ,inacct_entry_core_tran_dt  -- 收妥入账记账核心交易日期
    ,inacct_entry_teller_id  -- 收妥入账记账柜员编号
    ,inacct_auth_teller_id  -- 收妥入账授权柜员编号
    ,inacct_tm  -- 收妥入账时间
    ,agent_pay_bank_num  -- 代理付款行号
    ,revs_teller_id  -- 冲正柜员编号
    ,revs_auth_teller_id  -- 冲正授权柜员编号
    ,revs_submit_status_cd  -- 冲正提交状态代码
    ,revs_msg_flow_num  -- 冲正报文流水号
    ,revs_core_tran_flow_num  -- 冲正核心交易流水号
    ,revs_core_tran_dt  -- 冲正核心交易日期
    ,revs_tm  -- 冲正时间
    ,revs_rs_descb  -- 冲正原因描述
    ,present_cfm_oper_teller_id  -- 提出确认操作柜员编号
    ,present_cfm_auth_teller_id  -- 提出确认授权柜员编号
    ,present_cfm_tm  -- 提出确认时间
    ,check_teller_id  -- 复核柜员编号
    ,check_tm  -- 复核时间
    ,post_enter_acct_teller_id  -- 暂缓入账柜员编号
    ,post_enter_acct_auth_teller_id  -- 暂缓入账授权柜员编号
    ,post_enter_acct_tm  -- 暂缓入账时间
    ,cancel_post_enter_acct_teller_id  -- 取消暂缓入账柜员编号
    ,cancel_post_enter_acct_auth_teller_id  -- 取消暂缓入账授权柜员编号
    ,cancel_post_enter_acct_tm  -- 取消暂缓入账时间
    ,micr  -- 磁码交易码
    ,init_batch_proc_id  -- 原批量受理编号
    ,init_batch_flow_num  -- 原批量流水号
    ,in_seq_num  -- 提入序号
    ,in_bk_bank_no  -- 提入行行号
    ,in_bank_name  -- 提入行名称
    ,in_bus_init_way_cd  -- 提入业务发起方式代码
    ,in_bk_num_site_attr_cd  -- 提入行场次属性代码
    ,present_bk_bank_no  -- 提出行行号
    ,present_bank_name  -- 提出行名称
    ,paper_bill_bus_flg  -- 纸质票据业务标志
    ,on_acct_proc_id  -- 挂账受理编号
    ,obank_disho_bill_acct_proc_way_cd  -- 他行退票账务处理方式代码
    ,disho_bill_type_cd  -- 退票类型代码
    ,disho_bill_reason_descb  -- 退票理由描述
    ,disho_bill_reason  -- 退票理由
    ,senti_acct_flg  -- 敏感账户标志
    ,trigger_od_bus_flg  -- 触发透支业务标志
    ,od_amt  -- 透支金额
    ,espec_submit_flg  -- 特殊提交标志
    ,postsc  -- 附言
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- ETL处理日期
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id  -- 事件编号
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id  -- 法人编号
    ,replace(replace(t.ser_num,chr(13),''),chr(10),'') as ser_num  -- 序列号
    ,replace(replace(t.proc_id,chr(13),''),chr(10),'') as proc_id  -- 受理编号
    ,replace(replace(t.root_proc_id,chr(13),''),chr(10),'') as root_proc_id  -- 根受理编号
    ,replace(replace(t.flow_num,chr(13),''),chr(10),'') as flow_num  -- 流水号
    ,replace(replace(t.upper_tran_amt,chr(13),''),chr(10),'') as upper_tran_amt  -- 大写交易金额
    ,t.lower_tran_amt as lower_tran_amt  -- 小写交易金额
    ,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id  -- 交易机构编号
    ,replace(replace(t.city_wide_bill_tran_status_cd,chr(13),''),chr(10),'') as city_wide_bill_tran_status_cd  -- 同城票据交易状态代码
    ,replace(replace(t.tran_status_descb,chr(13),''),chr(10),'') as tran_status_descb  -- 交易状态描述
    ,replace(replace(t.memo_code,chr(13),''),chr(10),'') as memo_code  -- 摘要码
    ,t.tran_dt as tran_dt  -- 交易日期
    ,t.tran_tm as tran_tm  -- 交易时间
    ,replace(replace(t.batch_proc_sync_proc_center_flg,chr(13),''),chr(10),'') as batch_proc_sync_proc_center_flg  -- 批量处理同步受理中心标志
    ,t.batch_tot as batch_tot  -- 批量总笔数
    ,t.splt_cnt as splt_cnt  -- 拆分笔数
    ,replace(replace(t.teller_id,chr(13),''),chr(10),'') as teller_id  -- 柜员编号
    ,replace(replace(t.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id  -- 授权柜员编号
    ,replace(replace(t.entry_msg_flow_num,chr(13),''),chr(10),'') as entry_msg_flow_num  -- 记账报文流水号
    ,replace(replace(t.entry_core_tran_flow_num,chr(13),''),chr(10),'') as entry_core_tran_flow_num  -- 记账核心交易流水号
    ,t.entry_core_tran_dt as entry_core_tran_dt  -- 记账核心交易日期
    ,replace(replace(t.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd  -- 记账状态代码
    ,replace(replace(t.entry_org_id,chr(13),''),chr(10),'') as entry_org_id  -- 记账机构编号
    ,replace(replace(t.city_wide_bill_tx_bus_cd,chr(13),''),chr(10),'') as city_wide_bill_tx_bus_cd  -- 同城票交业务代码
    ,replace(replace(t.city_wide_bill_tx_bus_kind_cd,chr(13),''),chr(10),'') as city_wide_bill_tx_bus_kind_cd  -- 同城票交业务种类代码
    ,replace(replace(t.bus_attr_cd,chr(13),''),chr(10),'') as bus_attr_cd  -- 业务属性代码
    ,replace(replace(t.exch_chn_cd,chr(13),''),chr(10),'') as exch_chn_cd  -- 交换渠道代码
    ,t.exch_num_site as exch_num_site  -- 交换场次
    ,replace(replace(t.exch_bank_no,chr(13),''),chr(10),'') as exch_bank_no  -- 交换行号
    ,t.exch_dt as exch_dt  -- 交换日期
    ,replace(replace(t.bus_submit_status_cd,chr(13),''),chr(10),'') as bus_submit_status_cd  -- 业务提交状态代码
    ,replace(replace(t.vouch_kind_cd,chr(13),''),chr(10),'') as vouch_kind_cd  -- 凭证种类代码
    ,replace(replace(t.vouch_id,chr(13),''),chr(10),'') as vouch_id  -- 凭证编号
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id  -- 客户编号
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name  -- 客户名称
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd  -- 币种代码
    ,replace(replace(t.payer_name,chr(13),''),chr(10),'') as payer_name  -- 付款人名称
    ,replace(replace(t.payer_acct_id,chr(13),''),chr(10),'') as payer_acct_id  -- 付款人账户编号
    ,replace(replace(t.payer_addr_desc,chr(13),''),chr(10),'') as payer_addr_desc  -- 付款人地址描述
    ,replace(replace(t.pay_bank_bank_no,chr(13),''),chr(10),'') as pay_bank_bank_no  -- 付款行行号
    ,replace(replace(t.pay_bank_name,chr(13),''),chr(10),'') as pay_bank_name  -- 付款行名称
    ,replace(replace(t.intnal_acct_flg,chr(13),''),chr(10),'') as intnal_acct_flg  -- 内部账户标志
    ,replace(replace(t.recver_name,chr(13),''),chr(10),'') as recver_name  -- 收款人名称
    ,replace(replace(t.recver_acct_id,chr(13),''),chr(10),'') as recver_acct_id  -- 收款人账户编号
    ,replace(replace(t.recver_addr_desc,chr(13),''),chr(10),'') as recver_addr_desc  -- 收款人地址描述
    ,replace(replace(t.recvbl_bank_no,chr(13),''),chr(10),'') as recvbl_bank_no  -- 收款行行号
    ,replace(replace(t.recv_bank_name,chr(13),''),chr(10),'') as recv_bank_name  -- 收款行名称
    ,replace(replace(t.pay_msg_flow_num,chr(13),''),chr(10),'') as pay_msg_flow_num  -- 支付报文流水号
    ,t.pay_msg_tran_dt as pay_msg_tran_dt  -- 支付报文交易日期
    ,replace(replace(t.pay_host_flow_num,chr(13),''),chr(10),'') as pay_host_flow_num  -- 支付主机流水号
    ,t.pay_host_tran_dt as pay_host_tran_dt  -- 支付主机交易日期
    ,replace(replace(t.pay_bus_seq_num,chr(13),''),chr(10),'') as pay_bus_seq_num  -- 支付业务序号
    ,replace(replace(t.recver_info_rest_descb,chr(13),''),chr(10),'') as recver_info_rest_descb  -- 收款人信息处理结果描述
    ,t.recver_info_proc_tm as recver_info_proc_tm  -- 收款人信息处理时间
    ,replace(replace(t.recver_info_proc_status_cd,chr(13),''),chr(10),'') as recver_info_proc_status_cd  -- 收款人信息处理状态代码
    ,t.bill_cnt as bill_cnt  -- 票据张数
    ,t.endors_number as endors_number  -- 背书人数
    ,replace(replace(t.endors_lt_descb,chr(13),''),chr(10),'') as endors_lt_descb  -- 背书清单描述
    ,t.draw_dt as draw_dt  -- 出票日期
    ,replace(replace(t.tax_bill_flg,chr(13),''),chr(10),'') as tax_bill_flg  -- 税票标志
    ,replace(replace(t.auto_seal_batch_id,chr(13),''),chr(10),'') as auto_seal_batch_id  -- 自动验印批次编号
    ,replace(replace(t.present_cfm_batch_id,chr(13),''),chr(10),'') as present_cfm_batch_id  -- 提出确认批次编号
    ,t.clear_num_site as clear_num_site  -- 清算场次
    ,t.clear_dt as clear_dt  -- 清算日期
    ,replace(replace(t.city_wide_in_main_tran_flow_num,chr(13),''),chr(10),'') as city_wide_in_main_tran_flow_num  -- 同城提入主交易流水号
    ,replace(replace(t.main_acct_que_info_desc,chr(13),''),chr(10),'') as main_acct_que_info_desc  -- 主账户查询信息描述
    ,replace(replace(t.acct_num_open_acct_org_id,chr(13),''),chr(10),'') as acct_num_open_acct_org_id  -- 账号开户机构编号
    ,replace(replace(t.city_wide_bill_tx_acct_status_cd,chr(13),''),chr(10),'') as city_wide_bill_tx_acct_status_cd  -- 同城票交账户状态代码
    ,replace(replace(t.acct_num_bal_status_cd,chr(13),''),chr(10),'') as acct_num_bal_status_cd  -- 账号余额状态代码
    ,replace(replace(t.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg  -- 借贷标志
    ,replace(replace(t.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num  -- 关联流水号
    ,replace(replace(t.enter_acct_flg,chr(13),''),chr(10),'') as enter_acct_flg  -- 入账标志
    ,replace(replace(t.inacct_entry_status_cd,chr(13),''),chr(10),'') as inacct_entry_status_cd  -- 收妥入账记账状态代码
    ,replace(replace(t.inacct_bus_submit_status_cd,chr(13),''),chr(10),'') as inacct_bus_submit_status_cd  -- 收妥入账业务提交状态代码
    ,replace(replace(t.inacct_entry_msg_flow_num,chr(13),''),chr(10),'') as inacct_entry_msg_flow_num  -- 收妥入账记账报文流水号
    ,replace(replace(t.inacct_entry_core_tran_flow,chr(13),''),chr(10),'') as inacct_entry_core_tran_flow  -- 收妥入账记账核心交易流水号
    ,t.inacct_entry_core_tran_dt as inacct_entry_core_tran_dt  -- 收妥入账记账核心交易日期
    ,replace(replace(t.inacct_entry_teller_id,chr(13),''),chr(10),'') as inacct_entry_teller_id  -- 收妥入账记账柜员编号
    ,replace(replace(t.inacct_auth_teller_id,chr(13),''),chr(10),'') as inacct_auth_teller_id  -- 收妥入账授权柜员编号
    ,t.inacct_tm as inacct_tm  -- 收妥入账时间
    ,replace(replace(t.agent_pay_bank_num,chr(13),''),chr(10),'') as agent_pay_bank_num  -- 代理付款行号
    ,replace(replace(t.revs_teller_id,chr(13),''),chr(10),'') as revs_teller_id  -- 冲正柜员编号
    ,replace(replace(t.revs_auth_teller_id,chr(13),''),chr(10),'') as revs_auth_teller_id  -- 冲正授权柜员编号
    ,replace(replace(t.revs_submit_status_cd,chr(13),''),chr(10),'') as revs_submit_status_cd  -- 冲正提交状态代码
    ,replace(replace(t.revs_msg_flow_num,chr(13),''),chr(10),'') as revs_msg_flow_num  -- 冲正报文流水号
    ,replace(replace(t.revs_core_tran_flow_num,chr(13),''),chr(10),'') as revs_core_tran_flow_num  -- 冲正核心交易流水号
    ,t.revs_core_tran_dt as revs_core_tran_dt  -- 冲正核心交易日期
    ,t.revs_tm as revs_tm  -- 冲正时间
    ,replace(replace(t.revs_rs_descb,chr(13),''),chr(10),'') as revs_rs_descb  -- 冲正原因描述
    ,replace(replace(t.present_cfm_oper_teller_id,chr(13),''),chr(10),'') as present_cfm_oper_teller_id  -- 提出确认操作柜员编号
    ,replace(replace(t.present_cfm_auth_teller_id,chr(13),''),chr(10),'') as present_cfm_auth_teller_id  -- 提出确认授权柜员编号
    ,t.present_cfm_tm as present_cfm_tm  -- 提出确认时间
    ,replace(replace(t.check_teller_id,chr(13),''),chr(10),'') as check_teller_id  -- 复核柜员编号
    ,t.check_tm as check_tm  -- 复核时间
    ,replace(replace(t.post_enter_acct_teller_id,chr(13),''),chr(10),'') as post_enter_acct_teller_id  -- 暂缓入账柜员编号
    ,replace(replace(t.post_enter_acct_auth_teller_id,chr(13),''),chr(10),'') as post_enter_acct_auth_teller_id  -- 暂缓入账授权柜员编号
    ,t.post_enter_acct_tm as post_enter_acct_tm  -- 暂缓入账时间
    ,replace(replace(t.cancel_post_enter_acct_teller_id,chr(13),''),chr(10),'') as cancel_post_enter_acct_teller_id  -- 取消暂缓入账柜员编号
    ,replace(replace(t.cancel_post_enter_acct_auth_teller_id,chr(13),''),chr(10),'') as cancel_post_enter_acct_auth_teller_id  -- 取消暂缓入账授权柜员编号
    ,t.cancel_post_enter_acct_tm as cancel_post_enter_acct_tm  -- 取消暂缓入账时间
    ,replace(replace(t.micr,chr(13),''),chr(10),'') as micr  -- 磁码交易码
    ,replace(replace(t.init_batch_proc_id,chr(13),''),chr(10),'') as init_batch_proc_id  -- 原批量受理编号
    ,replace(replace(t.init_batch_flow_num,chr(13),''),chr(10),'') as init_batch_flow_num  -- 原批量流水号
    ,t.in_seq_num as in_seq_num  -- 提入序号
    ,replace(replace(t.in_bk_bank_no,chr(13),''),chr(10),'') as in_bk_bank_no  -- 提入行行号
    ,replace(replace(t.in_bank_name,chr(13),''),chr(10),'') as in_bank_name  -- 提入行名称
    ,replace(replace(t.in_bus_init_way_cd,chr(13),''),chr(10),'') as in_bus_init_way_cd  -- 提入业务发起方式代码
    ,replace(replace(t.in_bk_num_site_attr_cd,chr(13),''),chr(10),'') as in_bk_num_site_attr_cd  -- 提入行场次属性代码
    ,replace(replace(t.present_bk_bank_no,chr(13),''),chr(10),'') as present_bk_bank_no  -- 提出行行号
    ,replace(replace(t.present_bank_name,chr(13),''),chr(10),'') as present_bank_name  -- 提出行名称
    ,replace(replace(t.paper_bill_bus_flg,chr(13),''),chr(10),'') as paper_bill_bus_flg  -- 纸质票据业务标志
    ,replace(replace(t.on_acct_proc_id,chr(13),''),chr(10),'') as on_acct_proc_id  -- 挂账受理编号
    ,replace(replace(t.obank_disho_bill_acct_proc_way_cd,chr(13),''),chr(10),'') as obank_disho_bill_acct_proc_way_cd  -- 他行退票账务处理方式代码
    ,replace(replace(t.disho_bill_type_cd,chr(13),''),chr(10),'') as disho_bill_type_cd  -- 退票类型代码
    ,replace(replace(t.disho_bill_reason_descb,chr(13),''),chr(10),'') as disho_bill_reason_descb  -- 退票理由描述
    ,replace(replace(t.disho_bill_reason,chr(13),''),chr(10),'') as disho_bill_reason  -- 退票理由
    ,replace(replace(t.senti_acct_flg,chr(13),''),chr(10),'') as senti_acct_flg  -- 敏感账户标志
    ,replace(replace(t.trigger_od_bus_flg,chr(13),''),chr(10),'') as trigger_od_bus_flg  -- 触发透支业务标志
    ,t.od_amt as od_amt  -- 透支金额
    ,replace(replace(t.espec_submit_flg,chr(13),''),chr(10),'') as espec_submit_flg  -- 特殊提交标志
    ,replace(replace(t.postsc,chr(13),''),chr(10),'') as postsc  -- 附言
    ,replace(replace(t.job_cd,chr(13),''),chr(10),'') as job_cd  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 时间戳
 from ${iml_schema}.evt_scps_city_wide_bill_tx_bus_flow t--后援中心同城票交业务流水
where t.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;

-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'evt_scps_city_wide_bill_tx_bus_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);