/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_pledge_disposal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_pledge_disposal
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_pledge_disposal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_pledge_disposal(
    branch varchar2(12) -- 机构编号
    ,client_no varchar2(16) -- 客户编号
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,disposal_cd_seq_no varchar2(5) -- 处置存单序号
    ,disposal_seq_no varchar2(50) -- 处置序号
    ,dispose_acct_no varchar2(50) -- 处置入账账号
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,compensate_amt number(17,2) -- 保函冻结金额
    ,disposal_cd_ccy varchar2(3) -- 处置存单币种
    ,disposal_cd_prod_type varchar2(12) -- 处置存单产品类型
    ,dispose_account_amt number(17,2) -- 处置入账金额
    ,dispose_after_bal number(17,2) -- 处置后账户余额
    ,dispose_amount number(17,2) -- 处置金额
    ,dispose_cd_acct_no varchar2(50) -- 处置存单编号
    ,loan_no varchar2(50) -- 贷款号
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
grant select on ${iol_schema}.ncbs_cl_pledge_disposal to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_pledge_disposal to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_pledge_disposal to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_pledge_disposal to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_pledge_disposal is '贷款存单质押处置登记表';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.branch is '机构编号';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.company is '法人';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.disposal_cd_seq_no is '处置存单序号';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.disposal_seq_no is '处置序号';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.dispose_acct_no is '处置入账账号';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.compensate_amt is '保函冻结金额';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.disposal_cd_ccy is '处置存单币种';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.disposal_cd_prod_type is '处置存单产品类型';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.dispose_account_amt is '处置入账金额';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.dispose_after_bal is '处置后账户余额';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.dispose_amount is '处置金额';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.dispose_cd_acct_no is '处置存单编号';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_pledge_disposal.etl_timestamp is 'ETL处理时间戳';
