/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_b_c_relation_serial
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_b_c_relation_serial
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_b_c_relation_serial purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_b_c_relation_serial(
    relativecreditno varchar2(64) -- 额度系统额度编号
    ,actualoccupyexposureamount number(24,6) -- 实际占用敞口金额
    ,roletype varchar2(64) -- 角色类型
    ,occupynominalamount number(24,6) -- 占用名义金额
    ,effect varchar2(2) -- Y有效N无效
    ,serialno varchar2(64) -- 流水号
    ,businessno varchar2(64) -- 额度系统业务编号
    ,relativetype varchar2(64) -- 关系类型
    ,execslowreleaseexposureamount number(24,6) -- 执行可缓释敞口金额
    ,actualoccupynominalamount number(24,6) -- 实际占用名义金额
    ,updateorgid varchar2(64) -- 最后更新机构
    ,occupyexposureamount number(24,6) -- 占用敞口金额
    ,customerid varchar2(16) -- 额度系统客户编号
    ,createdway varchar2(64) -- 关系建立方式
    ,updatedate timestamp -- 最后更新日期
    ,inputorgid varchar2(64) -- 登记机构
    ,updateuserid varchar2(64) -- 最后更新人
    ,occupycoefficient number(24,6) -- 占用上层额度的系数
    ,inputdate timestamp -- 登记日期
    ,occupycurrency varchar2(64) -- 占用币种
    ,inputuserid varchar2(64) -- 登记人
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
grant select on ${iol_schema}.icms_cl_b_c_relation_serial to ${iml_schema};
grant select on ${iol_schema}.icms_cl_b_c_relation_serial to ${icl_schema};
grant select on ${iol_schema}.icms_cl_b_c_relation_serial to ${idl_schema};
grant select on ${iol_schema}.icms_cl_b_c_relation_serial to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_b_c_relation_serial is '业务与额度关系流水';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.relativecreditno is '额度系统额度编号';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.actualoccupyexposureamount is '实际占用敞口金额';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.roletype is '角色类型';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.occupynominalamount is '占用名义金额';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.effect is 'Y有效N无效';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.serialno is '流水号';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.businessno is '额度系统业务编号';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.relativetype is '关系类型';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.execslowreleaseexposureamount is '执行可缓释敞口金额';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.actualoccupynominalamount is '实际占用名义金额';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.updateorgid is '最后更新机构';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.occupyexposureamount is '占用敞口金额';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.customerid is '额度系统客户编号';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.createdway is '关系建立方式';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.updatedate is '最后更新日期';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.updateuserid is '最后更新人';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.occupycoefficient is '占用上层额度的系数';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.occupycurrency is '占用币种';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_cl_b_c_relation_serial.etl_timestamp is 'ETL处理时间戳';
