/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a35tfintranslist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a35tfintranslist
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a35tfintranslist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a35tfintranslist(
    seqno varchar2(30) -- 
    ,trntm varchar2(26) -- 
    ,chnlid varchar2(3) -- 
    ,chnlseqno varchar2(45) -- 
    ,chnltime varchar2(26) -- 
    ,cobank varchar2(2) -- 
    ,acctno varchar2(68) -- 
    ,custname varchar2(120) -- 
    ,seccd varchar2(12) -- 
    ,secname varchar2(60) -- 
    ,capitalacctno varchar2(33) -- 
    ,trntype varchar2(3) -- 
    ,trnamt varchar2(23) -- 
    ,ccy varchar2(5) -- 
    ,acctbal varchar2(23) -- 
    ,capitalacctbal varchar2(23) -- 
    ,hostseqno varchar2(96) -- 
    ,hostdt varchar2(12) -- 
    ,rspcd varchar2(30) -- 
    ,rspmsg varchar2(180) -- 
    ,dataid varchar2(96) -- 
    ,paechkflag varchar2(2) -- 
    ,paechkremark varchar2(75) -- 
    ,paechktime varchar2(26) -- 
    ,jtechkflag varchar2(2) -- 
    ,jtechkremark varchar2(75) -- 
    ,jtechktime varchar2(26) -- 
    ,turnflag varchar2(2) -- 
    ,hangflag varchar2(2) -- 
    ,addflag varchar2(2) -- 
    ,glob_seq_num varchar2(50) -- 全局流水号
    ,trnchnl varchar2(3) -- 渠道类型(01：手机 02：网银 03：银银平台 04：其他)
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
grant select on ${iol_schema}.mpcs_a35tfintranslist to ${iml_schema};
grant select on ${iol_schema}.mpcs_a35tfintranslist to ${icl_schema};
grant select on ${iol_schema}.mpcs_a35tfintranslist to ${idl_schema};
grant select on ${iol_schema}.mpcs_a35tfintranslist to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a35tfintranslist is '三方存管金融交易流水表';
comment on column ${iol_schema}.mpcs_a35tfintranslist.seqno is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.trntm is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.chnlid is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.chnlseqno is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.chnltime is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.cobank is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.acctno is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.custname is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.seccd is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.secname is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.capitalacctno is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.trntype is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.trnamt is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.ccy is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.acctbal is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.capitalacctbal is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.hostseqno is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.hostdt is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.rspcd is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.rspmsg is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.dataid is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.paechkflag is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.paechkremark is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.paechktime is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.jtechkflag is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.jtechkremark is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.jtechktime is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.turnflag is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.hangflag is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.addflag is '';
comment on column ${iol_schema}.mpcs_a35tfintranslist.glob_seq_num is '全局流水号';
comment on column ${iol_schema}.mpcs_a35tfintranslist.trnchnl is '渠道类型(01：手机 02：网银 03：银银平台 04：其他)';
comment on column ${iol_schema}.mpcs_a35tfintranslist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a35tfintranslist.etl_timestamp is 'ETL处理时间戳';
