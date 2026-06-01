/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbtransday
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbtransday
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbtransday purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbtransday(
    date_type varchar2(2) -- 
    ,asso_code varchar2(30) -- 
    ,trans_date number(22,0) -- 
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
grant select on ${iol_schema}.ifms_tbtransday to ${iml_schema};
grant select on ${iol_schema}.ifms_tbtransday to ${icl_schema};
grant select on ${iol_schema}.ifms_tbtransday to ${idl_schema};
grant select on ${iol_schema}.ifms_tbtransday to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbtransday is '';
comment on column ${iol_schema}.ifms_tbtransday.date_type is '';
comment on column ${iol_schema}.ifms_tbtransday.asso_code is '';
comment on column ${iol_schema}.ifms_tbtransday.trans_date is '';
comment on column ${iol_schema}.ifms_tbtransday.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbtransday.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbtransday.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbtransday.etl_timestamp is 'ETL处理时间戳';
