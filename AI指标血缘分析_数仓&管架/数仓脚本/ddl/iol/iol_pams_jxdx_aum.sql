/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_aum
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_aum
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_aum purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_aum(
    jxdxdh number(22) -- 绩效对象代号
    ,khh varchar2(90) -- 客户号
    ,khzt varchar2(3) -- 开户状态
    ,xhrq number(22) -- 销户日期
    ,aumye number(25,4) -- AUM余额
    ,aumyrj number(25,4) -- AUM月日均
    ,aumjrj number(25,4) -- AUM季日均
    ,aumnrj number(25,4) -- AUM年累计
    ,tjrq number(22) -- 统计日期
    ,lskhbz1 varchar2(2) -- 判断是否包含一二三类账户或存单存折的非互联网客户，1-是，0-否
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
grant select on ${iol_schema}.pams_jxdx_aum to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_aum to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_aum to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_aum to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_aum is '绩效对象_AUM';
comment on column ${iol_schema}.pams_jxdx_aum.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_aum.khh is '客户号';
comment on column ${iol_schema}.pams_jxdx_aum.khzt is '开户状态';
comment on column ${iol_schema}.pams_jxdx_aum.xhrq is '销户日期';
comment on column ${iol_schema}.pams_jxdx_aum.aumye is 'AUM余额';
comment on column ${iol_schema}.pams_jxdx_aum.aumyrj is 'AUM月日均';
comment on column ${iol_schema}.pams_jxdx_aum.aumjrj is 'AUM季日均';
comment on column ${iol_schema}.pams_jxdx_aum.aumnrj is 'AUM年累计';
comment on column ${iol_schema}.pams_jxdx_aum.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxdx_aum.lskhbz1 is '判断是否包含一二三类账户或存单存折的非互联网客户，1-是，0-否';
comment on column ${iol_schema}.pams_jxdx_aum.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxdx_aum.etl_timestamp is 'ETL处理时间戳';
