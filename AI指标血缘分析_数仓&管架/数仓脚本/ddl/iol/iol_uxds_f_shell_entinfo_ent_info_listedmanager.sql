/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_shell_entinfo_ent_info_listedmanager
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager(
    gendate date -- 
    ,serialnumber varchar2(4000) -- 
    ,sequenceid varchar2(4000) -- 
    ,realtetype varchar2(4000) -- 
    ,holdbegindate varchar2(4000) -- 
    ,holdenddate varchar2(4000) -- 
    ,ent_info_listedmanager varchar2(4000) -- 
    ,educationlevel varchar2(4000) -- 
    ,enddate varchar2(4000) -- 
    ,actdutyname varchar2(4000) -- 
    ,dimreason varchar2(4000) -- 
    ,holdafamt varchar2(4000) -- 
    ,gender varchar2(4000) -- 
    ,holdname varchar2(4000) -- 
    ,cname varchar2(4000) -- 
    ,begindate varchar2(4000) -- 
    ,nowstatus varchar2(4000) -- 
    ,remark varchar2(4000) -- 
    ,age varchar2(4000) -- 
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
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager to ${iml_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager to ${icl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager to ${idl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager is '上市公司高管信息';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.gendate is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.serialnumber is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.sequenceid is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.realtetype is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.holdbegindate is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.holdenddate is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.ent_info_listedmanager is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.educationlevel is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.enddate is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.actdutyname is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.dimreason is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.holdafamt is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.gender is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.holdname is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.cname is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.begindate is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.nowstatus is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.remark is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.age is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedmanager.etl_timestamp is 'ETL处理时间戳';
