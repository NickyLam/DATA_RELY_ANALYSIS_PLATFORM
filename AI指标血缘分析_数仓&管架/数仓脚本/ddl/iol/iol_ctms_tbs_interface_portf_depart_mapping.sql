/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_interface_portf_depart_mapping
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_interface_portf_depart_mapping
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_interface_portf_depart_mapping purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_interface_portf_depart_mapping(
    keepfolder_id varchar2(30) -- 账户ID
    ,keepfolder_name varchar2(300) -- 账户名称
    ,departmentname varchar2(300) -- 部门名称
    ,departmentid varchar2(30) -- 部门编号
    ,currency varchar2(90) -- 
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
grant select on ${iol_schema}.ctms_tbs_interface_portf_depart_mapping to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_interface_portf_depart_mapping to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_interface_portf_depart_mapping to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_interface_portf_depart_mapping to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_interface_portf_depart_mapping is '账户部门编号映射表';
comment on column ${iol_schema}.ctms_tbs_interface_portf_depart_mapping.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_interface_portf_depart_mapping.keepfolder_name is '账户名称';
comment on column ${iol_schema}.ctms_tbs_interface_portf_depart_mapping.departmentname is '部门名称';
comment on column ${iol_schema}.ctms_tbs_interface_portf_depart_mapping.departmentid is '部门编号';
comment on column ${iol_schema}.ctms_tbs_interface_portf_depart_mapping.currency is '';
comment on column ${iol_schema}.ctms_tbs_interface_portf_depart_mapping.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_interface_portf_depart_mapping.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_interface_portf_depart_mapping.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_interface_portf_depart_mapping.etl_timestamp is 'ETL处理时间戳';
