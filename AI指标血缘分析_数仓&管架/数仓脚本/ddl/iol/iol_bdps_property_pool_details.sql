/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_property_pool_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_property_pool_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_property_pool_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_property_pool_details(
    id number(22) -- 
    ,contract_id number(22) -- 资产池批次id 关联“property_pool_contract”的id
    ,cancel_contract_id number(22) -- 解除资产池批次id 关联“property_pool_contract”的id
    ,property_id number(22) -- 资产id 关联“customer_property_info”的id
    ,dtl_status varchar2(2) -- 资产池明细状态 0-已办理 1-入池申请中 2-已入资产池 5-解除资产池办理中 6-已解除资产池 8-已冲正
    ,misc varchar2(150) -- 信息域
    ,last_upd_oper_id number(22) -- 最后修改操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,draft_amount_rate number(11,8) -- 质押率
    ,pledge_serial_no varchar2(33) -- 理财系统质押流水号
    ,pledge_flag varchar2(2) -- 质押通知成功标识 0-质押通知失败 1-质押通知成功 2-解押通知失败 3-解押通知成功
    ,account_flag varchar2(2) -- 记账标识0-记帐失败 1-记帐成功  2-解记帐失败 3-解记帐成功
    ,serino varchar2(6) -- 序列号
    ,res_seq_no varchar2(75) -- 限制编号
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
grant select on ${iol_schema}.bdps_property_pool_details to ${iml_schema};
grant select on ${iol_schema}.bdps_property_pool_details to ${icl_schema};
grant select on ${iol_schema}.bdps_property_pool_details to ${idl_schema};
grant select on ${iol_schema}.bdps_property_pool_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_property_pool_details is '资产池明细表';
comment on column ${iol_schema}.bdps_property_pool_details.id is '';
comment on column ${iol_schema}.bdps_property_pool_details.contract_id is '资产池批次id 关联“property_pool_contract”的id';
comment on column ${iol_schema}.bdps_property_pool_details.cancel_contract_id is '解除资产池批次id 关联“property_pool_contract”的id';
comment on column ${iol_schema}.bdps_property_pool_details.property_id is '资产id 关联“customer_property_info”的id';
comment on column ${iol_schema}.bdps_property_pool_details.dtl_status is '资产池明细状态 0-已办理 1-入池申请中 2-已入资产池 5-解除资产池办理中 6-已解除资产池 8-已冲正';
comment on column ${iol_schema}.bdps_property_pool_details.misc is '信息域';
comment on column ${iol_schema}.bdps_property_pool_details.last_upd_oper_id is '最后修改操作员';
comment on column ${iol_schema}.bdps_property_pool_details.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdps_property_pool_details.draft_amount_rate is '质押率';
comment on column ${iol_schema}.bdps_property_pool_details.pledge_serial_no is '理财系统质押流水号';
comment on column ${iol_schema}.bdps_property_pool_details.pledge_flag is '质押通知成功标识 0-质押通知失败 1-质押通知成功 2-解押通知失败 3-解押通知成功';
comment on column ${iol_schema}.bdps_property_pool_details.account_flag is '记账标识0-记帐失败 1-记帐成功  2-解记帐失败 3-解记帐成功';
comment on column ${iol_schema}.bdps_property_pool_details.serino is '序列号';
comment on column ${iol_schema}.bdps_property_pool_details.res_seq_no is '限制编号';
comment on column ${iol_schema}.bdps_property_pool_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_property_pool_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_property_pool_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_property_pool_details.etl_timestamp is 'ETL处理时间戳';
