/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_guacreditapply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_guacreditapply
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_guacreditapply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_guacreditapply(
    applycode varchar2(75) -- 
    ,sccode varchar2(48) -- 
    ,seqno varchar2(75) -- 
    ,startdate varchar2(45) -- 
    ,state varchar2(2) -- 
    ,isrelease varchar2(2) -- 
    ,datasourceflag varchar2(2) -- 
    ,status varchar2(2) -- 
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
grant select on ${iol_schema}.mims_si_guacreditapply to ${iml_schema};
grant select on ${iol_schema}.mims_si_guacreditapply to ${icl_schema};
grant select on ${iol_schema}.mims_si_guacreditapply to ${idl_schema};
grant select on ${iol_schema}.mims_si_guacreditapply to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_guacreditapply is '押品和授信申请对应表';
comment on column ${iol_schema}.mims_si_guacreditapply.applycode is '';
comment on column ${iol_schema}.mims_si_guacreditapply.sccode is '';
comment on column ${iol_schema}.mims_si_guacreditapply.seqno is '';
comment on column ${iol_schema}.mims_si_guacreditapply.startdate is '';
comment on column ${iol_schema}.mims_si_guacreditapply.state is '';
comment on column ${iol_schema}.mims_si_guacreditapply.isrelease is '';
comment on column ${iol_schema}.mims_si_guacreditapply.datasourceflag is '';
comment on column ${iol_schema}.mims_si_guacreditapply.status is '';
comment on column ${iol_schema}.mims_si_guacreditapply.barsign is '';
comment on column ${iol_schema}.mims_si_guacreditapply.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_guacreditapply.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_guacreditapply.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_guacreditapply.etl_timestamp is 'ETL处理时间戳';
