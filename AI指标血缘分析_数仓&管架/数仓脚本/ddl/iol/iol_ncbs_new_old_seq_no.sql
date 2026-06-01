/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_new_old_seq_no
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_new_old_seq_no
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_new_old_seq_no purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_new_old_seq_no(
    internal_key number(15,0) -- 
    ,base_acct_no varchar2(200) -- 
    ,card_no varchar2(200) -- 
    ,acct_seq_no varchar2(20) -- 
    ,acct_ccy varchar2(12) -- 
    ,prod_type varchar2(80) -- 
    ,acct_id varchar2(40) -- 
    ,acct_seq_no_o varchar2(20) -- 
    ,tran_timestamp varchar2(52) -- 
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
grant select on ${iol_schema}.ncbs_new_old_seq_no to ${iml_schema};
grant select on ${iol_schema}.ncbs_new_old_seq_no to ${icl_schema};
grant select on ${iol_schema}.ncbs_new_old_seq_no to ${idl_schema};
grant select on ${iol_schema}.ncbs_new_old_seq_no to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_new_old_seq_no is '核心静态表数仓不跑批';
comment on column ${iol_schema}.ncbs_new_old_seq_no.internal_key is '';
comment on column ${iol_schema}.ncbs_new_old_seq_no.base_acct_no is '';
comment on column ${iol_schema}.ncbs_new_old_seq_no.card_no is '';
comment on column ${iol_schema}.ncbs_new_old_seq_no.acct_seq_no is '';
comment on column ${iol_schema}.ncbs_new_old_seq_no.acct_ccy is '';
comment on column ${iol_schema}.ncbs_new_old_seq_no.prod_type is '';
comment on column ${iol_schema}.ncbs_new_old_seq_no.acct_id is '';
comment on column ${iol_schema}.ncbs_new_old_seq_no.acct_seq_no_o is '';
comment on column ${iol_schema}.ncbs_new_old_seq_no.tran_timestamp is '';
comment on column ${iol_schema}.ncbs_new_old_seq_no.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_new_old_seq_no.etl_timestamp is 'ETL处理时间戳';
