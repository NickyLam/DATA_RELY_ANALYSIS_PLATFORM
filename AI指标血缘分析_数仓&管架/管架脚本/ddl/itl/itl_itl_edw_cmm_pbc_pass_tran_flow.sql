/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_cmm_pbc_pass_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,pay_decl_form_id varchar2(60) -- 支付报单编号
    ,tran_dt date -- 交易日期
    ,out_line_pay_tran_seq_num varchar2(60) -- 行外支付交易序号
    ,bank_int_bus_seq_num varchar2(60) -- 行内业务序号
    ,bus_origi_bank_no varchar2(60) -- 业务发起行行号
    ,msg_type_id varchar2(60) -- 报文类型编号
    ,scd_gener_msg_type_id varchar2(60) -- 二代报文类型编号
    ,host_flow_num varchar2(100) -- 主机流水号
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,send_tran_flow_num varchar2(30) -- 发送交易流水号
    ,ova_flow_num varchar2(60) -- 全局流水号
    ,host_tran_code varchar2(30) -- 主机交易码
    ,midgrod_tran_code varchar2(30) -- 中台交易码
    ,curr_cd varchar2(10) -- 币种代码
    ,prod_cd varchar2(10) -- 产品代码
    ,bus_kind_cd varchar2(20) -- 业务种类代码
    ,bus_type_cd varchar2(10) -- 业务类型代码
    ,proc_status_cd varchar2(10) -- 处理状态代码
    ,npc_proc_cd varchar2(60) -- NPC处理代码
    ,check_entry_status_cd varchar2(10) -- 对账状态代码
    ,debit_crdt_cd varchar2(10) -- 借贷代码
    ,entry_code varchar2(30) -- 记账分录编码
    ,acct_gen_cd varchar2(20) -- 账户大类型代码
    ,acct_type_cd varchar2(20) -- 账户类型代码
    ,e_acct_cd varchar2(10) -- 电子账户代码
    ,rec_status_cd varchar2(10) -- 记录状态代码
    ,mode_pay_cd varchar2(10) -- 支付方式代码
    ,exch_bus_tran_chn_cd varchar2(10) -- 汇兑业务交易渠道代码
    ,ground_proc_status_cd varchar2(10) -- 落地处理状态代码
    ,verify_proc_status_cd varchar2(10) -- 查证处理状态代码
    ,nostro_flg varchar2(10) -- 往来账标志
    ,charge_flg varchar2(10) -- 收费标志
    ,agent_flg varchar2(10) -- 代理标志
    ,intnal_acct_flg varchar2(10) -- 内部账标志
    ,entr_dt date -- 委托日期
    ,host_dt date -- 主机日期
    ,clear_dt date -- 清算日期
    ,check_entry_dt date -- 对账日期
    ,modif_dt date -- 修改日期
    ,modif_tm timestamp -- 修改时间
    ,init_entr_dt date -- 原委托日期
    ,init_pay_tran_seq_num varchar2(60) -- 原支付交易序号
    ,tran_amt number(30,2) -- 交易金额
    ,comm_fee_amt number(30,8) -- 手续费用金额
    ,remit_tran_fee_amt number(30,8) -- 汇划费用金额
    ,todos number(30,8) -- 工本费
    ,payer_open_bank_no varchar2(60) -- 付款人开户行行号
    ,payer_open_bank_name varchar2(250) -- 付款人开户行名称
    ,payer_acct_num varchar2(60) -- 付款人账号
    ,payer_name varchar2(250) -- 付款人名称
    ,payer_addr varchar2(250) -- 付款人地址
    ,recver_open_bank_no varchar2(60) -- 收款人开户行行号
    ,recver_open_bank_name varchar2(250) -- 收款人开户行名称
    ,recver_acct_num varchar2(60) -- 收款人账号
    ,recver_name varchar2(250) -- 收款人名称
    ,recver_addr varchar2(250) -- 收款人地址
    ,err_return_code varchar2(30) -- 错误返回编码
    ,err_info varchar2(500) -- 错误信息
    ,prior_level varchar2(20) -- 优先级别
    ,input_teller_id varchar2(60) -- 录入柜员编号
    ,check_teller_id varchar2(60) -- 复核柜员编号
    ,auth_teller_id varchar2(60) -- 授权柜员编号
    ,input_check_teller_dept_id varchar2(60) -- 录入复核柜员部门编号
    ,auth_teller_dept_id varchar2(60) -- 授权柜员部门编号
    ,reg_main_acct_num varchar2(60) -- 挂账或维护入账账号
    ,reg_main_name varchar2(250) -- 挂账或维护入账姓名
    ,matn_enter_acct_dt date -- 维护入账日期
    ,matn_enter_acct_teller_id varchar2(60) -- 维护入账柜员编号
    ,matn_enter_acct_dept_id varchar2(60) -- 维护入账部门编号
    ,vouch_type_cd varchar2(10) -- 凭证类型代码
    ,vouch_dt date -- 凭证日期
    ,vouch_no varchar2(60) -- 凭证号码
    ,cert_kind_cd varchar2(10) -- 证件种类代码
    ,cert_no varchar2(60) -- 证件号码
    ,actl_deduct_acct_num varchar2(60) -- 实际扣账账号
    ,actl_deduct_acct_name varchar2(100) -- 实际扣账户名称
    ,rgst_addit_data_tab_name varchar2(100) -- 登记附加数据表名称
    ,on_acct_rs_cd varchar2(10) -- 挂账原因代码
    ,auto_refund_flg varchar2(10) -- 自动退汇标志
    ,auto_refund_cnt number(10) -- 自动退汇次数
    ,vtual_bind_acct varchar2(60) -- 虚户绑定账户
    ,vtual_bind_acct_name varchar2(250) -- 虚户绑定账户名称
    ,vtual_open_acct_org_id varchar2(60) -- 虚户绑定账户开户机构编号
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow is '人行通道交易流水';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.evt_id is '事件编号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.lp_id is '法人编号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.pay_decl_form_id is '支付报单编号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.tran_dt is '交易日期';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.out_line_pay_tran_seq_num is '行外支付交易序号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.bank_int_bus_seq_num is '行内业务序号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.bus_origi_bank_no is '业务发起行行号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.msg_type_id is '报文类型编号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.scd_gener_msg_type_id is '二代报文类型编号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.host_flow_num is '主机流水号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.tran_flow_num is '交易流水号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.send_tran_flow_num is '发送交易流水号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.ova_flow_num is '全局流水号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.host_tran_code is '主机交易码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.midgrod_tran_code is '中台交易码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.curr_cd is '币种代码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.prod_cd is '产品代码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.bus_kind_cd is '业务种类代码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.bus_type_cd is '业务类型代码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.proc_status_cd is '处理状态代码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.npc_proc_cd is 'NPC处理代码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.check_entry_status_cd is '对账状态代码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.debit_crdt_cd is '借贷代码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.entry_code is '记账分录编码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.acct_gen_cd is '账户大类型代码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.acct_type_cd is '账户类型代码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.e_acct_cd is '电子账户代码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.rec_status_cd is '记录状态代码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.mode_pay_cd is '支付方式代码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.exch_bus_tran_chn_cd is '汇兑业务交易渠道代码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.ground_proc_status_cd is '落地处理状态代码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.verify_proc_status_cd is '查证处理状态代码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.nostro_flg is '往来账标志';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.charge_flg is '收费标志';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.agent_flg is '代理标志';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.intnal_acct_flg is '内部账标志';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.entr_dt is '委托日期';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.host_dt is '主机日期';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.clear_dt is '清算日期';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.check_entry_dt is '对账日期';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.modif_dt is '修改日期';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.modif_tm is '修改时间';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.init_entr_dt is '原委托日期';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.init_pay_tran_seq_num is '原支付交易序号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.tran_amt is '交易金额';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.comm_fee_amt is '手续费用金额';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.remit_tran_fee_amt is '汇划费用金额';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.todos is '工本费';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.payer_open_bank_no is '付款人开户行行号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.payer_open_bank_name is '付款人开户行名称';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.payer_acct_num is '付款人账号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.payer_name is '付款人名称';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.payer_addr is '付款人地址';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.recver_open_bank_no is '收款人开户行行号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.recver_open_bank_name is '收款人开户行名称';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.recver_acct_num is '收款人账号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.recver_name is '收款人名称';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.recver_addr is '收款人地址';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.err_return_code is '错误返回编码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.err_info is '错误信息';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.prior_level is '优先级别';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.input_teller_id is '录入柜员编号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.check_teller_id is '复核柜员编号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.auth_teller_id is '授权柜员编号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.input_check_teller_dept_id is '录入复核柜员部门编号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.auth_teller_dept_id is '授权柜员部门编号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.reg_main_acct_num is '挂账或维护入账账号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.reg_main_name is '挂账或维护入账姓名';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.matn_enter_acct_dt is '维护入账日期';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.matn_enter_acct_teller_id is '维护入账柜员编号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.matn_enter_acct_dept_id is '维护入账部门编号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.vouch_type_cd is '凭证类型代码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.vouch_dt is '凭证日期';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.vouch_no is '凭证号码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.cert_kind_cd is '证件种类代码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.cert_no is '证件号码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.actl_deduct_acct_num is '实际扣账账号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.actl_deduct_acct_name is '实际扣账户名称';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.rgst_addit_data_tab_name is '登记附加数据表名称';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.on_acct_rs_cd is '挂账原因代码';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.auto_refund_flg is '自动退汇标志';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.auto_refund_cnt is '自动退汇次数';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.vtual_bind_acct is '虚户绑定账户';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.vtual_bind_acct_name is '虚户绑定账户名称';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.vtual_open_acct_org_id is '虚户绑定账户开户机构编号';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_cmm_pbc_pass_tran_flow.etl_timestamp is 'ETL处理时间戳';