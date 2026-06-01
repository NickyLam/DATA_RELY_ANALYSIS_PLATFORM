/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_dbm_detail_securityinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_dbm_detail_securityinfo
whenever sqlerror continue none;
drop table ${iol_schema}.icms_dbm_detail_securityinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_dbm_detail_securityinfo(
    sccode varchar2(32) -- 押品编号
    ,guartype varchar2(32) -- 押品类型编号
    ,state varchar2(2) -- 押品入库状态
    ,confmamt number(20,2) -- 我行确认价值
    ,confmcurrency varchar2(3) -- 我行确认价值币种代码
    ,createdate varchar2(30) -- 建立时间
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
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
grant select on ${iol_schema}.icms_dbm_detail_securityinfo to ${iml_schema};
grant select on ${iol_schema}.icms_dbm_detail_securityinfo to ${icl_schema};
grant select on ${iol_schema}.icms_dbm_detail_securityinfo to ${idl_schema};
grant select on ${iol_schema}.icms_dbm_detail_securityinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_dbm_detail_securityinfo is '资产池明细押品基本信息';
comment on column ${iol_schema}.icms_dbm_detail_securityinfo.sccode is '押品编号';
comment on column ${iol_schema}.icms_dbm_detail_securityinfo.guartype is '押品类型编号';
comment on column ${iol_schema}.icms_dbm_detail_securityinfo.state is '押品入库状态';
comment on column ${iol_schema}.icms_dbm_detail_securityinfo.confmamt is '我行确认价值';
comment on column ${iol_schema}.icms_dbm_detail_securityinfo.confmcurrency is '我行确认价值币种代码';
comment on column ${iol_schema}.icms_dbm_detail_securityinfo.createdate is '建立时间';
comment on column ${iol_schema}.icms_dbm_detail_securityinfo.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_dbm_detail_securityinfo.start_dt is '开始时间';
comment on column ${iol_schema}.icms_dbm_detail_securityinfo.end_dt is '结束时间';
comment on column ${iol_schema}.icms_dbm_detail_securityinfo.id_mark is '增删标志';
comment on column ${iol_schema}.icms_dbm_detail_securityinfo.etl_timestamp is 'ETL处理时间戳';
