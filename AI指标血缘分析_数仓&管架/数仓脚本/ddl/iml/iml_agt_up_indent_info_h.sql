/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_up_indent_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_up_indent_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_up_indent_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_up_indent_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,order_no varchar2(250) -- 订单号
    ,fund_corp_id varchar2(250) -- 基金公司编号
    ,unionpay_mercht_id varchar2(250) -- 银联商户编号
    ,belong_org_id varchar2(250) -- 所属机构编号
    ,org_id varchar2(250) -- 机构编号
    ,payfan_chn_id varchar2(250) -- 代付渠道编号
    ,cert_type_cd varchar2(60) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,mobile_no varchar2(250) -- 手机号码
    ,tran_amt number(30,2) -- 交易金额
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_dt date -- 交易日期
    ,recvbl_acct_id varchar2(100) -- 收款账户编号
    ,recvbl_acct_name varchar2(500) -- 收款账户名称
    ,recvbl_acct_type_cd varchar2(60) -- 收款账户类型代码
    ,recvbl_bank_no varchar2(100) -- 收款银行行号
    ,recvbl_bank_name varchar2(500) -- 收款银行名称
    ,recvbl_acct_core_type_cd varchar2(60) -- 收款账户核心类型代码
    ,bank_int_recvbl_acct_flg varchar2(10) -- 行内收款账户标志
    ,pay_acct_id varchar2(100) -- 付款账户编号
    ,pay_acct_name varchar2(500) -- 付款账户名称
    ,pay_acct_type_cd varchar2(60) -- 付款账户类型代码
    ,pay_acct_core_type_cd varchar2(60) -- 付款账户核心类型代码
    ,init_tran_date date -- 原交易日期
    ,init_tran_id varchar2(250) -- 原交易编号
    ,fail_rs varchar2(1000) -- 失败原因
    ,valid_flg varchar2(10) -- 有效标志
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
grant select on ${iml_schema}.agt_up_indent_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_up_indent_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_up_indent_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_up_indent_info_h is '银联代付订单信息历史';
comment on column ${iml_schema}.agt_up_indent_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_up_indent_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_up_indent_info_h.order_no is '订单号';
comment on column ${iml_schema}.agt_up_indent_info_h.fund_corp_id is '基金公司编号';
comment on column ${iml_schema}.agt_up_indent_info_h.unionpay_mercht_id is '银联商户编号';
comment on column ${iml_schema}.agt_up_indent_info_h.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_up_indent_info_h.org_id is '机构编号';
comment on column ${iml_schema}.agt_up_indent_info_h.payfan_chn_id is '代付渠道编号';
comment on column ${iml_schema}.agt_up_indent_info_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_up_indent_info_h.cert_no is '证件号码';
comment on column ${iml_schema}.agt_up_indent_info_h.mobile_no is '手机号码';
comment on column ${iml_schema}.agt_up_indent_info_h.tran_amt is '交易金额';
comment on column ${iml_schema}.agt_up_indent_info_h.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.agt_up_indent_info_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_up_indent_info_h.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.agt_up_indent_info_h.recvbl_acct_name is '收款账户名称';
comment on column ${iml_schema}.agt_up_indent_info_h.recvbl_acct_type_cd is '收款账户类型代码';
comment on column ${iml_schema}.agt_up_indent_info_h.recvbl_bank_no is '收款银行行号';
comment on column ${iml_schema}.agt_up_indent_info_h.recvbl_bank_name is '收款银行名称';
comment on column ${iml_schema}.agt_up_indent_info_h.recvbl_acct_core_type_cd is '收款账户核心类型代码';
comment on column ${iml_schema}.agt_up_indent_info_h.bank_int_recvbl_acct_flg is '行内收款账户标志';
comment on column ${iml_schema}.agt_up_indent_info_h.pay_acct_id is '付款账户编号';
comment on column ${iml_schema}.agt_up_indent_info_h.pay_acct_name is '付款账户名称';
comment on column ${iml_schema}.agt_up_indent_info_h.pay_acct_type_cd is '付款账户类型代码';
comment on column ${iml_schema}.agt_up_indent_info_h.pay_acct_core_type_cd is '付款账户核心类型代码';
comment on column ${iml_schema}.agt_up_indent_info_h.init_tran_date is '原交易日期';
comment on column ${iml_schema}.agt_up_indent_info_h.init_tran_id is '原交易编号';
comment on column ${iml_schema}.agt_up_indent_info_h.fail_rs is '失败原因';
comment on column ${iml_schema}.agt_up_indent_info_h.valid_flg is '有效标志';
comment on column ${iml_schema}.agt_up_indent_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_up_indent_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_up_indent_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_up_indent_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_up_indent_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_up_indent_info_h.etl_timestamp is 'ETL处理时间戳';
