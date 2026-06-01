/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_guaranty_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.icms_guaranty_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_guaranty_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_guaranty_info_op purge;
drop table ${iol_schema}.icms_guaranty_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_guaranty_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_guaranty_info where 0=1;

create table ${iol_schema}.icms_guaranty_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_guaranty_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_guaranty_info_cl(
            guarantyid -- 押品编号
            ,rwisenoughvalue -- 现时是否足值(风险预警)
            ,ownertype -- 所属人客户类型
            ,contracttype -- 担保方式
            ,evaluatenetvalue -- 评估价值（元）
            ,guarantytype -- 押品类型
            ,floorarea -- 不动产建筑面积(平方米)
            ,rwlocation -- 地址/存放地点(风险预警)
            ,rwbuildbuyprice -- 建购价款(风险预警)
            ,evalorgname -- 评估机构
            ,ownerid -- 权利人客户编号
            ,realestatecode -- 不动产证号
            ,guarantystatus -- 担保状态
            ,updateorgid -- 更新机构
            ,rwpledgerate -- 现时抵质押率(风险预警)
            ,guarantyname -- 押品名称
            ,lettertype -- 保函类型
            ,lettercontry -- 证书开具国别
            ,evaldate -- 估值日期
            ,ypguarantyid -- 押品系统的编号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,letterno -- 保函编号
            ,certid -- 所属人证件号码
            ,confirmvalue -- 我行确认价值
            ,inputuserid -- 登记人
            ,lettersum -- 保函金额
            ,guarantyrightid -- 权证号码
            ,inputdate -- 登记日期
            ,guarantyrighttype -- 权证类型
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,issueorgtype -- 担保机构类型
            ,ownername -- 权属人名称
            ,certtype -- 所属人证件类型
            ,guaranteetype -- 保证担保形式
            ,lettercurrency -- 保函币种
            ,inputorgid -- 登记机构
            ,rwpracticalvalue -- 现时实际价值(风险预警)
            ,guarantylocation -- 抵押物地址
            ,aboutotherid1 -- 母账号
            ,aboutotherid2 -- 
            ,aboutotherid3 -- 
            ,financialyield -- 
            ,collateraltype -- 
            ,stockcode -- 
            ,stockname -- 
            ,shareamount -- 
            ,persharemarketprice -- 
            ,totalvalue -- 
            ,warningline -- 
            ,liquidateline -- 
            ,evalexpiredate -- 
            ,registerno -- 
            ,statuschangetime -- 
            ,isnewshilianassessvalue -- 
            ,newshilianassessvalue -- 
            ,newshilianassessdate -- 
            ,isshilianaccevaluate -- 
            ,isourbankaccevaluate -- 
            ,externalevaluatevalue -- 
            ,externalevaluatedate -- 
            ,externalevaluateexpiredate -- 
            ,remark -- 备注
            ,registcountry -- 保证人注册地所在国家或地区
            ,registcountryresult -- 保证人注册地所在国家或地区外部评级结果
            ,outratingdate -- 保证人外部评级日期
            ,outratingresult -- 保证人外部评级结果
            ,inratingdate -- 保证人内部评级日期
            ,inratingresult -- 保证人内部评级结果
            ,guarcash -- 担保公司保证金金额
            ,isstage -- 是否阶段性担保
            ,insuranceno -- 保证保险保单号码
            ,purpose -- 保证目的
            ,independence -- 保证人担保独立性
            ,isresident -- 是否居民
            ,netassetcurrency -- 净资产币种
            ,orgname -- 开立机构名称（保函）\开证机构名称（信用证）
            ,orgtype -- 开立机构类型（保函）\开证机构类型（信用证）
            ,iscancel -- 是否不可撤销
            ,vouchertype -- 保证人所有制类型
            ,netasset -- 保证人净资产
            ,confirmcurrency -- 担保币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_guaranty_info_op(
            guarantyid -- 押品编号
            ,rwisenoughvalue -- 现时是否足值(风险预警)
            ,ownertype -- 所属人客户类型
            ,contracttype -- 担保方式
            ,evaluatenetvalue -- 评估价值（元）
            ,guarantytype -- 押品类型
            ,floorarea -- 不动产建筑面积(平方米)
            ,rwlocation -- 地址/存放地点(风险预警)
            ,rwbuildbuyprice -- 建购价款(风险预警)
            ,evalorgname -- 评估机构
            ,ownerid -- 权利人客户编号
            ,realestatecode -- 不动产证号
            ,guarantystatus -- 担保状态
            ,updateorgid -- 更新机构
            ,rwpledgerate -- 现时抵质押率(风险预警)
            ,guarantyname -- 押品名称
            ,lettertype -- 保函类型
            ,lettercontry -- 证书开具国别
            ,evaldate -- 估值日期
            ,ypguarantyid -- 押品系统的编号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,letterno -- 保函编号
            ,certid -- 所属人证件号码
            ,confirmvalue -- 我行确认价值
            ,inputuserid -- 登记人
            ,lettersum -- 保函金额
            ,guarantyrightid -- 权证号码
            ,inputdate -- 登记日期
            ,guarantyrighttype -- 权证类型
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,issueorgtype -- 担保机构类型
            ,ownername -- 权属人名称
            ,certtype -- 所属人证件类型
            ,guaranteetype -- 保证担保形式
            ,lettercurrency -- 保函币种
            ,inputorgid -- 登记机构
            ,rwpracticalvalue -- 现时实际价值(风险预警)
            ,guarantylocation -- 抵押物地址
            ,aboutotherid1 -- 母账号
            ,aboutotherid2 -- 
            ,aboutotherid3 -- 
            ,financialyield -- 
            ,collateraltype -- 
            ,stockcode -- 
            ,stockname -- 
            ,shareamount -- 
            ,persharemarketprice -- 
            ,totalvalue -- 
            ,warningline -- 
            ,liquidateline -- 
            ,evalexpiredate -- 
            ,registerno -- 
            ,statuschangetime -- 
            ,isnewshilianassessvalue -- 
            ,newshilianassessvalue -- 
            ,newshilianassessdate -- 
            ,isshilianaccevaluate -- 
            ,isourbankaccevaluate -- 
            ,externalevaluatevalue -- 
            ,externalevaluatedate -- 
            ,externalevaluateexpiredate -- 
            ,remark -- 备注
            ,registcountry -- 保证人注册地所在国家或地区
            ,registcountryresult -- 保证人注册地所在国家或地区外部评级结果
            ,outratingdate -- 保证人外部评级日期
            ,outratingresult -- 保证人外部评级结果
            ,inratingdate -- 保证人内部评级日期
            ,inratingresult -- 保证人内部评级结果
            ,guarcash -- 担保公司保证金金额
            ,isstage -- 是否阶段性担保
            ,insuranceno -- 保证保险保单号码
            ,purpose -- 保证目的
            ,independence -- 保证人担保独立性
            ,isresident -- 是否居民
            ,netassetcurrency -- 净资产币种
            ,orgname -- 开立机构名称（保函）\开证机构名称（信用证）
            ,orgtype -- 开立机构类型（保函）\开证机构类型（信用证）
            ,iscancel -- 是否不可撤销
            ,vouchertype -- 保证人所有制类型
            ,netasset -- 保证人净资产
            ,confirmcurrency -- 担保币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.guarantyid, o.guarantyid) as guarantyid -- 押品编号
    ,nvl(n.rwisenoughvalue, o.rwisenoughvalue) as rwisenoughvalue -- 现时是否足值(风险预警)
    ,nvl(n.ownertype, o.ownertype) as ownertype -- 所属人客户类型
    ,nvl(n.contracttype, o.contracttype) as contracttype -- 担保方式
    ,nvl(n.evaluatenetvalue, o.evaluatenetvalue) as evaluatenetvalue -- 评估价值（元）
    ,nvl(n.guarantytype, o.guarantytype) as guarantytype -- 押品类型
    ,nvl(n.floorarea, o.floorarea) as floorarea -- 不动产建筑面积(平方米)
    ,nvl(n.rwlocation, o.rwlocation) as rwlocation -- 地址/存放地点(风险预警)
    ,nvl(n.rwbuildbuyprice, o.rwbuildbuyprice) as rwbuildbuyprice -- 建购价款(风险预警)
    ,nvl(n.evalorgname, o.evalorgname) as evalorgname -- 评估机构
    ,nvl(n.ownerid, o.ownerid) as ownerid -- 权利人客户编号
    ,nvl(n.realestatecode, o.realestatecode) as realestatecode -- 不动产证号
    ,nvl(n.guarantystatus, o.guarantystatus) as guarantystatus -- 担保状态
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.rwpledgerate, o.rwpledgerate) as rwpledgerate -- 现时抵质押率(风险预警)
    ,nvl(n.guarantyname, o.guarantyname) as guarantyname -- 押品名称
    ,nvl(n.lettertype, o.lettertype) as lettertype -- 保函类型
    ,nvl(n.lettercontry, o.lettercontry) as lettercontry -- 证书开具国别
    ,nvl(n.evaldate, o.evaldate) as evaldate -- 估值日期
    ,nvl(n.ypguarantyid, o.ypguarantyid) as ypguarantyid -- 押品系统的编号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.letterno, o.letterno) as letterno -- 保函编号
    ,nvl(n.certid, o.certid) as certid -- 所属人证件号码
    ,nvl(n.confirmvalue, o.confirmvalue) as confirmvalue -- 我行确认价值
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.lettersum, o.lettersum) as lettersum -- 保函金额
    ,nvl(n.guarantyrightid, o.guarantyrightid) as guarantyrightid -- 权证号码
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.guarantyrighttype, o.guarantyrighttype) as guarantyrighttype -- 权证类型
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.issueorgtype, o.issueorgtype) as issueorgtype -- 担保机构类型
    ,nvl(n.ownername, o.ownername) as ownername -- 权属人名称
    ,nvl(n.certtype, o.certtype) as certtype -- 所属人证件类型
    ,nvl(n.guaranteetype, o.guaranteetype) as guaranteetype -- 保证担保形式
    ,nvl(n.lettercurrency, o.lettercurrency) as lettercurrency -- 保函币种
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.rwpracticalvalue, o.rwpracticalvalue) as rwpracticalvalue -- 现时实际价值(风险预警)
    ,nvl(n.guarantylocation, o.guarantylocation) as guarantylocation -- 抵押物地址
    ,nvl(n.aboutotherid1, o.aboutotherid1) as aboutotherid1 -- 母账号
    ,nvl(n.aboutotherid2, o.aboutotherid2) as aboutotherid2 -- 
    ,nvl(n.aboutotherid3, o.aboutotherid3) as aboutotherid3 -- 
    ,nvl(n.financialyield, o.financialyield) as financialyield -- 
    ,nvl(n.collateraltype, o.collateraltype) as collateraltype -- 
    ,nvl(n.stockcode, o.stockcode) as stockcode -- 
    ,nvl(n.stockname, o.stockname) as stockname -- 
    ,nvl(n.shareamount, o.shareamount) as shareamount -- 
    ,nvl(n.persharemarketprice, o.persharemarketprice) as persharemarketprice -- 
    ,nvl(n.totalvalue, o.totalvalue) as totalvalue -- 
    ,nvl(n.warningline, o.warningline) as warningline -- 
    ,nvl(n.liquidateline, o.liquidateline) as liquidateline -- 
    ,nvl(n.evalexpiredate, o.evalexpiredate) as evalexpiredate -- 
    ,nvl(n.registerno, o.registerno) as registerno -- 
    ,nvl(n.statuschangetime, o.statuschangetime) as statuschangetime -- 
    ,nvl(n.isnewshilianassessvalue, o.isnewshilianassessvalue) as isnewshilianassessvalue -- 
    ,nvl(n.newshilianassessvalue, o.newshilianassessvalue) as newshilianassessvalue -- 
    ,nvl(n.newshilianassessdate, o.newshilianassessdate) as newshilianassessdate -- 
    ,nvl(n.isshilianaccevaluate, o.isshilianaccevaluate) as isshilianaccevaluate -- 
    ,nvl(n.isourbankaccevaluate, o.isourbankaccevaluate) as isourbankaccevaluate -- 
    ,nvl(n.externalevaluatevalue, o.externalevaluatevalue) as externalevaluatevalue -- 
    ,nvl(n.externalevaluatedate, o.externalevaluatedate) as externalevaluatedate -- 
    ,nvl(n.externalevaluateexpiredate, o.externalevaluateexpiredate) as externalevaluateexpiredate -- 
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.registcountry, o.registcountry) as registcountry -- 保证人注册地所在国家或地区
    ,nvl(n.registcountryresult, o.registcountryresult) as registcountryresult -- 保证人注册地所在国家或地区外部评级结果
    ,nvl(n.outratingdate, o.outratingdate) as outratingdate -- 保证人外部评级日期
    ,nvl(n.outratingresult, o.outratingresult) as outratingresult -- 保证人外部评级结果
    ,nvl(n.inratingdate, o.inratingdate) as inratingdate -- 保证人内部评级日期
    ,nvl(n.inratingresult, o.inratingresult) as inratingresult -- 保证人内部评级结果
    ,nvl(n.guarcash, o.guarcash) as guarcash -- 担保公司保证金金额
    ,nvl(n.isstage, o.isstage) as isstage -- 是否阶段性担保
    ,nvl(n.insuranceno, o.insuranceno) as insuranceno -- 保证保险保单号码
    ,nvl(n.purpose, o.purpose) as purpose -- 保证目的
    ,nvl(n.independence, o.independence) as independence -- 保证人担保独立性
    ,nvl(n.isresident, o.isresident) as isresident -- 是否居民
    ,nvl(n.netassetcurrency, o.netassetcurrency) as netassetcurrency -- 净资产币种
    ,nvl(n.orgname, o.orgname) as orgname -- 开立机构名称（保函）\开证机构名称（信用证）
    ,nvl(n.orgtype, o.orgtype) as orgtype -- 开立机构类型（保函）\开证机构类型（信用证）
    ,nvl(n.iscancel, o.iscancel) as iscancel -- 是否不可撤销
    ,nvl(n.vouchertype, o.vouchertype) as vouchertype -- 保证人所有制类型
    ,nvl(n.netasset, o.netasset) as netasset -- 保证人净资产
    ,nvl(n.confirmcurrency, o.confirmcurrency) as confirmcurrency -- 担保币种
    ,case when
            n.guarantyid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.guarantyid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.guarantyid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_guaranty_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_guaranty_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.guarantyid = n.guarantyid
