/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl pais_agt_dacct_rela
CreateDate: 20221215
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.pais_agt_dacct_rela purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.pais_agt_dacct_rela(
etl_dt date --ETL处理日期
,acct_id varchar2(60) --账户编号
,cust_acct_id varchar2(60) --客户账户编号
,stl_cust_acct_num varchar2(60) --结算客户账号
,open_acct_bank_fin_inst_id varchar2(100) --开户银行金融机构编号
,del_flg varchar2(1) --删除标志
,job_cd varchar2(10) --任务代码
,etl_timestamp timestamp --任务处理时间

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.pais_agt_dacct_rela to ${iel_schema};

-- comment
comment on table ${idl_schema}.pais_agt_dacct_rela is '存款账户关系';
comment on column ${idl_schema}.pais_agt_dacct_rela.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.pais_agt_dacct_rela.acct_id is '账户编号';
comment on column ${idl_schema}.pais_agt_dacct_rela.cust_acct_id is '客户账户编号';
comment on column ${idl_schema}.pais_agt_dacct_rela.stl_cust_acct_num is '结算客户账号';
comment on column ${idl_schema}.pais_agt_dacct_rela.open_acct_bank_fin_inst_id is '开户银行金融机构编号';
comment on column ${idl_schema}.pais_agt_dacct_rela.del_flg is '删除标志';
comment on column ${idl_schema}.pais_agt_dacct_rela.job_cd is '任务代码';
comment on column ${idl_schema}.pais_agt_dacct_rela.etl_timestamp is '任务处理时间';

