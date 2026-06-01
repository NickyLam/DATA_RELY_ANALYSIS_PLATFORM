/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_hkcashflowsimple
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_hkcashflowsimple
whenever sqlerror continue none;
drop table ${iol_schema}.wind_hkcashflowsimple purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hkcashflowsimple(
    object_id varchar2(300) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司id
    ,report_type varchar2(150) -- 报告类型代码
    ,statement_type varchar2(60) -- 报表类型代码
    ,begindate varchar2(12) -- 起始日期
    ,enddate varchar2(12) -- 截止日期
    ,net_cash_flows_oper_act number(20,4) -- 经营活动产生的现金流量净额
    ,net_cash_flows_inv_act number(20,4) -- 投资活动产生的现金流量净额
    ,net_cash_flows_fund_act number(20,4) -- 筹资活动产生现金流量净额(融资活动产生的现金流量净额)
    ,net_incr_cash_cash_equ number(20,4) -- 现金及现金等价物净增加额
    ,crncy_code varchar2(30) -- 货币代码
    ,ann_dt varchar2(12) -- 公告日期
    ,acc_sta_code number(9,0) -- 会计准则类型代码
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
grant select on ${iol_schema}.wind_hkcashflowsimple to ${iml_schema};
grant select on ${iol_schema}.wind_hkcashflowsimple to ${icl_schema};
grant select on ${iol_schema}.wind_hkcashflowsimple to ${idl_schema};
grant select on ${iol_schema}.wind_hkcashflowsimple to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_hkcashflowsimple is '香港股票现金流量表（简表）';
comment on column ${iol_schema}.wind_hkcashflowsimple.object_id is '对象ID';
comment on column ${iol_schema}.wind_hkcashflowsimple.s_info_compcode is '公司id';
comment on column ${iol_schema}.wind_hkcashflowsimple.report_type is '报告类型代码';
comment on column ${iol_schema}.wind_hkcashflowsimple.statement_type is '报表类型代码';
comment on column ${iol_schema}.wind_hkcashflowsimple.begindate is '起始日期';
comment on column ${iol_schema}.wind_hkcashflowsimple.enddate is '截止日期';
comment on column ${iol_schema}.wind_hkcashflowsimple.net_cash_flows_oper_act is '经营活动产生的现金流量净额';
comment on column ${iol_schema}.wind_hkcashflowsimple.net_cash_flows_inv_act is '投资活动产生的现金流量净额';
comment on column ${iol_schema}.wind_hkcashflowsimple.net_cash_flows_fund_act is '筹资活动产生现金流量净额(融资活动产生的现金流量净额)';
comment on column ${iol_schema}.wind_hkcashflowsimple.net_incr_cash_cash_equ is '现金及现金等价物净增加额';
comment on column ${iol_schema}.wind_hkcashflowsimple.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_hkcashflowsimple.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_hkcashflowsimple.acc_sta_code is '会计准则类型代码';
comment on column ${iol_schema}.wind_hkcashflowsimple.start_dt is '开始时间';
comment on column ${iol_schema}.wind_hkcashflowsimple.end_dt is '结束时间';
comment on column ${iol_schema}.wind_hkcashflowsimple.id_mark is '增删标志';
comment on column ${iol_schema}.wind_hkcashflowsimple.etl_timestamp is 'ETL处理时间戳';
