/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_pbc_report_balance
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_pbc_report_balance
whenever sqlerror continue none;
drop table ${iol_schema}.fams_pbc_report_balance purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_pbc_report_balance(
    detailuuid varchar2(72) -- 明细统计uuid
    ,reporttype varchar2(100) -- 报表类型2_1-资管产品资产负债统计
    ,grouptype varchar2(100) -- 分组类型 资产-ASSET，负债-DEBT 资产负债合计-ASSETDEBTSUM
    ,propertycode varchar2(100) -- 属性代码
    ,cny number(30,2) -- 人民币
    ,usd_to_cny number(30,2) -- 美元折人民币
    ,eur_to_cny number(30,2) -- 欧元折人民币
    ,gbp_to_cny number(30,2) -- 英镑折人民币
    ,jpy_to_cny number(30,2) -- 日元折人民币
    ,oth_to_cny number(30,2) -- 其他币种折人名币
    ,total number(30,2) -- 合计
    ,reportuuid varchar2(72) -- 主表关联id
    ,ccy_amount varchar2(2048) -- 币种金额信息，多币种存值，人民币也存值，格式：CNY,原币金额,折人民币金额;USD,原币金额,折人民币金额
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
grant select on ${iol_schema}.fams_pbc_report_balance to ${iml_schema};
grant select on ${iol_schema}.fams_pbc_report_balance to ${icl_schema};
grant select on ${iol_schema}.fams_pbc_report_balance to ${idl_schema};
grant select on ${iol_schema}.fams_pbc_report_balance to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_pbc_report_balance is '资管产品资产负债统计表';
comment on column ${iol_schema}.fams_pbc_report_balance.detailuuid is '明细统计uuid';
comment on column ${iol_schema}.fams_pbc_report_balance.reporttype is '报表类型2_1-资管产品资产负债统计';
comment on column ${iol_schema}.fams_pbc_report_balance.grouptype is '分组类型 资产-ASSET，负债-DEBT 资产负债合计-ASSETDEBTSUM';
comment on column ${iol_schema}.fams_pbc_report_balance.propertycode is '属性代码';
comment on column ${iol_schema}.fams_pbc_report_balance.cny is '人民币';
comment on column ${iol_schema}.fams_pbc_report_balance.usd_to_cny is '美元折人民币';
comment on column ${iol_schema}.fams_pbc_report_balance.eur_to_cny is '欧元折人民币';
comment on column ${iol_schema}.fams_pbc_report_balance.gbp_to_cny is '英镑折人民币';
comment on column ${iol_schema}.fams_pbc_report_balance.jpy_to_cny is '日元折人民币';
comment on column ${iol_schema}.fams_pbc_report_balance.oth_to_cny is '其他币种折人名币';
comment on column ${iol_schema}.fams_pbc_report_balance.total is '合计';
comment on column ${iol_schema}.fams_pbc_report_balance.reportuuid is '主表关联id';
comment on column ${iol_schema}.fams_pbc_report_balance.ccy_amount is '币种金额信息，多币种存值，人民币也存值，格式：CNY,原币金额,折人民币金额;USD,原币金额,折人民币金额';
comment on column ${iol_schema}.fams_pbc_report_balance.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.fams_pbc_report_balance.etl_timestamp is 'ETL处理时间戳';
