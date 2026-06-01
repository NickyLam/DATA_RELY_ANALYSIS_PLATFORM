/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_asharefinsegmentinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_asharefinsegmentinfo
whenever sqlerror continue none;
drop table ${iol_schema}.wind_asharefinsegmentinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_asharefinsegmentinfo(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(15) -- 公司ID
    ,report_period varchar2(12) -- 报告期
    ,statement_type number(9,0) -- 报表类型代码
    ,class_code number(9,0) -- 分部类别代码
    ,subject_code number(9,0) -- 科目代码
    ,item_amount number(20,4) -- 金额
    ,unit varchar2(60) -- 单位
    ,crncy_code varchar2(15) -- 货币代码
    ,subject_name_ann varchar2(150) -- [内部]公布科目名称
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
grant select on ${iol_schema}.wind_asharefinsegmentinfo to ${iml_schema};
grant select on ${iol_schema}.wind_asharefinsegmentinfo to ${icl_schema};
grant select on ${iol_schema}.wind_asharefinsegmentinfo to ${idl_schema};
grant select on ${iol_schema}.wind_asharefinsegmentinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_asharefinsegmentinfo is '中国A股金融机构经营分部信息';
comment on column ${iol_schema}.wind_asharefinsegmentinfo.object_id is '对象ID';
comment on column ${iol_schema}.wind_asharefinsegmentinfo.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_asharefinsegmentinfo.report_period is '报告期';
comment on column ${iol_schema}.wind_asharefinsegmentinfo.statement_type is '报表类型代码';
comment on column ${iol_schema}.wind_asharefinsegmentinfo.class_code is '分部类别代码';
comment on column ${iol_schema}.wind_asharefinsegmentinfo.subject_code is '科目代码';
comment on column ${iol_schema}.wind_asharefinsegmentinfo.item_amount is '金额';
comment on column ${iol_schema}.wind_asharefinsegmentinfo.unit is '单位';
comment on column ${iol_schema}.wind_asharefinsegmentinfo.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_asharefinsegmentinfo.subject_name_ann is '[内部]公布科目名称';
comment on column ${iol_schema}.wind_asharefinsegmentinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_asharefinsegmentinfo.etl_timestamp is 'ETL处理时间戳';
