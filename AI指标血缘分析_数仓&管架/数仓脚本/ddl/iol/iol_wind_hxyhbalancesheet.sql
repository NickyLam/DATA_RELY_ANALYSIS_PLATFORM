/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_hxyhbalancesheet
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_hxyhbalancesheet
whenever sqlerror continue none;
drop table ${iol_schema}.wind_hxyhbalancesheet purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hxyhbalancesheet(
    object_id varchar2(150) -- 对象ID
    ,comp_id varchar2(60) -- 公司ID
    ,ann_dt varchar2(12) -- 公告日期
    ,report_period varchar2(12) -- 报告期
    ,statement_type varchar2(60) -- 报表类型
    ,iflisted_data varchar2(3) -- 是否上市后数据
    ,crncy_code varchar2(15) -- 货币代码
    ,prepay number(20,4) -- 预付账款
    ,inventories number(20,4) -- 存货
    ,acct_rcv number(20,4) -- 应收账款
    ,tot_cur_assets number(20,4) -- 流动资产合计
    ,tot_assets number(20,4) -- 资产合计
    ,st_borrow number(20,4) -- 短期借款
    ,int_payable number(20,4) -- 应付利息
    ,non_cur_liab_due_within_1y number(20,4) -- 一年内到期的非流动负债
    ,tot_cur_liab number(20,4) -- 流动负债合计
    ,lt_borrow number(20,4) -- 长期借款
    ,bonds_payable number(20,4) -- 应付债券
    ,total_liabilities number(20,4) -- 负债合计
    ,cap_stk number(20,4) -- 股本
    ,cap_rsrv number(20,4) -- 资本公积金
    ,tot_shrhldr_eqy_excl_min_int number(20,4) -- 股东权益合计(不含少数股东权益)
    ,tot_shrhldr_eqy_incl_min_int number(20,4) -- 股东权益合计(含少数股东权益)
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
grant select on ${iol_schema}.wind_hxyhbalancesheet to ${iml_schema};
grant select on ${iol_schema}.wind_hxyhbalancesheet to ${icl_schema};
grant select on ${iol_schema}.wind_hxyhbalancesheet to ${idl_schema};
grant select on ${iol_schema}.wind_hxyhbalancesheet to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_hxyhbalancesheet is '华兴银行企业库资产负债表';
comment on column ${iol_schema}.wind_hxyhbalancesheet.object_id is '对象ID';
comment on column ${iol_schema}.wind_hxyhbalancesheet.comp_id is '公司ID';
comment on column ${iol_schema}.wind_hxyhbalancesheet.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_hxyhbalancesheet.report_period is '报告期';
comment on column ${iol_schema}.wind_hxyhbalancesheet.statement_type is '报表类型';
comment on column ${iol_schema}.wind_hxyhbalancesheet.iflisted_data is '是否上市后数据';
comment on column ${iol_schema}.wind_hxyhbalancesheet.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_hxyhbalancesheet.prepay is '预付账款';
comment on column ${iol_schema}.wind_hxyhbalancesheet.inventories is '存货';
comment on column ${iol_schema}.wind_hxyhbalancesheet.acct_rcv is '应收账款';
comment on column ${iol_schema}.wind_hxyhbalancesheet.tot_cur_assets is '流动资产合计';
comment on column ${iol_schema}.wind_hxyhbalancesheet.tot_assets is '资产合计';
comment on column ${iol_schema}.wind_hxyhbalancesheet.st_borrow is '短期借款';
comment on column ${iol_schema}.wind_hxyhbalancesheet.int_payable is '应付利息';
comment on column ${iol_schema}.wind_hxyhbalancesheet.non_cur_liab_due_within_1y is '一年内到期的非流动负债';
comment on column ${iol_schema}.wind_hxyhbalancesheet.tot_cur_liab is '流动负债合计';
comment on column ${iol_schema}.wind_hxyhbalancesheet.lt_borrow is '长期借款';
comment on column ${iol_schema}.wind_hxyhbalancesheet.bonds_payable is '应付债券';
comment on column ${iol_schema}.wind_hxyhbalancesheet.total_liabilities is '负债合计';
comment on column ${iol_schema}.wind_hxyhbalancesheet.cap_stk is '股本';
comment on column ${iol_schema}.wind_hxyhbalancesheet.cap_rsrv is '资本公积金';
comment on column ${iol_schema}.wind_hxyhbalancesheet.tot_shrhldr_eqy_excl_min_int is '股东权益合计(不含少数股东权益)';
comment on column ${iol_schema}.wind_hxyhbalancesheet.tot_shrhldr_eqy_incl_min_int is '股东权益合计(含少数股东权益)';
comment on column ${iol_schema}.wind_hxyhbalancesheet.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_hxyhbalancesheet.etl_timestamp is 'ETL处理时间戳';
