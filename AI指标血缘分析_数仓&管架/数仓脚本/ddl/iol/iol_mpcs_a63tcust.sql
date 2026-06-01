/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a63tcust
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a63tcust
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a63tcust purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a63tcust(
    custno varchar2(30) -- 
    ,custname varchar2(384) -- 
    ,signno varchar2(38) -- 
    ,signdt varchar2(12) -- 
    ,custbrcno varchar2(15) -- 
    ,openbrcno varchar2(15) -- 
    ,idtype varchar2(6) -- 
    ,idno varchar2(60) -- 
    ,stat varchar2(2) -- 状态:0-正常，1-注销，2-暂停
    ,trnts timestamp -- 
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
grant select on ${iol_schema}.mpcs_a63tcust to ${iml_schema};
grant select on ${iol_schema}.mpcs_a63tcust to ${icl_schema};
grant select on ${iol_schema}.mpcs_a63tcust to ${idl_schema};
grant select on ${iol_schema}.mpcs_a63tcust to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a63tcust is '客户签约信息表';
comment on column ${iol_schema}.mpcs_a63tcust.custno is '';
comment on column ${iol_schema}.mpcs_a63tcust.custname is '';
comment on column ${iol_schema}.mpcs_a63tcust.signno is '';
comment on column ${iol_schema}.mpcs_a63tcust.signdt is '';
comment on column ${iol_schema}.mpcs_a63tcust.custbrcno is '';
comment on column ${iol_schema}.mpcs_a63tcust.openbrcno is '';
comment on column ${iol_schema}.mpcs_a63tcust.idtype is '';
comment on column ${iol_schema}.mpcs_a63tcust.idno is '';
comment on column ${iol_schema}.mpcs_a63tcust.stat is '状态:0-正常，1-注销，2-暂停';
comment on column ${iol_schema}.mpcs_a63tcust.trnts is '';
comment on column ${iol_schema}.mpcs_a63tcust.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a63tcust.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a63tcust.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a63tcust.etl_timestamp is 'ETL处理时间戳';
