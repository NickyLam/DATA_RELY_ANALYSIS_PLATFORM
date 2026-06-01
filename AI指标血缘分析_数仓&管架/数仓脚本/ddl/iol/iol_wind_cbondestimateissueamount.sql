/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondestimateissueamount
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondestimateissueamount
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondestimateissueamount purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondestimateissueamount(
    object_id varchar2(57) -- 对象ID
    ,issue_firstissue varchar2(12) -- 发行日期
    ,bond_type varchar2(60) -- 债券类型
    ,issue_amountplan number(20,4) -- 发行数量(亿元)
    ,term_year number(20,4) -- 债券期限(年)
    ,interesttype varchar2(150) -- 利率类型
    ,interestfrequency varchar2(150) -- 付息频率
    ,isser_introduce varchar2(300) -- 发行简介
    ,specialbondtype number(9,0) -- 债券品种代码
    ,interesttype_code number(9,0) -- 附息利率品种代码
    ,reimbursement number(9,0) -- 偿还方式代码
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
grant select on ${iol_schema}.wind_cbondestimateissueamount to ${iml_schema};
grant select on ${iol_schema}.wind_cbondestimateissueamount to ${icl_schema};
grant select on ${iol_schema}.wind_cbondestimateissueamount to ${idl_schema};
grant select on ${iol_schema}.wind_cbondestimateissueamount to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondestimateissueamount is '银行间债券预计发行总量';
comment on column ${iol_schema}.wind_cbondestimateissueamount.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondestimateissueamount.issue_firstissue is '发行日期';
comment on column ${iol_schema}.wind_cbondestimateissueamount.bond_type is '债券类型';
comment on column ${iol_schema}.wind_cbondestimateissueamount.issue_amountplan is '发行数量(亿元)';
comment on column ${iol_schema}.wind_cbondestimateissueamount.term_year is '债券期限(年)';
comment on column ${iol_schema}.wind_cbondestimateissueamount.interesttype is '利率类型';
comment on column ${iol_schema}.wind_cbondestimateissueamount.interestfrequency is '付息频率';
comment on column ${iol_schema}.wind_cbondestimateissueamount.isser_introduce is '发行简介';
comment on column ${iol_schema}.wind_cbondestimateissueamount.specialbondtype is '债券品种代码';
comment on column ${iol_schema}.wind_cbondestimateissueamount.interesttype_code is '附息利率品种代码';
comment on column ${iol_schema}.wind_cbondestimateissueamount.reimbursement is '偿还方式代码';
comment on column ${iol_schema}.wind_cbondestimateissueamount.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbondestimateissueamount.etl_timestamp is 'ETL处理时间戳';
