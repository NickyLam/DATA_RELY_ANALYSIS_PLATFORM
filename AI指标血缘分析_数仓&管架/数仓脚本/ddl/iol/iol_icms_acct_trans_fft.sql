/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_acct_trans_fft
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_acct_trans_fft
whenever sqlerror continue none;
drop table ${iol_schema}.icms_acct_trans_fft purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_acct_trans_fft(
    serialno varchar2(64) -- 流水号
    ,counterparty varchar2(64) -- 交易对手
    ,counterpartyid varchar2(64) -- 交易对手编号
    ,shroffaccount varchar2(64) -- 收款账号
    ,loannumber varchar2(64) -- 借据笔数
    ,resalegatheramount number(24,6) -- 转卖收款金额汇总
    ,resaleloanamount number(24,6) -- 转卖借据金额汇总
    ,transferins varchar2(300) -- 转让说明
    ,completeflag varchar2(1) -- 暂存标志
    ,fundsourceaccountno varchar2(64) -- 资金来源账号
    ,fundsourcebankid varchar2(64) -- 资金来源行号
    ,fundsourceaccountname varchar2(120) -- 资金来源户名
    ,fundsourcebankname varchar2(120) -- 资金来源行名
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
grant select on ${iol_schema}.icms_acct_trans_fft to ${iml_schema};
grant select on ${iol_schema}.icms_acct_trans_fft to ${icl_schema};
grant select on ${iol_schema}.icms_acct_trans_fft to ${idl_schema};
grant select on ${iol_schema}.icms_acct_trans_fft to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_acct_trans_fft is '核算交易福费廷转让信息表';
comment on column ${iol_schema}.icms_acct_trans_fft.serialno is '流水号';
comment on column ${iol_schema}.icms_acct_trans_fft.counterparty is '交易对手';
comment on column ${iol_schema}.icms_acct_trans_fft.counterpartyid is '交易对手编号';
comment on column ${iol_schema}.icms_acct_trans_fft.shroffaccount is '收款账号';
comment on column ${iol_schema}.icms_acct_trans_fft.loannumber is '借据笔数';
comment on column ${iol_schema}.icms_acct_trans_fft.resalegatheramount is '转卖收款金额汇总';
comment on column ${iol_schema}.icms_acct_trans_fft.resaleloanamount is '转卖借据金额汇总';
comment on column ${iol_schema}.icms_acct_trans_fft.transferins is '转让说明';
comment on column ${iol_schema}.icms_acct_trans_fft.completeflag is '暂存标志';
comment on column ${iol_schema}.icms_acct_trans_fft.fundsourceaccountno is '资金来源账号';
comment on column ${iol_schema}.icms_acct_trans_fft.fundsourcebankid is '资金来源行号';
comment on column ${iol_schema}.icms_acct_trans_fft.fundsourceaccountname is '资金来源户名';
comment on column ${iol_schema}.icms_acct_trans_fft.fundsourcebankname is '资金来源行名';
comment on column ${iol_schema}.icms_acct_trans_fft.start_dt is '开始时间';
comment on column ${iol_schema}.icms_acct_trans_fft.end_dt is '结束时间';
comment on column ${iol_schema}.icms_acct_trans_fft.id_mark is '增删标志';
comment on column ${iol_schema}.icms_acct_trans_fft.etl_timestamp is 'ETL处理时间戳';
