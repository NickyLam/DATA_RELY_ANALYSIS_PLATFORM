/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondinsideholder
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondinsideholder
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondinsideholder purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondinsideholder(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司ID
    ,s_info_compname varchar2(300) -- 公司名称
    ,ann_dt varchar2(12) -- 公告日期
    ,b_holder_enddate varchar2(12) -- 截止日期
    ,b_holder_holdercategory varchar2(2) -- 股东类型
    ,b_holder_name varchar2(300) -- 股东名称
    ,b_holder_quantity number(20,4) -- 持股数量
    ,b_holder_pct number(20,4) -- 持股比例
    ,b_holder_sharecategory varchar2(150) -- 持股性质
    ,b_holder_aname varchar2(300) -- 股东名称
    ,opdate date -- 
    ,opmode varchar2(2) -- 
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
grant select on ${iol_schema}.wind_cbondinsideholder to ${iml_schema};
grant select on ${iol_schema}.wind_cbondinsideholder to ${icl_schema};
grant select on ${iol_schema}.wind_cbondinsideholder to ${idl_schema};
grant select on ${iol_schema}.wind_cbondinsideholder to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondinsideholder is '中国债券内部人持股变动';
comment on column ${iol_schema}.wind_cbondinsideholder.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondinsideholder.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_cbondinsideholder.s_info_compname is '公司名称';
comment on column ${iol_schema}.wind_cbondinsideholder.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_cbondinsideholder.b_holder_enddate is '截止日期';
comment on column ${iol_schema}.wind_cbondinsideholder.b_holder_holdercategory is '股东类型';
comment on column ${iol_schema}.wind_cbondinsideholder.b_holder_name is '股东名称';
comment on column ${iol_schema}.wind_cbondinsideholder.b_holder_quantity is '持股数量';
comment on column ${iol_schema}.wind_cbondinsideholder.b_holder_pct is '持股比例';
comment on column ${iol_schema}.wind_cbondinsideholder.b_holder_sharecategory is '持股性质';
comment on column ${iol_schema}.wind_cbondinsideholder.b_holder_aname is '股东名称';
comment on column ${iol_schema}.wind_cbondinsideholder.opdate is '';
comment on column ${iol_schema}.wind_cbondinsideholder.opmode is '';
comment on column ${iol_schema}.wind_cbondinsideholder.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbondinsideholder.etl_timestamp is 'ETL处理时间戳';
