/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondfinancialexpense
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondfinancialexpense
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondfinancialexpense purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondfinancialexpense(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司id
    ,s_info_compname varchar2(300) -- 公司名称
    ,ann_dt varchar2(12) -- 公告日期
    ,report_period varchar2(12) -- 报告期
    ,statement_typecode number(9,0) -- 报表类型代码
    ,s_stmnote_intexp number(20,4) -- 利息支出
    ,s_stmnote_intinc number(20,4) -- 减：利息收入
    ,s_stmnote_exch number(20,4) -- 汇兑损益
    ,s_stmnote_fee number(20,4) -- 手续费
    ,s_stmnote_others number(20,4) -- 其他
    ,s_stmnote_finexp number(20,4) -- 合计
    ,s_stmnote_finexp_1 number(20,4) -- 利息资本化金额
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
grant select on ${iol_schema}.wind_cbondfinancialexpense to ${iml_schema};
grant select on ${iol_schema}.wind_cbondfinancialexpense to ${icl_schema};
grant select on ${iol_schema}.wind_cbondfinancialexpense to ${idl_schema};
grant select on ${iol_schema}.wind_cbondfinancialexpense to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondfinancialexpense is '中国债券发行主体财务费用明细';
comment on column ${iol_schema}.wind_cbondfinancialexpense.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondfinancialexpense.s_info_compcode is '公司id';
comment on column ${iol_schema}.wind_cbondfinancialexpense.s_info_compname is '公司名称';
comment on column ${iol_schema}.wind_cbondfinancialexpense.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_cbondfinancialexpense.report_period is '报告期';
comment on column ${iol_schema}.wind_cbondfinancialexpense.statement_typecode is '报表类型代码';
comment on column ${iol_schema}.wind_cbondfinancialexpense.s_stmnote_intexp is '利息支出';
comment on column ${iol_schema}.wind_cbondfinancialexpense.s_stmnote_intinc is '减：利息收入';
comment on column ${iol_schema}.wind_cbondfinancialexpense.s_stmnote_exch is '汇兑损益';
comment on column ${iol_schema}.wind_cbondfinancialexpense.s_stmnote_fee is '手续费';
comment on column ${iol_schema}.wind_cbondfinancialexpense.s_stmnote_others is '其他';
comment on column ${iol_schema}.wind_cbondfinancialexpense.s_stmnote_finexp is '合计';
comment on column ${iol_schema}.wind_cbondfinancialexpense.s_stmnote_finexp_1 is '利息资本化金额';
comment on column ${iol_schema}.wind_cbondfinancialexpense.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbondfinancialexpense.etl_timestamp is 'ETL处理时间戳';
