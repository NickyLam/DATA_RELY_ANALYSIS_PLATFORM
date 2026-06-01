/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_deposit_receipt_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_deposit_receipt_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_deposit_receipt_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_deposit_receipt_info(
    id number(22) -- 
    ,account varchar2(54) -- 存单账号
    ,account_sub_no varchar2(60) -- 存单子账号
    ,matudt varchar2(192) -- 期限
    ,start_date varchar2(12) -- 起息日
    ,maturity_date varchar2(12) -- 到期日
    ,amount number(18,2) -- 余额
    ,rate number(12,7) -- 利率
    ,debttp varchar2(192) -- 储种
    ,last_upd_time varchar2(21) -- 最后更新时间
    ,remark varchar2(192) -- 备注
    ,available_amount number(18,2) -- 可用余额
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
grant select on ${iol_schema}.bdps_deposit_receipt_info to ${iml_schema};
grant select on ${iol_schema}.bdps_deposit_receipt_info to ${icl_schema};
grant select on ${iol_schema}.bdps_deposit_receipt_info to ${idl_schema};
grant select on ${iol_schema}.bdps_deposit_receipt_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_deposit_receipt_info is '定期存单信息表';
comment on column ${iol_schema}.bdps_deposit_receipt_info.id is '';
comment on column ${iol_schema}.bdps_deposit_receipt_info.account is '存单账号';
comment on column ${iol_schema}.bdps_deposit_receipt_info.account_sub_no is '存单子账号';
comment on column ${iol_schema}.bdps_deposit_receipt_info.matudt is '期限';
comment on column ${iol_schema}.bdps_deposit_receipt_info.start_date is '起息日';
comment on column ${iol_schema}.bdps_deposit_receipt_info.maturity_date is '到期日';
comment on column ${iol_schema}.bdps_deposit_receipt_info.amount is '余额';
comment on column ${iol_schema}.bdps_deposit_receipt_info.rate is '利率';
comment on column ${iol_schema}.bdps_deposit_receipt_info.debttp is '储种';
comment on column ${iol_schema}.bdps_deposit_receipt_info.last_upd_time is '最后更新时间';
comment on column ${iol_schema}.bdps_deposit_receipt_info.remark is '备注';
comment on column ${iol_schema}.bdps_deposit_receipt_info.available_amount is '可用余额';
comment on column ${iol_schema}.bdps_deposit_receipt_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_deposit_receipt_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_deposit_receipt_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_deposit_receipt_info.etl_timestamp is 'ETL处理时间戳';
