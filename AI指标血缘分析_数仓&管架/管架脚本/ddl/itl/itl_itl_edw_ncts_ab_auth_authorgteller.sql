/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_ncts_ab_auth_authorgteller
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_ncts_ab_auth_authorgteller
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_ncts_ab_auth_authorgteller purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_ncts_ab_auth_authorgteller(
    authorgno varchar2(10) -- 授权机构
    ,authtellerno varchar2(100) -- 授权柜员
    ,telleroid varchar2(256) -- 授权柜员终端OID
    ,telleronline varchar2(2) -- 登录状态。0,离线;1,在线
    ,realocationflag varchar2(1) -- 
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
grant select on ${itl_schema}.itl_edw_ncts_ab_auth_authorgteller to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_ncts_ab_auth_authorgteller is '授权中心与柜员关系';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgteller.authorgno is '授权机构';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgteller.authtellerno is '授权柜员';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgteller.telleroid is '授权柜员终端OID';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgteller.telleronline is '登录状态。0,离线;1,在线';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgteller.realocationflag is '';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgteller.start_dt is '开始时间';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgteller.end_dt is '结束时间';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgteller.id_mark is '增删标志';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgteller.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_authorgteller.etl_timestamp is 'ETL处理时间戳';