/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_group_info
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
create table ${iol_schema}.icms_group_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_group_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_group_info_op purge;
drop table ${iol_schema}.icms_group_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_group_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_group_info where 0=1;

create table ${iol_schema}.icms_group_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_group_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_group_info_cl(
            groupid -- 客户编号
            ,businessscope -- 经营范围(文本描述)
            ,mgtorgid -- 主办机构
            ,currentversionseq -- 当前正在使用的家谱版本号
            ,countrycode -- 所在国家(地区)
            ,firstloandate -- 首贷日期
            ,groupmembercount -- 集群成员数量
            ,registerregioncode -- 登记地行政区划代码
            ,creditlevel -- 内部信用评级级别
            ,groupcredittype -- 集团类型
            ,customertype -- 客户类型
            ,newregioncode -- 行政区域（风险预警）
            ,industrytypeproportion -- 第一大主营业务占比
            ,city -- 省直辖市/县
            ,officeaddupdatedate -- 更新办公地址日期
            ,isretiveeconmics -- 是否经济依存
            ,groupname -- 集群名称
            ,familymapstatus -- 家谱版本状态
            ,approveorgid -- 复核机构
            ,isrelatedparty -- 是否我行关联方标志
            ,parentcompanyofficeadd -- 集团客户母公司国内办公地址
            ,industrytypeproportion2 -- 第三大主营业务占比
            ,corpidetitytype -- 征信报送企业身份标识类型
            ,refversionseq -- 当前正在维护的家谱版本号
            ,oldfinancefocus -- 过往财务集中情况
            ,oldheadofficemanage -- 过往总行集中管理情况
            ,industrytype -- 所属行业类型
            ,subjectbusiness -- 主营业务(文本描述)
            ,groupstatus -- 集群状态
            ,groupabbname -- 集团简称
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,groupcustomertype -- 集群客户类型
            ,oldgroupcredittype -- 过往集团类型
            ,industrytypeproportion1 -- 第二大主营业务占比
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,mgtuserid -- 主办客户经理
            ,inputorgid -- 登记单位
            ,inputuserid -- 登记人
            ,oldgroupabbname -- 集群曾用简称
            ,isrelativetrade -- 是否我行关联交易
            ,actualcontrollercounts -- 实际控制人个数
            ,remark -- 备注
            ,updateorgid -- 更新机构
            ,industrytype1 -- 第二大主营业务编号(行业代码)
            ,industrytype2 -- 第三大主营业务编号(行业代码)
            ,inputdate -- 登记日期
            ,financialgroupscope -- 规模(文本描述)
            ,financialgroupposition -- 行业地位(文本描述)
            ,grouptype -- 集群类型
            ,approvedate -- 复核日期
            ,oldgroupname -- 集团曾用名
            ,headofficemanage -- 总行集中管理
            ,approveuserid -- 复核人
            ,investmencounts -- 主要出资人个数
            ,keymembercustomerid -- 集团核心企业
            ,financefocus -- 财务是否集中
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,actualcontroller -- 实际控制人
            ,migtcustomerid -- 转换前客户号
            ,iscontroller -- 是否有实控人
            ,controllercerttype -- 实控人证件类型
            ,controllercertid -- 实控人证件号码
            ,controllernational -- 实控人国别
            ,groupnature -- 集团性质
            ,groupcreditcustomertype -- 集团客户类型
            ,groupstatusone -- 集团是否生效
            ,isflow -- 是否修改成员信息走流程：0否，1是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_group_info_op(
            groupid -- 客户编号
            ,businessscope -- 经营范围(文本描述)
            ,mgtorgid -- 主办机构
            ,currentversionseq -- 当前正在使用的家谱版本号
            ,countrycode -- 所在国家(地区)
            ,firstloandate -- 首贷日期
            ,groupmembercount -- 集群成员数量
            ,registerregioncode -- 登记地行政区划代码
            ,creditlevel -- 内部信用评级级别
            ,groupcredittype -- 集团类型
            ,customertype -- 客户类型
            ,newregioncode -- 行政区域（风险预警）
            ,industrytypeproportion -- 第一大主营业务占比
            ,city -- 省直辖市/县
            ,officeaddupdatedate -- 更新办公地址日期
            ,isretiveeconmics -- 是否经济依存
            ,groupname -- 集群名称
            ,familymapstatus -- 家谱版本状态
            ,approveorgid -- 复核机构
            ,isrelatedparty -- 是否我行关联方标志
            ,parentcompanyofficeadd -- 集团客户母公司国内办公地址
            ,industrytypeproportion2 -- 第三大主营业务占比
            ,corpidetitytype -- 征信报送企业身份标识类型
            ,refversionseq -- 当前正在维护的家谱版本号
            ,oldfinancefocus -- 过往财务集中情况
            ,oldheadofficemanage -- 过往总行集中管理情况
            ,industrytype -- 所属行业类型
            ,subjectbusiness -- 主营业务(文本描述)
            ,groupstatus -- 集群状态
            ,groupabbname -- 集团简称
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,groupcustomertype -- 集群客户类型
            ,oldgroupcredittype -- 过往集团类型
            ,industrytypeproportion1 -- 第二大主营业务占比
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,mgtuserid -- 主办客户经理
            ,inputorgid -- 登记单位
            ,inputuserid -- 登记人
            ,oldgroupabbname -- 集群曾用简称
            ,isrelativetrade -- 是否我行关联交易
            ,actualcontrollercounts -- 实际控制人个数
            ,remark -- 备注
            ,updateorgid -- 更新机构
            ,industrytype1 -- 第二大主营业务编号(行业代码)
            ,industrytype2 -- 第三大主营业务编号(行业代码)
            ,inputdate -- 登记日期
            ,financialgroupscope -- 规模(文本描述)
            ,financialgroupposition -- 行业地位(文本描述)
            ,grouptype -- 集群类型
            ,approvedate -- 复核日期
            ,oldgroupname -- 集团曾用名
            ,headofficemanage -- 总行集中管理
            ,approveuserid -- 复核人
            ,investmencounts -- 主要出资人个数
            ,keymembercustomerid -- 集团核心企业
            ,financefocus -- 财务是否集中
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,actualcontroller -- 实际控制人
            ,migtcustomerid -- 转换前客户号
            ,iscontroller -- 是否有实控人
            ,controllercerttype -- 实控人证件类型
            ,controllercertid -- 实控人证件号码
            ,controllernational -- 实控人国别
            ,groupnature -- 集团性质
            ,groupcreditcustomertype -- 集团客户类型
            ,groupstatusone -- 集团是否生效
            ,isflow -- 是否修改成员信息走流程：0否，1是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.groupid, o.groupid) as groupid -- 客户编号
    ,nvl(n.businessscope, o.businessscope) as businessscope -- 经营范围(文本描述)
    ,nvl(n.mgtorgid, o.mgtorgid) as mgtorgid -- 主办机构
    ,nvl(n.currentversionseq, o.currentversionseq) as currentversionseq -- 当前正在使用的家谱版本号
    ,nvl(n.countrycode, o.countrycode) as countrycode -- 所在国家(地区)
    ,nvl(n.firstloandate, o.firstloandate) as firstloandate -- 首贷日期
    ,nvl(n.groupmembercount, o.groupmembercount) as groupmembercount -- 集群成员数量
    ,nvl(n.registerregioncode, o.registerregioncode) as registerregioncode -- 登记地行政区划代码
    ,nvl(n.creditlevel, o.creditlevel) as creditlevel -- 内部信用评级级别
    ,nvl(n.groupcredittype, o.groupcredittype) as groupcredittype -- 集团类型
    ,nvl(n.customertype, o.customertype) as customertype -- 客户类型
    ,nvl(n.newregioncode, o.newregioncode) as newregioncode -- 行政区域（风险预警）
    ,nvl(n.industrytypeproportion, o.industrytypeproportion) as industrytypeproportion -- 第一大主营业务占比
    ,nvl(n.city, o.city) as city -- 省直辖市/县
    ,nvl(n.officeaddupdatedate, o.officeaddupdatedate) as officeaddupdatedate -- 更新办公地址日期
    ,nvl(n.isretiveeconmics, o.isretiveeconmics) as isretiveeconmics -- 是否经济依存
    ,nvl(n.groupname, o.groupname) as groupname -- 集群名称
    ,nvl(n.familymapstatus, o.familymapstatus) as familymapstatus -- 家谱版本状态
    ,nvl(n.approveorgid, o.approveorgid) as approveorgid -- 复核机构
    ,nvl(n.isrelatedparty, o.isrelatedparty) as isrelatedparty -- 是否我行关联方标志
    ,nvl(n.parentcompanyofficeadd, o.parentcompanyofficeadd) as parentcompanyofficeadd -- 集团客户母公司国内办公地址
    ,nvl(n.industrytypeproportion2, o.industrytypeproportion2) as industrytypeproportion2 -- 第三大主营业务占比
    ,nvl(n.corpidetitytype, o.corpidetitytype) as corpidetitytype -- 征信报送企业身份标识类型
    ,nvl(n.refversionseq, o.refversionseq) as refversionseq -- 当前正在维护的家谱版本号
    ,nvl(n.oldfinancefocus, o.oldfinancefocus) as oldfinancefocus -- 过往财务集中情况
    ,nvl(n.oldheadofficemanage, o.oldheadofficemanage) as oldheadofficemanage -- 过往总行集中管理情况
    ,nvl(n.industrytype, o.industrytype) as industrytype -- 所属行业类型
    ,nvl(n.subjectbusiness, o.subjectbusiness) as subjectbusiness -- 主营业务(文本描述)
    ,nvl(n.groupstatus, o.groupstatus) as groupstatus -- 集群状态
    ,nvl(n.groupabbname, o.groupabbname) as groupabbname -- 集团简称
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.groupcustomertype, o.groupcustomertype) as groupcustomertype -- 集群客户类型
    ,nvl(n.oldgroupcredittype, o.oldgroupcredittype) as oldgroupcredittype -- 过往集团类型
    ,nvl(n.industrytypeproportion1, o.industrytypeproportion1) as industrytypeproportion1 -- 第二大主营业务占比
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.mgtuserid, o.mgtuserid) as mgtuserid -- 主办客户经理
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记单位
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.oldgroupabbname, o.oldgroupabbname) as oldgroupabbname -- 集群曾用简称
    ,nvl(n.isrelativetrade, o.isrelativetrade) as isrelativetrade -- 是否我行关联交易
    ,nvl(n.actualcontrollercounts, o.actualcontrollercounts) as actualcontrollercounts -- 实际控制人个数
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.industrytype1, o.industrytype1) as industrytype1 -- 第二大主营业务编号(行业代码)
    ,nvl(n.industrytype2, o.industrytype2) as industrytype2 -- 第三大主营业务编号(行业代码)
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.financialgroupscope, o.financialgroupscope) as financialgroupscope -- 规模(文本描述)
    ,nvl(n.financialgroupposition, o.financialgroupposition) as financialgroupposition -- 行业地位(文本描述)
    ,nvl(n.grouptype, o.grouptype) as grouptype -- 集群类型
    ,nvl(n.approvedate, o.approvedate) as approvedate -- 复核日期
    ,nvl(n.oldgroupname, o.oldgroupname) as oldgroupname -- 集团曾用名
    ,nvl(n.headofficemanage, o.headofficemanage) as headofficemanage -- 总行集中管理
    ,nvl(n.approveuserid, o.approveuserid) as approveuserid -- 复核人
    ,nvl(n.investmencounts, o.investmencounts) as investmencounts -- 主要出资人个数
    ,nvl(n.keymembercustomerid, o.keymembercustomerid) as keymembercustomerid -- 集团核心企业
    ,nvl(n.financefocus, o.financefocus) as financefocus -- 财务是否集中
    ,nvl(n.migtoldvalue, o.migtoldvalue) as migtoldvalue -- 迁移数据-参数转换前字段值
    ,nvl(n.actualcontroller, o.actualcontroller) as actualcontroller -- 实际控制人
    ,nvl(n.migtcustomerid, o.migtcustomerid) as migtcustomerid -- 转换前客户号
    ,nvl(n.iscontroller, o.iscontroller) as iscontroller -- 是否有实控人
    ,nvl(n.controllercerttype, o.controllercerttype) as controllercerttype -- 实控人证件类型
    ,nvl(n.controllercertid, o.controllercertid) as controllercertid -- 实控人证件号码
    ,nvl(n.controllernational, o.controllernational) as controllernational -- 实控人国别
    ,nvl(n.groupnature, o.groupnature) as groupnature -- 集团性质
    ,nvl(n.groupcreditcustomertype, o.groupcreditcustomertype) as groupcreditcustomertype -- 集团客户类型
    ,nvl(n.groupstatusone, o.groupstatusone) as groupstatusone -- 集团是否生效
    ,nvl(n.isflow, o.isflow) as isflow -- 是否修改成员信息走流程：0否，1是
    ,case when
            n.groupid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.groupid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.groupid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_group_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_group_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.groupid = n.groupid
