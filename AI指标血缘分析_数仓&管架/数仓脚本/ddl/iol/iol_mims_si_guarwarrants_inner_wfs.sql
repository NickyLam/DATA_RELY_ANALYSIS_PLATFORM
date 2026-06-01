/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_guarwarrants_inner_wfs
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_guarwarrants_inner_wfs
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_guarwarrants_inner_wfs purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_guarwarrants_inner_wfs(
    businessinsid varchar2(45) -- 业务实例id
    ,guarid varchar2(45) -- 押品编号
    ,contractno varchar2(75) -- 合同号
    ,state varchar2(2) -- 流程状态 正常：0  流程中：1
    ,asscontno varchar2(75) -- 担保合同号
    ,departcode varchar2(30) -- 下级机构
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
grant select on ${iol_schema}.mims_si_guarwarrants_inner_wfs to ${iml_schema};
grant select on ${iol_schema}.mims_si_guarwarrants_inner_wfs to ${icl_schema};
grant select on ${iol_schema}.mims_si_guarwarrants_inner_wfs to ${idl_schema};
grant select on ${iol_schema}.mims_si_guarwarrants_inner_wfs to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_guarwarrants_inner_wfs is '出入库流程表';
comment on column ${iol_schema}.mims_si_guarwarrants_inner_wfs.businessinsid is '业务实例id';
comment on column ${iol_schema}.mims_si_guarwarrants_inner_wfs.guarid is '押品编号';
comment on column ${iol_schema}.mims_si_guarwarrants_inner_wfs.contractno is '合同号';
comment on column ${iol_schema}.mims_si_guarwarrants_inner_wfs.state is '流程状态 正常：0  流程中：1';
comment on column ${iol_schema}.mims_si_guarwarrants_inner_wfs.asscontno is '担保合同号';
comment on column ${iol_schema}.mims_si_guarwarrants_inner_wfs.departcode is '下级机构';
comment on column ${iol_schema}.mims_si_guarwarrants_inner_wfs.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_guarwarrants_inner_wfs.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_guarwarrants_inner_wfs.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_guarwarrants_inner_wfs.etl_timestamp is 'ETL处理时间戳';
