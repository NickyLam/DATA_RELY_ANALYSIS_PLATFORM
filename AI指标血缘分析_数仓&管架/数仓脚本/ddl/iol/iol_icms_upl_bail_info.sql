/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_upl_bail_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_upl_bail_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_upl_bail_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_upl_bail_info(
    serialno varchar2(40) -- 流水号
    ,customerid varchar2(32) -- 客户编号
    ,bailsum number(32,2) -- 保证金可用金额
    ,bailminratio number(10,6) -- 保证金最低比例
    ,inputdate varchar2(10) -- 登记日期
    ,actualuseratio number(32,2) -- 保证金占用比例
    ,corpno varchar2(10) -- 合作公司编码
    ,bailsubaccount varchar2(32) -- 保证金子户号
    ,inputuser varchar2(80) -- 登记人
    ,bailaccountno varchar2(32) -- 保证金账户
    ,corpname varchar2(80) -- 客户名称
    ,paiedsum number(32,2) -- 保证金核心止付金额
    ,inputorg varchar2(80) -- 登记机构
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,syndate varchar2(32) -- 同步核心时间
    ,bailbalance number(32,2) -- 保证金余额
    ,usedsum number(32,2) -- 保证金占用金额
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
grant select on ${iol_schema}.icms_upl_bail_info to ${iml_schema};
grant select on ${iol_schema}.icms_upl_bail_info to ${icl_schema};
grant select on ${iol_schema}.icms_upl_bail_info to ${idl_schema};
grant select on ${iol_schema}.icms_upl_bail_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_upl_bail_info is '微贷保证金信息表';
comment on column ${iol_schema}.icms_upl_bail_info.serialno is '流水号';
comment on column ${iol_schema}.icms_upl_bail_info.customerid is '客户编号';
comment on column ${iol_schema}.icms_upl_bail_info.bailsum is '保证金可用金额';
comment on column ${iol_schema}.icms_upl_bail_info.bailminratio is '保证金最低比例';
comment on column ${iol_schema}.icms_upl_bail_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_upl_bail_info.actualuseratio is '保证金占用比例';
comment on column ${iol_schema}.icms_upl_bail_info.corpno is '合作公司编码';
comment on column ${iol_schema}.icms_upl_bail_info.bailsubaccount is '保证金子户号';
comment on column ${iol_schema}.icms_upl_bail_info.inputuser is '登记人';
comment on column ${iol_schema}.icms_upl_bail_info.bailaccountno is '保证金账户';
comment on column ${iol_schema}.icms_upl_bail_info.corpname is '客户名称';
comment on column ${iol_schema}.icms_upl_bail_info.paiedsum is '保证金核心止付金额';
comment on column ${iol_schema}.icms_upl_bail_info.inputorg is '登记机构';
comment on column ${iol_schema}.icms_upl_bail_info.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_upl_bail_info.syndate is '同步核心时间';
comment on column ${iol_schema}.icms_upl_bail_info.bailbalance is '保证金余额';
comment on column ${iol_schema}.icms_upl_bail_info.usedsum is '保证金占用金额';
comment on column ${iol_schema}.icms_upl_bail_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_upl_bail_info.etl_timestamp is 'ETL处理时间戳';
