/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_counter_party
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_counter_party
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_counter_party purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_counter_party(
    company varchar2(20) -- 法人
    ,counter_party varchar2(10) -- 对手
    ,counter_party_desc varchar2(50) -- 对手描述
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
grant select on ${iol_schema}.ncbs_fm_counter_party to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_counter_party to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_counter_party to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_counter_party to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_counter_party is '交易对手定义表';
comment on column ${iol_schema}.ncbs_fm_counter_party.company is '法人';
comment on column ${iol_schema}.ncbs_fm_counter_party.counter_party is '对手';
comment on column ${iol_schema}.ncbs_fm_counter_party.counter_party_desc is '对手描述';
comment on column ${iol_schema}.ncbs_fm_counter_party.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_counter_party.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_counter_party.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_counter_party.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_counter_party.etl_timestamp is 'ETL处理时间戳';
