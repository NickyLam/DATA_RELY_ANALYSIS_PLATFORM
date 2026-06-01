/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_ptl_raised_amt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_ptl_raised_amt
whenever sqlerror continue none;
drop table ${iol_schema}.fams_ptl_raised_amt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ptl_raised_amt(
    portfolio_id varchar2(32) -- 产品ID
    ,cdate varchar2(20) -- 计算日
    ,raise_amt number(32,2) -- 募集金额
    ,tdy_raise_amt number(32,2) -- 当日募集金额
    ,vdate varchar2(20) -- 起始日
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,profit_type varchar2(50) -- 收益类型
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
grant select on ${iol_schema}.fams_ptl_raised_amt to ${iml_schema};
grant select on ${iol_schema}.fams_ptl_raised_amt to ${icl_schema};
grant select on ${iol_schema}.fams_ptl_raised_amt to ${idl_schema};
grant select on ${iol_schema}.fams_ptl_raised_amt to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_ptl_raised_amt is '产品募集金额表';
comment on column ${iol_schema}.fams_ptl_raised_amt.portfolio_id is '产品ID';
comment on column ${iol_schema}.fams_ptl_raised_amt.cdate is '计算日';
comment on column ${iol_schema}.fams_ptl_raised_amt.raise_amt is '募集金额';
comment on column ${iol_schema}.fams_ptl_raised_amt.tdy_raise_amt is '当日募集金额';
comment on column ${iol_schema}.fams_ptl_raised_amt.vdate is '起始日';
comment on column ${iol_schema}.fams_ptl_raised_amt.create_user is '创建人';
comment on column ${iol_schema}.fams_ptl_raised_amt.create_dept is '创建部门';
comment on column ${iol_schema}.fams_ptl_raised_amt.create_time is '创建时间';
comment on column ${iol_schema}.fams_ptl_raised_amt.update_user is '更新人';
comment on column ${iol_schema}.fams_ptl_raised_amt.update_time is '更新时间';
comment on column ${iol_schema}.fams_ptl_raised_amt.profit_type is '收益类型';
comment on column ${iol_schema}.fams_ptl_raised_amt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.fams_ptl_raised_amt.etl_timestamp is 'ETL处理时间戳';
