/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_aml_evaluate_history
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_aml_evaluate_history
whenever sqlerror continue none;
drop table ${iol_schema}.icms_aml_evaluate_history purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_aml_evaluate_history(
    serialno varchar2(32) -- 流水号
    ,objectno varchar2(32) -- 业务流水号
    ,objecttype varchar2(32) -- 业务类型
    ,businessstatus varchar2(4) -- 业务状态
    ,evaluateflowserialno varchar2(50) -- 评级结果对应的评级编号
    ,evaluateresult varchar2(4) -- 评级风险等级
    ,evaluatereason varchar2(4000) -- 评级原因
    ,evaluateexcuse varchar2(4000) -- 评级理由
    ,inputuserid varchar2(64) -- 录入人
    ,inputorgid varchar2(64) -- 录入机构
    ,inputdate date -- 录入日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,belongorgid varchar2(40) -- 客户归属机构（反洗钱）
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
grant select on ${iol_schema}.icms_aml_evaluate_history to ${iml_schema};
grant select on ${iol_schema}.icms_aml_evaluate_history to ${icl_schema};
grant select on ${iol_schema}.icms_aml_evaluate_history to ${idl_schema};
grant select on ${iol_schema}.icms_aml_evaluate_history to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_aml_evaluate_history is '反洗钱评级历史表';
comment on column ${iol_schema}.icms_aml_evaluate_history.serialno is '流水号';
comment on column ${iol_schema}.icms_aml_evaluate_history.objectno is '业务流水号';
comment on column ${iol_schema}.icms_aml_evaluate_history.objecttype is '业务类型';
comment on column ${iol_schema}.icms_aml_evaluate_history.businessstatus is '业务状态';
comment on column ${iol_schema}.icms_aml_evaluate_history.evaluateflowserialno is '评级结果对应的评级编号';
comment on column ${iol_schema}.icms_aml_evaluate_history.evaluateresult is '评级风险等级';
comment on column ${iol_schema}.icms_aml_evaluate_history.evaluatereason is '评级原因';
comment on column ${iol_schema}.icms_aml_evaluate_history.evaluateexcuse is '评级理由';
comment on column ${iol_schema}.icms_aml_evaluate_history.inputuserid is '录入人';
comment on column ${iol_schema}.icms_aml_evaluate_history.inputorgid is '录入机构';
comment on column ${iol_schema}.icms_aml_evaluate_history.inputdate is '录入日期';
comment on column ${iol_schema}.icms_aml_evaluate_history.updateuserid is '更新人';
comment on column ${iol_schema}.icms_aml_evaluate_history.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_aml_evaluate_history.updatedate is '更新日期';
comment on column ${iol_schema}.icms_aml_evaluate_history.belongorgid is '客户归属机构（反洗钱）';
comment on column ${iol_schema}.icms_aml_evaluate_history.start_dt is '开始时间';
comment on column ${iol_schema}.icms_aml_evaluate_history.end_dt is '结束时间';
comment on column ${iol_schema}.icms_aml_evaluate_history.id_mark is '增删标志';
comment on column ${iol_schema}.icms_aml_evaluate_history.etl_timestamp is 'ETL处理时间戳';
