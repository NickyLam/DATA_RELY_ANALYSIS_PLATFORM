/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_res_ds_bank_no_dca_commission_day_coop
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop
whenever sqlerror continue none;
drop table ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop(
    partitiondate varchar2(10) -- 分区日期
    ,repaydate date -- 还款日期
    ,cardno varchar2(24) -- 逻辑卡号
    ,refnbr varchar2(60) -- 借据号
    ,duedays number(38) -- 逾期天数
    ,bankgroupid varchar2(24) -- 参贷方案编号
    ,bankno varchar2(24) -- 银行编号
    ,bankproportion number(15,6) -- 参贷方案比例
    ,repayamt number(15,2) -- 还款金额
    ,commissionratio number(15,6) -- 委外费率
    ,outexpense number(15,2) -- 委外费用
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop to ${iml_schema};
grant select on ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop to ${icl_schema};
grant select on ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop to ${idl_schema};
grant select on ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop is '微粒贷银行催收佣金日报表';
comment on column ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop.partitiondate is '分区日期';
comment on column ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop.repaydate is '还款日期';
comment on column ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop.cardno is '逻辑卡号';
comment on column ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop.refnbr is '借据号';
comment on column ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop.duedays is '逾期天数';
comment on column ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop.bankgroupid is '参贷方案编号';
comment on column ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop.bankno is '银行编号';
comment on column ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop.bankproportion is '参贷方案比例';
comment on column ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop.repayamt is '还款金额';
comment on column ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop.commissionratio is '委外费率';
comment on column ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop.outexpense is '委外费用';
comment on column ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop.etl_timestamp is 'ETL处理时间戳';
