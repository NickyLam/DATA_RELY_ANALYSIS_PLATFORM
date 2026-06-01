/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_shell_entinfo_ent_info_listedshareholder
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder(
    gendate date -- 
    ,serialnumber varchar2(4000) -- 
    ,sequenceid varchar2(4000) -- 
    ,shholdertype varchar2(4000) -- 
    ,ent_info_listedshareholder varchar2(4000) -- 
    ,shholdercreditcode varchar2(4000) -- 
    ,limitholderamt varchar2(4000) -- 
    ,shholdernature varchar2(4000) -- 
    ,creditcode varchar2(4000) -- 
    ,shholdertypecode varchar2(4000) -- 
    ,unlimholderamt varchar2(4000) -- 
    ,entrydate varchar2(4000) -- 
    ,holderamt varchar2(4000) -- 
    ,shholdernaturecode varchar2(4000) -- 
    ,holderrto varchar2(4000) -- 
    ,shholdername varchar2(4000) -- 
    ,regno varchar2(4000) -- 
    ,shholderregno varchar2(4000) -- 
    ,sharestype varchar2(4000) -- 
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
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder to ${iml_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder to ${icl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder to ${idl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder is '上市公司十大股东';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.gendate is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.serialnumber is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.sequenceid is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.shholdertype is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.ent_info_listedshareholder is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.shholdercreditcode is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.limitholderamt is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.shholdernature is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.creditcode is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.shholdertypecode is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.unlimholderamt is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.entrydate is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.holderamt is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.shholdernaturecode is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.holderrto is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.shholdername is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.regno is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.shholderregno is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.sharestype is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_listedshareholder.etl_timestamp is 'ETL处理时间戳';
