/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_guarwarranthistoryt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_guarwarranthistoryt
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_guarwarranthistoryt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_guarwarranthistoryt(
    seqno varchar2(45) -- 
    ,sccode varchar2(48) -- 
    ,occurdate varchar2(15) -- 
    ,businesstype varchar2(3) -- 
    ,remarks varchar2(3000) -- 
    ,businessno varchar2(45) -- 
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
grant select on ${iol_schema}.mims_si_guarwarranthistoryt to ${iml_schema};
grant select on ${iol_schema}.mims_si_guarwarranthistoryt to ${icl_schema};
grant select on ${iol_schema}.mims_si_guarwarranthistoryt to ${idl_schema};
grant select on ${iol_schema}.mims_si_guarwarranthistoryt to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_guarwarranthistoryt is '权证历史变动轨迹';
comment on column ${iol_schema}.mims_si_guarwarranthistoryt.seqno is '';
comment on column ${iol_schema}.mims_si_guarwarranthistoryt.sccode is '';
comment on column ${iol_schema}.mims_si_guarwarranthistoryt.occurdate is '';
comment on column ${iol_schema}.mims_si_guarwarranthistoryt.businesstype is '';
comment on column ${iol_schema}.mims_si_guarwarranthistoryt.remarks is '';
comment on column ${iol_schema}.mims_si_guarwarranthistoryt.businessno is '';
comment on column ${iol_schema}.mims_si_guarwarranthistoryt.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_guarwarranthistoryt.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_guarwarranthistoryt.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_guarwarranthistoryt.etl_timestamp is 'ETL处理时间戳';
