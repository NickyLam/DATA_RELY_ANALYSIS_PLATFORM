/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_risk_weight_proportion
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_risk_weight_proportion
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_risk_weight_proportion purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_risk_weight_proportion(
    i_code varchar2(75) -- 
    ,a_type varchar2(30) -- 
    ,m_type varchar2(30) -- 
    ,risk_id number(22,0) -- 风险占比表id
    ,proportion number(14,6) -- 占比
    ,update_time varchar2(30) -- 生效时间
    ,update_user_id number(19,0) -- 
    ,status varchar2(2) -- 
    ,effective_time varchar2(15) -- 生效时间
    ,is_current varchar2(2) -- 是否为最新数据
    ,id number(22,0) -- 
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
grant select on ${iol_schema}.ibms_ttrd_risk_weight_proportion to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_risk_weight_proportion to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_risk_weight_proportion to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_risk_weight_proportion to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_risk_weight_proportion is '基金风险占比信息1（华兴）';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_proportion.i_code is '';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_proportion.a_type is '';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_proportion.m_type is '';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_proportion.risk_id is '风险占比表id';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_proportion.proportion is '占比';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_proportion.update_time is '生效时间';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_proportion.update_user_id is '';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_proportion.status is '';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_proportion.effective_time is '生效时间';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_proportion.is_current is '是否为最新数据';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_proportion.id is '';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_proportion.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_proportion.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_proportion.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_proportion.etl_timestamp is 'ETL处理时间戳';
