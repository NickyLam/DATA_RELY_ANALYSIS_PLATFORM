/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_digit_curr_bus_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_digit_curr_bus_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_digit_curr_bus_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_digit_curr_bus_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,sys_code varchar2(100) -- 系统码
    ,midgrod_flow_num varchar2(100) -- 中台流水号
    ,midgrod_dt date -- 中台日期
    ,midgrod_tran_code varchar2(100) -- 中台交易码
    ,msg_id varchar2(100) -- 报文编号
    ,msg_idf_id varchar2(100) -- 报文标识编号
    ,send_bank_no varchar2(100) -- 发送行号
    ,origi_bank_code varchar2(100) -- 发起行LEI码
    ,recv_bank_num varchar2(100) -- 接收行号
    ,recv_bank_code varchar2(100) -- 接收行LEI码
    ,entr_dt date -- 委托日期
    ,bank_int_bus_seq_num varchar2(60) -- 行内业务序号
    ,bank_int_err_cd varchar2(100) -- 行内错误码
    ,bank_int_err_info varchar2(500) -- 行内错误信息
    ,nostro_flg varchar2(10) -- 往来账标志
    ,fin_tran_code varchar2(100) -- 金融交易码
    ,fin_tran_dt date -- 金融交易日期
    ,fin_tran_flow_num varchar2(100) -- 金融交易流水号
    ,fin_midgrod_flow_num varchar2(100) -- 金融中台流水号
    ,fin_midgrod_dt date -- 金融中台日期
    ,fin_check_entry_status_cd varchar2(30) -- 金融对账状态代码
    ,acct_type_cd varchar2(30) -- 账户类型代码
    ,curr_cd varchar2(30) -- 币种代码
    ,payer_open_bank_num varchar2(60) -- 付款人开户行号
    ,payer_open_bank_name varchar2(500) -- 付款人开户行名称
    ,payer_acct_type_cd varchar2(30) -- 付款人账户类型代码
    ,payer_acct_id varchar2(2000) -- 付款人账户编号
    ,payer_name varchar2(2000) -- 付款人名称
    ,pay_acct_resdnt_type_cd varchar2(30) -- 付款账户居民类型代码
    ,pay_acct_permt_rg_cd varchar2(30) -- 付款账户常驻地区代码
    ,recver_open_bank_no varchar2(60) -- 收款人开户行行号
    ,recver_open_bank_name varchar2(500) -- 收款人开户行名称
    ,recver_acct_type_cd varchar2(30) -- 收款人账户类型代码
    ,recver_acct_id varchar2(2000) -- 收款人账户编号
    ,recver_name varchar2(2000) -- 收款人名称
    ,recvbl_acct_resdnt_type_cd varchar2(30) -- 收款账户居民类型代码
    ,recvbl_acct_permt_rg_cd varchar2(30) -- 收款账户常驻地区代码
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,pkg_level_cd varchar2(30) -- 钱包等级代码
    ,pkg_type_cd varchar2(30) -- 钱包类型代码
    ,pkg_name varchar2(500) -- 钱包名称
    ,pkg_rgst_mobile_no_site_cd varchar2(30) -- 钱包注册手机号所在地区代码
    ,bus_type_id varchar2(100) -- 业务类型编号
    ,bus_kind_id varchar2(100) -- 业务种类编号
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,bus_process_cd varchar2(100) -- 业务处理码
    ,bus_proc_dt date -- 业务处理日期
    ,bus_status_cd varchar2(30) -- 业务状态代码
    ,bus_rtn_rcpt_status_cd varchar2(30) -- 业务回执状态代码
    ,bus_refuse_code varchar2(100) -- 业务拒绝码
    ,bus_refuse_info varchar2(500) -- 业务拒绝信息
    ,bus_check_entry_status_cd varchar2(30) -- 业务对账状态代码
    ,tran_batch_no varchar2(60) -- 交易批次号
    ,tran_amt number(30,2) -- 交易金额
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_excep_proc_flg varchar2(10) -- 交易异常处理标志
    ,tran_rest_descb varchar2(500) -- 交易结果描述
    ,tran_usage_cd varchar2(30) -- 交易用途代码
    ,tran_cap_src_cd varchar2(30) -- 交易资金来源代码
    ,tran_effect_dt date -- 交易生效日期
    ,tran_invalid_dt date -- 交易失效日期
    ,tran_chn_cd varchar2(30) -- 交易渠道代码
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,debit_crdt_flg varchar2(10) -- 借贷标志
    ,comm_fee_flg varchar2(10) -- 手续费标志
    ,comm_fee_amt number(30,2) -- 手续费金额
    ,proc_cnt number(10) -- 处理次数
    ,err_rs_code varchar2(100) -- 差错原因码
    ,err_rs_comnt varchar2(500) -- 差错原因说明
    ,rtn_rcpt_tran_dt date -- 回执交易日期
    ,rtn_rcpt_msg_idf_id varchar2(100) -- 回执报文标识编号
    ,rtn_rcpt_msg_id varchar2(100) -- 回执报文编号
    ,letter_idf_flow_num varchar2(100) -- 通信级标识流水号
    ,letter_ref_flow_num varchar2(100) -- 通信级参考流水号
    ,init_entr_dt date -- 原委托日期
    ,init_msg_idf_id varchar2(100) -- 原报文标识编号
    ,init_init_prtcpt_org_id varchar2(100) -- 原发起参与机构编号
    ,init_msg_type_id varchar2(100) -- 原报文类型编号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,unify_pay_chn_flow_num varchar2(100) -- 统一支付渠道流水号
    ,agt_id varchar2(100) -- 挂接协议编号
    ,intfc_return_code varchar2(100) -- ESC接口返回码
    ,intfc_return_info varchar2(2000) -- ESC接口返回信息
    ,intfc_tran_flow_num varchar2(100) -- ESC接口交易流水号
    ,adj_entry_amt number(30,2) -- 调账金额
    ,postsc varchar2(2000) -- 附言
    ,remark varchar2(2000) -- 备注
    ,mgmt_org_id varchar2(100) -- 管理机构编号
    ,final_update_dt date -- 最后更新日期
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
grant select on ${iml_schema}.evt_digit_curr_bus_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_digit_curr_bus_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_digit_curr_bus_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_digit_curr_bus_tran_flow is '数字货币业务交易流水';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.sys_code is '系统码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.midgrod_flow_num is '中台流水号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.midgrod_dt is '中台日期';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.midgrod_tran_code is '中台交易码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.msg_id is '报文编号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.msg_idf_id is '报文标识编号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.send_bank_no is '发送行号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.origi_bank_code is '发起行LEI码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.recv_bank_num is '接收行号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.recv_bank_code is '接收行LEI码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.entr_dt is '委托日期';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.bank_int_bus_seq_num is '行内业务序号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.bank_int_err_cd is '行内错误码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.bank_int_err_info is '行内错误信息';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.nostro_flg is '往来账标志';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.fin_tran_code is '金融交易码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.fin_tran_dt is '金融交易日期';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.fin_tran_flow_num is '金融交易流水号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.fin_midgrod_flow_num is '金融中台流水号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.fin_midgrod_dt is '金融中台日期';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.fin_check_entry_status_cd is '金融对账状态代码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.payer_open_bank_num is '付款人开户行号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.payer_open_bank_name is '付款人开户行名称';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.payer_acct_type_cd is '付款人账户类型代码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.payer_acct_id is '付款人账户编号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.payer_name is '付款人名称';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.pay_acct_resdnt_type_cd is '付款账户居民类型代码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.pay_acct_permt_rg_cd is '付款账户常驻地区代码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.recver_open_bank_no is '收款人开户行行号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.recver_open_bank_name is '收款人开户行名称';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.recver_acct_type_cd is '收款人账户类型代码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.recver_acct_id is '收款人账户编号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.recver_name is '收款人名称';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.recvbl_acct_resdnt_type_cd is '收款账户居民类型代码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.recvbl_acct_permt_rg_cd is '收款账户常驻地区代码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.pkg_level_cd is '钱包等级代码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.pkg_type_cd is '钱包类型代码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.pkg_name is '钱包名称';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.pkg_rgst_mobile_no_site_cd is '钱包注册手机号所在地区代码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.bus_type_id is '业务类型编号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.bus_kind_id is '业务种类编号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.bus_process_cd is '业务处理码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.bus_proc_dt is '业务处理日期';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.bus_status_cd is '业务状态代码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.bus_rtn_rcpt_status_cd is '业务回执状态代码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.bus_refuse_code is '业务拒绝码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.bus_refuse_info is '业务拒绝信息';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.bus_check_entry_status_cd is '业务对账状态代码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.tran_batch_no is '交易批次号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.tran_excep_proc_flg is '交易异常处理标志';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.tran_rest_descb is '交易结果描述';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.tran_usage_cd is '交易用途代码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.tran_cap_src_cd is '交易资金来源代码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.tran_effect_dt is '交易生效日期';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.tran_invalid_dt is '交易失效日期';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.tran_chn_cd is '交易渠道代码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.debit_crdt_flg is '借贷标志';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.comm_fee_flg is '手续费标志';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.comm_fee_amt is '手续费金额';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.proc_cnt is '处理次数';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.err_rs_code is '差错原因码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.err_rs_comnt is '差错原因说明';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.rtn_rcpt_tran_dt is '回执交易日期';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.rtn_rcpt_msg_idf_id is '回执报文标识编号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.rtn_rcpt_msg_id is '回执报文编号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.letter_idf_flow_num is '通信级标识流水号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.letter_ref_flow_num is '通信级参考流水号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.init_entr_dt is '原委托日期';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.init_msg_idf_id is '原报文标识编号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.init_init_prtcpt_org_id is '原发起参与机构编号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.init_msg_type_id is '原报文类型编号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.unify_pay_chn_flow_num is '统一支付渠道流水号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.agt_id is '挂接协议编号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.intfc_return_code is 'ESC接口返回码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.intfc_return_info is 'ESC接口返回信息';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.intfc_tran_flow_num is 'ESC接口交易流水号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.adj_entry_amt is '调账金额';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.postsc is '附言';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.remark is '备注';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.mgmt_org_id is '管理机构编号';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_digit_curr_bus_tran_flow.etl_timestamp is 'ETL处理时间戳';
