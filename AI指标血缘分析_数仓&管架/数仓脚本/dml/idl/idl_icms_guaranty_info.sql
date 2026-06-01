/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icms_guaranty_info
CreateDate: 20250527
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.icms_guaranty_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_guaranty_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_guaranty_info (
etl_dt  --数据日期
,guarantyid  --押品编号
,rwisenoughvalue  --现时是否足值(风险预警)
,ownertype  --所属人客户类型
,contracttype  --担保方式
,evaluatenetvalue  --评估价值（元）
,guarantytype  --押品类型
,floorarea  --不动产建筑面积(平方米)
,rwlocation  --地址/存放地点(风险预警)
,rwbuildbuyprice  --建购价款(风险预警)
,evalorgname  --评估机构
,ownerid  --权利人客户编号
,realestatecode  --不动产证号
,guarantystatus  --担保状态
,updateorgid  --更新机构
,rwpledgerate  --现时抵质押率(风险预警)
,guarantyname  --押品名称
,lettertype  --保函类型
,lettercontry  --证书开具国别
,evaldate  --估值日期
,ypguarantyid  --押品系统的编号
,migtflag  --迁移标志：crs rcr ilc upl
,letterno  --保函编号
,certid  --所属人证件号码
,confirmvalue  --我行确认价值
,inputuserid  --登记人
,lettersum  --保函金额
,guarantyrightid  --权证号码
,inputdate  --登记日期
,guarantyrighttype  --权证类型
,updatedate  --更新日期
,updateuserid  --更新人
,issueorgtype  --担保机构类型
,ownername  --权属人名称
,certtype  --所属人证件类型
,guaranteetype  --保证担保形式
,lettercurrency  --保函币种
,inputorgid  --登记机构
,rwpracticalvalue  --现时实际价值(风险预警)
,guarantylocation  --抵押物地址
,aboutotherid1  --母账号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.guarantyid,chr(13),''),chr(10),'') as guarantyid --押品编号
,replace(replace(t1.rwisenoughvalue,chr(13),''),chr(10),'') as rwisenoughvalue --现时是否足值(风险预警)
,replace(replace(t1.ownertype,chr(13),''),chr(10),'') as ownertype --所属人客户类型
,replace(replace(t1.contracttype,chr(13),''),chr(10),'') as contracttype --担保方式
,t1.evaluatenetvalue as evaluatenetvalue --评估价值（元）
,replace(replace(t1.guarantytype,chr(13),''),chr(10),'') as guarantytype --押品类型
,t1.floorarea as floorarea --不动产建筑面积(平方米)
,replace(replace(t1.rwlocation,chr(13),''),chr(10),'') as rwlocation --地址/存放地点(风险预警)
,t1.rwbuildbuyprice as rwbuildbuyprice --建购价款(风险预警)
,replace(replace(t1.evalorgname,chr(13),''),chr(10),'') as evalorgname --评估机构
,replace(replace(t1.ownerid,chr(13),''),chr(10),'') as ownerid --权利人客户编号
,replace(replace(t1.realestatecode,chr(13),''),chr(10),'') as realestatecode --不动产证号
,replace(replace(t1.guarantystatus,chr(13),''),chr(10),'') as guarantystatus --担保状态
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid --更新机构
,t1.rwpledgerate as rwpledgerate --现时抵质押率(风险预警)
,replace(replace(t1.guarantyname,chr(13),''),chr(10),'') as guarantyname --押品名称
,replace(replace(t1.lettertype,chr(13),''),chr(10),'') as lettertype --保函类型
,replace(replace(t1.lettercontry,chr(13),''),chr(10),'') as lettercontry --证书开具国别
,t1.evaldate as evaldate --估值日期
,replace(replace(t1.ypguarantyid,chr(13),''),chr(10),'') as ypguarantyid --押品系统的编号
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag --迁移标志：crs rcr ilc upl
,replace(replace(t1.letterno,chr(13),''),chr(10),'') as letterno --保函编号
,replace(replace(t1.certid,chr(13),''),chr(10),'') as certid --所属人证件号码
,t1.confirmvalue as confirmvalue --我行确认价值
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid --登记人
,t1.lettersum as lettersum --保函金额
,replace(replace(t1.guarantyrightid,chr(13),''),chr(10),'') as guarantyrightid --权证号码
,t1.inputdate as inputdate --登记日期
,replace(replace(t1.guarantyrighttype,chr(13),''),chr(10),'') as guarantyrighttype --权证类型
,t1.updatedate as updatedate --更新日期
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid --更新人
,replace(replace(t1.issueorgtype,chr(13),''),chr(10),'') as issueorgtype --担保机构类型
,replace(replace(t1.ownername,chr(13),''),chr(10),'') as ownername --权属人名称
,replace(replace(t1.certtype,chr(13),''),chr(10),'') as certtype --所属人证件类型
,replace(replace(t1.guaranteetype,chr(13),''),chr(10),'') as guaranteetype --保证担保形式
,replace(replace(t1.lettercurrency,chr(13),''),chr(10),'') as lettercurrency --保函币种
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid --登记机构
,t1.rwpracticalvalue as rwpracticalvalue --现时实际价值(风险预警)
,replace(replace(t1.guarantylocation,chr(13),''),chr(10),'') as guarantylocation --抵押物地址
,replace(replace(t1.aboutotherid1,chr(13),''),chr(10),'') as aboutotherid1 --母账号
from ${iol_schema}.icms_guaranty_info t1    --押品信息
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_guaranty_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
