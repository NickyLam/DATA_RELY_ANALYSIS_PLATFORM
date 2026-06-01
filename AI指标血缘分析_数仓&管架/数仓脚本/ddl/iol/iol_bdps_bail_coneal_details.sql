/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_bail_coneal_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_bail_coneal_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_bail_coneal_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_bail_coneal_details(
    id number(22) -- 
    ,bail_account_id number(22) -- 
    ,bail_coneal_status varchar2(2) -- 
    ,bail_coneal_amount number(18,2) -- 
    ,last_upd_time varchar2(21) -- 
    ,bail_coneal_startdt varchar2(21) -- 
    ,bail_coneal_endt varchar2(21) -- 
    ,coneal_nbr varchar2(30) -- 
    ,unfreeze_nbr varchar2(30) -- 
    ,last_upd_oper_id number(22) -- 
    ,coneal_dt varchar2(21) -- 
    ,unfreeze_dt varchar2(21) -- 
    ,par_status varchar2(2) -- 备款状态 1-已用于备款
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
grant select on ${iol_schema}.bdps_bail_coneal_details to ${iml_schema};
grant select on ${iol_schema}.bdps_bail_coneal_details to ${icl_schema};
grant select on ${iol_schema}.bdps_bail_coneal_details to ${idl_schema};
grant select on ${iol_schema}.bdps_bail_coneal_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_bail_coneal_details is '保证金止付明细表';
comment on column ${iol_schema}.bdps_bail_coneal_details.id is '';
comment on column ${iol_schema}.bdps_bail_coneal_details.bail_account_id is '';
comment on column ${iol_schema}.bdps_bail_coneal_details.bail_coneal_status is '';
comment on column ${iol_schema}.bdps_bail_coneal_details.bail_coneal_amount is '';
comment on column ${iol_schema}.bdps_bail_coneal_details.last_upd_time is '';
comment on column ${iol_schema}.bdps_bail_coneal_details.bail_coneal_startdt is '';
comment on column ${iol_schema}.bdps_bail_coneal_details.bail_coneal_endt is '';
comment on column ${iol_schema}.bdps_bail_coneal_details.coneal_nbr is '';
comment on column ${iol_schema}.bdps_bail_coneal_details.unfreeze_nbr is '';
comment on column ${iol_schema}.bdps_bail_coneal_details.last_upd_oper_id is '';
comment on column ${iol_schema}.bdps_bail_coneal_details.coneal_dt is '';
comment on column ${iol_schema}.bdps_bail_coneal_details.unfreeze_dt is '';
comment on column ${iol_schema}.bdps_bail_coneal_details.par_status is '备款状态 1-已用于备款';
comment on column ${iol_schema}.bdps_bail_coneal_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_bail_coneal_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_bail_coneal_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_bail_coneal_details.etl_timestamp is 'ETL处理时间戳';
