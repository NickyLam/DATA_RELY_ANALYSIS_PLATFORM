/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_appr_letter
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_appr_letter
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_appr_letter purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_appr_letter(
    client_no varchar2(16) -- 客户编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,acct_type_desc varchar2(400) -- 账户类型描述
    ,appr_acct_ind varchar2(2) -- 核准账户要项
    ,appr_letter_no varchar2(30) -- 核准件编号
    ,appr_type varchar2(10) -- 核准件类型
    ,company varchar2(20) -- 法人
    ,expend_scope varchar2(200) -- 支出范围
    ,fund_purpose varchar2(50) -- 资金用途
    ,fund_source varchar2(50) -- 资金来源
    ,income_scope varchar2(50) -- 收入范围
    ,narrative varchar2(400) -- 摘要
    ,maturity_date date -- 到期日期
    ,open_date date -- 开立日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,capital_amt number(17,2) -- 核准件开立金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,remark varchar2(600) -- 备注
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_rb_appr_letter to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_appr_letter to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_appr_letter to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_appr_letter to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_appr_letter is '核准件主表信息';
comment on column ${iol_schema}.ncbs_rb_appr_letter.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_appr_letter.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_appr_letter.acct_type_desc is '账户类型描述';
comment on column ${iol_schema}.ncbs_rb_appr_letter.appr_acct_ind is '核准账户要项';
comment on column ${iol_schema}.ncbs_rb_appr_letter.appr_letter_no is '核准件编号';
comment on column ${iol_schema}.ncbs_rb_appr_letter.appr_type is '核准件类型';
comment on column ${iol_schema}.ncbs_rb_appr_letter.company is '法人';
comment on column ${iol_schema}.ncbs_rb_appr_letter.expend_scope is '支出范围';
comment on column ${iol_schema}.ncbs_rb_appr_letter.fund_purpose is '资金用途';
comment on column ${iol_schema}.ncbs_rb_appr_letter.fund_source is '资金来源';
comment on column ${iol_schema}.ncbs_rb_appr_letter.income_scope is '收入范围';
comment on column ${iol_schema}.ncbs_rb_appr_letter.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_appr_letter.maturity_date is '到期日期';
comment on column ${iol_schema}.ncbs_rb_appr_letter.open_date is '开立日期';
comment on column ${iol_schema}.ncbs_rb_appr_letter.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_appr_letter.capital_amt is '核准件开立金额';
comment on column ${iol_schema}.ncbs_rb_appr_letter.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_appr_letter.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_appr_letter.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_appr_letter.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_appr_letter.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_appr_letter.etl_timestamp is 'ETL处理时间戳';
