/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wph_deduction_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wph_deduction_result
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wph_deduction_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_deduction_result(
    receiptno varchar2(50) -- 回收号
    ,reference varchar2(50) -- 交易参考号
    ,internalkey varchar2(50) -- 借据号
    ,repaytime date -- 本息回收时间
    ,repayinstreqno varchar2(150) -- 清算交易编号
    ,repayaccttype varchar2(64) -- 还款账户类型
    ,repayacctname varchar2(64) -- 还款账户户名
    ,repayacctno varchar2(64) -- 还款账户编号
    ,inputdate date -- 登记日期
    ,bizdate varchar2(10) -- 流程日期
    ,repaychannel varchar2(64) -- 还款支付通道
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
grant select on ${iol_schema}.icms_wph_deduction_result to ${iml_schema};
grant select on ${iol_schema}.icms_wph_deduction_result to ${icl_schema};
grant select on ${iol_schema}.icms_wph_deduction_result to ${idl_schema};
grant select on ${iol_schema}.icms_wph_deduction_result to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wph_deduction_result is '唯品消金代扣结果表';
comment on column ${iol_schema}.icms_wph_deduction_result.receiptno is '回收号';
comment on column ${iol_schema}.icms_wph_deduction_result.reference is '交易参考号';
comment on column ${iol_schema}.icms_wph_deduction_result.internalkey is '借据号';
comment on column ${iol_schema}.icms_wph_deduction_result.repaytime is '本息回收时间';
comment on column ${iol_schema}.icms_wph_deduction_result.repayinstreqno is '清算交易编号';
comment on column ${iol_schema}.icms_wph_deduction_result.repayaccttype is '还款账户类型';
comment on column ${iol_schema}.icms_wph_deduction_result.repayacctname is '还款账户户名';
comment on column ${iol_schema}.icms_wph_deduction_result.repayacctno is '还款账户编号';
comment on column ${iol_schema}.icms_wph_deduction_result.inputdate is '登记日期';
comment on column ${iol_schema}.icms_wph_deduction_result.bizdate is '流程日期';
comment on column ${iol_schema}.icms_wph_deduction_result.repaychannel is '还款支付通道';
comment on column ${iol_schema}.icms_wph_deduction_result.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wph_deduction_result.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wph_deduction_result.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wph_deduction_result.etl_timestamp is 'ETL处理时间戳';
