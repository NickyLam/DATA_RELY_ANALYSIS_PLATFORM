/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_customer_property_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_customer_property_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_customer_property_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_customer_property_info(
    id number(22) -- 
    ,property_type varchar2(2) -- 资产种类 1-理财产品
    ,property_id number(22) -- 资产id
    ,property_name varchar2(192) -- 资产名
    ,property_amount number(18,4) -- 金额
    ,owner_cust_id number(22) -- 所属客户id
    ,effective_date varchar2(12) -- 生效日
    ,maturity_date varchar2(12) -- 到期日
    ,status varchar2(3) -- 资产状态 99-无效 52-已结清 92-资产池入池 93-资产池出池
    ,tmp_status varchar2(3) -- 处理中状态  00-处理结束 11-质押处理中 12-解除质押处理中
    ,property_source varchar2(9) -- 系统简称
    ,channel_source varchar2(9) -- 系统简称
    ,last_upd_oper_id number(22) -- 最后更新操作员
    ,last_upd_time varchar2(21) -- 最后更新时间
    ,remark varchar2(192) -- 备注
    ,branch_id number(22) -- 机构id
    ,property_no varchar2(192) -- 资产编号
    ,ebank_cancel_id number(22) -- 交易门户出池任务id
    ,ebank_apply_id number(22) -- ebank_apply_id  交易门户入池申请任务id
    ,bank_account varchar2(54) -- 银行账号
    ,auto_flag varchar2(2) -- 自动入池
    ,blip_seq varchar2(192) -- 影像流水号
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
grant select on ${iol_schema}.bdps_customer_property_info to ${iml_schema};
grant select on ${iol_schema}.bdps_customer_property_info to ${icl_schema};
grant select on ${iol_schema}.bdps_customer_property_info to ${idl_schema};
grant select on ${iol_schema}.bdps_customer_property_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_customer_property_info is '客户资产信息表';
comment on column ${iol_schema}.bdps_customer_property_info.id is '';
comment on column ${iol_schema}.bdps_customer_property_info.property_type is '资产种类 1-理财产品';
comment on column ${iol_schema}.bdps_customer_property_info.property_id is '资产id';
comment on column ${iol_schema}.bdps_customer_property_info.property_name is '资产名';
comment on column ${iol_schema}.bdps_customer_property_info.property_amount is '金额';
comment on column ${iol_schema}.bdps_customer_property_info.owner_cust_id is '所属客户id';
comment on column ${iol_schema}.bdps_customer_property_info.effective_date is '生效日';
comment on column ${iol_schema}.bdps_customer_property_info.maturity_date is '到期日';
comment on column ${iol_schema}.bdps_customer_property_info.status is '资产状态 99-无效 52-已结清 92-资产池入池 93-资产池出池';
comment on column ${iol_schema}.bdps_customer_property_info.tmp_status is '处理中状态  00-处理结束 11-质押处理中 12-解除质押处理中';
comment on column ${iol_schema}.bdps_customer_property_info.property_source is '系统简称';
comment on column ${iol_schema}.bdps_customer_property_info.channel_source is '系统简称';
comment on column ${iol_schema}.bdps_customer_property_info.last_upd_oper_id is '最后更新操作员';
comment on column ${iol_schema}.bdps_customer_property_info.last_upd_time is '最后更新时间';
comment on column ${iol_schema}.bdps_customer_property_info.remark is '备注';
comment on column ${iol_schema}.bdps_customer_property_info.branch_id is '机构id';
comment on column ${iol_schema}.bdps_customer_property_info.property_no is '资产编号';
comment on column ${iol_schema}.bdps_customer_property_info.ebank_cancel_id is '交易门户出池任务id';
comment on column ${iol_schema}.bdps_customer_property_info.ebank_apply_id is 'ebank_apply_id  交易门户入池申请任务id';
comment on column ${iol_schema}.bdps_customer_property_info.bank_account is '银行账号';
comment on column ${iol_schema}.bdps_customer_property_info.auto_flag is '自动入池';
comment on column ${iol_schema}.bdps_customer_property_info.blip_seq is '影像流水号';
comment on column ${iol_schema}.bdps_customer_property_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_customer_property_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_customer_property_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_customer_property_info.etl_timestamp is 'ETL处理时间戳';
