/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_shell_entinfo_ent_info_breaklaw
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_shell_entinfo_ent_info_breaklaw
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_shell_entinfo_ent_info_breaklaw purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_shell_entinfo_ent_info_breaklaw(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,ent_info_breaklaw varchar2(4000) -- 业务关联
    ,indate varchar2(4000) -- 列入日期
    ,inreason varchar2(4000) -- 列入原因
    ,inregorg varchar2(4000) -- 列入作出决定机关
    ,outdate varchar2(4000) -- 移出日期
    ,outreason varchar2(4000) -- 移出原因
    ,outregorg varchar2(4000) -- 移出作出决定机关
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
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_breaklaw to ${iml_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_breaklaw to ${icl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_breaklaw to ${idl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_breaklaw to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_shell_entinfo_ent_info_breaklaw is '中数智汇企业查询_严重违法';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_breaklaw.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_breaklaw.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_breaklaw.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_breaklaw.ent_info_breaklaw is '业务关联';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_breaklaw.indate is '列入日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_breaklaw.inreason is '列入原因';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_breaklaw.inregorg is '列入作出决定机关';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_breaklaw.outdate is '移出日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_breaklaw.outreason is '移出原因';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_breaklaw.outregorg is '移出作出决定机关';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_breaklaw.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_breaklaw.etl_timestamp is 'ETL处理时间戳';
