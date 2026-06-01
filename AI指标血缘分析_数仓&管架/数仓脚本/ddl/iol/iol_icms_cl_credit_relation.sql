/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_credit_relation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_credit_relation
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_credit_relation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_credit_relation(
    actualoccupyexposureamount number(24,6) -- 实际占用敞口金额
    ,updatedate timestamp -- 最后更新日期
    ,creditno varchar2(64) -- 额度系统业务编号
    ,roletype varchar2(64) -- 角色类型
    ,relativecreditno varchar2(64) -- 额度系统业务编号
    ,occupyexposureamount number(24,6) -- 占用敞口金额
    ,createdway varchar2(64) -- 关系建立方式
    ,occupycoefficient number(24,6) -- 占用上层额度的系数
    ,effect varchar2(2) -- Y有效N无效
    ,updateuserid varchar2(64) -- 最后更新人
    ,customerid varchar2(32) -- 额度系统客户编号
    ,occupycurrency varchar2(64) -- 占用币种
    ,inputdate timestamp -- 登记日期
    ,updateorgid varchar2(64) -- 最后更新机构
    ,execslowreleaseexposureamount number(24,6) -- 执行可缓释敞口金额
    ,inputuserid varchar2(64) -- 登记人
    ,occupynominalamount number(24,6) -- 占用名义金额
    ,actualoccupynominalamount number(24,6) -- 实际占用名义金额
    ,inputorgid varchar2(64) -- 登记机构
    ,relativetype varchar2(64) -- 关系类型
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
grant select on ${iol_schema}.icms_cl_credit_relation to ${iml_schema};
grant select on ${iol_schema}.icms_cl_credit_relation to ${icl_schema};
grant select on ${iol_schema}.icms_cl_credit_relation to ${idl_schema};
grant select on ${iol_schema}.icms_cl_credit_relation to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_credit_relation is '额度与额度关系';
comment on column ${iol_schema}.icms_cl_credit_relation.actualoccupyexposureamount is '实际占用敞口金额';
comment on column ${iol_schema}.icms_cl_credit_relation.updatedate is '最后更新日期';
comment on column ${iol_schema}.icms_cl_credit_relation.creditno is '额度系统业务编号';
comment on column ${iol_schema}.icms_cl_credit_relation.roletype is '角色类型';
comment on column ${iol_schema}.icms_cl_credit_relation.relativecreditno is '额度系统业务编号';
comment on column ${iol_schema}.icms_cl_credit_relation.occupyexposureamount is '占用敞口金额';
comment on column ${iol_schema}.icms_cl_credit_relation.createdway is '关系建立方式';
comment on column ${iol_schema}.icms_cl_credit_relation.occupycoefficient is '占用上层额度的系数';
comment on column ${iol_schema}.icms_cl_credit_relation.effect is 'Y有效N无效';
comment on column ${iol_schema}.icms_cl_credit_relation.updateuserid is '最后更新人';
comment on column ${iol_schema}.icms_cl_credit_relation.customerid is '额度系统客户编号';
comment on column ${iol_schema}.icms_cl_credit_relation.occupycurrency is '占用币种';
comment on column ${iol_schema}.icms_cl_credit_relation.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_credit_relation.updateorgid is '最后更新机构';
comment on column ${iol_schema}.icms_cl_credit_relation.execslowreleaseexposureamount is '执行可缓释敞口金额';
comment on column ${iol_schema}.icms_cl_credit_relation.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_credit_relation.occupynominalamount is '占用名义金额';
comment on column ${iol_schema}.icms_cl_credit_relation.actualoccupynominalamount is '实际占用名义金额';
comment on column ${iol_schema}.icms_cl_credit_relation.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_credit_relation.relativetype is '关系类型';
comment on column ${iol_schema}.icms_cl_credit_relation.start_dt is '开始时间';
comment on column ${iol_schema}.icms_cl_credit_relation.end_dt is '结束时间';
comment on column ${iol_schema}.icms_cl_credit_relation.id_mark is '增删标志';
comment on column ${iol_schema}.icms_cl_credit_relation.etl_timestamp is 'ETL处理时间戳';
