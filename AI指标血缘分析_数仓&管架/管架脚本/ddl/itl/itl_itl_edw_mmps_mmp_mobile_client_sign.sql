/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_mmps_mmp_mobile_client_sign
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign(
    etl_dt date -- 数据日期
    ,scanseqno varchar2(30) -- 
    ,bizcode varchar2(6) -- 
    ,idtftp varchar2(1) -- 
    ,idtfno varchar2(20) -- 
    ,custna varchar2(40) -- 
    ,idtaddress varchar2(100) -- 
    ,idtdt varchar2(8) -- 
    ,acctno varchar2(28) -- 
    ,custno varchar2(12) -- 
    ,sex varchar2(32) -- 
    ,mobile varchar2(20) -- 
    ,idcheckresult varchar2(2) -- 
    ,netbcustsign varchar2(1) -- 
    ,openflag varchar2(1) -- 
    ,groupflag varchar2(3) -- 
    ,sectype varchar2(1) -- 
    ,secno varchar2(20) -- 
    ,netbphone varchar2(20) -- 
    ,leftmsg varchar2(30) -- 
    ,transid varchar2(100) -- 
    ,transresult varchar2(1000) -- 
    ,isnetb varchar2(1) -- 
    ,issms varchar2(1) -- 
    ,smscustsign varchar2(1) -- 
    ,feeacctno varchar2(28) -- 
    ,feeacctbrcno varchar2(3) -- 
    ,feeacctnodeno varchar2(6) -- 
    ,isfinance varchar2(1) -- 
    ,financeacctno varchar2(28) -- 
    ,openbrcno varchar2(6) -- 
    ,address varchar2(100) -- 
    ,zipcd varchar2(6) -- 
    ,custmgrno varchar2(32) -- 
    ,sendfreq varchar2(1) -- 
    ,sendmode varchar2(8) -- 
    ,risklevel varchar2(1) -- 
    ,clientgroup varchar2(1) -- 
    ,chnlflag varchar2(1) -- 
    ,alloriphone varchar2(11) -- 
    ,uptime timestamp(6) -- 
    ,smsopflag varchar2(1) -- 
    ,allopflag varchar2(1) -- 
    ,finopflag varchar2(1) -- 
    ,netopflag varchar2(1) -- 
    ,delukey varchar2(1) -- 
    ,alldelphone varchar2(11) -- 
    ,allrepphone varchar2(11) -- 
    ,alladdphone varchar2(11) -- 
    ,bgnamt varchar2(15) -- 
    ,finnewacct varchar2(30) -- 
    ,finnewopenbrcno varchar2(8) -- 
    ,isfund varchar2(1) -- 
    ,fundacct varchar2(32) -- 
    ,fundopflag varchar2(1) -- 
    ,fundbrcno varchar2(9) -- 
    ,hometel varchar2(30) -- 
    ,officetel varchar2(30) -- 
    ,fax varchar2(30) -- 
    ,email varchar2(30) -- 
    ,edulevel varchar2(3) -- 
    ,vocation varchar2(3) -- 
    ,income varchar2(2) -- 
    ,nation varchar2(3) -- 
    ,finmanagerid varchar2(16) -- 
    ,szsecno varchar2(16) -- 
    ,shsecno varchar2(16) -- 
    ,minorflag varchar2(1) -- 
    ,fundnewacct varchar2(32) -- 
    ,isothermanage varchar2(32) -- 
    ,otheropflag varchar2(32) -- 
    ,cobank varchar2(32) -- 
    ,ccy varchar2(32) -- 
    ,oriacct varchar2(28) -- 
    ,oribrcode varchar2(6) -- 
    ,bondacct varchar2(28) -- 
    ,bondpass varchar2(28) -- 
    ,bondcode varchar2(30) -- 
    ,bondname varchar2(100) -- 
    ,newacct varchar2(30) -- 
    ,newpasswod varchar2(30) -- 
    ,istimeinvest varchar2(1) -- 
    ,investopflag varchar2(1) -- 
    ,isquickin varchar2(1) -- 
    ,quickinopflag varchar2(1) -- 
    ,savetype varchar2(1) -- 
    ,savedeadline varchar2(5) -- 
    ,saveamt varchar2(20) -- 
    ,lowamt varchar2(20) -- 
    ,savemultiple varchar2(20) -- 
    ,pswd varchar2(20) -- 
    ,nodeid varchar2(20) -- 
    ,isfcfnoper varchar2(1) -- 是否操作非柜面非同名限额签约
    ,isfcfntype varchar2(1) -- 是否 非柜面非同名账户限额签约
    ,daylimit varchar2(16) -- 日累计限额
    ,txntimeslimit varchar2(16) -- 日笔数限额
    ,yearlimit varchar2(16) -- 年累计限额
    ,otherccupation varchar2(40) -- 其他职业
    ,changeebankpwd varchar2(1) -- 是否重置网银登录密码
    ,etl_timestamp timestamp -- ETL处理时间戳
   -- ,job_cd varchar2(10) -- 任务编码
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign to ${iel_schema};

-- comment
comment on table ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.scanseqno is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.bizcode is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.idtftp is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.idtfno is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.custna is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.idtaddress is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.idtdt is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.acctno is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.custno is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.sex is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.mobile is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.idcheckresult is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.netbcustsign is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.openflag is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.groupflag is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.sectype is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.secno is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.netbphone is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.leftmsg is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.transid is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.transresult is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.isnetb is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.issms is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.smscustsign is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.feeacctno is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.feeacctbrcno is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.feeacctnodeno is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.isfinance is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.financeacctno is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.openbrcno is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.address is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.zipcd is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.custmgrno is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.sendfreq is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.sendmode is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.risklevel is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.clientgroup is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.chnlflag is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.alloriphone is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.uptime is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.smsopflag is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.allopflag is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.finopflag is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.netopflag is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.delukey is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.alldelphone is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.allrepphone is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.alladdphone is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.bgnamt is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.finnewacct is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.finnewopenbrcno is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.isfund is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.fundacct is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.fundopflag is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.fundbrcno is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.hometel is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.officetel is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.fax is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.email is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.edulevel is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.vocation is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.income is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.nation is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.finmanagerid is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.szsecno is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.shsecno is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.minorflag is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.fundnewacct is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.isothermanage is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.otheropflag is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.cobank is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.ccy is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.oriacct is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.oribrcode is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.bondacct is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.bondpass is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.bondcode is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.bondname is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.newacct is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.newpasswod is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.istimeinvest is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.investopflag is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.isquickin is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.quickinopflag is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.savetype is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.savedeadline is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.saveamt is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.lowamt is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.savemultiple is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.pswd is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.nodeid is '';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.isfcfnoper is '是否操作非柜面非同名限额签约';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.isfcfntype is '是否 非柜面非同名账户限额签约';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.daylimit is '日累计限额';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.txntimeslimit is '日笔数限额';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.yearlimit is '年累计限额';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.otherccupation is '其他职业';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.changeebankpwd is '是否重置网银登录密码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign.etl_timestamp is 'ETL处理时间戳';