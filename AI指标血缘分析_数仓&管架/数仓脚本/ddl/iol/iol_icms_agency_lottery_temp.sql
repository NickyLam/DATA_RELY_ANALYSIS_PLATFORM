/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_agency_lottery_temp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_agency_lottery_temp
whenever sqlerror continue none;
drop table ${iol_schema}.icms_agency_lottery_temp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_agency_lottery_temp(
    parentorgid varchar2(192) -- 评估机构所属机构
    ,appraisalorgid varchar2(96) -- 评估机构编号
    ,status varchar2(30) -- 状态
    ,belongdept varchar2(18) -- 所属条线
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
grant select on ${iol_schema}.icms_agency_lottery_temp to ${iml_schema};
grant select on ${iol_schema}.icms_agency_lottery_temp to ${icl_schema};
grant select on ${iol_schema}.icms_agency_lottery_temp to ${idl_schema};
grant select on ${iol_schema}.icms_agency_lottery_temp to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_agency_lottery_temp is '评级机构摇号中间表';
comment on column ${iol_schema}.icms_agency_lottery_temp.parentorgid is '评估机构所属机构';
comment on column ${iol_schema}.icms_agency_lottery_temp.appraisalorgid is '评估机构编号';
comment on column ${iol_schema}.icms_agency_lottery_temp.status is '状态';
comment on column ${iol_schema}.icms_agency_lottery_temp.belongdept is '所属条线';
comment on column ${iol_schema}.icms_agency_lottery_temp.start_dt is '开始时间';
comment on column ${iol_schema}.icms_agency_lottery_temp.end_dt is '结束时间';
comment on column ${iol_schema}.icms_agency_lottery_temp.id_mark is '增删标志';
comment on column ${iol_schema}.icms_agency_lottery_temp.etl_timestamp is 'ETL处理时间戳';
