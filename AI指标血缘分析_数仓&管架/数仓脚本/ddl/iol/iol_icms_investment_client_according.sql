/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_investment_client_according
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_investment_client_according
whenever sqlerror continue none;
drop table ${iol_schema}.icms_investment_client_according purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_investment_client_according(
    serialno varchar2(32) -- 流水号
    ,relserialno varchar2(32) -- 关联认定表主键
    ,loslistedcompanyflag varchar2(10) -- 是否上市企业判定标识
    ,loslistedcompany varchar2(10) -- 是否上市公司
    ,loslistexchange varchar2(64) -- 上市交易所
    ,losdurationbondflag varchar2(10) -- 是否存续期内债券判定标识
    ,vlrperformedchecks number(38) -- 执行公开排查条数
    ,vlrsuspectchecks number(38) -- 罪犯及嫌疑人排查条数
    ,vlruncreditchecks number(38) -- 失信被执行人排查条数
    ,vlrviolationchecks number(38) -- 行政违法排查条数
    ,vlrhighvaluechecks number(38) -- 限制高消费排查条数
    ,vlrowingtaxeschecks number(38) -- 欠税排查条数
    ,vlrexitandentrychecks number(38) -- 限制出入境排查条数
    ,vlrimproperchecks number(38) -- 纳税非正常户排查条数
    ,vlrjudicativechecks number(38) -- 民商事裁判文书排查条数
    ,vlrfinalcasechecks number(38) -- 终本案件排查条数
    ,vlrtrialprocesschecks number(38) -- 民商事审判流程排查条数
    ,vlrprincipaltype varchar2(10) -- 主体类型
    ,afaauditflag varchar2(10) -- 审计标志
    ,afaauditopinion varchar2(1000) -- 审计意见
    ,afaauditreportdate date -- 审计意见报表日期
    ,ddydebtdefaultflag varchar2(10) -- 是否债务违约判定标识
    ,ddyclassifyresult varchar2(10) -- 当前五级分类
    ,ddyclassifydate date -- 当前分类日期
    ,egsassetsratio varchar2(10) -- 担保总额占净资产比例
    ,egsillegalguarantees number(24,6) -- 违规担保总额
    ,iidindustrycategory varchar2(10) -- 所属行业门类代码
    ,alrreportperiod varchar2(32) -- 资产负债-报告期
    ,alrreporttype varchar2(32) -- 资产负债-报表类型
    ,alrtotalassets number(24,6) -- 资产总计
    ,alrtotaldebt number(24,6) -- 负债合计
    ,alrliabilityratio number(24,6) -- 资产负债率
    ,cfncashreportperiod varchar2(32) -- 经营活动-报告期
    ,cfncashreporttype varchar2(32) -- 经营活动-报表类型
    ,cfncashflowamount varchar2(32) -- 经营活动产生的现金流净额
    ,cfnnetreportperiod varchar2(32) -- 净利息-报告期
    ,cfnnetreporttype varchar2(32) -- 净利息-报表类型
    ,cfninterestcost number(24,6) -- 财务费用:利息费用
    ,cfninterestincome number(24,6) -- 财务费用:利息收入
    ,cfnnetinterestcost number(24,6) -- 净利息费用
    ,spatotalprofitflag varchar2(10) -- 利润总额判定标识
    ,spaparentnetprofitflag varchar2(10) -- 归属母公司净利润判定标识
    ,spanetprofitflag varchar2(10) -- 净利润判定标识
    ,tfdreportperiod varchar2(32) -- 财务数据-报告期
    ,tfdreporttype varchar2(32) -- 财务数据-报表类型
    ,tfdreportdate date -- 财务数据-录入日期
    ,tdereportperiod varchar2(32) -- 按时披露-报告期
    ,tdereporttype varchar2(32) -- 按时披露-报表类型
    ,tdereportdate date -- 按时披露-录入日期
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,spacomprehensiveflag varchar2(10) -- 综合收益总额判定标识
    ,spacomprehensivereportperiod varchar2(32) -- 综合收益报告期
    ,spacomprehensivereporttype varchar2(32) -- 综合收益报表类型
    ,spacomprehensiveincome number(24,6) -- 综合收益总额
    ,spaparentreportperiod varchar2(32) -- 母公司综合收益报告期
    ,spaparentreporttype varchar2(32) -- 母公司综合收益报表类型
    ,spaparentincome number(24,6) -- 综合收益总额（母公司）
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
grant select on ${iol_schema}.icms_investment_client_according to ${iml_schema};
grant select on ${iol_schema}.icms_investment_client_according to ${icl_schema};
grant select on ${iol_schema}.icms_investment_client_according to ${idl_schema};
grant select on ${iol_schema}.icms_investment_client_according to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_investment_client_according is '投资级客户判断依据';
comment on column ${iol_schema}.icms_investment_client_according.serialno is '流水号';
comment on column ${iol_schema}.icms_investment_client_according.relserialno is '关联认定表主键';
comment on column ${iol_schema}.icms_investment_client_according.loslistedcompanyflag is '是否上市企业判定标识';
comment on column ${iol_schema}.icms_investment_client_according.loslistedcompany is '是否上市公司';
comment on column ${iol_schema}.icms_investment_client_according.loslistexchange is '上市交易所';
comment on column ${iol_schema}.icms_investment_client_according.losdurationbondflag is '是否存续期内债券判定标识';
comment on column ${iol_schema}.icms_investment_client_according.vlrperformedchecks is '执行公开排查条数';
comment on column ${iol_schema}.icms_investment_client_according.vlrsuspectchecks is '罪犯及嫌疑人排查条数';
comment on column ${iol_schema}.icms_investment_client_according.vlruncreditchecks is '失信被执行人排查条数';
comment on column ${iol_schema}.icms_investment_client_according.vlrviolationchecks is '行政违法排查条数';
comment on column ${iol_schema}.icms_investment_client_according.vlrhighvaluechecks is '限制高消费排查条数';
comment on column ${iol_schema}.icms_investment_client_according.vlrowingtaxeschecks is '欠税排查条数';
comment on column ${iol_schema}.icms_investment_client_according.vlrexitandentrychecks is '限制出入境排查条数';
comment on column ${iol_schema}.icms_investment_client_according.vlrimproperchecks is '纳税非正常户排查条数';
comment on column ${iol_schema}.icms_investment_client_according.vlrjudicativechecks is '民商事裁判文书排查条数';
comment on column ${iol_schema}.icms_investment_client_according.vlrfinalcasechecks is '终本案件排查条数';
comment on column ${iol_schema}.icms_investment_client_according.vlrtrialprocesschecks is '民商事审判流程排查条数';
comment on column ${iol_schema}.icms_investment_client_according.vlrprincipaltype is '主体类型';
comment on column ${iol_schema}.icms_investment_client_according.afaauditflag is '审计标志';
comment on column ${iol_schema}.icms_investment_client_according.afaauditopinion is '审计意见';
comment on column ${iol_schema}.icms_investment_client_according.afaauditreportdate is '审计意见报表日期';
comment on column ${iol_schema}.icms_investment_client_according.ddydebtdefaultflag is '是否债务违约判定标识';
comment on column ${iol_schema}.icms_investment_client_according.ddyclassifyresult is '当前五级分类';
comment on column ${iol_schema}.icms_investment_client_according.ddyclassifydate is '当前分类日期';
comment on column ${iol_schema}.icms_investment_client_according.egsassetsratio is '担保总额占净资产比例';
comment on column ${iol_schema}.icms_investment_client_according.egsillegalguarantees is '违规担保总额';
comment on column ${iol_schema}.icms_investment_client_according.iidindustrycategory is '所属行业门类代码';
comment on column ${iol_schema}.icms_investment_client_according.alrreportperiod is '资产负债-报告期';
comment on column ${iol_schema}.icms_investment_client_according.alrreporttype is '资产负债-报表类型';
comment on column ${iol_schema}.icms_investment_client_according.alrtotalassets is '资产总计';
comment on column ${iol_schema}.icms_investment_client_according.alrtotaldebt is '负债合计';
comment on column ${iol_schema}.icms_investment_client_according.alrliabilityratio is '资产负债率';
comment on column ${iol_schema}.icms_investment_client_according.cfncashreportperiod is '经营活动-报告期';
comment on column ${iol_schema}.icms_investment_client_according.cfncashreporttype is '经营活动-报表类型';
comment on column ${iol_schema}.icms_investment_client_according.cfncashflowamount is '经营活动产生的现金流净额';
comment on column ${iol_schema}.icms_investment_client_according.cfnnetreportperiod is '净利息-报告期';
comment on column ${iol_schema}.icms_investment_client_according.cfnnetreporttype is '净利息-报表类型';
comment on column ${iol_schema}.icms_investment_client_according.cfninterestcost is '财务费用:利息费用';
comment on column ${iol_schema}.icms_investment_client_according.cfninterestincome is '财务费用:利息收入';
comment on column ${iol_schema}.icms_investment_client_according.cfnnetinterestcost is '净利息费用';
comment on column ${iol_schema}.icms_investment_client_according.spatotalprofitflag is '利润总额判定标识';
comment on column ${iol_schema}.icms_investment_client_according.spaparentnetprofitflag is '归属母公司净利润判定标识';
comment on column ${iol_schema}.icms_investment_client_according.spanetprofitflag is '净利润判定标识';
comment on column ${iol_schema}.icms_investment_client_according.tfdreportperiod is '财务数据-报告期';
comment on column ${iol_schema}.icms_investment_client_according.tfdreporttype is '财务数据-报表类型';
comment on column ${iol_schema}.icms_investment_client_according.tfdreportdate is '财务数据-录入日期';
comment on column ${iol_schema}.icms_investment_client_according.tdereportperiod is '按时披露-报告期';
comment on column ${iol_schema}.icms_investment_client_according.tdereporttype is '按时披露-报表类型';
comment on column ${iol_schema}.icms_investment_client_according.tdereportdate is '按时披露-录入日期';
comment on column ${iol_schema}.icms_investment_client_according.inputuserid is '登记人';
comment on column ${iol_schema}.icms_investment_client_according.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_investment_client_according.inputdate is '登记日期';
comment on column ${iol_schema}.icms_investment_client_according.updateuserid is '更新人';
comment on column ${iol_schema}.icms_investment_client_according.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_investment_client_according.updatedate is '更新日期';
comment on column ${iol_schema}.icms_investment_client_according.spacomprehensiveflag is '综合收益总额判定标识';
comment on column ${iol_schema}.icms_investment_client_according.spacomprehensivereportperiod is '综合收益报告期';
comment on column ${iol_schema}.icms_investment_client_according.spacomprehensivereporttype is '综合收益报表类型';
comment on column ${iol_schema}.icms_investment_client_according.spacomprehensiveincome is '综合收益总额';
comment on column ${iol_schema}.icms_investment_client_according.spaparentreportperiod is '母公司综合收益报告期';
comment on column ${iol_schema}.icms_investment_client_according.spaparentreporttype is '母公司综合收益报表类型';
comment on column ${iol_schema}.icms_investment_client_according.spaparentincome is '综合收益总额（母公司）';
comment on column ${iol_schema}.icms_investment_client_according.start_dt is '开始时间';
comment on column ${iol_schema}.icms_investment_client_according.end_dt is '结束时间';
comment on column ${iol_schema}.icms_investment_client_according.id_mark is '增删标志';
comment on column ${iol_schema}.icms_investment_client_according.etl_timestamp is 'ETL处理时间戳';
