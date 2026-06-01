/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_ncts_ab_auth_taskpoolthreshold
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_ncts_ab_auth_taskpoolthreshold
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_ncts_ab_auth_taskpoolthreshold purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_ncts_ab_auth_taskpoolthreshold(
    authorgno varchar2(10) -- 授权机构
    ,taskpoolid varchar2(10) -- 任务池编号
    ,threshold number(4,2) -- 阀值
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_ncts_ab_auth_taskpoolthreshold to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_ncts_ab_auth_taskpoolthreshold is '机构授权中心参数表';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpoolthreshold.authorgno is '授权机构';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpoolthreshold.taskpoolid is '任务池编号';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpoolthreshold.threshold is '阀值';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpoolthreshold.start_dt is '开始时间';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpoolthreshold.end_dt is '结束时间';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpoolthreshold.id_mark is '增删标志';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpoolthreshold.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpoolthreshold.etl_timestamp is 'ETL处理时间戳';