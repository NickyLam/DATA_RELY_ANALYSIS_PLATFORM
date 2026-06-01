/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_shell_entinfo_ent_info_person
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_shell_entinfo_ent_info_person
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_shell_entinfo_ent_info_person purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_shell_entinfo_ent_info_person(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,pername varchar2(4000) -- 高管姓名
    ,ent_info_person varchar2(4000) -- 关联标签
    ,position varchar2(4000) -- 职位
    ,personamount varchar2(4000) -- 高管总数量
    ,entname varchar2(4000) -- 企业名称
    ,positioncode varchar2(4000) -- 职位代码
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
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_person to ${iml_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_person to ${icl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_person to ${idl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_person to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_shell_entinfo_ent_info_person is '中数智汇企业查询_主要管理人员';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_person.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_person.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_person.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_person.pername is '高管姓名';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_person.ent_info_person is '关联标签';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_person.position is '职位';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_person.personamount is '高管总数量';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_person.entname is '企业名称';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_person.positioncode is '职位代码';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_person.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_person.etl_timestamp is 'ETL处理时间戳';
