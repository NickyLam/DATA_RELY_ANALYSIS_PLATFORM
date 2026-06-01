/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondrepo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondrepo
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondrepo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondrepo(
    object_id varchar2(100) -- 对象id
    ,trade_dt varchar2(8) -- 交易日期
    ,b_info_term number(20,4) -- 期限(天)
    ,b_tender_interestrate number(20,4) -- 招标利率(%)
    ,b_tender_amount number(20,4) -- 招标数量(亿元)
    ,b_tender_method number(9,0) -- 招标方式
    ,b_info_repo_type number(9,0) -- 操作类型代码
    ,b_info_term_words varchar2(40) -- 期限(文字）
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
grant select on ${iol_schema}.wind_cbondrepo to ${iml_schema};
grant select on ${iol_schema}.wind_cbondrepo to ${icl_schema};
grant select on ${iol_schema}.wind_cbondrepo to ${idl_schema};
grant select on ${iol_schema}.wind_cbondrepo to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondrepo is '中国央行回购交易';
comment on column ${iol_schema}.wind_cbondrepo.object_id is '对象id';
comment on column ${iol_schema}.wind_cbondrepo.trade_dt is '交易日期';
comment on column ${iol_schema}.wind_cbondrepo.b_info_term is '期限(天)';
comment on column ${iol_schema}.wind_cbondrepo.b_tender_interestrate is '招标利率(%)';
comment on column ${iol_schema}.wind_cbondrepo.b_tender_amount is '招标数量(亿元)';
comment on column ${iol_schema}.wind_cbondrepo.b_tender_method is '招标方式';
comment on column ${iol_schema}.wind_cbondrepo.b_info_repo_type is '操作类型代码';
comment on column ${iol_schema}.wind_cbondrepo.b_info_term_words is '期限(文字）';
comment on column ${iol_schema}.wind_cbondrepo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbondrepo.etl_timestamp is 'ETL处理时间戳';
