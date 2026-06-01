/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_b_c_relation_history
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_b_c_relation_history
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_b_c_relation_history purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_b_c_relation_history(
    relativecreditno varchar2(64) -- 额度系统额度编号
    ,occupycoefficient number(24,6) -- 占用上层额度的系数
    ,customerid varchar2(16) -- 额度系统客户编号
    ,updatedate timestamp -- 最后更新日期
    ,occupycurrency varchar2(64) -- 占用币种
    ,effect varchar2(2) -- Y有效N无效
    ,roletype varchar2(64) -- 角色类型
    ,inputuserid varchar2(64) -- 登记人
    ,relativetype varchar2(64) -- 关系类型
    ,inputdate timestamp -- 登记日期
    ,businessno varchar2(64) -- 额度系统业务编号
    ,actualoccupynominalamount number(24,6) -- 实际占用名义金额
    ,execslowreleaseexposureamount number(24,6) -- 执行可缓释敞口金额
    ,occupynominalamount number(24,6) -- 占用名义金额
    ,updateuserid varchar2(64) -- 最后更新人
    ,occupyexposureamount number(24,6) -- 占用敞口金额
    ,createdway varchar2(64) -- 关系建立方式
    ,actualoccupyexposureamount number(24,6) -- 实际占用敞口金额
    ,inputorgid varchar2(64) -- 登记机构
    ,updateorgid varchar2(64) -- 最后更新机构
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_cl_b_c_relation_history to ${iml_schema};
grant select on ${iol_schema}.icms_cl_b_c_relation_history to ${icl_schema};
grant select on ${iol_schema}.icms_cl_b_c_relation_history to ${idl_schema};
grant select on ${iol_schema}.icms_cl_b_c_relation_history to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_b_c_relation_history is '业务与额度关系历史表';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.relativecreditno is '额度系统额度编号';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.occupycoefficient is '占用上层额度的系数';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.customerid is '额度系统客户编号';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.updatedate is '最后更新日期';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.occupycurrency is '占用币种';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.effect is 'Y有效N无效';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.roletype is '角色类型';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.relativetype is '关系类型';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.businessno is '额度系统业务编号';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.actualoccupynominalamount is '实际占用名义金额';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.execslowreleaseexposureamount is '执行可缓释敞口金额';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.occupynominalamount is '占用名义金额';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.updateuserid is '最后更新人';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.occupyexposureamount is '占用敞口金额';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.createdway is '关系建立方式';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.actualoccupyexposureamount is '实际占用敞口金额';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.updateorgid is '最后更新机构';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_cl_b_c_relation_history.etl_timestamp is 'ETL处理时间戳';
