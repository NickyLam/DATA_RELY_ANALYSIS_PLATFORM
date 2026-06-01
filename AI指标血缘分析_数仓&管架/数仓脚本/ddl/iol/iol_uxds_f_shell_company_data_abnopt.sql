/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_shell_company_data_abnopt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_shell_company_data_abnopt
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_shell_company_data_abnopt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_shell_company_data_abnopt(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,yr_regorg varchar2(4000) -- 列入机关名称
    ,yc_regorg varchar2(4000) -- 移出机关名称
    ,outreason varchar2(4000) -- 移出原因
    ,outdate varchar2(4000) -- 移出时间
    ,data_abnopt varchar2(4000) -- 关联标签
    ,inreason varchar2(4000) -- 列入原因
    ,indate varchar2(4000) -- 列入时间
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
grant select on ${iol_schema}.uxds_f_shell_company_data_abnopt to ${iml_schema};
grant select on ${iol_schema}.uxds_f_shell_company_data_abnopt to ${icl_schema};
grant select on ${iol_schema}.uxds_f_shell_company_data_abnopt to ${idl_schema};
grant select on ${iol_schema}.uxds_f_shell_company_data_abnopt to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_shell_company_data_abnopt is '中数智汇空壳公司_异常信息';
comment on column ${iol_schema}.uxds_f_shell_company_data_abnopt.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_shell_company_data_abnopt.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_shell_company_data_abnopt.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_shell_company_data_abnopt.yr_regorg is '列入机关名称';
comment on column ${iol_schema}.uxds_f_shell_company_data_abnopt.yc_regorg is '移出机关名称';
comment on column ${iol_schema}.uxds_f_shell_company_data_abnopt.outreason is '移出原因';
comment on column ${iol_schema}.uxds_f_shell_company_data_abnopt.outdate is '移出时间';
comment on column ${iol_schema}.uxds_f_shell_company_data_abnopt.data_abnopt is '关联标签';
comment on column ${iol_schema}.uxds_f_shell_company_data_abnopt.inreason is '列入原因';
comment on column ${iol_schema}.uxds_f_shell_company_data_abnopt.indate is '列入时间';
comment on column ${iol_schema}.uxds_f_shell_company_data_abnopt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_shell_company_data_abnopt.etl_timestamp is 'ETL处理时间戳';
