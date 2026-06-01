/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_state
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_state
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_state purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_state(
    country varchar2(3) -- 国家
    ,company varchar2(20) -- 法人
    ,state varchar2(6) -- 行政区划(省、州)
    ,state_desc varchar2(50) -- 省名称
    ,weekend1 varchar2(3) -- 周末1
    ,weekend2 varchar2(3) -- 周末2
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
grant select on ${iol_schema}.ncbs_fm_state to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_state to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_state to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_state to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_state is '省、州信息表';
comment on column ${iol_schema}.ncbs_fm_state.country is '国家';
comment on column ${iol_schema}.ncbs_fm_state.company is '法人';
comment on column ${iol_schema}.ncbs_fm_state.state is '行政区划(省、州)';
comment on column ${iol_schema}.ncbs_fm_state.state_desc is '省名称';
comment on column ${iol_schema}.ncbs_fm_state.weekend1 is '周末1';
comment on column ${iol_schema}.ncbs_fm_state.weekend2 is '周末2';
comment on column ${iol_schema}.ncbs_fm_state.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_state.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_state.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_state.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_state.etl_timestamp is 'ETL处理时间戳';
