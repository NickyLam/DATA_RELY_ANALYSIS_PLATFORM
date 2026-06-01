/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_evt_beps_tran_evt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_evt_beps_tran_evt
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_evt_beps_tran_evt purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_evt_beps_tran_evt(
    etl_dt date
    ,evt_id varchar2(60)
    ,lp_id varchar2(60)
    ,pay_decl_form_id varchar2(60)
    ,out_line_pay_tran_seq_num varchar2(60)
    ,bank_int_bus_seq_num varchar2(60)
    ,bus_type_cd varchar2(10)
    ,bus_kind_cd varchar2(20)
    ,pkg_seq_num varchar2(60)
    ,pkg_entr_dt date
    ,pkg_type varchar2(60)
    ,host_tran_code varchar2(30)
    ,midgrod_tran_code varchar2(30)
    ,tran_dt date
    ,entr_dt date
    ,host_dt date
    ,host_flow_num varchar2(60)
    ,curr_cd varchar2(10)
    ,tran_amt number(30,2)
    ,payer_open_bank_dept_id varchar2(60)
    ,payer_open_bank_no varchar2(60)
    ,payer_acct_num varchar2(60)
    ,payer_name varchar2(250)
    ,payer_addr varchar2(250)
    ,recver_open_bank_no varchar2(60)
    ,recver_acct_num varchar2(60)
    ,recver_name varchar2(250)
    ,recver_addr varchar2(250)
    ,send_msg_center_cd varchar2(10)
    ,init_clear_bk_no varchar2(60)
    ,origi_bank_no varchar2(60)
    ,recv_msg_center_cd varchar2(10)
    ,recv_clear_bk_no varchar2(60)
    ,recv_bank_no varchar2(60)
    ,init_entr_dt date
    ,init_pay_tran_seq_num varchar2(60)
    ,init_bus_type_cd varchar2(10)
    ,bill_num varchar2(30)
    ,offs_bal_node_type_cd varchar2(10)
    ,offs_bal_num_site number(10,0)
    ,offs_bal_dt_or_fs_dt date
    ,refund_rs_cd varchar2(20)
    ,proc_status_cd varchar2(10)
    ,status_rest_cd varchar2(10)
    ,pbc_bus_status_cd varchar2(10)
    ,rtn_rcpt_code varchar2(30)
    ,proc_cd varchar2(60)
    ,sys_type_cd varchar2(10)
    ,node_type_cd varchar2(10)
    ,rest_cd varchar2(10)
    ,check_revs_flow_num varchar2(60)
    ,rtn_rcpt_tenor_cd varchar2(10)
    ,rtn_rcpt_dt date
    ,send_revs_flow_num varchar2(60)
    ,clear_dt date
    ,err_code varchar2(30)
    ,err_info varchar2(500)
    ,prior_level varchar2(20)
    ,input_teller_id varchar2(60)
    ,check_teller_id varchar2(60)
    ,auth_teller_id varchar2(60)
    ,input_check_teller_dept_id varchar2(60)
    ,auth_teller_dept_id varchar2(60)
    ,check_entry_status_cd varchar2(10)
    ,print_cnt number(10,0)
    ,revid_tm timestamp(6)
    ,send_tm timestamp(6)
    ,sugst_pay_dt date
    ,nostro_flg varchar2(10)
    ,charge_flg varchar2(10)
    ,debit_crdt_cd varchar2(10)
    ,bank_int_out_line_flg varchar2(10)
    ,draft_appl_form_num varchar2(30)
    ,matn_enter_acct_num varchar2(60)
    ,reg_main_name varchar2(250)
    ,matn_enter_acct_dt date
    ,matn_enter_acct_teller_id varchar2(60)
    ,matn_enter_acct_dept_id varchar2(60)
    ,agent_flg varchar2(10)
    ,jnl_flow_num varchar2(60)
    ,send_jnl_flow_num varchar2(60)
    ,vouch_type_cd varchar2(10)
    ,entr_vouch_dt date
    ,entr_vouch_num varchar2(60)
    ,cert_kind_cd varchar2(10)
    ,cert_no varchar2(60)
    ,tran_lmt number(30,2)
    ,tran_flow_num varchar2(60)
    ,send_tran_flow_num varchar2(60)
    ,mode_pay_cd varchar2(10)
    ,exch_bus_cors_tran_chn_cd varchar2(10)
    ,recnt_modif_dt date
    ,bus_flow_num varchar2(60)
    ,comm_fee number(30,8)
    ,remit_tran_fee number(30,8)
    ,todos number(30,8)
    ,init_amt number(30,2)
    ,pay_amt number(30,2)
    ,multi_pay_amt number(30,2)
    ,mpr_host_flow_num varchar2(60)
    ,mpr_host_dt date
    ,mpr_teller_id varchar2(60)
    ,recnt_modif_tm timestamp(6)
    ,proc_org_id varchar2(60)
    ,rec_update_edit_num varchar2(60)
    ,rec_status_cd varchar2(10)
    ,init_pkg_type varchar2(60)
    ,init_pkg_init_clear_bk_num varchar2(60)
    ,init_pkg_entr_dt date
    ,init_pkg_seq_num varchar2(60)
    ,prod_cd varchar2(10)
    ,intnal_acct_flg varchar2(10)
    ,actl_deduct_acct_num varchar2(60)
    ,actl_deduct_acct_name varchar2(100)
    ,bank_int_sys_edit_num varchar2(60)
    ,cntpty_sys_edit_num varchar2(60)
    ,ground_proc_status_cd varchar2(10)
    ,verify_proc_status_cd varchar2(10)
    ,rgst_addit_data_name varchar2(100)
    ,rgst_addit_data_dtl_name varchar2(100)
    ,on_acct_rs_cd varchar2(10)
    ,pkg_bank_int_seq_num varchar2(60)
    ,scd_gener_msg_type_id varchar2(60)
    ,scd_gener_bus_type_cd varchar2(10)
    ,scd_gener_bus_kind_cd varchar2(20)
    ,payer_open_bank_name varchar2(250)
    ,recver_open_bank_name varchar2(250)
    ,charge_way_cd varchar2(10)
    ,e_acct_cd varchar2(10)
    ,next_day_tran_flg varchar2(10)
    ,auto_refund_flg varchar2(10)
    ,auto_refund_cnt number(10,0)
    ,vtual_acct_bind_acct varchar2(60)
    ,vtual_acct_bind_acct_name varchar2(250)
    ,acct_type_cd varchar2(20)
    ,vtual_open_acct_org_id varchar2(60)
    ,last_debit_rtn_rcpt_status_cd varchar2(10)
    ,last_tran_status_cd varchar2(10)
    ,acct_gen_cd varchar2(20)
    ,lmt_order_no varchar2(60)
    ,bind_flg varchar2(10)
    ,ova_flow_num varchar2(60)
    ,esb_intfc_return_code varchar2(30)
    ,esb_intfc_return_info varchar2(2000)
    ,esb_intfc_tran_flow_num varchar2(60)
    ,send_pbc_tm timestamp(6)
    ,src_table_name varchar2(100)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_evt_beps_tran_evt to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_evt_beps_tran_evt is '小额交易事件';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.evt_id is '事件编号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.lp_id is '法人编号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.pay_decl_form_id is '支付报单编号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.out_line_pay_tran_seq_num is '行外支付交易序号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.bank_int_bus_seq_num is '行内业务序号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.bus_type_cd is '业务类型代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.bus_kind_cd is '业务种类代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.pkg_seq_num is '包序号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.pkg_entr_dt is '包委托日期';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.pkg_type is '包类型';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.host_tran_code is '主机交易码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.midgrod_tran_code is '中台交易码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.tran_dt is '交易日期';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.entr_dt is '委托日期';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.host_dt is '主机日期';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.host_flow_num is '主机流水号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.curr_cd is '币种代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.tran_amt is '交易金额';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.payer_open_bank_dept_id is '付款人开户行部门编号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.payer_open_bank_no is '付款人开户行行号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.payer_acct_num is '付款人账号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.payer_name is '付款人名称';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.payer_addr is '付款人地址';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.recver_open_bank_no is '收款人开户行行号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.recver_acct_num is '收款人账号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.recver_name is '收款人名称';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.recver_addr is '收款人地址';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.send_msg_center_cd is '发报中心代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.init_clear_bk_no is '发起清算行行号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.origi_bank_no is '发起行行号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.recv_msg_center_cd is '收报中心代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.recv_clear_bk_no is '接收清算行行号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.recv_bank_no is '接收行行号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.init_entr_dt is '原委托日期';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.init_pay_tran_seq_num is '原支付交易序号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.init_bus_type_cd is '原业务类型代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.bill_num is '票据号码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.offs_bal_node_type_cd is '轧差节点类型代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.offs_bal_num_site is '轧差场次';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.offs_bal_dt_or_fs_dt is '轧差日期或终态日期';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.refund_rs_cd is '退汇原因代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.proc_status_cd is '处理状态代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.status_rest_cd is '状态处理结果代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.pbc_bus_status_cd is '人行业务状态代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.rtn_rcpt_code is '回执码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.proc_cd is '处理代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.sys_type_cd is '系统类型代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.node_type_cd is '节点类型代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.rest_cd is '处理结果代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.check_revs_flow_num is '复核冲正流水号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.rtn_rcpt_tenor_cd is '回执期限代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.rtn_rcpt_dt is '回执日期';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.send_revs_flow_num is '发送冲正流水号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.clear_dt is '清算日期';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.err_code is '错误编码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.err_info is '错误信息';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.prior_level is '优先级别';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.input_teller_id is '录入柜员编号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.check_teller_id is '复核柜员编号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.auth_teller_id is '授权柜员编号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.input_check_teller_dept_id is '录入复核柜员部门编号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.auth_teller_dept_id is '授权柜员部门编号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.check_entry_status_cd is '对账状态代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.print_cnt is '打印次数';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.revid_tm is '收到时间';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.send_tm is '发送时间';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.sugst_pay_dt is '提示付款日期';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.nostro_flg is '往来账标志';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.charge_flg is '收费标志';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.debit_crdt_cd is '借贷代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.bank_int_out_line_flg is '行内行外标志';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.draft_appl_form_num is '汇票申请书号码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.matn_enter_acct_num is '维护入账账号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.reg_main_name is '挂账或维护入账姓名';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.matn_enter_acct_dt is '维护入账日期';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.matn_enter_acct_teller_id is '维护入账柜员编号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.matn_enter_acct_dept_id is '维护入账部门编号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.agent_flg is '代理标志';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.jnl_flow_num is '日志流水号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.send_jnl_flow_num is '发送日志流水号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.vouch_type_cd is '凭证类型代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.entr_vouch_dt is '委托凭证日期';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.entr_vouch_num is '委托凭证号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.cert_kind_cd is '证件种类代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.cert_no is '证件号码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.tran_lmt is '转账限额';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.tran_flow_num is '交易流水号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.send_tran_flow_num is '发送交易流水号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.mode_pay_cd is '支付方式代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.exch_bus_cors_tran_chn_cd is '汇兑业务对应交易渠道代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.recnt_modif_dt is '最近修改日期';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.bus_flow_num is '业务流水号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.comm_fee is '手续费';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.remit_tran_fee is '汇划费';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.todos is '工本费';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.init_amt is '原托金额';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.pay_amt is '支付金额';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.multi_pay_amt is '多付金额';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.mpr_host_flow_num is '维护入账冲账主机流水号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.mpr_host_dt is '维护入账冲账主机日期';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.mpr_teller_id is '维护入账冲账柜员编号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.recnt_modif_tm is '最近修改时间';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.proc_org_id is '处理机构编号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.rec_update_edit_num is '记录更新版本号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.rec_status_cd is '记录状态代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.init_pkg_type is '原包类型';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.init_pkg_init_clear_bk_num is '原包发起清算行号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.init_pkg_entr_dt is '原包委托日期';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.init_pkg_seq_num is '原包序号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.prod_cd is '产品代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.intnal_acct_flg is '内部账标志';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.actl_deduct_acct_num is '实际扣账账号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.actl_deduct_acct_name is '实际扣账户名称';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.bank_int_sys_edit_num is '行内系统版本号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.cntpty_sys_edit_num is '对手系统版本号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.ground_proc_status_cd is '落地处理状态代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.verify_proc_status_cd is '查证处理状态代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.rgst_addit_data_name is '登记附加数据表名称';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.rgst_addit_data_dtl_name is '登记附加数据明细表名称';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.on_acct_rs_cd is '挂账原因代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.pkg_bank_int_seq_num is '包行内序号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.scd_gener_msg_type_id is '二代报文类型编号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.scd_gener_bus_type_cd is '二代业务类型代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.scd_gener_bus_kind_cd is '二代业务种类代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.payer_open_bank_name is '付款人开户行名称';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.recver_open_bank_name is '收款人开户行名称';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.charge_way_cd is '收费方式代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.e_acct_cd is '电子账户代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.next_day_tran_flg is '次日转账标志';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.auto_refund_flg is '自动退汇标志';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.auto_refund_cnt is '自动退汇次数';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.vtual_acct_bind_acct is '虚户绑定账户';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.vtual_acct_bind_acct_name is '虚户绑定账户名称';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.acct_type_cd is '账户类型代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.vtual_open_acct_org_id is '虚户绑定账户开户机构编号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.last_debit_rtn_rcpt_status_cd is '上一借记回执状态代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.last_tran_status_cd is '上一交易状态代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.acct_gen_cd is '账户大类型代码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.lmt_order_no is '限额订单号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.bind_flg is '绑定标志';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.ova_flow_num is '全局流水号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.esb_intfc_return_code is 'esb接口返回码';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.esb_intfc_return_info is 'esb接口返回信息';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.esb_intfc_tran_flow_num is 'esb接口交易流水号';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.send_pbc_tm is '发送人行时间';
comment on column ${msl_schema}.msl_edw_evt_beps_tran_evt.src_table_name is '源表名称';
