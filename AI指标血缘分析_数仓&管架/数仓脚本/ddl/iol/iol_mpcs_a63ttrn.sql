/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a63ttrn
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a63ttrn
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a63ttrn purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a63ttrn(
    custno varchar2(15) -- 
    ,entworkdt varchar2(12) -- 
    ,entseqno varchar2(120) -- 
    ,batentworkdt varchar2(12) -- 
    ,batentseqno varchar2(120) -- 
    ,workdt varchar2(12) -- 
    ,seqno varchar2(15) -- 
    ,step number(4,0) -- 
    ,centredate varchar2(12) -- 
    ,settlestat varchar2(2) -- 
    ,chnl varchar2(3) -- 渠道:0-小额，1-大额，2-超级网银，3-行内
    ,chnldt varchar2(12) -- 
    ,chnlseqno varchar2(96) -- 
    ,hostdt varchar2(12) -- 
    ,hostseqno varchar2(60) -- 
    ,dataid varchar2(96) -- 
    ,brcno varchar2(15) -- 
    ,payacctno varchar2(53) -- 
    ,payacctname varchar2(384) -- 
    ,rcvacctflag varchar2(2) -- 收款人类型:1-对私，2-对公
    ,rcvacctno varchar2(53) -- 
    ,rcvacctname varchar2(384) -- 
    ,rcvbankno varchar2(120) -- 
    ,rcvbankname varchar2(384) -- 
    ,ccy varchar2(3) -- 币种:01-人民币
    ,ccyflag varchar2(6) -- 钞汇标识:0-钞，1-汇
    ,trnamt number(12,2) -- 
    ,fee number(12,2) -- 
    ,memocd varchar2(6) -- 
    ,remark varchar2(200) -- 附言
    ,stat varchar2(3) -- 状态:0-成功，1-失败，2-待处理，3-预处理中，4-账务处理中，5-待核实结果，6-已冲正
    ,rspcd varchar2(30) -- 
    ,rspmsg varchar2(1536) -- 
    ,synts timestamp -- 
    ,syncount number(22) -- 
    ,trnts timestamp -- 
    ,fronttrcd varchar2(15) -- 中台交易码
    ,globalseqno varchar2(96) -- 全局流水号
    ,unique_seq_num varchar2(96) -- 业务流水号
    ,efmipadd varchar2(96) -- 输出ip地址
    ,efmmac varchar2(96) -- 输出mac值
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
grant select on ${iol_schema}.mpcs_a63ttrn to ${iml_schema};
grant select on ${iol_schema}.mpcs_a63ttrn to ${icl_schema};
grant select on ${iol_schema}.mpcs_a63ttrn to ${idl_schema};
grant select on ${iol_schema}.mpcs_a63ttrn to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a63ttrn is '转账批次表';
comment on column ${iol_schema}.mpcs_a63ttrn.custno is '';
comment on column ${iol_schema}.mpcs_a63ttrn.entworkdt is '';
comment on column ${iol_schema}.mpcs_a63ttrn.entseqno is '';
comment on column ${iol_schema}.mpcs_a63ttrn.batentworkdt is '';
comment on column ${iol_schema}.mpcs_a63ttrn.batentseqno is '';
comment on column ${iol_schema}.mpcs_a63ttrn.workdt is '';
comment on column ${iol_schema}.mpcs_a63ttrn.seqno is '';
comment on column ${iol_schema}.mpcs_a63ttrn.step is '';
comment on column ${iol_schema}.mpcs_a63ttrn.centredate is '';
comment on column ${iol_schema}.mpcs_a63ttrn.settlestat is '';
comment on column ${iol_schema}.mpcs_a63ttrn.chnl is '渠道:0-小额，1-大额，2-超级网银，3-行内';
comment on column ${iol_schema}.mpcs_a63ttrn.chnldt is '';
comment on column ${iol_schema}.mpcs_a63ttrn.chnlseqno is '';
comment on column ${iol_schema}.mpcs_a63ttrn.hostdt is '';
comment on column ${iol_schema}.mpcs_a63ttrn.hostseqno is '';
comment on column ${iol_schema}.mpcs_a63ttrn.dataid is '';
comment on column ${iol_schema}.mpcs_a63ttrn.brcno is '';
comment on column ${iol_schema}.mpcs_a63ttrn.payacctno is '';
comment on column ${iol_schema}.mpcs_a63ttrn.payacctname is '';
comment on column ${iol_schema}.mpcs_a63ttrn.rcvacctflag is '收款人类型:1-对私，2-对公';
comment on column ${iol_schema}.mpcs_a63ttrn.rcvacctno is '';
comment on column ${iol_schema}.mpcs_a63ttrn.rcvacctname is '';
comment on column ${iol_schema}.mpcs_a63ttrn.rcvbankno is '';
comment on column ${iol_schema}.mpcs_a63ttrn.rcvbankname is '';
comment on column ${iol_schema}.mpcs_a63ttrn.ccy is '币种:01-人民币';
comment on column ${iol_schema}.mpcs_a63ttrn.ccyflag is '钞汇标识:0-钞，1-汇';
comment on column ${iol_schema}.mpcs_a63ttrn.trnamt is '';
comment on column ${iol_schema}.mpcs_a63ttrn.fee is '';
comment on column ${iol_schema}.mpcs_a63ttrn.memocd is '';
comment on column ${iol_schema}.mpcs_a63ttrn.remark is '附言';
comment on column ${iol_schema}.mpcs_a63ttrn.stat is '状态:0-成功，1-失败，2-待处理，3-预处理中，4-账务处理中，5-待核实结果，6-已冲正';
comment on column ${iol_schema}.mpcs_a63ttrn.rspcd is '';
comment on column ${iol_schema}.mpcs_a63ttrn.rspmsg is '';
comment on column ${iol_schema}.mpcs_a63ttrn.synts is '';
comment on column ${iol_schema}.mpcs_a63ttrn.syncount is '';
comment on column ${iol_schema}.mpcs_a63ttrn.trnts is '';
comment on column ${iol_schema}.mpcs_a63ttrn.fronttrcd is '中台交易码';
comment on column ${iol_schema}.mpcs_a63ttrn.globalseqno is '全局流水号';
comment on column ${iol_schema}.mpcs_a63ttrn.unique_seq_num is '业务流水号';
comment on column ${iol_schema}.mpcs_a63ttrn.efmipadd is '输出ip地址';
comment on column ${iol_schema}.mpcs_a63ttrn.efmmac is '输出mac值';
comment on column ${iol_schema}.mpcs_a63ttrn.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a63ttrn.etl_timestamp is 'ETL处理时间戳';
