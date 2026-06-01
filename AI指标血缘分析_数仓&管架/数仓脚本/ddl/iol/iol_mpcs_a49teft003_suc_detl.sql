/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49teft003_suc_detl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49teft003_suc_detl
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49teft003_suc_detl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49teft003_suc_detl(
    bachdt varchar2(12) -- 
    ,bachsq varchar2(12) -- 
    ,tranno varchar2(15) -- 
    ,payercode varchar2(18) -- 
    ,payername varchar2(120) -- 
    ,payertxtnbr varchar2(18) -- 
    ,payertxtname varchar2(105) -- 
    ,payeracct varchar2(53) -- 
    ,revercode varchar2(18) -- 
    ,revername varchar2(120) -- 
    ,revertxtnbr varchar2(18) -- 
    ,revertxtname varchar2(105) -- 
    ,reveracct varchar2(53) -- 
    ,transtp varchar2(3) -- 
    ,sourcetp varchar2(2) -- 
    ,sourcename varchar2(90) -- 
    ,feetype varchar2(18) -- 
    ,feename varchar2(90) -- 
    ,amount number(18,2) -- 
    ,seccode varchar2(17) -- 
    ,secname varchar2(90) -- 
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
grant select on ${iol_schema}.mpcs_a49teft003_suc_detl to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49teft003_suc_detl to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49teft003_suc_detl to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49teft003_suc_detl to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49teft003_suc_detl is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.bachdt is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.bachsq is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.tranno is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.payercode is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.payername is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.payertxtnbr is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.payertxtname is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.payeracct is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.revercode is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.revername is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.revertxtnbr is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.revertxtname is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.reveracct is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.transtp is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.sourcetp is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.sourcename is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.feetype is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.feename is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.amount is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.seccode is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.secname is '';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a49teft003_suc_detl.etl_timestamp is 'ETL处理时间戳';
