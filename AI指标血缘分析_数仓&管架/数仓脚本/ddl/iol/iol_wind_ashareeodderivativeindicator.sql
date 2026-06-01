/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_ashareeodderivativeindicator
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_ashareeodderivativeindicator
whenever sqlerror continue none;
drop table ${iol_schema}.wind_ashareeodderivativeindicator purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_ashareeodderivativeindicator(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,trade_dt varchar2(12) -- 交易日期
    ,crncy_code varchar2(15) -- 货币代码
    ,s_val_mv number(20,4) -- 当日总市值
    ,s_dq_mv number(20,4) -- 当日流通市值
    ,s_pq_high_52w_ number(20,4) -- 52周最高价
    ,s_pq_low_52w_ number(20,4) -- 52周最低价
    ,s_val_pe number(20,4) -- 市盈率(PE)
    ,s_val_pb_new number(20,4) -- 市净率(PB)
    ,s_val_pe_ttm number(20,4) -- 市盈率(PE,TTM)
    ,s_val_pcf_ocf number(20,4) -- 市现率(PCF,经营现金流)
    ,s_val_pcf_ocfttm number(20,4) -- 市现率(PCF,经营现金流TTM)
    ,s_val_pcf_ncf number(20,4) -- 市现率(PCF,现金净流量)
    ,s_val_pcf_ncfttm number(20,4) -- 市现率(PCF,现金净流量TTM)
    ,s_val_ps number(20,4) -- 市销率(PS)
    ,s_val_ps_ttm number(20,4) -- 市销率(PS,TTM)
    ,s_dq_turn number(20,4) -- 换手率
    ,s_dq_freeturnover number(20,4) -- 换手率(基准.自由流通股本)
    ,tot_shr_today number(24,8) -- 当日总股本
    ,float_a_shr_today number(24,8) -- 当日流通股本
    ,s_dq_close_today number(20,4) -- 当日收盘价
    ,s_price_div_dps number(20,4) -- 股价/每股派息
    ,s_pq_adjhigh_52w number(20,4) -- 52周最高价(复权)
    ,s_pq_adjlow_52w number(20,4) -- 52周最低价(复权)
    ,free_shares_today number(24,8) -- 当日自由流通股本
    ,net_profit_parent_comp_ttm number(20,4) -- 归属母公司净利润(TTM)
    ,net_profit_parent_comp_lyr number(20,4) -- 归属母公司净利润(LYR)
    ,net_assets_today number(20,4) -- 当日净资产
    ,net_cash_flows_oper_act_ttm number(20,4) -- 经营活动产生的现金流量净额(TTM)
    ,net_cash_flows_oper_act_lyr number(20,4) -- 经营活动产生的现金流量净额(LYR)
    ,oper_rev_ttm number(20,4) -- 营业收入(TTM)
    ,oper_rev_lyr number(20,4) -- 营业收入(LYR)
    ,net_incr_cash_cash_equ_ttm number(20,4) -- 现金及现金等价物净增加额(TTM)
    ,net_incr_cash_cash_equ_lyr number(20,4) -- 现金及现金等价物净增加额(LYR)
    ,up_down_limit_status number(2,0) -- 涨跌停状态
    ,lowest_highest_status number(2,0) -- 最高最低价状态
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
grant select on ${iol_schema}.wind_ashareeodderivativeindicator to ${iml_schema};
grant select on ${iol_schema}.wind_ashareeodderivativeindicator to ${icl_schema};
grant select on ${iol_schema}.wind_ashareeodderivativeindicator to ${idl_schema};
grant select on ${iol_schema}.wind_ashareeodderivativeindicator to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_ashareeodderivativeindicator is '中国A股日行情估值指标';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.object_id is '对象ID';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.trade_dt is '交易日期';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.s_val_mv is '当日总市值';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.s_dq_mv is '当日流通市值';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.s_pq_high_52w_ is '52周最高价';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.s_pq_low_52w_ is '52周最低价';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.s_val_pe is '市盈率(PE)';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.s_val_pb_new is '市净率(PB)';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.s_val_pe_ttm is '市盈率(PE,TTM)';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.s_val_pcf_ocf is '市现率(PCF,经营现金流)';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.s_val_pcf_ocfttm is '市现率(PCF,经营现金流TTM)';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.s_val_pcf_ncf is '市现率(PCF,现金净流量)';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.s_val_pcf_ncfttm is '市现率(PCF,现金净流量TTM)';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.s_val_ps is '市销率(PS)';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.s_val_ps_ttm is '市销率(PS,TTM)';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.s_dq_turn is '换手率';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.s_dq_freeturnover is '换手率(基准.自由流通股本)';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.tot_shr_today is '当日总股本';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.float_a_shr_today is '当日流通股本';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.s_dq_close_today is '当日收盘价';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.s_price_div_dps is '股价/每股派息';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.s_pq_adjhigh_52w is '52周最高价(复权)';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.s_pq_adjlow_52w is '52周最低价(复权)';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.free_shares_today is '当日自由流通股本';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.net_profit_parent_comp_ttm is '归属母公司净利润(TTM)';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.net_profit_parent_comp_lyr is '归属母公司净利润(LYR)';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.net_assets_today is '当日净资产';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.net_cash_flows_oper_act_ttm is '经营活动产生的现金流量净额(TTM)';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.net_cash_flows_oper_act_lyr is '经营活动产生的现金流量净额(LYR)';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.oper_rev_ttm is '营业收入(TTM)';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.oper_rev_lyr is '营业收入(LYR)';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.net_incr_cash_cash_equ_ttm is '现金及现金等价物净增加额(TTM)';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.net_incr_cash_cash_equ_lyr is '现金及现金等价物净增加额(LYR)';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.up_down_limit_status is '涨跌停状态';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.lowest_highest_status is '最高最低价状态';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_ashareeodderivativeindicator.etl_timestamp is 'ETL处理时间戳';
