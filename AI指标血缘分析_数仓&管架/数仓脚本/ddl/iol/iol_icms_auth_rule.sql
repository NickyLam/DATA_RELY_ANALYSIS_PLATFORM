/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_auth_rule
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_auth_rule
whenever sqlerror continue none;
drop table ${iol_schema}.icms_auth_rule purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_auth_rule(
    ruleid varchar2(64) -- 规则编号
    ,inputorgid varchar2(64) -- 登记机构
    ,status varchar2(12) -- 规则状态
    ,inputdate date -- 登记日期
    ,corporgid varchar2(64) -- 法人机构编号
    ,remark varchar2(2000) -- 备注
    ,updateuserid varchar2(64) -- 更新人
    ,updatedate date -- 更新日期
    ,frontruleid varchar2(64) -- 前置规则编号
    ,priority number(22) -- 优先级
    ,result varchar2(64) -- 规则结果规则结果(终批/禁批)
    ,programid varchar2(64) -- 方案编号
    ,inputuserid varchar2(64) -- 登记人
    ,updateorgid varchar2(64) -- 更新机构
    ,ruletype varchar2(64) -- 规则类型规则类型(独立/前置)
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
grant select on ${iol_schema}.icms_auth_rule to ${iml_schema};
grant select on ${iol_schema}.icms_auth_rule to ${icl_schema};
grant select on ${iol_schema}.icms_auth_rule to ${idl_schema};
grant select on ${iol_schema}.icms_auth_rule to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_auth_rule is '授权规则授权规则';
comment on column ${iol_schema}.icms_auth_rule.ruleid is '规则编号';
comment on column ${iol_schema}.icms_auth_rule.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_auth_rule.status is '规则状态';
comment on column ${iol_schema}.icms_auth_rule.inputdate is '登记日期';
comment on column ${iol_schema}.icms_auth_rule.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_auth_rule.remark is '备注';
comment on column ${iol_schema}.icms_auth_rule.updateuserid is '更新人';
comment on column ${iol_schema}.icms_auth_rule.updatedate is '更新日期';
comment on column ${iol_schema}.icms_auth_rule.frontruleid is '前置规则编号';
comment on column ${iol_schema}.icms_auth_rule.priority is '优先级';
comment on column ${iol_schema}.icms_auth_rule.result is '规则结果规则结果(终批/禁批)';
comment on column ${iol_schema}.icms_auth_rule.programid is '方案编号';
comment on column ${iol_schema}.icms_auth_rule.inputuserid is '登记人';
comment on column ${iol_schema}.icms_auth_rule.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_auth_rule.ruletype is '规则类型规则类型(独立/前置)';
comment on column ${iol_schema}.icms_auth_rule.start_dt is '开始时间';
comment on column ${iol_schema}.icms_auth_rule.end_dt is '结束时间';
comment on column ${iol_schema}.icms_auth_rule.id_mark is '增删标志';
comment on column ${iol_schema}.icms_auth_rule.etl_timestamp is 'ETL处理时间戳';
