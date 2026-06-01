/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_register_program_sub
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_register_program_sub
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_register_program_sub purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_register_program_sub(
    serialno varchar2(64) -- 流水号
    ,programrelano varchar2(64) -- 关联方案编号
    ,term number(8) -- 期号
    ,counterpartypaydate date -- 交易对手转账日期
    ,paymentamount number(24,6) -- 支付金额
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,inputdate date -- 登记日期
    ,updatedate date -- 更新日期
    ,rpserialno varchar2(64) -- 关联零售单户资产方案流水号
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
grant select on ${iol_schema}.icms_ap_register_program_sub to ${iml_schema};
grant select on ${iol_schema}.icms_ap_register_program_sub to ${icl_schema};
grant select on ${iol_schema}.icms_ap_register_program_sub to ${idl_schema};
grant select on ${iol_schema}.icms_ap_register_program_sub to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_register_program_sub is '资产转让子计划';
comment on column ${iol_schema}.icms_ap_register_program_sub.serialno is '流水号';
comment on column ${iol_schema}.icms_ap_register_program_sub.programrelano is '关联方案编号';
comment on column ${iol_schema}.icms_ap_register_program_sub.term is '期号';
comment on column ${iol_schema}.icms_ap_register_program_sub.counterpartypaydate is '交易对手转账日期';
comment on column ${iol_schema}.icms_ap_register_program_sub.paymentamount is '支付金额';
comment on column ${iol_schema}.icms_ap_register_program_sub.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_register_program_sub.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_register_program_sub.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_register_program_sub.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_register_program_sub.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_register_program_sub.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_register_program_sub.rpserialno is '关联零售单户资产方案流水号';
comment on column ${iol_schema}.icms_ap_register_program_sub.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_register_program_sub.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_register_program_sub.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_register_program_sub.etl_timestamp is 'ETL处理时间戳';
