/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_evt_bigamt_tran_evt
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
--alter table ${idl_schema}.evt_bigamt_tran_evt drop partition p_${last_date};
alter table ${idl_schema}.evt_bigamt_tran_evt drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror continue none;
alter table ${idl_schema}.evt_bigamt_tran_evt add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.evt_bigamt_tran_evt (
    etl_dt  -- 数据日期
    ,evt_id  -- 事件编号
    ,lp_id  -- 法人编号
    ,pay_decl_form_id  -- 支付报单编号
    ,tran_dt  -- 交易日期
    ,curr_cd  -- 币种代码
    ,tran_amt  -- 交易金额
    ,out_line_pay_tran_seq_num  -- 行外支付交易序号
    ,bank_int_bus_seq_num  -- 行内业务序号
    ,msg_type_id  -- 报文类型编号
    ,host_tran_code  -- 主机交易码
    ,midgrod_tran_code  -- 中台交易码
    ,entr_dt  -- 委托日期
    ,host_dt  -- 主机日期
    ,host_flow_num  -- 主机流水号
    ,spec_prmssn_prtcptr_id  -- 特许参与者编号
    ,send_msg_center_cd  -- 发报中心代码
    ,init_clear_bk_no  -- 发起清算行行号
    ,origi_bank_no  -- 发起行行号
    ,payer_open_bank_dept_id  -- 付款人开户行部门编号
    ,payer_open_bank_no  -- 付款人开户行行号
    ,payer_open_bank_name  -- 付款人开户行名称
    ,payer_acct_num  -- 付款人账号
    ,payer_name  -- 付款人名称
    ,payer_addr  -- 付款人地址
    ,recv_msg_center_cd  -- 收报中心代码
    ,recv_clear_bk_no  -- 接收清算行行号
    ,recv_bank_bank_no  -- 接收行行号
    ,recver_open_bank_no  -- 收款人开户行行号
    ,recver_open_bank_name  -- 收款人开户行名称
    ,recver_acct_num  -- 收款人账号
    ,recver_name  -- 收款人名称
    ,recver_addr  -- 收款人地址
    ,bus_kind_cd  -- 业务种类代码
    ,bus_type_cd  -- 业务类型代码
    ,init_entr_dt  -- 原委托日期
    ,init_pay_tran_seq_num  -- 原支付交易序号
    ,init_prtcpt_org_id  -- 原发起参与机构编号
    ,init_msg_type_id  -- 原报文类型编号
    ,proc_status_cd  -- 处理状态代码
    ,pbc_bus_status_cd  -- 人行业务状态代码
    ,npc_proc_cd  -- NPC处理代码
    ,sys_type_cd  -- 系统类型代码
    ,node_type_cd  -- 节点类型代码
    ,npc_rest_cd  -- NPC处理结果代码
    ,check_revs_flow_num  -- 复核冲正流水号
    ,send_revs_flow_num  -- 发送冲正流水号
    ,clear_dt  -- 清算日期
    ,err_return_code  -- 错误返回编码
    ,err_info  -- 错误信息
    ,prior_level  -- 优先级别
    ,input_teller_id  -- 录入柜员编号
    ,check_teller_id  -- 复核柜员编号
    ,auth_teller_id  -- 授权柜员编号
    ,input_check_teller_dept_id  -- 录入复核柜员部门编号
    ,auth_teller_dept_id  -- 授权柜员部门编号
    ,check_entry_status_cd  -- 对账状态代码
    ,print_cnt  -- 打印次数
    ,revid_tm  -- 收到时间
    ,send_tm  -- 发送时间
    ,sugst_pay_dt  -- 提示付款日期
    ,nostro_flg  -- 往来账标志
    ,charge_flg  -- 收费标志
    ,debit_crdt_cd  -- 借贷代码
    ,reg_main_acct_num  -- 挂账或维护入账账号
    ,reg_main_name  -- 挂账或维护入账姓名
    ,matn_enter_acct_dt  -- 维护入账日期
    ,matn_enter_acct_teller_id  -- 维护入账柜员编号
    ,matn_enter_acct_dept_id  -- 维护入账部门编号
    ,clarify_enter_acct_num  -- 清分入账账号
    ,clarify_flow_num  -- 清分流水号
    ,agent_flg  -- 代理标志
    ,jnl_flow_num  -- 日志流水号
    ,send_jnl_flow_num  -- 发送日志流水号
    ,vouch_type_cd  -- 凭证类型代码
    ,vouch_dt  -- 凭证日期
    ,vouch_no  -- 凭证号码
    ,cert_kind_cd  -- 证件种类代码
    ,cert_no  -- 证件号码
    ,tran_lmt  -- 转账限额
    ,tran_flow_num  -- 交易流水号
    ,send_tran_flow_num  -- 发送交易流水号
    ,modif_tm  -- 修改时间
    ,cc_bank_draft_id  -- 城商行汇票编号
    ,rec_update_edit_num  -- 记录更新版本号
    ,rec_status_cd  -- 记录状态代码
    ,mode_pay_cd  -- 支付方式代码
    ,exch_bus_tran_chn_cd  -- 汇兑业务交易渠道代码
    ,modif_dt  -- 修改日期
    ,bus_flow_num  -- 业务流水号
    ,mgmt_org_id  -- 管理机构编号
    ,comm_fee_amt  -- 手续费用金额
    ,remit_tran_fee_amt  -- 汇划费用金额
    ,todos  -- 工本费
    ,mpr_teller_id  -- 维护入账冲账柜员编号
    ,revs_tran_flow_num  -- 冲正交易流水号
    ,revs_tran_dt  -- 冲正交易日期
    ,prod_cd  -- 产品代码
    ,intnal_acct_flg  -- 内部账标志
    ,actl_deduct_acct_num  -- 实际扣账账号
    ,actl_deduct_acct_name  -- 实际扣账户名称
    ,bank_int_sys_edit_num  -- 行内系统版本号
    ,cntpty_sys_edit_num  -- 对手系统版本号
    ,ground_proc_status_cd  -- 落地处理状态代码
    ,verify_proc_status_cd  -- 查证处理状态代码
    ,rgst_addit_data_name  -- 登记附加数据表名称
    ,on_acct_rs_cd  -- 挂账原因代码
    ,scd_gener_msg_type_id  -- 二代报文类型编号
    ,scd_gener_bus_type_cd  -- 二代业务类型代码
    ,scd_gener_bus_kind_cd  -- 二代业务种类代码
    ,charge_way_cd  -- 收费方式代码
    ,e_acct_cd  -- 电子账户代码
    ,chn_flow_num  -- 渠道流水号
    ,next_day_tran_flg  -- 次日转账标志
    ,auto_refund_flg  -- 自动退汇标志
    ,auto_refund_cnt  -- 自动退汇次数
    ,vtual_acct_bind_acct  -- 虚户绑定账户
    ,vtual_acct_bind_acct_name  -- 虚户绑定账户名称
    ,acct_type_cd  -- 账户类型代码
    ,vtual_open_acct_org_id  -- 虚户绑定账户开户机构编号
    ,acct_gen_cd  -- 账户大类型代码
    ,lmt_order_no  -- 限额订单号
    ,ova_flow_num  -- 全局流水号
    ,esb_intfc_return_code  -- ESB接口返回码
    ,esb_intfc_return_info  -- ESB接口返回信息
    ,esb_intfc_tran_flow_num  -- ESB接口交易流水号
    ,send_pbc_tm  -- 发送人行时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(p1.evt_id,chr(13),''),chr(10),'')  -- 事件编号
    ,replace(replace(p1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(p1.pay_decl_form_id,chr(13),''),chr(10),'')  -- 支付报单编号
    ,p1.tran_dt  -- 交易日期
    ,replace(replace(p1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,p1.tran_amt  -- 交易金额
    ,replace(replace(p1.out_line_pay_tran_seq_num,chr(13),''),chr(10),'')  -- 行外支付交易序号
    ,replace(replace(p1.bank_int_bus_seq_num,chr(13),''),chr(10),'')  -- 行内业务序号
    ,replace(replace(p1.msg_type_id,chr(13),''),chr(10),'')  -- 报文类型编号
    ,replace(replace(p1.host_tran_code,chr(13),''),chr(10),'')  -- 主机交易码
    ,replace(replace(p1.midgrod_tran_code,chr(13),''),chr(10),'')  -- 中台交易码
    ,p1.entr_dt  -- 委托日期
    ,p1.host_dt  -- 主机日期
    ,replace(replace(p1.host_flow_num,chr(13),''),chr(10),'')  -- 主机流水号
    ,replace(replace(p1.spec_prmssn_prtcptr_id,chr(13),''),chr(10),'')  -- 特许参与者编号
    ,replace(replace(p1.send_msg_center_cd,chr(13),''),chr(10),'')  -- 发报中心代码
    ,replace(replace(p1.init_clear_bk_no,chr(13),''),chr(10),'')  -- 发起清算行行号
    ,replace(replace(p1.origi_bank_no,chr(13),''),chr(10),'')  -- 发起行行号
    ,replace(replace(p1.payer_open_bank_dept_id,chr(13),''),chr(10),'')  -- 付款人开户行部门编号
    ,replace(replace(p1.payer_open_bank_no,chr(13),''),chr(10),'')  -- 付款人开户行行号
    ,replace(replace(p1.payer_open_bank_name,chr(13),''),chr(10),'')  -- 付款人开户行名称
    ,replace(replace(p1.payer_acct_num,chr(13),''),chr(10),'')  -- 付款人账号
    ,replace(replace(p1.payer_name,chr(13),''),chr(10),'')  -- 付款人名称
    ,replace(replace(p1.payer_addr,chr(13),''),chr(10),'')  -- 付款人地址
    ,replace(replace(p1.recv_msg_center_cd,chr(13),''),chr(10),'')  -- 收报中心代码
    ,replace(replace(p1.recv_clear_bk_no,chr(13),''),chr(10),'')  -- 接收清算行行号
    ,replace(replace(p1.recv_bank_bank_no,chr(13),''),chr(10),'')  -- 接收行行号
    ,replace(replace(p1.recver_open_bank_no,chr(13),''),chr(10),'')  -- 收款人开户行行号
    ,replace(replace(p1.recver_open_bank_name,chr(13),''),chr(10),'')  -- 收款人开户行名称
    ,replace(replace(p1.recver_acct_num,chr(13),''),chr(10),'')  -- 收款人账号
    ,replace(replace(p1.recver_name,chr(13),''),chr(10),'')  -- 收款人名称
    ,replace(replace(p1.recver_addr,chr(13),''),chr(10),'')  -- 收款人地址
    ,replace(replace(p1.bus_kind_cd,chr(13),''),chr(10),'')  -- 业务种类代码
    ,replace(replace(p1.bus_type_cd,chr(13),''),chr(10),'')  -- 业务类型代码
    ,p1.init_entr_dt  -- 原委托日期
    ,replace(replace(p1.init_pay_tran_seq_num,chr(13),''),chr(10),'')  -- 原支付交易序号
    ,replace(replace(p1.init_prtcpt_org_id,chr(13),''),chr(10),'')  -- 原发起参与机构编号
    ,replace(replace(p1.init_msg_type_id,chr(13),''),chr(10),'')  -- 原报文类型编号
    ,replace(replace(p1.proc_status_cd,chr(13),''),chr(10),'')  -- 处理状态代码
    ,replace(replace(p1.pbc_bus_status_cd,chr(13),''),chr(10),'')  -- 人行业务状态代码
    ,replace(replace(p1.npc_proc_cd,chr(13),''),chr(10),'')  -- NPC处理代码
    ,replace(replace(p1.sys_type_cd,chr(13),''),chr(10),'')  -- 系统类型代码
    ,replace(replace(p1.node_type_cd,chr(13),''),chr(10),'')  -- 节点类型代码
    ,replace(replace(p1.npc_rest_cd,chr(13),''),chr(10),'')  -- NPC处理结果代码
    ,replace(replace(p1.check_revs_flow_num,chr(13),''),chr(10),'')  -- 复核冲正流水号
    ,replace(replace(p1.send_revs_flow_num,chr(13),''),chr(10),'')  -- 发送冲正流水号
    ,p1.clear_dt  -- 清算日期
    ,replace(replace(p1.err_return_code,chr(13),''),chr(10),'')  -- 错误返回编码
    ,replace(replace(p1.err_info,chr(13),''),chr(10),'')  -- 错误信息
    ,replace(replace(p1.prior_level,chr(13),''),chr(10),'')  -- 优先级别
    ,replace(replace(p1.input_teller_id,chr(13),''),chr(10),'')  -- 录入柜员编号
    ,replace(replace(p1.check_teller_id,chr(13),''),chr(10),'')  -- 复核柜员编号
    ,replace(replace(p1.auth_teller_id,chr(13),''),chr(10),'')  -- 授权柜员编号
    ,replace(replace(p1.input_check_teller_dept_id,chr(13),''),chr(10),'')  -- 录入复核柜员部门编号
    ,replace(replace(p1.auth_teller_dept_id,chr(13),''),chr(10),'')  -- 授权柜员部门编号
    ,replace(replace(p1.check_entry_status_cd,chr(13),''),chr(10),'')  -- 对账状态代码
    ,p1.print_cnt  -- 打印次数
    ,p1.revid_tm  -- 收到时间
    ,p1.send_tm  -- 发送时间
    ,p1.sugst_pay_dt  -- 提示付款日期
    ,replace(replace(p1.nostro_flg,chr(13),''),chr(10),'')  -- 往来账标志
    ,replace(replace(p1.charge_flg,chr(13),''),chr(10),'')  -- 收费标志
    ,replace(replace(p1.debit_crdt_cd,chr(13),''),chr(10),'')  -- 借贷代码
    ,replace(replace(p1.reg_main_acct_num,chr(13),''),chr(10),'')  -- 挂账或维护入账账号
    ,replace(replace(p1.reg_main_name,chr(13),''),chr(10),'')  -- 挂账或维护入账姓名
    ,p1.matn_enter_acct_dt  -- 维护入账日期
    ,replace(replace(p1.matn_enter_acct_teller_id,chr(13),''),chr(10),'')  -- 维护入账柜员编号
    ,replace(replace(p1.matn_enter_acct_dept_id,chr(13),''),chr(10),'')  -- 维护入账部门编号
    ,replace(replace(p1.clarify_enter_acct_num,chr(13),''),chr(10),'')  -- 清分入账账号
    ,replace(replace(p1.clarify_flow_num,chr(13),''),chr(10),'')  -- 清分流水号
    ,replace(replace(p1.agent_flg,chr(13),''),chr(10),'')  -- 代理标志
    ,replace(replace(p1.jnl_flow_num,chr(13),''),chr(10),'')  -- 日志流水号
    ,replace(replace(p1.send_jnl_flow_num,chr(13),''),chr(10),'')  -- 发送日志流水号
    ,replace(replace(p1.vouch_type_cd,chr(13),''),chr(10),'')  -- 凭证类型代码
    ,p1.vouch_dt  -- 凭证日期
    ,replace(replace(p1.vouch_no,chr(13),''),chr(10),'')  -- 凭证号码
    ,replace(replace(p1.cert_kind_cd,chr(13),''),chr(10),'')  -- 证件种类代码
    ,replace(replace(p1.cert_no,chr(13),''),chr(10),'')  -- 证件号码
    ,p1.tran_lmt  -- 转账限额
    ,replace(replace(p1.tran_flow_num,chr(13),''),chr(10),'')  -- 交易流水号
    ,replace(replace(p1.send_tran_flow_num,chr(13),''),chr(10),'')  -- 发送交易流水号
    ,p1.modif_tm  -- 修改时间
    ,replace(replace(p1.cc_bank_draft_id,chr(13),''),chr(10),'')  -- 城商行汇票编号
    ,replace(replace(p1.rec_update_edit_num,chr(13),''),chr(10),'')  -- 记录更新版本号
    ,replace(replace(p1.rec_status_cd,chr(13),''),chr(10),'')  -- 记录状态代码
    ,replace(replace(p1.mode_pay_cd,chr(13),''),chr(10),'')  -- 支付方式代码
    ,replace(replace(p1.exch_bus_tran_chn_cd,chr(13),''),chr(10),'')  -- 汇兑业务交易渠道代码
    ,p1.modif_dt  -- 修改日期
    ,replace(replace(p1.bus_flow_num,chr(13),''),chr(10),'')  -- 业务流水号
    ,replace(replace(p1.mgmt_org_id,chr(13),''),chr(10),'')  -- 管理机构编号
    ,p1.comm_fee_amt  -- 手续费用金额
    ,p1.remit_tran_fee_amt  -- 汇划费用金额
    ,p1.todos  -- 工本费
    ,replace(replace(p1.mpr_teller_id,chr(13),''),chr(10),'')  -- 维护入账冲账柜员编号
    ,replace(replace(p1.revs_tran_flow_num,chr(13),''),chr(10),'')  -- 冲正交易流水号
    ,p1.revs_tran_dt  -- 冲正交易日期
    ,replace(replace(p1.prod_cd,chr(13),''),chr(10),'')  -- 产品代码
    ,replace(replace(p1.intnal_acct_flg,chr(13),''),chr(10),'')  -- 内部账标志
    ,replace(replace(p1.actl_deduct_acct_num,chr(13),''),chr(10),'')  -- 实际扣账账号
    ,replace(replace(p1.actl_deduct_acct_name,chr(13),''),chr(10),'')  -- 实际扣账户名称
    ,replace(replace(p1.bank_int_sys_edit_num,chr(13),''),chr(10),'')  -- 行内系统版本号
    ,replace(replace(p1.cntpty_sys_edit_num,chr(13),''),chr(10),'')  -- 对手系统版本号
    ,replace(replace(p1.ground_proc_status_cd,chr(13),''),chr(10),'')  -- 落地处理状态代码
    ,replace(replace(p1.verify_proc_status_cd,chr(13),''),chr(10),'')  -- 查证处理状态代码
    ,replace(replace(p1.rgst_addit_data_name,chr(13),''),chr(10),'')  -- 登记附加数据表名称
    ,replace(replace(p1.on_acct_rs_cd,chr(13),''),chr(10),'')  -- 挂账原因代码
    ,replace(replace(p1.scd_gener_msg_type_id,chr(13),''),chr(10),'')  -- 二代报文类型编号
    ,replace(replace(p1.scd_gener_bus_type_cd,chr(13),''),chr(10),'')  -- 二代业务类型代码
    ,replace(replace(p1.scd_gener_bus_kind_cd,chr(13),''),chr(10),'')  -- 二代业务种类代码
    ,replace(replace(p1.charge_way_cd,chr(13),''),chr(10),'')  -- 收费方式代码
    ,replace(replace(p1.e_acct_cd,chr(13),''),chr(10),'')  -- 电子账户代码
    ,replace(replace(p1.chn_flow_num,chr(13),''),chr(10),'')  -- 渠道流水号
    ,replace(replace(p1.next_day_tran_flg,chr(13),''),chr(10),'')  -- 次日转账标志
    ,replace(replace(p1.auto_refund_flg,chr(13),''),chr(10),'')  -- 自动退汇标志
    ,p1.auto_refund_cnt  -- 自动退汇次数
    ,replace(replace(p1.vtual_acct_bind_acct,chr(13),''),chr(10),'')  -- 虚户绑定账户
    ,replace(replace(p1.vtual_acct_bind_acct_name,chr(13),''),chr(10),'')  -- 虚户绑定账户名称
    ,replace(replace(p1.acct_type_cd,chr(13),''),chr(10),'')  -- 账户类型代码
    ,replace(replace(p1.vtual_open_acct_org_id,chr(13),''),chr(10),'')  -- 虚户绑定账户开户机构编号
    ,replace(replace(p1.acct_gen_cd,chr(13),''),chr(10),'')  -- 账户大类型代码
    ,replace(replace(p1.lmt_order_no,chr(13),''),chr(10),'')  -- 限额订单号
    ,replace(replace(p1.ova_flow_num,chr(13),''),chr(10),'')  -- 全局流水号
    ,replace(replace(p1.esb_intfc_return_code,chr(13),''),chr(10),'')  -- ESB接口返回码
    ,replace(replace(p1.esb_intfc_return_info,chr(13),''),chr(10),'')  -- ESB接口返回信息
    ,replace(replace(p1.esb_intfc_tran_flow_num,chr(13),''),chr(10),'')  -- ESB接口交易流水号
    ,p1.send_pbc_tm  -- 发送人行时间
from ${iml_schema}.evt_bigamt_tran_evt  p1   --大额交易事件
where tran_dt = to_date('${batch_date}','yyyymmdd');
commit;

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'evt_bigamt_tran_evt',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);