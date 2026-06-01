/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_ashareannfinancialindicator
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_ashareannfinancialindicator
whenever sqlerror continue none;
drop table ${iol_schema}.wind_ashareannfinancialindicator purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_ashareannfinancialindicator(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,s_info_compcode varchar2(15) -- 公司ID
    ,ann_dt varchar2(12) -- 公告日期
    ,report_period varchar2(12) -- 报告期
    ,iflisted_data number(5,0) -- 是否上市后数据
    ,statement_type number(9,0) -- 报表类型代码
    ,crncy_code varchar2(15) -- 货币代码
    ,s_fa_eps_diluted number(20,4) -- 每股收益-摊薄(元)
    ,s_fa_eps_basic number(24,6) -- 每股收益-基本
    ,s_fa_eps_diluted2 number(20,6) -- 每股收益-稀释(元)
    ,s_fa_eps_ex number(20,4) -- 每股收益-扣除(元)
    ,s_fa_eps_exbasic number(24,6) -- 每股收益-扣除/基本
    ,s_fa_eps_exdiluted number(24,6) -- 每股收益-扣除/稀释(元)
    ,s_fa_bps number(22,4) -- 每股净资产(元)
    ,s_fa_bps_sh number(20,4) -- 归属于母公司股东的每股净资产(元)
    ,s_fa_bps_adjust number(20,4) -- 每股净资产-调整(元)
    ,roe_diluted number(20,4) -- 净资产收益率-摊薄(%)
    ,roe_weighted number(24,6) -- 净资产收益率-加权(%)
    ,roe_ex number(20,4) -- 净资产收益率-扣除(%)
    ,roe_exweighted number(24,6) -- 净资产收益率-扣除/加权(%)
    ,net_profit number(20,4) -- 国际会计准则净利润(元)
    ,rd_expense number(20,4) -- 研发费用(元)
    ,s_fa_extraordinary number(22,4) -- 非经常性损益(元)
    ,s_fa_current number(20,4) -- 流动比(%)
    ,s_fa_quick number(20,4) -- 速动比(%)
    ,s_fa_arturn number(20,4) -- 应收账款周转率(%)
    ,s_fa_invturn number(20,4) -- 存货周转率(%)
    ,s_ft_debttoassets number(20,4) -- 资产负债率(%)
    ,s_fa_ocfps number(20,4) -- 每股经营活动产生的现金流量净额(元)
    ,s_fa_yoyocfps number(22,4) -- 同比增长率.每股经营活动产生的现金流量净额(%)
    ,s_fa_deductedprofit number(20,4) -- 扣除非经常性损益后的净利润(扣除少数股东损益)
    ,s_fa_deductedprofit_yoy number(22,4) -- 同比增长率.扣除非经常性损益后的净利润(扣除少数股东损益)(%)
    ,contributionps number(20,4) -- 每股社会贡献值(元)
    ,growth_bps_sh number(22,4) -- 比年初增长率.归属于母公司股东的每股净资产(%)
    ,s_fa_yoyequity number(22,4) -- 比年初增长率.归属母公司的股东权益(%)
    ,yoy_roe_diluted number(22,4) -- 同比增长率.净资产收益率(摊薄)(%)
    ,yoy_net_cash_flows number(22,4) -- 同比增长率.经营活动产生的现金流量净额(%)
    ,s_fa_yoyeps_basic number(22,4) -- 同比增长率.基本每股收益(%)
    ,s_fa_yoyeps_diluted number(22,4) -- 同比增长率.稀释每股收益(%)
    ,s_fa_yoyop number(20,4) -- 同比增长率.营业利润(%)
    ,s_fa_yoyebt number(20,4) -- 同比增长率.利润总额(%)
    ,net_profit_yoy number(20,4) -- 同比增长率.净利润(%)
    ,memo varchar2(300) -- 备注
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
grant select on ${iol_schema}.wind_ashareannfinancialindicator to ${iml_schema};
grant select on ${iol_schema}.wind_ashareannfinancialindicator to ${icl_schema};
grant select on ${iol_schema}.wind_ashareannfinancialindicator to ${idl_schema};
grant select on ${iol_schema}.wind_ashareannfinancialindicator to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_ashareannfinancialindicator is '中国A股公布重要财务指标';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.object_id is '对象ID';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.report_period is '报告期';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.iflisted_data is '是否上市后数据';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.statement_type is '报表类型代码';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_eps_diluted is '每股收益-摊薄(元)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_eps_basic is '每股收益-基本';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_eps_diluted2 is '每股收益-稀释(元)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_eps_ex is '每股收益-扣除(元)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_eps_exbasic is '每股收益-扣除/基本';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_eps_exdiluted is '每股收益-扣除/稀释(元)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_bps is '每股净资产(元)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_bps_sh is '归属于母公司股东的每股净资产(元)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_bps_adjust is '每股净资产-调整(元)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.roe_diluted is '净资产收益率-摊薄(%)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.roe_weighted is '净资产收益率-加权(%)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.roe_ex is '净资产收益率-扣除(%)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.roe_exweighted is '净资产收益率-扣除/加权(%)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.net_profit is '国际会计准则净利润(元)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.rd_expense is '研发费用(元)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_extraordinary is '非经常性损益(元)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_current is '流动比(%)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_quick is '速动比(%)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_arturn is '应收账款周转率(%)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_invturn is '存货周转率(%)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_ft_debttoassets is '资产负债率(%)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_ocfps is '每股经营活动产生的现金流量净额(元)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_yoyocfps is '同比增长率.每股经营活动产生的现金流量净额(%)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_deductedprofit is '扣除非经常性损益后的净利润(扣除少数股东损益)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_deductedprofit_yoy is '同比增长率.扣除非经常性损益后的净利润(扣除少数股东损益)(%)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.contributionps is '每股社会贡献值(元)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.growth_bps_sh is '比年初增长率.归属于母公司股东的每股净资产(%)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_yoyequity is '比年初增长率.归属母公司的股东权益(%)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.yoy_roe_diluted is '同比增长率.净资产收益率(摊薄)(%)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.yoy_net_cash_flows is '同比增长率.经营活动产生的现金流量净额(%)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_yoyeps_basic is '同比增长率.基本每股收益(%)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_yoyeps_diluted is '同比增长率.稀释每股收益(%)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_yoyop is '同比增长率.营业利润(%)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.s_fa_yoyebt is '同比增长率.利润总额(%)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.net_profit_yoy is '同比增长率.净利润(%)';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.memo is '备注';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_ashareannfinancialindicator.etl_timestamp is 'ETL处理时间戳';
