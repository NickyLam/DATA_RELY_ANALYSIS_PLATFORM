/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08thvhp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08thvhp
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08thvhp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08thvhp(
    mainseq varchar2(24) -- 
    ,transdt varchar2(12) -- 
    ,cshpbillnb varchar2(30) -- 
    ,cshpbilldate varchar2(12) -- 
    ,payacct varchar2(53) -- 
    ,payname varchar2(180) -- 
    ,magebrn varchar2(18) -- 办理机构
    ,cshpbilltype varchar2(6) -- 
    ,ccynbr varchar2(5) -- 
    ,cshpbillamt number(15,2) -- 
    ,cshpbillsign varchar2(15) -- 
    ,cshpcashbkno varchar2(21) -- 兑付行号
    ,inconame varchar2(180) -- 
    ,incoacct varchar2(53) -- 
    ,infocode varchar2(3) -- 
    ,info varchar2(405) -- 
    ,billst varchar2(3) -- 
    ,msgsrc varchar2(2) -- 
    ,chngna varchar2(90) -- 兑付行名
    ,cshplastopenbkno varchar2(21) -- 
    ,cshplastacct varchar2(48) -- 
    ,cshplastname varchar2(180) -- 
    ,operdt varchar2(12) -- 
    ,opersq varchar2(24) -- 
    ,oprtlr varchar2(15) -- 
    ,chktlr varchar2(15) -- 
    ,clenus varchar2(15) -- 
    ,auttlr varchar2(15) -- 
    ,prttlr varchar2(15) -- 
    ,prtcnt number(22) -- 
    ,incodt varchar2(12) -- 
    ,chngam number(15,2) -- 
    ,refdid varchar2(30) -- 
    ,consigndt varchar2(12) -- 
    ,respcd varchar2(30) -- 
    ,lostdt varchar2(12) -- 
    ,unlsdt varchar2(12) -- 
    ,lostlr varchar2(15) -- 
    ,ulstlr varchar2(15) -- 
    ,idtftp1 varchar2(6) -- 
    ,idtfno1 varchar2(30) -- 
    ,operna1 varchar2(120) -- 
    ,losttm varchar2(12) -- 
    ,lostad varchar2(90) -- 
    ,linkad1 varchar2(90) -- 
    ,linktl1 varchar2(30) -- 
    ,lostrs1 varchar2(30) -- 
    ,idtftp2 varchar2(6) -- 
    ,idtfno2 varchar2(30) -- 
    ,operna2 varchar2(120) -- 
    ,linkad2 varchar2(90) -- 
    ,linktl2 varchar2(30) -- 
    ,lostrs2 varchar2(30) -- 
    ,provtp varchar2(3) -- 
    ,provno varchar2(30) -- 
    ,reason varchar2(120) -- 
    ,execut varchar2(120) -- 
    ,execpe varchar2(45) -- 
    ,certtp varchar2(2) -- 
    ,certno varchar2(30) -- 
    ,provtp2 varchar2(3) -- 
    ,provno2 varchar2(30) -- 
    ,reason2 varchar2(120) -- 
    ,execut2 varchar2(120) -- 
    ,execpe2 varchar2(45) -- 
    ,certtp2 varchar2(2) -- 
    ,certno2 varchar2(30) -- 
    ,signbilltype varchar2(2) -- 
    ,flag3 varchar2(2) -- 
    ,feeamt number(15,2) -- 
    ,feeamt1 number(15,2) -- 
    ,feeamt2 number(15,2) -- 
    ,bookdt varchar2(12) -- 
    ,booknb varchar2(48) -- 
    ,payopenbrn varchar2(18) -- 申请人开户机构号
    ,payopenbrnnm varchar2(180) -- 申请人开户机构名称
    ,incobrn varchar2(21) -- 收款行号
    ,incobrnnm varchar2(180) -- 收款行名
    ,idtftp3 varchar2(6) -- 兑付申请人证据类型
    ,idtfno3 varchar2(30) -- 兑付申请人证据号
    ,oprtlr3 varchar2(15) -- 兑付操作柜员
    ,reason3 varchar2(120) -- 未用退回原因
    ,paytype varchar2(2) -- 1转账入账2 支取现金
    ,paybrnno varchar2(21) -- 签发行行号
    ,paybrnname varchar2(90) -- 签发行行名
    ,reason4 varchar2(60) -- 挂账原因
    ,hpstatus varchar2(2) -- 账务处理状态 4-已挂账 6-已维护入账  7-已直接入账
    ,paytp varchar2(2) -- 支付方式
    ,bkcode varchar2(6) -- 凭证类型
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
grant select on ${iol_schema}.mpcs_a08thvhp to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08thvhp to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08thvhp to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08thvhp to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08thvhp is '';
comment on column ${iol_schema}.mpcs_a08thvhp.mainseq is '';
comment on column ${iol_schema}.mpcs_a08thvhp.transdt is '';
comment on column ${iol_schema}.mpcs_a08thvhp.cshpbillnb is '';
comment on column ${iol_schema}.mpcs_a08thvhp.cshpbilldate is '';
comment on column ${iol_schema}.mpcs_a08thvhp.payacct is '';
comment on column ${iol_schema}.mpcs_a08thvhp.payname is '';
comment on column ${iol_schema}.mpcs_a08thvhp.magebrn is '办理机构';
comment on column ${iol_schema}.mpcs_a08thvhp.cshpbilltype is '';
comment on column ${iol_schema}.mpcs_a08thvhp.ccynbr is '';
comment on column ${iol_schema}.mpcs_a08thvhp.cshpbillamt is '';
comment on column ${iol_schema}.mpcs_a08thvhp.cshpbillsign is '';
comment on column ${iol_schema}.mpcs_a08thvhp.cshpcashbkno is '兑付行号';
comment on column ${iol_schema}.mpcs_a08thvhp.inconame is '';
comment on column ${iol_schema}.mpcs_a08thvhp.incoacct is '';
comment on column ${iol_schema}.mpcs_a08thvhp.infocode is '';
comment on column ${iol_schema}.mpcs_a08thvhp.info is '';
comment on column ${iol_schema}.mpcs_a08thvhp.billst is '';
comment on column ${iol_schema}.mpcs_a08thvhp.msgsrc is '';
comment on column ${iol_schema}.mpcs_a08thvhp.chngna is '兑付行名';
comment on column ${iol_schema}.mpcs_a08thvhp.cshplastopenbkno is '';
comment on column ${iol_schema}.mpcs_a08thvhp.cshplastacct is '';
comment on column ${iol_schema}.mpcs_a08thvhp.cshplastname is '';
comment on column ${iol_schema}.mpcs_a08thvhp.operdt is '';
comment on column ${iol_schema}.mpcs_a08thvhp.opersq is '';
comment on column ${iol_schema}.mpcs_a08thvhp.oprtlr is '';
comment on column ${iol_schema}.mpcs_a08thvhp.chktlr is '';
comment on column ${iol_schema}.mpcs_a08thvhp.clenus is '';
comment on column ${iol_schema}.mpcs_a08thvhp.auttlr is '';
comment on column ${iol_schema}.mpcs_a08thvhp.prttlr is '';
comment on column ${iol_schema}.mpcs_a08thvhp.prtcnt is '';
comment on column ${iol_schema}.mpcs_a08thvhp.incodt is '';
comment on column ${iol_schema}.mpcs_a08thvhp.chngam is '';
comment on column ${iol_schema}.mpcs_a08thvhp.refdid is '';
comment on column ${iol_schema}.mpcs_a08thvhp.consigndt is '';
comment on column ${iol_schema}.mpcs_a08thvhp.respcd is '';
comment on column ${iol_schema}.mpcs_a08thvhp.lostdt is '';
comment on column ${iol_schema}.mpcs_a08thvhp.unlsdt is '';
comment on column ${iol_schema}.mpcs_a08thvhp.lostlr is '';
comment on column ${iol_schema}.mpcs_a08thvhp.ulstlr is '';
comment on column ${iol_schema}.mpcs_a08thvhp.idtftp1 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.idtfno1 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.operna1 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.losttm is '';
comment on column ${iol_schema}.mpcs_a08thvhp.lostad is '';
comment on column ${iol_schema}.mpcs_a08thvhp.linkad1 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.linktl1 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.lostrs1 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.idtftp2 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.idtfno2 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.operna2 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.linkad2 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.linktl2 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.lostrs2 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.provtp is '';
comment on column ${iol_schema}.mpcs_a08thvhp.provno is '';
comment on column ${iol_schema}.mpcs_a08thvhp.reason is '';
comment on column ${iol_schema}.mpcs_a08thvhp.execut is '';
comment on column ${iol_schema}.mpcs_a08thvhp.execpe is '';
comment on column ${iol_schema}.mpcs_a08thvhp.certtp is '';
comment on column ${iol_schema}.mpcs_a08thvhp.certno is '';
comment on column ${iol_schema}.mpcs_a08thvhp.provtp2 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.provno2 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.reason2 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.execut2 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.execpe2 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.certtp2 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.certno2 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.signbilltype is '';
comment on column ${iol_schema}.mpcs_a08thvhp.flag3 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.feeamt is '';
comment on column ${iol_schema}.mpcs_a08thvhp.feeamt1 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.feeamt2 is '';
comment on column ${iol_schema}.mpcs_a08thvhp.bookdt is '';
comment on column ${iol_schema}.mpcs_a08thvhp.booknb is '';
comment on column ${iol_schema}.mpcs_a08thvhp.payopenbrn is '申请人开户机构号';
comment on column ${iol_schema}.mpcs_a08thvhp.payopenbrnnm is '申请人开户机构名称';
comment on column ${iol_schema}.mpcs_a08thvhp.incobrn is '收款行号';
comment on column ${iol_schema}.mpcs_a08thvhp.incobrnnm is '收款行名';
comment on column ${iol_schema}.mpcs_a08thvhp.idtftp3 is '兑付申请人证据类型';
comment on column ${iol_schema}.mpcs_a08thvhp.idtfno3 is '兑付申请人证据号';
comment on column ${iol_schema}.mpcs_a08thvhp.oprtlr3 is '兑付操作柜员';
comment on column ${iol_schema}.mpcs_a08thvhp.reason3 is '未用退回原因';
comment on column ${iol_schema}.mpcs_a08thvhp.paytype is '1转账入账2 支取现金';
comment on column ${iol_schema}.mpcs_a08thvhp.paybrnno is '签发行行号';
comment on column ${iol_schema}.mpcs_a08thvhp.paybrnname is '签发行行名';
comment on column ${iol_schema}.mpcs_a08thvhp.reason4 is '挂账原因';
comment on column ${iol_schema}.mpcs_a08thvhp.hpstatus is '账务处理状态 4-已挂账 6-已维护入账  7-已直接入账';
comment on column ${iol_schema}.mpcs_a08thvhp.paytp is '支付方式';
comment on column ${iol_schema}.mpcs_a08thvhp.bkcode is '凭证类型';
comment on column ${iol_schema}.mpcs_a08thvhp.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a08thvhp.etl_timestamp is 'ETL处理时间戳';
