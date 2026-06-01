/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbsysarg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbsysarg
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbsysarg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbsysarg(
    seller_code varchar2(14) -- 
    ,bank_name varchar2(375) -- 
    ,system_name varchar2(375) -- 
    ,bank_short_name varchar2(30) -- 
    ,prev_date number(22) -- 
    ,init_date number(22) -- 
    ,host_check_date number(22) -- 
    ,rights varchar2(75) -- 
    ,unfrozen_flag varchar2(2) -- 
    ,holddays number(22) -- 
    ,status varchar2(2) -- 
    ,befbkup_date number(22) -- 
    ,aftbkup_date number(22) -- 
    ,hisbkup_date number(22) -- 
    ,fstunloadbeg_date number(22) -- 
    ,sharechg_days number(22) -- 
    ,reserve1 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbsysarg to ${iml_schema};
grant select on ${iol_schema}.ifms_tbsysarg to ${icl_schema};
grant select on ${iol_schema}.ifms_tbsysarg to ${idl_schema};
grant select on ${iol_schema}.ifms_tbsysarg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbsysarg is '系统参数表';
comment on column ${iol_schema}.ifms_tbsysarg.seller_code is '';
comment on column ${iol_schema}.ifms_tbsysarg.bank_name is '';
comment on column ${iol_schema}.ifms_tbsysarg.system_name is '';
comment on column ${iol_schema}.ifms_tbsysarg.bank_short_name is '';
comment on column ${iol_schema}.ifms_tbsysarg.prev_date is '';
comment on column ${iol_schema}.ifms_tbsysarg.init_date is '';
comment on column ${iol_schema}.ifms_tbsysarg.host_check_date is '';
comment on column ${iol_schema}.ifms_tbsysarg.rights is '';
comment on column ${iol_schema}.ifms_tbsysarg.unfrozen_flag is '';
comment on column ${iol_schema}.ifms_tbsysarg.holddays is '';
comment on column ${iol_schema}.ifms_tbsysarg.status is '';
comment on column ${iol_schema}.ifms_tbsysarg.befbkup_date is '';
comment on column ${iol_schema}.ifms_tbsysarg.aftbkup_date is '';
comment on column ${iol_schema}.ifms_tbsysarg.hisbkup_date is '';
comment on column ${iol_schema}.ifms_tbsysarg.fstunloadbeg_date is '';
comment on column ${iol_schema}.ifms_tbsysarg.sharechg_days is '';
comment on column ${iol_schema}.ifms_tbsysarg.reserve1 is '';
comment on column ${iol_schema}.ifms_tbsysarg.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbsysarg.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbsysarg.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbsysarg.etl_timestamp is 'ETL处理时间戳';
