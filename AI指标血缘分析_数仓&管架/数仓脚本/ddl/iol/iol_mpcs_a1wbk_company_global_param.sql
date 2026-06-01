/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1wbk_company_global_param
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1wbk_company_global_param
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1wbk_company_global_param purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1wbk_company_global_param(
    param_id varchar2(18) -- 参数id
    ,param_value varchar2(192) -- 参数值
    ,param_name varchar2(1536) -- 参数名称
    ,param_desc varchar2(1536) -- 参数说明
    ,create_timestamp varchar2(144) -- 创建时间戳
    ,update_timestamp varchar2(144) -- 更新时间戳
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
grant select on ${iol_schema}.mpcs_a1wbk_company_global_param to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1wbk_company_global_param to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1wbk_company_global_param to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1wbk_company_global_param to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1wbk_company_global_param is '企业全局参数表';
comment on column ${iol_schema}.mpcs_a1wbk_company_global_param.param_id is '参数id';
comment on column ${iol_schema}.mpcs_a1wbk_company_global_param.param_value is '参数值';
comment on column ${iol_schema}.mpcs_a1wbk_company_global_param.param_name is '参数名称';
comment on column ${iol_schema}.mpcs_a1wbk_company_global_param.param_desc is '参数说明';
comment on column ${iol_schema}.mpcs_a1wbk_company_global_param.create_timestamp is '创建时间戳';
comment on column ${iol_schema}.mpcs_a1wbk_company_global_param.update_timestamp is '更新时间戳';
comment on column ${iol_schema}.mpcs_a1wbk_company_global_param.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a1wbk_company_global_param.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a1wbk_company_global_param.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a1wbk_company_global_param.etl_timestamp is 'ETL处理时间戳';
