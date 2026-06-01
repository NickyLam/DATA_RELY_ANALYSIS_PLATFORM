/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_rep_asset_position
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_rep_asset_position
whenever sqlerror continue none;
drop table ${iol_schema}.fams_rep_asset_position purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_rep_asset_position(
    cdate varchar2(50) -- 日期
    ,assetcode varchar2(50) -- 资产代码
    ,assetname varchar2(200) -- 资产名称
    ,vdate varchar2(50) -- 首期日
    ,mdate varchar2(50) -- 到期日
    ,custrate varchar2(50) -- 利率(%)
    ,basis varchar2(50) -- 计息基础 枚举值数据字典：BASIS
    ,position number(30,2) -- 持仓余额
    ,criceamt number(30,2) -- 资产价值
    ,tdylossamt number(30,2) -- 资产减值金额
    ,unpayamt number(30,2) -- 应收利息
    ,friceamt number(30,2) -- 资产全价
    ,sppiactmdate varchar2(50) -- 实际到期日
    ,accounttype varchar2(10) -- 账户类型 枚举值数据字典：AMT_INCOME_TYPE
    ,assettype varchar2(50) -- 资产类别 枚举值数据字典：FINPROD_TYPE_TG
    ,detailassettype varchar2(200) -- 明细资产类别
    ,profittype varchar2(10) -- 收益类型
    ,assettypeone varchar2(10) -- 资产分类（一级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_ONE
    ,assettypetwo varchar2(10) -- 资产分类（二级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_TWO
    ,assettypethree varchar2(10) -- 资产分类（三级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_THREE
    ,assettypefour varchar2(10) -- 资产分类（四级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_FOUR
    ,assettypesecone varchar2(10) -- 资产分类（债券品种维度一级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_SEC_ONE
    ,assettypesectwo varchar2(10) -- 资产分类（债券品种维度二级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_SEC_TWO
    ,assettypeissueone varchar2(10) -- 资产分类（发行主体维度）枚举值数据字典：ASSET_TYPE_MAINTENANCE_ISSUE_ONE
    ,maingrade varchar2(50) -- 债券主体评级 枚举值数据字典：MAIN_GRADE_RESULT
    ,maingradeorg varchar2(50) -- 主体评级机构 枚举值数据字典：GRADE_PARTY
    ,creditgrade varchar2(50) -- 债券信用评级 枚举值数据字典：MAIN_GRADE_RESULT
    ,creditgradeorg varchar2(50) -- 债券评级机构 枚举值数据字典：GRADE_PARTY
    ,termtype varchar2(50) -- 剩余期限分类
    ,investnature varchar2(50) -- 资产投资性质 枚举值数据字典：INVEST_TYPE
    ,isstandasset varchar2(10) -- 是否标准化资产
    ,investmenttype varchar2(10) -- 投资方式 枚举值数据字典：INVESTMENT_TYPE
    ,customername varchar2(200) -- 基础资产客户名称
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
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
grant select on ${iol_schema}.fams_rep_asset_position to ${iml_schema};
grant select on ${iol_schema}.fams_rep_asset_position to ${icl_schema};
grant select on ${iol_schema}.fams_rep_asset_position to ${idl_schema};
grant select on ${iol_schema}.fams_rep_asset_position to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_rep_asset_position is '报表单据-账户持仓表';
comment on column ${iol_schema}.fams_rep_asset_position.cdate is '日期';
comment on column ${iol_schema}.fams_rep_asset_position.assetcode is '资产代码';
comment on column ${iol_schema}.fams_rep_asset_position.assetname is '资产名称';
comment on column ${iol_schema}.fams_rep_asset_position.vdate is '首期日';
comment on column ${iol_schema}.fams_rep_asset_position.mdate is '到期日';
comment on column ${iol_schema}.fams_rep_asset_position.custrate is '利率(%)';
comment on column ${iol_schema}.fams_rep_asset_position.basis is '计息基础 枚举值数据字典：BASIS';
comment on column ${iol_schema}.fams_rep_asset_position.position is '持仓余额';
comment on column ${iol_schema}.fams_rep_asset_position.criceamt is '资产价值';
comment on column ${iol_schema}.fams_rep_asset_position.tdylossamt is '资产减值金额';
comment on column ${iol_schema}.fams_rep_asset_position.unpayamt is '应收利息';
comment on column ${iol_schema}.fams_rep_asset_position.friceamt is '资产全价';
comment on column ${iol_schema}.fams_rep_asset_position.sppiactmdate is '实际到期日';
comment on column ${iol_schema}.fams_rep_asset_position.accounttype is '账户类型 枚举值数据字典：AMT_INCOME_TYPE';
comment on column ${iol_schema}.fams_rep_asset_position.assettype is '资产类别 枚举值数据字典：FINPROD_TYPE_TG';
comment on column ${iol_schema}.fams_rep_asset_position.detailassettype is '明细资产类别';
comment on column ${iol_schema}.fams_rep_asset_position.profittype is '收益类型';
comment on column ${iol_schema}.fams_rep_asset_position.assettypeone is '资产分类（一级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_ONE';
comment on column ${iol_schema}.fams_rep_asset_position.assettypetwo is '资产分类（二级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_TWO';
comment on column ${iol_schema}.fams_rep_asset_position.assettypethree is '资产分类（三级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_THREE';
comment on column ${iol_schema}.fams_rep_asset_position.assettypefour is '资产分类（四级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_FOUR';
comment on column ${iol_schema}.fams_rep_asset_position.assettypesecone is '资产分类（债券品种维度一级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_SEC_ONE';
comment on column ${iol_schema}.fams_rep_asset_position.assettypesectwo is '资产分类（债券品种维度二级）枚举值数据字典：ASSET_TYPE_MAINTENANCE_SEC_TWO';
comment on column ${iol_schema}.fams_rep_asset_position.assettypeissueone is '资产分类（发行主体维度）枚举值数据字典：ASSET_TYPE_MAINTENANCE_ISSUE_ONE';
comment on column ${iol_schema}.fams_rep_asset_position.maingrade is '债券主体评级 枚举值数据字典：MAIN_GRADE_RESULT';
comment on column ${iol_schema}.fams_rep_asset_position.maingradeorg is '主体评级机构 枚举值数据字典：GRADE_PARTY';
comment on column ${iol_schema}.fams_rep_asset_position.creditgrade is '债券信用评级 枚举值数据字典：MAIN_GRADE_RESULT';
comment on column ${iol_schema}.fams_rep_asset_position.creditgradeorg is '债券评级机构 枚举值数据字典：GRADE_PARTY';
comment on column ${iol_schema}.fams_rep_asset_position.termtype is '剩余期限分类';
comment on column ${iol_schema}.fams_rep_asset_position.investnature is '资产投资性质 枚举值数据字典：INVEST_TYPE';
comment on column ${iol_schema}.fams_rep_asset_position.isstandasset is '是否标准化资产';
comment on column ${iol_schema}.fams_rep_asset_position.investmenttype is '投资方式 枚举值数据字典：INVESTMENT_TYPE';
comment on column ${iol_schema}.fams_rep_asset_position.customername is '基础资产客户名称';
comment on column ${iol_schema}.fams_rep_asset_position.create_user is '创建人';
comment on column ${iol_schema}.fams_rep_asset_position.create_dept is '创建部门';
comment on column ${iol_schema}.fams_rep_asset_position.create_time is '创建时间';
comment on column ${iol_schema}.fams_rep_asset_position.update_user is '更新人';
comment on column ${iol_schema}.fams_rep_asset_position.update_time is '更新时间';
comment on column ${iol_schema}.fams_rep_asset_position.start_dt is '开始时间';
comment on column ${iol_schema}.fams_rep_asset_position.end_dt is '结束时间';
comment on column ${iol_schema}.fams_rep_asset_position.id_mark is '增删标志';
comment on column ${iol_schema}.fams_rep_asset_position.etl_timestamp is 'ETL处理时间戳';
