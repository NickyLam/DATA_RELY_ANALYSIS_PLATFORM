/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_credit_limit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_credit_limit
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_credit_limit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_credit_limit(
    customertype varchar2(64) -- 客户类型
    ,currency varchar2(3) -- 币种
    ,capital number(24,6) -- 资本金
    ,percentage number(24,6) -- 比例
    ,limitamount number(24,6) -- 限额
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate timestamp -- 登记日期
    ,updateuserid varchar2(64) -- 最后更新人
    ,updateorgid varchar2(64) -- 最后更新机构
    ,updatedate timestamp -- 最后更新日期
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
grant select on ${iol_schema}.icms_cl_credit_limit to ${iml_schema};
grant select on ${iol_schema}.icms_cl_credit_limit to ${icl_schema};
grant select on ${iol_schema}.icms_cl_credit_limit to ${idl_schema};
grant select on ${iol_schema}.icms_cl_credit_limit to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_credit_limit is '监管限额信息';
comment on column ${iol_schema}.icms_cl_credit_limit.customertype is '客户类型';
comment on column ${iol_schema}.icms_cl_credit_limit.currency is '币种';
comment on column ${iol_schema}.icms_cl_credit_limit.capital is '资本金';
comment on column ${iol_schema}.icms_cl_credit_limit.percentage is '比例';
comment on column ${iol_schema}.icms_cl_credit_limit.limitamount is '限额';
comment on column ${iol_schema}.icms_cl_credit_limit.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_credit_limit.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_credit_limit.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_credit_limit.updateuserid is '最后更新人';
comment on column ${iol_schema}.icms_cl_credit_limit.updateorgid is '最后更新机构';
comment on column ${iol_schema}.icms_cl_credit_limit.updatedate is '最后更新日期';
comment on column ${iol_schema}.icms_cl_credit_limit.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_cl_credit_limit.etl_timestamp is 'ETL处理时间戳';
