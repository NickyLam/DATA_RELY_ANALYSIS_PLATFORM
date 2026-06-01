/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_hkgsdcashflow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_hkgsdcashflow
whenever sqlerror continue none;
drop table ${iol_schema}.wind_hkgsdcashflow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hkgsdcashflow(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(15) -- 公司id
    ,ann_dt varchar2(12) -- 公告日期
    ,begin_dt varchar2(12) -- 起始日期
    ,end_dt varchar2(12) -- 截止日期
    ,report_type number(9,0) -- 报告类型代码
    ,statement_type number(9,0) -- 报表类型代码
    ,is_calc number(1,0) -- 是否计算值
    ,crncy_code varchar2(30) -- 货币代码
    ,net_cash_flows_oper_act number(20,4) -- 经营活动产生的现金流量净额
    ,net_profit_cs number(20,4) -- 净利润
    ,plus_net_da number(20,4) -- 折旧与摊销
    ,op_cap_change number(20,4) -- 营运资本变动
    ,oth_noncash_change number(20,4) -- 其他非现金调整
    ,net_cash_flows_inv_act number(20,4) -- 投资活动产生的现金流量净额
    ,cash_recp_fixasset_sell number(20,4) -- 出售固定资产收到的现金
    ,less_cap_expense number(20,4) -- 资本性支出
    ,less_inv_incr number(20,4) -- 投资增加
    ,inv_decr number(20,4) -- 投资减少
    ,net_oth_icf number(20,4) -- 其他投资活动产生的现金流量净额
    ,net_cash_flows_fund_act number(20,4) -- 筹资活动产生现金流量净额(融资活动产生的现金流量净额)
    ,debt_incr number(20,4) -- 债务增加
    ,less_debt_decr number(20,4) -- 债务减少
    ,cap_incr number(20,4) -- 股本增加
    ,plus_net_cap_decr number(20,4) -- 股本减少
    ,tot_div_paid number(20,4) -- 支付的股利合计
    ,net_oth_fcf number(20,4) -- 其他筹资活动产生的现金流量净额
    ,e_change_effect number(20,4) -- 汇率变动影响
    ,oth_cf_adjust number(20,4) -- 其他现金流量调整
    ,net_incr_cash_cash_equ number(20,4) -- 现金及现金等价物净增加额
    ,cash_cash_equ_beg_period number(20,4) -- 现金及现金等价物期初余额
    ,cash_cash_equ_end_period number(20,4) -- 现金及现金等价物期末余额
    ,s_meno varchar2(3000) -- 备注
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
grant select on ${iol_schema}.wind_hkgsdcashflow to ${iml_schema};
grant select on ${iol_schema}.wind_hkgsdcashflow to ${icl_schema};
grant select on ${iol_schema}.wind_hkgsdcashflow to ${idl_schema};
grant select on ${iol_schema}.wind_hkgsdcashflow to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_hkgsdcashflow is '香港股票现金流量表(GSD)';
comment on column ${iol_schema}.wind_hkgsdcashflow.object_id is '对象ID';
comment on column ${iol_schema}.wind_hkgsdcashflow.s_info_compcode is '公司id';
comment on column ${iol_schema}.wind_hkgsdcashflow.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_hkgsdcashflow.begin_dt is '起始日期';
comment on column ${iol_schema}.wind_hkgsdcashflow.end_dt is '截止日期';
comment on column ${iol_schema}.wind_hkgsdcashflow.report_type is '报告类型代码';
comment on column ${iol_schema}.wind_hkgsdcashflow.statement_type is '报表类型代码';
comment on column ${iol_schema}.wind_hkgsdcashflow.is_calc is '是否计算值';
comment on column ${iol_schema}.wind_hkgsdcashflow.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_hkgsdcashflow.net_cash_flows_oper_act is '经营活动产生的现金流量净额';
comment on column ${iol_schema}.wind_hkgsdcashflow.net_profit_cs is '净利润';
comment on column ${iol_schema}.wind_hkgsdcashflow.plus_net_da is '折旧与摊销';
comment on column ${iol_schema}.wind_hkgsdcashflow.op_cap_change is '营运资本变动';
comment on column ${iol_schema}.wind_hkgsdcashflow.oth_noncash_change is '其他非现金调整';
comment on column ${iol_schema}.wind_hkgsdcashflow.net_cash_flows_inv_act is '投资活动产生的现金流量净额';
comment on column ${iol_schema}.wind_hkgsdcashflow.cash_recp_fixasset_sell is '出售固定资产收到的现金';
comment on column ${iol_schema}.wind_hkgsdcashflow.less_cap_expense is '资本性支出';
comment on column ${iol_schema}.wind_hkgsdcashflow.less_inv_incr is '投资增加';
comment on column ${iol_schema}.wind_hkgsdcashflow.inv_decr is '投资减少';
comment on column ${iol_schema}.wind_hkgsdcashflow.net_oth_icf is '其他投资活动产生的现金流量净额';
comment on column ${iol_schema}.wind_hkgsdcashflow.net_cash_flows_fund_act is '筹资活动产生现金流量净额(融资活动产生的现金流量净额)';
comment on column ${iol_schema}.wind_hkgsdcashflow.debt_incr is '债务增加';
comment on column ${iol_schema}.wind_hkgsdcashflow.less_debt_decr is '债务减少';
comment on column ${iol_schema}.wind_hkgsdcashflow.cap_incr is '股本增加';
comment on column ${iol_schema}.wind_hkgsdcashflow.plus_net_cap_decr is '股本减少';
comment on column ${iol_schema}.wind_hkgsdcashflow.tot_div_paid is '支付的股利合计';
comment on column ${iol_schema}.wind_hkgsdcashflow.net_oth_fcf is '其他筹资活动产生的现金流量净额';
comment on column ${iol_schema}.wind_hkgsdcashflow.e_change_effect is '汇率变动影响';
comment on column ${iol_schema}.wind_hkgsdcashflow.oth_cf_adjust is '其他现金流量调整';
comment on column ${iol_schema}.wind_hkgsdcashflow.net_incr_cash_cash_equ is '现金及现金等价物净增加额';
comment on column ${iol_schema}.wind_hkgsdcashflow.cash_cash_equ_beg_period is '现金及现金等价物期初余额';
comment on column ${iol_schema}.wind_hkgsdcashflow.cash_cash_equ_end_period is '现金及现金等价物期末余额';
comment on column ${iol_schema}.wind_hkgsdcashflow.s_meno is '备注';
comment on column ${iol_schema}.wind_hkgsdcashflow.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_hkgsdcashflow.etl_timestamp is 'ETL处理时间戳';
