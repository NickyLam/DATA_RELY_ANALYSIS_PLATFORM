/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_credit_preoccupy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_credit_preoccupy
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_credit_preoccupy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_credit_preoccupy(
    updatedate date -- 更新日期
    ,preexposureamount number(24,6) -- 预占敞口金额
    ,expirydate date -- 到期日
    ,status varchar2(64) -- 状态
    ,startdate date -- 起始日
    ,corporgid varchar2(64) -- 法人机构号
    ,preno varchar2(64) -- 预占编号
    ,precurrency varchar2(12) -- 预占币种
    ,prenominalamount number(24,6) -- 预占名义金额
    ,inputorgid varchar2(64) -- 登记机构
    ,updateuserid varchar2(64) -- 更新人
    ,dimensionno varchar2(64) -- 维度号
    ,leftprenominalamount number(24,6) -- 剩余预占名义金额
    ,preobject varchar2(2000) -- 预占对象
    ,inputdate date -- 登记日期
    ,pretimelimit number(38) -- 预占期限
    ,updateorgid varchar2(64) -- 更新机构
    ,creditno varchar2(64) -- 额度编号
    ,leftpreexposureamount number(24,6) -- 剩余预占敞口金额
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
grant select on ${iol_schema}.icms_cl_credit_preoccupy to ${iml_schema};
grant select on ${iol_schema}.icms_cl_credit_preoccupy to ${icl_schema};
grant select on ${iol_schema}.icms_cl_credit_preoccupy to ${idl_schema};
grant select on ${iol_schema}.icms_cl_credit_preoccupy to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_credit_preoccupy is '额度预占表';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.updatedate is '更新日期';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.preexposureamount is '预占敞口金额';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.expirydate is '到期日';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.status is '状态';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.startdate is '起始日';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.corporgid is '法人机构号';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.preno is '预占编号';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.precurrency is '预占币种';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.prenominalamount is '预占名义金额';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.updateuserid is '更新人';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.dimensionno is '维度号';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.leftprenominalamount is '剩余预占名义金额';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.preobject is '预占对象';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.pretimelimit is '预占期限';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.creditno is '额度编号';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.leftpreexposureamount is '剩余预占敞口金额';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_cl_credit_preoccupy.etl_timestamp is 'ETL处理时间戳';
