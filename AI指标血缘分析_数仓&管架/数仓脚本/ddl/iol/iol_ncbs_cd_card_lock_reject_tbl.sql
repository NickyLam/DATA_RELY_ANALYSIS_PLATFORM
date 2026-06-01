/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cd_card_lock_reject_tbl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cd_card_lock_reject_tbl
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cd_card_lock_reject_tbl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cd_card_lock_reject_tbl(
    base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,tran_type varchar2(10) -- 交易类型
    ,company varchar2(20) -- 法人
    ,lock_type varchar2(1) -- 锁类型
    ,seq_no varchar2(50) -- 序号
    ,source_type varchar2(6) -- 渠道编号
    ,tran_desc varchar2(200) -- 交易描述
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,tran_amt number(17,2) -- 交易金额
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
grant select on ${iol_schema}.ncbs_cd_card_lock_reject_tbl to ${iml_schema};
grant select on ${iol_schema}.ncbs_cd_card_lock_reject_tbl to ${icl_schema};
grant select on ${iol_schema}.ncbs_cd_card_lock_reject_tbl to ${idl_schema};
grant select on ${iol_schema}.ncbs_cd_card_lock_reject_tbl to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cd_card_lock_reject_tbl is '安全锁拒绝交易信息表';
comment on column ${iol_schema}.ncbs_cd_card_lock_reject_tbl.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_cd_card_lock_reject_tbl.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cd_card_lock_reject_tbl.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_cd_card_lock_reject_tbl.company is '法人';
comment on column ${iol_schema}.ncbs_cd_card_lock_reject_tbl.lock_type is '锁类型';
comment on column ${iol_schema}.ncbs_cd_card_lock_reject_tbl.seq_no is '序号';
comment on column ${iol_schema}.ncbs_cd_card_lock_reject_tbl.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_cd_card_lock_reject_tbl.tran_desc is '交易描述';
comment on column ${iol_schema}.ncbs_cd_card_lock_reject_tbl.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cd_card_lock_reject_tbl.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cd_card_lock_reject_tbl.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_cd_card_lock_reject_tbl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cd_card_lock_reject_tbl.etl_timestamp is 'ETL处理时间戳';