where (
        o.guarantyid is null
    )
    or (
        n.guarantyid is null
    )
    or (
        o.rwisenoughvalue <> n.rwisenoughvalue
        or o.ownertype <> n.ownertype
        or o.contracttype <> n.contracttype
        or o.evaluatenetvalue <> n.evaluatenetvalue
        or o.guarantytype <> n.guarantytype
        or o.floorarea <> n.floorarea
        or o.rwlocation <> n.rwlocation
        or o.rwbuildbuyprice <> n.rwbuildbuyprice
        or o.evalorgname <> n.evalorgname
        or o.ownerid <> n.ownerid
        or o.realestatecode <> n.realestatecode
        or o.guarantystatus <> n.guarantystatus
        or o.updateorgid <> n.updateorgid
        or o.rwpledgerate <> n.rwpledgerate
        or o.guarantyname <> n.guarantyname
        or o.lettertype <> n.lettertype
        or o.lettercontry <> n.lettercontry
        or o.evaldate <> n.evaldate
        or o.ypguarantyid <> n.ypguarantyid
        or o.migtflag <> n.migtflag
        or o.letterno <> n.letterno
        or o.certid <> n.certid
        or o.confirmvalue <> n.confirmvalue
        or o.inputuserid <> n.inputuserid
        or o.lettersum <> n.lettersum
        or o.guarantyrightid <> n.guarantyrightid
        or o.inputdate <> n.inputdate
        or o.guarantyrighttype <> n.guarantyrighttype
        or o.updatedate <> n.updatedate
        or o.updateuserid <> n.updateuserid
        or o.issueorgtype <> n.issueorgtype
        or o.ownername <> n.ownername
        or o.certtype <> n.certtype
        or o.guaranteetype <> n.guaranteetype
        or o.lettercurrency <> n.lettercurrency
        or o.inputorgid <> n.inputorgid
        or o.rwpracticalvalue <> n.rwpracticalvalue
        or o.guarantylocation <> n.guarantylocation
        or o.aboutotherid1 <> n.aboutotherid1
        or o.aboutotherid2 <> n.aboutotherid2
        or o.aboutotherid3 <> n.aboutotherid3
        or o.financialyield <> n.financialyield
        or o.collateraltype <> n.collateraltype
        or o.stockcode <> n.stockcode
        or o.stockname <> n.stockname
        or o.shareamount <> n.shareamount
        or o.persharemarketprice <> n.persharemarketprice
        or o.totalvalue <> n.totalvalue
        or o.warningline <> n.warningline
        or o.liquidateline <> n.liquidateline
        or o.evalexpiredate <> n.evalexpiredate
        or o.registerno <> n.registerno
        or o.statuschangetime <> n.statuschangetime
        or o.isnewshilianassessvalue <> n.isnewshilianassessvalue
        or o.newshilianassessvalue <> n.newshilianassessvalue
        or o.newshilianassessdate <> n.newshilianassessdate
        or o.isshilianaccevaluate <> n.isshilianaccevaluate
        or o.isourbankaccevaluate <> n.isourbankaccevaluate
        or o.externalevaluatevalue <> n.externalevaluatevalue
        or o.externalevaluatedate <> n.externalevaluatedate
        or o.externalevaluateexpiredate <> n.externalevaluateexpiredate
        or o.remark <> n.remark
        or o.registcountry <> n.registcountry
        or o.registcountryresult <> n.registcountryresult
        or o.outratingdate <> n.outratingdate
        or o.outratingresult <> n.outratingresult
        or o.inratingdate <> n.inratingdate
        or o.inratingresult <> n.inratingresult
        or o.guarcash <> n.guarcash
        or o.isstage <> n.isstage
        or o.insuranceno <> n.insuranceno
        or o.purpose <> n.purpose
        or o.independence <> n.independence
        or o.isresident <> n.isresident
        or o.netassetcurrency <> n.netassetcurrency
        or o.orgname <> n.orgname
        or o.orgtype <> n.orgtype
        or o.iscancel <> n.iscancel
        or o.vouchertype <> n.vouchertype
        or o.netasset <> n.netasset
        or o.confirmcurrency <> n.confirmcurrency
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_guaranty_info_cl(
            guarantyid -- 押品编号
            ,rwisenoughvalue -- 现时是否足值(风险预警)
            ,ownertype -- 所属人客户类型
            ,contracttype -- 担保方式
            ,evaluatenetvalue -- 评估价值（元）
            ,guarantytype -- 押品类型
            ,floorarea -- 不动产建筑面积(平方米)
            ,rwlocation -- 地址/存放地点(风险预警)
            ,rwbuildbuyprice -- 建购价款(风险预警)
            ,evalorgname -- 评估机构
            ,ownerid -- 权利人客户编号
            ,realestatecode -- 不动产证号
            ,guarantystatus -- 担保状态
            ,updateorgid -- 更新机构
            ,rwpledgerate -- 现时抵质押率(风险预警)
            ,guarantyname -- 押品名称
            ,lettertype -- 保函类型
            ,lettercontry -- 证书开具国别
            ,evaldate -- 估值日期
            ,ypguarantyid -- 押品系统的编号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,letterno -- 保函编号
            ,certid -- 所属人证件号码
            ,confirmvalue -- 我行确认价值
            ,inputuserid -- 登记人
            ,lettersum -- 保函金额
            ,guarantyrightid -- 权证号码
            ,inputdate -- 登记日期
            ,guarantyrighttype -- 权证类型
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,issueorgtype -- 担保机构类型
            ,ownername -- 权属人名称
            ,certtype -- 所属人证件类型
            ,guaranteetype -- 保证担保形式
            ,lettercurrency -- 保函币种
            ,inputorgid -- 登记机构
            ,rwpracticalvalue -- 现时实际价值(风险预警)
            ,guarantylocation -- 抵押物地址
            ,aboutotherid1 -- 母账号
            ,aboutotherid2 -- 
            ,aboutotherid3 -- 
            ,financialyield -- 
            ,collateraltype -- 
            ,stockcode -- 
            ,stockname -- 
            ,shareamount -- 
            ,persharemarketprice -- 
            ,totalvalue -- 
            ,warningline -- 
            ,liquidateline -- 
            ,evalexpiredate -- 
            ,registerno -- 
            ,statuschangetime -- 
            ,isnewshilianassessvalue -- 
            ,newshilianassessvalue -- 
            ,newshilianassessdate -- 
            ,isshilianaccevaluate -- 
            ,isourbankaccevaluate -- 
            ,externalevaluatevalue -- 
            ,externalevaluatedate -- 
            ,externalevaluateexpiredate -- 
            ,remark -- 备注
            ,registcountry -- 保证人注册地所在国家或地区
            ,registcountryresult -- 保证人注册地所在国家或地区外部评级结果
            ,outratingdate -- 保证人外部评级日期
            ,outratingresult -- 保证人外部评级结果
            ,inratingdate -- 保证人内部评级日期
            ,inratingresult -- 保证人内部评级结果
            ,guarcash -- 担保公司保证金金额
            ,isstage -- 是否阶段性担保
            ,insuranceno -- 保证保险保单号码
            ,purpose -- 保证目的
            ,independence -- 保证人担保独立性
            ,isresident -- 是否居民
            ,netassetcurrency -- 净资产币种
            ,orgname -- 开立机构名称（保函）\开证机构名称（信用证）
            ,orgtype -- 开立机构类型（保函）\开证机构类型（信用证）
            ,iscancel -- 是否不可撤销
            ,vouchertype -- 保证人所有制类型
            ,netasset -- 保证人净资产
            ,confirmcurrency -- 担保币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_guaranty_info_op(
            guarantyid -- 押品编号
            ,rwisenoughvalue -- 现时是否足值(风险预警)
            ,ownertype -- 所属人客户类型
            ,contracttype -- 担保方式
            ,evaluatenetvalue -- 评估价值（元）
            ,guarantytype -- 押品类型
            ,floorarea -- 不动产建筑面积(平方米)
            ,rwlocation -- 地址/存放地点(风险预警)
            ,rwbuildbuyprice -- 建购价款(风险预警)
            ,evalorgname -- 评估机构
            ,ownerid -- 权利人客户编号
            ,realestatecode -- 不动产证号
            ,guarantystatus -- 担保状态
            ,updateorgid -- 更新机构
            ,rwpledgerate -- 现时抵质押率(风险预警)
            ,guarantyname -- 押品名称
            ,lettertype -- 保函类型
            ,lettercontry -- 证书开具国别
            ,evaldate -- 估值日期
            ,ypguarantyid -- 押品系统的编号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,letterno -- 保函编号
            ,certid -- 所属人证件号码
            ,confirmvalue -- 我行确认价值
            ,inputuserid -- 登记人
            ,lettersum -- 保函金额
            ,guarantyrightid -- 权证号码
            ,inputdate -- 登记日期
            ,guarantyrighttype -- 权证类型
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,issueorgtype -- 担保机构类型
            ,ownername -- 权属人名称
            ,certtype -- 所属人证件类型
            ,guaranteetype -- 保证担保形式
            ,lettercurrency -- 保函币种
            ,inputorgid -- 登记机构
            ,rwpracticalvalue -- 现时实际价值(风险预警)
            ,guarantylocation -- 抵押物地址
            ,aboutotherid1 -- 母账号
            ,aboutotherid2 -- 
            ,aboutotherid3 -- 
            ,financialyield -- 
            ,collateraltype -- 
            ,stockcode -- 
            ,stockname -- 
            ,shareamount -- 
            ,persharemarketprice -- 
            ,totalvalue -- 
            ,warningline -- 
            ,liquidateline -- 
            ,evalexpiredate -- 
            ,registerno -- 
            ,statuschangetime -- 
            ,isnewshilianassessvalue -- 
            ,newshilianassessvalue -- 
            ,newshilianassessdate -- 
            ,isshilianaccevaluate -- 
            ,isourbankaccevaluate -- 
            ,externalevaluatevalue -- 
            ,externalevaluatedate -- 
            ,externalevaluateexpiredate -- 
            ,remark -- 备注
            ,registcountry -- 保证人注册地所在国家或地区
            ,registcountryresult -- 保证人注册地所在国家或地区外部评级结果
            ,outratingdate -- 保证人外部评级日期
            ,outratingresult -- 保证人外部评级结果
            ,inratingdate -- 保证人内部评级日期
            ,inratingresult -- 保证人内部评级结果
            ,guarcash -- 担保公司保证金金额
            ,isstage -- 是否阶段性担保
            ,insuranceno -- 保证保险保单号码
            ,purpose -- 保证目的
            ,independence -- 保证人担保独立性
            ,isresident -- 是否居民
            ,netassetcurrency -- 净资产币种
            ,orgname -- 开立机构名称（保函）\开证机构名称（信用证）
            ,orgtype -- 开立机构类型（保函）\开证机构类型（信用证）
            ,iscancel -- 是否不可撤销
            ,vouchertype -- 保证人所有制类型
            ,netasset -- 保证人净资产
            ,confirmcurrency -- 担保币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.guarantyid -- 押品编号
    ,o.rwisenoughvalue -- 现时是否足值(风险预警)
    ,o.ownertype -- 所属人客户类型
    ,o.contracttype -- 担保方式
    ,o.evaluatenetvalue -- 评估价值（元）
    ,o.guarantytype -- 押品类型
    ,o.floorarea -- 不动产建筑面积(平方米)
    ,o.rwlocation -- 地址/存放地点(风险预警)
    ,o.rwbuildbuyprice -- 建购价款(风险预警)
    ,o.evalorgname -- 评估机构
    ,o.ownerid -- 权利人客户编号
    ,o.realestatecode -- 不动产证号
    ,o.guarantystatus -- 担保状态
    ,o.updateorgid -- 更新机构
    ,o.rwpledgerate -- 现时抵质押率(风险预警)
    ,o.guarantyname -- 押品名称
    ,o.lettertype -- 保函类型
    ,o.lettercontry -- 证书开具国别
    ,o.evaldate -- 估值日期
    ,o.ypguarantyid -- 押品系统的编号
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.letterno -- 保函编号
    ,o.certid -- 所属人证件号码
    ,o.confirmvalue -- 我行确认价值
    ,o.inputuserid -- 登记人
    ,o.lettersum -- 保函金额
    ,o.guarantyrightid -- 权证号码
    ,o.inputdate -- 登记日期
    ,o.guarantyrighttype -- 权证类型
    ,o.updatedate -- 更新日期
    ,o.updateuserid -- 更新人
    ,o.issueorgtype -- 担保机构类型
    ,o.ownername -- 权属人名称
    ,o.certtype -- 所属人证件类型
    ,o.guaranteetype -- 保证担保形式
    ,o.lettercurrency -- 保函币种
    ,o.inputorgid -- 登记机构
    ,o.rwpracticalvalue -- 现时实际价值(风险预警)
    ,o.guarantylocation -- 抵押物地址
    ,o.aboutotherid1 -- 母账号
    ,o.aboutotherid2 -- 
    ,o.aboutotherid3 -- 
    ,o.financialyield -- 
    ,o.collateraltype -- 
    ,o.stockcode -- 
    ,o.stockname -- 
    ,o.shareamount -- 
    ,o.persharemarketprice -- 
    ,o.totalvalue -- 
    ,o.warningline -- 
    ,o.liquidateline -- 
    ,o.evalexpiredate -- 
    ,o.registerno -- 
    ,o.statuschangetime -- 
    ,o.isnewshilianassessvalue -- 
    ,o.newshilianassessvalue -- 
    ,o.newshilianassessdate -- 
    ,o.isshilianaccevaluate -- 
    ,o.isourbankaccevaluate -- 
    ,o.externalevaluatevalue -- 
    ,o.externalevaluatedate -- 
    ,o.externalevaluateexpiredate -- 
    ,o.remark -- 备注
    ,o.registcountry -- 保证人注册地所在国家或地区
    ,o.registcountryresult -- 保证人注册地所在国家或地区外部评级结果
    ,o.outratingdate -- 保证人外部评级日期
    ,o.outratingresult -- 保证人外部评级结果
    ,o.inratingdate -- 保证人内部评级日期
    ,o.inratingresult -- 保证人内部评级结果
    ,o.guarcash -- 担保公司保证金金额
    ,o.isstage -- 是否阶段性担保
    ,o.insuranceno -- 保证保险保单号码
    ,o.purpose -- 保证目的
    ,o.independence -- 保证人担保独立性
    ,o.isresident -- 是否居民
    ,o.netassetcurrency -- 净资产币种
    ,o.orgname -- 开立机构名称（保函）\开证机构名称（信用证）
    ,o.orgtype -- 开立机构类型（保函）\开证机构类型（信用证）
    ,o.iscancel -- 是否不可撤销
    ,o.vouchertype -- 保证人所有制类型
    ,o.netasset -- 保证人净资产
    ,o.confirmcurrency -- 担保币种
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_guaranty_info_bk o
    left join ${iol_schema}.icms_guaranty_info_op n
        on
            o.guarantyid = n.guarantyid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_guaranty_info_cl d
        on
            o.guarantyid = d.guarantyid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_guaranty_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_guaranty_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_guaranty_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_guaranty_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_guaranty_info exchange partition p_${batch_date} with table ${iol_schema}.icms_guaranty_info_cl;
alter table ${iol_schema}.icms_guaranty_info exchange partition p_20991231 with table ${iol_schema}.icms_guaranty_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_guaranty_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_guaranty_info_op purge;
drop table ${iol_schema}.icms_guaranty_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_guaranty_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_guaranty_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
