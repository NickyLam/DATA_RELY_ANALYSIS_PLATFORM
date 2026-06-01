/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_financialnotecategory
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_financialnotecategory
whenever sqlerror continue none;
drop table ${iol_schema}.wind_financialnotecategory purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_financialnotecategory(
    object_id varchar2(57) -- 对象ID
    ,s_segment_itemcode varchar2(6) -- 项目类别代码
    ,s_segment_itemname varchar2(450) -- 项目类别名称
    ,s_corresponding_content varchar2(150) -- 对应的数据内容
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
grant select on ${iol_schema}.wind_financialnotecategory to ${iml_schema};
grant select on ${iol_schema}.wind_financialnotecategory to ${icl_schema};
grant select on ${iol_schema}.wind_financialnotecategory to ${idl_schema};
grant select on ${iol_schema}.wind_financialnotecategory to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_financialnotecategory is '财务附注项目类别配置表';
comment on column ${iol_schema}.wind_financialnotecategory.object_id is '对象ID';
comment on column ${iol_schema}.wind_financialnotecategory.s_segment_itemcode is '项目类别代码';
comment on column ${iol_schema}.wind_financialnotecategory.s_segment_itemname is '项目类别名称';
comment on column ${iol_schema}.wind_financialnotecategory.s_corresponding_content is '对应的数据内容';
comment on column ${iol_schema}.wind_financialnotecategory.start_dt is '开始时间';
comment on column ${iol_schema}.wind_financialnotecategory.end_dt is '结束时间';
comment on column ${iol_schema}.wind_financialnotecategory.id_mark is '增删标志';
comment on column ${iol_schema}.wind_financialnotecategory.etl_timestamp is 'ETL处理时间戳';
