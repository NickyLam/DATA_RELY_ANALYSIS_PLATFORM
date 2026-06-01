/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_ashareinsideholder
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_ashareinsideholder
whenever sqlerror continue none;
drop table ${iol_schema}.wind_ashareinsideholder purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_ashareinsideholder(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,ann_dt varchar2(12) -- 公告日期
    ,s_holder_enddate varchar2(12) -- 截止日期
    ,s_holder_holdercategory varchar2(2) -- 股东类型
    ,s_holder_name varchar2(300) -- 股东名称
    ,s_holder_quantity number(20,4) -- 持股数量
    ,s_holder_pct number(20,4) -- 持股比例
    ,s_holder_sharecategory varchar2(60) -- 持股性质代码
    ,s_holder_restrictedquantity number(20,4) -- 持有限售股份（非流通股）数量
    ,s_holder_aname varchar2(300) -- 股东名称
    ,s_holder_sequence varchar2(300) -- 关联方序号
    ,s_holder_sharecategoryname varchar2(60) -- 持股性质
    ,s_holder_memo varchar2(3000) -- 股东说明
    ,opdate date -- 
    ,opmode varchar2(2) -- 
    ,s_info_compcode varchar2(15) -- 股东公司ID
    ,report_period varchar2(15) -- 报告期
    ,s_holder_nat varchar2(150) -- 
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
grant select on ${iol_schema}.wind_ashareinsideholder to ${iml_schema};
grant select on ${iol_schema}.wind_ashareinsideholder to ${icl_schema};
grant select on ${iol_schema}.wind_ashareinsideholder to ${idl_schema};
grant select on ${iol_schema}.wind_ashareinsideholder to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_ashareinsideholder is '中国a股内部人持股变动(中国a股前十大股东)';
comment on column ${iol_schema}.wind_ashareinsideholder.object_id is '对象ID';
comment on column ${iol_schema}.wind_ashareinsideholder.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_ashareinsideholder.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_ashareinsideholder.s_holder_enddate is '截止日期';
comment on column ${iol_schema}.wind_ashareinsideholder.s_holder_holdercategory is '股东类型';
comment on column ${iol_schema}.wind_ashareinsideholder.s_holder_name is '股东名称';
comment on column ${iol_schema}.wind_ashareinsideholder.s_holder_quantity is '持股数量';
comment on column ${iol_schema}.wind_ashareinsideholder.s_holder_pct is '持股比例';
comment on column ${iol_schema}.wind_ashareinsideholder.s_holder_sharecategory is '持股性质代码';
comment on column ${iol_schema}.wind_ashareinsideholder.s_holder_restrictedquantity is '持有限售股份（非流通股）数量';
comment on column ${iol_schema}.wind_ashareinsideholder.s_holder_aname is '股东名称';
comment on column ${iol_schema}.wind_ashareinsideholder.s_holder_sequence is '关联方序号';
comment on column ${iol_schema}.wind_ashareinsideholder.s_holder_sharecategoryname is '持股性质';
comment on column ${iol_schema}.wind_ashareinsideholder.s_holder_memo is '股东说明';
comment on column ${iol_schema}.wind_ashareinsideholder.opdate is '';
comment on column ${iol_schema}.wind_ashareinsideholder.opmode is '';
comment on column ${iol_schema}.wind_ashareinsideholder.s_info_compcode is '股东公司ID';
comment on column ${iol_schema}.wind_ashareinsideholder.report_period is '报告期';
comment on column ${iol_schema}.wind_ashareinsideholder.s_holder_nat is '';
comment on column ${iol_schema}.wind_ashareinsideholder.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_ashareinsideholder.etl_timestamp is 'ETL处理时间戳';
