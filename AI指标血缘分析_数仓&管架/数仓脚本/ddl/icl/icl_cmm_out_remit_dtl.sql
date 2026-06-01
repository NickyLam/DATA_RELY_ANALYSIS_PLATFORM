/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_out_remit_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_out_remit_dtl
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_out_remit_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_out_remit_dtl(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,tran_flow_id varchar2(60) -- 交易流水编号
    ,core_tran_flow_num varchar2(60) -- 核心交易流水号
    ,decl_num varchar2(60) -- 申报号码
    ,remit_id varchar2(60) -- 汇款编号
    ,cust_id varchar2(60) -- 客户编号
    ,recvbl_num varchar2(60) -- 收款账号
    ,remit_acct_num varchar2(60) -- 汇款账号
    ,remiter_name varchar2(100) -- 汇款人名称
    ,remiter_cn_name varchar2(150) -- 汇款人中文名称
    ,remiter_cty_cd varchar2(10) -- 汇款人国家代码
    ,remit_cmplt_dt date -- 汇款完成日期
    ,remit_char varchar2(60) -- 汇款性质
    ,value_day date -- 起息日
    ,exp_day timestamp(6) -- 到期日
    ,recver_cust_type_cd varchar2(60) -- 收款方客户类型代码
    ,recver_name varchar2(200) -- 收款人名称
    ,recver_cn_name varchar2(250) -- 收款人中文名称
    ,recver_cty_cd varchar2(10) -- 收款人国家代码
    ,recver_descb varchar2(200) -- 收款人描述
    ,curr_cd varchar2(10) -- 币种代码
    ,remit_amt number(30,2) -- 汇款金额
    ,remit_type_cd varchar2(10) -- 汇款类型代码
    ,tran_cd varchar2(60) -- 交易代码
    ,tran_postsc varchar2(2000) -- 交易附言
    ,tran_dtl_cd varchar2(60) -- 交易明细代码
    ,tran_dtl_postsc varchar2(2000) -- 交易明细附言
    ,tran_teller_id varchar2(60) -- 交易柜员编号
    ,tran_org_name varchar2(500) -- 交易机构名称
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,clear_bk_bic varchar2(90) -- 清算行BIC
    ,inter_bank_bic varchar2(60) -- 中间行BIC
    ,recv_bank_bic varchar2(90) -- 收款行BIC
    ,msg_info_1 varchar2(60) -- 报文信息1
    ,msg_info_2 varchar2(60) -- 报文信息2
    ,fee_amt number(30,2) -- 费用金额
    ,usd_fee_amt number(30,2) -- 折美元费用金额
    ,usd_tran_amt number(30,2) -- 折美元交易金额
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_out_remit_dtl to ${idl_schema};
grant select on ${icl_schema}.cmm_out_remit_dtl to ${iel_schema};
grant select on ${icl_schema}.cmm_out_remit_dtl to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_out_remit_dtl is '汇出汇款明细';
comment on column ${icl_schema}.cmm_out_remit_dtl.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_out_remit_dtl.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_out_remit_dtl.tran_flow_id is '交易流水编号';
comment on column ${icl_schema}.cmm_out_remit_dtl.core_tran_flow_num is '核心交易流水号';
comment on column ${icl_schema}.cmm_out_remit_dtl.decl_num is '申报号码';
comment on column ${icl_schema}.cmm_out_remit_dtl.remit_id is '汇款编号';
comment on column ${icl_schema}.cmm_out_remit_dtl.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_out_remit_dtl.recvbl_num is '收款账号';
comment on column ${icl_schema}.cmm_out_remit_dtl.remit_acct_num is '汇款账号';
comment on column ${icl_schema}.cmm_out_remit_dtl.remiter_name is '汇款人名称';
comment on column ${icl_schema}.cmm_out_remit_dtl.remiter_cn_name is '汇款人中文名称';
comment on column ${icl_schema}.cmm_out_remit_dtl.remiter_cty_cd is '汇款人国家代码';
comment on column ${icl_schema}.cmm_out_remit_dtl.remit_cmplt_dt is '汇款完成日期';
comment on column ${icl_schema}.cmm_out_remit_dtl.remit_char is '汇款性质';
comment on column ${icl_schema}.cmm_out_remit_dtl.value_day is '起息日';
comment on column ${icl_schema}.cmm_out_remit_dtl.exp_day is '到期日';
comment on column ${icl_schema}.cmm_out_remit_dtl.recver_cust_type_cd is '收款方客户类型代码';
comment on column ${icl_schema}.cmm_out_remit_dtl.recver_name is '收款人名称';
comment on column ${icl_schema}.cmm_out_remit_dtl.recver_cn_name is '收款人中文名称';
comment on column ${icl_schema}.cmm_out_remit_dtl.recver_cty_cd is '收款人国家代码';
comment on column ${icl_schema}.cmm_out_remit_dtl.recver_descb is '收款人描述';
comment on column ${icl_schema}.cmm_out_remit_dtl.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_out_remit_dtl.remit_amt is '汇款金额';
comment on column ${icl_schema}.cmm_out_remit_dtl.remit_type_cd is '汇款类型代码';
comment on column ${icl_schema}.cmm_out_remit_dtl.tran_cd is '交易代码';
comment on column ${icl_schema}.cmm_out_remit_dtl.tran_postsc is '交易附言';
comment on column ${icl_schema}.cmm_out_remit_dtl.tran_dtl_cd is '交易明细代码';
comment on column ${icl_schema}.cmm_out_remit_dtl.tran_dtl_postsc is '交易明细附言';
comment on column ${icl_schema}.cmm_out_remit_dtl.tran_teller_id is '交易柜员编号';
comment on column ${icl_schema}.cmm_out_remit_dtl.tran_org_name is '交易机构名称';
comment on column ${icl_schema}.cmm_out_remit_dtl.tran_org_id is '交易机构编号';
comment on column ${icl_schema}.cmm_out_remit_dtl.belong_org_id is '所属机构编号';
comment on column ${icl_schema}.cmm_out_remit_dtl.clear_bk_bic is '清算行BIC';
comment on column ${icl_schema}.cmm_out_remit_dtl.inter_bank_bic is '中间行BIC';
comment on column ${icl_schema}.cmm_out_remit_dtl.recv_bank_bic is '收款行BIC';
comment on column ${icl_schema}.cmm_out_remit_dtl.msg_info_1 is '报文信息1';
comment on column ${icl_schema}.cmm_out_remit_dtl.msg_info_2 is '报文信息2';
comment on column ${icl_schema}.cmm_out_remit_dtl.fee_amt is '费用金额';
comment on column ${icl_schema}.cmm_out_remit_dtl.usd_fee_amt is '折美元费用金额';
comment on column ${icl_schema}.cmm_out_remit_dtl.usd_tran_amt is '折美元交易金额';
comment on column ${icl_schema}.cmm_out_remit_dtl.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_out_remit_dtl.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_out_remit_dtl.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_out_remit_dtl.etl_timestamp is 'ETL处理时间戳';
