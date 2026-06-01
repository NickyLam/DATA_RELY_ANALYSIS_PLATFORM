/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_crss_guaranty_info
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
alter table ${idl_schema}.oass_crss_guaranty_info drop partition p_${retain_week};
alter table ${idl_schema}.oass_crss_guaranty_info drop partition p_${batch_date};


-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_crss_guaranty_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_crss_guaranty_info (
    etl_dt  -- 数据日期
    ,guarantyid  -- 
    ,guarantytype  -- 
    ,guarantystatus  -- 
    ,ownerid  -- 
    ,ownername  -- 
    ,ownertype  -- 
    ,rate  -- 
    ,custguarantytype  -- 
    ,subjectno  -- 
    ,relativeaccount  -- 
    ,guarantyrightid  -- 
    ,otherguarantyright  -- 
    ,guarantyname  -- 
    ,guarantysubtype  -- 
    ,guarantyownway  -- 
    ,guarantyusing  -- 
    ,guarantylocation  -- 
    ,guarantyamount  -- 
    ,guarantyamount1  -- 
    ,guarantyamount2  -- 
    ,guarantyresouce  -- 
    ,guarantydate  -- 
    ,begindate  -- 
    ,ownertime  -- 
    ,guarantydescript  -- 
    ,aboutotherid1  -- 
    ,aboutotherid2  -- 
    ,aboutotherid3  -- 
    ,aboutotherid4  -- 
    ,purpose  -- 
    ,aboutsum1  -- 
    ,aboutsum2  -- 
    ,aboutrate  -- 
    ,guarantyana  -- 
    ,guarantyprice  -- 
    ,evalmethod  -- 
    ,evalorgid  -- 
    ,evalorgname  -- 
    ,evaldate  -- 
    ,evalnetvalue  -- 
    ,confirmvalue  -- 
    ,guarantyrate  -- 
    ,thirdparty1  -- 
    ,thirdparty2  -- 
    ,thirdparty3  -- 
    ,guarantydescribe1  -- 
    ,guarantydescribe2  -- 
    ,guarantydescribe3  -- 
    ,flag1  -- 
    ,flag2  -- 
    ,flag3  -- 
    ,flag4  -- 
    ,guarantyregno  -- 
    ,guarantyregorg  -- 
    ,guarantyregdate  -- 
    ,guarantywodate  -- 
    ,insurecertno  -- 
    ,otherassumpsit  -- 
    ,inputorgid  -- 
    ,inputuserid  -- 
    ,inputdate  -- 
    ,updateuserid  -- 
    ,updatedate  -- 
    ,remark  -- 
    ,sapvouchtype  -- 
    ,certtype  -- 
    ,certid  -- 
    ,loancardno  -- 
    ,guarantycurrency  -- 
    ,evalcurrency  -- 
    ,guarantydescribe4  -- 
    ,status  -- 
    ,eguarantyquality  -- 
    ,eguarantyamount  -- 
    ,eguarantyname  -- 
    ,eguarantyright  -- 
    ,eguarantyshare  -- 
    ,eguarantyowner  -- 
    ,eguarantyothersituation  -- 
    ,pledgename  -- 
    ,evaluatenetvalue  -- 
    ,spareyear  -- 
    ,buytime  -- 
    ,buyprice  -- 
    ,unitprice  -- 
    ,guarantynumber  -- 
    ,insurefirmname  -- 
    ,insuredate  -- 
    ,insuresum  -- 
    ,insurecontent  -- 
    ,nowstate  -- 
    ,ifguarantyflag  -- 
    ,rwaguarantytype  -- 
    ,guarantypublishtype  -- 
    ,evaluatemeans  -- 
    ,ifsure  -- 
    ,islowrisk  -- 
    ,drawee  -- 
    ,ownerrelative  -- 
    ,enddate  -- 
    ,custodyability  -- 
    ,impawncustody  -- 
    ,mortgagepledgevalue  -- 抵质押额
    ,jointowner  -- 
    ,flag5  -- 
    ,commercebackdrop  -- 
    ,querycase  -- 
    ,chamberlain  -- 
    ,putoutorgid  -- 
    ,trandt  -- 质押止付交易日期
    ,transq  -- 质押止付流水号
    ,otherguarrigper  -- 
    ,ischange  -- 
    ,newhnmber  -- 
    ,newhaddress  -- 
    ,zqno  -- 
    ,guarantycompany  -- 
    ,commercialhousingcontract  -- 抵押权益的房产买卖合同编号
    ,chitnd  -- 
    ,carbrand  -- 
    ,cartype  -- 
    ,carnumber  -- 
    ,chariotnumber  -- 
    ,motornumber  -- 
    ,subguarantyrightid  -- 质押止付子户号
    ,recordlogno  -- 放款平台押品流水号
    ,updateflag  -- 修改标志
    ,inputoffice  -- 登记机关
    ,tempsaveflag  -- 保存标志（1 已保存）
    ,grteac  -- 保证金账户
    ,account  -- 银行账号
    ,fpflag  -- 理财产品解冻交易发起标志
    ,fpserialno  -- 理财产品冻结流水号
    ,swtbizid  -- 票据业务流水号
    ,isinuse  -- 添加维护标志1正常2不维护
    ,hbname1  -- 核保人一姓名
    ,hbname2  -- 核保人二姓名
    ,qzname  -- 权证名称
    ,bwstartdate  -- 表外核算开始日期
    ,djendtime  -- 登记有效终止日期
    ,hbdate  -- 核保日期
    ,qzendtime  -- 权证有效到期日期
    ,ifbwhs  -- 是否纳入表外核算
    ,approveno  -- 审批单号
    ,ypguarantytype  -- 
    ,ypguarantyid  -- 
    ,start_dt  -- 
    ,end_dt  -- 
    ,id_mark  -- 
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.guarantyid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantytype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantystatus,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ownerid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ownername,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ownertype,chr(13),''),chr(10),'')  -- 
    ,t1.rate  -- 
    ,replace(replace(t1.custguarantytype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.subjectno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.relativeaccount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantyrightid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.otherguarantyright,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantyname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantysubtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantyownway,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantyusing,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantylocation,chr(13),''),chr(10),'')  -- 
    ,t1.guarantyamount  -- 
    ,t1.guarantyamount1  -- 
    ,t1.guarantyamount2  -- 
    ,replace(replace(t1.guarantyresouce,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantydate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.begindate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ownertime,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantydescript,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.aboutotherid1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.aboutotherid2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.aboutotherid3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.aboutotherid4,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.purpose,chr(13),''),chr(10),'')  -- 
    ,t1.aboutsum1  -- 
    ,t1.aboutsum2  -- 
    ,t1.aboutrate  -- 
    ,replace(replace(t1.guarantyana,chr(13),''),chr(10),'')  -- 
    ,t1.guarantyprice  -- 
    ,replace(replace(t1.evalmethod,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.evalorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.evalorgname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.evaldate,chr(13),''),chr(10),'')  -- 
    ,t1.evalnetvalue  -- 
    ,t1.confirmvalue  -- 
    ,t1.guarantyrate  -- 
    ,replace(replace(t1.thirdparty1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdparty2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdparty3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantydescribe1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantydescribe2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantydescribe3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flag1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flag2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flag3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flag4,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantyregno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantyregorg,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantyregdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantywodate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.insurecertno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.otherassumpsit,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.updateuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.updatedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.sapvouchtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.certtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.certid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loancardno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantycurrency,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.evalcurrency,chr(13),''),chr(10),'')  -- 
    ,t1.guarantydescribe4  -- 
    ,replace(replace(t1.status,chr(13),''),chr(10),'')  -- 
    ,t1.eguarantyquality  -- 
    ,t1.eguarantyamount  -- 
    ,replace(replace(t1.eguarantyname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.eguarantyright,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.eguarantyshare,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.eguarantyowner,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.eguarantyothersituation,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.pledgename,chr(13),''),chr(10),'')  -- 
    ,t1.evaluatenetvalue  -- 
    ,replace(replace(t1.spareyear,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.buytime,chr(13),''),chr(10),'')  -- 
    ,t1.buyprice  -- 
    ,t1.unitprice  -- 
    ,t1.guarantynumber  -- 
    ,replace(replace(t1.insurefirmname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.insuredate,chr(13),''),chr(10),'')  -- 
    ,t1.insuresum  -- 
    ,replace(replace(t1.insurecontent,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.nowstate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ifguarantyflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.rwaguarantytype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantypublishtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.evaluatemeans,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ifsure,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.islowrisk,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.drawee,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ownerrelative,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.enddate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.custodyability,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.impawncustody,chr(13),''),chr(10),'')  -- 
    ,t1.mortgagepledgevalue  -- 抵质押额
    ,replace(replace(t1.jointowner,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flag5,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.commercebackdrop,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.querycase,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.chamberlain,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.putoutorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.trandt,chr(13),''),chr(10),'')  -- 质押止付交易日期
    ,replace(replace(t1.transq,chr(13),''),chr(10),'')  -- 质押止付流水号
    ,replace(replace(t1.otherguarrigper,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ischange,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.newhnmber,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.newhaddress,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.zqno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantycompany,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.commercialhousingcontract,chr(13),''),chr(10),'')  -- 抵押权益的房产买卖合同编号
    ,replace(replace(t1.chitnd,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.carbrand,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cartype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.carnumber,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.chariotnumber,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.motornumber,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.subguarantyrightid,chr(13),''),chr(10),'')  -- 质押止付子户号
    ,replace(replace(t1.recordlogno,chr(13),''),chr(10),'')  -- 放款平台押品流水号
    ,replace(replace(t1.updateflag,chr(13),''),chr(10),'')  -- 修改标志
    ,replace(replace(t1.inputoffice,chr(13),''),chr(10),'')  -- 登记机关
    ,replace(replace(t1.tempsaveflag,chr(13),''),chr(10),'')  -- 保存标志（1 已保存）
    ,replace(replace(t1.grteac,chr(13),''),chr(10),'')  -- 保证金账户
    ,replace(replace(t1.account,chr(13),''),chr(10),'')  -- 银行账号
    ,replace(replace(t1.fpflag,chr(13),''),chr(10),'')  -- 理财产品解冻交易发起标志
    ,replace(replace(t1.fpserialno,chr(13),''),chr(10),'')  -- 理财产品冻结流水号
    ,replace(replace(t1.swtbizid,chr(13),''),chr(10),'')  -- 票据业务流水号
    ,replace(replace(t1.isinuse,chr(13),''),chr(10),'')  -- 添加维护标志1正常2不维护
    ,replace(replace(t1.hbname1,chr(13),''),chr(10),'')  -- 核保人一姓名
    ,replace(replace(t1.hbname2,chr(13),''),chr(10),'')  -- 核保人二姓名
    ,replace(replace(t1.qzname,chr(13),''),chr(10),'')  -- 权证名称
    ,replace(replace(t1.bwstartdate,chr(13),''),chr(10),'')  -- 表外核算开始日期
    ,replace(replace(t1.djendtime,chr(13),''),chr(10),'')  -- 登记有效终止日期
    ,replace(replace(t1.hbdate,chr(13),''),chr(10),'')  -- 核保日期
    ,replace(replace(t1.qzendtime,chr(13),''),chr(10),'')  -- 权证有效到期日期
    ,replace(replace(t1.ifbwhs,chr(13),''),chr(10),'')  -- 是否纳入表外核算
    ,replace(replace(t1.approveno,chr(13),''),chr(10),'')  -- 审批单号
    ,replace(replace(t1.ypguarantytype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.ypguarantyid,chr(13),''),chr(10),'')  -- 
    ,t1.start_dt  -- 
    ,t1.end_dt  -- 
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.crss_guaranty_info t1    --担保物信息表
where t1.start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_crss_guaranty_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);