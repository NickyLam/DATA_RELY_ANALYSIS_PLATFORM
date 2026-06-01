/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cd_card_lock_tbl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cd_card_lock_tbl
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cd_card_lock_tbl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cd_card_lock_tbl(
    base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,common_province1 varchar2(50) -- 常用省份1
    ,common_province2 varchar2(50) -- 常用省份2
    ,common_province3 varchar2(50) -- 常用省份3
    ,common_province4 varchar2(50) -- 常用省份4
    ,common_province5 varchar2(50) -- 常用省份5
    ,company varchar2(20) -- 法人
    ,lock_flag varchar2(1) -- 锁标志
    ,lock_type varchar2(1) -- 锁类型
    ,end_date date -- 结束日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_cd_card_lock_tbl to ${iml_schema};
grant select on ${iol_schema}.ncbs_cd_card_lock_tbl to ${icl_schema};
grant select on ${iol_schema}.ncbs_cd_card_lock_tbl to ${idl_schema};
grant select on ${iol_schema}.ncbs_cd_card_lock_tbl to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cd_card_lock_tbl is '安全锁信息表';
comment on column ${iol_schema}.ncbs_cd_card_lock_tbl.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_cd_card_lock_tbl.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cd_card_lock_tbl.common_province1 is '常用省份1';
comment on column ${iol_schema}.ncbs_cd_card_lock_tbl.common_province2 is '常用省份2';
comment on column ${iol_schema}.ncbs_cd_card_lock_tbl.common_province3 is '常用省份3';
comment on column ${iol_schema}.ncbs_cd_card_lock_tbl.common_province4 is '常用省份4';
comment on column ${iol_schema}.ncbs_cd_card_lock_tbl.common_province5 is '常用省份5';
comment on column ${iol_schema}.ncbs_cd_card_lock_tbl.company is '法人';
comment on column ${iol_schema}.ncbs_cd_card_lock_tbl.lock_flag is '锁标志';
comment on column ${iol_schema}.ncbs_cd_card_lock_tbl.lock_type is '锁类型';
comment on column ${iol_schema}.ncbs_cd_card_lock_tbl.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_cd_card_lock_tbl.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_cd_card_lock_tbl.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cd_card_lock_tbl.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cd_card_lock_tbl.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cd_card_lock_tbl.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cd_card_lock_tbl.etl_timestamp is 'ETL处理时间戳';
