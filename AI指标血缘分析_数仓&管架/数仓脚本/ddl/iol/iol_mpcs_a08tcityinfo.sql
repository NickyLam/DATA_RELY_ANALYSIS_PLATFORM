/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08tcityinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08tcityinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08tcityinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tcityinfo(
    citycd varchar2(9) -- 
    ,citynm varchar2(105) -- 
    ,citytp varchar2(24) -- 
    ,cityndcd varchar2(6) -- 
    ,chngnb varchar2(12) -- 
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
grant select on ${iol_schema}.mpcs_a08tcityinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08tcityinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08tcityinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08tcityinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08tcityinfo is '城市信息表';
comment on column ${iol_schema}.mpcs_a08tcityinfo.citycd is '';
comment on column ${iol_schema}.mpcs_a08tcityinfo.citynm is '';
comment on column ${iol_schema}.mpcs_a08tcityinfo.citytp is '';
comment on column ${iol_schema}.mpcs_a08tcityinfo.cityndcd is '';
comment on column ${iol_schema}.mpcs_a08tcityinfo.chngnb is '';
comment on column ${iol_schema}.mpcs_a08tcityinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a08tcityinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a08tcityinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a08tcityinfo.etl_timestamp is 'ETL处理时间戳';
