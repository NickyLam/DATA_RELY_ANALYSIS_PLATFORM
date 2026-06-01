/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_sxd_company_swjcxx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_sxd_company_swjcxx
whenever sqlerror continue none;
drop table ${iol_schema}.icms_sxd_company_swjcxx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_sxd_company_swjcxx(
    id varchar2(32) -- 主键
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,serno varchar2(32) -- 业务流水号
    ,aydjrq date -- 案源登记日期
    ,ajbh varchar2(20) -- 稽查案件编号
    ,rwxdrq date -- 稽查任务下达日期
    ,aymc varchar2(200) -- 案源名称
    ,ajzt varchar2(5) -- 案件状态
    ,aydjbm varchar2(200) -- 案源登记部门名称
    ,nrzy varchar2(2000) -- 内容摘要
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
grant select on ${iol_schema}.icms_sxd_company_swjcxx to ${iml_schema};
grant select on ${iol_schema}.icms_sxd_company_swjcxx to ${icl_schema};
grant select on ${iol_schema}.icms_sxd_company_swjcxx to ${idl_schema};
grant select on ${iol_schema}.icms_sxd_company_swjcxx to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_sxd_company_swjcxx is '税兴贷企业稽查信息';
comment on column ${iol_schema}.icms_sxd_company_swjcxx.id is '主键';
comment on column ${iol_schema}.icms_sxd_company_swjcxx.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_sxd_company_swjcxx.serno is '业务流水号';
comment on column ${iol_schema}.icms_sxd_company_swjcxx.aydjrq is '案源登记日期';
comment on column ${iol_schema}.icms_sxd_company_swjcxx.ajbh is '稽查案件编号';
comment on column ${iol_schema}.icms_sxd_company_swjcxx.rwxdrq is '稽查任务下达日期';
comment on column ${iol_schema}.icms_sxd_company_swjcxx.aymc is '案源名称';
comment on column ${iol_schema}.icms_sxd_company_swjcxx.ajzt is '案件状态';
comment on column ${iol_schema}.icms_sxd_company_swjcxx.aydjbm is '案源登记部门名称';
comment on column ${iol_schema}.icms_sxd_company_swjcxx.nrzy is '内容摘要';
comment on column ${iol_schema}.icms_sxd_company_swjcxx.start_dt is '开始时间';
comment on column ${iol_schema}.icms_sxd_company_swjcxx.end_dt is '结束时间';
comment on column ${iol_schema}.icms_sxd_company_swjcxx.id_mark is '增删标志';
comment on column ${iol_schema}.icms_sxd_company_swjcxx.etl_timestamp is 'ETL处理时间戳';
