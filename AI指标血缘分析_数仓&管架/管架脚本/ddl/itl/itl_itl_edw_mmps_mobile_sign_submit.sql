/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_mmps_mobile_sign_submit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_mmps_mobile_sign_submit
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_mmps_mobile_sign_submit purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_mmps_mobile_sign_submit(
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
    ,issms varchar2(1) -- 
    ,isnetb varchar2(1) -- 
    ,netbphone varchar2(20) -- 
    ,netbtransfer varchar2(1) -- 
    ,netbcustsign varchar2(1) -- 
    ,custmgrno varchar2(12) -- 
    ,idcheckresult varchar2(2) -- 
    ,vouchertype varchar2(10) -- 
    ,voucherno varchar2(20) -- 
    ,mobile varchar2(20) -- 
    ,openflag varchar2(1) -- 
    ,groupflag varchar2(3) -- 
    ,sectype varchar2(1) -- 
    ,secno varchar2(20) -- 
    ,leftmsg varchar2(30) -- 
    ,occupation varchar2(1) -- 
    ,isfinance varchar2(1) -- 
    ,address varchar2(100) -- 
    ,zipcd varchar2(6) -- 
    ,sendfreq varchar2(1) -- 
    ,sendmode varchar2(8) -- 
    ,risklevel varchar2(1) -- 
    ,clientgroup varchar2(1) -- 
    ,chnlflag varchar2(1) -- 
    ,pswd varchar2(20) -- 
    ,transresult varchar2(1000) -- 
    ,attbrn varchar2(6) -- 
    ,uptime timestamp(6) -- 
    ,isfund varchar2(1) -- 
    ,fundopflag varchar2(1) -- 
    ,openbrcno varchar2(9) -- 
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
    ,isquickin varchar2(1) -- 
    ,savetype varchar2(1) -- 
    ,savedeadline varchar2(5) -- 
    ,saveamt varchar2(20) -- 
    ,lowamt varchar2(20) -- 
    ,savemultiple varchar2(20) -- 
    ,nodeid varchar2(20) -- 
    ,quickinpass varchar2(25) -- 
    ,otheroccupation varchar2(40) -- 其他职业
    ,isfcfnct varchar2(1) -- 是否 非柜面非同名账户限额签约
    ,daylimit varchar2(16) -- 日累计限额
    ,txntimeslimit varchar2(16) -- 日笔数限额
    ,yearlimit varchar2(16) -- 年累计限额
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
grant select on ${itl_schema}.itl_edw_mmps_mobile_sign_submit to ${iel_schema};

-- comment
comment on table ${itl_schema}.itl_edw_mmps_mobile_sign_submit is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.scanseqno is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.bizcode is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.idtftp is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.idtfno is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.custna is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.idtaddress is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.idtdt is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.acctno is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.custno is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.sex is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.issms is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.isnetb is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.netbphone is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.netbtransfer is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.netbcustsign is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.custmgrno is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.idcheckresult is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.vouchertype is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.voucherno is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.mobile is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.openflag is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.groupflag is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.sectype is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.secno is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.leftmsg is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.occupation is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.isfinance is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.address is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.zipcd is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.sendfreq is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.sendmode is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.risklevel is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.clientgroup is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.chnlflag is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.pswd is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.transresult is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.attbrn is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.uptime is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.isfund is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.fundopflag is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.openbrcno is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.hometel is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.officetel is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.fax is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.email is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.edulevel is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.vocation is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.income is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.nation is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.finmanagerid is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.szsecno is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.shsecno is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.minorflag is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.fundnewacct is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.isothermanage is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.otheropflag is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.cobank is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.ccy is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.oriacct is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.oribrcode is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.bondacct is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.bondpass is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.bondcode is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.bondname is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.newacct is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.newpasswod is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.istimeinvest is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.isquickin is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.savetype is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.savedeadline is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.saveamt is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.lowamt is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.savemultiple is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.nodeid is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.quickinpass is '';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.otheroccupation is '其他职业';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.isfcfnct is '是否 非柜面非同名账户限额签约';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.daylimit is '日累计限额';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.txntimeslimit is '日笔数限额';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.yearlimit is '年累计限额';
comment on column ${itl_schema}.itl_edw_mmps_mobile_sign_submit.etl_timestamp is 'ETL处理时间戳';