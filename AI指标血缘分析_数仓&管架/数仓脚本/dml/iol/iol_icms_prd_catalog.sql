/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_prd_catalog
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
create table ${iol_schema}.icms_prd_catalog_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_prd_catalog
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_prd_catalog_op purge;
drop table ${iol_schema}.icms_prd_catalog_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_catalog_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_prd_catalog where 0=1;

create table ${iol_schema}.icms_prd_catalog_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_prd_catalog where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_prd_catalog_cl(
            productid -- 产品编号
            ,expirydate -- 产品失效日期
            ,indpostloancheckrate -- 个人客户贷后检查抽取比例
            ,parentproductid -- 父目录
            ,productclassify -- 新增产品类型
            ,permitpackage -- 是否允许打包
            ,occupylimitdesc -- 额度占用说明
            ,publiclimit -- 是否公开额度
            ,multiloan -- 是否允许多次放款
            ,updatedate -- 更新日期
            ,exflusiveflag -- 是否专属产品
            ,uniquesuitscope -- 唯一性适用范围
            ,iscapitalpurposecheck -- 是否进行资金用途检查
            ,packageproduct -- 打包业务品种
            ,businessflag -- 是否额度类产品
            ,productstatus -- 产品状态
            ,updateorgid -- 更新机构
            ,belongdept -- 隶属管理部门
            ,multiputout -- 是否允许多次出账
            ,purposechecktopdays -- 资金用途检查天数上限
            ,purposecheckbottomdays -- 资金用途检查天数下限
            ,corporgid -- 法人机构编号
            ,occupylimit -- 是否会占用额度(自用/他用/同业)
            ,earlyrepayment -- 是否允许提前还款
            ,offsheetflag -- 表内外属性
            ,suitcurrency -- 可用币种
            ,inputorgid -- 登记机构
            ,uniquelimit -- 额度是否唯一
            ,suitroles -- 适用角色
            ,belongproductid -- 所属产品编号
            ,baseproduct -- 期限值(月)
            ,productname -- 产品名称
            ,underproduct -- 额度适用产品
            ,limitrelaprotocal -- 额度是否关联协议
            ,productdesc -- 产品描述
            ,basetermmodelno -- 基础条款模型编号
            ,relatermmodelno -- 关联条款模型编号
            ,effectivedate -- 产品生效日期
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,usabledept -- 产品发行机构编号
            ,producttype -- 产品类型
            ,limitperiod -- 额度管控阶段
            ,updateuserid -- 更新人
            ,assetthreetype -- 三分类标识
            ,occupytype -- 额度被占用方式
            ,rotative -- 循环贷款标志
            ,sortno -- 排序号
            ,norisk -- 是否无风险业务
            ,totalexposure -- 是否全敞口业务
            ,isleafnode -- 是否叶节点
            ,entcreditclassify -- 企业征信分类-CreditType
            ,saveflag -- 保存标识
            ,queryparam -- 额度查询参数
            ,isgrouplimit -- 
            ,iscallimit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_prd_catalog_op(
            productid -- 产品编号
            ,expirydate -- 产品失效日期
            ,indpostloancheckrate -- 个人客户贷后检查抽取比例
            ,parentproductid -- 父目录
            ,productclassify -- 新增产品类型
            ,permitpackage -- 是否允许打包
            ,occupylimitdesc -- 额度占用说明
            ,publiclimit -- 是否公开额度
            ,multiloan -- 是否允许多次放款
            ,updatedate -- 更新日期
            ,exflusiveflag -- 是否专属产品
            ,uniquesuitscope -- 唯一性适用范围
            ,iscapitalpurposecheck -- 是否进行资金用途检查
            ,packageproduct -- 打包业务品种
            ,businessflag -- 是否额度类产品
            ,productstatus -- 产品状态
            ,updateorgid -- 更新机构
            ,belongdept -- 隶属管理部门
            ,multiputout -- 是否允许多次出账
            ,purposechecktopdays -- 资金用途检查天数上限
            ,purposecheckbottomdays -- 资金用途检查天数下限
            ,corporgid -- 法人机构编号
            ,occupylimit -- 是否会占用额度(自用/他用/同业)
            ,earlyrepayment -- 是否允许提前还款
            ,offsheetflag -- 表内外属性
            ,suitcurrency -- 可用币种
            ,inputorgid -- 登记机构
            ,uniquelimit -- 额度是否唯一
            ,suitroles -- 适用角色
            ,belongproductid -- 所属产品编号
            ,baseproduct -- 期限值(月)
            ,productname -- 产品名称
            ,underproduct -- 额度适用产品
            ,limitrelaprotocal -- 额度是否关联协议
            ,productdesc -- 产品描述
            ,basetermmodelno -- 基础条款模型编号
            ,relatermmodelno -- 关联条款模型编号
            ,effectivedate -- 产品生效日期
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,usabledept -- 产品发行机构编号
            ,producttype -- 产品类型
            ,limitperiod -- 额度管控阶段
            ,updateuserid -- 更新人
            ,assetthreetype -- 三分类标识
            ,occupytype -- 额度被占用方式
            ,rotative -- 循环贷款标志
            ,sortno -- 排序号
            ,norisk -- 是否无风险业务
            ,totalexposure -- 是否全敞口业务
            ,isleafnode -- 是否叶节点
            ,entcreditclassify -- 企业征信分类-CreditType
            ,saveflag -- 保存标识
            ,queryparam -- 额度查询参数
            ,isgrouplimit -- 
            ,iscallimit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.expirydate, o.expirydate) as expirydate -- 产品失效日期
    ,nvl(n.indpostloancheckrate, o.indpostloancheckrate) as indpostloancheckrate -- 个人客户贷后检查抽取比例
    ,nvl(n.parentproductid, o.parentproductid) as parentproductid -- 父目录
    ,nvl(n.productclassify, o.productclassify) as productclassify -- 新增产品类型
    ,nvl(n.permitpackage, o.permitpackage) as permitpackage -- 是否允许打包
    ,nvl(n.occupylimitdesc, o.occupylimitdesc) as occupylimitdesc -- 额度占用说明
    ,nvl(n.publiclimit, o.publiclimit) as publiclimit -- 是否公开额度
    ,nvl(n.multiloan, o.multiloan) as multiloan -- 是否允许多次放款
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.exflusiveflag, o.exflusiveflag) as exflusiveflag -- 是否专属产品
    ,nvl(n.uniquesuitscope, o.uniquesuitscope) as uniquesuitscope -- 唯一性适用范围
    ,nvl(n.iscapitalpurposecheck, o.iscapitalpurposecheck) as iscapitalpurposecheck -- 是否进行资金用途检查
    ,nvl(n.packageproduct, o.packageproduct) as packageproduct -- 打包业务品种
    ,nvl(n.businessflag, o.businessflag) as businessflag -- 是否额度类产品
    ,nvl(n.productstatus, o.productstatus) as productstatus -- 产品状态
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.belongdept, o.belongdept) as belongdept -- 隶属管理部门
    ,nvl(n.multiputout, o.multiputout) as multiputout -- 是否允许多次出账
    ,nvl(n.purposechecktopdays, o.purposechecktopdays) as purposechecktopdays -- 资金用途检查天数上限
    ,nvl(n.purposecheckbottomdays, o.purposecheckbottomdays) as purposecheckbottomdays -- 资金用途检查天数下限
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.occupylimit, o.occupylimit) as occupylimit -- 是否会占用额度(自用/他用/同业)
    ,nvl(n.earlyrepayment, o.earlyrepayment) as earlyrepayment -- 是否允许提前还款
    ,nvl(n.offsheetflag, o.offsheetflag) as offsheetflag -- 表内外属性
    ,nvl(n.suitcurrency, o.suitcurrency) as suitcurrency -- 可用币种
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.uniquelimit, o.uniquelimit) as uniquelimit -- 额度是否唯一
    ,nvl(n.suitroles, o.suitroles) as suitroles -- 适用角色
    ,nvl(n.belongproductid, o.belongproductid) as belongproductid -- 所属产品编号
    ,nvl(n.baseproduct, o.baseproduct) as baseproduct -- 期限值(月)
    ,nvl(n.productname, o.productname) as productname -- 产品名称
    ,nvl(n.underproduct, o.underproduct) as underproduct -- 额度适用产品
    ,nvl(n.limitrelaprotocal, o.limitrelaprotocal) as limitrelaprotocal -- 额度是否关联协议
    ,nvl(n.productdesc, o.productdesc) as productdesc -- 产品描述
    ,nvl(n.basetermmodelno, o.basetermmodelno) as basetermmodelno -- 基础条款模型编号
    ,nvl(n.relatermmodelno, o.relatermmodelno) as relatermmodelno -- 关联条款模型编号
    ,nvl(n.effectivedate, o.effectivedate) as effectivedate -- 产品生效日期
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.usabledept, o.usabledept) as usabledept -- 产品发行机构编号
    ,nvl(n.producttype, o.producttype) as producttype -- 产品类型
    ,nvl(n.limitperiod, o.limitperiod) as limitperiod -- 额度管控阶段
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.assetthreetype, o.assetthreetype) as assetthreetype -- 三分类标识
    ,nvl(n.occupytype, o.occupytype) as occupytype -- 额度被占用方式
    ,nvl(n.rotative, o.rotative) as rotative -- 循环贷款标志
    ,nvl(n.sortno, o.sortno) as sortno -- 排序号
    ,nvl(n.norisk, o.norisk) as norisk -- 是否无风险业务
    ,nvl(n.totalexposure, o.totalexposure) as totalexposure -- 是否全敞口业务
    ,nvl(n.isleafnode, o.isleafnode) as isleafnode -- 是否叶节点
    ,nvl(n.entcreditclassify, o.entcreditclassify) as entcreditclassify -- 企业征信分类-CreditType
    ,nvl(n.saveflag, o.saveflag) as saveflag -- 保存标识
    ,nvl(n.queryparam, o.queryparam) as queryparam -- 额度查询参数
    ,nvl(n.isgrouplimit, o.isgrouplimit) as isgrouplimit -- 
    ,nvl(n.iscallimit, o.iscallimit) as iscallimit -- 
    ,case when
            n.productid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.productid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.productid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_prd_catalog_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_prd_catalog where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.productid = n.productid
