/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_tgls_prod_acct_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl(
    systid varchar2(45) -- 系统代号
    ,trandt varchar2(12) -- 交易日期
    ,bsnssq varchar2(75) -- 全局流水
    ,transq varchar2(96) -- 交易流水
    ,serino varchar2(30) -- 序号
    ,tranbr varchar2(24) -- 交易机构编号
    ,acctbr varchar2(24) -- 账务机构编号
    ,prcscd varchar2(45) -- 交易码
    ,prodcd varchar2(24) -- 解析产品
    ,loanp1 varchar2(38) -- 产品属性1
    ,loanp2 varchar2(24) -- 产品属性2
    ,loanp3 varchar2(24) -- 产品属性3
    ,loanp4 varchar2(24) -- 产品属性4
    ,loanp5 varchar2(24) -- 产品属性5
    ,loanp6 varchar2(24) -- 产品属性6
    ,loanp7 varchar2(24) -- 产品属性7
    ,loanp8 varchar2(24) -- 产品属性8
    ,loanp9 varchar2(24) -- 产品属性9
    ,loanpa varchar2(24) -- 产品属性10
    ,evetdn varchar2(24) -- 交易方向
    ,trprcd varchar2(24) -- 金额类型
    ,crcycd varchar2(5) -- 币种
    ,tranam number(20,2) -- 交易金额
    ,custcd varchar2(90) -- 客户号
    ,acctno varchar2(45) -- 协议编号
    ,assis0 varchar2(45) -- 渠道
    ,assis1 varchar2(45) -- 可售产品
    ,assis2 varchar2(45) -- 辅助核算2
    ,assis3 varchar2(45) -- 辅助核算3
    ,assis4 varchar2(45) -- 辅助核算4
    ,assis5 varchar2(45) -- 辅助核算5
    ,assis6 varchar2(45) -- 辅助核算6
    ,assis7 varchar2(45) -- 辅助核算7
    ,assis9 varchar2(45) -- 辅助核算9
    ,datex0 varchar2(30) -- 交易时间
    ,chrex0 varchar2(45) -- 交易用户
    ,chrex1 varchar2(45) -- 授权用户
    ,chrex2 varchar2(48) -- 冲正标志
    ,chrex3 varchar2(96) -- 冲抹原交易流水号
    ,datex1 varchar2(12) -- 冲抹原交易日期
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
grant select on ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl to ${iml_schema};
grant select on ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl to ${icl_schema};
grant select on ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl to ${idl_schema};
grant select on ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl is '核算中台交易明细接口表';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.systid is '系统代号';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.trandt is '交易日期';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.bsnssq is '全局流水';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.transq is '交易流水';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.serino is '序号';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.tranbr is '交易机构编号';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.acctbr is '账务机构编号';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.prcscd is '交易码';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.prodcd is '解析产品';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.loanp1 is '产品属性1';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.loanp2 is '产品属性2';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.loanp3 is '产品属性3';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.loanp4 is '产品属性4';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.loanp5 is '产品属性5';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.loanp6 is '产品属性6';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.loanp7 is '产品属性7';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.loanp8 is '产品属性8';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.loanp9 is '产品属性9';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.loanpa is '产品属性10';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.evetdn is '交易方向';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.trprcd is '金额类型';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.crcycd is '币种';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.tranam is '交易金额';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.custcd is '客户号';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.acctno is '协议编号';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.assis0 is '渠道';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.assis1 is '可售产品';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.assis2 is '辅助核算2';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.assis3 is '辅助核算3';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.assis4 is '辅助核算4';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.assis5 is '辅助核算5';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.assis6 is '辅助核算6';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.assis7 is '辅助核算7';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.assis9 is '辅助核算9';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.datex0 is '交易时间';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.chrex0 is '交易用户';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.chrex1 is '授权用户';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.chrex2 is '冲正标志';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.chrex3 is '冲抹原交易流水号';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.datex1 is '冲抹原交易日期';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl.etl_timestamp is 'ETL处理时间戳';
