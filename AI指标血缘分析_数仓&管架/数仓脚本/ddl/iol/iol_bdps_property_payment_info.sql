/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_property_payment_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_property_payment_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_property_payment_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_property_payment_info(
    id number(22) -- 序号、主键
    ,property_id varchar2(29) -- 资产id 关联“customer_property_info”的id
    ,property_type varchar2(3) -- 资产类型 1-理财产品
    ,product_no varchar2(90) -- 产品编号
    ,cust_no varchar2(30) -- 客户号
    ,txn_type varchar2(9) -- 回款来源 系统简称
    ,is_coneal varchar2(2) -- 是否止付 0- 否1- 是
    ,bail_account varchar2(60) -- 保证金账号
    ,bail_sub_no varchar2(60) -- 保证金账号子户
    ,payment_flag varchar2(2) -- 是否兑付成功 0- 否1- 是
    ,payment_date varchar2(12) -- 兑付日期
    ,total_amt number(15,2) -- 金额
    ,remark varchar2(150) -- 附言
    ,last_upd_time varchar2(21) -- 最后更新时间
    ,misc varchar2(384) -- 备注
    ,profit_amt number(15,2) -- 收益金额
    ,coneal_nbr varchar2(48) -- 止付流水
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
grant select on ${iol_schema}.bdps_property_payment_info to ${iml_schema};
grant select on ${iol_schema}.bdps_property_payment_info to ${icl_schema};
grant select on ${iol_schema}.bdps_property_payment_info to ${idl_schema};
grant select on ${iol_schema}.bdps_property_payment_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_property_payment_info is '资产回款信息表';
comment on column ${iol_schema}.bdps_property_payment_info.id is '序号、主键';
comment on column ${iol_schema}.bdps_property_payment_info.property_id is '资产id 关联“customer_property_info”的id';
comment on column ${iol_schema}.bdps_property_payment_info.property_type is '资产类型 1-理财产品';
comment on column ${iol_schema}.bdps_property_payment_info.product_no is '产品编号';
comment on column ${iol_schema}.bdps_property_payment_info.cust_no is '客户号';
comment on column ${iol_schema}.bdps_property_payment_info.txn_type is '回款来源 系统简称';
comment on column ${iol_schema}.bdps_property_payment_info.is_coneal is '是否止付 0- 否1- 是';
comment on column ${iol_schema}.bdps_property_payment_info.bail_account is '保证金账号';
comment on column ${iol_schema}.bdps_property_payment_info.bail_sub_no is '保证金账号子户';
comment on column ${iol_schema}.bdps_property_payment_info.payment_flag is '是否兑付成功 0- 否1- 是';
comment on column ${iol_schema}.bdps_property_payment_info.payment_date is '兑付日期';
comment on column ${iol_schema}.bdps_property_payment_info.total_amt is '金额';
comment on column ${iol_schema}.bdps_property_payment_info.remark is '附言';
comment on column ${iol_schema}.bdps_property_payment_info.last_upd_time is '最后更新时间';
comment on column ${iol_schema}.bdps_property_payment_info.misc is '备注';
comment on column ${iol_schema}.bdps_property_payment_info.profit_amt is '收益金额';
comment on column ${iol_schema}.bdps_property_payment_info.coneal_nbr is '止付流水';
comment on column ${iol_schema}.bdps_property_payment_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_property_payment_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_property_payment_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_property_payment_info.etl_timestamp is 'ETL处理时间戳';
