/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_amend
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_amend
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_amend purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_amend(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,after_val varchar2(3000) -- 变更后值
    ,amend_batch_no varchar2(50) -- 变更批次号
    ,amend_busi_sort varchar2(1) -- 变更业务分类
    ,amend_key varchar2(30) -- 变更内容的关键值
    ,amend_seq_no varchar2(50) -- 变更序号
    ,amend_type varchar2(10) -- 账户变更类型
    ,appr_flag varchar2(1) -- 复核标志
    ,before_val varchar2(3000) -- 变更前值
    ,before_val1 varchar2(3000) -- 变更前值1
    ,company varchar2(20) -- 法人
    ,narrative varchar2(400) -- 摘要
    ,amend_item varchar2(30) -- 修改项
    ,amend_date date -- 变更日期
    ,approval_date date -- 复核日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,appr_user_id varchar2(8) -- 复核柜员
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
grant select on ${iol_schema}.ncbs_rb_amend to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_amend to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_amend to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_amend to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_amend is '业务信息变更操作记录';
comment on column ${iol_schema}.ncbs_rb_amend.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_amend.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_amend.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_amend.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_amend.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_amend.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_amend.after_val is '变更后值';
comment on column ${iol_schema}.ncbs_rb_amend.amend_batch_no is '变更批次号';
comment on column ${iol_schema}.ncbs_rb_amend.amend_busi_sort is '变更业务分类';
comment on column ${iol_schema}.ncbs_rb_amend.amend_key is '变更内容的关键值';
comment on column ${iol_schema}.ncbs_rb_amend.amend_seq_no is '变更序号';
comment on column ${iol_schema}.ncbs_rb_amend.amend_type is '账户变更类型';
comment on column ${iol_schema}.ncbs_rb_amend.appr_flag is '复核标志';
comment on column ${iol_schema}.ncbs_rb_amend.before_val is '变更前值';
comment on column ${iol_schema}.ncbs_rb_amend.before_val1 is '变更前值1';
comment on column ${iol_schema}.ncbs_rb_amend.company is '法人';
comment on column ${iol_schema}.ncbs_rb_amend.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_amend.amend_item is '修改项';
comment on column ${iol_schema}.ncbs_rb_amend.amend_date is '变更日期';
comment on column ${iol_schema}.ncbs_rb_amend.approval_date is '复核日期';
comment on column ${iol_schema}.ncbs_rb_amend.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_amend.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_amend.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_rb_amend.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_amend.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_amend.etl_timestamp is 'ETL处理时间戳';
