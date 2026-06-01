/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_finance_assetpool
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_finance_assetpool
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_finance_assetpool purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_finance_assetpool(
    clrid varchar2(32) -- 押品编号
    ,poolcode varchar2(32) -- 资产池编号
    ,poolaccount varchar2(200) -- 保证金账户
    ,poolamount number(38,0) -- 资产数量
    ,poolmoney number(24,6) -- 资产汇总金额
    ,tdcurrency varchar2(3) -- 币种
    ,money number(24,6) -- 质押金额
    ,islimit varchar2(2) -- 是否占用集团额度
    ,remark varchar2(4000) -- 其他说明
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
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
grant select on ${iol_schema}.icms_clr_asset_finance_assetpool to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_assetpool to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_assetpool to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_assetpool to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_finance_assetpool is '金融质押品之资产池';
comment on column ${iol_schema}.icms_clr_asset_finance_assetpool.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_finance_assetpool.poolcode is '资产池编号';
comment on column ${iol_schema}.icms_clr_asset_finance_assetpool.poolaccount is '保证金账户';
comment on column ${iol_schema}.icms_clr_asset_finance_assetpool.poolamount is '资产数量';
comment on column ${iol_schema}.icms_clr_asset_finance_assetpool.poolmoney is '资产汇总金额';
comment on column ${iol_schema}.icms_clr_asset_finance_assetpool.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_finance_assetpool.money is '质押金额';
comment on column ${iol_schema}.icms_clr_asset_finance_assetpool.islimit is '是否占用集团额度';
comment on column ${iol_schema}.icms_clr_asset_finance_assetpool.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_finance_assetpool.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_finance_assetpool.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_finance_assetpool.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_finance_assetpool.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_finance_assetpool.etl_timestamp is 'ETL处理时间戳';
