/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_mmps_mmp_mobile_client_sign
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_mmps_mmp_mobile_client_sign partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,scanseqno  -- 
    ,bizcode  -- 
    ,idtftp  -- 
    ,idtfno  -- 
    ,custna  -- 
    ,idtaddress  -- 
    ,idtdt  -- 
    ,acctno  -- 
    ,custno  -- 
    ,sex  -- 
    ,mobile  -- 
    ,idcheckresult  -- 
    ,netbcustsign  -- 
    ,openflag  -- 
    ,groupflag  -- 
    ,sectype  -- 
    ,secno  -- 
    ,netbphone  -- 
    ,leftmsg  -- 
    ,transid  -- 
    ,transresult  -- 
    ,isnetb  -- 
    ,issms  -- 
    ,smscustsign  -- 
    ,feeacctno  -- 
    ,feeacctbrcno  -- 
    ,feeacctnodeno  -- 
    ,isfinance  -- 
    ,financeacctno  -- 
    ,openbrcno  -- 
    ,address  -- 
    ,zipcd  -- 
    ,custmgrno  -- 
    ,sendfreq  -- 
    ,sendmode  -- 
    ,risklevel  -- 
    ,clientgroup  -- 
    ,chnlflag  -- 
    ,alloriphone  -- 
    ,uptime  -- 
    ,smsopflag  -- 
    ,allopflag  -- 
    ,finopflag  -- 
    ,netopflag  -- 
    ,delukey  -- 
    ,alldelphone  -- 
    ,allrepphone  -- 
    ,alladdphone  -- 
    ,bgnamt  -- 
    ,finnewacct  -- 
    ,finnewopenbrcno  -- 
    ,isfund  -- 
    ,fundacct  -- 
    ,fundopflag  -- 
    ,fundbrcno  -- 
    ,hometel  -- 
    ,officetel  -- 
    ,fax  -- 
    ,email  -- 
    ,edulevel  -- 
    ,vocation  -- 
    ,income  -- 
    ,nation  -- 
    ,finmanagerid  -- 
    ,szsecno  -- 
    ,shsecno  -- 
    ,minorflag  -- 
    ,fundnewacct  -- 
    ,isothermanage  -- 
    ,otheropflag  -- 
    ,cobank  -- 
    ,ccy  -- 
    ,oriacct  -- 
    ,oribrcode  -- 
    ,bondacct  -- 
    ,bondpass  -- 
    ,bondcode  -- 
    ,bondname  -- 
    ,newacct  -- 
    ,newpasswod  -- 
    ,istimeinvest  -- 
    ,investopflag  -- 
    ,isquickin  -- 
    ,quickinopflag  -- 
    ,savetype  -- 
    ,savedeadline  -- 
    ,saveamt  -- 
    ,lowamt  -- 
    ,savemultiple  -- 
    ,pswd  -- 
    ,nodeid  -- 
    ,isfcfnoper  -- 是否操作非柜面非同名限额签约
    ,isfcfntype  -- 是否 非柜面非同名账户限额签约
    ,daylimit  -- 日累计限额
    ,txntimeslimit  -- 日笔数限额
    ,yearlimit  -- 年累计限额
    ,otherccupation  -- 其他职业
    ,changeebankpwd  -- 是否重置网银登录密码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.scanseqno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.bizcode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.idtftp,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.idtfno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.custna,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.idtaddress,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.idtdt,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.acctno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.custno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.sex,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.mobile,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.idcheckresult,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.netbcustsign,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.openflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.groupflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.sectype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.secno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.netbphone,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.leftmsg,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.transid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.transresult,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.isnetb,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.issms,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.smscustsign,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.feeacctno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.feeacctbrcno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.feeacctnodeno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.isfinance,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.financeacctno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.openbrcno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.address,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.zipcd,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.custmgrno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.sendfreq,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.sendmode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.risklevel,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.clientgroup,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.chnlflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.alloriphone,chr(13),''),chr(10),'')  -- 
    ,t1.uptime  -- 
    ,replace(replace(t1.smsopflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.allopflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.finopflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.netopflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.delukey,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.alldelphone,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.allrepphone,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.alladdphone,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.bgnamt,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.finnewacct,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.finnewopenbrcno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.isfund,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fundacct,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fundopflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fundbrcno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.hometel,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.officetel,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fax,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.email,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.edulevel,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.vocation,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.income,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.nation,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.finmanagerid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.szsecno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.shsecno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.minorflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fundnewacct,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.isothermanage,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.otheropflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cobank,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ccy,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.oriacct,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.oribrcode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.bondacct,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.bondpass,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.bondcode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.bondname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.newacct,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.newpasswod,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.istimeinvest,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.investopflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.isquickin,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.quickinopflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.savetype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.savedeadline,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.saveamt,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.lowamt,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.savemultiple,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.pswd,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.nodeid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.isfcfnoper,chr(13),''),chr(10),'')  -- 是否操作非柜面非同名限额签约
    ,replace(replace(t1.isfcfntype,chr(13),''),chr(10),'')  -- 是否 非柜面非同名账户限额签约
    ,replace(replace(t1.daylimit,chr(13),''),chr(10),'')  -- 日累计限额
    ,replace(replace(t1.txntimeslimit,chr(13),''),chr(10),'')  -- 日笔数限额
    ,replace(replace(t1.yearlimit,chr(13),''),chr(10),'')  -- 年累计限额
    ,replace(replace(t1.otherccupation,chr(13),''),chr(10),'')  -- 其他职业
    ,replace(replace(t1.changeebankpwd,chr(13),''),chr(10),'')  -- 是否重置网银登录密码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from iol.v_mmps_mmp_mobile_client_sign t1    --
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_mmps_mmp_mobile_client_sign',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);