/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_param
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_param
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_param purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_param(
    clrtypeid varchar2(96) -- 押品类型编号
    ,clrtypename varchar2(240) -- 押品类型名称
    ,crmtype varchar2(54) -- 风险缓释工具类型
    ,maxltv number(16,6) -- 最大抵质押率
    ,maxltvscenario varchar2(1500) -- 最大抵质押率适用业务场景
    ,isallowedmort varchar2(3) -- 是否允许抵押
    ,isallowedpledge varchar2(3) -- 是否允许质押
    ,isallowedremort varchar2(3) -- 是否允许重复抵押
    ,isallowedremortinline varchar2(3) -- 是否允许行内重复抵押
    ,isacceptnfstrepay varchar2(3) -- 是否接受非第一顺位受偿
    ,registagencytype varchar2(54) -- 权利登记机关类型
    ,gntcerttype varchar2(54) -- 抵质押代表权证类型
    ,atttemplate varchar2(96) -- 押品要素模板
    ,infotab varchar2(96) -- 押品详细组合信息页面
    ,iscurrmismatch varchar2(3) -- 是否允许币种错配
    ,isneedinsurance varchar2(3) -- 是否需要投保
    ,renewalterm number(38,0) -- 续保期限;年)
    ,isneednotarizaiton varchar2(3) -- 是否需要公证
    ,isneedrgst varchar2(3) -- 是否需要抵质押登记手续
    ,isneedmonitoring varchar2(3) -- 是否需要贷后现场检查
    ,monitoringfrq varchar2(18) -- 贷后现场检查频率
    ,maxguaterm number(38,0) -- 最大担保期限
    ,maxguascenario varchar2(3000) -- 最大担保期限适用业务场景
    ,evalperiod number(38,0) -- 价值评估周期;月)
    ,issuitineval varchar2(3) -- 是否适用内部评估
    ,issuitouteval varchar2(3) -- 是否适用外部评估
    ,mainevalmethod varchar2(96) -- 主要的估值方法
    ,detailevalmodel varchar2(240) -- 适用的详细评估模型
    ,fastevalmodel varchar2(240) -- 适用的快速评估模型
    ,evalflow varchar2(96) -- 价值评估流程
    ,appraiseatt varchar2(3000) -- 外部评估公司资质要求
    ,reevalfrqunit varchar2(18) -- 重估频率单位
    ,reevalfrq number(38,0) -- 重估频率
    ,isautoreeval varchar2(3) -- 是否自动重估
    ,autoreevalmode varchar2(18) -- 固定日期滚动周期
    ,reevaldatedef varchar2(3000) -- 重估日定义
    ,extweight number(16,6) -- 外评权重
    ,inweight number(16,6) -- 内评权重
    ,isneedrightcert varchar2(3) -- 是否需要提交权证
    ,issuitcombineeval varchar2(3) -- 是否适用内外结合评估
    ,ismanualbatchreval varchar2(3) -- 是否人工批量重估
    ,issysbatchreval varchar2(3) -- 是否系统批量重估
    ,evalmodelmarket varchar2(240) -- 市场法估值模板
    ,evalmodelprofit varchar2(240) -- 收益法估值模板
    ,evalmodelcost varchar2(240) -- 成本法估值模板
    ,evalmodelquick varchar2(240) -- 贷后快速评估模板
    ,ishavewarrant varchar2(3) -- 是否有他项权证
    ,isneedin varchar2(3) -- 是否需要入库
    ,isqualified varchar2(3) -- 是否合格缓释工具
    ,validcerttype varchar2(240) -- 有效权证名称
    ,inputorgid varchar2(96) -- 登记机构
    ,inputuserid varchar2(240) -- 登记人
    ,inputdate timestamp -- 登记日期
    ,updateorgid varchar2(96) -- 更新机构
    ,updateuserid varchar2(240) -- 更新人
    ,updatedate timestamp -- 更新日期
    ,remark varchar2(1500) -- 备注
    ,entrycriteria varchar2(4000) -- 准入条件文本
    ,productlist varchar2(4000) -- 适用的产品
    ,clronlyscope varchar2(4000) -- 押品唯一性校验范围
    ,maincerttype varchar2(90) -- 主权证类型
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
grant select on ${iol_schema}.icms_clr_param to ${iml_schema};
grant select on ${iol_schema}.icms_clr_param to ${icl_schema};
grant select on ${iol_schema}.icms_clr_param to ${idl_schema};
grant select on ${iol_schema}.icms_clr_param to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_param is '押品分类参数';
comment on column ${iol_schema}.icms_clr_param.clrtypeid is '押品类型编号';
comment on column ${iol_schema}.icms_clr_param.clrtypename is '押品类型名称';
comment on column ${iol_schema}.icms_clr_param.crmtype is '风险缓释工具类型';
comment on column ${iol_schema}.icms_clr_param.maxltv is '最大抵质押率';
comment on column ${iol_schema}.icms_clr_param.maxltvscenario is '最大抵质押率适用业务场景';
comment on column ${iol_schema}.icms_clr_param.isallowedmort is '是否允许抵押';
comment on column ${iol_schema}.icms_clr_param.isallowedpledge is '是否允许质押';
comment on column ${iol_schema}.icms_clr_param.isallowedremort is '是否允许重复抵押';
comment on column ${iol_schema}.icms_clr_param.isallowedremortinline is '是否允许行内重复抵押';
comment on column ${iol_schema}.icms_clr_param.isacceptnfstrepay is '是否接受非第一顺位受偿';
comment on column ${iol_schema}.icms_clr_param.registagencytype is '权利登记机关类型';
comment on column ${iol_schema}.icms_clr_param.gntcerttype is '抵质押代表权证类型';
comment on column ${iol_schema}.icms_clr_param.atttemplate is '押品要素模板';
comment on column ${iol_schema}.icms_clr_param.infotab is '押品详细组合信息页面';
comment on column ${iol_schema}.icms_clr_param.iscurrmismatch is '是否允许币种错配';
comment on column ${iol_schema}.icms_clr_param.isneedinsurance is '是否需要投保';
comment on column ${iol_schema}.icms_clr_param.renewalterm is '续保期限;年)';
comment on column ${iol_schema}.icms_clr_param.isneednotarizaiton is '是否需要公证';
comment on column ${iol_schema}.icms_clr_param.isneedrgst is '是否需要抵质押登记手续';
comment on column ${iol_schema}.icms_clr_param.isneedmonitoring is '是否需要贷后现场检查';
comment on column ${iol_schema}.icms_clr_param.monitoringfrq is '贷后现场检查频率';
comment on column ${iol_schema}.icms_clr_param.maxguaterm is '最大担保期限';
comment on column ${iol_schema}.icms_clr_param.maxguascenario is '最大担保期限适用业务场景';
comment on column ${iol_schema}.icms_clr_param.evalperiod is '价值评估周期;月)';
comment on column ${iol_schema}.icms_clr_param.issuitineval is '是否适用内部评估';
comment on column ${iol_schema}.icms_clr_param.issuitouteval is '是否适用外部评估';
comment on column ${iol_schema}.icms_clr_param.mainevalmethod is '主要的估值方法';
comment on column ${iol_schema}.icms_clr_param.detailevalmodel is '适用的详细评估模型';
comment on column ${iol_schema}.icms_clr_param.fastevalmodel is '适用的快速评估模型';
comment on column ${iol_schema}.icms_clr_param.evalflow is '价值评估流程';
comment on column ${iol_schema}.icms_clr_param.appraiseatt is '外部评估公司资质要求';
comment on column ${iol_schema}.icms_clr_param.reevalfrqunit is '重估频率单位';
comment on column ${iol_schema}.icms_clr_param.reevalfrq is '重估频率';
comment on column ${iol_schema}.icms_clr_param.isautoreeval is '是否自动重估';
comment on column ${iol_schema}.icms_clr_param.autoreevalmode is '固定日期滚动周期';
comment on column ${iol_schema}.icms_clr_param.reevaldatedef is '重估日定义';
comment on column ${iol_schema}.icms_clr_param.extweight is '外评权重';
comment on column ${iol_schema}.icms_clr_param.inweight is '内评权重';
comment on column ${iol_schema}.icms_clr_param.isneedrightcert is '是否需要提交权证';
comment on column ${iol_schema}.icms_clr_param.issuitcombineeval is '是否适用内外结合评估';
comment on column ${iol_schema}.icms_clr_param.ismanualbatchreval is '是否人工批量重估';
comment on column ${iol_schema}.icms_clr_param.issysbatchreval is '是否系统批量重估';
comment on column ${iol_schema}.icms_clr_param.evalmodelmarket is '市场法估值模板';
comment on column ${iol_schema}.icms_clr_param.evalmodelprofit is '收益法估值模板';
comment on column ${iol_schema}.icms_clr_param.evalmodelcost is '成本法估值模板';
comment on column ${iol_schema}.icms_clr_param.evalmodelquick is '贷后快速评估模板';
comment on column ${iol_schema}.icms_clr_param.ishavewarrant is '是否有他项权证';
comment on column ${iol_schema}.icms_clr_param.isneedin is '是否需要入库';
comment on column ${iol_schema}.icms_clr_param.isqualified is '是否合格缓释工具';
comment on column ${iol_schema}.icms_clr_param.validcerttype is '有效权证名称';
comment on column ${iol_schema}.icms_clr_param.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_clr_param.inputuserid is '登记人';
comment on column ${iol_schema}.icms_clr_param.inputdate is '登记日期';
comment on column ${iol_schema}.icms_clr_param.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_clr_param.updateuserid is '更新人';
comment on column ${iol_schema}.icms_clr_param.updatedate is '更新日期';
comment on column ${iol_schema}.icms_clr_param.remark is '备注';
comment on column ${iol_schema}.icms_clr_param.entrycriteria is '准入条件文本';
comment on column ${iol_schema}.icms_clr_param.productlist is '适用的产品';
comment on column ${iol_schema}.icms_clr_param.clronlyscope is '押品唯一性校验范围';
comment on column ${iol_schema}.icms_clr_param.maincerttype is '主权证类型';
comment on column ${iol_schema}.icms_clr_param.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_param.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_param.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_param.etl_timestamp is 'ETL处理时间戳';
