/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_param
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
create table ${iol_schema}.icms_clr_param_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_param
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_param_op purge;
drop table ${iol_schema}.icms_clr_param_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_param_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_param where 0=1;

create table ${iol_schema}.icms_clr_param_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_param where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_param_cl(
            clrtypeid -- 押品类型编号
            ,clrtypename -- 押品类型名称
            ,crmtype -- 风险缓释工具类型
            ,maxltv -- 最大抵质押率
            ,maxltvscenario -- 最大抵质押率适用业务场景
            ,isallowedmort -- 是否允许抵押
            ,isallowedpledge -- 是否允许质押
            ,isallowedremort -- 是否允许重复抵押
            ,isallowedremortinline -- 是否允许行内重复抵押
            ,isacceptnfstrepay -- 是否接受非第一顺位受偿
            ,registagencytype -- 权利登记机关类型
            ,gntcerttype -- 抵质押代表权证类型
            ,atttemplate -- 押品要素模板
            ,infotab -- 押品详细组合信息页面
            ,iscurrmismatch -- 是否允许币种错配
            ,isneedinsurance -- 是否需要投保
            ,renewalterm -- 续保期限;年)
            ,isneednotarizaiton -- 是否需要公证
            ,isneedrgst -- 是否需要抵质押登记手续
            ,isneedmonitoring -- 是否需要贷后现场检查
            ,monitoringfrq -- 贷后现场检查频率
            ,maxguaterm -- 最大担保期限
            ,maxguascenario -- 最大担保期限适用业务场景
            ,evalperiod -- 价值评估周期;月)
            ,issuitineval -- 是否适用内部评估
            ,issuitouteval -- 是否适用外部评估
            ,mainevalmethod -- 主要的估值方法
            ,detailevalmodel -- 适用的详细评估模型
            ,fastevalmodel -- 适用的快速评估模型
            ,evalflow -- 价值评估流程
            ,appraiseatt -- 外部评估公司资质要求
            ,reevalfrqunit -- 重估频率单位
            ,reevalfrq -- 重估频率
            ,isautoreeval -- 是否自动重估
            ,autoreevalmode -- 固定日期滚动周期
            ,reevaldatedef -- 重估日定义
            ,extweight -- 外评权重
            ,inweight -- 内评权重
            ,isneedrightcert -- 是否需要提交权证
            ,issuitcombineeval -- 是否适用内外结合评估
            ,ismanualbatchreval -- 是否人工批量重估
            ,issysbatchreval -- 是否系统批量重估
            ,evalmodelmarket -- 市场法估值模板
            ,evalmodelprofit -- 收益法估值模板
            ,evalmodelcost -- 成本法估值模板
            ,evalmodelquick -- 贷后快速评估模板
            ,ishavewarrant -- 是否有他项权证
            ,isneedin -- 是否需要入库
            ,isqualified -- 是否合格缓释工具
            ,validcerttype -- 有效权证名称
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,remark -- 备注
            ,entrycriteria -- 准入条件文本
            ,productlist -- 适用的产品
            ,clronlyscope -- 押品唯一性校验范围
            ,maincerttype -- 主权证类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_param_op(
            clrtypeid -- 押品类型编号
            ,clrtypename -- 押品类型名称
            ,crmtype -- 风险缓释工具类型
            ,maxltv -- 最大抵质押率
            ,maxltvscenario -- 最大抵质押率适用业务场景
            ,isallowedmort -- 是否允许抵押
            ,isallowedpledge -- 是否允许质押
            ,isallowedremort -- 是否允许重复抵押
            ,isallowedremortinline -- 是否允许行内重复抵押
            ,isacceptnfstrepay -- 是否接受非第一顺位受偿
            ,registagencytype -- 权利登记机关类型
            ,gntcerttype -- 抵质押代表权证类型
            ,atttemplate -- 押品要素模板
            ,infotab -- 押品详细组合信息页面
            ,iscurrmismatch -- 是否允许币种错配
            ,isneedinsurance -- 是否需要投保
            ,renewalterm -- 续保期限;年)
            ,isneednotarizaiton -- 是否需要公证
            ,isneedrgst -- 是否需要抵质押登记手续
            ,isneedmonitoring -- 是否需要贷后现场检查
            ,monitoringfrq -- 贷后现场检查频率
            ,maxguaterm -- 最大担保期限
            ,maxguascenario -- 最大担保期限适用业务场景
            ,evalperiod -- 价值评估周期;月)
            ,issuitineval -- 是否适用内部评估
            ,issuitouteval -- 是否适用外部评估
            ,mainevalmethod -- 主要的估值方法
            ,detailevalmodel -- 适用的详细评估模型
            ,fastevalmodel -- 适用的快速评估模型
            ,evalflow -- 价值评估流程
            ,appraiseatt -- 外部评估公司资质要求
            ,reevalfrqunit -- 重估频率单位
            ,reevalfrq -- 重估频率
            ,isautoreeval -- 是否自动重估
            ,autoreevalmode -- 固定日期滚动周期
            ,reevaldatedef -- 重估日定义
            ,extweight -- 外评权重
            ,inweight -- 内评权重
            ,isneedrightcert -- 是否需要提交权证
            ,issuitcombineeval -- 是否适用内外结合评估
            ,ismanualbatchreval -- 是否人工批量重估
            ,issysbatchreval -- 是否系统批量重估
            ,evalmodelmarket -- 市场法估值模板
            ,evalmodelprofit -- 收益法估值模板
            ,evalmodelcost -- 成本法估值模板
            ,evalmodelquick -- 贷后快速评估模板
            ,ishavewarrant -- 是否有他项权证
            ,isneedin -- 是否需要入库
            ,isqualified -- 是否合格缓释工具
            ,validcerttype -- 有效权证名称
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,remark -- 备注
            ,entrycriteria -- 准入条件文本
            ,productlist -- 适用的产品
            ,clronlyscope -- 押品唯一性校验范围
            ,maincerttype -- 主权证类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.clrtypeid, o.clrtypeid) as clrtypeid -- 押品类型编号
    ,nvl(n.clrtypename, o.clrtypename) as clrtypename -- 押品类型名称
    ,nvl(n.crmtype, o.crmtype) as crmtype -- 风险缓释工具类型
    ,nvl(n.maxltv, o.maxltv) as maxltv -- 最大抵质押率
    ,nvl(n.maxltvscenario, o.maxltvscenario) as maxltvscenario -- 最大抵质押率适用业务场景
    ,nvl(n.isallowedmort, o.isallowedmort) as isallowedmort -- 是否允许抵押
    ,nvl(n.isallowedpledge, o.isallowedpledge) as isallowedpledge -- 是否允许质押
    ,nvl(n.isallowedremort, o.isallowedremort) as isallowedremort -- 是否允许重复抵押
    ,nvl(n.isallowedremortinline, o.isallowedremortinline) as isallowedremortinline -- 是否允许行内重复抵押
    ,nvl(n.isacceptnfstrepay, o.isacceptnfstrepay) as isacceptnfstrepay -- 是否接受非第一顺位受偿
    ,nvl(n.registagencytype, o.registagencytype) as registagencytype -- 权利登记机关类型
    ,nvl(n.gntcerttype, o.gntcerttype) as gntcerttype -- 抵质押代表权证类型
    ,nvl(n.atttemplate, o.atttemplate) as atttemplate -- 押品要素模板
    ,nvl(n.infotab, o.infotab) as infotab -- 押品详细组合信息页面
    ,nvl(n.iscurrmismatch, o.iscurrmismatch) as iscurrmismatch -- 是否允许币种错配
    ,nvl(n.isneedinsurance, o.isneedinsurance) as isneedinsurance -- 是否需要投保
    ,nvl(n.renewalterm, o.renewalterm) as renewalterm -- 续保期限;年)
    ,nvl(n.isneednotarizaiton, o.isneednotarizaiton) as isneednotarizaiton -- 是否需要公证
    ,nvl(n.isneedrgst, o.isneedrgst) as isneedrgst -- 是否需要抵质押登记手续
    ,nvl(n.isneedmonitoring, o.isneedmonitoring) as isneedmonitoring -- 是否需要贷后现场检查
    ,nvl(n.monitoringfrq, o.monitoringfrq) as monitoringfrq -- 贷后现场检查频率
    ,nvl(n.maxguaterm, o.maxguaterm) as maxguaterm -- 最大担保期限
    ,nvl(n.maxguascenario, o.maxguascenario) as maxguascenario -- 最大担保期限适用业务场景
    ,nvl(n.evalperiod, o.evalperiod) as evalperiod -- 价值评估周期;月)
    ,nvl(n.issuitineval, o.issuitineval) as issuitineval -- 是否适用内部评估
    ,nvl(n.issuitouteval, o.issuitouteval) as issuitouteval -- 是否适用外部评估
    ,nvl(n.mainevalmethod, o.mainevalmethod) as mainevalmethod -- 主要的估值方法
    ,nvl(n.detailevalmodel, o.detailevalmodel) as detailevalmodel -- 适用的详细评估模型
    ,nvl(n.fastevalmodel, o.fastevalmodel) as fastevalmodel -- 适用的快速评估模型
    ,nvl(n.evalflow, o.evalflow) as evalflow -- 价值评估流程
    ,nvl(n.appraiseatt, o.appraiseatt) as appraiseatt -- 外部评估公司资质要求
    ,nvl(n.reevalfrqunit, o.reevalfrqunit) as reevalfrqunit -- 重估频率单位
    ,nvl(n.reevalfrq, o.reevalfrq) as reevalfrq -- 重估频率
    ,nvl(n.isautoreeval, o.isautoreeval) as isautoreeval -- 是否自动重估
    ,nvl(n.autoreevalmode, o.autoreevalmode) as autoreevalmode -- 固定日期滚动周期
    ,nvl(n.reevaldatedef, o.reevaldatedef) as reevaldatedef -- 重估日定义
    ,nvl(n.extweight, o.extweight) as extweight -- 外评权重
    ,nvl(n.inweight, o.inweight) as inweight -- 内评权重
    ,nvl(n.isneedrightcert, o.isneedrightcert) as isneedrightcert -- 是否需要提交权证
    ,nvl(n.issuitcombineeval, o.issuitcombineeval) as issuitcombineeval -- 是否适用内外结合评估
    ,nvl(n.ismanualbatchreval, o.ismanualbatchreval) as ismanualbatchreval -- 是否人工批量重估
    ,nvl(n.issysbatchreval, o.issysbatchreval) as issysbatchreval -- 是否系统批量重估
    ,nvl(n.evalmodelmarket, o.evalmodelmarket) as evalmodelmarket -- 市场法估值模板
    ,nvl(n.evalmodelprofit, o.evalmodelprofit) as evalmodelprofit -- 收益法估值模板
    ,nvl(n.evalmodelcost, o.evalmodelcost) as evalmodelcost -- 成本法估值模板
    ,nvl(n.evalmodelquick, o.evalmodelquick) as evalmodelquick -- 贷后快速评估模板
    ,nvl(n.ishavewarrant, o.ishavewarrant) as ishavewarrant -- 是否有他项权证
    ,nvl(n.isneedin, o.isneedin) as isneedin -- 是否需要入库
    ,nvl(n.isqualified, o.isqualified) as isqualified -- 是否合格缓释工具
    ,nvl(n.validcerttype, o.validcerttype) as validcerttype -- 有效权证名称
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.entrycriteria, o.entrycriteria) as entrycriteria -- 准入条件文本
    ,nvl(n.productlist, o.productlist) as productlist -- 适用的产品
    ,nvl(n.clronlyscope, o.clronlyscope) as clronlyscope -- 押品唯一性校验范围
    ,nvl(n.maincerttype, o.maincerttype) as maincerttype -- 主权证类型
    ,case when
            n.clrtypeid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.clrtypeid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.clrtypeid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_clr_param_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_param where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clrtypeid = n.clrtypeid
