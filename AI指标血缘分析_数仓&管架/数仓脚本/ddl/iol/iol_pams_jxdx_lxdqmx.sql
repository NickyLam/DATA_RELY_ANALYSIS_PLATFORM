/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_lxdqmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_lxdqmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_lxdqmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_lxdqmx(
    jxdxdh number(22,0) -- 绩效对象代号
    ,qsrq number(22,0) -- 起始日期
    ,jsrq number(22,0) -- 结束日期
    ,khh varchar2(45) -- 客户号
    ,khmc varchar2(750) -- 客户名称
    ,jydf varchar2(375) -- 交易对手分类描述
    ,jyr number(22,0) -- 交易日期
    ,dqr number(22,0) -- 到期日期
    ,bz varchar2(45) -- 币种
    ,tzje number(30,8) -- 交易金额
    ,qmye number(30,8) -- 当期余额
    ,ylj number(30,8) -- 月累计余额
    ,nlj number(30,8) -- 年累计余额
    ,yqsyl number(30,8) -- 票面利率
    ,jxfs varchar2(90) -- 记息方式
    ,tzlx varchar2(375) -- 资产类型名称
    ,khjg varchar2(90) -- 开户机构
    ,ssfhhh varchar2(90) -- 所属机构编号
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
grant select on ${iol_schema}.pams_jxdx_lxdqmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_lxdqmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_lxdqmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_lxdqmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_lxdqmx is '绩效对象-类信贷全明细';
comment on column ${iol_schema}.pams_jxdx_lxdqmx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_lxdqmx.qsrq is '起始日期';
comment on column ${iol_schema}.pams_jxdx_lxdqmx.jsrq is '结束日期';
comment on column ${iol_schema}.pams_jxdx_lxdqmx.khh is '客户号';
comment on column ${iol_schema}.pams_jxdx_lxdqmx.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxdx_lxdqmx.jydf is '交易对手分类描述';
comment on column ${iol_schema}.pams_jxdx_lxdqmx.jyr is '交易日期';
comment on column ${iol_schema}.pams_jxdx_lxdqmx.dqr is '到期日期';
comment on column ${iol_schema}.pams_jxdx_lxdqmx.bz is '币种';
comment on column ${iol_schema}.pams_jxdx_lxdqmx.tzje is '交易金额';
comment on column ${iol_schema}.pams_jxdx_lxdqmx.qmye is '当期余额';
comment on column ${iol_schema}.pams_jxdx_lxdqmx.ylj is '月累计余额';
comment on column ${iol_schema}.pams_jxdx_lxdqmx.nlj is '年累计余额';
comment on column ${iol_schema}.pams_jxdx_lxdqmx.yqsyl is '票面利率';
comment on column ${iol_schema}.pams_jxdx_lxdqmx.jxfs is '记息方式';
comment on column ${iol_schema}.pams_jxdx_lxdqmx.tzlx is '资产类型名称';
comment on column ${iol_schema}.pams_jxdx_lxdqmx.khjg is '开户机构';
comment on column ${iol_schema}.pams_jxdx_lxdqmx.ssfhhh is '所属机构编号';
comment on column ${iol_schema}.pams_jxdx_lxdqmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxdx_lxdqmx.etl_timestamp is 'ETL处理时间戳';
