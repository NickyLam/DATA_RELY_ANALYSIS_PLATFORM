/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_investment_client_according
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
create table ${iol_schema}.icms_investment_client_according_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_investment_client_according
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_investment_client_according_op purge;
drop table ${iol_schema}.icms_investment_client_according_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_investment_client_according_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_investment_client_according where 0=1;

create table ${iol_schema}.icms_investment_client_according_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_investment_client_according where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_investment_client_according_cl(
            serialno -- 流水号
            ,relserialno -- 关联认定表主键
            ,loslistedcompanyflag -- 是否上市企业判定标识
            ,loslistedcompany -- 是否上市公司
            ,loslistexchange -- 上市交易所
            ,losdurationbondflag -- 是否存续期内债券判定标识
            ,vlrperformedchecks -- 执行公开排查条数
            ,vlrsuspectchecks -- 罪犯及嫌疑人排查条数
            ,vlruncreditchecks -- 失信被执行人排查条数
            ,vlrviolationchecks -- 行政违法排查条数
            ,vlrhighvaluechecks -- 限制高消费排查条数
            ,vlrowingtaxeschecks -- 欠税排查条数
            ,vlrexitandentrychecks -- 限制出入境排查条数
            ,vlrimproperchecks -- 纳税非正常户排查条数
            ,vlrjudicativechecks -- 民商事裁判文书排查条数
            ,vlrfinalcasechecks -- 终本案件排查条数
            ,vlrtrialprocesschecks -- 民商事审判流程排查条数
            ,vlrprincipaltype -- 主体类型
            ,afaauditflag -- 审计标志
            ,afaauditopinion -- 审计意见
            ,afaauditreportdate -- 审计意见报表日期
            ,ddydebtdefaultflag -- 是否债务违约判定标识
            ,ddyclassifyresult -- 当前五级分类
            ,ddyclassifydate -- 当前分类日期
            ,egsassetsratio -- 担保总额占净资产比例
            ,egsillegalguarantees -- 违规担保总额
            ,iidindustrycategory -- 所属行业门类代码
            ,alrreportperiod -- 资产负债-报告期
            ,alrreporttype -- 资产负债-报表类型
            ,alrtotalassets -- 资产总计
            ,alrtotaldebt -- 负债合计
            ,alrliabilityratio -- 资产负债率
            ,cfncashreportperiod -- 经营活动-报告期
            ,cfncashreporttype -- 经营活动-报表类型
            ,cfncashflowamount -- 经营活动产生的现金流净额
            ,cfnnetreportperiod -- 净利息-报告期
            ,cfnnetreporttype -- 净利息-报表类型
            ,cfninterestcost -- 财务费用:利息费用
            ,cfninterestincome -- 财务费用:利息收入
            ,cfnnetinterestcost -- 净利息费用
            ,spatotalprofitflag -- 利润总额判定标识
            ,spaparentnetprofitflag -- 归属母公司净利润判定标识
            ,spanetprofitflag -- 净利润判定标识
            ,tfdreportperiod -- 财务数据-报告期
            ,tfdreporttype -- 财务数据-报表类型
            ,tfdreportdate -- 财务数据-录入日期
            ,tdereportperiod -- 按时披露-报告期
            ,tdereporttype -- 按时披露-报表类型
            ,tdereportdate -- 按时披露-录入日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,spacomprehensiveflag -- 综合收益总额判定标识
            ,spacomprehensivereportperiod -- 综合收益报告期
            ,spacomprehensivereporttype -- 综合收益报表类型
            ,spacomprehensiveincome -- 综合收益总额
            ,spaparentreportperiod -- 母公司综合收益报告期
            ,spaparentreporttype -- 母公司综合收益报表类型
            ,spaparentincome -- 综合收益总额（母公司）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_investment_client_according_op(
            serialno -- 流水号
            ,relserialno -- 关联认定表主键
            ,loslistedcompanyflag -- 是否上市企业判定标识
            ,loslistedcompany -- 是否上市公司
            ,loslistexchange -- 上市交易所
            ,losdurationbondflag -- 是否存续期内债券判定标识
            ,vlrperformedchecks -- 执行公开排查条数
            ,vlrsuspectchecks -- 罪犯及嫌疑人排查条数
            ,vlruncreditchecks -- 失信被执行人排查条数
            ,vlrviolationchecks -- 行政违法排查条数
            ,vlrhighvaluechecks -- 限制高消费排查条数
            ,vlrowingtaxeschecks -- 欠税排查条数
            ,vlrexitandentrychecks -- 限制出入境排查条数
            ,vlrimproperchecks -- 纳税非正常户排查条数
            ,vlrjudicativechecks -- 民商事裁判文书排查条数
            ,vlrfinalcasechecks -- 终本案件排查条数
            ,vlrtrialprocesschecks -- 民商事审判流程排查条数
            ,vlrprincipaltype -- 主体类型
            ,afaauditflag -- 审计标志
            ,afaauditopinion -- 审计意见
            ,afaauditreportdate -- 审计意见报表日期
            ,ddydebtdefaultflag -- 是否债务违约判定标识
            ,ddyclassifyresult -- 当前五级分类
            ,ddyclassifydate -- 当前分类日期
            ,egsassetsratio -- 担保总额占净资产比例
            ,egsillegalguarantees -- 违规担保总额
            ,iidindustrycategory -- 所属行业门类代码
            ,alrreportperiod -- 资产负债-报告期
            ,alrreporttype -- 资产负债-报表类型
            ,alrtotalassets -- 资产总计
            ,alrtotaldebt -- 负债合计
            ,alrliabilityratio -- 资产负债率
            ,cfncashreportperiod -- 经营活动-报告期
            ,cfncashreporttype -- 经营活动-报表类型
            ,cfncashflowamount -- 经营活动产生的现金流净额
            ,cfnnetreportperiod -- 净利息-报告期
            ,cfnnetreporttype -- 净利息-报表类型
            ,cfninterestcost -- 财务费用:利息费用
            ,cfninterestincome -- 财务费用:利息收入
            ,cfnnetinterestcost -- 净利息费用
            ,spatotalprofitflag -- 利润总额判定标识
            ,spaparentnetprofitflag -- 归属母公司净利润判定标识
            ,spanetprofitflag -- 净利润判定标识
            ,tfdreportperiod -- 财务数据-报告期
            ,tfdreporttype -- 财务数据-报表类型
            ,tfdreportdate -- 财务数据-录入日期
            ,tdereportperiod -- 按时披露-报告期
            ,tdereporttype -- 按时披露-报表类型
            ,tdereportdate -- 按时披露-录入日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,spacomprehensiveflag -- 综合收益总额判定标识
            ,spacomprehensivereportperiod -- 综合收益报告期
            ,spacomprehensivereporttype -- 综合收益报表类型
            ,spacomprehensiveincome -- 综合收益总额
            ,spaparentreportperiod -- 母公司综合收益报告期
            ,spaparentreporttype -- 母公司综合收益报表类型
            ,spaparentincome -- 综合收益总额（母公司）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.relserialno, o.relserialno) as relserialno -- 关联认定表主键
    ,nvl(n.loslistedcompanyflag, o.loslistedcompanyflag) as loslistedcompanyflag -- 是否上市企业判定标识
    ,nvl(n.loslistedcompany, o.loslistedcompany) as loslistedcompany -- 是否上市公司
    ,nvl(n.loslistexchange, o.loslistexchange) as loslistexchange -- 上市交易所
    ,nvl(n.losdurationbondflag, o.losdurationbondflag) as losdurationbondflag -- 是否存续期内债券判定标识
    ,nvl(n.vlrperformedchecks, o.vlrperformedchecks) as vlrperformedchecks -- 执行公开排查条数
    ,nvl(n.vlrsuspectchecks, o.vlrsuspectchecks) as vlrsuspectchecks -- 罪犯及嫌疑人排查条数
    ,nvl(n.vlruncreditchecks, o.vlruncreditchecks) as vlruncreditchecks -- 失信被执行人排查条数
    ,nvl(n.vlrviolationchecks, o.vlrviolationchecks) as vlrviolationchecks -- 行政违法排查条数
    ,nvl(n.vlrhighvaluechecks, o.vlrhighvaluechecks) as vlrhighvaluechecks -- 限制高消费排查条数
    ,nvl(n.vlrowingtaxeschecks, o.vlrowingtaxeschecks) as vlrowingtaxeschecks -- 欠税排查条数
    ,nvl(n.vlrexitandentrychecks, o.vlrexitandentrychecks) as vlrexitandentrychecks -- 限制出入境排查条数
    ,nvl(n.vlrimproperchecks, o.vlrimproperchecks) as vlrimproperchecks -- 纳税非正常户排查条数
    ,nvl(n.vlrjudicativechecks, o.vlrjudicativechecks) as vlrjudicativechecks -- 民商事裁判文书排查条数
    ,nvl(n.vlrfinalcasechecks, o.vlrfinalcasechecks) as vlrfinalcasechecks -- 终本案件排查条数
    ,nvl(n.vlrtrialprocesschecks, o.vlrtrialprocesschecks) as vlrtrialprocesschecks -- 民商事审判流程排查条数
    ,nvl(n.vlrprincipaltype, o.vlrprincipaltype) as vlrprincipaltype -- 主体类型
    ,nvl(n.afaauditflag, o.afaauditflag) as afaauditflag -- 审计标志
    ,nvl(n.afaauditopinion, o.afaauditopinion) as afaauditopinion -- 审计意见
    ,nvl(n.afaauditreportdate, o.afaauditreportdate) as afaauditreportdate -- 审计意见报表日期
    ,nvl(n.ddydebtdefaultflag, o.ddydebtdefaultflag) as ddydebtdefaultflag -- 是否债务违约判定标识
    ,nvl(n.ddyclassifyresult, o.ddyclassifyresult) as ddyclassifyresult -- 当前五级分类
    ,nvl(n.ddyclassifydate, o.ddyclassifydate) as ddyclassifydate -- 当前分类日期
    ,nvl(n.egsassetsratio, o.egsassetsratio) as egsassetsratio -- 担保总额占净资产比例
    ,nvl(n.egsillegalguarantees, o.egsillegalguarantees) as egsillegalguarantees -- 违规担保总额
    ,nvl(n.iidindustrycategory, o.iidindustrycategory) as iidindustrycategory -- 所属行业门类代码
    ,nvl(n.alrreportperiod, o.alrreportperiod) as alrreportperiod -- 资产负债-报告期
    ,nvl(n.alrreporttype, o.alrreporttype) as alrreporttype -- 资产负债-报表类型
    ,nvl(n.alrtotalassets, o.alrtotalassets) as alrtotalassets -- 资产总计
    ,nvl(n.alrtotaldebt, o.alrtotaldebt) as alrtotaldebt -- 负债合计
    ,nvl(n.alrliabilityratio, o.alrliabilityratio) as alrliabilityratio -- 资产负债率
    ,nvl(n.cfncashreportperiod, o.cfncashreportperiod) as cfncashreportperiod -- 经营活动-报告期
    ,nvl(n.cfncashreporttype, o.cfncashreporttype) as cfncashreporttype -- 经营活动-报表类型
    ,nvl(n.cfncashflowamount, o.cfncashflowamount) as cfncashflowamount -- 经营活动产生的现金流净额
    ,nvl(n.cfnnetreportperiod, o.cfnnetreportperiod) as cfnnetreportperiod -- 净利息-报告期
    ,nvl(n.cfnnetreporttype, o.cfnnetreporttype) as cfnnetreporttype -- 净利息-报表类型
    ,nvl(n.cfninterestcost, o.cfninterestcost) as cfninterestcost -- 财务费用:利息费用
    ,nvl(n.cfninterestincome, o.cfninterestincome) as cfninterestincome -- 财务费用:利息收入
    ,nvl(n.cfnnetinterestcost, o.cfnnetinterestcost) as cfnnetinterestcost -- 净利息费用
    ,nvl(n.spatotalprofitflag, o.spatotalprofitflag) as spatotalprofitflag -- 利润总额判定标识
    ,nvl(n.spaparentnetprofitflag, o.spaparentnetprofitflag) as spaparentnetprofitflag -- 归属母公司净利润判定标识
    ,nvl(n.spanetprofitflag, o.spanetprofitflag) as spanetprofitflag -- 净利润判定标识
    ,nvl(n.tfdreportperiod, o.tfdreportperiod) as tfdreportperiod -- 财务数据-报告期
    ,nvl(n.tfdreporttype, o.tfdreporttype) as tfdreporttype -- 财务数据-报表类型
    ,nvl(n.tfdreportdate, o.tfdreportdate) as tfdreportdate -- 财务数据-录入日期
    ,nvl(n.tdereportperiod, o.tdereportperiod) as tdereportperiod -- 按时披露-报告期
    ,nvl(n.tdereporttype, o.tdereporttype) as tdereporttype -- 按时披露-报表类型
    ,nvl(n.tdereportdate, o.tdereportdate) as tdereportdate -- 按时披露-录入日期
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.spacomprehensiveflag, o.spacomprehensiveflag) as spacomprehensiveflag -- 综合收益总额判定标识
    ,nvl(n.spacomprehensivereportperiod, o.spacomprehensivereportperiod) as spacomprehensivereportperiod -- 综合收益报告期
    ,nvl(n.spacomprehensivereporttype, o.spacomprehensivereporttype) as spacomprehensivereporttype -- 综合收益报表类型
    ,nvl(n.spacomprehensiveincome, o.spacomprehensiveincome) as spacomprehensiveincome -- 综合收益总额
    ,nvl(n.spaparentreportperiod, o.spaparentreportperiod) as spaparentreportperiod -- 母公司综合收益报告期
    ,nvl(n.spaparentreporttype, o.spaparentreporttype) as spaparentreporttype -- 母公司综合收益报表类型
    ,nvl(n.spaparentincome, o.spaparentincome) as spaparentincome -- 综合收益总额（母公司）
    ,case when
            n.serialno is null
            and n.relserialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
            and n.relserialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
            and n.relserialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_investment_client_according_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_investment_client_according where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
            and o.relserialno = n.relserialno
