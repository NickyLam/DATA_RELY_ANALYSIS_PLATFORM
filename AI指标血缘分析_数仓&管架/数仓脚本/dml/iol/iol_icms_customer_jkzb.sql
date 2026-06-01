/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_jkzb
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
create table ${iol_schema}.icms_customer_jkzb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_jkzb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_jkzb_op purge;
drop table ${iol_schema}.icms_customer_jkzb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_jkzb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_jkzb where 0=1;

create table ${iol_schema}.icms_customer_jkzb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_jkzb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_jkzb_cl(
            serialno -- 流水号
            ,updateuserid -- 更新人编号
            ,yzldscale -- 优质流动性资产充足率（%）
            ,zygdjzb -- 自营固定收益类证券及证券衍生品/净资本
            ,rzzlscale -- 融资租赁质量偏离度（%）
            ,mrfsassets -- 买入返售金融资产（亿元）
            ,xtbcscale -- 信托报酬率（%）
            ,dykhrzscale -- 对单一客户融资业务规模与净资本比例（%）
            ,zqjzbscale -- 持有一种权益类证券的成本与净资本比例（%）
            ,jincome -- 净利润（亿元）
            ,yqcreditscale -- 逾期贷款比例（%）
            ,chbhscale -- 实际偿付能力额度变化率（%）
            ,cdscale1 -- 存贷比（%）——人民币
            ,gzcreditscale -- 关注贷款比例（%）
            ,ldfgscale -- 流动性覆盖率（%）
            ,dqbxscale -- 短期险保费收入增长率（%）
            ,badzlscale -- 不良融资租赁资产率（%）
            ,yskinvest -- 应收款项类投资（亿元）
            ,zbczscale -- 资本充足率（%）
            ,belongyear -- 指标所属年度
            ,llzhscale -- 两年综合成本率
            ,stockb -- 股本（亿元）
            ,inputtime -- 创建时间
            ,jzcfz -- 净资产/负债
            ,gzldkye -- 关注类贷款余额（万元）
            ,updatetime -- 更新时间
            ,ljckscale -- 累计外汇敞口头寸占资本净额比例
            ,yjzbscale -- 一级资本充足率（%）
            ,zlchannel -- 资料来源
            ,zlbfscale -- 自留保费增长率
            ,jsdgpscale -- 接受单只担保股票市值与该股票总市值比例（%）
            ,badrzzlscale -- 拨备覆盖不良融资租赁资产率（%）
            ,rjdqsczz -- 
            ,gainzb -- 净资本（亿元）
            ,ldxscale2 -- 流动性比例（%）——外币
            ,coreyjscale -- 核心一级资本充足率（%）
            ,dbscale -- 担保比例（%）
            ,zcsum -- 总资产（亿元）
            ,zzcscale -- 总资产收益率（%）（即资产利润率）
            ,dykhjzbscale -- 对单一客户融券业务规模与净资本比例（%）
            ,zqszscale -- 持有一种权益类证券市值与其总市值的比例（%）
            ,baddkye -- 不良贷款余额（万元）
            ,ldxscale1 -- 流动性比例（%）——人民币
            ,jwdzjscale -- 净稳定资金率（%）
            ,jzbjfz -- 净资本/负债
            ,dkssscale -- 贷款损失准备充足率（%）
            ,bdscale -- 拨贷比（即拨备覆盖率）（%）
            ,pjdlscale -- 平均代理证券业务净收入（亿元）
            ,cqtzscale -- 长期投资比例（%）
            ,dygdjzd -- 单一股东及其关联方授信集中度
            ,xtsrscale -- 信托业务收入占比（%）
            ,zbsyscale -- 资本收益率（%）（即资本利润率）
            ,bcreditpydscale -- 不良贷款与预期贷款偏离度（%）
            ,cfllscale -- 偿付能力充足率（%）
            ,jzbjzc -- 净资本/净资产
            ,stockdqy -- 股东权益（亿元）
            ,rjprofit -- 人均利润（万元）
            ,ditzscale -- 短期投资比例（%）
            ,tycrscale -- 同业拆入比例（%）
            ,cbsrscale -- 成本收入比（%）
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,cqbxscale -- 长期险保费收入增长率（%）
            ,bfzzscale -- 保费增长率
            ,zyqxjzb -- 自营权益类证券及证券衍生品/净资本
            ,fxfgscale -- 风险覆盖率（%）
            ,customerid -- 监管客户编号
            ,badscale -- 不良资产率（%）
            ,dyjtglscale -- 单一客户关联度（%）
            ,bfrzscale -- 批发性融资比例（%）
            ,dkzlzcgm -- 贷款/融资租赁资产规模
            ,ldxscale3 -- 流动性比例（%）——本外币
            ,businessjsr -- 营业净收入（亿元）
            ,fxtzzbscale -- 风险调整资本回报率（%）
            ,tbscale -- 退保率（%）
            ,dyjtsxscale -- 单一集团客户授信集中度（%）
            ,inputorg -- 操作人所在机构
            ,dqsczs -- 
            ,jtkfscale -- 集团客户关联度（%）
            ,yqbadzlscale -- 逾期90天以上融资租赁与不良融资租赁比例（%）
            ,zbjye -- 各项准备金余额（万元）
            ,zzggscale -- 资本杠杆率（%）
            ,dkscope -- 贷款规模（亿元）
            ,cdscale2 -- 存贷比（%）——外币
            ,cdscale3 -- 存贷比（%）——本外币
            ,jwdscale -- 净稳定资金比例（%）
            ,ldppscale -- 流动性匹配率（%）
            ,dyjtjzscale -- 单一客户集中度（%）
            ,badcreditscale -- 不良贷款比例（%）
            ,inputuser -- 操作人
            ,updateorgid -- 更新人所在机构编号
            ,zcglscope -- 资产管理规模（亿元）
            ,ckscope -- 存款规模（亿元）
            ,registercountrycode -- 注册国家代码
            ,countryrating -- 所在国家评级
            ,countrycapstandard -- 所在国家或地区监管部门的最低资本监管要求
            ,countryaddoncapital -- 所在国家或地区监管部门公开发布的监管法规中缓冲资本要求
            ,coretieronerate -- 核心一级资本充足率
            ,tieronerate -- 一级资本充足率
            ,capitaladeratio -- 资本充足率
            ,leveragerate -- 杠杆率
            ,auditcommnent -- 外部审计意见
            ,riskalert -- 尽职调查发现存在重大风险情形
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_jkzb_op(
            serialno -- 流水号
            ,updateuserid -- 更新人编号
            ,yzldscale -- 优质流动性资产充足率（%）
            ,zygdjzb -- 自营固定收益类证券及证券衍生品/净资本
            ,rzzlscale -- 融资租赁质量偏离度（%）
            ,mrfsassets -- 买入返售金融资产（亿元）
            ,xtbcscale -- 信托报酬率（%）
            ,dykhrzscale -- 对单一客户融资业务规模与净资本比例（%）
            ,zqjzbscale -- 持有一种权益类证券的成本与净资本比例（%）
            ,jincome -- 净利润（亿元）
            ,yqcreditscale -- 逾期贷款比例（%）
            ,chbhscale -- 实际偿付能力额度变化率（%）
            ,cdscale1 -- 存贷比（%）——人民币
            ,gzcreditscale -- 关注贷款比例（%）
            ,ldfgscale -- 流动性覆盖率（%）
            ,dqbxscale -- 短期险保费收入增长率（%）
            ,badzlscale -- 不良融资租赁资产率（%）
            ,yskinvest -- 应收款项类投资（亿元）
            ,zbczscale -- 资本充足率（%）
            ,belongyear -- 指标所属年度
            ,llzhscale -- 两年综合成本率
            ,stockb -- 股本（亿元）
            ,inputtime -- 创建时间
            ,jzcfz -- 净资产/负债
            ,gzldkye -- 关注类贷款余额（万元）
            ,updatetime -- 更新时间
            ,ljckscale -- 累计外汇敞口头寸占资本净额比例
            ,yjzbscale -- 一级资本充足率（%）
            ,zlchannel -- 资料来源
            ,zlbfscale -- 自留保费增长率
            ,jsdgpscale -- 接受单只担保股票市值与该股票总市值比例（%）
            ,badrzzlscale -- 拨备覆盖不良融资租赁资产率（%）
            ,rjdqsczz -- 
            ,gainzb -- 净资本（亿元）
            ,ldxscale2 -- 流动性比例（%）——外币
            ,coreyjscale -- 核心一级资本充足率（%）
            ,dbscale -- 担保比例（%）
            ,zcsum -- 总资产（亿元）
            ,zzcscale -- 总资产收益率（%）（即资产利润率）
            ,dykhjzbscale -- 对单一客户融券业务规模与净资本比例（%）
            ,zqszscale -- 持有一种权益类证券市值与其总市值的比例（%）
            ,baddkye -- 不良贷款余额（万元）
            ,ldxscale1 -- 流动性比例（%）——人民币
            ,jwdzjscale -- 净稳定资金率（%）
            ,jzbjfz -- 净资本/负债
            ,dkssscale -- 贷款损失准备充足率（%）
            ,bdscale -- 拨贷比（即拨备覆盖率）（%）
            ,pjdlscale -- 平均代理证券业务净收入（亿元）
            ,cqtzscale -- 长期投资比例（%）
            ,dygdjzd -- 单一股东及其关联方授信集中度
            ,xtsrscale -- 信托业务收入占比（%）
            ,zbsyscale -- 资本收益率（%）（即资本利润率）
            ,bcreditpydscale -- 不良贷款与预期贷款偏离度（%）
            ,cfllscale -- 偿付能力充足率（%）
            ,jzbjzc -- 净资本/净资产
            ,stockdqy -- 股东权益（亿元）
            ,rjprofit -- 人均利润（万元）
            ,ditzscale -- 短期投资比例（%）
            ,tycrscale -- 同业拆入比例（%）
            ,cbsrscale -- 成本收入比（%）
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,cqbxscale -- 长期险保费收入增长率（%）
            ,bfzzscale -- 保费增长率
            ,zyqxjzb -- 自营权益类证券及证券衍生品/净资本
            ,fxfgscale -- 风险覆盖率（%）
            ,customerid -- 监管客户编号
            ,badscale -- 不良资产率（%）
            ,dyjtglscale -- 单一客户关联度（%）
            ,bfrzscale -- 批发性融资比例（%）
            ,dkzlzcgm -- 贷款/融资租赁资产规模
            ,ldxscale3 -- 流动性比例（%）——本外币
            ,businessjsr -- 营业净收入（亿元）
            ,fxtzzbscale -- 风险调整资本回报率（%）
            ,tbscale -- 退保率（%）
            ,dyjtsxscale -- 单一集团客户授信集中度（%）
            ,inputorg -- 操作人所在机构
            ,dqsczs -- 
            ,jtkfscale -- 集团客户关联度（%）
            ,yqbadzlscale -- 逾期90天以上融资租赁与不良融资租赁比例（%）
            ,zbjye -- 各项准备金余额（万元）
            ,zzggscale -- 资本杠杆率（%）
            ,dkscope -- 贷款规模（亿元）
            ,cdscale2 -- 存贷比（%）——外币
            ,cdscale3 -- 存贷比（%）——本外币
            ,jwdscale -- 净稳定资金比例（%）
            ,ldppscale -- 流动性匹配率（%）
            ,dyjtjzscale -- 单一客户集中度（%）
            ,badcreditscale -- 不良贷款比例（%）
            ,inputuser -- 操作人
            ,updateorgid -- 更新人所在机构编号
            ,zcglscope -- 资产管理规模（亿元）
            ,ckscope -- 存款规模（亿元）
            ,registercountrycode -- 注册国家代码
            ,countryrating -- 所在国家评级
            ,countrycapstandard -- 所在国家或地区监管部门的最低资本监管要求
            ,countryaddoncapital -- 所在国家或地区监管部门公开发布的监管法规中缓冲资本要求
            ,coretieronerate -- 核心一级资本充足率
            ,tieronerate -- 一级资本充足率
            ,capitaladeratio -- 资本充足率
            ,leveragerate -- 杠杆率
            ,auditcommnent -- 外部审计意见
            ,riskalert -- 尽职调查发现存在重大风险情形
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人编号
    ,nvl(n.yzldscale, o.yzldscale) as yzldscale -- 优质流动性资产充足率（%）
    ,nvl(n.zygdjzb, o.zygdjzb) as zygdjzb -- 自营固定收益类证券及证券衍生品/净资本
    ,nvl(n.rzzlscale, o.rzzlscale) as rzzlscale -- 融资租赁质量偏离度（%）
    ,nvl(n.mrfsassets, o.mrfsassets) as mrfsassets -- 买入返售金融资产（亿元）
    ,nvl(n.xtbcscale, o.xtbcscale) as xtbcscale -- 信托报酬率（%）
    ,nvl(n.dykhrzscale, o.dykhrzscale) as dykhrzscale -- 对单一客户融资业务规模与净资本比例（%）
    ,nvl(n.zqjzbscale, o.zqjzbscale) as zqjzbscale -- 持有一种权益类证券的成本与净资本比例（%）
    ,nvl(n.jincome, o.jincome) as jincome -- 净利润（亿元）
    ,nvl(n.yqcreditscale, o.yqcreditscale) as yqcreditscale -- 逾期贷款比例（%）
    ,nvl(n.chbhscale, o.chbhscale) as chbhscale -- 实际偿付能力额度变化率（%）
    ,nvl(n.cdscale1, o.cdscale1) as cdscale1 -- 存贷比（%）——人民币
    ,nvl(n.gzcreditscale, o.gzcreditscale) as gzcreditscale -- 关注贷款比例（%）
    ,nvl(n.ldfgscale, o.ldfgscale) as ldfgscale -- 流动性覆盖率（%）
    ,nvl(n.dqbxscale, o.dqbxscale) as dqbxscale -- 短期险保费收入增长率（%）
    ,nvl(n.badzlscale, o.badzlscale) as badzlscale -- 不良融资租赁资产率（%）
    ,nvl(n.yskinvest, o.yskinvest) as yskinvest -- 应收款项类投资（亿元）
    ,nvl(n.zbczscale, o.zbczscale) as zbczscale -- 资本充足率（%）
    ,nvl(n.belongyear, o.belongyear) as belongyear -- 指标所属年度
    ,nvl(n.llzhscale, o.llzhscale) as llzhscale -- 两年综合成本率
    ,nvl(n.stockb, o.stockb) as stockb -- 股本（亿元）
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 创建时间
    ,nvl(n.jzcfz, o.jzcfz) as jzcfz -- 净资产/负债
    ,nvl(n.gzldkye, o.gzldkye) as gzldkye -- 关注类贷款余额（万元）
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.ljckscale, o.ljckscale) as ljckscale -- 累计外汇敞口头寸占资本净额比例
    ,nvl(n.yjzbscale, o.yjzbscale) as yjzbscale -- 一级资本充足率（%）
    ,nvl(n.zlchannel, o.zlchannel) as zlchannel -- 资料来源
    ,nvl(n.zlbfscale, o.zlbfscale) as zlbfscale -- 自留保费增长率
    ,nvl(n.jsdgpscale, o.jsdgpscale) as jsdgpscale -- 接受单只担保股票市值与该股票总市值比例（%）
    ,nvl(n.badrzzlscale, o.badrzzlscale) as badrzzlscale -- 拨备覆盖不良融资租赁资产率（%）
    ,nvl(n.rjdqsczz, o.rjdqsczz) as rjdqsczz -- 
    ,nvl(n.gainzb, o.gainzb) as gainzb -- 净资本（亿元）
    ,nvl(n.ldxscale2, o.ldxscale2) as ldxscale2 -- 流动性比例（%）——外币
    ,nvl(n.coreyjscale, o.coreyjscale) as coreyjscale -- 核心一级资本充足率（%）
    ,nvl(n.dbscale, o.dbscale) as dbscale -- 担保比例（%）
    ,nvl(n.zcsum, o.zcsum) as zcsum -- 总资产（亿元）
    ,nvl(n.zzcscale, o.zzcscale) as zzcscale -- 总资产收益率（%）（即资产利润率）
    ,nvl(n.dykhjzbscale, o.dykhjzbscale) as dykhjzbscale -- 对单一客户融券业务规模与净资本比例（%）
    ,nvl(n.zqszscale, o.zqszscale) as zqszscale -- 持有一种权益类证券市值与其总市值的比例（%）
    ,nvl(n.baddkye, o.baddkye) as baddkye -- 不良贷款余额（万元）
    ,nvl(n.ldxscale1, o.ldxscale1) as ldxscale1 -- 流动性比例（%）——人民币
    ,nvl(n.jwdzjscale, o.jwdzjscale) as jwdzjscale -- 净稳定资金率（%）
    ,nvl(n.jzbjfz, o.jzbjfz) as jzbjfz -- 净资本/负债
    ,nvl(n.dkssscale, o.dkssscale) as dkssscale -- 贷款损失准备充足率（%）
    ,nvl(n.bdscale, o.bdscale) as bdscale -- 拨贷比（即拨备覆盖率）（%）
    ,nvl(n.pjdlscale, o.pjdlscale) as pjdlscale -- 平均代理证券业务净收入（亿元）
    ,nvl(n.cqtzscale, o.cqtzscale) as cqtzscale -- 长期投资比例（%）
    ,nvl(n.dygdjzd, o.dygdjzd) as dygdjzd -- 单一股东及其关联方授信集中度
    ,nvl(n.xtsrscale, o.xtsrscale) as xtsrscale -- 信托业务收入占比（%）
    ,nvl(n.zbsyscale, o.zbsyscale) as zbsyscale -- 资本收益率（%）（即资本利润率）
    ,nvl(n.bcreditpydscale, o.bcreditpydscale) as bcreditpydscale -- 不良贷款与预期贷款偏离度（%）
    ,nvl(n.cfllscale, o.cfllscale) as cfllscale -- 偿付能力充足率（%）
    ,nvl(n.jzbjzc, o.jzbjzc) as jzbjzc -- 净资本/净资产
    ,nvl(n.stockdqy, o.stockdqy) as stockdqy -- 股东权益（亿元）
    ,nvl(n.rjprofit, o.rjprofit) as rjprofit -- 人均利润（万元）
    ,nvl(n.ditzscale, o.ditzscale) as ditzscale -- 短期投资比例（%）
    ,nvl(n.tycrscale, o.tycrscale) as tycrscale -- 同业拆入比例（%）
    ,nvl(n.cbsrscale, o.cbsrscale) as cbsrscale -- 成本收入比（%）
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.cqbxscale, o.cqbxscale) as cqbxscale -- 长期险保费收入增长率（%）
    ,nvl(n.bfzzscale, o.bfzzscale) as bfzzscale -- 保费增长率
    ,nvl(n.zyqxjzb, o.zyqxjzb) as zyqxjzb -- 自营权益类证券及证券衍生品/净资本
    ,nvl(n.fxfgscale, o.fxfgscale) as fxfgscale -- 风险覆盖率（%）
    ,nvl(n.customerid, o.customerid) as customerid -- 监管客户编号
    ,nvl(n.badscale, o.badscale) as badscale -- 不良资产率（%）
    ,nvl(n.dyjtglscale, o.dyjtglscale) as dyjtglscale -- 单一客户关联度（%）
    ,nvl(n.bfrzscale, o.bfrzscale) as bfrzscale -- 批发性融资比例（%）
    ,nvl(n.dkzlzcgm, o.dkzlzcgm) as dkzlzcgm -- 贷款/融资租赁资产规模
    ,nvl(n.ldxscale3, o.ldxscale3) as ldxscale3 -- 流动性比例（%）——本外币
    ,nvl(n.businessjsr, o.businessjsr) as businessjsr -- 营业净收入（亿元）
    ,nvl(n.fxtzzbscale, o.fxtzzbscale) as fxtzzbscale -- 风险调整资本回报率（%）
    ,nvl(n.tbscale, o.tbscale) as tbscale -- 退保率（%）
    ,nvl(n.dyjtsxscale, o.dyjtsxscale) as dyjtsxscale -- 单一集团客户授信集中度（%）
    ,nvl(n.inputorg, o.inputorg) as inputorg -- 操作人所在机构
    ,nvl(n.dqsczs, o.dqsczs) as dqsczs -- 
    ,nvl(n.jtkfscale, o.jtkfscale) as jtkfscale -- 集团客户关联度（%）
    ,nvl(n.yqbadzlscale, o.yqbadzlscale) as yqbadzlscale -- 逾期90天以上融资租赁与不良融资租赁比例（%）
    ,nvl(n.zbjye, o.zbjye) as zbjye -- 各项准备金余额（万元）
    ,nvl(n.zzggscale, o.zzggscale) as zzggscale -- 资本杠杆率（%）
    ,nvl(n.dkscope, o.dkscope) as dkscope -- 贷款规模（亿元）
    ,nvl(n.cdscale2, o.cdscale2) as cdscale2 -- 存贷比（%）——外币
    ,nvl(n.cdscale3, o.cdscale3) as cdscale3 -- 存贷比（%）——本外币
    ,nvl(n.jwdscale, o.jwdscale) as jwdscale -- 净稳定资金比例（%）
    ,nvl(n.ldppscale, o.ldppscale) as ldppscale -- 流动性匹配率（%）
    ,nvl(n.dyjtjzscale, o.dyjtjzscale) as dyjtjzscale -- 单一客户集中度（%）
    ,nvl(n.badcreditscale, o.badcreditscale) as badcreditscale -- 不良贷款比例（%）
    ,nvl(n.inputuser, o.inputuser) as inputuser -- 操作人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新人所在机构编号
    ,nvl(n.zcglscope, o.zcglscope) as zcglscope -- 资产管理规模（亿元）
    ,nvl(n.ckscope, o.ckscope) as ckscope -- 存款规模（亿元）
    ,nvl(n.registercountrycode, o.registercountrycode) as registercountrycode -- 注册国家代码
    ,nvl(n.countryrating, o.countryrating) as countryrating -- 所在国家评级
    ,nvl(n.countrycapstandard, o.countrycapstandard) as countrycapstandard -- 所在国家或地区监管部门的最低资本监管要求
    ,nvl(n.countryaddoncapital, o.countryaddoncapital) as countryaddoncapital -- 所在国家或地区监管部门公开发布的监管法规中缓冲资本要求
    ,nvl(n.coretieronerate, o.coretieronerate) as coretieronerate -- 核心一级资本充足率
    ,nvl(n.tieronerate, o.tieronerate) as tieronerate -- 一级资本充足率
    ,nvl(n.capitaladeratio, o.capitaladeratio) as capitaladeratio -- 资本充足率
    ,nvl(n.leveragerate, o.leveragerate) as leveragerate -- 杠杆率
    ,nvl(n.auditcommnent, o.auditcommnent) as auditcommnent -- 外部审计意见
    ,nvl(n.riskalert, o.riskalert) as riskalert -- 尽职调查发现存在重大风险情形
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_customer_jkzb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_jkzb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.updateuserid <> n.updateuserid
        or o.yzldscale <> n.yzldscale
        or o.zygdjzb <> n.zygdjzb
        or o.rzzlscale <> n.rzzlscale
        or o.mrfsassets <> n.mrfsassets
        or o.xtbcscale <> n.xtbcscale
        or o.dykhrzscale <> n.dykhrzscale
        or o.zqjzbscale <> n.zqjzbscale
        or o.jincome <> n.jincome
        or o.yqcreditscale <> n.yqcreditscale
        or o.chbhscale <> n.chbhscale
        or o.cdscale1 <> n.cdscale1
        or o.gzcreditscale <> n.gzcreditscale
        or o.ldfgscale <> n.ldfgscale
        or o.dqbxscale <> n.dqbxscale
        or o.badzlscale <> n.badzlscale
        or o.yskinvest <> n.yskinvest
        or o.zbczscale <> n.zbczscale
        or o.belongyear <> n.belongyear
        or o.llzhscale <> n.llzhscale
        or o.stockb <> n.stockb
        or o.inputtime <> n.inputtime
        or o.jzcfz <> n.jzcfz
        or o.gzldkye <> n.gzldkye
        or o.updatetime <> n.updatetime
        or o.ljckscale <> n.ljckscale
        or o.yjzbscale <> n.yjzbscale
        or o.zlchannel <> n.zlchannel
        or o.zlbfscale <> n.zlbfscale
        or o.jsdgpscale <> n.jsdgpscale
        or o.badrzzlscale <> n.badrzzlscale
        or o.rjdqsczz <> n.rjdqsczz
        or o.gainzb <> n.gainzb
        or o.ldxscale2 <> n.ldxscale2
        or o.coreyjscale <> n.coreyjscale
        or o.dbscale <> n.dbscale
        or o.zcsum <> n.zcsum
        or o.zzcscale <> n.zzcscale
        or o.dykhjzbscale <> n.dykhjzbscale
        or o.zqszscale <> n.zqszscale
        or o.baddkye <> n.baddkye
        or o.ldxscale1 <> n.ldxscale1
        or o.jwdzjscale <> n.jwdzjscale
        or o.jzbjfz <> n.jzbjfz
        or o.dkssscale <> n.dkssscale
        or o.bdscale <> n.bdscale
        or o.pjdlscale <> n.pjdlscale
        or o.cqtzscale <> n.cqtzscale
        or o.dygdjzd <> n.dygdjzd
        or o.xtsrscale <> n.xtsrscale
        or o.zbsyscale <> n.zbsyscale
        or o.bcreditpydscale <> n.bcreditpydscale
        or o.cfllscale <> n.cfllscale
        or o.jzbjzc <> n.jzbjzc
        or o.stockdqy <> n.stockdqy
        or o.rjprofit <> n.rjprofit
        or o.ditzscale <> n.ditzscale
        or o.tycrscale <> n.tycrscale
        or o.cbsrscale <> n.cbsrscale
        or o.migtflag <> n.migtflag
        or o.cqbxscale <> n.cqbxscale
        or o.bfzzscale <> n.bfzzscale
        or o.zyqxjzb <> n.zyqxjzb
        or o.fxfgscale <> n.fxfgscale
        or o.customerid <> n.customerid
        or o.badscale <> n.badscale
        or o.dyjtglscale <> n.dyjtglscale
        or o.bfrzscale <> n.bfrzscale
        or o.dkzlzcgm <> n.dkzlzcgm
        or o.ldxscale3 <> n.ldxscale3
        or o.businessjsr <> n.businessjsr
        or o.fxtzzbscale <> n.fxtzzbscale
        or o.tbscale <> n.tbscale
        or o.dyjtsxscale <> n.dyjtsxscale
        or o.inputorg <> n.inputorg
        or o.dqsczs <> n.dqsczs
        or o.jtkfscale <> n.jtkfscale
        or o.yqbadzlscale <> n.yqbadzlscale
        or o.zbjye <> n.zbjye
        or o.zzggscale <> n.zzggscale
        or o.dkscope <> n.dkscope
        or o.cdscale2 <> n.cdscale2
        or o.cdscale3 <> n.cdscale3
        or o.jwdscale <> n.jwdscale
        or o.ldppscale <> n.ldppscale
        or o.dyjtjzscale <> n.dyjtjzscale
        or o.badcreditscale <> n.badcreditscale
        or o.inputuser <> n.inputuser
        or o.updateorgid <> n.updateorgid
        or o.zcglscope <> n.zcglscope
        or o.ckscope <> n.ckscope
        or o.registercountrycode <> n.registercountrycode
        or o.countryrating <> n.countryrating
        or o.countrycapstandard <> n.countrycapstandard
        or o.countryaddoncapital <> n.countryaddoncapital
        or o.coretieronerate <> n.coretieronerate
        or o.tieronerate <> n.tieronerate
        or o.capitaladeratio <> n.capitaladeratio
        or o.leveragerate <> n.leveragerate
        or o.auditcommnent <> n.auditcommnent
        or o.riskalert <> n.riskalert
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_jkzb_cl(
            serialno -- 流水号
            ,updateuserid -- 更新人编号
            ,yzldscale -- 优质流动性资产充足率（%）
            ,zygdjzb -- 自营固定收益类证券及证券衍生品/净资本
            ,rzzlscale -- 融资租赁质量偏离度（%）
            ,mrfsassets -- 买入返售金融资产（亿元）
            ,xtbcscale -- 信托报酬率（%）
            ,dykhrzscale -- 对单一客户融资业务规模与净资本比例（%）
            ,zqjzbscale -- 持有一种权益类证券的成本与净资本比例（%）
            ,jincome -- 净利润（亿元）
            ,yqcreditscale -- 逾期贷款比例（%）
            ,chbhscale -- 实际偿付能力额度变化率（%）
            ,cdscale1 -- 存贷比（%）——人民币
            ,gzcreditscale -- 关注贷款比例（%）
            ,ldfgscale -- 流动性覆盖率（%）
            ,dqbxscale -- 短期险保费收入增长率（%）
            ,badzlscale -- 不良融资租赁资产率（%）
            ,yskinvest -- 应收款项类投资（亿元）
            ,zbczscale -- 资本充足率（%）
            ,belongyear -- 指标所属年度
            ,llzhscale -- 两年综合成本率
            ,stockb -- 股本（亿元）
            ,inputtime -- 创建时间
            ,jzcfz -- 净资产/负债
            ,gzldkye -- 关注类贷款余额（万元）
            ,updatetime -- 更新时间
            ,ljckscale -- 累计外汇敞口头寸占资本净额比例
            ,yjzbscale -- 一级资本充足率（%）
            ,zlchannel -- 资料来源
            ,zlbfscale -- 自留保费增长率
            ,jsdgpscale -- 接受单只担保股票市值与该股票总市值比例（%）
            ,badrzzlscale -- 拨备覆盖不良融资租赁资产率（%）
            ,rjdqsczz -- 
            ,gainzb -- 净资本（亿元）
            ,ldxscale2 -- 流动性比例（%）——外币
            ,coreyjscale -- 核心一级资本充足率（%）
            ,dbscale -- 担保比例（%）
            ,zcsum -- 总资产（亿元）
            ,zzcscale -- 总资产收益率（%）（即资产利润率）
            ,dykhjzbscale -- 对单一客户融券业务规模与净资本比例（%）
            ,zqszscale -- 持有一种权益类证券市值与其总市值的比例（%）
            ,baddkye -- 不良贷款余额（万元）
            ,ldxscale1 -- 流动性比例（%）——人民币
            ,jwdzjscale -- 净稳定资金率（%）
            ,jzbjfz -- 净资本/负债
            ,dkssscale -- 贷款损失准备充足率（%）
            ,bdscale -- 拨贷比（即拨备覆盖率）（%）
            ,pjdlscale -- 平均代理证券业务净收入（亿元）
            ,cqtzscale -- 长期投资比例（%）
            ,dygdjzd -- 单一股东及其关联方授信集中度
            ,xtsrscale -- 信托业务收入占比（%）
            ,zbsyscale -- 资本收益率（%）（即资本利润率）
            ,bcreditpydscale -- 不良贷款与预期贷款偏离度（%）
            ,cfllscale -- 偿付能力充足率（%）
            ,jzbjzc -- 净资本/净资产
            ,stockdqy -- 股东权益（亿元）
            ,rjprofit -- 人均利润（万元）
            ,ditzscale -- 短期投资比例（%）
            ,tycrscale -- 同业拆入比例（%）
            ,cbsrscale -- 成本收入比（%）
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,cqbxscale -- 长期险保费收入增长率（%）
            ,bfzzscale -- 保费增长率
            ,zyqxjzb -- 自营权益类证券及证券衍生品/净资本
            ,fxfgscale -- 风险覆盖率（%）
            ,customerid -- 监管客户编号
            ,badscale -- 不良资产率（%）
            ,dyjtglscale -- 单一客户关联度（%）
            ,bfrzscale -- 批发性融资比例（%）
            ,dkzlzcgm -- 贷款/融资租赁资产规模
            ,ldxscale3 -- 流动性比例（%）——本外币
            ,businessjsr -- 营业净收入（亿元）
            ,fxtzzbscale -- 风险调整资本回报率（%）
            ,tbscale -- 退保率（%）
            ,dyjtsxscale -- 单一集团客户授信集中度（%）
            ,inputorg -- 操作人所在机构
            ,dqsczs -- 
            ,jtkfscale -- 集团客户关联度（%）
            ,yqbadzlscale -- 逾期90天以上融资租赁与不良融资租赁比例（%）
            ,zbjye -- 各项准备金余额（万元）
            ,zzggscale -- 资本杠杆率（%）
            ,dkscope -- 贷款规模（亿元）
            ,cdscale2 -- 存贷比（%）——外币
            ,cdscale3 -- 存贷比（%）——本外币
            ,jwdscale -- 净稳定资金比例（%）
            ,ldppscale -- 流动性匹配率（%）
            ,dyjtjzscale -- 单一客户集中度（%）
            ,badcreditscale -- 不良贷款比例（%）
            ,inputuser -- 操作人
            ,updateorgid -- 更新人所在机构编号
            ,zcglscope -- 资产管理规模（亿元）
            ,ckscope -- 存款规模（亿元）
            ,registercountrycode -- 注册国家代码
            ,countryrating -- 所在国家评级
            ,countrycapstandard -- 所在国家或地区监管部门的最低资本监管要求
            ,countryaddoncapital -- 所在国家或地区监管部门公开发布的监管法规中缓冲资本要求
            ,coretieronerate -- 核心一级资本充足率
            ,tieronerate -- 一级资本充足率
            ,capitaladeratio -- 资本充足率
            ,leveragerate -- 杠杆率
            ,auditcommnent -- 外部审计意见
            ,riskalert -- 尽职调查发现存在重大风险情形
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_jkzb_op(
            serialno -- 流水号
            ,updateuserid -- 更新人编号
            ,yzldscale -- 优质流动性资产充足率（%）
            ,zygdjzb -- 自营固定收益类证券及证券衍生品/净资本
            ,rzzlscale -- 融资租赁质量偏离度（%）
            ,mrfsassets -- 买入返售金融资产（亿元）
            ,xtbcscale -- 信托报酬率（%）
            ,dykhrzscale -- 对单一客户融资业务规模与净资本比例（%）
            ,zqjzbscale -- 持有一种权益类证券的成本与净资本比例（%）
            ,jincome -- 净利润（亿元）
            ,yqcreditscale -- 逾期贷款比例（%）
            ,chbhscale -- 实际偿付能力额度变化率（%）
            ,cdscale1 -- 存贷比（%）——人民币
            ,gzcreditscale -- 关注贷款比例（%）
            ,ldfgscale -- 流动性覆盖率（%）
            ,dqbxscale -- 短期险保费收入增长率（%）
            ,badzlscale -- 不良融资租赁资产率（%）
            ,yskinvest -- 应收款项类投资（亿元）
            ,zbczscale -- 资本充足率（%）
            ,belongyear -- 指标所属年度
            ,llzhscale -- 两年综合成本率
            ,stockb -- 股本（亿元）
            ,inputtime -- 创建时间
            ,jzcfz -- 净资产/负债
            ,gzldkye -- 关注类贷款余额（万元）
            ,updatetime -- 更新时间
            ,ljckscale -- 累计外汇敞口头寸占资本净额比例
            ,yjzbscale -- 一级资本充足率（%）
            ,zlchannel -- 资料来源
            ,zlbfscale -- 自留保费增长率
            ,jsdgpscale -- 接受单只担保股票市值与该股票总市值比例（%）
            ,badrzzlscale -- 拨备覆盖不良融资租赁资产率（%）
            ,rjdqsczz -- 
            ,gainzb -- 净资本（亿元）
            ,ldxscale2 -- 流动性比例（%）——外币
            ,coreyjscale -- 核心一级资本充足率（%）
            ,dbscale -- 担保比例（%）
            ,zcsum -- 总资产（亿元）
            ,zzcscale -- 总资产收益率（%）（即资产利润率）
            ,dykhjzbscale -- 对单一客户融券业务规模与净资本比例（%）
            ,zqszscale -- 持有一种权益类证券市值与其总市值的比例（%）
            ,baddkye -- 不良贷款余额（万元）
            ,ldxscale1 -- 流动性比例（%）——人民币
            ,jwdzjscale -- 净稳定资金率（%）
            ,jzbjfz -- 净资本/负债
            ,dkssscale -- 贷款损失准备充足率（%）
            ,bdscale -- 拨贷比（即拨备覆盖率）（%）
            ,pjdlscale -- 平均代理证券业务净收入（亿元）
            ,cqtzscale -- 长期投资比例（%）
            ,dygdjzd -- 单一股东及其关联方授信集中度
            ,xtsrscale -- 信托业务收入占比（%）
            ,zbsyscale -- 资本收益率（%）（即资本利润率）
            ,bcreditpydscale -- 不良贷款与预期贷款偏离度（%）
            ,cfllscale -- 偿付能力充足率（%）
            ,jzbjzc -- 净资本/净资产
            ,stockdqy -- 股东权益（亿元）
            ,rjprofit -- 人均利润（万元）
            ,ditzscale -- 短期投资比例（%）
            ,tycrscale -- 同业拆入比例（%）
            ,cbsrscale -- 成本收入比（%）
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,cqbxscale -- 长期险保费收入增长率（%）
            ,bfzzscale -- 保费增长率
            ,zyqxjzb -- 自营权益类证券及证券衍生品/净资本
            ,fxfgscale -- 风险覆盖率（%）
            ,customerid -- 监管客户编号
            ,badscale -- 不良资产率（%）
            ,dyjtglscale -- 单一客户关联度（%）
            ,bfrzscale -- 批发性融资比例（%）
            ,dkzlzcgm -- 贷款/融资租赁资产规模
            ,ldxscale3 -- 流动性比例（%）——本外币
            ,businessjsr -- 营业净收入（亿元）
            ,fxtzzbscale -- 风险调整资本回报率（%）
            ,tbscale -- 退保率（%）
            ,dyjtsxscale -- 单一集团客户授信集中度（%）
            ,inputorg -- 操作人所在机构
            ,dqsczs -- 
            ,jtkfscale -- 集团客户关联度（%）
            ,yqbadzlscale -- 逾期90天以上融资租赁与不良融资租赁比例（%）
            ,zbjye -- 各项准备金余额（万元）
            ,zzggscale -- 资本杠杆率（%）
            ,dkscope -- 贷款规模（亿元）
            ,cdscale2 -- 存贷比（%）——外币
            ,cdscale3 -- 存贷比（%）——本外币
            ,jwdscale -- 净稳定资金比例（%）
            ,ldppscale -- 流动性匹配率（%）
            ,dyjtjzscale -- 单一客户集中度（%）
            ,badcreditscale -- 不良贷款比例（%）
            ,inputuser -- 操作人
            ,updateorgid -- 更新人所在机构编号
            ,zcglscope -- 资产管理规模（亿元）
            ,ckscope -- 存款规模（亿元）
            ,registercountrycode -- 注册国家代码
            ,countryrating -- 所在国家评级
            ,countrycapstandard -- 所在国家或地区监管部门的最低资本监管要求
            ,countryaddoncapital -- 所在国家或地区监管部门公开发布的监管法规中缓冲资本要求
            ,coretieronerate -- 核心一级资本充足率
            ,tieronerate -- 一级资本充足率
            ,capitaladeratio -- 资本充足率
            ,leveragerate -- 杠杆率
            ,auditcommnent -- 外部审计意见
            ,riskalert -- 尽职调查发现存在重大风险情形
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.updateuserid -- 更新人编号
    ,o.yzldscale -- 优质流动性资产充足率（%）
    ,o.zygdjzb -- 自营固定收益类证券及证券衍生品/净资本
    ,o.rzzlscale -- 融资租赁质量偏离度（%）
    ,o.mrfsassets -- 买入返售金融资产（亿元）
    ,o.xtbcscale -- 信托报酬率（%）
    ,o.dykhrzscale -- 对单一客户融资业务规模与净资本比例（%）
    ,o.zqjzbscale -- 持有一种权益类证券的成本与净资本比例（%）
    ,o.jincome -- 净利润（亿元）
    ,o.yqcreditscale -- 逾期贷款比例（%）
    ,o.chbhscale -- 实际偿付能力额度变化率（%）
    ,o.cdscale1 -- 存贷比（%）——人民币
    ,o.gzcreditscale -- 关注贷款比例（%）
    ,o.ldfgscale -- 流动性覆盖率（%）
    ,o.dqbxscale -- 短期险保费收入增长率（%）
    ,o.badzlscale -- 不良融资租赁资产率（%）
    ,o.yskinvest -- 应收款项类投资（亿元）
    ,o.zbczscale -- 资本充足率（%）
    ,o.belongyear -- 指标所属年度
    ,o.llzhscale -- 两年综合成本率
    ,o.stockb -- 股本（亿元）
    ,o.inputtime -- 创建时间
    ,o.jzcfz -- 净资产/负债
    ,o.gzldkye -- 关注类贷款余额（万元）
    ,o.updatetime -- 更新时间
    ,o.ljckscale -- 累计外汇敞口头寸占资本净额比例
    ,o.yjzbscale -- 一级资本充足率（%）
    ,o.zlchannel -- 资料来源
    ,o.zlbfscale -- 自留保费增长率
    ,o.jsdgpscale -- 接受单只担保股票市值与该股票总市值比例（%）
    ,o.badrzzlscale -- 拨备覆盖不良融资租赁资产率（%）
    ,o.rjdqsczz -- 
    ,o.gainzb -- 净资本（亿元）
    ,o.ldxscale2 -- 流动性比例（%）——外币
    ,o.coreyjscale -- 核心一级资本充足率（%）
    ,o.dbscale -- 担保比例（%）
    ,o.zcsum -- 总资产（亿元）
    ,o.zzcscale -- 总资产收益率（%）（即资产利润率）
    ,o.dykhjzbscale -- 对单一客户融券业务规模与净资本比例（%）
    ,o.zqszscale -- 持有一种权益类证券市值与其总市值的比例（%）
    ,o.baddkye -- 不良贷款余额（万元）
    ,o.ldxscale1 -- 流动性比例（%）——人民币
    ,o.jwdzjscale -- 净稳定资金率（%）
    ,o.jzbjfz -- 净资本/负债
    ,o.dkssscale -- 贷款损失准备充足率（%）
    ,o.bdscale -- 拨贷比（即拨备覆盖率）（%）
    ,o.pjdlscale -- 平均代理证券业务净收入（亿元）
    ,o.cqtzscale -- 长期投资比例（%）
    ,o.dygdjzd -- 单一股东及其关联方授信集中度
    ,o.xtsrscale -- 信托业务收入占比（%）
    ,o.zbsyscale -- 资本收益率（%）（即资本利润率）
    ,o.bcreditpydscale -- 不良贷款与预期贷款偏离度（%）
    ,o.cfllscale -- 偿付能力充足率（%）
    ,o.jzbjzc -- 净资本/净资产
    ,o.stockdqy -- 股东权益（亿元）
    ,o.rjprofit -- 人均利润（万元）
    ,o.ditzscale -- 短期投资比例（%）
    ,o.tycrscale -- 同业拆入比例（%）
    ,o.cbsrscale -- 成本收入比（%）
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.cqbxscale -- 长期险保费收入增长率（%）
    ,o.bfzzscale -- 保费增长率
    ,o.zyqxjzb -- 自营权益类证券及证券衍生品/净资本
    ,o.fxfgscale -- 风险覆盖率（%）
    ,o.customerid -- 监管客户编号
    ,o.badscale -- 不良资产率（%）
    ,o.dyjtglscale -- 单一客户关联度（%）
    ,o.bfrzscale -- 批发性融资比例（%）
    ,o.dkzlzcgm -- 贷款/融资租赁资产规模
    ,o.ldxscale3 -- 流动性比例（%）——本外币
    ,o.businessjsr -- 营业净收入（亿元）
    ,o.fxtzzbscale -- 风险调整资本回报率（%）
    ,o.tbscale -- 退保率（%）
    ,o.dyjtsxscale -- 单一集团客户授信集中度（%）
    ,o.inputorg -- 操作人所在机构
    ,o.dqsczs -- 
    ,o.jtkfscale -- 集团客户关联度（%）
    ,o.yqbadzlscale -- 逾期90天以上融资租赁与不良融资租赁比例（%）
    ,o.zbjye -- 各项准备金余额（万元）
    ,o.zzggscale -- 资本杠杆率（%）
    ,o.dkscope -- 贷款规模（亿元）
    ,o.cdscale2 -- 存贷比（%）——外币
    ,o.cdscale3 -- 存贷比（%）——本外币
    ,o.jwdscale -- 净稳定资金比例（%）
    ,o.ldppscale -- 流动性匹配率（%）
    ,o.dyjtjzscale -- 单一客户集中度（%）
    ,o.badcreditscale -- 不良贷款比例（%）
    ,o.inputuser -- 操作人
    ,o.updateorgid -- 更新人所在机构编号
    ,o.zcglscope -- 资产管理规模（亿元）
    ,o.ckscope -- 存款规模（亿元）
    ,o.registercountrycode -- 注册国家代码
    ,o.countryrating -- 所在国家评级
    ,o.countrycapstandard -- 所在国家或地区监管部门的最低资本监管要求
    ,o.countryaddoncapital -- 所在国家或地区监管部门公开发布的监管法规中缓冲资本要求
    ,o.coretieronerate -- 核心一级资本充足率
    ,o.tieronerate -- 一级资本充足率
    ,o.capitaladeratio -- 资本充足率
    ,o.leveragerate -- 杠杆率
    ,o.auditcommnent -- 外部审计意见
    ,o.riskalert -- 尽职调查发现存在重大风险情形
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
from ${iol_schema}.icms_customer_jkzb_bk o
    left join ${iol_schema}.icms_customer_jkzb_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_jkzb_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_customer_jkzb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_jkzb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_jkzb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_jkzb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_jkzb exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_jkzb_cl;
alter table ${iol_schema}.icms_customer_jkzb exchange partition p_20991231 with table ${iol_schema}.icms_customer_jkzb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_jkzb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_jkzb_op purge;
drop table ${iol_schema}.icms_customer_jkzb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_jkzb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_jkzb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
