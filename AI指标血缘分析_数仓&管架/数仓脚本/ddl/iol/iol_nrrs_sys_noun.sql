/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nrrs_sys_noun
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nrrs_sys_noun
whenever sqlerror continue none;
drop table ${iol_schema}.nrrs_sys_noun purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_sys_noun(
    nounid varchar2(20) -- 编号
    ,nounsuper varchar2(20) -- 上级
    ,nounlevel number(22,0) -- 级别
    ,nounleaf varchar2(1) -- 叶子
    ,nounorder number(22,0) -- 顺序
    ,nounvalidity varchar2(1) -- 有效性
    ,nounname varchar2(1000) -- 名称
    ,nounvalue varchar2(100) -- 代码
    ,nounremarks varchar2(100) -- 备注
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
grant select on ${iol_schema}.nrrs_sys_noun to ${iml_schema};
grant select on ${iol_schema}.nrrs_sys_noun to ${icl_schema};
grant select on ${iol_schema}.nrrs_sys_noun to ${idl_schema};
grant select on ${iol_schema}.nrrs_sys_noun to ${iel_schema};

-- comment
comment on table ${iol_schema}.nrrs_sys_noun is '系统名词表';
comment on column ${iol_schema}.nrrs_sys_noun.nounid is '编号';
comment on column ${iol_schema}.nrrs_sys_noun.nounsuper is '上级';
comment on column ${iol_schema}.nrrs_sys_noun.nounlevel is '级别';
comment on column ${iol_schema}.nrrs_sys_noun.nounleaf is '叶子';
comment on column ${iol_schema}.nrrs_sys_noun.nounorder is '顺序';
comment on column ${iol_schema}.nrrs_sys_noun.nounvalidity is '有效性';
comment on column ${iol_schema}.nrrs_sys_noun.nounname is '名称';
comment on column ${iol_schema}.nrrs_sys_noun.nounvalue is '代码';
comment on column ${iol_schema}.nrrs_sys_noun.nounremarks is '备注';
comment on column ${iol_schema}.nrrs_sys_noun.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nrrs_sys_noun.etl_timestamp is 'ETL处理时间戳';
