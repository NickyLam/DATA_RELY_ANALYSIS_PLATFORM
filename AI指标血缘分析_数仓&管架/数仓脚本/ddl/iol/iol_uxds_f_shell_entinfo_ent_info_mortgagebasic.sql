/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_shell_entinfo_ent_info_mortgagebasic
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagebasic
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagebasic purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagebasic(
    gendate date -- 
    ,serialnumber varchar2(4000) -- 
    ,sequenceid varchar2(4000) -- 
    ,mab_status varchar2(4000) -- 
    ,ent_info_mortgagebasic varchar2(4000) -- 
    ,mab_regno varchar2(4000) -- 
    ,mab_gs_date varchar2(4000) -- 
    ,mab_guar_amt varchar2(4000) -- 
    ,mab_reg_org varchar2(4000) -- 
    ,mab_reg_date varchar2(4000) -- 
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
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagebasic to ${iml_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagebasic to ${icl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagebasic to ${idl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagebasic to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagebasic is '动产抵押-基本信息';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagebasic.gendate is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagebasic.serialnumber is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagebasic.sequenceid is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagebasic.mab_status is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagebasic.ent_info_mortgagebasic is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagebasic.mab_regno is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagebasic.mab_gs_date is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagebasic.mab_guar_amt is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagebasic.mab_reg_org is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagebasic.mab_reg_date is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagebasic.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagebasic.etl_timestamp is 'ETL处理时间戳';