where (
        o.serialno is null
        and o.relserialno is null
    )
    or (
        n.serialno is null
        and n.relserialno is null
    )
    or (
        o.loslistedcompanyflag <> n.loslistedcompanyflag
        or o.loslistedcompany <> n.loslistedcompany
        or o.loslistexchange <> n.loslistexchange
        or o.losdurationbondflag <> n.losdurationbondflag
        or o.vlrperformedchecks <> n.vlrperformedchecks
        or o.vlrsuspectchecks <> n.vlrsuspectchecks
        or o.vlruncreditchecks <> n.vlruncreditchecks
        or o.vlrviolationchecks <> n.vlrviolationchecks
        or o.vlrhighvaluechecks <> n.vlrhighvaluechecks
        or o.vlrowingtaxeschecks <> n.vlrowingtaxeschecks
        or o.vlrexitandentrychecks <> n.vlrexitandentrychecks
        or o.vlrimproperchecks <> n.vlrimproperchecks
        or o.vlrjudicativechecks <> n.vlrjudicativechecks
        or o.vlrfinalcasechecks <> n.vlrfinalcasechecks
        or o.vlrtrialprocesschecks <> n.vlrtrialprocesschecks
        or o.vlrprincipaltype <> n.vlrprincipaltype
        or o.afaauditflag <> n.afaauditflag
        or o.afaauditopinion <> n.afaauditopinion
        or o.afaauditreportdate <> n.afaauditreportdate
        or o.ddydebtdefaultflag <> n.ddydebtdefaultflag
        or o.ddyclassifyresult <> n.ddyclassifyresult
        or o.ddyclassifydate <> n.ddyclassifydate
        or o.egsassetsratio <> n.egsassetsratio
        or o.egsillegalguarantees <> n.egsillegalguarantees
        or o.iidindustrycategory <> n.iidindustrycategory
        or o.alrreportperiod <> n.alrreportperiod
        or o.alrreporttype <> n.alrreporttype
        or o.alrtotalassets <> n.alrtotalassets
        or o.alrtotaldebt <> n.alrtotaldebt
        or o.alrliabilityratio <> n.alrliabilityratio
        or o.cfncashreportperiod <> n.cfncashreportperiod
        or o.cfncashreporttype <> n.cfncashreporttype
        or o.cfncashflowamount <> n.cfncashflowamount
        or o.cfnnetreportperiod <> n.cfnnetreportperiod
        or o.cfnnetreporttype <> n.cfnnetreporttype
        or o.cfninterestcost <> n.cfninterestcost
        or o.cfninterestincome <> n.cfninterestincome
        or o.cfnnetinterestcost <> n.cfnnetinterestcost
        or o.spatotalprofitflag <> n.spatotalprofitflag
        or o.spaparentnetprofitflag <> n.spaparentnetprofitflag
        or o.spanetprofitflag <> n.spanetprofitflag
        or o.tfdreportperiod <> n.tfdreportperiod
        or o.tfdreporttype <> n.tfdreporttype
        or o.tfdreportdate <> n.tfdreportdate
        or o.tdereportperiod <> n.tdereportperiod
        or o.tdereporttype <> n.tdereporttype
        or o.tdereportdate <> n.tdereportdate
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.spacomprehensiveflag <> n.spacomprehensiveflag
        or o.spacomprehensivereportperiod <> n.spacomprehensivereportperiod
        or o.spacomprehensivereporttype <> n.spacomprehensivereporttype
        or o.spacomprehensiveincome <> n.spacomprehensiveincome
        or o.spaparentreportperiod <> n.spaparentreportperiod
        or o.spaparentreporttype <> n.spaparentreporttype
        or o.spaparentincome <> n.spaparentincome
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_investment_client_according_cl(
            serialno -- 流水号
            ,relserialno -- 关联认定表主键
            ,loslistedcompanyflag -- 是否上市企业判定标识
            ,loslistedcompany -- 是否上市公司
            ,loslistexchange -- 上市交易所
            ,losdurationbondflag -- 是否存续期内债券判定标识
            ,vlrperformedchecks -- 执行公开排查条数
            ,vlrsuspectchecks -- 罪犯及嫌疑人排查条数
            ,vlruncreditchecks -- 失信被执行人排查条数
            ,vlrviolationchecks -- 行政违法排查条数
            ,vlrhighvaluechecks -- 限制高消费排查条数
            ,vlrowingtaxeschecks -- 欠税排查条数
            ,vlrexitandentrychecks -- 限制出入境排查条数
            ,vlrimproperchecks -- 纳税非正常户排查条数
            ,vlrjudicativechecks -- 民商事裁判文书排查条数
            ,vlrfinalcasechecks -- 终本案件排查条数
            ,vlrtrialprocesschecks -- 民商事审判流程排查条数
            ,vlrprincipaltype -- 主体类型
            ,afaauditflag -- 审计标志
            ,afaauditopinion -- 审计意见
            ,afaauditreportdate -- 审计意见报表日期
            ,ddydebtdefaultflag -- 是否债务违约判定标识
            ,ddyclassifyresult -- 当前五级分类
            ,ddyclassifydate -- 当前分类日期
            ,egsassetsratio -- 担保总额占净资产比例
            ,egsillegalguarantees -- 违规担保总额
            ,iidindustrycategory -- 所属行业门类代码
            ,alrreportperiod -- 资产负债-报告期
            ,alrreporttype -- 资产负债-报表类型
            ,alrtotalassets -- 资产总计
            ,alrtotaldebt -- 负债合计
            ,alrliabilityratio -- 资产负债率
            ,cfncashreportperiod -- 经营活动-报告期
            ,cfncashreporttype -- 经营活动-报表类型
            ,cfncashflowamount -- 经营活动产生的现金流净额
            ,cfnnetreportperiod -- 净利息-报告期
            ,cfnnetreporttype -- 净利息-报表类型
            ,cfninterestcost -- 财务费用:利息费用
            ,cfninterestincome -- 财务费用:利息收入
            ,cfnnetinterestcost -- 净利息费用
            ,spatotalprofitflag -- 利润总额判定标识
            ,spaparentnetprofitflag -- 归属母公司净利润判定标识
            ,spanetprofitflag -- 净利润判定标识
            ,tfdreportperiod -- 财务数据-报告期
            ,tfdreporttype -- 财务数据-报表类型
            ,tfdreportdate -- 财务数据-录入日期
            ,tdereportperiod -- 按时披露-报告期
            ,tdereporttype -- 按时披露-报表类型
            ,tdereportdate -- 按时披露-录入日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,spacomprehensiveflag -- 综合收益总额判定标识
            ,spacomprehensivereportperiod -- 综合收益报告期
            ,spacomprehensivereporttype -- 综合收益报表类型
            ,spacomprehensiveincome -- 综合收益总额
            ,spaparentreportperiod -- 母公司综合收益报告期
            ,spaparentreporttype -- 母公司综合收益报表类型
            ,spaparentincome -- 综合收益总额（母公司）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_investment_client_according_op(
            serialno -- 流水号
            ,relserialno -- 关联认定表主键
            ,loslistedcompanyflag -- 是否上市企业判定标识
            ,loslistedcompany -- 是否上市公司
            ,loslistexchange -- 上市交易所
            ,losdurationbondflag -- 是否存续期内债券判定标识
            ,vlrperformedchecks -- 执行公开排查条数
            ,vlrsuspectchecks -- 罪犯及嫌疑人排查条数
            ,vlruncreditchecks -- 失信被执行人排查条数
            ,vlrviolationchecks -- 行政违法排查条数
            ,vlrhighvaluechecks -- 限制高消费排查条数
            ,vlrowingtaxeschecks -- 欠税排查条数
            ,vlrexitandentrychecks -- 限制出入境排查条数
            ,vlrimproperchecks -- 纳税非正常户排查条数
            ,vlrjudicativechecks -- 民商事裁判文书排查条数
            ,vlrfinalcasechecks -- 终本案件排查条数
            ,vlrtrialprocesschecks -- 民商事审判流程排查条数
            ,vlrprincipaltype -- 主体类型
            ,afaauditflag -- 审计标志
            ,afaauditopinion -- 审计意见
            ,afaauditreportdate -- 审计意见报表日期
            ,ddydebtdefaultflag -- 是否债务违约判定标识
            ,ddyclassifyresult -- 当前五级分类
            ,ddyclassifydate -- 当前分类日期
            ,egsassetsratio -- 担保总额占净资产比例
            ,egsillegalguarantees -- 违规担保总额
            ,iidindustrycategory -- 所属行业门类代码
            ,alrreportperiod -- 资产负债-报告期
            ,alrreporttype -- 资产负债-报表类型
            ,alrtotalassets -- 资产总计
            ,alrtotaldebt -- 负债合计
            ,alrliabilityratio -- 资产负债率
            ,cfncashreportperiod -- 经营活动-报告期
            ,cfncashreporttype -- 经营活动-报表类型
            ,cfncashflowamount -- 经营活动产生的现金流净额
            ,cfnnetreportperiod -- 净利息-报告期
            ,cfnnetreporttype -- 净利息-报表类型
            ,cfninterestcost -- 财务费用:利息费用
            ,cfninterestincome -- 财务费用:利息收入
            ,cfnnetinterestcost -- 净利息费用
            ,spatotalprofitflag -- 利润总额判定标识
            ,spaparentnetprofitflag -- 归属母公司净利润判定标识
            ,spanetprofitflag -- 净利润判定标识
            ,tfdreportperiod -- 财务数据-报告期
            ,tfdreporttype -- 财务数据-报表类型
            ,tfdreportdate -- 财务数据-录入日期
            ,tdereportperiod -- 按时披露-报告期
            ,tdereporttype -- 按时披露-报表类型
            ,tdereportdate -- 按时披露-录入日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,spacomprehensiveflag -- 综合收益总额判定标识
            ,spacomprehensivereportperiod -- 综合收益报告期
            ,spacomprehensivereporttype -- 综合收益报表类型
            ,spacomprehensiveincome -- 综合收益总额
            ,spaparentreportperiod -- 母公司综合收益报告期
            ,spaparentreporttype -- 母公司综合收益报表类型
            ,spaparentincome -- 综合收益总额（母公司）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.relserialno -- 关联认定表主键
    ,o.loslistedcompanyflag -- 是否上市企业判定标识
    ,o.loslistedcompany -- 是否上市公司
    ,o.loslistexchange -- 上市交易所
    ,o.losdurationbondflag -- 是否存续期内债券判定标识
    ,o.vlrperformedchecks -- 执行公开排查条数
    ,o.vlrsuspectchecks -- 罪犯及嫌疑人排查条数
    ,o.vlruncreditchecks -- 失信被执行人排查条数
    ,o.vlrviolationchecks -- 行政违法排查条数
    ,o.vlrhighvaluechecks -- 限制高消费排查条数
    ,o.vlrowingtaxeschecks -- 欠税排查条数
    ,o.vlrexitandentrychecks -- 限制出入境排查条数
    ,o.vlrimproperchecks -- 纳税非正常户排查条数
    ,o.vlrjudicativechecks -- 民商事裁判文书排查条数
    ,o.vlrfinalcasechecks -- 终本案件排查条数
    ,o.vlrtrialprocesschecks -- 民商事审判流程排查条数
    ,o.vlrprincipaltype -- 主体类型
    ,o.afaauditflag -- 审计标志
    ,o.afaauditopinion -- 审计意见
    ,o.afaauditreportdate -- 审计意见报表日期
    ,o.ddydebtdefaultflag -- 是否债务违约判定标识
    ,o.ddyclassifyresult -- 当前五级分类
    ,o.ddyclassifydate -- 当前分类日期
    ,o.egsassetsratio -- 担保总额占净资产比例
    ,o.egsillegalguarantees -- 违规担保总额
    ,o.iidindustrycategory -- 所属行业门类代码
    ,o.alrreportperiod -- 资产负债-报告期
    ,o.alrreporttype -- 资产负债-报表类型
    ,o.alrtotalassets -- 资产总计
    ,o.alrtotaldebt -- 负债合计
    ,o.alrliabilityratio -- 资产负债率
    ,o.cfncashreportperiod -- 经营活动-报告期
    ,o.cfncashreporttype -- 经营活动-报表类型
    ,o.cfncashflowamount -- 经营活动产生的现金流净额
    ,o.cfnnetreportperiod -- 净利息-报告期
    ,o.cfnnetreporttype -- 净利息-报表类型
    ,o.cfninterestcost -- 财务费用:利息费用
    ,o.cfninterestincome -- 财务费用:利息收入
    ,o.cfnnetinterestcost -- 净利息费用
    ,o.spatotalprofitflag -- 利润总额判定标识
    ,o.spaparentnetprofitflag -- 归属母公司净利润判定标识
    ,o.spanetprofitflag -- 净利润判定标识
    ,o.tfdreportperiod -- 财务数据-报告期
    ,o.tfdreporttype -- 财务数据-报表类型
    ,o.tfdreportdate -- 财务数据-录入日期
    ,o.tdereportperiod -- 按时披露-报告期
    ,o.tdereporttype -- 按时披露-报表类型
    ,o.tdereportdate -- 按时披露-录入日期
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.spacomprehensiveflag -- 综合收益总额判定标识
    ,o.spacomprehensivereportperiod -- 综合收益报告期
    ,o.spacomprehensivereporttype -- 综合收益报表类型
    ,o.spacomprehensiveincome -- 综合收益总额
    ,o.spaparentreportperiod -- 母公司综合收益报告期
    ,o.spaparentreporttype -- 母公司综合收益报表类型
    ,o.spaparentincome -- 综合收益总额（母公司）
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
from ${iol_schema}.icms_investment_client_according_bk o
    left join ${iol_schema}.icms_investment_client_according_op n
        on
            o.serialno = n.serialno
            and o.relserialno = n.relserialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_investment_client_according_cl d
        on
            o.serialno = d.serialno
            and o.relserialno = d.relserialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_investment_client_according;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_investment_client_according') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_investment_client_according drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_investment_client_according add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_investment_client_according exchange partition p_${batch_date} with table ${iol_schema}.icms_investment_client_according_cl;
alter table ${iol_schema}.icms_investment_client_according exchange partition p_20991231 with table ${iol_schema}.icms_investment_client_according_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_investment_client_according to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_investment_client_according_op purge;
drop table ${iol_schema}.icms_investment_client_according_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_investment_client_according_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_investment_client_according',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
