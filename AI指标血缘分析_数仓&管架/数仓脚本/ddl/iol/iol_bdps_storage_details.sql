/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_storage_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_storage_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_storage_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_storage_details(
    id number(22) -- 
    ,contract_id number(22) -- 
    ,cancel_contract_id number(22) -- 
    ,draft_id number(22) -- 
    ,ref_id number(22) -- 
    ,storg_dtl_status varchar2(2) -- 
    ,misc varchar2(150) -- 
    ,last_upd_oper_id number(22) -- 
    ,last_upd_time varchar2(21) -- 
    ,ebank_pool_out_id number(22) -- 
    ,is_problem_draft varchar2(2) -- 
    ,billsys_out_id number(22) -- 电票代保管出库申请id
    ,billsys_in_id number(22) -- 电票代保管入库申请id
    ,account_flag varchar2(2) -- 记账标识0-记帐失败 1-记帐成功 2-解记帐失败 3-解记帐成功 4-到期回款
    ,serino varchar2(6) -- 序列号
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
grant select on ${iol_schema}.bdps_storage_details to ${iml_schema};
grant select on ${iol_schema}.bdps_storage_details to ${icl_schema};
grant select on ${iol_schema}.bdps_storage_details to ${idl_schema};
grant select on ${iol_schema}.bdps_storage_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_storage_details is '代保管明细表';
comment on column ${iol_schema}.bdps_storage_details.id is '';
comment on column ${iol_schema}.bdps_storage_details.contract_id is '';
comment on column ${iol_schema}.bdps_storage_details.cancel_contract_id is '';
comment on column ${iol_schema}.bdps_storage_details.draft_id is '';
comment on column ${iol_schema}.bdps_storage_details.ref_id is '';
comment on column ${iol_schema}.bdps_storage_details.storg_dtl_status is '';
comment on column ${iol_schema}.bdps_storage_details.misc is '';
comment on column ${iol_schema}.bdps_storage_details.last_upd_oper_id is '';
comment on column ${iol_schema}.bdps_storage_details.last_upd_time is '';
comment on column ${iol_schema}.bdps_storage_details.ebank_pool_out_id is '';
comment on column ${iol_schema}.bdps_storage_details.is_problem_draft is '';
comment on column ${iol_schema}.bdps_storage_details.billsys_out_id is '电票代保管出库申请id';
comment on column ${iol_schema}.bdps_storage_details.billsys_in_id is '电票代保管入库申请id';
comment on column ${iol_schema}.bdps_storage_details.account_flag is '记账标识0-记帐失败 1-记帐成功 2-解记帐失败 3-解记帐成功 4-到期回款';
comment on column ${iol_schema}.bdps_storage_details.serino is '序列号';
comment on column ${iol_schema}.bdps_storage_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_storage_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_storage_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_storage_details.etl_timestamp is 'ETL处理时间戳';
