/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icms_prd_catalog
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
alter table ${idl_schema}.icms_prd_catalog drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_prd_catalog add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_prd_catalog (
etl_dt  --数据日期
,productid  --产品编号
,expirydate  --产品失效日期
,indpostloancheckrate  --个人客户贷后检查抽取比例
,parentproductid  --父目录
,productclassify  --新增产品类型
,permitpackage  --是否允许打包
,occupylimitdesc  --额度占用说明
,publiclimit  --是否公开额度
,multiloan  --是否允许多次放款
,updatedate  --更新日期
,exflusiveflag  --是否专属产品
,uniquesuitscope  --唯一性适用范围
,iscapitalpurposecheck  --是否进行资金用途检查
,packageproduct  --打包业务品种
,businessflag  --是否额度类产品
,productstatus  --产品状态
,updateorgid  --更新机构
,belongdept  --隶属管理部门
,multiputout  --是否允许多次出账
,purposechecktopdays  --资金用途检查天数上限
,purposecheckbottomdays  --资金用途检查天数下限
,corporgid  --法人机构编号
,occupylimit  --是否会占用额度(自用/他用/同业)
,earlyrepayment  --是否允许提前还款
,offsheetflag  --表内外属性
,suitcurrency  --可用币种
,inputorgid  --登记机构
,uniquelimit  --额度是否唯一
,suitroles  --适用角色
,belongproductid  --所属产品编号
,baseproduct  --期限值(月)
,productname  --产品名称
,underproduct  --额度适用产品
,limitrelaprotocal  --额度是否关联协议
,productdesc  --产品描述
,basetermmodelno  --基础条款模型编号
,relatermmodelno  --关联条款模型编号
,effectivedate  --产品生效日期
,inputuserid  --登记人
,inputdate  --登记日期
,usabledept  --产品发行机构编号
,producttype  --产品类型
,limitperiod  --额度管控阶段
,updateuserid  --更新人
,assetthreetype  --三分类标识
,occupytype  --额度被占用方式
,rotative  --循环贷款标志
,sortno  --排序号
,norisk  --是否无风险业务
,totalexposure  --是否全敞口业务
,isleafnode  --是否叶节点
,entcreditclassify  --企业征信分类-credittype
,saveflag  --保存标识
,queryparam  --额度查询参数
,isgrouplimit  --是否受集团管控
,iscallimit  --是否参与单一客户信用限额计算

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid --产品编号
,t1.expirydate as expirydate --产品失效日期
,t1.indpostloancheckrate as indpostloancheckrate --个人客户贷后检查抽取比例
,replace(replace(t1.parentproductid,chr(13),''),chr(10),'') as parentproductid --父目录
,replace(replace(t1.productclassify,chr(13),''),chr(10),'') as productclassify --新增产品类型
,replace(replace(t1.permitpackage,chr(13),''),chr(10),'') as permitpackage --是否允许打包
,replace(replace(t1.occupylimitdesc,chr(13),''),chr(10),'') as occupylimitdesc --额度占用说明
,replace(replace(t1.publiclimit,chr(13),''),chr(10),'') as publiclimit --是否公开额度
,replace(replace(t1.multiloan,chr(13),''),chr(10),'') as multiloan --是否允许多次放款
,t1.updatedate as updatedate --更新日期
,replace(replace(t1.exflusiveflag,chr(13),''),chr(10),'') as exflusiveflag --是否专属产品
,replace(replace(t1.uniquesuitscope,chr(13),''),chr(10),'') as uniquesuitscope --唯一性适用范围
,replace(replace(t1.iscapitalpurposecheck,chr(13),''),chr(10),'') as iscapitalpurposecheck --是否进行资金用途检查
,replace(replace(t1.packageproduct,chr(13),''),chr(10),'') as packageproduct --打包业务品种
,replace(replace(t1.businessflag,chr(13),''),chr(10),'') as businessflag --是否额度类产品
,replace(replace(t1.productstatus,chr(13),''),chr(10),'') as productstatus --产品状态
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid --更新机构
,replace(replace(t1.belongdept,chr(13),''),chr(10),'') as belongdept --隶属管理部门
,replace(replace(t1.multiputout,chr(13),''),chr(10),'') as multiputout --是否允许多次出账
,t1.purposechecktopdays as purposechecktopdays --资金用途检查天数上限
,t1.purposecheckbottomdays as purposecheckbottomdays --资金用途检查天数下限
,replace(replace(t1.corporgid,chr(13),''),chr(10),'') as corporgid --法人机构编号
,replace(replace(t1.occupylimit,chr(13),''),chr(10),'') as occupylimit --是否会占用额度(自用/他用/同业)
,replace(replace(t1.earlyrepayment,chr(13),''),chr(10),'') as earlyrepayment --是否允许提前还款
,replace(replace(t1.offsheetflag,chr(13),''),chr(10),'') as offsheetflag --表内外属性
,replace(replace(t1.suitcurrency,chr(13),''),chr(10),'') as suitcurrency --可用币种
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid --登记机构
,replace(replace(t1.uniquelimit,chr(13),''),chr(10),'') as uniquelimit --额度是否唯一
,replace(replace(t1.suitroles,chr(13),''),chr(10),'') as suitroles --适用角色
,replace(replace(t1.belongproductid,chr(13),''),chr(10),'') as belongproductid --所属产品编号
,t1.baseproduct as baseproduct --期限值(月)
,replace(replace(t1.productname,chr(13),''),chr(10),'') as productname --产品名称
,replace(replace(t1.underproduct,chr(13),''),chr(10),'') as underproduct --额度适用产品
,replace(replace(t1.limitrelaprotocal,chr(13),''),chr(10),'') as limitrelaprotocal --额度是否关联协议
,replace(replace(t1.productdesc,chr(13),''),chr(10),'') as productdesc --产品描述
,replace(replace(t1.basetermmodelno,chr(13),''),chr(10),'') as basetermmodelno --基础条款模型编号
,replace(replace(t1.relatermmodelno,chr(13),''),chr(10),'') as relatermmodelno --关联条款模型编号
,t1.effectivedate as effectivedate --产品生效日期
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid --登记人
,t1.inputdate as inputdate --登记日期
,replace(replace(t1.usabledept,chr(13),''),chr(10),'') as usabledept --产品发行机构编号
,replace(replace(t1.producttype,chr(13),''),chr(10),'') as producttype --产品类型
,replace(replace(t1.limitperiod,chr(13),''),chr(10),'') as limitperiod --额度管控阶段
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid --更新人
,replace(replace(t1.assetthreetype,chr(13),''),chr(10),'') as assetthreetype --三分类标识
,replace(replace(t1.occupytype,chr(13),''),chr(10),'') as occupytype --额度被占用方式
,replace(replace(t1.rotative,chr(13),''),chr(10),'') as rotative --循环贷款标志
,replace(replace(t1.sortno,chr(13),''),chr(10),'') as sortno --排序号
,replace(replace(t1.norisk,chr(13),''),chr(10),'') as norisk --是否无风险业务
,replace(replace(t1.totalexposure,chr(13),''),chr(10),'') as totalexposure --是否全敞口业务
,replace(replace(t1.isleafnode,chr(13),''),chr(10),'') as isleafnode --是否叶节点
,replace(replace(t1.entcreditclassify,chr(13),''),chr(10),'') as entcreditclassify --企业征信分类-credittype
,replace(replace(t1.saveflag,chr(13),''),chr(10),'') as saveflag --保存标识
,replace(replace(t1.queryparam,chr(13),''),chr(10),'') as queryparam --额度查询参数
,replace(replace(t1.isgrouplimit,chr(13),''),chr(10),'') as isgrouplimit --是否受集团管控
,replace(replace(t1.iscallimit,chr(13),''),chr(10),'') as iscallimit --是否参与单一客户信用限额计算
from ${iol_schema}.icms_prd_catalog t1    --产品目录
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_prd_catalog',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
