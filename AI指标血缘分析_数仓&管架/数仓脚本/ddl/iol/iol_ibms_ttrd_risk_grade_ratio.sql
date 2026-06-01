/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_risk_grade_ratio
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_risk_grade_ratio
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_risk_grade_ratio purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_risk_grade_ratio(
    id number(22,0) -- 主键
    ,risk_detail varchar2(300) -- 资产信息
    ,parent_id number(22,0) -- 所属分类id
    ,is_default_grade varchar2(2) -- 评级是否只读
    ,style_level varchar2(2) -- 1-加粗2-空一格3-空2哥
    ,check_level varchar2(2) -- 0-无控制1-控制子节点小于父节点2-控制子节点和为100
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
grant select on ${iol_schema}.ibms_ttrd_risk_grade_ratio to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_risk_grade_ratio to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_risk_grade_ratio to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_risk_grade_ratio to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_risk_grade_ratio is '最终投向类型信息（华兴）';
comment on column ${iol_schema}.ibms_ttrd_risk_grade_ratio.id is '主键';
comment on column ${iol_schema}.ibms_ttrd_risk_grade_ratio.risk_detail is '资产信息';
comment on column ${iol_schema}.ibms_ttrd_risk_grade_ratio.parent_id is '所属分类id';
comment on column ${iol_schema}.ibms_ttrd_risk_grade_ratio.is_default_grade is '评级是否只读';
comment on column ${iol_schema}.ibms_ttrd_risk_grade_ratio.style_level is '1-加粗2-空一格3-空2哥';
comment on column ${iol_schema}.ibms_ttrd_risk_grade_ratio.check_level is '0-无控制1-控制子节点小于父节点2-控制子节点和为100';
comment on column ${iol_schema}.ibms_ttrd_risk_grade_ratio.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_risk_grade_ratio.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_risk_grade_ratio.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_risk_grade_ratio.etl_timestamp is 'ETL处理时间戳';
