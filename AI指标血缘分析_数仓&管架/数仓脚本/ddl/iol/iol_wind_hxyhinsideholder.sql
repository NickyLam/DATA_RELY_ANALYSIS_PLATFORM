/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_hxyhinsideholder
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_hxyhinsideholder
whenever sqlerror continue none;
drop table ${iol_schema}.wind_hxyhinsideholder purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hxyhinsideholder(
    object_id varchar2(150) -- 对象ID
    ,comp_id varchar2(60) -- 公司ID
    ,ann_dt varchar2(12) -- 公告日期
    ,s_holder_enddate varchar2(12) -- 截止日期
    ,s_holder_holdercategory varchar2(2) -- 股东类型
    ,s_holder_aname varchar2(150) -- 股东名称
    ,s_holder_quantity number(20,4) -- 持股数量
    ,s_holder_pct number(20,4) -- 持股比例
    ,s_holder_sharecategory varchar2(60) -- 持股性质代码
    ,crncy_code varchar2(15) -- 货币代码
    ,s_holder_memo varchar2(2250) -- 股东说明
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.wind_hxyhinsideholder to ${iml_schema};
grant select on ${iol_schema}.wind_hxyhinsideholder to ${icl_schema};
grant select on ${iol_schema}.wind_hxyhinsideholder to ${idl_schema};
grant select on ${iol_schema}.wind_hxyhinsideholder to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_hxyhinsideholder is '华兴银行企业库股东信息';
comment on column ${iol_schema}.wind_hxyhinsideholder.object_id is '对象ID';
comment on column ${iol_schema}.wind_hxyhinsideholder.comp_id is '公司ID';
comment on column ${iol_schema}.wind_hxyhinsideholder.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_hxyhinsideholder.s_holder_enddate is '截止日期';
comment on column ${iol_schema}.wind_hxyhinsideholder.s_holder_holdercategory is '股东类型';
comment on column ${iol_schema}.wind_hxyhinsideholder.s_holder_aname is '股东名称';
comment on column ${iol_schema}.wind_hxyhinsideholder.s_holder_quantity is '持股数量';
comment on column ${iol_schema}.wind_hxyhinsideholder.s_holder_pct is '持股比例';
comment on column ${iol_schema}.wind_hxyhinsideholder.s_holder_sharecategory is '持股性质代码';
comment on column ${iol_schema}.wind_hxyhinsideholder.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_hxyhinsideholder.s_holder_memo is '股东说明';
comment on column ${iol_schema}.wind_hxyhinsideholder.start_dt is '开始时间';
comment on column ${iol_schema}.wind_hxyhinsideholder.end_dt is '结束时间';
comment on column ${iol_schema}.wind_hxyhinsideholder.id_mark is '增删标志';
comment on column ${iol_schema}.wind_hxyhinsideholder.etl_timestamp is 'ETL处理时间戳';