where (
        o.groupid is null
    )
    or (
        n.groupid is null
    )
    or (
        o.businessscope <> n.businessscope
        or o.mgtorgid <> n.mgtorgid
        or o.currentversionseq <> n.currentversionseq
        or o.countrycode <> n.countrycode
        or o.firstloandate <> n.firstloandate
        or o.groupmembercount <> n.groupmembercount
        or o.registerregioncode <> n.registerregioncode
        or o.creditlevel <> n.creditlevel
        or o.groupcredittype <> n.groupcredittype
        or o.customertype <> n.customertype
        or o.newregioncode <> n.newregioncode
        or o.industrytypeproportion <> n.industrytypeproportion
        or o.city <> n.city
        or o.officeaddupdatedate <> n.officeaddupdatedate
        or o.isretiveeconmics <> n.isretiveeconmics
        or o.groupname <> n.groupname
        or o.familymapstatus <> n.familymapstatus
        or o.approveorgid <> n.approveorgid
        or o.isrelatedparty <> n.isrelatedparty
        or o.parentcompanyofficeadd <> n.parentcompanyofficeadd
        or o.industrytypeproportion2 <> n.industrytypeproportion2
        or o.corpidetitytype <> n.corpidetitytype
        or o.refversionseq <> n.refversionseq
        or o.oldfinancefocus <> n.oldfinancefocus
        or o.oldheadofficemanage <> n.oldheadofficemanage
        or o.industrytype <> n.industrytype
        or o.subjectbusiness <> n.subjectbusiness
        or o.groupstatus <> n.groupstatus
        or o.groupabbname <> n.groupabbname
        or o.updateuserid <> n.updateuserid
        or o.updatedate <> n.updatedate
        or o.corporgid <> n.corporgid
        or o.groupcustomertype <> n.groupcustomertype
        or o.oldgroupcredittype <> n.oldgroupcredittype
        or o.industrytypeproportion1 <> n.industrytypeproportion1
        or o.migtflag <> n.migtflag
        or o.mgtuserid <> n.mgtuserid
        or o.inputorgid <> n.inputorgid
        or o.inputuserid <> n.inputuserid
        or o.oldgroupabbname <> n.oldgroupabbname
        or o.isrelativetrade <> n.isrelativetrade
        or o.actualcontrollercounts <> n.actualcontrollercounts
        or o.remark <> n.remark
        or o.updateorgid <> n.updateorgid
        or o.industrytype1 <> n.industrytype1
        or o.industrytype2 <> n.industrytype2
        or o.inputdate <> n.inputdate
        or o.financialgroupscope <> n.financialgroupscope
        or o.financialgroupposition <> n.financialgroupposition
        or o.grouptype <> n.grouptype
        or o.approvedate <> n.approvedate
        or o.oldgroupname <> n.oldgroupname
        or o.headofficemanage <> n.headofficemanage
        or o.approveuserid <> n.approveuserid
        or o.investmencounts <> n.investmencounts
        or o.keymembercustomerid <> n.keymembercustomerid
        or o.financefocus <> n.financefocus
        or o.migtoldvalue <> n.migtoldvalue
        or o.actualcontroller <> n.actualcontroller
        or o.migtcustomerid <> n.migtcustomerid
        or o.iscontroller <> n.iscontroller
        or o.controllercerttype <> n.controllercerttype
        or o.controllercertid <> n.controllercertid
        or o.controllernational <> n.controllernational
        or o.groupnature <> n.groupnature
        or o.groupcreditcustomertype <> n.groupcreditcustomertype
        or o.groupstatusone <> n.groupstatusone
        or o.isflow <> n.isflow
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_group_info_cl(
            groupid -- 客户编号
            ,businessscope -- 经营范围(文本描述)
            ,mgtorgid -- 主办机构
            ,currentversionseq -- 当前正在使用的家谱版本号
            ,countrycode -- 所在国家(地区)
            ,firstloandate -- 首贷日期
            ,groupmembercount -- 集群成员数量
            ,registerregioncode -- 登记地行政区划代码
            ,creditlevel -- 内部信用评级级别
            ,groupcredittype -- 集团类型
            ,customertype -- 客户类型
            ,newregioncode -- 行政区域（风险预警）
            ,industrytypeproportion -- 第一大主营业务占比
            ,city -- 省直辖市/县
            ,officeaddupdatedate -- 更新办公地址日期
            ,isretiveeconmics -- 是否经济依存
            ,groupname -- 集群名称
            ,familymapstatus -- 家谱版本状态
            ,approveorgid -- 复核机构
            ,isrelatedparty -- 是否我行关联方标志
            ,parentcompanyofficeadd -- 集团客户母公司国内办公地址
            ,industrytypeproportion2 -- 第三大主营业务占比
            ,corpidetitytype -- 征信报送企业身份标识类型
            ,refversionseq -- 当前正在维护的家谱版本号
            ,oldfinancefocus -- 过往财务集中情况
            ,oldheadofficemanage -- 过往总行集中管理情况
            ,industrytype -- 所属行业类型
            ,subjectbusiness -- 主营业务(文本描述)
            ,groupstatus -- 集群状态
            ,groupabbname -- 集团简称
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,groupcustomertype -- 集群客户类型
            ,oldgroupcredittype -- 过往集团类型
            ,industrytypeproportion1 -- 第二大主营业务占比
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,mgtuserid -- 主办客户经理
            ,inputorgid -- 登记单位
            ,inputuserid -- 登记人
            ,oldgroupabbname -- 集群曾用简称
            ,isrelativetrade -- 是否我行关联交易
            ,actualcontrollercounts -- 实际控制人个数
            ,remark -- 备注
            ,updateorgid -- 更新机构
            ,industrytype1 -- 第二大主营业务编号(行业代码)
            ,industrytype2 -- 第三大主营业务编号(行业代码)
            ,inputdate -- 登记日期
            ,financialgroupscope -- 规模(文本描述)
            ,financialgroupposition -- 行业地位(文本描述)
            ,grouptype -- 集群类型
            ,approvedate -- 复核日期
            ,oldgroupname -- 集团曾用名
            ,headofficemanage -- 总行集中管理
            ,approveuserid -- 复核人
            ,investmencounts -- 主要出资人个数
            ,keymembercustomerid -- 集团核心企业
            ,financefocus -- 财务是否集中
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,actualcontroller -- 实际控制人
            ,migtcustomerid -- 转换前客户号
            ,iscontroller -- 是否有实控人
            ,controllercerttype -- 实控人证件类型
            ,controllercertid -- 实控人证件号码
            ,controllernational -- 实控人国别
            ,groupnature -- 集团性质
            ,groupcreditcustomertype -- 集团客户类型
            ,groupstatusone -- 集团是否生效
            ,isflow -- 是否修改成员信息走流程：0否，1是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_group_info_op(
            groupid -- 客户编号
            ,businessscope -- 经营范围(文本描述)
            ,mgtorgid -- 主办机构
            ,currentversionseq -- 当前正在使用的家谱版本号
            ,countrycode -- 所在国家(地区)
            ,firstloandate -- 首贷日期
            ,groupmembercount -- 集群成员数量
            ,registerregioncode -- 登记地行政区划代码
            ,creditlevel -- 内部信用评级级别
            ,groupcredittype -- 集团类型
            ,customertype -- 客户类型
            ,newregioncode -- 行政区域（风险预警）
            ,industrytypeproportion -- 第一大主营业务占比
            ,city -- 省直辖市/县
            ,officeaddupdatedate -- 更新办公地址日期
            ,isretiveeconmics -- 是否经济依存
            ,groupname -- 集群名称
            ,familymapstatus -- 家谱版本状态
            ,approveorgid -- 复核机构
            ,isrelatedparty -- 是否我行关联方标志
            ,parentcompanyofficeadd -- 集团客户母公司国内办公地址
            ,industrytypeproportion2 -- 第三大主营业务占比
            ,corpidetitytype -- 征信报送企业身份标识类型
            ,refversionseq -- 当前正在维护的家谱版本号
            ,oldfinancefocus -- 过往财务集中情况
            ,oldheadofficemanage -- 过往总行集中管理情况
            ,industrytype -- 所属行业类型
            ,subjectbusiness -- 主营业务(文本描述)
            ,groupstatus -- 集群状态
            ,groupabbname -- 集团简称
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,groupcustomertype -- 集群客户类型
            ,oldgroupcredittype -- 过往集团类型
            ,industrytypeproportion1 -- 第二大主营业务占比
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,mgtuserid -- 主办客户经理
            ,inputorgid -- 登记单位
            ,inputuserid -- 登记人
            ,oldgroupabbname -- 集群曾用简称
            ,isrelativetrade -- 是否我行关联交易
            ,actualcontrollercounts -- 实际控制人个数
            ,remark -- 备注
            ,updateorgid -- 更新机构
            ,industrytype1 -- 第二大主营业务编号(行业代码)
            ,industrytype2 -- 第三大主营业务编号(行业代码)
            ,inputdate -- 登记日期
            ,financialgroupscope -- 规模(文本描述)
            ,financialgroupposition -- 行业地位(文本描述)
            ,grouptype -- 集群类型
            ,approvedate -- 复核日期
            ,oldgroupname -- 集团曾用名
            ,headofficemanage -- 总行集中管理
            ,approveuserid -- 复核人
            ,investmencounts -- 主要出资人个数
            ,keymembercustomerid -- 集团核心企业
            ,financefocus -- 财务是否集中
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,actualcontroller -- 实际控制人
            ,migtcustomerid -- 转换前客户号
            ,iscontroller -- 是否有实控人
            ,controllercerttype -- 实控人证件类型
            ,controllercertid -- 实控人证件号码
            ,controllernational -- 实控人国别
            ,groupnature -- 集团性质
            ,groupcreditcustomertype -- 集团客户类型
            ,groupstatusone -- 集团是否生效
            ,isflow -- 是否修改成员信息走流程：0否，1是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.groupid -- 客户编号
    ,o.businessscope -- 经营范围(文本描述)
    ,o.mgtorgid -- 主办机构
    ,o.currentversionseq -- 当前正在使用的家谱版本号
    ,o.countrycode -- 所在国家(地区)
    ,o.firstloandate -- 首贷日期
    ,o.groupmembercount -- 集群成员数量
    ,o.registerregioncode -- 登记地行政区划代码
    ,o.creditlevel -- 内部信用评级级别
    ,o.groupcredittype -- 集团类型
    ,o.customertype -- 客户类型
    ,o.newregioncode -- 行政区域（风险预警）
    ,o.industrytypeproportion -- 第一大主营业务占比
    ,o.city -- 省直辖市/县
    ,o.officeaddupdatedate -- 更新办公地址日期
    ,o.isretiveeconmics -- 是否经济依存
    ,o.groupname -- 集群名称
    ,o.familymapstatus -- 家谱版本状态
    ,o.approveorgid -- 复核机构
    ,o.isrelatedparty -- 是否我行关联方标志
    ,o.parentcompanyofficeadd -- 集团客户母公司国内办公地址
    ,o.industrytypeproportion2 -- 第三大主营业务占比
    ,o.corpidetitytype -- 征信报送企业身份标识类型
    ,o.refversionseq -- 当前正在维护的家谱版本号
    ,o.oldfinancefocus -- 过往财务集中情况
    ,o.oldheadofficemanage -- 过往总行集中管理情况
    ,o.industrytype -- 所属行业类型
    ,o.subjectbusiness -- 主营业务(文本描述)
    ,o.groupstatus -- 集群状态
    ,o.groupabbname -- 集团简称
    ,o.updateuserid -- 更新人
    ,o.updatedate -- 更新日期
    ,o.corporgid -- 法人机构编号
    ,o.groupcustomertype -- 集群客户类型
    ,o.oldgroupcredittype -- 过往集团类型
    ,o.industrytypeproportion1 -- 第二大主营业务占比
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.mgtuserid -- 主办客户经理
    ,o.inputorgid -- 登记单位
    ,o.inputuserid -- 登记人
    ,o.oldgroupabbname -- 集群曾用简称
    ,o.isrelativetrade -- 是否我行关联交易
    ,o.actualcontrollercounts -- 实际控制人个数
    ,o.remark -- 备注
    ,o.updateorgid -- 更新机构
    ,o.industrytype1 -- 第二大主营业务编号(行业代码)
    ,o.industrytype2 -- 第三大主营业务编号(行业代码)
    ,o.inputdate -- 登记日期
    ,o.financialgroupscope -- 规模(文本描述)
    ,o.financialgroupposition -- 行业地位(文本描述)
    ,o.grouptype -- 集群类型
    ,o.approvedate -- 复核日期
    ,o.oldgroupname -- 集团曾用名
    ,o.headofficemanage -- 总行集中管理
    ,o.approveuserid -- 复核人
    ,o.investmencounts -- 主要出资人个数
    ,o.keymembercustomerid -- 集团核心企业
    ,o.financefocus -- 财务是否集中
    ,o.migtoldvalue -- 迁移数据-参数转换前字段值
    ,o.actualcontroller -- 实际控制人
    ,o.migtcustomerid -- 转换前客户号
    ,o.iscontroller -- 是否有实控人
    ,o.controllercerttype -- 实控人证件类型
    ,o.controllercertid -- 实控人证件号码
    ,o.controllernational -- 实控人国别
    ,o.groupnature -- 集团性质
    ,o.groupcreditcustomertype -- 集团客户类型
    ,o.groupstatusone -- 集团是否生效
    ,o.isflow -- 是否修改成员信息走流程：0否，1是
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
from ${iol_schema}.icms_group_info_bk o
    left join ${iol_schema}.icms_group_info_op n
        on
            o.groupid = n.groupid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_group_info_cl d
        on
            o.groupid = d.groupid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_group_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_group_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_group_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_group_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_group_info exchange partition p_${batch_date} with table ${iol_schema}.icms_group_info_cl;
alter table ${iol_schema}.icms_group_info exchange partition p_20991231 with table ${iol_schema}.icms_group_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_group_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_group_info_op purge;
drop table ${iol_schema}.icms_group_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_group_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_group_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
