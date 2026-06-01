/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_shell_entinfo_ent_info_exceptionlist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,ent_info_exceptionlist varchar2(4000) -- 业务关联
    ,entname varchar2(4000) -- 企业名称
    ,indate varchar2(4000) -- 列入日期
    ,inreason varchar2(4000) -- 列入原因
    ,outdate varchar2(4000) -- 移出日期
    ,outreason varchar2(4000) -- 退出异常名录原因
    ,regno varchar2(4000) -- 注册号
    ,shxydm varchar2(4000) -- 统一社会信用代码
    ,yc_regorg varchar2(4000) -- 移出机关名称
    ,yr_regorg varchar2(4000) -- 列入机关名称
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
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist to ${iml_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist to ${icl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist to ${idl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist is '中数智汇企业查询_企业异常名';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist.ent_info_exceptionlist is '业务关联';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist.entname is '企业名称';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist.indate is '列入日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist.inreason is '列入原因';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist.outdate is '移出日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist.outreason is '退出异常名录原因';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist.regno is '注册号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist.shxydm is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist.yc_regorg is '移出机关名称';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist.yr_regorg is '列入机关名称';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_exceptionlist.etl_timestamp is 'ETL处理时间戳';