where (
        o.productid is null
    )
    or (
        n.productid is null
    )
    or (
        o.expirydate <> n.expirydate
        or o.indpostloancheckrate <> n.indpostloancheckrate
        or o.parentproductid <> n.parentproductid
        or o.productclassify <> n.productclassify
        or o.permitpackage <> n.permitpackage
        or o.occupylimitdesc <> n.occupylimitdesc
        or o.publiclimit <> n.publiclimit
        or o.multiloan <> n.multiloan
        or o.updatedate <> n.updatedate
        or o.exflusiveflag <> n.exflusiveflag
        or o.uniquesuitscope <> n.uniquesuitscope
        or o.iscapitalpurposecheck <> n.iscapitalpurposecheck
        or o.packageproduct <> n.packageproduct
        or o.businessflag <> n.businessflag
        or o.productstatus <> n.productstatus
        or o.updateorgid <> n.updateorgid
        or o.belongdept <> n.belongdept
        or o.multiputout <> n.multiputout
        or o.purposechecktopdays <> n.purposechecktopdays
        or o.purposecheckbottomdays <> n.purposecheckbottomdays
        or o.corporgid <> n.corporgid
        or o.occupylimit <> n.occupylimit
        or o.earlyrepayment <> n.earlyrepayment
        or o.offsheetflag <> n.offsheetflag
        or o.suitcurrency <> n.suitcurrency
        or o.inputorgid <> n.inputorgid
        or o.uniquelimit <> n.uniquelimit
        or o.suitroles <> n.suitroles
        or o.belongproductid <> n.belongproductid
        or o.baseproduct <> n.baseproduct
        or o.productname <> n.productname
        or o.underproduct <> n.underproduct
        or o.limitrelaprotocal <> n.limitrelaprotocal
        or o.productdesc <> n.productdesc
        or o.basetermmodelno <> n.basetermmodelno
        or o.relatermmodelno <> n.relatermmodelno
        or o.effectivedate <> n.effectivedate
        or o.inputuserid <> n.inputuserid
        or o.inputdate <> n.inputdate
        or o.usabledept <> n.usabledept
        or o.producttype <> n.producttype
        or o.limitperiod <> n.limitperiod
        or o.updateuserid <> n.updateuserid
        or o.assetthreetype <> n.assetthreetype
        or o.occupytype <> n.occupytype
        or o.rotative <> n.rotative
        or o.sortno <> n.sortno
        or o.norisk <> n.norisk
        or o.totalexposure <> n.totalexposure
        or o.isleafnode <> n.isleafnode
        or o.entcreditclassify <> n.entcreditclassify
        or o.saveflag <> n.saveflag
        or o.queryparam <> n.queryparam
        or o.isgrouplimit <> n.isgrouplimit
        or o.iscallimit <> n.iscallimit
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_prd_catalog_cl(
            productid -- 产品编号
            ,expirydate -- 产品失效日期
            ,indpostloancheckrate -- 个人客户贷后检查抽取比例
            ,parentproductid -- 父目录
            ,productclassify -- 新增产品类型
            ,permitpackage -- 是否允许打包
            ,occupylimitdesc -- 额度占用说明
            ,publiclimit -- 是否公开额度
            ,multiloan -- 是否允许多次放款
            ,updatedate -- 更新日期
            ,exflusiveflag -- 是否专属产品
            ,uniquesuitscope -- 唯一性适用范围
            ,iscapitalpurposecheck -- 是否进行资金用途检查
            ,packageproduct -- 打包业务品种
            ,businessflag -- 是否额度类产品
            ,productstatus -- 产品状态
            ,updateorgid -- 更新机构
            ,belongdept -- 隶属管理部门
            ,multiputout -- 是否允许多次出账
            ,purposechecktopdays -- 资金用途检查天数上限
            ,purposecheckbottomdays -- 资金用途检查天数下限
            ,corporgid -- 法人机构编号
            ,occupylimit -- 是否会占用额度(自用/他用/同业)
            ,earlyrepayment -- 是否允许提前还款
            ,offsheetflag -- 表内外属性
            ,suitcurrency -- 可用币种
            ,inputorgid -- 登记机构
            ,uniquelimit -- 额度是否唯一
            ,suitroles -- 适用角色
            ,belongproductid -- 所属产品编号
            ,baseproduct -- 期限值(月)
            ,productname -- 产品名称
            ,underproduct -- 额度适用产品
            ,limitrelaprotocal -- 额度是否关联协议
            ,productdesc -- 产品描述
            ,basetermmodelno -- 基础条款模型编号
            ,relatermmodelno -- 关联条款模型编号
            ,effectivedate -- 产品生效日期
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,usabledept -- 产品发行机构编号
            ,producttype -- 产品类型
            ,limitperiod -- 额度管控阶段
            ,updateuserid -- 更新人
            ,assetthreetype -- 三分类标识
            ,occupytype -- 额度被占用方式
            ,rotative -- 循环贷款标志
            ,sortno -- 排序号
            ,norisk -- 是否无风险业务
            ,totalexposure -- 是否全敞口业务
            ,isleafnode -- 是否叶节点
            ,entcreditclassify -- 企业征信分类-CreditType
            ,saveflag -- 保存标识
            ,queryparam -- 额度查询参数
            ,isgrouplimit -- 
            ,iscallimit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_prd_catalog_op(
            productid -- 产品编号
            ,expirydate -- 产品失效日期
            ,indpostloancheckrate -- 个人客户贷后检查抽取比例
            ,parentproductid -- 父目录
            ,productclassify -- 新增产品类型
            ,permitpackage -- 是否允许打包
            ,occupylimitdesc -- 额度占用说明
            ,publiclimit -- 是否公开额度
            ,multiloan -- 是否允许多次放款
            ,updatedate -- 更新日期
            ,exflusiveflag -- 是否专属产品
            ,uniquesuitscope -- 唯一性适用范围
            ,iscapitalpurposecheck -- 是否进行资金用途检查
            ,packageproduct -- 打包业务品种
            ,businessflag -- 是否额度类产品
            ,productstatus -- 产品状态
            ,updateorgid -- 更新机构
            ,belongdept -- 隶属管理部门
            ,multiputout -- 是否允许多次出账
            ,purposechecktopdays -- 资金用途检查天数上限
            ,purposecheckbottomdays -- 资金用途检查天数下限
            ,corporgid -- 法人机构编号
            ,occupylimit -- 是否会占用额度(自用/他用/同业)
            ,earlyrepayment -- 是否允许提前还款
            ,offsheetflag -- 表内外属性
            ,suitcurrency -- 可用币种
            ,inputorgid -- 登记机构
            ,uniquelimit -- 额度是否唯一
            ,suitroles -- 适用角色
            ,belongproductid -- 所属产品编号
            ,baseproduct -- 期限值(月)
            ,productname -- 产品名称
            ,underproduct -- 额度适用产品
            ,limitrelaprotocal -- 额度是否关联协议
            ,productdesc -- 产品描述
            ,basetermmodelno -- 基础条款模型编号
            ,relatermmodelno -- 关联条款模型编号
            ,effectivedate -- 产品生效日期
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,usabledept -- 产品发行机构编号
            ,producttype -- 产品类型
            ,limitperiod -- 额度管控阶段
            ,updateuserid -- 更新人
            ,assetthreetype -- 三分类标识
            ,occupytype -- 额度被占用方式
            ,rotative -- 循环贷款标志
            ,sortno -- 排序号
            ,norisk -- 是否无风险业务
            ,totalexposure -- 是否全敞口业务
            ,isleafnode -- 是否叶节点
            ,entcreditclassify -- 企业征信分类-CreditType
            ,saveflag -- 保存标识
            ,queryparam -- 额度查询参数
            ,isgrouplimit -- 
            ,iscallimit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.productid -- 产品编号
    ,o.expirydate -- 产品失效日期
    ,o.indpostloancheckrate -- 个人客户贷后检查抽取比例
    ,o.parentproductid -- 父目录
    ,o.productclassify -- 新增产品类型
    ,o.permitpackage -- 是否允许打包
    ,o.occupylimitdesc -- 额度占用说明
    ,o.publiclimit -- 是否公开额度
    ,o.multiloan -- 是否允许多次放款
    ,o.updatedate -- 更新日期
    ,o.exflusiveflag -- 是否专属产品
    ,o.uniquesuitscope -- 唯一性适用范围
    ,o.iscapitalpurposecheck -- 是否进行资金用途检查
    ,o.packageproduct -- 打包业务品种
    ,o.businessflag -- 是否额度类产品
    ,o.productstatus -- 产品状态
    ,o.updateorgid -- 更新机构
    ,o.belongdept -- 隶属管理部门
    ,o.multiputout -- 是否允许多次出账
    ,o.purposechecktopdays -- 资金用途检查天数上限
    ,o.purposecheckbottomdays -- 资金用途检查天数下限
    ,o.corporgid -- 法人机构编号
    ,o.occupylimit -- 是否会占用额度(自用/他用/同业)
    ,o.earlyrepayment -- 是否允许提前还款
    ,o.offsheetflag -- 表内外属性
    ,o.suitcurrency -- 可用币种
    ,o.inputorgid -- 登记机构
    ,o.uniquelimit -- 额度是否唯一
    ,o.suitroles -- 适用角色
    ,o.belongproductid -- 所属产品编号
    ,o.baseproduct -- 期限值(月)
    ,o.productname -- 产品名称
    ,o.underproduct -- 额度适用产品
    ,o.limitrelaprotocal -- 额度是否关联协议
    ,o.productdesc -- 产品描述
    ,o.basetermmodelno -- 基础条款模型编号
    ,o.relatermmodelno -- 关联条款模型编号
    ,o.effectivedate -- 产品生效日期
    ,o.inputuserid -- 登记人
    ,o.inputdate -- 登记日期
    ,o.usabledept -- 产品发行机构编号
    ,o.producttype -- 产品类型
    ,o.limitperiod -- 额度管控阶段
    ,o.updateuserid -- 更新人
    ,o.assetthreetype -- 三分类标识
    ,o.occupytype -- 额度被占用方式
    ,o.rotative -- 循环贷款标志
    ,o.sortno -- 排序号
    ,o.norisk -- 是否无风险业务
    ,o.totalexposure -- 是否全敞口业务
    ,o.isleafnode -- 是否叶节点
    ,o.entcreditclassify -- 企业征信分类-CreditType
    ,o.saveflag -- 保存标识
    ,o.queryparam -- 额度查询参数
    ,o.isgrouplimit -- 
    ,o.iscallimit -- 
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
from ${iol_schema}.icms_prd_catalog_bk o
    left join ${iol_schema}.icms_prd_catalog_op n
        on
            o.productid = n.productid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_prd_catalog_cl d
        on
            o.productid = d.productid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_prd_catalog;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_prd_catalog') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_prd_catalog drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_prd_catalog add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_prd_catalog exchange partition p_${batch_date} with table ${iol_schema}.icms_prd_catalog_cl;
alter table ${iol_schema}.icms_prd_catalog exchange partition p_20991231 with table ${iol_schema}.icms_prd_catalog_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_prd_catalog to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_prd_catalog_op purge;
drop table ${iol_schema}.icms_prd_catalog_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_prd_catalog_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_prd_catalog',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
