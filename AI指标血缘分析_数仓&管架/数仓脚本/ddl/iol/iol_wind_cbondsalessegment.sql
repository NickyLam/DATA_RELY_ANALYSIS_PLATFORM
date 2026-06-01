/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondsalessegment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondsalessegment
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondsalessegment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondsalessegment(
    object_id varchar2(57) -- 对象ID
    ,s_info_compcode varchar2(15) -- 公司ID
    ,s_segment_item varchar2(200) -- 主营业务项目
    ,s_segment_cost_ratio number(20,4) -- 主营业务成本比例(%)
    ,s_segment_profit_ratio number(20,4) -- 主营业务利润比例(%)
    ,s_segment_sales_ratio number(20,4) -- 主营业务收入比例(%)
    ,s_report_period varchar2(12) -- 报告期
    ,s_crncy_code varchar2(15) -- 货币代码
    ,s_segment_sales number(20,4) -- 主营业务收入
    ,s_segment_profit number(20,4) -- 主营业务利润
    ,s_segment_itemcode varchar2(75) -- 项目类别
    ,s_segment_cost number(20,4) -- 主营业务成本
    ,s_grossprofitmargin number(20,4) -- 毛利率(%)
    ,s_prime_oper_rev_yoy number(20,4) -- 主营业务收入比上年增减(%)
    ,s_prime_oper_cost_yoy number(20,4) -- 主营业务成本比上年增减(%)
    ,s_gross_profit_margin_yoy number(20,4) -- 毛利率比上年增减(%)
    ,s_segment_item_code varchar2(150) -- 容错后主营业务项目
    ,s_segment_sales_code number(9,0) -- 主营业务收入项目代码
    ,s_accounts_id varchar2(30) -- 科目ID
    ,s_is_publishvalue number(1,0) -- [内部]是否公布值
    ,s_gross_profit_yoy number(20,4) -- 毛利同比增长率
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
grant select on ${iol_schema}.wind_cbondsalessegment to ${iml_schema};
grant select on ${iol_schema}.wind_cbondsalessegment to ${icl_schema};
grant select on ${iol_schema}.wind_cbondsalessegment to ${idl_schema};
grant select on ${iol_schema}.wind_cbondsalessegment to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondsalessegment is '中国债券发行主体主营业务收入构成';
comment on column ${iol_schema}.wind_cbondsalessegment.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondsalessegment.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_cbondsalessegment.s_segment_item is '主营业务项目';
comment on column ${iol_schema}.wind_cbondsalessegment.s_segment_cost_ratio is '主营业务成本比例(%)';
comment on column ${iol_schema}.wind_cbondsalessegment.s_segment_profit_ratio is '主营业务利润比例(%)';
comment on column ${iol_schema}.wind_cbondsalessegment.s_segment_sales_ratio is '主营业务收入比例(%)';
comment on column ${iol_schema}.wind_cbondsalessegment.s_report_period is '报告期';
comment on column ${iol_schema}.wind_cbondsalessegment.s_crncy_code is '货币代码';
comment on column ${iol_schema}.wind_cbondsalessegment.s_segment_sales is '主营业务收入';
comment on column ${iol_schema}.wind_cbondsalessegment.s_segment_profit is '主营业务利润';
comment on column ${iol_schema}.wind_cbondsalessegment.s_segment_itemcode is '项目类别';
comment on column ${iol_schema}.wind_cbondsalessegment.s_segment_cost is '主营业务成本';
comment on column ${iol_schema}.wind_cbondsalessegment.s_grossprofitmargin is '毛利率(%)';
comment on column ${iol_schema}.wind_cbondsalessegment.s_prime_oper_rev_yoy is '主营业务收入比上年增减(%)';
comment on column ${iol_schema}.wind_cbondsalessegment.s_prime_oper_cost_yoy is '主营业务成本比上年增减(%)';
comment on column ${iol_schema}.wind_cbondsalessegment.s_gross_profit_margin_yoy is '毛利率比上年增减(%)';
comment on column ${iol_schema}.wind_cbondsalessegment.s_segment_item_code is '容错后主营业务项目';
comment on column ${iol_schema}.wind_cbondsalessegment.s_segment_sales_code is '主营业务收入项目代码';
comment on column ${iol_schema}.wind_cbondsalessegment.s_accounts_id is '科目ID';
comment on column ${iol_schema}.wind_cbondsalessegment.s_is_publishvalue is '[内部]是否公布值';
comment on column ${iol_schema}.wind_cbondsalessegment.s_gross_profit_yoy is '毛利同比增长率';
comment on column ${iol_schema}.wind_cbondsalessegment.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbondsalessegment.etl_timestamp is 'ETL处理时间戳';
