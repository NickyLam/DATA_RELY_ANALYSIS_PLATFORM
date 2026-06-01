/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifds_bill_fin_acc_assoc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifds_bill_fin_acc_assoc
whenever sqlerror continue none;
drop table ${iol_schema}.ifds_bill_fin_acc_assoc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifds_bill_fin_acc_assoc(
    billing_account_id varchar2(30) -- E账户编号
    ,fin_account_id varchar2(30) -- 产品账户账号
    ,party_id varchar2(30) -- 当事人编号
    ,third_party_id varchar2(30) -- 商户编号
    ,product_id varchar2(30) -- 产品编号0900100100201-活期户 0900100100202-新活期户 0900500100204-P2P1.0 0900500100205-P2P2.0 0900500100206-P2B(对公户) 0900500100207-P2P3.0
    ,account_role_type_id varchar2(30) -- 账户角色类型编号
    ,imprinted_name varchar2(30) -- 特征名称
    ,from_date timestamp -- 生效日期
    ,thru_date timestamp -- 失效日期
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
    ,account_no varchar2(30) -- 内部账户
    ,medium_type_id varchar2(30) -- 介质类型00-虚拟卡号 01-实体卡号 02-本地凭证
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
grant select on ${iol_schema}.ifds_bill_fin_acc_assoc to ${iml_schema};
grant select on ${iol_schema}.ifds_bill_fin_acc_assoc to ${icl_schema};
grant select on ${iol_schema}.ifds_bill_fin_acc_assoc to ${idl_schema};
grant select on ${iol_schema}.ifds_bill_fin_acc_assoc to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifds_bill_fin_acc_assoc is 'E账户与产品账号关联表';
comment on column ${iol_schema}.ifds_bill_fin_acc_assoc.billing_account_id is 'E账户编号';
comment on column ${iol_schema}.ifds_bill_fin_acc_assoc.fin_account_id is '产品账户账号';
comment on column ${iol_schema}.ifds_bill_fin_acc_assoc.party_id is '当事人编号';
comment on column ${iol_schema}.ifds_bill_fin_acc_assoc.third_party_id is '商户编号';
comment on column ${iol_schema}.ifds_bill_fin_acc_assoc.product_id is '产品编号0900100100201-活期户 0900100100202-新活期户 0900500100204-P2P1.0 0900500100205-P2P2.0 0900500100206-P2B(对公户) 0900500100207-P2P3.0';
comment on column ${iol_schema}.ifds_bill_fin_acc_assoc.account_role_type_id is '账户角色类型编号';
comment on column ${iol_schema}.ifds_bill_fin_acc_assoc.imprinted_name is '特征名称';
comment on column ${iol_schema}.ifds_bill_fin_acc_assoc.from_date is '生效日期';
comment on column ${iol_schema}.ifds_bill_fin_acc_assoc.thru_date is '失效日期';
comment on column ${iol_schema}.ifds_bill_fin_acc_assoc.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.ifds_bill_fin_acc_assoc.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.ifds_bill_fin_acc_assoc.created_stamp is '创建时间';
comment on column ${iol_schema}.ifds_bill_fin_acc_assoc.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.ifds_bill_fin_acc_assoc.account_no is '内部账户';
comment on column ${iol_schema}.ifds_bill_fin_acc_assoc.medium_type_id is '介质类型00-虚拟卡号 01-实体卡号 02-本地凭证';
comment on column ${iol_schema}.ifds_bill_fin_acc_assoc.start_dt is '开始时间';
comment on column ${iol_schema}.ifds_bill_fin_acc_assoc.end_dt is '结束时间';
comment on column ${iol_schema}.ifds_bill_fin_acc_assoc.id_mark is '增删标志';
comment on column ${iol_schema}.ifds_bill_fin_acc_assoc.etl_timestamp is 'ETL处理时间戳';
