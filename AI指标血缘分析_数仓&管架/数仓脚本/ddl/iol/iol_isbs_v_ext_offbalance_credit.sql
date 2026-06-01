/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_v_ext_offbalance_credit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_v_ext_offbalance_credit
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_v_ext_offbalance_credit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_v_ext_offbalance_credit(
    cif_key varchar2(24) -- 
    ,org_book_bal_latest number(22) -- 
    ,gl_account_id varchar2(18) -- 
    ,account_number varchar2(24) -- 
    ,finish_type varchar2(2) -- 
    ,finish_date date -- 
    ,account_open_date date -- 
    ,cur_book_bal number(18,3) -- 
    ,org_unit_id varchar2(12) -- 
    ,iso_currency_cd varchar2(5) -- 
    ,org_book_bal number(22) -- 
    ,as_of_date date -- 
    ,flag varchar2(2) -- 
    ,maturity_date date -- 
    ,data_source varchar2(6) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.isbs_v_ext_offbalance_credit to ${iml_schema};
grant select on ${iol_schema}.isbs_v_ext_offbalance_credit to ${icl_schema};
grant select on ${iol_schema}.isbs_v_ext_offbalance_credit to ${idl_schema};
grant select on ${iol_schema}.isbs_v_ext_offbalance_credit to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_v_ext_offbalance_credit is '信用证总帐余额';
comment on column ${iol_schema}.isbs_v_ext_offbalance_credit.cif_key is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_credit.org_book_bal_latest is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_credit.gl_account_id is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_credit.account_number is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_credit.finish_type is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_credit.finish_date is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_credit.account_open_date is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_credit.cur_book_bal is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_credit.org_unit_id is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_credit.iso_currency_cd is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_credit.org_book_bal is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_credit.as_of_date is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_credit.flag is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_credit.maturity_date is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_credit.data_source is '';
comment on column ${iol_schema}.isbs_v_ext_offbalance_credit.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_v_ext_offbalance_credit.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_v_ext_offbalance_credit.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_v_ext_offbalance_credit.etl_timestamp is 'ETL处理时间戳';
