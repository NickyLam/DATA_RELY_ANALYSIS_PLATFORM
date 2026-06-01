/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_ncts_ab_auth_authorgnopara
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara(
    authorgno varchar2(6) -- 授权中心机构号
    ,authorgname varchar2(50) -- 授权中心名称
    ,oraglev varchar2(1) -- 授权中心级别
    ,taskmode varchar2(1) -- 授权中心任务模式 1-系统推送，2-抢单
    ,deleteflag varchar2(1) -- 删除标识(0-正常 1-已删除)
    ,usingflag varchar2(1) -- 授权中心开启标识(0-未开启 1-启动)
    ,authorgtype varchar2(3) -- 授权中心类别(第一位1-总行授权中心，第二位1-分行授权中心，第三位1-网点授权中心)
    ,crtdate date -- 创建日期
    ,crttellerno varchar2(50) -- 创建柜员号
    ,upddate date -- 更新日期
    ,uptellerno varchar2(50) -- 更新柜员号
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
grant select on ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara is '机构授权中心参数表';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara.authorgno is '授权中心机构号';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara.authorgname is '授权中心名称';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara.oraglev is '授权中心级别';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara.taskmode is '授权中心任务模式 1-系统推送，2-抢单';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara.deleteflag is '删除标识(0-正常 1-已删除)';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara.usingflag is '授权中心开启标识(0-未开启 1-启动)';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara.authorgtype is '授权中心类别(第一位1-总行授权中心，第二位1-分行授权中心，第三位1-网点授权中心)';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara.crtdate is '创建日期';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara.crttellerno is '创建柜员号';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara.upddate is '更新日期';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara.uptellerno is '更新柜员号';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara.start_dt is '开始时间';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara.end_dt is '结束时间';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara.id_mark is '增删标志';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara.etl_timestamp is 'ETL处理时间戳';