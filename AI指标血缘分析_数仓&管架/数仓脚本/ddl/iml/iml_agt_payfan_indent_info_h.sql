/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_payfan_indent_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_payfan_indent_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_payfan_indent_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_payfan_indent_info_h(
    agt_id varchar2(100) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,tran_dt date -- 交易日期
    ,payfan_chn_id varchar2(100) -- 代付渠道编号
    ,tran_code varchar2(60) -- 交易码
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_amt number(30,2) -- 交易金额
    ,batch_no varchar2(60) -- 批次号
    ,batch_rgst_status_cd varchar2(30) -- 批次登记状态代码
    ,tot number(10) -- 总笔数
    ,sucs_tran_amt number(30,2) -- 成功交易金额
    ,sucs_tran_cnt number(10) -- 成功交易笔数
    ,fail_tran_amt number(30,2) -- 失败交易金额
    ,fail_tran_cnt number(10) -- 失败交易笔数
    ,chn_order_no varchar2(60) -- 渠道订单号
    ,resp_code varchar2(30) -- 响应码
    ,resp_code_descb varchar2(2000) -- 响应码描述
    ,mercht_id varchar2(250) -- 商户编号
    ,pay_acct_type_cd varchar2(30) -- 支付账户类型代码
    ,pay_acct_id varchar2(100) -- 支付账户编号
    ,pay_acct_name varchar2(500) -- 支付账户名称
    ,intnal_acct_id varchar2(100) -- 内部账户编号
    ,intnal_acct_name varchar2(500) -- 内部账户名称
    ,recvbl_acct_id varchar2(100) -- 收款账户编号
    ,recvbl_acct_name varchar2(500) -- 收款账户名称
    ,recvbl_acct_type_cd varchar2(30) -- 收款账户类型代码
    ,recvbl_bank_ibank_no varchar2(60) -- 收款银行联行号
    ,recvbl_bank_name varchar2(1000) -- 收款银行名称
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(100) -- 证件号码
    ,mobile_no varchar2(60) -- 手机号码
    ,postsc varchar2(1000) -- 附言
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,core_flow_num varchar2(100) -- 核心流水号
    ,unionpay_mercht_order_no varchar2(100) -- 银联商户订单号
    ,unionpay_tran_flow_num varchar2(100) -- 银联交易流水号
    ,unionpay_tran_dt date -- 银联交易日期
    ,agt_corp_type_cd varchar2(30) -- 协议单位类型代码
    ,agency_id varchar2(100) -- 代理商编号
    ,agt_corp_id varchar2(100) -- 协议单位编号
    ,agt_corp_name varchar2(1000) -- 协议单位名称
    ,api_sys_idf varchar2(100) -- API系统标识
    ,teller_id varchar2(100) -- 柜员编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_payfan_indent_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_payfan_indent_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_payfan_indent_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_payfan_indent_info_h is 'E校通代付订单批次';
comment on column ${iml_schema}.agt_payfan_indent_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_payfan_indent_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_payfan_indent_info_h.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.agt_payfan_indent_info_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_payfan_indent_info_h.payfan_chn_id is '代付渠道编号';
comment on column ${iml_schema}.agt_payfan_indent_info_h.tran_code is '交易码';
comment on column ${iml_schema}.agt_payfan_indent_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_payfan_indent_info_h.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.agt_payfan_indent_info_h.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.agt_payfan_indent_info_h.tran_amt is '交易金额';
comment on column ${iml_schema}.agt_payfan_indent_info_h.batch_no is '批次号';
comment on column ${iml_schema}.agt_payfan_indent_info_h.batch_rgst_status_cd is '批次登记状态代码';
comment on column ${iml_schema}.agt_payfan_indent_info_h.tot is '总笔数';
comment on column ${iml_schema}.agt_payfan_indent_info_h.sucs_tran_amt is '成功交易金额';
comment on column ${iml_schema}.agt_payfan_indent_info_h.sucs_tran_cnt is '成功交易笔数';
comment on column ${iml_schema}.agt_payfan_indent_info_h.fail_tran_amt is '失败交易金额';
comment on column ${iml_schema}.agt_payfan_indent_info_h.fail_tran_cnt is '失败交易笔数';
comment on column ${iml_schema}.agt_payfan_indent_info_h.chn_order_no is '渠道订单号';
comment on column ${iml_schema}.agt_payfan_indent_info_h.resp_code is '响应码';
comment on column ${iml_schema}.agt_payfan_indent_info_h.resp_code_descb is '响应码描述';
comment on column ${iml_schema}.agt_payfan_indent_info_h.mercht_id is '商户编号';
comment on column ${iml_schema}.agt_payfan_indent_info_h.pay_acct_type_cd is '支付账户类型代码';
comment on column ${iml_schema}.agt_payfan_indent_info_h.pay_acct_id is '支付账户编号';
comment on column ${iml_schema}.agt_payfan_indent_info_h.pay_acct_name is '支付账户名称';
comment on column ${iml_schema}.agt_payfan_indent_info_h.intnal_acct_id is '内部账户编号';
comment on column ${iml_schema}.agt_payfan_indent_info_h.intnal_acct_name is '内部账户名称';
comment on column ${iml_schema}.agt_payfan_indent_info_h.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.agt_payfan_indent_info_h.recvbl_acct_name is '收款账户名称';
comment on column ${iml_schema}.agt_payfan_indent_info_h.recvbl_acct_type_cd is '收款账户类型代码';
comment on column ${iml_schema}.agt_payfan_indent_info_h.recvbl_bank_ibank_no is '收款银行联行号';
comment on column ${iml_schema}.agt_payfan_indent_info_h.recvbl_bank_name is '收款银行名称';
comment on column ${iml_schema}.agt_payfan_indent_info_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_payfan_indent_info_h.cert_no is '证件号码';
comment on column ${iml_schema}.agt_payfan_indent_info_h.mobile_no is '手机号码';
comment on column ${iml_schema}.agt_payfan_indent_info_h.postsc is '附言';
comment on column ${iml_schema}.agt_payfan_indent_info_h.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.agt_payfan_indent_info_h.core_flow_num is '核心流水号';
comment on column ${iml_schema}.agt_payfan_indent_info_h.unionpay_mercht_order_no is '银联商户订单号';
comment on column ${iml_schema}.agt_payfan_indent_info_h.unionpay_tran_flow_num is '银联交易流水号';
comment on column ${iml_schema}.agt_payfan_indent_info_h.unionpay_tran_dt is '银联交易日期';
comment on column ${iml_schema}.agt_payfan_indent_info_h.agt_corp_type_cd is '协议单位类型代码';
comment on column ${iml_schema}.agt_payfan_indent_info_h.agency_id is '代理商编号';
comment on column ${iml_schema}.agt_payfan_indent_info_h.agt_corp_id is '协议单位编号';
comment on column ${iml_schema}.agt_payfan_indent_info_h.agt_corp_name is '协议单位名称';
comment on column ${iml_schema}.agt_payfan_indent_info_h.api_sys_idf is 'API系统标识';
comment on column ${iml_schema}.agt_payfan_indent_info_h.teller_id is '柜员编号';
comment on column ${iml_schema}.agt_payfan_indent_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_payfan_indent_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_payfan_indent_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_payfan_indent_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_payfan_indent_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_payfan_indent_info_h.etl_timestamp is 'ETL处理时间戳';
