/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a51ubmerchantpltdtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a51ubmerchantpltdtl
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a51ubmerchantpltdtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51ubmerchantpltdtl(
    transdt varchar2(12) -- 登记日期
    ,transtm varchar2(9) -- 登记时间
    ,batchno varchar2(75) -- 总批次号
    ,dtlstatus varchar2(3) -- 明细状态  0已登记，待处理 1成功 2失败
    ,failreason varchar2(384) -- 错误描述
    ,updt varchar2(21) -- 最后修改时间
    ,transnbr varchar2(120) -- 原交易流水号
    ,transactionid varchar2(96) -- upp流水号
    ,partyid varchar2(30) -- 交易机构
    ,amount varchar2(27) -- 金额
    ,currencyuomid varchar2(5) -- 币种
    ,internalnote varchar2(159) -- 银行附言
    ,publicnote varchar2(383) -- 客户附言
    ,payeracct varchar2(60) -- 付款账户
    ,payeracctname varchar2(219) -- 付款户名
    ,payermethodtypeid varchar2(30) -- 付款支付工具类型
    ,payeeacct varchar2(60) -- 收款账户
    ,payeeacctname varchar2(219) -- 收款户名
    ,payeemethodtypeid varchar2(30) -- 收款支付工具类型
    ,electrontcnote varchar2(90) -- 电子账户附言
    ,trantype varchar2(45) -- 交易类型
    ,payersubacctseqno varchar2(8) -- 付款子账户序号
    ,payeesubacctseqno varchar2(8) -- 收款子账户序号
    ,hostnbr varchar2(96) -- 核心流水号(成功时返回)
    ,hostdate varchar2(21) -- 核心日期(成功时返回)
    ,reserve1 varchar2(192) -- 备用字段1
    ,reserve2 varchar2(192) -- 备用字段2
    ,reserve3 varchar2(192) -- 备用字段3
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
grant select on ${iol_schema}.mpcs_a51ubmerchantpltdtl to ${iml_schema};
grant select on ${iol_schema}.mpcs_a51ubmerchantpltdtl to ${icl_schema};
grant select on ${iol_schema}.mpcs_a51ubmerchantpltdtl to ${idl_schema};
grant select on ${iol_schema}.mpcs_a51ubmerchantpltdtl to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a51ubmerchantpltdtl is '商户入帐清单UPP批处理明细表';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.transdt is '登记日期';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.transtm is '登记时间';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.batchno is '总批次号';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.dtlstatus is '明细状态  0已登记，待处理 1成功 2失败';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.failreason is '错误描述';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.updt is '最后修改时间';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.transnbr is '原交易流水号';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.transactionid is 'upp流水号';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.partyid is '交易机构';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.amount is '金额';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.currencyuomid is '币种';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.internalnote is '银行附言';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.publicnote is '客户附言';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.payeracct is '付款账户';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.payeracctname is '付款户名';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.payermethodtypeid is '付款支付工具类型';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.payeeacct is '收款账户';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.payeeacctname is '收款户名';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.payeemethodtypeid is '收款支付工具类型';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.electrontcnote is '电子账户附言';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.trantype is '交易类型';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.payersubacctseqno is '付款子账户序号';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.payeesubacctseqno is '收款子账户序号';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.hostnbr is '核心流水号(成功时返回)';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.hostdate is '核心日期(成功时返回)';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.reserve1 is '备用字段1';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.reserve2 is '备用字段2';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.reserve3 is '备用字段3';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a51ubmerchantpltdtl.etl_timestamp is 'ETL处理时间戳';
