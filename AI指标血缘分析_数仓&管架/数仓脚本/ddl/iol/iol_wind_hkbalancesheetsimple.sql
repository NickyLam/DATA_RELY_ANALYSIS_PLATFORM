/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_hkbalancesheetsimple
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_hkbalancesheetsimple
whenever sqlerror continue none;
drop table ${iol_schema}.wind_hkbalancesheetsimple purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hkbalancesheetsimple(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司id
    ,report_type varchar2(150) -- 报告类型代码
    ,statement_type varchar2(60) -- 报表类型代码
    ,report_period varchar2(12) -- 截至日期
    ,tot_cur_assets number(20,4) -- 流动资产合计
    ,tot_non_cur_assets number(20,4) -- 非流动资产合计
    ,tot_assets number(20,4) -- 总资产
    ,tot_cur_liab number(20,4) -- 流动负债合计
    ,tot_non_cur_liab number(20,4) -- 非流动负债合计
    ,total_liabilities number(20,4) -- 总负债
    ,parsh_int number(20,4) -- 股东权益
    ,minority_int number(20,4) -- 少数股东权益
    ,tot_shrhldr_eqy number(20,4) -- 股东权益合计
    ,crncy_code varchar2(15) -- 货币代码
    ,ann_dt varchar2(12) -- 公告日期
    ,acc_sta_code number(9,0) -- 会计准则类型代码
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
grant select on ${iol_schema}.wind_hkbalancesheetsimple to ${iml_schema};
grant select on ${iol_schema}.wind_hkbalancesheetsimple to ${icl_schema};
grant select on ${iol_schema}.wind_hkbalancesheetsimple to ${idl_schema};
grant select on ${iol_schema}.wind_hkbalancesheetsimple to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_hkbalancesheetsimple is '香港股票资产负债表（简表）';
comment on column ${iol_schema}.wind_hkbalancesheetsimple.object_id is '对象ID';
comment on column ${iol_schema}.wind_hkbalancesheetsimple.s_info_compcode is '公司id';
comment on column ${iol_schema}.wind_hkbalancesheetsimple.report_type is '报告类型代码';
comment on column ${iol_schema}.wind_hkbalancesheetsimple.statement_type is '报表类型代码';
comment on column ${iol_schema}.wind_hkbalancesheetsimple.report_period is '截至日期';
comment on column ${iol_schema}.wind_hkbalancesheetsimple.tot_cur_assets is '流动资产合计';
comment on column ${iol_schema}.wind_hkbalancesheetsimple.tot_non_cur_assets is '非流动资产合计';
comment on column ${iol_schema}.wind_hkbalancesheetsimple.tot_assets is '总资产';
comment on column ${iol_schema}.wind_hkbalancesheetsimple.tot_cur_liab is '流动负债合计';
comment on column ${iol_schema}.wind_hkbalancesheetsimple.tot_non_cur_liab is '非流动负债合计';
comment on column ${iol_schema}.wind_hkbalancesheetsimple.total_liabilities is '总负债';
comment on column ${iol_schema}.wind_hkbalancesheetsimple.parsh_int is '股东权益';
comment on column ${iol_schema}.wind_hkbalancesheetsimple.minority_int is '少数股东权益';
comment on column ${iol_schema}.wind_hkbalancesheetsimple.tot_shrhldr_eqy is '股东权益合计';
comment on column ${iol_schema}.wind_hkbalancesheetsimple.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_hkbalancesheetsimple.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_hkbalancesheetsimple.acc_sta_code is '会计准则类型代码';
comment on column ${iol_schema}.wind_hkbalancesheetsimple.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_hkbalancesheetsimple.etl_timestamp is 'ETL处理时间戳';
