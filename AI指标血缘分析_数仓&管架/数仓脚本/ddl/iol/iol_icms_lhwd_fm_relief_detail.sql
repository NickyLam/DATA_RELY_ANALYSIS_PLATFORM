/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lhwd_fm_relief_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lhwd_fm_relief_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lhwd_fm_relief_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhwd_fm_relief_detail(
    businessdate varchar2(8) -- 业务日期
    ,seqno varchar2(64) -- 交易流水号
    ,loanid varchar2(64) -- 借据号
    ,relieftime varchar2(20) -- 交易时间 YYYYMMDDHHMMSS
    ,period number(4) -- 减免期次
    ,reliefamt number(18,2) -- 减免总金额
    ,reliefintamt number(18,2) -- 减免利息
    ,reliefpinamt number(18,2) -- 减免罚息
    ,reliefcinamt number(18,2) -- 减免复利
    ,financetype varchar2(1) -- 资产类型 1-联合出资 2-机构全资
    ,assetidentification varchar2(16) -- 资产标识
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
grant select on ${iol_schema}.icms_lhwd_fm_relief_detail to ${iml_schema};
grant select on ${iol_schema}.icms_lhwd_fm_relief_detail to ${icl_schema};
grant select on ${iol_schema}.icms_lhwd_fm_relief_detail to ${idl_schema};
grant select on ${iol_schema}.icms_lhwd_fm_relief_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lhwd_fm_relief_detail is '联合网贷富民减免明细表';
comment on column ${iol_schema}.icms_lhwd_fm_relief_detail.businessdate is '业务日期';
comment on column ${iol_schema}.icms_lhwd_fm_relief_detail.seqno is '交易流水号';
comment on column ${iol_schema}.icms_lhwd_fm_relief_detail.loanid is '借据号';
comment on column ${iol_schema}.icms_lhwd_fm_relief_detail.relieftime is '交易时间 YYYYMMDDHHMMSS';
comment on column ${iol_schema}.icms_lhwd_fm_relief_detail.period is '减免期次';
comment on column ${iol_schema}.icms_lhwd_fm_relief_detail.reliefamt is '减免总金额';
comment on column ${iol_schema}.icms_lhwd_fm_relief_detail.reliefintamt is '减免利息';
comment on column ${iol_schema}.icms_lhwd_fm_relief_detail.reliefpinamt is '减免罚息';
comment on column ${iol_schema}.icms_lhwd_fm_relief_detail.reliefcinamt is '减免复利';
comment on column ${iol_schema}.icms_lhwd_fm_relief_detail.financetype is '资产类型 1-联合出资 2-机构全资';
comment on column ${iol_schema}.icms_lhwd_fm_relief_detail.assetidentification is '资产标识';
comment on column ${iol_schema}.icms_lhwd_fm_relief_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_lhwd_fm_relief_detail.etl_timestamp is 'ETL处理时间戳';
