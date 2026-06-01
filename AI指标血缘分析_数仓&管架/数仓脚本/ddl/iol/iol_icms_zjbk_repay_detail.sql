/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_zjbk_repay_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_zjbk_repay_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_zjbk_repay_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zjbk_repay_detail(
    serialno varchar2(64) -- 流水号
    ,relativeserialno varchar2(64) -- 关联流水号
    ,accountid varchar2(64) -- 授信ID
    ,repayorderid varchar2(64) -- 还款订单号
    ,orderno varchar2(64) -- 还款支付订单号
    ,loanid varchar2(64) -- 借款流水号
    ,amount varchar2(64) -- 还款总金额
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
grant select on ${iol_schema}.icms_zjbk_repay_detail to ${iml_schema};
grant select on ${iol_schema}.icms_zjbk_repay_detail to ${icl_schema};
grant select on ${iol_schema}.icms_zjbk_repay_detail to ${idl_schema};
grant select on ${iol_schema}.icms_zjbk_repay_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_zjbk_repay_detail is '字节还款通知信息详情表';
comment on column ${iol_schema}.icms_zjbk_repay_detail.serialno is '流水号';
comment on column ${iol_schema}.icms_zjbk_repay_detail.relativeserialno is '关联流水号';
comment on column ${iol_schema}.icms_zjbk_repay_detail.accountid is '授信ID';
comment on column ${iol_schema}.icms_zjbk_repay_detail.repayorderid is '还款订单号';
comment on column ${iol_schema}.icms_zjbk_repay_detail.orderno is '还款支付订单号';
comment on column ${iol_schema}.icms_zjbk_repay_detail.loanid is '借款流水号';
comment on column ${iol_schema}.icms_zjbk_repay_detail.amount is '还款总金额';
comment on column ${iol_schema}.icms_zjbk_repay_detail.start_dt is '开始时间';
comment on column ${iol_schema}.icms_zjbk_repay_detail.end_dt is '结束时间';
comment on column ${iol_schema}.icms_zjbk_repay_detail.id_mark is '增删标志';
comment on column ${iol_schema}.icms_zjbk_repay_detail.etl_timestamp is 'ETL处理时间戳';
