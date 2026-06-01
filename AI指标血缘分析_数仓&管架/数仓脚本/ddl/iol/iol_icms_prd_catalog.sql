/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_prd_catalog
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_prd_catalog
whenever sqlerror continue none;
drop table ${iol_schema}.icms_prd_catalog purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_catalog(
    productid varchar2(12) -- 产品编号
    ,expirydate date -- 产品失效日期
    ,indpostloancheckrate number(24,8) -- 个人客户贷后检查抽取比例
    ,parentproductid varchar2(64) -- 父目录
    ,productclassify varchar2(64) -- 新增产品类型
    ,permitpackage varchar2(2) -- 是否允许打包
    ,occupylimitdesc varchar2(2000) -- 额度占用说明
    ,publiclimit varchar2(2) -- 是否公开额度
    ,multiloan varchar2(2) -- 是否允许多次放款
    ,updatedate date -- 更新日期
    ,exflusiveflag varchar2(2) -- 是否专属产品
    ,uniquesuitscope varchar2(64) -- 唯一性适用范围
    ,iscapitalpurposecheck varchar2(2) -- 是否进行资金用途检查
    ,packageproduct varchar2(4000) -- 打包业务品种
    ,businessflag varchar2(2) -- 是否额度类产品
    ,productstatus varchar2(1) -- 产品状态
    ,updateorgid varchar2(64) -- 更新机构
    ,belongdept varchar2(12) -- 隶属管理部门
    ,multiputout varchar2(2) -- 是否允许多次出账
    ,purposechecktopdays number(22) -- 资金用途检查天数上限
    ,purposecheckbottomdays number(22) -- 资金用途检查天数下限
    ,corporgid varchar2(64) -- 法人机构编号
    ,occupylimit varchar2(2) -- 是否会占用额度(自用/他用/同业)
    ,earlyrepayment varchar2(2) -- 是否允许提前还款
    ,offsheetflag varchar2(12) -- 表内外属性
    ,suitcurrency varchar2(400) -- 可用币种
    ,inputorgid varchar2(64) -- 登记机构
    ,uniquelimit varchar2(2) -- 额度是否唯一
    ,suitroles varchar2(1000) -- 适用角色
    ,belongproductid varchar2(64) -- 所属产品编号
    ,baseproduct number(4,0) -- 期限值(月)
    ,productname varchar2(200) -- 产品名称
    ,underproduct varchar2(4000) -- 额度适用产品
    ,limitrelaprotocal varchar2(2) -- 额度是否关联协议
    ,productdesc varchar2(800) -- 产品描述
    ,basetermmodelno varchar2(64) -- 基础条款模型编号
    ,relatermmodelno varchar2(64) -- 关联条款模型编号
    ,effectivedate date -- 产品生效日期
    ,inputuserid varchar2(64) -- 登记人
    ,inputdate date -- 登记日期
    ,usabledept varchar2(12) -- 产品发行机构编号
    ,producttype varchar2(12) -- 产品类型
    ,limitperiod varchar2(64) -- 额度管控阶段
    ,updateuserid varchar2(64) -- 更新人
    ,assetthreetype varchar2(8) -- 三分类标识
    ,occupytype varchar2(64) -- 额度被占用方式
    ,rotative varchar2(12) -- 循环贷款标志
    ,sortno varchar2(64) -- 排序号
    ,norisk varchar2(2) -- 是否无风险业务
    ,totalexposure varchar2(2) -- 是否全敞口业务
    ,isleafnode varchar2(2) -- 是否叶节点
    ,entcreditclassify varchar2(10) -- 企业征信分类-CreditType
    ,saveflag varchar2(2) -- 保存标识
    ,queryparam varchar2(200) -- 额度查询参数
    ,isgrouplimit varchar2(1) -- 
    ,iscallimit varchar2(1) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_prd_catalog to ${iml_schema};
grant select on ${iol_schema}.icms_prd_catalog to ${icl_schema};
grant select on ${iol_schema}.icms_prd_catalog to ${idl_schema};
grant select on ${iol_schema}.icms_prd_catalog to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_prd_catalog is '产品目录';
comment on column ${iol_schema}.icms_prd_catalog.productid is '产品编号';
comment on column ${iol_schema}.icms_prd_catalog.expirydate is '产品失效日期';
comment on column ${iol_schema}.icms_prd_catalog.indpostloancheckrate is '个人客户贷后检查抽取比例';
comment on column ${iol_schema}.icms_prd_catalog.parentproductid is '父目录';
comment on column ${iol_schema}.icms_prd_catalog.productclassify is '新增产品类型';
comment on column ${iol_schema}.icms_prd_catalog.permitpackage is '是否允许打包';
comment on column ${iol_schema}.icms_prd_catalog.occupylimitdesc is '额度占用说明';
comment on column ${iol_schema}.icms_prd_catalog.publiclimit is '是否公开额度';
comment on column ${iol_schema}.icms_prd_catalog.multiloan is '是否允许多次放款';
comment on column ${iol_schema}.icms_prd_catalog.updatedate is '更新日期';
comment on column ${iol_schema}.icms_prd_catalog.exflusiveflag is '是否专属产品';
comment on column ${iol_schema}.icms_prd_catalog.uniquesuitscope is '唯一性适用范围';
comment on column ${iol_schema}.icms_prd_catalog.iscapitalpurposecheck is '是否进行资金用途检查';
comment on column ${iol_schema}.icms_prd_catalog.packageproduct is '打包业务品种';
comment on column ${iol_schema}.icms_prd_catalog.businessflag is '是否额度类产品';
comment on column ${iol_schema}.icms_prd_catalog.productstatus is '产品状态';
comment on column ${iol_schema}.icms_prd_catalog.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_prd_catalog.belongdept is '隶属管理部门';
comment on column ${iol_schema}.icms_prd_catalog.multiputout is '是否允许多次出账';
comment on column ${iol_schema}.icms_prd_catalog.purposechecktopdays is '资金用途检查天数上限';
comment on column ${iol_schema}.icms_prd_catalog.purposecheckbottomdays is '资金用途检查天数下限';
comment on column ${iol_schema}.icms_prd_catalog.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_prd_catalog.occupylimit is '是否会占用额度(自用/他用/同业)';
comment on column ${iol_schema}.icms_prd_catalog.earlyrepayment is '是否允许提前还款';
comment on column ${iol_schema}.icms_prd_catalog.offsheetflag is '表内外属性';
comment on column ${iol_schema}.icms_prd_catalog.suitcurrency is '可用币种';
comment on column ${iol_schema}.icms_prd_catalog.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_prd_catalog.uniquelimit is '额度是否唯一';
comment on column ${iol_schema}.icms_prd_catalog.suitroles is '适用角色';
comment on column ${iol_schema}.icms_prd_catalog.belongproductid is '所属产品编号';
comment on column ${iol_schema}.icms_prd_catalog.baseproduct is '期限值(月)';
comment on column ${iol_schema}.icms_prd_catalog.productname is '产品名称';
comment on column ${iol_schema}.icms_prd_catalog.underproduct is '额度适用产品';
comment on column ${iol_schema}.icms_prd_catalog.limitrelaprotocal is '额度是否关联协议';
comment on column ${iol_schema}.icms_prd_catalog.productdesc is '产品描述';
comment on column ${iol_schema}.icms_prd_catalog.basetermmodelno is '基础条款模型编号';
comment on column ${iol_schema}.icms_prd_catalog.relatermmodelno is '关联条款模型编号';
comment on column ${iol_schema}.icms_prd_catalog.effectivedate is '产品生效日期';
comment on column ${iol_schema}.icms_prd_catalog.inputuserid is '登记人';
comment on column ${iol_schema}.icms_prd_catalog.inputdate is '登记日期';
comment on column ${iol_schema}.icms_prd_catalog.usabledept is '产品发行机构编号';
comment on column ${iol_schema}.icms_prd_catalog.producttype is '产品类型';
comment on column ${iol_schema}.icms_prd_catalog.limitperiod is '额度管控阶段';
comment on column ${iol_schema}.icms_prd_catalog.updateuserid is '更新人';
comment on column ${iol_schema}.icms_prd_catalog.assetthreetype is '三分类标识';
comment on column ${iol_schema}.icms_prd_catalog.occupytype is '额度被占用方式';
comment on column ${iol_schema}.icms_prd_catalog.rotative is '循环贷款标志';
comment on column ${iol_schema}.icms_prd_catalog.sortno is '排序号';
comment on column ${iol_schema}.icms_prd_catalog.norisk is '是否无风险业务';
comment on column ${iol_schema}.icms_prd_catalog.totalexposure is '是否全敞口业务';
comment on column ${iol_schema}.icms_prd_catalog.isleafnode is '是否叶节点';
comment on column ${iol_schema}.icms_prd_catalog.entcreditclassify is '企业征信分类-CreditType';
comment on column ${iol_schema}.icms_prd_catalog.saveflag is '保存标识';
comment on column ${iol_schema}.icms_prd_catalog.queryparam is '额度查询参数';
comment on column ${iol_schema}.icms_prd_catalog.isgrouplimit is '';
comment on column ${iol_schema}.icms_prd_catalog.iscallimit is '';
comment on column ${iol_schema}.icms_prd_catalog.start_dt is '开始时间';
comment on column ${iol_schema}.icms_prd_catalog.end_dt is '结束时间';
comment on column ${iol_schema}.icms_prd_catalog.id_mark is '增删标志';
comment on column ${iol_schema}.icms_prd_catalog.etl_timestamp is 'ETL处理时间戳';
