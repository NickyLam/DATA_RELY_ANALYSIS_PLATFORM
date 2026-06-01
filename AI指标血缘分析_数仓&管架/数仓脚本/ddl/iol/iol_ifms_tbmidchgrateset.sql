/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbmidchgrateset
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbmidchgrateset
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbmidchgrateset purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbmidchgrateset(
    prd_code varchar2(32) -- 
    ,sale_rate number(18,8) -- 
    ,price_diff_rate number(18,8) -- 
    ,rate_effective_date number(22,0) -- 
    ,trans_date number(22,0) -- 
    ,trans_time number(22,0) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbmidchgrateset to ${iml_schema};
grant select on ${iol_schema}.ifms_tbmidchgrateset to ${icl_schema};
grant select on ${iol_schema}.ifms_tbmidchgrateset to ${idl_schema};
grant select on ${iol_schema}.ifms_tbmidchgrateset to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbmidchgrateset is '理财中收费率';
comment on column ${iol_schema}.ifms_tbmidchgrateset.prd_code is '';
comment on column ${iol_schema}.ifms_tbmidchgrateset.sale_rate is '';
comment on column ${iol_schema}.ifms_tbmidchgrateset.price_diff_rate is '';
comment on column ${iol_schema}.ifms_tbmidchgrateset.rate_effective_date is '';
comment on column ${iol_schema}.ifms_tbmidchgrateset.trans_date is '';
comment on column ${iol_schema}.ifms_tbmidchgrateset.trans_time is '';
comment on column ${iol_schema}.ifms_tbmidchgrateset.reserve1 is '';
comment on column ${iol_schema}.ifms_tbmidchgrateset.reserve2 is '';
comment on column ${iol_schema}.ifms_tbmidchgrateset.reserve3 is '';
comment on column ${iol_schema}.ifms_tbmidchgrateset.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbmidchgrateset.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbmidchgrateset.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbmidchgrateset.etl_timestamp is 'ETL处理时间戳';
