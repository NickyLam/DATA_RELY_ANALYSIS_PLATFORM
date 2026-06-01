/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_shell_entinfo_ent_info_mortgagedebt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt(
    gendate date -- 
    ,serialnumber varchar2(4000) -- 
    ,sequenceid varchar2(4000) -- 
    ,debt_edate varchar2(4000) -- 
    ,mab_debt_range varchar2(4000) -- 
    ,mab_debt_amt varchar2(4000) -- 
    ,ent_info_mortgagedebt varchar2(4000) -- 
    ,mab_regno varchar2(4000) -- 
    ,mab_debt_rmk varchar2(4000) -- 
    ,mab_debt_type varchar2(4000) -- 
    ,debt_sdate varchar2(4000) -- 
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
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt to ${iml_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt to ${icl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt to ${idl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt is '动产抵押-被担保主债权信息';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt.gendate is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt.serialnumber is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt.sequenceid is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt.debt_edate is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt.mab_debt_range is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt.mab_debt_amt is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt.ent_info_mortgagedebt is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt.mab_regno is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt.mab_debt_rmk is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt.mab_debt_type is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt.debt_sdate is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_mortgagedebt.etl_timestamp is 'ETL处理时间戳';
