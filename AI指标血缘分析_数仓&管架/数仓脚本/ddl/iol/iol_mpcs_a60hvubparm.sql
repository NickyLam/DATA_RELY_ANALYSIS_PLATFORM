/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a60hvubparm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a60hvubparm
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a60hvubparm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a60hvubparm(
    brnalias varchar2(18) -- 
    ,brnlevel varchar2(2) -- 
    ,ownbrn varchar2(9) -- 
    ,brnname varchar2(90) -- 
    ,brn varchar2(18) -- 
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
grant select on ${iol_schema}.mpcs_a60hvubparm to ${iml_schema};
grant select on ${iol_schema}.mpcs_a60hvubparm to ${icl_schema};
grant select on ${iol_schema}.mpcs_a60hvubparm to ${idl_schema};
grant select on ${iol_schema}.mpcs_a60hvubparm to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a60hvubparm is '';
comment on column ${iol_schema}.mpcs_a60hvubparm.brnalias is '';
comment on column ${iol_schema}.mpcs_a60hvubparm.brnlevel is '';
comment on column ${iol_schema}.mpcs_a60hvubparm.ownbrn is '';
comment on column ${iol_schema}.mpcs_a60hvubparm.brnname is '';
comment on column ${iol_schema}.mpcs_a60hvubparm.brn is '';
comment on column ${iol_schema}.mpcs_a60hvubparm.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a60hvubparm.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a60hvubparm.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a60hvubparm.etl_timestamp is 'ETL处理时间戳';
