/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_cmm_pbc_pass_tran_flow
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,pay_decl_form_id -- 支付报单编号
    ,tran_dt -- 交易日期
    ,out_line_pay_tran_seq_num -- 行外支付交易序号
    ,bank_int_bus_seq_num -- 行内业务序号
    ,bus_origi_bank_no -- 业务发起行行号
    ,msg_type_id -- 报文类型编号
    ,scd_gener_msg_type_id -- 二代报文类型编号
    ,host_flow_num -- 主机流水号
    ,tran_flow_num -- 交易流水号
    ,send_tran_flow_num -- 发送交易流水号
    ,ova_flow_num -- 全局流水号
    ,host_tran_code -- 主机交易码
    ,midgrod_tran_code -- 中台交易码
    ,curr_cd -- 币种代码
    ,prod_cd -- 产品代码
    ,bus_kind_cd -- 业务种类代码
    ,bus_type_cd -- 业务类型代码
    ,proc_status_cd -- 处理状态代码
    ,npc_proc_cd -- NPC处理代码
    ,check_entry_status_cd -- 对账状态代码
    ,debit_crdt_cd -- 借贷代码
    ,entry_code -- 记账分录编码
    ,acct_gen_cd -- 账户大类型代码
    ,acct_type_cd -- 账户类型代码
    ,e_acct_cd -- 电子账户代码
    ,rec_status_cd -- 记录状态代码
    ,mode_pay_cd -- 支付方式代码
    ,exch_bus_tran_chn_cd -- 汇兑业务交易渠道代码
    ,ground_proc_status_cd -- 落地处理状态代码
    ,verify_proc_status_cd -- 查证处理状态代码
    ,nostro_flg -- 往来账标志
    ,charge_flg -- 收费标志
    ,agent_flg -- 代理标志
    ,intnal_acct_flg -- 内部账标志
    ,entr_dt -- 委托日期
    ,host_dt -- 主机日期
    ,clear_dt -- 清算日期
    ,check_entry_dt -- 对账日期
    ,modif_dt -- 修改日期
    ,modif_tm -- 修改时间
    ,init_entr_dt -- 原委托日期
    ,init_pay_tran_seq_num -- 原支付交易序号
    ,tran_amt -- 交易金额
    ,comm_fee_amt -- 手续费用金额
    ,remit_tran_fee_amt -- 汇划费用金额
    ,todos -- 工本费
    ,payer_open_bank_no -- 付款人开户行行号
    ,payer_open_bank_name -- 付款人开户行名称
    ,payer_acct_num -- 付款人账号
    ,payer_name -- 付款人名称
    ,payer_addr -- 付款人地址
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,recver_acct_num -- 收款人账号
    ,recver_name -- 收款人名称
    ,recver_addr -- 收款人地址
    ,err_return_code -- 错误返回编码
    ,err_info -- 错误信息
    ,prior_level -- 优先级别
    ,input_teller_id -- 录入柜员编号
    ,check_teller_id -- 复核柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,input_check_teller_dept_id -- 录入复核柜员部门编号
    ,auth_teller_dept_id -- 授权柜员部门编号
    ,reg_main_acct_num -- 挂账或维护入账账号
    ,reg_main_name -- 挂账或维护入账姓名
    ,matn_enter_acct_dt -- 维护入账日期
    ,matn_enter_acct_teller_id -- 维护入账柜员编号
    ,matn_enter_acct_dept_id -- 维护入账部门编号
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_dt -- 凭证日期
    ,vouch_no -- 凭证号码
    ,cert_kind_cd -- 证件种类代码
    ,cert_no -- 证件号码
    ,actl_deduct_acct_num -- 实际扣账账号
    ,actl_deduct_acct_name -- 实际扣账户名称
    ,rgst_addit_data_tab_name -- 登记附加数据表名称
    ,on_acct_rs_cd -- 挂账原因代码
    ,auto_refund_flg -- 自动退汇标志
    ,auto_refund_cnt -- 自动退汇次数
    ,vtual_bind_acct -- 虚户绑定账户
    ,vtual_bind_acct_name -- 虚户绑定账户名称
    ,vtual_open_acct_org_id -- 虚户绑定账户开户机构编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(evt_id), ' ') as evt_id -- 事件编号
    ,nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(trim(pay_decl_form_id), ' ') as pay_decl_form_id -- 支付报单编号
    ,nvl(tran_dt, to_date('00010101', 'yyyymmdd')) as tran_dt -- 交易日期
    ,nvl(trim(out_line_pay_tran_seq_num), ' ') as out_line_pay_tran_seq_num -- 行外支付交易序号
    ,nvl(trim(bank_int_bus_seq_num), ' ') as bank_int_bus_seq_num -- 行内业务序号
    ,nvl(trim(bus_origi_bank_no), ' ') as bus_origi_bank_no -- 业务发起行行号
    ,nvl(trim(msg_type_id), ' ') as msg_type_id -- 报文类型编号
    ,nvl(trim(scd_gener_msg_type_id), ' ') as scd_gener_msg_type_id -- 二代报文类型编号
    ,nvl(trim(host_flow_num), ' ') as host_flow_num -- 主机流水号
    ,nvl(trim(tran_flow_num), ' ') as tran_flow_num -- 交易流水号
    ,nvl(trim(send_tran_flow_num), ' ') as send_tran_flow_num -- 发送交易流水号
    ,nvl(trim(ova_flow_num), ' ') as ova_flow_num -- 全局流水号
    ,nvl(trim(host_tran_code), ' ') as host_tran_code -- 主机交易码
    ,nvl(trim(midgrod_tran_code), ' ') as midgrod_tran_code -- 中台交易码
    ,nvl(trim(curr_cd), ' ') as curr_cd -- 币种代码
    ,nvl(trim(prod_cd), ' ') as prod_cd -- 产品代码
    ,nvl(trim(bus_kind_cd), ' ') as bus_kind_cd -- 业务种类代码
    ,nvl(trim(bus_type_cd), ' ') as bus_type_cd -- 业务类型代码
    ,nvl(trim(proc_status_cd), ' ') as proc_status_cd -- 处理状态代码
    ,nvl(trim(npc_proc_cd), ' ') as npc_proc_cd -- NPC处理代码
    ,nvl(trim(check_entry_status_cd), ' ') as check_entry_status_cd -- 对账状态代码
    ,nvl(trim(debit_crdt_cd), ' ') as debit_crdt_cd -- 借贷代码
    ,nvl(trim(entry_code), ' ') as entry_code -- 记账分录编码
    ,nvl(trim(acct_gen_cd), ' ') as acct_gen_cd -- 账户大类型代码
    ,nvl(trim(acct_type_cd), ' ') as acct_type_cd -- 账户类型代码
    ,nvl(trim(e_acct_cd), ' ') as e_acct_cd -- 电子账户代码
    ,nvl(trim(rec_status_cd), ' ') as rec_status_cd -- 记录状态代码
    ,nvl(trim(mode_pay_cd), ' ') as mode_pay_cd -- 支付方式代码
    ,nvl(trim(exch_bus_tran_chn_cd), ' ') as exch_bus_tran_chn_cd -- 汇兑业务交易渠道代码
    ,nvl(trim(ground_proc_status_cd), ' ') as ground_proc_status_cd -- 落地处理状态代码
    ,nvl(trim(verify_proc_status_cd), ' ') as verify_proc_status_cd -- 查证处理状态代码
    ,nvl(trim(nostro_flg), ' ') as nostro_flg -- 往来账标志
    ,nvl(trim(charge_flg), ' ') as charge_flg -- 收费标志
    ,nvl(trim(agent_flg), ' ') as agent_flg -- 代理标志
    ,nvl(trim(intnal_acct_flg), ' ') as intnal_acct_flg -- 内部账标志
    ,nvl(entr_dt, to_date('00010101', 'yyyymmdd')) as entr_dt -- 委托日期
    ,nvl(host_dt, to_date('00010101', 'yyyymmdd')) as host_dt -- 主机日期
    ,nvl(clear_dt, to_date('00010101', 'yyyymmdd')) as clear_dt -- 清算日期
    ,nvl(check_entry_dt, to_date('00010101', 'yyyymmdd')) as check_entry_dt -- 对账日期
    ,nvl(modif_dt, to_date('00010101', 'yyyymmdd')) as modif_dt -- 修改日期
    ,nvl(modif_tm, to_timestamp('00010101', 'yyyymmdd')) as modif_tm -- 修改时间
    ,nvl(init_entr_dt, to_date('00010101', 'yyyymmdd')) as init_entr_dt -- 原委托日期
    ,nvl(trim(init_pay_tran_seq_num), ' ') as init_pay_tran_seq_num -- 原支付交易序号
    ,nvl(trim(tran_amt), 0) as tran_amt -- 交易金额
    ,nvl(trim(comm_fee_amt), 0) as comm_fee_amt -- 手续费用金额
    ,nvl(trim(remit_tran_fee_amt), 0) as remit_tran_fee_amt -- 汇划费用金额
    ,nvl(trim(todos), 0) as todos -- 工本费
    ,nvl(trim(payer_open_bank_no), ' ') as payer_open_bank_no -- 付款人开户行行号
    ,nvl(trim(payer_open_bank_name), ' ') as payer_open_bank_name -- 付款人开户行名称
    ,nvl(trim(payer_acct_num), ' ') as payer_acct_num -- 付款人账号
    ,nvl(trim(payer_name), ' ') as payer_name -- 付款人名称
    ,nvl(trim(payer_addr), ' ') as payer_addr -- 付款人地址
    ,nvl(trim(recver_open_bank_no), ' ') as recver_open_bank_no -- 收款人开户行行号
    ,nvl(trim(recver_open_bank_name), ' ') as recver_open_bank_name -- 收款人开户行名称
    ,nvl(trim(recver_acct_num), ' ') as recver_acct_num -- 收款人账号
    ,nvl(trim(recver_name), ' ') as recver_name -- 收款人名称
    ,nvl(trim(recver_addr), ' ') as recver_addr -- 收款人地址
    ,nvl(trim(err_return_code), ' ') as err_return_code -- 错误返回编码
    ,nvl(trim(err_info), ' ') as err_info -- 错误信息
    ,nvl(trim(prior_level), ' ') as prior_level -- 优先级别
    ,nvl(trim(input_teller_id), ' ') as input_teller_id -- 录入柜员编号
    ,nvl(trim(check_teller_id), ' ') as check_teller_id -- 复核柜员编号
    ,nvl(trim(auth_teller_id), ' ') as auth_teller_id -- 授权柜员编号
    ,nvl(trim(input_check_teller_dept_id), ' ') as input_check_teller_dept_id -- 录入复核柜员部门编号
    ,nvl(trim(auth_teller_dept_id), ' ') as auth_teller_dept_id -- 授权柜员部门编号
    ,nvl(trim(reg_main_acct_num), ' ') as reg_main_acct_num -- 挂账或维护入账账号
    ,nvl(trim(reg_main_name), ' ') as reg_main_name -- 挂账或维护入账姓名
    ,nvl(matn_enter_acct_dt, to_date('00010101', 'yyyymmdd')) as matn_enter_acct_dt -- 维护入账日期
    ,nvl(trim(matn_enter_acct_teller_id), ' ') as matn_enter_acct_teller_id -- 维护入账柜员编号
    ,nvl(trim(matn_enter_acct_dept_id), ' ') as matn_enter_acct_dept_id -- 维护入账部门编号
    ,nvl(trim(vouch_type_cd), ' ') as vouch_type_cd -- 凭证类型代码
    ,nvl(vouch_dt, to_date('00010101', 'yyyymmdd')) as vouch_dt -- 凭证日期
    ,nvl(trim(vouch_no), ' ') as vouch_no -- 凭证号码
    ,nvl(trim(cert_kind_cd), ' ') as cert_kind_cd -- 证件种类代码
    ,nvl(trim(cert_no), ' ') as cert_no -- 证件号码
    ,nvl(trim(actl_deduct_acct_num), ' ') as actl_deduct_acct_num -- 实际扣账账号
    ,nvl(trim(actl_deduct_acct_name), ' ') as actl_deduct_acct_name -- 实际扣账户名称
    ,nvl(trim(rgst_addit_data_tab_name), ' ') as rgst_addit_data_tab_name -- 登记附加数据表名称
    ,nvl(trim(on_acct_rs_cd), ' ') as on_acct_rs_cd -- 挂账原因代码
    ,nvl(trim(auto_refund_flg), ' ') as auto_refund_flg -- 自动退汇标志
    ,nvl(trim(auto_refund_cnt), 0) as auto_refund_cnt -- 自动退汇次数
    ,nvl(trim(vtual_bind_acct), ' ') as vtual_bind_acct -- 虚户绑定账户
    ,nvl(trim(vtual_bind_acct_name), ' ') as vtual_bind_acct_name -- 虚户绑定账户名称
    ,nvl(trim(vtual_open_acct_org_id), ' ') as vtual_open_acct_org_id -- 虚户绑定账户开户机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from icl.v_cmm_pbc_pass_tran_flow
where tran_dt <= to_date('${batch_date}','yyyymmdd') and tran_dt >= to_date('${batch_date}','yyyymmdd') - 14
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_cmm_pbc_pass_tran_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);