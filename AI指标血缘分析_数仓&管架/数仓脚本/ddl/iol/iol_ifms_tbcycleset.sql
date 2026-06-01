/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbcycleset
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbcycleset
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbcycleset purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbcycleset(
    prd_code varchar2(32) -- 
    ,cycle_date number(22) -- 
    ,deal_status varchar2(2) -- 
    ,deal_date number(22) -- 
    ,all_income number(24,7) -- 
    ,froze_income number(18,2) -- 
    ,all_fee number(18,2) -- 
    ,manage_fee number(18,2) -- 
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
grant select on ${iol_schema}.ifms_tbcycleset to ${iml_schema};
grant select on ${iol_schema}.ifms_tbcycleset to ${icl_schema};
grant select on ${iol_schema}.ifms_tbcycleset to ${idl_schema};
grant select on ${iol_schema}.ifms_tbcycleset to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbcycleset is '周期设置表';
comment on column ${iol_schema}.ifms_tbcycleset.prd_code is '';
comment on column ${iol_schema}.ifms_tbcycleset.cycle_date is '';
comment on column ${iol_schema}.ifms_tbcycleset.deal_status is '';
comment on column ${iol_schema}.ifms_tbcycleset.deal_date is '';
comment on column ${iol_schema}.ifms_tbcycleset.all_income is '';
comment on column ${iol_schema}.ifms_tbcycleset.froze_income is '';
comment on column ${iol_schema}.ifms_tbcycleset.all_fee is '';
comment on column ${iol_schema}.ifms_tbcycleset.manage_fee is '';
comment on column ${iol_schema}.ifms_tbcycleset.reserve1 is '';
comment on column ${iol_schema}.ifms_tbcycleset.reserve2 is '';
comment on column ${iol_schema}.ifms_tbcycleset.reserve3 is '';
comment on column ${iol_schema}.ifms_tbcycleset.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbcycleset.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbcycleset.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbcycleset.etl_timestamp is 'ETL处理时间戳';
