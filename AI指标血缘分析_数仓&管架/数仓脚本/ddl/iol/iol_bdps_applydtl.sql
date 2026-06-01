/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_applydtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_applydtl
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_applydtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_applydtl(
    id number(22) -- 
    ,transno varchar2(135) -- 
    ,appno varchar2(45) -- 
    ,txdate varchar2(12) -- 
    ,brhno varchar2(30) -- 
    ,oprno varchar2(30) -- 
    ,tlsrno varchar2(14) -- 
    ,txtime varchar2(38) -- 
    ,func_code varchar2(33) -- 
    ,buss_type varchar2(6) -- 
    ,attitude varchar2(75) -- 
    ,role_id number(22) -- 
    ,role_type varchar2(2) -- 
    ,reason varchar2(1536) -- 
    ,timestamps timestamp -- 
    ,miscflgs varchar2(30) -- 
    ,misc varchar2(1536) -- 
    ,last_upd_time varchar2(21) -- 
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
grant select on ${iol_schema}.bdps_applydtl to ${iml_schema};
grant select on ${iol_schema}.bdps_applydtl to ${icl_schema};
grant select on ${iol_schema}.bdps_applydtl to ${idl_schema};
grant select on ${iol_schema}.bdps_applydtl to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_applydtl is '审批意见明细表';
comment on column ${iol_schema}.bdps_applydtl.id is '';
comment on column ${iol_schema}.bdps_applydtl.transno is '';
comment on column ${iol_schema}.bdps_applydtl.appno is '';
comment on column ${iol_schema}.bdps_applydtl.txdate is '';
comment on column ${iol_schema}.bdps_applydtl.brhno is '';
comment on column ${iol_schema}.bdps_applydtl.oprno is '';
comment on column ${iol_schema}.bdps_applydtl.tlsrno is '';
comment on column ${iol_schema}.bdps_applydtl.txtime is '';
comment on column ${iol_schema}.bdps_applydtl.func_code is '';
comment on column ${iol_schema}.bdps_applydtl.buss_type is '';
comment on column ${iol_schema}.bdps_applydtl.attitude is '';
comment on column ${iol_schema}.bdps_applydtl.role_id is '';
comment on column ${iol_schema}.bdps_applydtl.role_type is '';
comment on column ${iol_schema}.bdps_applydtl.reason is '';
comment on column ${iol_schema}.bdps_applydtl.timestamps is '';
comment on column ${iol_schema}.bdps_applydtl.miscflgs is '';
comment on column ${iol_schema}.bdps_applydtl.misc is '';
comment on column ${iol_schema}.bdps_applydtl.last_upd_time is '';
comment on column ${iol_schema}.bdps_applydtl.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_applydtl.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_applydtl.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_applydtl.etl_timestamp is 'ETL处理时间戳';
