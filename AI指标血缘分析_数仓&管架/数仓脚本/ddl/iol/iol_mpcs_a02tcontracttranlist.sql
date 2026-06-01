/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a02tcontracttranlist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a02tcontracttranlist
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a02tcontracttranlist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a02tcontracttranlist(
    fntseqno varchar2(21) -- 
    ,chnlid varchar2(8) -- 
    ,chnlseqno varchar2(105) -- 
    ,thirdseqno varchar2(105) -- 
    ,hostseqno varchar2(105) -- 
    ,trntype varchar2(3) -- 
    ,maincontractno varchar2(21) -- 
    ,contractno varchar2(15) -- 
    ,custno varchar2(30) -- 
    ,acctno varchar2(60) -- 
    ,trndt varchar2(12) -- 
    ,trnts varchar2(9) -- 
    ,trnbrcno varchar2(15) -- 
    ,tlrno varchar2(15) -- 
    ,authtlrno varchar2(15) -- 
    ,fnttrncd varchar2(15) -- 
    ,dsttrncd varchar2(30) -- 
    ,trnname varchar2(60) -- 
    ,trnresult varchar2(9) -- 
    ,chkflag varchar2(2) -- 
    ,prttimes varchar2(5) -- 
    ,prtworkno varchar2(30) -- 
    ,memo varchar2(75) -- 
    ,opdata varchar2(4000) -- 
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
grant select on ${iol_schema}.mpcs_a02tcontracttranlist to ${iml_schema};
grant select on ${iol_schema}.mpcs_a02tcontracttranlist to ${icl_schema};
grant select on ${iol_schema}.mpcs_a02tcontracttranlist to ${idl_schema};
grant select on ${iol_schema}.mpcs_a02tcontracttranlist to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a02tcontracttranlist is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.fntseqno is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.chnlid is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.chnlseqno is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.thirdseqno is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.hostseqno is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.trntype is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.maincontractno is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.contractno is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.custno is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.acctno is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.trndt is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.trnts is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.trnbrcno is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.tlrno is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.authtlrno is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.fnttrncd is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.dsttrncd is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.trnname is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.trnresult is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.chkflag is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.prttimes is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.prtworkno is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.memo is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.opdata is '';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a02tcontracttranlist.etl_timestamp is 'ETL处理时间戳';
