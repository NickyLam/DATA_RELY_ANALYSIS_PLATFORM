/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_hkincomesimple
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_hkincomesimple
whenever sqlerror continue none;
drop table ${iol_schema}.wind_hkincomesimple purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hkincomesimple(
    object_id varchar2(300) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司id
    ,report_type varchar2(150) -- 报告类型
    ,statement_type varchar2(60) -- 报表类型代码
    ,fiscalyear varchar2(12) -- 会计年度
    ,begindate varchar2(12) -- 起始日期
    ,enddate varchar2(12) -- 截止日期
    ,tot_oper_rev number(20,4) -- 总营业收入
    ,tot_oper_cost number(20,4) -- 总营业支出
    ,opprofit number(20,4) -- 营业利润
    ,profit_bef_tax number(20,4) -- 除税前利润(除税前盈利)
    ,less_tax number(20,4) -- 所得税
    ,minority_int_inc number(20,4) -- 少数股东损益
    ,net_profit_cs number(20,4) -- 净利润
    ,np_belongto_commonsh number(20,4) -- 归属普通股东净利润
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
grant select on ${iol_schema}.wind_hkincomesimple to ${iml_schema};
grant select on ${iol_schema}.wind_hkincomesimple to ${icl_schema};
grant select on ${iol_schema}.wind_hkincomesimple to ${idl_schema};
grant select on ${iol_schema}.wind_hkincomesimple to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_hkincomesimple is '香港股票利润表（简表）';
comment on column ${iol_schema}.wind_hkincomesimple.object_id is '对象ID';
comment on column ${iol_schema}.wind_hkincomesimple.s_info_compcode is '公司id';
comment on column ${iol_schema}.wind_hkincomesimple.report_type is '报告类型';
comment on column ${iol_schema}.wind_hkincomesimple.statement_type is '报表类型代码';
comment on column ${iol_schema}.wind_hkincomesimple.fiscalyear is '会计年度';
comment on column ${iol_schema}.wind_hkincomesimple.begindate is '起始日期';
comment on column ${iol_schema}.wind_hkincomesimple.enddate is '截止日期';
comment on column ${iol_schema}.wind_hkincomesimple.tot_oper_rev is '总营业收入';
comment on column ${iol_schema}.wind_hkincomesimple.tot_oper_cost is '总营业支出';
comment on column ${iol_schema}.wind_hkincomesimple.opprofit is '营业利润';
comment on column ${iol_schema}.wind_hkincomesimple.profit_bef_tax is '除税前利润(除税前盈利)';
comment on column ${iol_schema}.wind_hkincomesimple.less_tax is '所得税';
comment on column ${iol_schema}.wind_hkincomesimple.minority_int_inc is '少数股东损益';
comment on column ${iol_schema}.wind_hkincomesimple.net_profit_cs is '净利润';
comment on column ${iol_schema}.wind_hkincomesimple.np_belongto_commonsh is '归属普通股东净利润';
comment on column ${iol_schema}.wind_hkincomesimple.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_hkincomesimple.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_hkincomesimple.acc_sta_code is '会计准则类型代码';
comment on column ${iol_schema}.wind_hkincomesimple.start_dt is '开始时间';
comment on column ${iol_schema}.wind_hkincomesimple.end_dt is '结束时间';
comment on column ${iol_schema}.wind_hkincomesimple.id_mark is '增删标志';
comment on column ${iol_schema}.wind_hkincomesimple.etl_timestamp is 'ETL处理时间戳';
