/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a51ubelecashtranlog
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a51ubelecashtranlog
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a51ubelecashtranlog purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51ubelecashtranlog(
    filedate varchar2(12) -- 文件日期
    ,gatetype varchar2(5) -- 
    ,fwdinstid varchar2(18) -- 发送机构号
    ,systrace varchar2(9) -- 系统跟踪号
    ,acqinstid varchar2(18) -- 受理机构号
    ,transtime varchar2(15) -- 交易传输时间
    ,settlmtdate varchar2(12) -- 清算日期
    ,trandate varchar2(12) -- 交易日期
    ,priacct varchar2(30) -- 卡号
    ,cardsq varchar2(5) -- 卡序号
    ,trantp varchar2(5) -- 
    ,crcycd varchar2(5) -- 
    ,tranam number(19,2) -- 
    ,provstatus varchar2(2) -- 
    ,merctp varchar2(6) -- 
    ,termid varchar2(12) -- 终端号
    ,mercid varchar2(23) -- 商户号
    ,mercad varchar2(180) -- 
    ,trcert varchar2(24) -- 
    ,trauam varchar2(18) -- 
    ,trotam varchar2(18) -- 
    ,trcoun varchar2(5) -- 
    ,trcrcy varchar2(5) -- 
    ,trdate varchar2(9) -- 
    ,trtype varchar2(3) -- 
    ,trrand varchar2(12) -- 
    ,trapip varchar2(6) -- 
    ,traptc varchar2(6) -- 
    ,trresp varchar2(3) -- 
    ,idprest varchar2(17) -- 
    ,isdata varchar2(98) -- 
    ,oldtrantp varchar2(5) -- 
    ,oldsystrace varchar2(9) -- 
    ,oldsettlmtdate varchar2(12) -- 
    ,oldtranstime varchar2(15) -- 
    ,feeamt number(12,2) -- 手续费
    ,cardholdrate varchar2(18) -- 
    ,cardholdamt number(12,2) -- 
    ,cardholdcy varchar2(5) -- 
    ,settlmtamt number(12,2) -- 清算金额
    ,settlmtcy varchar2(3) -- 
    ,ratefeeamt number(12,2) -- 
    ,openbrn varchar2(15) -- 
    ,hostdate varchar2(15) -- 主机交易日期
    ,hostnbr varchar2(96) -- 主机交易流水
    ,dataid varchar2(96) -- 
    ,errcode varchar2(30) -- 错误代码
    ,errmsg varchar2(300) -- 错误信息
    ,qsstatus varchar2(2) -- 清算状态
    ,opstatus varchar2(2) -- 
    ,retrflg varchar2(2) -- 
    ,magacct varchar2(30) -- 
    ,tranexamt number(15,2) -- 本方交换费
    ,covamt number(15,2) -- 转接清算费
    ,remark1 varchar2(30) -- 保留
    ,remark2 varchar2(30) -- 保留
    ,old_busi_seq varchar2(96) -- 原交易流水号
    ,old_global_seq varchar2(96) -- 原全局流水号
    ,old_trn_seq varchar2(96) -- 原业务流水号
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
grant select on ${iol_schema}.mpcs_a51ubelecashtranlog to ${iml_schema};
grant select on ${iol_schema}.mpcs_a51ubelecashtranlog to ${icl_schema};
grant select on ${iol_schema}.mpcs_a51ubelecashtranlog to ${idl_schema};
grant select on ${iol_schema}.mpcs_a51ubelecashtranlog to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a51ubelecashtranlog is '电子现金交易流水表';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.filedate is '文件日期';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.gatetype is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.fwdinstid is '发送机构号';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.systrace is '系统跟踪号';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.acqinstid is '受理机构号';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.transtime is '交易传输时间';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.settlmtdate is '清算日期';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.trandate is '交易日期';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.priacct is '卡号';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.cardsq is '卡序号';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.trantp is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.crcycd is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.tranam is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.provstatus is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.merctp is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.termid is '终端号';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.mercid is '商户号';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.mercad is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.trcert is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.trauam is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.trotam is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.trcoun is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.trcrcy is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.trdate is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.trtype is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.trrand is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.trapip is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.traptc is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.trresp is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.idprest is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.isdata is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.oldtrantp is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.oldsystrace is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.oldsettlmtdate is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.oldtranstime is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.feeamt is '手续费';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.cardholdrate is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.cardholdamt is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.cardholdcy is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.settlmtamt is '清算金额';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.settlmtcy is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.ratefeeamt is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.openbrn is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.hostdate is '主机交易日期';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.hostnbr is '主机交易流水';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.dataid is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.errcode is '错误代码';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.errmsg is '错误信息';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.qsstatus is '清算状态';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.opstatus is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.retrflg is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.magacct is '';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.tranexamt is '本方交换费';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.covamt is '转接清算费';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.remark1 is '保留';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.remark2 is '保留';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.old_busi_seq is '原交易流水号';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.old_global_seq is '原全局流水号';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.old_trn_seq is '原业务流水号';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a51ubelecashtranlog.etl_timestamp is 'ETL处理时间戳';
