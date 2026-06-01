/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_pcp_agreement_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_pcp_agreement_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_pcp_agreement_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pcp_agreement_hist(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,agreement_id varchar2(50) -- 协议编号
    ,agreement_operate_type varchar2(2) -- 协议操作类型
    ,company varchar2(20) -- 法人
    ,pcp_group_id varchar2(30) -- 资金池账户组id
    ,program_id varchar2(20) -- 交易代码
    ,seq_no varchar2(50) -- 序号
    ,source_type varchar2(6) -- 渠道编号
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,appr_user_id varchar2(8) -- 复核柜员
    ,auth_user_id varchar2(8) -- 授权柜员
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_rb_pcp_agreement_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_agreement_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_agreement_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_agreement_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_pcp_agreement_hist is '现金池签约维护解约流水表';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement_hist.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement_hist.agreement_operate_type is '协议操作类型';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement_hist.pcp_group_id is '资金池账户组id';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement_hist.program_id is '交易代码';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement_hist.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement_hist.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement_hist.etl_timestamp is 'ETL处理时间戳';
