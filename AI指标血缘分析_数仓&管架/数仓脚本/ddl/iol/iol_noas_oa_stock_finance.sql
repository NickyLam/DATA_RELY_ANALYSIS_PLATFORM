/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol noas_oa_stock_finance
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.noas_oa_stock_finance
whenever sqlerror continue none;
drop table ${iol_schema}.noas_oa_stock_finance purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_stock_finance(
    stock_finance_id varchar2(30) -- 
    ,stock_info_id varchar2(30) -- 
    ,a_particular_year varchar2(15) -- 
    ,total_assets varchar2(90) -- 
    ,gross_liability varchar2(90) -- 
    ,net_asset varchar2(90) -- 
    ,retained_profits varchar2(90) -- 
    ,ratio_of_liabilities varchar2(90) -- 
    ,balance_investment varchar2(90) -- 
    ,balance_net_asset_ratio varchar2(90) -- 
    ,last_updated_stamp timestamp -- 
    ,last_updated_tx_stamp timestamp -- 
    ,created_stamp timestamp -- 
    ,created_tx_stamp timestamp -- 
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
grant select on ${iol_schema}.noas_oa_stock_finance to ${iml_schema};
grant select on ${iol_schema}.noas_oa_stock_finance to ${icl_schema};
grant select on ${iol_schema}.noas_oa_stock_finance to ${idl_schema};
grant select on ${iol_schema}.noas_oa_stock_finance to ${iel_schema};

-- comment
comment on table ${iol_schema}.noas_oa_stock_finance is '股东财务表';
comment on column ${iol_schema}.noas_oa_stock_finance.stock_finance_id is '';
comment on column ${iol_schema}.noas_oa_stock_finance.stock_info_id is '';
comment on column ${iol_schema}.noas_oa_stock_finance.a_particular_year is '';
comment on column ${iol_schema}.noas_oa_stock_finance.total_assets is '';
comment on column ${iol_schema}.noas_oa_stock_finance.gross_liability is '';
comment on column ${iol_schema}.noas_oa_stock_finance.net_asset is '';
comment on column ${iol_schema}.noas_oa_stock_finance.retained_profits is '';
comment on column ${iol_schema}.noas_oa_stock_finance.ratio_of_liabilities is '';
comment on column ${iol_schema}.noas_oa_stock_finance.balance_investment is '';
comment on column ${iol_schema}.noas_oa_stock_finance.balance_net_asset_ratio is '';
comment on column ${iol_schema}.noas_oa_stock_finance.last_updated_stamp is '';
comment on column ${iol_schema}.noas_oa_stock_finance.last_updated_tx_stamp is '';
comment on column ${iol_schema}.noas_oa_stock_finance.created_stamp is '';
comment on column ${iol_schema}.noas_oa_stock_finance.created_tx_stamp is '';
comment on column ${iol_schema}.noas_oa_stock_finance.start_dt is '开始时间';
comment on column ${iol_schema}.noas_oa_stock_finance.end_dt is '结束时间';
comment on column ${iol_schema}.noas_oa_stock_finance.id_mark is '增删标志';
comment on column ${iol_schema}.noas_oa_stock_finance.etl_timestamp is 'ETL处理时间戳';
