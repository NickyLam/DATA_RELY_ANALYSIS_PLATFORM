/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_cc_asscontcorres
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_cc_asscontcorres
whenever sqlerror continue none;
drop table ${iol_schema}.mims_cc_asscontcorres purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_cc_asscontcorres(
    contno varchar2(150) -- 
    ,asscontno varchar2(75) -- 
    ,assconttype varchar2(2) -- 
    ,useassamt number(16,2) -- 
    ,useasscurrency varchar2(5) -- 
    ,state varchar2(2) -- 
    ,state2 varchar2(2) -- 
    ,iscopy varchar2(2) -- 
    ,datasourceflag varchar2(2) -- 
    ,barsign varchar2(2) -- 
    ,contype varchar2(2) -- 
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
grant select on ${iol_schema}.mims_cc_asscontcorres to ${iml_schema};
grant select on ${iol_schema}.mims_cc_asscontcorres to ${icl_schema};
grant select on ${iol_schema}.mims_cc_asscontcorres to ${idl_schema};
grant select on ${iol_schema}.mims_cc_asscontcorres to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_cc_asscontcorres is '';
comment on column ${iol_schema}.mims_cc_asscontcorres.contno is '';
comment on column ${iol_schema}.mims_cc_asscontcorres.asscontno is '';
comment on column ${iol_schema}.mims_cc_asscontcorres.assconttype is '';
comment on column ${iol_schema}.mims_cc_asscontcorres.useassamt is '';
comment on column ${iol_schema}.mims_cc_asscontcorres.useasscurrency is '';
comment on column ${iol_schema}.mims_cc_asscontcorres.state is '';
comment on column ${iol_schema}.mims_cc_asscontcorres.state2 is '';
comment on column ${iol_schema}.mims_cc_asscontcorres.iscopy is '';
comment on column ${iol_schema}.mims_cc_asscontcorres.datasourceflag is '';
comment on column ${iol_schema}.mims_cc_asscontcorres.barsign is '';
comment on column ${iol_schema}.mims_cc_asscontcorres.contype is '';
comment on column ${iol_schema}.mims_cc_asscontcorres.start_dt is '开始时间';
comment on column ${iol_schema}.mims_cc_asscontcorres.end_dt is '结束时间';
comment on column ${iol_schema}.mims_cc_asscontcorres.id_mark is '增删标志';
comment on column ${iol_schema}.mims_cc_asscontcorres.etl_timestamp is 'ETL处理时间戳';
