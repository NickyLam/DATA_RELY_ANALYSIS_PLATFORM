/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_cc_guarcorres
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_cc_guarcorres
whenever sqlerror continue none;
drop table ${iol_schema}.mims_cc_guarcorres purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_cc_guarcorres(
    guarno varchar2(48) -- 
    ,bussno varchar2(75) -- 
    ,assconttype varchar2(2) -- 
    ,period varchar2(3) -- 
    ,useassamt number(16,2) -- 
    ,useasscurrency varchar2(5) -- 
    ,state varchar2(2) -- 
    ,state2 varchar2(2) -- 
    ,guarrate number(16,2) -- 
    ,adguarrate number(16,2) -- 
    ,mainguartype varchar2(2) -- 
    ,isimp varchar2(2) -- 
    ,guarorder varchar2(2) -- 
    ,guardate number(22) -- 
    ,guarvalue number(16,2) -- 
    ,datasourceflag varchar2(2) -- 
    ,startdate varchar2(15) -- 
    ,barsign varchar2(2) -- 
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
grant select on ${iol_schema}.mims_cc_guarcorres to ${iml_schema};
grant select on ${iol_schema}.mims_cc_guarcorres to ${icl_schema};
grant select on ${iol_schema}.mims_cc_guarcorres to ${idl_schema};
grant select on ${iol_schema}.mims_cc_guarcorres to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_cc_guarcorres is '';
comment on column ${iol_schema}.mims_cc_guarcorres.guarno is '';
comment on column ${iol_schema}.mims_cc_guarcorres.bussno is '';
comment on column ${iol_schema}.mims_cc_guarcorres.assconttype is '';
comment on column ${iol_schema}.mims_cc_guarcorres.period is '';
comment on column ${iol_schema}.mims_cc_guarcorres.useassamt is '';
comment on column ${iol_schema}.mims_cc_guarcorres.useasscurrency is '';
comment on column ${iol_schema}.mims_cc_guarcorres.state is '';
comment on column ${iol_schema}.mims_cc_guarcorres.state2 is '';
comment on column ${iol_schema}.mims_cc_guarcorres.guarrate is '';
comment on column ${iol_schema}.mims_cc_guarcorres.adguarrate is '';
comment on column ${iol_schema}.mims_cc_guarcorres.mainguartype is '';
comment on column ${iol_schema}.mims_cc_guarcorres.isimp is '';
comment on column ${iol_schema}.mims_cc_guarcorres.guarorder is '';
comment on column ${iol_schema}.mims_cc_guarcorres.guardate is '';
comment on column ${iol_schema}.mims_cc_guarcorres.guarvalue is '';
comment on column ${iol_schema}.mims_cc_guarcorres.datasourceflag is '';
comment on column ${iol_schema}.mims_cc_guarcorres.startdate is '';
comment on column ${iol_schema}.mims_cc_guarcorres.barsign is '';
comment on column ${iol_schema}.mims_cc_guarcorres.start_dt is '开始时间';
comment on column ${iol_schema}.mims_cc_guarcorres.end_dt is '结束时间';
comment on column ${iol_schema}.mims_cc_guarcorres.id_mark is '增删标志';
comment on column ${iol_schema}.mims_cc_guarcorres.etl_timestamp is 'ETL处理时间戳';