where (
        o.clrtypeid is null
    )
    or (
        n.clrtypeid is null
    )
    or (
        o.clrtypename <> n.clrtypename
        or o.crmtype <> n.crmtype
        or o.maxltv <> n.maxltv
        or o.maxltvscenario <> n.maxltvscenario
        or o.isallowedmort <> n.isallowedmort
        or o.isallowedpledge <> n.isallowedpledge
        or o.isallowedremort <> n.isallowedremort
        or o.isallowedremortinline <> n.isallowedremortinline
        or o.isacceptnfstrepay <> n.isacceptnfstrepay
        or o.registagencytype <> n.registagencytype
        or o.gntcerttype <> n.gntcerttype
        or o.atttemplate <> n.atttemplate
        or o.infotab <> n.infotab
        or o.iscurrmismatch <> n.iscurrmismatch
        or o.isneedinsurance <> n.isneedinsurance
        or o.renewalterm <> n.renewalterm
        or o.isneednotarizaiton <> n.isneednotarizaiton
        or o.isneedrgst <> n.isneedrgst
        or o.isneedmonitoring <> n.isneedmonitoring
        or o.monitoringfrq <> n.monitoringfrq
        or o.maxguaterm <> n.maxguaterm
        or o.maxguascenario <> n.maxguascenario
        or o.evalperiod <> n.evalperiod
        or o.issuitineval <> n.issuitineval
        or o.issuitouteval <> n.issuitouteval
        or o.mainevalmethod <> n.mainevalmethod
        or o.detailevalmodel <> n.detailevalmodel
        or o.fastevalmodel <> n.fastevalmodel
        or o.evalflow <> n.evalflow
        or o.appraiseatt <> n.appraiseatt
        or o.reevalfrqunit <> n.reevalfrqunit
        or o.reevalfrq <> n.reevalfrq
        or o.isautoreeval <> n.isautoreeval
        or o.autoreevalmode <> n.autoreevalmode
        or o.reevaldatedef <> n.reevaldatedef
        or o.extweight <> n.extweight
        or o.inweight <> n.inweight
        or o.isneedrightcert <> n.isneedrightcert
        or o.issuitcombineeval <> n.issuitcombineeval
        or o.ismanualbatchreval <> n.ismanualbatchreval
        or o.issysbatchreval <> n.issysbatchreval
        or o.evalmodelmarket <> n.evalmodelmarket
        or o.evalmodelprofit <> n.evalmodelprofit
        or o.evalmodelcost <> n.evalmodelcost
        or o.evalmodelquick <> n.evalmodelquick
        or o.ishavewarrant <> n.ishavewarrant
        or o.isneedin <> n.isneedin
        or o.isqualified <> n.isqualified
        or o.validcerttype <> n.validcerttype
        or o.inputorgid <> n.inputorgid
        or o.inputuserid <> n.inputuserid
        or o.inputdate <> n.inputdate
        or o.updateorgid <> n.updateorgid
        or o.updateuserid <> n.updateuserid
        or o.updatedate <> n.updatedate
        or o.remark <> n.remark
        or o.entrycriteria <> n.entrycriteria
        or o.productlist <> n.productlist
        or o.clronlyscope <> n.clronlyscope
        or o.maincerttype <> n.maincerttype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_param_cl(
            clrtypeid -- 押品类型编号
            ,clrtypename -- 押品类型名称
            ,crmtype -- 风险缓释工具类型
            ,maxltv -- 最大抵质押率
            ,maxltvscenario -- 最大抵质押率适用业务场景
            ,isallowedmort -- 是否允许抵押
            ,isallowedpledge -- 是否允许质押
            ,isallowedremort -- 是否允许重复抵押
            ,isallowedremortinline -- 是否允许行内重复抵押
            ,isacceptnfstrepay -- 是否接受非第一顺位受偿
            ,registagencytype -- 权利登记机关类型
            ,gntcerttype -- 抵质押代表权证类型
            ,atttemplate -- 押品要素模板
            ,infotab -- 押品详细组合信息页面
            ,iscurrmismatch -- 是否允许币种错配
            ,isneedinsurance -- 是否需要投保
            ,renewalterm -- 续保期限;年)
            ,isneednotarizaiton -- 是否需要公证
            ,isneedrgst -- 是否需要抵质押登记手续
            ,isneedmonitoring -- 是否需要贷后现场检查
            ,monitoringfrq -- 贷后现场检查频率
            ,maxguaterm -- 最大担保期限
            ,maxguascenario -- 最大担保期限适用业务场景
            ,evalperiod -- 价值评估周期;月)
            ,issuitineval -- 是否适用内部评估
            ,issuitouteval -- 是否适用外部评估
            ,mainevalmethod -- 主要的估值方法
            ,detailevalmodel -- 适用的详细评估模型
            ,fastevalmodel -- 适用的快速评估模型
            ,evalflow -- 价值评估流程
            ,appraiseatt -- 外部评估公司资质要求
            ,reevalfrqunit -- 重估频率单位
            ,reevalfrq -- 重估频率
            ,isautoreeval -- 是否自动重估
            ,autoreevalmode -- 固定日期滚动周期
            ,reevaldatedef -- 重估日定义
            ,extweight -- 外评权重
            ,inweight -- 内评权重
            ,isneedrightcert -- 是否需要提交权证
            ,issuitcombineeval -- 是否适用内外结合评估
            ,ismanualbatchreval -- 是否人工批量重估
            ,issysbatchreval -- 是否系统批量重估
            ,evalmodelmarket -- 市场法估值模板
            ,evalmodelprofit -- 收益法估值模板
            ,evalmodelcost -- 成本法估值模板
            ,evalmodelquick -- 贷后快速评估模板
            ,ishavewarrant -- 是否有他项权证
            ,isneedin -- 是否需要入库
            ,isqualified -- 是否合格缓释工具
            ,validcerttype -- 有效权证名称
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,remark -- 备注
            ,entrycriteria -- 准入条件文本
            ,productlist -- 适用的产品
            ,clronlyscope -- 押品唯一性校验范围
            ,maincerttype -- 主权证类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_param_op(
            clrtypeid -- 押品类型编号
            ,clrtypename -- 押品类型名称
            ,crmtype -- 风险缓释工具类型
            ,maxltv -- 最大抵质押率
            ,maxltvscenario -- 最大抵质押率适用业务场景
            ,isallowedmort -- 是否允许抵押
            ,isallowedpledge -- 是否允许质押
            ,isallowedremort -- 是否允许重复抵押
            ,isallowedremortinline -- 是否允许行内重复抵押
            ,isacceptnfstrepay -- 是否接受非第一顺位受偿
            ,registagencytype -- 权利登记机关类型
            ,gntcerttype -- 抵质押代表权证类型
            ,atttemplate -- 押品要素模板
            ,infotab -- 押品详细组合信息页面
            ,iscurrmismatch -- 是否允许币种错配
            ,isneedinsurance -- 是否需要投保
            ,renewalterm -- 续保期限;年)
            ,isneednotarizaiton -- 是否需要公证
            ,isneedrgst -- 是否需要抵质押登记手续
            ,isneedmonitoring -- 是否需要贷后现场检查
            ,monitoringfrq -- 贷后现场检查频率
            ,maxguaterm -- 最大担保期限
            ,maxguascenario -- 最大担保期限适用业务场景
            ,evalperiod -- 价值评估周期;月)
            ,issuitineval -- 是否适用内部评估
            ,issuitouteval -- 是否适用外部评估
            ,mainevalmethod -- 主要的估值方法
            ,detailevalmodel -- 适用的详细评估模型
            ,fastevalmodel -- 适用的快速评估模型
            ,evalflow -- 价值评估流程
            ,appraiseatt -- 外部评估公司资质要求
            ,reevalfrqunit -- 重估频率单位
            ,reevalfrq -- 重估频率
            ,isautoreeval -- 是否自动重估
            ,autoreevalmode -- 固定日期滚动周期
            ,reevaldatedef -- 重估日定义
            ,extweight -- 外评权重
            ,inweight -- 内评权重
            ,isneedrightcert -- 是否需要提交权证
            ,issuitcombineeval -- 是否适用内外结合评估
            ,ismanualbatchreval -- 是否人工批量重估
            ,issysbatchreval -- 是否系统批量重估
            ,evalmodelmarket -- 市场法估值模板
            ,evalmodelprofit -- 收益法估值模板
            ,evalmodelcost -- 成本法估值模板
            ,evalmodelquick -- 贷后快速评估模板
            ,ishavewarrant -- 是否有他项权证
            ,isneedin -- 是否需要入库
            ,isqualified -- 是否合格缓释工具
            ,validcerttype -- 有效权证名称
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,remark -- 备注
            ,entrycriteria -- 准入条件文本
            ,productlist -- 适用的产品
            ,clronlyscope -- 押品唯一性校验范围
            ,maincerttype -- 主权证类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.clrtypeid -- 押品类型编号
    ,o.clrtypename -- 押品类型名称
    ,o.crmtype -- 风险缓释工具类型
    ,o.maxltv -- 最大抵质押率
    ,o.maxltvscenario -- 最大抵质押率适用业务场景
    ,o.isallowedmort -- 是否允许抵押
    ,o.isallowedpledge -- 是否允许质押
    ,o.isallowedremort -- 是否允许重复抵押
    ,o.isallowedremortinline -- 是否允许行内重复抵押
    ,o.isacceptnfstrepay -- 是否接受非第一顺位受偿
    ,o.registagencytype -- 权利登记机关类型
    ,o.gntcerttype -- 抵质押代表权证类型
    ,o.atttemplate -- 押品要素模板
    ,o.infotab -- 押品详细组合信息页面
    ,o.iscurrmismatch -- 是否允许币种错配
    ,o.isneedinsurance -- 是否需要投保
    ,o.renewalterm -- 续保期限;年)
    ,o.isneednotarizaiton -- 是否需要公证
    ,o.isneedrgst -- 是否需要抵质押登记手续
    ,o.isneedmonitoring -- 是否需要贷后现场检查
    ,o.monitoringfrq -- 贷后现场检查频率
    ,o.maxguaterm -- 最大担保期限
    ,o.maxguascenario -- 最大担保期限适用业务场景
    ,o.evalperiod -- 价值评估周期;月)
    ,o.issuitineval -- 是否适用内部评估
    ,o.issuitouteval -- 是否适用外部评估
    ,o.mainevalmethod -- 主要的估值方法
    ,o.detailevalmodel -- 适用的详细评估模型
    ,o.fastevalmodel -- 适用的快速评估模型
    ,o.evalflow -- 价值评估流程
    ,o.appraiseatt -- 外部评估公司资质要求
    ,o.reevalfrqunit -- 重估频率单位
    ,o.reevalfrq -- 重估频率
    ,o.isautoreeval -- 是否自动重估
    ,o.autoreevalmode -- 固定日期滚动周期
    ,o.reevaldatedef -- 重估日定义
    ,o.extweight -- 外评权重
    ,o.inweight -- 内评权重
    ,o.isneedrightcert -- 是否需要提交权证
    ,o.issuitcombineeval -- 是否适用内外结合评估
    ,o.ismanualbatchreval -- 是否人工批量重估
    ,o.issysbatchreval -- 是否系统批量重估
    ,o.evalmodelmarket -- 市场法估值模板
    ,o.evalmodelprofit -- 收益法估值模板
    ,o.evalmodelcost -- 成本法估值模板
    ,o.evalmodelquick -- 贷后快速评估模板
    ,o.ishavewarrant -- 是否有他项权证
    ,o.isneedin -- 是否需要入库
    ,o.isqualified -- 是否合格缓释工具
    ,o.validcerttype -- 有效权证名称
    ,o.inputorgid -- 登记机构
    ,o.inputuserid -- 登记人
    ,o.inputdate -- 登记日期
    ,o.updateorgid -- 更新机构
    ,o.updateuserid -- 更新人
    ,o.updatedate -- 更新日期
    ,o.remark -- 备注
    ,o.entrycriteria -- 准入条件文本
    ,o.productlist -- 适用的产品
    ,o.clronlyscope -- 押品唯一性校验范围
    ,o.maincerttype -- 主权证类型
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
from ${iol_schema}.icms_clr_param_bk o
    left join ${iol_schema}.icms_clr_param_op n
        on
            o.clrtypeid = n.clrtypeid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_param_cl d
        on
            o.clrtypeid = d.clrtypeid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_clr_param;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_param') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_param drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_param add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_param exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_param_cl;
alter table ${iol_schema}.icms_clr_param exchange partition p_20991231 with table ${iol_schema}.icms_clr_param_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_param to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_param_op purge;
drop table ${iol_schema}.icms_clr_param_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_param_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_param',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
