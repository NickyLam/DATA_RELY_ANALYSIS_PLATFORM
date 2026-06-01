/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_asset_transfer_accounting_eso
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_asset_transfer_accounting_eso
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_asset_transfer_accounting_eso purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_asset_transfer_accounting_eso(
    accountingtype varchar2(64) -- 汇总记账类型
    ,accountingamt number(24,6) -- 汇总记账金额
    ,fvtpltag varchar2(8) -- 平价和折溢价转让为N，净值回购为Y
    ,regioncode varchar2(8) -- 行政区划代码
    ,bsntype varchar2(64) -- 业务类型
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
grant select on ${iol_schema}.icms_mybk_asset_transfer_accounting_eso to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_asset_transfer_accounting_eso to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_asset_transfer_accounting_eso to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_asset_transfer_accounting_eso to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_asset_transfer_accounting_eso is '网商贷汇总记账文件中间表-债权直转';
comment on column ${iol_schema}.icms_mybk_asset_transfer_accounting_eso.accountingtype is '汇总记账类型';
comment on column ${iol_schema}.icms_mybk_asset_transfer_accounting_eso.accountingamt is '汇总记账金额';
comment on column ${iol_schema}.icms_mybk_asset_transfer_accounting_eso.fvtpltag is '平价和折溢价转让为N，净值回购为Y';
comment on column ${iol_schema}.icms_mybk_asset_transfer_accounting_eso.regioncode is '行政区划代码';
comment on column ${iol_schema}.icms_mybk_asset_transfer_accounting_eso.bsntype is '业务类型';
comment on column ${iol_schema}.icms_mybk_asset_transfer_accounting_eso.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_mybk_asset_transfer_accounting_eso.etl_timestamp is 'ETL处理时间戳';
