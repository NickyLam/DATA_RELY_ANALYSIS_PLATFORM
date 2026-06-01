/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49tefhosttrxlist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49tefhosttrxlist
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49tefhosttrxlist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49tefhosttrxlist(
    ztappcode varchar2(15) -- 应用码
    ,insertdt varchar2(12) -- 入库日期
    ,trace varchar2(60) -- 中台流水号
    ,trandate varchar2(12) -- 交易日期
    ,node varchar2(15) -- 机构号
    ,prdcd varchar2(12) -- 产品码
    ,workcode varchar2(30) -- 主机交易码
    ,kind varchar2(5) -- 币种
    ,amount varchar2(30) -- 交易金额
    ,fee varchar2(30) -- 手续费
    ,amt1 varchar2(30) -- 
    ,hostdate varchar2(12) -- 主机日期
    ,hostnbr varchar2(105) -- 主机流水
    ,amt2 varchar2(30) -- 
    ,bkcd varchar2(5) -- 凭证类型
    ,bknbr varchar2(30) -- 凭证号码
    ,transt varchar2(2) -- 1: 成功交易 2：被冲正交易 3：冲正交易
    ,dataid varchar2(105) -- 第三方报文标识号
    ,crcycd varchar2(30) -- 钞汇
    ,acctno varchar2(60) -- 对账账号
    ,begindate varchar2(12) -- 
    ,enddate varchar2(12) -- 
    ,status varchar2(2) -- 1: 对账成功 0: 未对账
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
grant select on ${iol_schema}.mpcs_a49tefhosttrxlist to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49tefhosttrxlist to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49tefhosttrxlist to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49tefhosttrxlist to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49tefhosttrxlist is '';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.ztappcode is '应用码';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.insertdt is '入库日期';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.trace is '中台流水号';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.trandate is '交易日期';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.node is '机构号';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.prdcd is '产品码';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.workcode is '主机交易码';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.kind is '币种';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.amount is '交易金额';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.fee is '手续费';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.amt1 is '';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.hostdate is '主机日期';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.hostnbr is '主机流水';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.amt2 is '';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.bkcd is '凭证类型';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.bknbr is '凭证号码';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.transt is '1: 成功交易 2：被冲正交易 3：冲正交易';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.dataid is '第三方报文标识号';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.crcycd is '钞汇';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.acctno is '对账账号';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.begindate is '';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.enddate is '';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.status is '1: 对账成功 0: 未对账';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a49tefhosttrxlist.etl_timestamp is 'ETL处理时间戳';
