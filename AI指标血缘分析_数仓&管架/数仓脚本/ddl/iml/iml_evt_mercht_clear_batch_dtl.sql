/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_mercht_clear_batch_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_mercht_clear_batch_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_mercht_clear_batch_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_mercht_clear_batch_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,batch_id varchar2(100) -- 批次编号
    ,init_tran_flow_num varchar2(100) -- 原交易流水号
    ,rgst_dt date -- 登记日期
    ,rgst_tm timestamp -- 登记时间
    ,dtl_status_cd varchar2(30) -- 明细状态代码
    ,upp_flow_num varchar2(100) -- UPP流水号
    ,amt number(30,2) -- 金额
    ,curr_cd varchar2(30) -- 币种代码
    ,pay_acct_id varchar2(100) -- 付款账户编号
    ,pay_acct_name varchar2(750) -- 付款账户名称
    ,pay_sub_acct_num varchar2(60) -- 付款子账号
    ,pay_pt_type_cd varchar2(30) -- 付款支付工具类型代码
    ,recvbl_acct_id varchar2(100) -- 收款账户编号
    ,recvbl_acct_name varchar2(750) -- 收款账户名称
    ,recvbl_sub_acct_num varchar2(60) -- 收款子账号
    ,recvbl_pt_type_cd varchar2(30) -- 收款支付工具类型代码
    ,bank_postsc varchar2(750) -- 银行附言
    ,cust_postsc varchar2(750) -- 客户附言
    ,err_descb varchar2(750) -- 错误描述
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,core_flow_num varchar2(100) -- 核心流水号
    ,core_dt date -- 核心日期
    ,final_modif_tm timestamp -- 最后修改时间
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
grant select on ${iml_schema}.evt_mercht_clear_batch_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_mercht_clear_batch_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_mercht_clear_batch_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_mercht_clear_batch_dtl is '商户清算批次明细';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.batch_id is '批次编号';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.init_tran_flow_num is '原交易流水号';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.rgst_dt is '登记日期';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.rgst_tm is '登记时间';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.dtl_status_cd is '明细状态代码';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.upp_flow_num is 'UPP流水号';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.amt is '金额';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.pay_acct_id is '付款账户编号';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.pay_acct_name is '付款账户名称';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.pay_sub_acct_num is '付款子账号';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.pay_pt_type_cd is '付款支付工具类型代码';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.recvbl_acct_name is '收款账户名称';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.recvbl_sub_acct_num is '收款子账号';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.recvbl_pt_type_cd is '收款支付工具类型代码';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.bank_postsc is '银行附言';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.cust_postsc is '客户附言';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.err_descb is '错误描述';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.core_dt is '核心日期';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_mercht_clear_batch_dtl.etl_timestamp is 'ETL处理时间戳';
