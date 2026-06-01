/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_tk_management_params
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_tk_management_params
whenever sqlerror continue none;
drop table ${iol_schema}.icms_tk_management_params purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_tk_management_params(
    objecttype varchar2(64) -- 消息大类
    ,messagetype varchar2(64) -- 消息小类
    ,paramtype varchar2(64) -- 参数类型
    ,paramkey varchar2(64) -- 参数键
    ,paramvalue varchar2(4000) -- 参数值
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
grant select on ${iol_schema}.icms_tk_management_params to ${iml_schema};
grant select on ${iol_schema}.icms_tk_management_params to ${icl_schema};
grant select on ${iol_schema}.icms_tk_management_params to ${idl_schema};
grant select on ${iol_schema}.icms_tk_management_params to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_tk_management_params is '经营平台参数配置表';
comment on column ${iol_schema}.icms_tk_management_params.objecttype is '消息大类';
comment on column ${iol_schema}.icms_tk_management_params.messagetype is '消息小类';
comment on column ${iol_schema}.icms_tk_management_params.paramtype is '参数类型';
comment on column ${iol_schema}.icms_tk_management_params.paramkey is '参数键';
comment on column ${iol_schema}.icms_tk_management_params.paramvalue is '参数值';
comment on column ${iol_schema}.icms_tk_management_params.start_dt is '开始时间';
comment on column ${iol_schema}.icms_tk_management_params.end_dt is '结束时间';
comment on column ${iol_schema}.icms_tk_management_params.id_mark is '增删标志';
comment on column ${iol_schema}.icms_tk_management_params.etl_timestamp is 'ETL处理时间戳';
