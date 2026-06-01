/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a60datadict
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a60datadict
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a60datadict purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a60datadict(
    name varchar2(384) -- 字典名称
    ,key varchar2(192) -- 字典key
    ,value varchar2(384) -- 字典值
    ,stat varchar2(2) -- 状态0-无效1-有效
    ,reserve1 varchar2(48) -- 预留1
    ,reserve2 varchar2(96) -- 预留2
    ,reserve3 varchar2(192) -- 预留3
    ,reserve4 varchar2(384) -- 预留4
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
grant select on ${iol_schema}.mpcs_a60datadict to ${iml_schema};
grant select on ${iol_schema}.mpcs_a60datadict to ${icl_schema};
grant select on ${iol_schema}.mpcs_a60datadict to ${idl_schema};
grant select on ${iol_schema}.mpcs_a60datadict to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a60datadict is '数据字典表';
comment on column ${iol_schema}.mpcs_a60datadict.name is '字典名称';
comment on column ${iol_schema}.mpcs_a60datadict.key is '字典key';
comment on column ${iol_schema}.mpcs_a60datadict.value is '字典值';
comment on column ${iol_schema}.mpcs_a60datadict.stat is '状态0-无效1-有效';
comment on column ${iol_schema}.mpcs_a60datadict.reserve1 is '预留1';
comment on column ${iol_schema}.mpcs_a60datadict.reserve2 is '预留2';
comment on column ${iol_schema}.mpcs_a60datadict.reserve3 is '预留3';
comment on column ${iol_schema}.mpcs_a60datadict.reserve4 is '预留4';
comment on column ${iol_schema}.mpcs_a60datadict.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a60datadict.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a60datadict.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a60datadict.etl_timestamp is 'ETL处理时间戳';
