/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_shell_entinfo_ent_info_alter
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_shell_entinfo_ent_info_alter
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_shell_entinfo_ent_info_alter purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_shell_entinfo_ent_info_alter(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,ent_info_alter varchar2(4000) -- 关联标签
    ,altdate varchar2(4000) -- 变更日期
    ,altaf varchar2(4000) -- 变更后内容
    ,altitem varchar2(4000) -- 变更事项
    ,altbe varchar2(4000) -- 变更前内容
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_alter to ${iml_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_alter to ${icl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_alter to ${idl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_alter to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_shell_entinfo_ent_info_alter is '中数智汇企业查询_变更信息';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_alter.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_alter.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_alter.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_alter.ent_info_alter is '关联标签';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_alter.altdate is '变更日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_alter.altaf is '变更后内容';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_alter.altitem is '变更事项';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_alter.altbe is '变更前内容';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_alter.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_alter.etl_timestamp is 'ETL处理时间戳';
