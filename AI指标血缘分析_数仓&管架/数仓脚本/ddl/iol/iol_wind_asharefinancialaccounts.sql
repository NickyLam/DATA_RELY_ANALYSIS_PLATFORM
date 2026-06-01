/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_asharefinancialaccounts
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_asharefinancialaccounts
whenever sqlerror continue none;
drop table ${iol_schema}.wind_asharefinancialaccounts purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_asharefinancialaccounts(
    object_id varchar2(57) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,report_period varchar2(12) -- 报告期
    ,ann_dt varchar2(12) -- 公告日期
    ,statement_type varchar2(120) -- 报表类型
    ,subject_chinese_name varchar2(150) -- 科目中文名
    ,classification_number varchar2(15) -- 分类序号
    ,s_info_datatype varchar2(60) -- 数据类型
    ,ann_item varchar2(150) -- 项目公布名称
    ,item_amount number(20,4) -- 项目金额
    ,item_name varchar2(150) -- 项目容错名称
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
grant select on ${iol_schema}.wind_asharefinancialaccounts to ${iml_schema};
grant select on ${iol_schema}.wind_asharefinancialaccounts to ${icl_schema};
grant select on ${iol_schema}.wind_asharefinancialaccounts to ${idl_schema};
grant select on ${iol_schema}.wind_asharefinancialaccounts to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_asharefinancialaccounts is '中国A股财务科目与附注对应表';
comment on column ${iol_schema}.wind_asharefinancialaccounts.object_id is '对象ID';
comment on column ${iol_schema}.wind_asharefinancialaccounts.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_asharefinancialaccounts.report_period is '报告期';
comment on column ${iol_schema}.wind_asharefinancialaccounts.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_asharefinancialaccounts.statement_type is '报表类型';
comment on column ${iol_schema}.wind_asharefinancialaccounts.subject_chinese_name is '科目中文名';
comment on column ${iol_schema}.wind_asharefinancialaccounts.classification_number is '分类序号';
comment on column ${iol_schema}.wind_asharefinancialaccounts.s_info_datatype is '数据类型';
comment on column ${iol_schema}.wind_asharefinancialaccounts.ann_item is '项目公布名称';
comment on column ${iol_schema}.wind_asharefinancialaccounts.item_amount is '项目金额';
comment on column ${iol_schema}.wind_asharefinancialaccounts.item_name is '项目容错名称';
comment on column ${iol_schema}.wind_asharefinancialaccounts.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_asharefinancialaccounts.etl_timestamp is 'ETL处理时间戳';
