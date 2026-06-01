/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol abss_abs_pool_relative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.abss_abs_pool_relative
whenever sqlerror continue none;
drop table ${iol_schema}.abss_abs_pool_relative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.abss_abs_pool_relative(
    assetpoolno varchar2(60) -- 资产池编号
    ,parentassetpoolno varchar2(60) -- 父资产池编号
    ,objectno varchar2(60) -- 对象编号
    ,objecttype varchar2(60) -- 对象类型
    ,ruleno varchar2(60) -- 规则编号
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
grant select on ${iol_schema}.abss_abs_pool_relative to ${iml_schema};
grant select on ${iol_schema}.abss_abs_pool_relative to ${icl_schema};
grant select on ${iol_schema}.abss_abs_pool_relative to ${idl_schema};
grant select on ${iol_schema}.abss_abs_pool_relative to ${iel_schema};

-- comment
comment on table ${iol_schema}.abss_abs_pool_relative is '资产池关联关系表';
comment on column ${iol_schema}.abss_abs_pool_relative.assetpoolno is '资产池编号';
comment on column ${iol_schema}.abss_abs_pool_relative.parentassetpoolno is '父资产池编号';
comment on column ${iol_schema}.abss_abs_pool_relative.objectno is '对象编号';
comment on column ${iol_schema}.abss_abs_pool_relative.objecttype is '对象类型';
comment on column ${iol_schema}.abss_abs_pool_relative.ruleno is '规则编号';
comment on column ${iol_schema}.abss_abs_pool_relative.start_dt is '开始时间';
comment on column ${iol_schema}.abss_abs_pool_relative.end_dt is '结束时间';
comment on column ${iol_schema}.abss_abs_pool_relative.id_mark is '增删标志';
comment on column ${iol_schema}.abss_abs_pool_relative.etl_timestamp is 'ETL处理时间戳';
