/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_fin_open_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_fin_open_plan
whenever sqlerror continue none;
drop table ${iol_schema}.fams_fin_open_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_open_plan(
    cash_id varchar2(64) -- 现金流代码
    ,open_type varchar2(100) -- 开放类型，申购开放、赎回开放、申赎开放
    ,open_date_str_un date -- 募集起始日
    ,open_date_end_un date -- 募集结束日
    ,open_vdate_un date -- 起息日
    ,open_mdate_un date -- 到期日
    ,open_date_str date -- 募集起始日
    ,open_date_end date -- 募集结束日
    ,open_vdate date -- 起息日
    ,open_mdate date -- 到期日
    ,finprod_id varchar2(100) -- 金融产品代码
    ,branch number(10,0) -- 分支序号
    ,open_status varchar2(100) -- 开放状态，不开放、开放
    ,create_user varchar2(40) -- 创建人
    ,create_dept varchar2(64) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(40) -- 更新人
    ,update_time timestamp -- 更新时间
    ,open_ndate date -- 净值日
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
grant select on ${iol_schema}.fams_fin_open_plan to ${iml_schema};
grant select on ${iol_schema}.fams_fin_open_plan to ${icl_schema};
grant select on ${iol_schema}.fams_fin_open_plan to ${idl_schema};
grant select on ${iol_schema}.fams_fin_open_plan to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_fin_open_plan is '开放计划';
comment on column ${iol_schema}.fams_fin_open_plan.cash_id is '现金流代码';
comment on column ${iol_schema}.fams_fin_open_plan.open_type is '开放类型，申购开放、赎回开放、申赎开放';
comment on column ${iol_schema}.fams_fin_open_plan.open_date_str_un is '募集起始日';
comment on column ${iol_schema}.fams_fin_open_plan.open_date_end_un is '募集结束日';
comment on column ${iol_schema}.fams_fin_open_plan.open_vdate_un is '起息日';
comment on column ${iol_schema}.fams_fin_open_plan.open_mdate_un is '到期日';
comment on column ${iol_schema}.fams_fin_open_plan.open_date_str is '募集起始日';
comment on column ${iol_schema}.fams_fin_open_plan.open_date_end is '募集结束日';
comment on column ${iol_schema}.fams_fin_open_plan.open_vdate is '起息日';
comment on column ${iol_schema}.fams_fin_open_plan.open_mdate is '到期日';
comment on column ${iol_schema}.fams_fin_open_plan.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_fin_open_plan.branch is '分支序号';
comment on column ${iol_schema}.fams_fin_open_plan.open_status is '开放状态，不开放、开放';
comment on column ${iol_schema}.fams_fin_open_plan.create_user is '创建人';
comment on column ${iol_schema}.fams_fin_open_plan.create_dept is '创建部门';
comment on column ${iol_schema}.fams_fin_open_plan.create_time is '创建时间';
comment on column ${iol_schema}.fams_fin_open_plan.update_user is '更新人';
comment on column ${iol_schema}.fams_fin_open_plan.update_time is '更新时间';
comment on column ${iol_schema}.fams_fin_open_plan.open_ndate is '净值日';
comment on column ${iol_schema}.fams_fin_open_plan.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.fams_fin_open_plan.etl_timestamp is 'ETL处理时间戳';
