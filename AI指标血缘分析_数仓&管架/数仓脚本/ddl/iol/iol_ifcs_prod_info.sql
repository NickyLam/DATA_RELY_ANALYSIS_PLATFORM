/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_prod_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_prod_info
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_prod_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_prod_info(
    prod_id varchar2(90) -- 产品编号
    ,curr_cd varchar2(15) -- 币种代码
    ,sav_type_cd varchar2(15) -- 储种代码
    ,dep_term_cd varchar2(15) -- 存期代码
    ,accting_code varchar2(30) -- 本金会计核算码
    ,int_paybl_accting_code varchar2(30) -- 应付利息会计核算码
    ,int_expns_accting_code varchar2(30) -- 利息支出会计核算码
    ,accti_org varchar2(45) -- 核算机构
    ,exec_int_rat_cd varchar2(15) -- 执行利率类别
    ,pa_ext_int_rat_cd varchar2(15) -- 部提利率代码
    ,ovdue_int_rat_cd varchar2(15) -- 逾期利率代码
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
grant select on ${iol_schema}.ifcs_prod_info to ${iml_schema};
grant select on ${iol_schema}.ifcs_prod_info to ${icl_schema};
grant select on ${iol_schema}.ifcs_prod_info to ${idl_schema};
grant select on ${iol_schema}.ifcs_prod_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_prod_info is '产品定义表';
comment on column ${iol_schema}.ifcs_prod_info.prod_id is '产品编号';
comment on column ${iol_schema}.ifcs_prod_info.curr_cd is '币种代码';
comment on column ${iol_schema}.ifcs_prod_info.sav_type_cd is '储种代码';
comment on column ${iol_schema}.ifcs_prod_info.dep_term_cd is '存期代码';
comment on column ${iol_schema}.ifcs_prod_info.accting_code is '本金会计核算码';
comment on column ${iol_schema}.ifcs_prod_info.int_paybl_accting_code is '应付利息会计核算码';
comment on column ${iol_schema}.ifcs_prod_info.int_expns_accting_code is '利息支出会计核算码';
comment on column ${iol_schema}.ifcs_prod_info.accti_org is '核算机构';
comment on column ${iol_schema}.ifcs_prod_info.exec_int_rat_cd is '执行利率类别';
comment on column ${iol_schema}.ifcs_prod_info.pa_ext_int_rat_cd is '部提利率代码';
comment on column ${iol_schema}.ifcs_prod_info.ovdue_int_rat_cd is '逾期利率代码';
comment on column ${iol_schema}.ifcs_prod_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifcs_prod_info.etl_timestamp is 'ETL处理时间戳';
