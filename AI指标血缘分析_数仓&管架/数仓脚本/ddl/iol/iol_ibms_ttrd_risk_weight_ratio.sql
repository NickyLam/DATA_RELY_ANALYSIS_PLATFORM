/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_risk_weight_ratio
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_risk_weight_ratio
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_risk_weight_ratio purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_risk_weight_ratio(
    weight number(14,6) -- 权重
    ,risk_detail varchar2(300) -- 资产信息
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
grant select on ${iol_schema}.ibms_ttrd_risk_weight_ratio to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_risk_weight_ratio to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_risk_weight_ratio to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_risk_weight_ratio to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_risk_weight_ratio is '基金风险占比信息2（华兴）';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_ratio.weight is '权重';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_ratio.risk_detail is '资产信息';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_ratio.id is '';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_ratio.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_ratio.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_ratio.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_risk_weight_ratio.etl_timestamp is 'ETL处理时间戳';
