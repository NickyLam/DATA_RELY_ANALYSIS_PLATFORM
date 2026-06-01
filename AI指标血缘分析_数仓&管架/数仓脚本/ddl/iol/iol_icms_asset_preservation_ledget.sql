/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_asset_preservation_ledget
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_asset_preservation_ledget
whenever sqlerror continue none;
drop table ${iol_schema}.icms_asset_preservation_ledget purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_asset_preservation_ledget(
    serialno varchar2(64) -- 流水号
    ,branchbusinessdivision varchar2(120) -- 分行/事业部
    ,inputorgid varchar2(64) -- 经办机构名称
    ,inputuserid varchar2(64) -- 客户经理
    ,customerid varchar2(64) -- 客户编号
    ,duebillid varchar2(64) -- 借据号
    ,customername varchar2(200) -- 客户名称
    ,customertype varchar2(32) -- 客户类型
    ,industry varchar2(32) -- 行业
    ,entscale varchar2(18) -- 企业规模
    ,assettype varchar2(10) -- 资产类型
    ,begincreditbalance number(24,6) -- 年初授信余额折人民币
    ,beginriskclassify varchar2(36) -- 年初风险分类
    ,firsttimedesc date -- 第一次下调不良时间
    ,riskisolationresults varchar2(36) -- 风险排查结果
    ,ironridetime date -- 列入铁骑名单时间
    ,handleriskclassify varchar2(36) -- 处置时点风险分类
    ,handletype varchar2(200) -- 处置（含重组）方式
    ,typeassettransfer varchar2(2) -- 资产转让类型
    ,handletime date -- 处置（含重组）时间
    ,handlebalance number(24,6) -- 处置金额
    ,repaymentresource varchar2(36) -- 还款来源
    ,handleinterestbalance number(24,6) -- 处置欠息金额
    ,handlechargedbalance number(24,6) -- 处置罚息金额
    ,handlereinterestedbalance number(24,6) -- 处置复息金额
    ,handlesubstitutecushion number(24,6) -- 处置代垫费用
    ,beforeclassifyresult varchar2(36) -- 变动前五级分类
    ,beforebalance number(24,6) -- 变动前余额
    ,afterclassifyresult varchar2(36) -- 变动后五级分类
    ,cashoffdate date -- 核销/抵债后收现日期（元）
    ,recoveroffbalance number(24,6) -- 核销/抵债后收回金额（元）
    ,normalrecoverbalance number(24,6) -- 调回正常后收回金额
    ,remark varchar2(2000) -- 备注
    ,businesstype varchar2(5) -- 
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
grant select on ${iol_schema}.icms_asset_preservation_ledget to ${iml_schema};
grant select on ${iol_schema}.icms_asset_preservation_ledget to ${icl_schema};
grant select on ${iol_schema}.icms_asset_preservation_ledget to ${idl_schema};
grant select on ${iol_schema}.icms_asset_preservation_ledget to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_asset_preservation_ledget is '资产保全台账信息表';
comment on column ${iol_schema}.icms_asset_preservation_ledget.serialno is '流水号';
comment on column ${iol_schema}.icms_asset_preservation_ledget.branchbusinessdivision is '分行/事业部';
comment on column ${iol_schema}.icms_asset_preservation_ledget.inputorgid is '经办机构名称';
comment on column ${iol_schema}.icms_asset_preservation_ledget.inputuserid is '客户经理';
comment on column ${iol_schema}.icms_asset_preservation_ledget.customerid is '客户编号';
comment on column ${iol_schema}.icms_asset_preservation_ledget.duebillid is '借据号';
comment on column ${iol_schema}.icms_asset_preservation_ledget.customername is '客户名称';
comment on column ${iol_schema}.icms_asset_preservation_ledget.customertype is '客户类型';
comment on column ${iol_schema}.icms_asset_preservation_ledget.industry is '行业';
comment on column ${iol_schema}.icms_asset_preservation_ledget.entscale is '企业规模';
comment on column ${iol_schema}.icms_asset_preservation_ledget.assettype is '资产类型';
comment on column ${iol_schema}.icms_asset_preservation_ledget.begincreditbalance is '年初授信余额折人民币';
comment on column ${iol_schema}.icms_asset_preservation_ledget.beginriskclassify is '年初风险分类';
comment on column ${iol_schema}.icms_asset_preservation_ledget.firsttimedesc is '第一次下调不良时间';
comment on column ${iol_schema}.icms_asset_preservation_ledget.riskisolationresults is '风险排查结果';
comment on column ${iol_schema}.icms_asset_preservation_ledget.ironridetime is '列入铁骑名单时间';
comment on column ${iol_schema}.icms_asset_preservation_ledget.handleriskclassify is '处置时点风险分类';
comment on column ${iol_schema}.icms_asset_preservation_ledget.handletype is '处置（含重组）方式';
comment on column ${iol_schema}.icms_asset_preservation_ledget.typeassettransfer is '资产转让类型';
comment on column ${iol_schema}.icms_asset_preservation_ledget.handletime is '处置（含重组）时间';
comment on column ${iol_schema}.icms_asset_preservation_ledget.handlebalance is '处置金额';
comment on column ${iol_schema}.icms_asset_preservation_ledget.repaymentresource is '还款来源';
comment on column ${iol_schema}.icms_asset_preservation_ledget.handleinterestbalance is '处置欠息金额';
comment on column ${iol_schema}.icms_asset_preservation_ledget.handlechargedbalance is '处置罚息金额';
comment on column ${iol_schema}.icms_asset_preservation_ledget.handlereinterestedbalance is '处置复息金额';
comment on column ${iol_schema}.icms_asset_preservation_ledget.handlesubstitutecushion is '处置代垫费用';
comment on column ${iol_schema}.icms_asset_preservation_ledget.beforeclassifyresult is '变动前五级分类';
comment on column ${iol_schema}.icms_asset_preservation_ledget.beforebalance is '变动前余额';
comment on column ${iol_schema}.icms_asset_preservation_ledget.afterclassifyresult is '变动后五级分类';
comment on column ${iol_schema}.icms_asset_preservation_ledget.cashoffdate is '核销/抵债后收现日期（元）';
comment on column ${iol_schema}.icms_asset_preservation_ledget.recoveroffbalance is '核销/抵债后收回金额（元）';
comment on column ${iol_schema}.icms_asset_preservation_ledget.normalrecoverbalance is '调回正常后收回金额';
comment on column ${iol_schema}.icms_asset_preservation_ledget.remark is '备注';
comment on column ${iol_schema}.icms_asset_preservation_ledget.businesstype is '';
comment on column ${iol_schema}.icms_asset_preservation_ledget.start_dt is '开始时间';
comment on column ${iol_schema}.icms_asset_preservation_ledget.end_dt is '结束时间';
comment on column ${iol_schema}.icms_asset_preservation_ledget.id_mark is '增删标志';
comment on column ${iol_schema}.icms_asset_preservation_ledget.etl_timestamp is 'ETL处理时间戳';
