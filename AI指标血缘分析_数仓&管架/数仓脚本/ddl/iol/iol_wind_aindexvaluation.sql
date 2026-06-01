/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_aindexvaluation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_aindexvaluation
whenever sqlerror continue none;
drop table ${iol_schema}.wind_aindexvaluation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_aindexvaluation(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- 指数Wind代码
    ,trade_dt varchar2(12) -- 交易日期
    ,con_num number(20,4) -- 成分股数量
    ,pe_lyr number(20,4) -- 市盈率(PE,LYR)
    ,pe_ttm number(20,4) -- 市盈率(PE,TTM)
    ,pb_lf number(20,4) -- 市净率(PB,LF)
    ,pcf_lyr number(20,4) -- 市现率(PCF,LYR)
    ,pcf_ttm number(20,4) -- 市现率(PCF,TTM)
    ,ps_lyr number(20,4) -- 市销率(PS,LYR)
    ,ps_ttm number(20,4) -- 市销率(PS,TTM)
    ,mv_total number(24,4) -- 当日总市值合计（元）
    ,mv_float number(24,4) -- 当日流通市值合计（元）
    ,dividend_yield number(20,4) -- 股息率
    ,peg_his number(20,4) -- 历史PEG
    ,tot_shr number(24,4) -- 总股本合计（股）
    ,tot_shr_float number(24,4) -- 流通股本合计（股）
    ,tot_shr_free number(24,4) -- 自由流通股本合计（股）
    ,turnover number(20,4) -- 换手率
    ,turnover_free number(20,4) -- 换手率(自由流通)
    ,est_net_profit_y1 number(20,4) -- 预测净利润(Y1)
    ,est_net_profit_y2 number(20,4) -- 预测净利润(Y2)
    ,est_bus_inc_y1 number(20,4) -- 预测营业收入(Y1)
    ,est_bus_inc_y2 number(20,4) -- 预测营业收入(Y2)
    ,est_eps_y1 number(20,4) -- 预测每股收益(Y1)
    ,est_eps_y2 number(20,4) -- 预测每股收益(Y2)
    ,est_yoyprofit_y1 number(20,4) -- 预测净利润同比增速(Y1)
    ,est_yoyprofit_y2 number(20,4) -- 预测净利润同比增速(Y2)
    ,est_yoygr_y1 number(20,4) -- 预测营业收入同比增速(Y1)
    ,est_yoygr_y2 number(20,4) -- 预测营业收入同比增速(Y2)
    ,est_pe_y1 number(20,4) -- 预测PE(Y1)
    ,est_pe_y2 number(20,4) -- 预测PE(Y2)
    ,est_peg_y1 number(20,4) -- 预测PEG(Y1)
    ,est_peg_y2 number(20,4) -- 预测PEG(Y2)
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
grant select on ${iol_schema}.wind_aindexvaluation to ${iml_schema};
grant select on ${iol_schema}.wind_aindexvaluation to ${icl_schema};
grant select on ${iol_schema}.wind_aindexvaluation to ${idl_schema};
grant select on ${iol_schema}.wind_aindexvaluation to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_aindexvaluation is '中国A股指数估值数据';
comment on column ${iol_schema}.wind_aindexvaluation.object_id is '对象ID';
comment on column ${iol_schema}.wind_aindexvaluation.s_info_windcode is '指数Wind代码';
comment on column ${iol_schema}.wind_aindexvaluation.trade_dt is '交易日期';
comment on column ${iol_schema}.wind_aindexvaluation.con_num is '成分股数量';
comment on column ${iol_schema}.wind_aindexvaluation.pe_lyr is '市盈率(PE,LYR)';
comment on column ${iol_schema}.wind_aindexvaluation.pe_ttm is '市盈率(PE,TTM)';
comment on column ${iol_schema}.wind_aindexvaluation.pb_lf is '市净率(PB,LF)';
comment on column ${iol_schema}.wind_aindexvaluation.pcf_lyr is '市现率(PCF,LYR)';
comment on column ${iol_schema}.wind_aindexvaluation.pcf_ttm is '市现率(PCF,TTM)';
comment on column ${iol_schema}.wind_aindexvaluation.ps_lyr is '市销率(PS,LYR)';
comment on column ${iol_schema}.wind_aindexvaluation.ps_ttm is '市销率(PS,TTM)';
comment on column ${iol_schema}.wind_aindexvaluation.mv_total is '当日总市值合计（元）';
comment on column ${iol_schema}.wind_aindexvaluation.mv_float is '当日流通市值合计（元）';
comment on column ${iol_schema}.wind_aindexvaluation.dividend_yield is '股息率';
comment on column ${iol_schema}.wind_aindexvaluation.peg_his is '历史PEG';
comment on column ${iol_schema}.wind_aindexvaluation.tot_shr is '总股本合计（股）';
comment on column ${iol_schema}.wind_aindexvaluation.tot_shr_float is '流通股本合计（股）';
comment on column ${iol_schema}.wind_aindexvaluation.tot_shr_free is '自由流通股本合计（股）';
comment on column ${iol_schema}.wind_aindexvaluation.turnover is '换手率';
comment on column ${iol_schema}.wind_aindexvaluation.turnover_free is '换手率(自由流通)';
comment on column ${iol_schema}.wind_aindexvaluation.est_net_profit_y1 is '预测净利润(Y1)';
comment on column ${iol_schema}.wind_aindexvaluation.est_net_profit_y2 is '预测净利润(Y2)';
comment on column ${iol_schema}.wind_aindexvaluation.est_bus_inc_y1 is '预测营业收入(Y1)';
comment on column ${iol_schema}.wind_aindexvaluation.est_bus_inc_y2 is '预测营业收入(Y2)';
comment on column ${iol_schema}.wind_aindexvaluation.est_eps_y1 is '预测每股收益(Y1)';
comment on column ${iol_schema}.wind_aindexvaluation.est_eps_y2 is '预测每股收益(Y2)';
comment on column ${iol_schema}.wind_aindexvaluation.est_yoyprofit_y1 is '预测净利润同比增速(Y1)';
comment on column ${iol_schema}.wind_aindexvaluation.est_yoyprofit_y2 is '预测净利润同比增速(Y2)';
comment on column ${iol_schema}.wind_aindexvaluation.est_yoygr_y1 is '预测营业收入同比增速(Y1)';
comment on column ${iol_schema}.wind_aindexvaluation.est_yoygr_y2 is '预测营业收入同比增速(Y2)';
comment on column ${iol_schema}.wind_aindexvaluation.est_pe_y1 is '预测PE(Y1)';
comment on column ${iol_schema}.wind_aindexvaluation.est_pe_y2 is '预测PE(Y2)';
comment on column ${iol_schema}.wind_aindexvaluation.est_peg_y1 is '预测PEG(Y1)';
comment on column ${iol_schema}.wind_aindexvaluation.est_peg_y2 is '预测PEG(Y2)';
comment on column ${iol_schema}.wind_aindexvaluation.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_aindexvaluation.etl_timestamp is 'ETL处理时间戳';
