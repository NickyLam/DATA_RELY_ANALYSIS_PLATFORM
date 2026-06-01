/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_ashareadvancepayment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_ashareadvancepayment
whenever sqlerror continue none;
drop table ${iol_schema}.wind_ashareadvancepayment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_ashareadvancepayment(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司id
    ,report_period varchar2(12) -- 报告期
    ,ann_dt varchar2(12) -- 公告日期
    ,statement_type varchar2(120) -- 报表类型
    ,item_data varchar2(60) -- 数据内容
    ,item_type_code varchar2(6) -- 项目类别代码
    ,ann_item varchar2(600) -- 项目公布名称
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
grant select on ${iol_schema}.wind_ashareadvancepayment to ${iml_schema};
grant select on ${iol_schema}.wind_ashareadvancepayment to ${icl_schema};
grant select on ${iol_schema}.wind_ashareadvancepayment to ${idl_schema};
grant select on ${iol_schema}.wind_ashareadvancepayment to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_ashareadvancepayment is '中国A股财务附注--预付账款';
comment on column ${iol_schema}.wind_ashareadvancepayment.object_id is '对象ID';
comment on column ${iol_schema}.wind_ashareadvancepayment.s_info_compcode is '公司id';
comment on column ${iol_schema}.wind_ashareadvancepayment.report_period is '报告期';
comment on column ${iol_schema}.wind_ashareadvancepayment.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_ashareadvancepayment.statement_type is '报表类型';
comment on column ${iol_schema}.wind_ashareadvancepayment.item_data is '数据内容';
comment on column ${iol_schema}.wind_ashareadvancepayment.item_type_code is '项目类别代码';
comment on column ${iol_schema}.wind_ashareadvancepayment.ann_item is '项目公布名称';
comment on column ${iol_schema}.wind_ashareadvancepayment.item_amount is '项目金额';
comment on column ${iol_schema}.wind_ashareadvancepayment.item_name is '项目容错名称';
comment on column ${iol_schema}.wind_ashareadvancepayment.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_ashareadvancepayment.etl_timestamp is 'ETL处理时间戳';
