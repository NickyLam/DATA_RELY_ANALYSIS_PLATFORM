/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_cbps_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_cbps_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_cbps_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cbps_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,sys_id varchar2(100) -- 系统编号
    ,midgrod_flow_num varchar2(100) -- 中台流水号
    ,midgrod_tran_dt date -- 中台交易日期
    ,midgrod_tran_tm varchar2(10) -- 中台交易时间
    ,msg_type_id varchar2(100) -- 报文类型编号
    ,origi_bank_no varchar2(100) -- 发起行行号
    ,init_clear_bk_no varchar2(100) -- 发起清算行行号
    ,recv_bank_no varchar2(100) -- 接收行行号
    ,recv_clear_bk_no varchar2(100) -- 接收清算行行号
    ,entr_dt date -- 委托日期
    ,msg_idf_id varchar2(100) -- 报文标识编号
    ,dtl_idf_id varchar2(100) -- 明细标识编号
    ,bank_int_bus_seq_num varchar2(100) -- 行内业务序号
    ,midgrod_tran_code varchar2(90) -- 中台交易码
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,nostro_cd varchar2(30) -- 往来账代码
    ,debit_crdt_dir_cd varchar2(30) -- 借贷方向代码
    ,core_tran_code varchar2(90) -- 核心交易码
    ,core_tran_dt date -- 核心交易日期
    ,core_flow_num varchar2(100) -- 核心流水号
    ,entr_tm timestamp -- 委托时间
    ,payer_open_belong_city_cd varchar2(30) -- 付款人开户行所属城市代码
    ,pay_clear_bk_no varchar2(100) -- 付款清算行行号
    ,payer_open_dept_id varchar2(100) -- 付款人开户行部门编号
    ,payer_open_no varchar2(100) -- 付款人开户行行号
    ,payer_open_bank_name varchar2(750) -- 付款人开户行名称
    ,payer_acct_type_cd varchar2(30) -- 付款人账户类型代码
    ,payer_acct_num varchar2(100) -- 付款人账号
    ,payer_name varchar2(375) -- 付款人名称
    ,payer_addr varchar2(375) -- 付款人地址
    ,recver_open_belong_city_cd varchar2(30) -- 收款人开户行所属城市代码
    ,recver_open_bank_no varchar2(100) -- 收款人开户行行号
    ,recvbl_clear_bk_no varchar2(100) -- 收款清算行行号
    ,recver_open_bank_name varchar2(750) -- 收款人开户行名称
    ,recver_acct_type_cd varchar2(30) -- 收款人账户类型代码
    ,recver_acct_num varchar2(100) -- 收款人账号
    ,recver_name varchar2(375) -- 收款人名称
    ,recver_addr varchar2(375) -- 收款人地址
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,bus_kind_cd varchar2(30) -- 业务种类代码
    ,init_entr_dt date -- 原委托日期
    ,init_msg_idf_id varchar2(100) -- 原报文标识编号
    ,init_origi_bank_no varchar2(100) -- 原发起行行号
    ,init_msg_type_id varchar2(100) -- 原报文类型编号
    ,mode_pay_cd varchar2(30) -- 支付方式代码
    ,vouch_type_cd varchar2(30) -- 凭证类型代码
    ,vouch_dt date -- 凭证日期
    ,vouch_no varchar2(100) -- 凭证号码
    ,prior_level varchar2(15) -- 优先级别
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,refund_rs_descb varchar2(750) -- 退汇原因描述
    ,tran_chn_cd varchar2(30) -- 交易渠道代码
    ,tran_lmt number(30,2) -- 转账限额
    ,err_return_code varchar2(45) -- 错误返回码
    ,err_info_desc varchar2(750) -- 错误信息描述
    ,recv_tm timestamp -- 接收时间
    ,rtn_rcpt_msg_idf_id varchar2(100) -- 回执报文标识编号
    ,cbps_bus_status_cd varchar2(30) -- 城银清算业务状态代码
    ,offs_bal_num_site varchar2(15) -- 轧差场次
    ,offs_bal_dt date -- 轧差日期
    ,cbps_bus_process_cd varchar2(45) -- 城银清算业务处理码
    ,clear_dt date -- 清算日期
    ,bus_check_entry_status_cd varchar2(30) -- 业务对账状态代码
    ,core_check_entry_status_cd varchar2(30) -- 核心对账状态代码
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_rest_descb varchar2(1500) -- 交易结果描述
    ,update_tm timestamp -- 更新时间
    ,mgmt_org_id varchar2(100) -- 管理机构编号
    ,on_acct_rs_cd varchar2(30) -- 挂账原因代码
    ,on_acct_rs_comnt varchar2(1500) -- 挂账原因说明
    ,on_acct_dt date -- 挂账日期
    ,on_acct_teller_id varchar2(100) -- 挂账柜员编号
    ,on_acct_org_id varchar2(100) -- 挂账机构编号
    ,on_acct_acct_num varchar2(100) -- 挂账账号
    ,on_acct_acct_name varchar2(375) -- 挂账账户名称
    ,matn_enter_acct_dt date -- 维护入账日期
    ,matn_enter_acct_teller_id varchar2(100) -- 维护入账柜员编号
    ,matn_enter_acct_org_id varchar2(100) -- 维护入账机构编号
    ,matn_enter_acct_num varchar2(100) -- 维护入账账号
    ,matn_enter_name varchar2(375) -- 维护入账账户名称
    ,revs_teller_id varchar2(100) -- 冲正柜员编号
    ,revs_tran_flow_num varchar2(100) -- 冲正交易流水号
    ,revs_dt date -- 冲正日期
    ,intnal_acct_flg varchar2(30) -- 内部账标志
    ,actl_deduct_acct_num varchar2(100) -- 实际扣账账号
    ,actl_deduct_acct_name varchar2(375) -- 实际扣账账户名称
    ,e_acct_flg varchar2(30) -- 电子账户标志
    ,acct_type_cd varchar2(30) -- 账户类型代码
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,unify_pay_chn_flow_num varchar2(100) -- 统一支付渠道流水号
    ,happ_od_flg varchar2(30) -- 发生透支标志
    ,od_amt number(30,2) -- 透支金额
    ,lmt_order_no varchar2(100) -- 限额订单号
    ,e_acct_prod_acct_num varchar2(100) -- 电子账户产品账号
    ,e_acct_entry_memo varchar2(750) -- 电子账户记账摘要
    ,pay_check_midgrod_flow_num varchar2(100) -- 支付对账中台流水号
    ,pay_check_midgrod_tran_dt date -- 支付对账中台交易日期
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_cbps_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_cbps_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_cbps_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_cbps_tran_flow is '城银清算交易流水';
comment on column ${iml_schema}.evt_cbps_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_cbps_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_cbps_tran_flow.sys_id is '系统编号';
comment on column ${iml_schema}.evt_cbps_tran_flow.midgrod_flow_num is '中台流水号';
comment on column ${iml_schema}.evt_cbps_tran_flow.midgrod_tran_dt is '中台交易日期';
comment on column ${iml_schema}.evt_cbps_tran_flow.midgrod_tran_tm is '中台交易时间';
comment on column ${iml_schema}.evt_cbps_tran_flow.msg_type_id is '报文类型编号';
comment on column ${iml_schema}.evt_cbps_tran_flow.origi_bank_no is '发起行行号';
comment on column ${iml_schema}.evt_cbps_tran_flow.init_clear_bk_no is '发起清算行行号';
comment on column ${iml_schema}.evt_cbps_tran_flow.recv_bank_no is '接收行行号';
comment on column ${iml_schema}.evt_cbps_tran_flow.recv_clear_bk_no is '接收清算行行号';
comment on column ${iml_schema}.evt_cbps_tran_flow.entr_dt is '委托日期';
comment on column ${iml_schema}.evt_cbps_tran_flow.msg_idf_id is '报文标识编号';
comment on column ${iml_schema}.evt_cbps_tran_flow.dtl_idf_id is '明细标识编号';
comment on column ${iml_schema}.evt_cbps_tran_flow.bank_int_bus_seq_num is '行内业务序号';
comment on column ${iml_schema}.evt_cbps_tran_flow.midgrod_tran_code is '中台交易码';
comment on column ${iml_schema}.evt_cbps_tran_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_cbps_tran_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_cbps_tran_flow.nostro_cd is '往来账代码';
comment on column ${iml_schema}.evt_cbps_tran_flow.debit_crdt_dir_cd is '借贷方向代码';
comment on column ${iml_schema}.evt_cbps_tran_flow.core_tran_code is '核心交易码';
comment on column ${iml_schema}.evt_cbps_tran_flow.core_tran_dt is '核心交易日期';
comment on column ${iml_schema}.evt_cbps_tran_flow.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_cbps_tran_flow.entr_tm is '委托时间';
comment on column ${iml_schema}.evt_cbps_tran_flow.payer_open_belong_city_cd is '付款人开户行所属城市代码';
comment on column ${iml_schema}.evt_cbps_tran_flow.pay_clear_bk_no is '付款清算行行号';
comment on column ${iml_schema}.evt_cbps_tran_flow.payer_open_dept_id is '付款人开户行部门编号';
comment on column ${iml_schema}.evt_cbps_tran_flow.payer_open_no is '付款人开户行行号';
comment on column ${iml_schema}.evt_cbps_tran_flow.payer_open_bank_name is '付款人开户行名称';
comment on column ${iml_schema}.evt_cbps_tran_flow.payer_acct_type_cd is '付款人账户类型代码';
comment on column ${iml_schema}.evt_cbps_tran_flow.payer_acct_num is '付款人账号';
comment on column ${iml_schema}.evt_cbps_tran_flow.payer_name is '付款人名称';
comment on column ${iml_schema}.evt_cbps_tran_flow.payer_addr is '付款人地址';
comment on column ${iml_schema}.evt_cbps_tran_flow.recver_open_belong_city_cd is '收款人开户行所属城市代码';
comment on column ${iml_schema}.evt_cbps_tran_flow.recver_open_bank_no is '收款人开户行行号';
comment on column ${iml_schema}.evt_cbps_tran_flow.recvbl_clear_bk_no is '收款清算行行号';
comment on column ${iml_schema}.evt_cbps_tran_flow.recver_open_bank_name is '收款人开户行名称';
comment on column ${iml_schema}.evt_cbps_tran_flow.recver_acct_type_cd is '收款人账户类型代码';
comment on column ${iml_schema}.evt_cbps_tran_flow.recver_acct_num is '收款人账号';
comment on column ${iml_schema}.evt_cbps_tran_flow.recver_name is '收款人名称';
comment on column ${iml_schema}.evt_cbps_tran_flow.recver_addr is '收款人地址';
comment on column ${iml_schema}.evt_cbps_tran_flow.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.evt_cbps_tran_flow.bus_kind_cd is '业务种类代码';
comment on column ${iml_schema}.evt_cbps_tran_flow.init_entr_dt is '原委托日期';
comment on column ${iml_schema}.evt_cbps_tran_flow.init_msg_idf_id is '原报文标识编号';
comment on column ${iml_schema}.evt_cbps_tran_flow.init_origi_bank_no is '原发起行行号';
comment on column ${iml_schema}.evt_cbps_tran_flow.init_msg_type_id is '原报文类型编号';
comment on column ${iml_schema}.evt_cbps_tran_flow.mode_pay_cd is '支付方式代码';
comment on column ${iml_schema}.evt_cbps_tran_flow.vouch_type_cd is '凭证类型代码';
comment on column ${iml_schema}.evt_cbps_tran_flow.vouch_dt is '凭证日期';
comment on column ${iml_schema}.evt_cbps_tran_flow.vouch_no is '凭证号码';
comment on column ${iml_schema}.evt_cbps_tran_flow.prior_level is '优先级别';
comment on column ${iml_schema}.evt_cbps_tran_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_cbps_tran_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_cbps_tran_flow.refund_rs_descb is '退汇原因描述';
comment on column ${iml_schema}.evt_cbps_tran_flow.tran_chn_cd is '交易渠道代码';
comment on column ${iml_schema}.evt_cbps_tran_flow.tran_lmt is '转账限额';
comment on column ${iml_schema}.evt_cbps_tran_flow.err_return_code is '错误返回码';
comment on column ${iml_schema}.evt_cbps_tran_flow.err_info_desc is '错误信息描述';
comment on column ${iml_schema}.evt_cbps_tran_flow.recv_tm is '接收时间';
comment on column ${iml_schema}.evt_cbps_tran_flow.rtn_rcpt_msg_idf_id is '回执报文标识编号';
comment on column ${iml_schema}.evt_cbps_tran_flow.cbps_bus_status_cd is '城银清算业务状态代码';
comment on column ${iml_schema}.evt_cbps_tran_flow.offs_bal_num_site is '轧差场次';
comment on column ${iml_schema}.evt_cbps_tran_flow.offs_bal_dt is '轧差日期';
comment on column ${iml_schema}.evt_cbps_tran_flow.cbps_bus_process_cd is '城银清算业务处理码';
comment on column ${iml_schema}.evt_cbps_tran_flow.clear_dt is '清算日期';
comment on column ${iml_schema}.evt_cbps_tran_flow.bus_check_entry_status_cd is '业务对账状态代码';
comment on column ${iml_schema}.evt_cbps_tran_flow.core_check_entry_status_cd is '核心对账状态代码';
comment on column ${iml_schema}.evt_cbps_tran_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_cbps_tran_flow.tran_rest_descb is '交易结果描述';
comment on column ${iml_schema}.evt_cbps_tran_flow.update_tm is '更新时间';
comment on column ${iml_schema}.evt_cbps_tran_flow.mgmt_org_id is '管理机构编号';
comment on column ${iml_schema}.evt_cbps_tran_flow.on_acct_rs_cd is '挂账原因代码';
comment on column ${iml_schema}.evt_cbps_tran_flow.on_acct_rs_comnt is '挂账原因说明';
comment on column ${iml_schema}.evt_cbps_tran_flow.on_acct_dt is '挂账日期';
comment on column ${iml_schema}.evt_cbps_tran_flow.on_acct_teller_id is '挂账柜员编号';
comment on column ${iml_schema}.evt_cbps_tran_flow.on_acct_org_id is '挂账机构编号';
comment on column ${iml_schema}.evt_cbps_tran_flow.on_acct_acct_num is '挂账账号';
comment on column ${iml_schema}.evt_cbps_tran_flow.on_acct_acct_name is '挂账账户名称';
comment on column ${iml_schema}.evt_cbps_tran_flow.matn_enter_acct_dt is '维护入账日期';
comment on column ${iml_schema}.evt_cbps_tran_flow.matn_enter_acct_teller_id is '维护入账柜员编号';
comment on column ${iml_schema}.evt_cbps_tran_flow.matn_enter_acct_org_id is '维护入账机构编号';
comment on column ${iml_schema}.evt_cbps_tran_flow.matn_enter_acct_num is '维护入账账号';
comment on column ${iml_schema}.evt_cbps_tran_flow.matn_enter_name is '维护入账账户名称';
comment on column ${iml_schema}.evt_cbps_tran_flow.revs_teller_id is '冲正柜员编号';
comment on column ${iml_schema}.evt_cbps_tran_flow.revs_tran_flow_num is '冲正交易流水号';
comment on column ${iml_schema}.evt_cbps_tran_flow.revs_dt is '冲正日期';
comment on column ${iml_schema}.evt_cbps_tran_flow.intnal_acct_flg is '内部账标志';
comment on column ${iml_schema}.evt_cbps_tran_flow.actl_deduct_acct_num is '实际扣账账号';
comment on column ${iml_schema}.evt_cbps_tran_flow.actl_deduct_acct_name is '实际扣账账户名称';
comment on column ${iml_schema}.evt_cbps_tran_flow.e_acct_flg is '电子账户标志';
comment on column ${iml_schema}.evt_cbps_tran_flow.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.evt_cbps_tran_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_cbps_tran_flow.unify_pay_chn_flow_num is '统一支付渠道流水号';
comment on column ${iml_schema}.evt_cbps_tran_flow.happ_od_flg is '发生透支标志';
comment on column ${iml_schema}.evt_cbps_tran_flow.od_amt is '透支金额';
comment on column ${iml_schema}.evt_cbps_tran_flow.lmt_order_no is '限额订单号';
comment on column ${iml_schema}.evt_cbps_tran_flow.e_acct_prod_acct_num is '电子账户产品账号';
comment on column ${iml_schema}.evt_cbps_tran_flow.e_acct_entry_memo is '电子账户记账摘要';
comment on column ${iml_schema}.evt_cbps_tran_flow.pay_check_midgrod_flow_num is '支付对账中台流水号';
comment on column ${iml_schema}.evt_cbps_tran_flow.pay_check_midgrod_tran_dt is '支付对账中台交易日期';
comment on column ${iml_schema}.evt_cbps_tran_flow.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_cbps_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_cbps_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_cbps_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_cbps_tran_flow.etl_timestamp is 'ETL处理时间戳';
