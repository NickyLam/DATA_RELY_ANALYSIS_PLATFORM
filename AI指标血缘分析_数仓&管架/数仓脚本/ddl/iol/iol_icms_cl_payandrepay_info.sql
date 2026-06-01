/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_payandrepay_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_payandrepay_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_payandrepay_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_payandrepay_info(
    sourcesystem varchar2(64) -- 来源系统
    ,serialno varchar2(64) -- 流水号
    ,inputdate timestamp -- 登记日期
    ,inputorgid varchar2(64) -- 登记机构
    ,inputuserid varchar2(64) -- 登记人
    ,businessno varchar2(64) -- 额度系统业务编号
    ,currency varchar2(3) -- 币种
    ,operateoptype varchar2(64) -- 操作类型放款或者还款）
    ,amount number(24,6) -- 金额
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
grant select on ${iol_schema}.icms_cl_payandrepay_info to ${iml_schema};
grant select on ${iol_schema}.icms_cl_payandrepay_info to ${icl_schema};
grant select on ${iol_schema}.icms_cl_payandrepay_info to ${idl_schema};
grant select on ${iol_schema}.icms_cl_payandrepay_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_payandrepay_info is '放款还款账目信息';
comment on column ${iol_schema}.icms_cl_payandrepay_info.sourcesystem is '来源系统';
comment on column ${iol_schema}.icms_cl_payandrepay_info.serialno is '流水号';
comment on column ${iol_schema}.icms_cl_payandrepay_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_payandrepay_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_payandrepay_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_payandrepay_info.businessno is '额度系统业务编号';
comment on column ${iol_schema}.icms_cl_payandrepay_info.currency is '币种';
comment on column ${iol_schema}.icms_cl_payandrepay_info.operateoptype is '操作类型放款或者还款）';
comment on column ${iol_schema}.icms_cl_payandrepay_info.amount is '金额';
comment on column ${iol_schema}.icms_cl_payandrepay_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_cl_payandrepay_info.etl_timestamp is 'ETL处理时间戳';
