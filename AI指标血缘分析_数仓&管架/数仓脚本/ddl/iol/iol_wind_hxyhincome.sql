/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_hxyhincome
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_hxyhincome
whenever sqlerror continue none;
drop table ${iol_schema}.wind_hxyhincome purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hxyhincome(
    object_id varchar2(150) -- 对象ID
    ,comp_id varchar2(60) -- 公司ID
    ,ann_dt varchar2(12) -- 公告日期
    ,report_period varchar2(12) -- 报告期
    ,statement_type varchar2(60) -- 报表类型
    ,iflisted_data varchar2(3) -- 是否上市后数据
    ,crncy_code varchar2(15) -- 货币代码
    ,tot_oper_rev number(20,4) -- 营业总收入
    ,less_oper_cost number(20,4) -- 减:营业成本
    ,oper_profit number(20,4) -- 营业利润
    ,net_profit_incl_min_int_inc number(20,4) -- 净利润(含少数股东损益)
    ,net_profit_excl_min_int_inc number(20,4) -- 净利润(不含少数股东损益)
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
grant select on ${iol_schema}.wind_hxyhincome to ${iml_schema};
grant select on ${iol_schema}.wind_hxyhincome to ${icl_schema};
grant select on ${iol_schema}.wind_hxyhincome to ${idl_schema};
grant select on ${iol_schema}.wind_hxyhincome to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_hxyhincome is '华兴银行企业库利润表';
comment on column ${iol_schema}.wind_hxyhincome.object_id is '对象ID';
comment on column ${iol_schema}.wind_hxyhincome.comp_id is '公司ID';
comment on column ${iol_schema}.wind_hxyhincome.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_hxyhincome.report_period is '报告期';
comment on column ${iol_schema}.wind_hxyhincome.statement_type is '报表类型';
comment on column ${iol_schema}.wind_hxyhincome.iflisted_data is '是否上市后数据';
comment on column ${iol_schema}.wind_hxyhincome.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_hxyhincome.tot_oper_rev is '营业总收入';
comment on column ${iol_schema}.wind_hxyhincome.less_oper_cost is '减:营业成本';
comment on column ${iol_schema}.wind_hxyhincome.oper_profit is '营业利润';
comment on column ${iol_schema}.wind_hxyhincome.net_profit_incl_min_int_inc is '净利润(含少数股东损益)';
comment on column ${iol_schema}.wind_hxyhincome.net_profit_excl_min_int_inc is '净利润(不含少数股东损益)';
comment on column ${iol_schema}.wind_hxyhincome.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_hxyhincome.etl_timestamp is 'ETL处理时间戳';
