/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_risk_asset_type_setting
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_risk_asset_type_setting
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_risk_asset_type_setting purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_risk_asset_type_setting(
    cus_number number -- CMS部门代码
    ,asset_name varchar2(150) -- CMS资产类别
    ,modify_user number -- 修改者
    ,modify_time date -- 修改时间
    ,asset_key varchar2(30) -- 资产类别的代码
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
grant select on ${iol_schema}.ctms_tbs_v_risk_asset_type_setting to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_risk_asset_type_setting to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_risk_asset_type_setting to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_risk_asset_type_setting to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_risk_asset_type_setting is '债券资产类别定义表';
comment on column ${iol_schema}.ctms_tbs_v_risk_asset_type_setting.cus_number is 'CMS部门代码';
comment on column ${iol_schema}.ctms_tbs_v_risk_asset_type_setting.asset_name is 'CMS资产类别';
comment on column ${iol_schema}.ctms_tbs_v_risk_asset_type_setting.modify_user is '修改者';
comment on column ${iol_schema}.ctms_tbs_v_risk_asset_type_setting.modify_time is '修改时间';
comment on column ${iol_schema}.ctms_tbs_v_risk_asset_type_setting.asset_key is '资产类别的代码';
comment on column ${iol_schema}.ctms_tbs_v_risk_asset_type_setting.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_risk_asset_type_setting.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_risk_asset_type_setting.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_risk_asset_type_setting.etl_timestamp is 'ETL处理时间戳';
