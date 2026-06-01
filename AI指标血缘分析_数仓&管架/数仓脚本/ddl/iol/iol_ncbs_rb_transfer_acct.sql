/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_transfer_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_transfer_acct
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_transfer_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_transfer_acct(
    base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,company varchar2(20) -- 法人
    ,td_inout_operate_type varchar2(2) -- 定期账户转入转出操作类型
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,in_seq_no varchar2(5) -- 转入账户序号
    ,oper_user_id varchar2(8) -- 操作柜员
    ,out_seq_no varchar2(5) -- 转出账户序号
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,transfer_in_after_acct varchar2(50) -- 移入后账号
    ,transfer_in_befor_acct varchar2(50) -- 移入前账号
    ,transfer_out_after_acct varchar2(50) -- 移出后账号
    ,transfer_out_before_acct varchar2(50) -- 移出前账号
    ,transfer_in_after_seq_no varchar2(5) -- 移入后账户序号
    ,transfer_out_before_seq_no varchar2(5) -- 移出前账户序号
    ,transfer_out_after_seq_no varchar2(5) -- 移出后账户序号
    ,transfer_in_befor_seq_no varchar2(5) -- 移入前账户序号
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
grant select on ${iol_schema}.ncbs_rb_transfer_acct to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_transfer_acct to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_transfer_acct to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_transfer_acct to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_transfer_acct is '子账户移入移出登记簿';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.company is '法人';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.td_inout_operate_type is '定期账户转入转出操作类型';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.in_seq_no is '转入账户序号';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.oper_user_id is '操作柜员';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.out_seq_no is '转出账户序号';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.transfer_in_after_acct is '移入后账号';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.transfer_in_befor_acct is '移入前账号';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.transfer_out_after_acct is '移出后账号';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.transfer_out_before_acct is '移出前账号';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.transfer_in_after_seq_no is '移入后账户序号';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.transfer_out_before_seq_no is '移出前账户序号';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.transfer_out_after_seq_no is '移出后账户序号';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.transfer_in_befor_seq_no is '移入前账户序号';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_transfer_acct.etl_timestamp is 'ETL处理时间戳';
