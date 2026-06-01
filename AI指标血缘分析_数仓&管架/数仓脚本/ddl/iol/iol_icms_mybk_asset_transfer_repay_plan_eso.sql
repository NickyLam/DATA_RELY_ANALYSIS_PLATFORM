/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_asset_transfer_repay_plan_eso
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_asset_transfer_repay_plan_eso
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_asset_transfer_repay_plan_eso purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_asset_transfer_repay_plan_eso(
    contractno varchar2(64) -- 融资平台贷款合约号
    ,termno number(24,6) -- 期次号
    ,startdate varchar2(64) -- 分期开始日期
    ,enddate varchar2(64) -- 分期结束日期
    ,prinamt number(24,6) -- 本金金额（单位分）
    ,intamt number(24,6) -- 初始利息匡算金额（单位分）
    ,bsntype varchar2(64) -- 产品业务类型
    ,regioncode varchar2(8) -- 行政区划代码
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
grant select on ${iol_schema}.icms_mybk_asset_transfer_repay_plan_eso to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_asset_transfer_repay_plan_eso to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_asset_transfer_repay_plan_eso to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_asset_transfer_repay_plan_eso to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_asset_transfer_repay_plan_eso is '网商贷转入资产放款（分期）明细文件中间表-债权直转';
comment on column ${iol_schema}.icms_mybk_asset_transfer_repay_plan_eso.contractno is '融资平台贷款合约号';
comment on column ${iol_schema}.icms_mybk_asset_transfer_repay_plan_eso.termno is '期次号';
comment on column ${iol_schema}.icms_mybk_asset_transfer_repay_plan_eso.startdate is '分期开始日期';
comment on column ${iol_schema}.icms_mybk_asset_transfer_repay_plan_eso.enddate is '分期结束日期';
comment on column ${iol_schema}.icms_mybk_asset_transfer_repay_plan_eso.prinamt is '本金金额（单位分）';
comment on column ${iol_schema}.icms_mybk_asset_transfer_repay_plan_eso.intamt is '初始利息匡算金额（单位分）';
comment on column ${iol_schema}.icms_mybk_asset_transfer_repay_plan_eso.bsntype is '产品业务类型';
comment on column ${iol_schema}.icms_mybk_asset_transfer_repay_plan_eso.regioncode is '行政区划代码';
comment on column ${iol_schema}.icms_mybk_asset_transfer_repay_plan_eso.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_mybk_asset_transfer_repay_plan_eso.etl_timestamp is 'ETL处理时间戳';
