/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08tccpcinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08tccpcinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08tccpcinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tccpcinfo(
    ccpccd varchar2(6) -- 
    ,ccpcrunsts varchar2(3) -- 
    ,ccpcnm varchar2(105) -- 
    ,ccpctp varchar2(6) -- 
    ,ccpccitycd varchar2(9) -- 
    ,chngnb varchar2(12) -- 
    ,syscd varchar2(6) -- 
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
grant select on ${iol_schema}.mpcs_a08tccpcinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08tccpcinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08tccpcinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08tccpcinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08tccpcinfo is '节点信息表';
comment on column ${iol_schema}.mpcs_a08tccpcinfo.ccpccd is '';
comment on column ${iol_schema}.mpcs_a08tccpcinfo.ccpcrunsts is '';
comment on column ${iol_schema}.mpcs_a08tccpcinfo.ccpcnm is '';
comment on column ${iol_schema}.mpcs_a08tccpcinfo.ccpctp is '';
comment on column ${iol_schema}.mpcs_a08tccpcinfo.ccpccitycd is '';
comment on column ${iol_schema}.mpcs_a08tccpcinfo.chngnb is '';
comment on column ${iol_schema}.mpcs_a08tccpcinfo.syscd is '';
comment on column ${iol_schema}.mpcs_a08tccpcinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a08tccpcinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a08tccpcinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a08tccpcinfo.etl_timestamp is 'ETL处理时间戳';
