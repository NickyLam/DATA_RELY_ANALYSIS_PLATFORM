/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_draft_pool_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_draft_pool_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_draft_pool_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_draft_pool_details(
    id number(22) -- 
    ,contract_id number(22) -- 
    ,cancel_contract_id number(22) -- 
    ,draft_id number(22) -- 
    ,ref_id number(22) -- 
    ,dtl_status varchar2(2) -- 
    ,misc varchar2(150) -- 
    ,last_upd_oper_id number(22) -- 
    ,last_upd_time varchar2(21) -- 
    ,bail_acct_no varchar2(48) -- 
    ,draft_amount_rate number(11,8) -- 
    ,cancel_collztn varchar2(2) -- 
    ,ebank_pool_out_id number(22) -- 
    ,ebank_pool_in_id number(22) -- 
    ,is_problem_draft varchar2(2) -- 
    ,serial_no varchar2(48) -- 信贷占用流水号
    ,is_occupy varchar2(2) -- 是否占用保贴额度 0-否 1-是
    ,billsys_out_id number(22) -- 电票质押转代保管申请id
    ,billsys_in_id number(22) -- 电票代保管转质押申请id
    ,account_flag varchar2(2) -- 记账标识0-记帐失败 1-记帐成功 2-解记帐失败 3-解记帐成功 4-到期回款
    ,derive_amt number(11,2) -- 质押计算天数
    ,ple_day number(11,2) -- 质押计算天数
    ,rate number(11,2) -- 质押计算利率
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
grant select on ${iol_schema}.bdps_draft_pool_details to ${iml_schema};
grant select on ${iol_schema}.bdps_draft_pool_details to ${icl_schema};
grant select on ${iol_schema}.bdps_draft_pool_details to ${idl_schema};
grant select on ${iol_schema}.bdps_draft_pool_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_draft_pool_details is '票据池明细表';
comment on column ${iol_schema}.bdps_draft_pool_details.id is '';
comment on column ${iol_schema}.bdps_draft_pool_details.contract_id is '';
comment on column ${iol_schema}.bdps_draft_pool_details.cancel_contract_id is '';
comment on column ${iol_schema}.bdps_draft_pool_details.draft_id is '';
comment on column ${iol_schema}.bdps_draft_pool_details.ref_id is '';
comment on column ${iol_schema}.bdps_draft_pool_details.dtl_status is '';
comment on column ${iol_schema}.bdps_draft_pool_details.misc is '';
comment on column ${iol_schema}.bdps_draft_pool_details.last_upd_oper_id is '';
comment on column ${iol_schema}.bdps_draft_pool_details.last_upd_time is '';
comment on column ${iol_schema}.bdps_draft_pool_details.bail_acct_no is '';
comment on column ${iol_schema}.bdps_draft_pool_details.draft_amount_rate is '';
comment on column ${iol_schema}.bdps_draft_pool_details.cancel_collztn is '';
comment on column ${iol_schema}.bdps_draft_pool_details.ebank_pool_out_id is '';
comment on column ${iol_schema}.bdps_draft_pool_details.ebank_pool_in_id is '';
comment on column ${iol_schema}.bdps_draft_pool_details.is_problem_draft is '';
comment on column ${iol_schema}.bdps_draft_pool_details.serial_no is '信贷占用流水号';
comment on column ${iol_schema}.bdps_draft_pool_details.is_occupy is '是否占用保贴额度 0-否 1-是';
comment on column ${iol_schema}.bdps_draft_pool_details.billsys_out_id is '电票质押转代保管申请id';
comment on column ${iol_schema}.bdps_draft_pool_details.billsys_in_id is '电票代保管转质押申请id';
comment on column ${iol_schema}.bdps_draft_pool_details.account_flag is '记账标识0-记帐失败 1-记帐成功 2-解记帐失败 3-解记帐成功 4-到期回款';
comment on column ${iol_schema}.bdps_draft_pool_details.derive_amt is '质押计算天数';
comment on column ${iol_schema}.bdps_draft_pool_details.ple_day is '质押计算天数';
comment on column ${iol_schema}.bdps_draft_pool_details.rate is '质押计算利率';
comment on column ${iol_schema}.bdps_draft_pool_details.serino is '序列号';
comment on column ${iol_schema}.bdps_draft_pool_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_draft_pool_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_draft_pool_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_draft_pool_details.etl_timestamp is 'ETL处理时间戳';
