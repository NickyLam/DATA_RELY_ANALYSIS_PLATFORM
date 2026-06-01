/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_business_fatou_putout
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
create table ${iol_schema}.icms_business_fatou_putout_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_business_fatou_putout
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_business_fatou_putout_op purge;
drop table ${iol_schema}.icms_business_fatou_putout_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_business_fatou_putout_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_business_fatou_putout where 0=1;

create table ${iol_schema}.icms_business_fatou_putout_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_business_fatou_putout where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_business_fatou_putout_cl(
            serialno -- 流水号
            ,businessrate -- 正常贷款执行利率
            ,lontyp -- 透支还款方式
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,odrputoutdate -- 法透额度起始日
            ,loanam -- 透支额度
            ,odrmaturity -- 法透额度到期日
            ,contractsum -- 合同金额
            ,operateuserid -- 经办人
            ,overduefloat -- 逾期贷款利率浮动
            ,lncmam -- 透支承诺费
            ,odrnextmonth -- 法透不跨月
            ,inputorgid -- 登记机构
            ,lendingorgid -- 贷款机构
            ,rategenre -- 新重定价方式
            ,businesstype -- 业务品种
            ,farmingloanuse -- 涉农贷款投向
            ,migtflag -- 
            ,careerguaranteeloantype -- 创业担保贷款类型
            ,ratefloat -- 正常贷款利率浮动
            ,oblopt -- 使用余额选择
            ,isputout -- 是否出账通过
            ,businesscurrency -- 币种
            ,iscareerguaranteeloan -- 是否创业担保贷款(1是0否)
            ,directionnew -- 行业投向17年版（最新）
            ,farmingloantype -- 涉农贷款主体类型
            ,tempsaveflag -- 暂存标志
            ,accountno1 -- 透支户账号
            ,baserate -- 基准利率
            ,operatedate -- 经办日期
            ,lprtype -- 基准利率选择LPR的取值方式（1最新LPR2首笔LPR）
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,customername -- 透支客户名称
            ,directionrs -- 行业投向（征信）
            ,isfarming -- 是否涉农(1是0否)
            ,contractserialno -- 合同流水号
            ,customerid -- 透支客户号
            ,baseratetype -- 基准利率类型
            ,bengdt -- 业务提醒短信发送时机
            ,daynum -- 单笔透支有效天数
            ,overduerate -- 逾期贷款执行利率
            ,ovdrmi -- 起透金额
            ,odrfreeinterest -- 法透不跨月免息天数
            ,platformpaycashsource -- 地方融资平台偿债资金来源分类
            ,loanhandlechannel -- 贷款办理渠道
            ,inputdate -- 输入日期
            ,acceptinttype -- 结息方式
            ,whitelist -- 白名单
            ,sectionalinterest -- 是否靠档计息
            ,frecharger -- 收费频率（按月、按日）码值：refreq
            ,binllingday -- 收费日
            ,artificialno -- 文本合同号
            ,subsac -- 透支账户子户号
            ,maintp -- 维护类型
            ,agrbdt -- 协议法透额度有效期起始日
            ,agredt -- 协议法透额度有效期结束日
            ,purpose -- 资金用途
            ,ovtype -- 日间隔夜透支类型
            ,flrttp -- 利率浮动类型
            ,feeivl -- 手续费费率
            ,tyflag -- 对公同业法透类型
            ,tzrate -- 透支利率
            ,agreementid -- 协议编号
            ,status -- 任务状态
            ,feedate -- 手续费收费日
            ,overduefloatcycle -- 利率浮动周期
            ,overduefloatmodel -- 利率浮动方式
            ,feefrequency -- 手续费收费频率
            ,feemodel -- 手续费收取方式
            ,feerate -- 手续费收费比率
            ,issupplychainfinance -- 是否为供应链金融业务
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,inputtime -- 
            ,ecodepartmentcode -- 
            ,entscale -- 
            ,classifyresulteleven -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_business_fatou_putout_op(
            serialno -- 流水号
            ,businessrate -- 正常贷款执行利率
            ,lontyp -- 透支还款方式
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,odrputoutdate -- 法透额度起始日
            ,loanam -- 透支额度
            ,odrmaturity -- 法透额度到期日
            ,contractsum -- 合同金额
            ,operateuserid -- 经办人
            ,overduefloat -- 逾期贷款利率浮动
            ,lncmam -- 透支承诺费
            ,odrnextmonth -- 法透不跨月
            ,inputorgid -- 登记机构
            ,lendingorgid -- 贷款机构
            ,rategenre -- 新重定价方式
            ,businesstype -- 业务品种
            ,farmingloanuse -- 涉农贷款投向
            ,migtflag -- 
            ,careerguaranteeloantype -- 创业担保贷款类型
            ,ratefloat -- 正常贷款利率浮动
            ,oblopt -- 使用余额选择
            ,isputout -- 是否出账通过
            ,businesscurrency -- 币种
            ,iscareerguaranteeloan -- 是否创业担保贷款(1是0否)
            ,directionnew -- 行业投向17年版（最新）
            ,farmingloantype -- 涉农贷款主体类型
            ,tempsaveflag -- 暂存标志
            ,accountno1 -- 透支户账号
            ,baserate -- 基准利率
            ,operatedate -- 经办日期
            ,lprtype -- 基准利率选择LPR的取值方式（1最新LPR2首笔LPR）
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,customername -- 透支客户名称
            ,directionrs -- 行业投向（征信）
            ,isfarming -- 是否涉农(1是0否)
            ,contractserialno -- 合同流水号
            ,customerid -- 透支客户号
            ,baseratetype -- 基准利率类型
            ,bengdt -- 业务提醒短信发送时机
            ,daynum -- 单笔透支有效天数
            ,overduerate -- 逾期贷款执行利率
            ,ovdrmi -- 起透金额
            ,odrfreeinterest -- 法透不跨月免息天数
            ,platformpaycashsource -- 地方融资平台偿债资金来源分类
            ,loanhandlechannel -- 贷款办理渠道
            ,inputdate -- 输入日期
            ,acceptinttype -- 结息方式
            ,whitelist -- 白名单
            ,sectionalinterest -- 是否靠档计息
            ,frecharger -- 收费频率（按月、按日）码值：refreq
            ,binllingday -- 收费日
            ,artificialno -- 文本合同号
            ,subsac -- 透支账户子户号
            ,maintp -- 维护类型
            ,agrbdt -- 协议法透额度有效期起始日
            ,agredt -- 协议法透额度有效期结束日
            ,purpose -- 资金用途
            ,ovtype -- 日间隔夜透支类型
            ,flrttp -- 利率浮动类型
            ,feeivl -- 手续费费率
            ,tyflag -- 对公同业法透类型
            ,tzrate -- 透支利率
            ,agreementid -- 协议编号
            ,status -- 任务状态
            ,feedate -- 手续费收费日
            ,overduefloatcycle -- 利率浮动周期
            ,overduefloatmodel -- 利率浮动方式
            ,feefrequency -- 手续费收费频率
            ,feemodel -- 手续费收取方式
            ,feerate -- 手续费收费比率
            ,issupplychainfinance -- 是否为供应链金融业务
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,inputtime -- 
            ,ecodepartmentcode -- 
            ,entscale -- 
            ,classifyresulteleven -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.businessrate, o.businessrate) as businessrate -- 正常贷款执行利率
    ,nvl(n.lontyp, o.lontyp) as lontyp -- 透支还款方式
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.odrputoutdate, o.odrputoutdate) as odrputoutdate -- 法透额度起始日
    ,nvl(n.loanam, o.loanam) as loanam -- 透支额度
    ,nvl(n.odrmaturity, o.odrmaturity) as odrmaturity -- 法透额度到期日
    ,nvl(n.contractsum, o.contractsum) as contractsum -- 合同金额
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 经办人
    ,nvl(n.overduefloat, o.overduefloat) as overduefloat -- 逾期贷款利率浮动
    ,nvl(n.lncmam, o.lncmam) as lncmam -- 透支承诺费
    ,nvl(n.odrnextmonth, o.odrnextmonth) as odrnextmonth -- 法透不跨月
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.lendingorgid, o.lendingorgid) as lendingorgid -- 贷款机构
    ,nvl(n.rategenre, o.rategenre) as rategenre -- 新重定价方式
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 业务品种
    ,nvl(n.farmingloanuse, o.farmingloanuse) as farmingloanuse -- 涉农贷款投向
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.careerguaranteeloantype, o.careerguaranteeloantype) as careerguaranteeloantype -- 创业担保贷款类型
    ,nvl(n.ratefloat, o.ratefloat) as ratefloat -- 正常贷款利率浮动
    ,nvl(n.oblopt, o.oblopt) as oblopt -- 使用余额选择
    ,nvl(n.isputout, o.isputout) as isputout -- 是否出账通过
    ,nvl(n.businesscurrency, o.businesscurrency) as businesscurrency -- 币种
    ,nvl(n.iscareerguaranteeloan, o.iscareerguaranteeloan) as iscareerguaranteeloan -- 是否创业担保贷款(1是0否)
    ,nvl(n.directionnew, o.directionnew) as directionnew -- 行业投向17年版（最新）
    ,nvl(n.farmingloantype, o.farmingloantype) as farmingloantype -- 涉农贷款主体类型
    ,nvl(n.tempsaveflag, o.tempsaveflag) as tempsaveflag -- 暂存标志
    ,nvl(n.accountno1, o.accountno1) as accountno1 -- 透支户账号
    ,nvl(n.baserate, o.baserate) as baserate -- 基准利率
    ,nvl(n.operatedate, o.operatedate) as operatedate -- 经办日期
    ,nvl(n.lprtype, o.lprtype) as lprtype -- 基准利率选择LPR的取值方式（1最新LPR2首笔LPR）
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.customername, o.customername) as customername -- 透支客户名称
    ,nvl(n.directionrs, o.directionrs) as directionrs -- 行业投向（征信）
    ,nvl(n.isfarming, o.isfarming) as isfarming -- 是否涉农(1是0否)
    ,nvl(n.contractserialno, o.contractserialno) as contractserialno -- 合同流水号
    ,nvl(n.customerid, o.customerid) as customerid -- 透支客户号
    ,nvl(n.baseratetype, o.baseratetype) as baseratetype -- 基准利率类型
    ,nvl(n.bengdt, o.bengdt) as bengdt -- 业务提醒短信发送时机
    ,nvl(n.daynum, o.daynum) as daynum -- 单笔透支有效天数
    ,nvl(n.overduerate, o.overduerate) as overduerate -- 逾期贷款执行利率
    ,nvl(n.ovdrmi, o.ovdrmi) as ovdrmi -- 起透金额
    ,nvl(n.odrfreeinterest, o.odrfreeinterest) as odrfreeinterest -- 法透不跨月免息天数
    ,nvl(n.platformpaycashsource, o.platformpaycashsource) as platformpaycashsource -- 地方融资平台偿债资金来源分类
    ,nvl(n.loanhandlechannel, o.loanhandlechannel) as loanhandlechannel -- 贷款办理渠道
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 输入日期
    ,nvl(n.acceptinttype, o.acceptinttype) as acceptinttype -- 结息方式
    ,nvl(n.whitelist, o.whitelist) as whitelist -- 白名单
    ,nvl(n.sectionalinterest, o.sectionalinterest) as sectionalinterest -- 是否靠档计息
    ,nvl(n.frecharger, o.frecharger) as frecharger -- 收费频率（按月、按日）码值：refreq
    ,nvl(n.binllingday, o.binllingday) as binllingday -- 收费日
    ,nvl(n.artificialno, o.artificialno) as artificialno -- 文本合同号
    ,nvl(n.subsac, o.subsac) as subsac -- 透支账户子户号
    ,nvl(n.maintp, o.maintp) as maintp -- 维护类型
    ,nvl(n.agrbdt, o.agrbdt) as agrbdt -- 协议法透额度有效期起始日
    ,nvl(n.agredt, o.agredt) as agredt -- 协议法透额度有效期结束日
    ,nvl(n.purpose, o.purpose) as purpose -- 资金用途
    ,nvl(n.ovtype, o.ovtype) as ovtype -- 日间隔夜透支类型
    ,nvl(n.flrttp, o.flrttp) as flrttp -- 利率浮动类型
    ,nvl(n.feeivl, o.feeivl) as feeivl -- 手续费费率
    ,nvl(n.tyflag, o.tyflag) as tyflag -- 对公同业法透类型
    ,nvl(n.tzrate, o.tzrate) as tzrate -- 透支利率
    ,nvl(n.agreementid, o.agreementid) as agreementid -- 协议编号
    ,nvl(n.status, o.status) as status -- 任务状态
    ,nvl(n.feedate, o.feedate) as feedate -- 手续费收费日
    ,nvl(n.overduefloatcycle, o.overduefloatcycle) as overduefloatcycle -- 利率浮动周期
    ,nvl(n.overduefloatmodel, o.overduefloatmodel) as overduefloatmodel -- 利率浮动方式
    ,nvl(n.feefrequency, o.feefrequency) as feefrequency -- 手续费收费频率
    ,nvl(n.feemodel, o.feemodel) as feemodel -- 手续费收取方式
    ,nvl(n.feerate, o.feerate) as feerate -- 手续费收费比率
    ,nvl(n.issupplychainfinance, o.issupplychainfinance) as issupplychainfinance -- 是否为供应链金融业务
    ,nvl(n.supplychainfinancetype, o.supplychainfinancetype) as supplychainfinancetype -- 供应链金融业务产品分类
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 
    ,nvl(n.ecodepartmentcode, o.ecodepartmentcode) as ecodepartmentcode -- 
    ,nvl(n.entscale, o.entscale) as entscale -- 
    ,nvl(n.classifyresulteleven, o.classifyresulteleven) as classifyresulteleven -- 
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
from (select * from ${iol_schema}.icms_business_fatou_putout_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_business_fatou_putout where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.businessrate <> n.businessrate
        or o.lontyp <> n.lontyp
        or o.inputuserid <> n.inputuserid
        or o.updateorgid <> n.updateorgid
        or o.odrputoutdate <> n.odrputoutdate
        or o.loanam <> n.loanam
        or o.odrmaturity <> n.odrmaturity
        or o.contractsum <> n.contractsum
        or o.operateuserid <> n.operateuserid
        or o.overduefloat <> n.overduefloat
        or o.lncmam <> n.lncmam
        or o.odrnextmonth <> n.odrnextmonth
        or o.inputorgid <> n.inputorgid
        or o.lendingorgid <> n.lendingorgid
        or o.rategenre <> n.rategenre
        or o.businesstype <> n.businesstype
        or o.farmingloanuse <> n.farmingloanuse
        or o.migtflag <> n.migtflag
        or o.careerguaranteeloantype <> n.careerguaranteeloantype
        or o.ratefloat <> n.ratefloat
        or o.oblopt <> n.oblopt
        or o.isputout <> n.isputout
        or o.businesscurrency <> n.businesscurrency
        or o.iscareerguaranteeloan <> n.iscareerguaranteeloan
        or o.directionnew <> n.directionnew
        or o.farmingloantype <> n.farmingloantype
        or o.tempsaveflag <> n.tempsaveflag
        or o.accountno1 <> n.accountno1
        or o.baserate <> n.baserate
        or o.operatedate <> n.operatedate
        or o.lprtype <> n.lprtype
        or o.updatedate <> n.updatedate
        or o.updateuserid <> n.updateuserid
        or o.customername <> n.customername
        or o.directionrs <> n.directionrs
        or o.isfarming <> n.isfarming
        or o.contractserialno <> n.contractserialno
        or o.customerid <> n.customerid
        or o.baseratetype <> n.baseratetype
        or o.bengdt <> n.bengdt
        or o.daynum <> n.daynum
        or o.overduerate <> n.overduerate
        or o.ovdrmi <> n.ovdrmi
        or o.odrfreeinterest <> n.odrfreeinterest
        or o.platformpaycashsource <> n.platformpaycashsource
        or o.loanhandlechannel <> n.loanhandlechannel
        or o.inputdate <> n.inputdate
        or o.acceptinttype <> n.acceptinttype
        or o.whitelist <> n.whitelist
        or o.sectionalinterest <> n.sectionalinterest
        or o.frecharger <> n.frecharger
        or o.binllingday <> n.binllingday
        or o.artificialno <> n.artificialno
        or o.subsac <> n.subsac
        or o.maintp <> n.maintp
        or o.agrbdt <> n.agrbdt
        or o.agredt <> n.agredt
        or o.purpose <> n.purpose
        or o.ovtype <> n.ovtype
        or o.flrttp <> n.flrttp
        or o.feeivl <> n.feeivl
        or o.tyflag <> n.tyflag
        or o.tzrate <> n.tzrate
        or o.agreementid <> n.agreementid
        or o.status <> n.status
        or o.feedate <> n.feedate
        or o.overduefloatcycle <> n.overduefloatcycle
        or o.overduefloatmodel <> n.overduefloatmodel
        or o.feefrequency <> n.feefrequency
        or o.feemodel <> n.feemodel
        or o.feerate <> n.feerate
        or o.issupplychainfinance <> n.issupplychainfinance
        or o.supplychainfinancetype <> n.supplychainfinancetype
        or o.inputtime <> n.inputtime
        or o.ecodepartmentcode <> n.ecodepartmentcode
        or o.entscale <> n.entscale
        or o.classifyresulteleven <> n.classifyresulteleven
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_business_fatou_putout_cl(
            serialno -- 流水号
            ,businessrate -- 正常贷款执行利率
            ,lontyp -- 透支还款方式
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,odrputoutdate -- 法透额度起始日
            ,loanam -- 透支额度
            ,odrmaturity -- 法透额度到期日
            ,contractsum -- 合同金额
            ,operateuserid -- 经办人
            ,overduefloat -- 逾期贷款利率浮动
            ,lncmam -- 透支承诺费
            ,odrnextmonth -- 法透不跨月
            ,inputorgid -- 登记机构
            ,lendingorgid -- 贷款机构
            ,rategenre -- 新重定价方式
            ,businesstype -- 业务品种
            ,farmingloanuse -- 涉农贷款投向
            ,migtflag -- 
            ,careerguaranteeloantype -- 创业担保贷款类型
            ,ratefloat -- 正常贷款利率浮动
            ,oblopt -- 使用余额选择
            ,isputout -- 是否出账通过
            ,businesscurrency -- 币种
            ,iscareerguaranteeloan -- 是否创业担保贷款(1是0否)
            ,directionnew -- 行业投向17年版（最新）
            ,farmingloantype -- 涉农贷款主体类型
            ,tempsaveflag -- 暂存标志
            ,accountno1 -- 透支户账号
            ,baserate -- 基准利率
            ,operatedate -- 经办日期
            ,lprtype -- 基准利率选择LPR的取值方式（1最新LPR2首笔LPR）
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,customername -- 透支客户名称
            ,directionrs -- 行业投向（征信）
            ,isfarming -- 是否涉农(1是0否)
            ,contractserialno -- 合同流水号
            ,customerid -- 透支客户号
            ,baseratetype -- 基准利率类型
            ,bengdt -- 业务提醒短信发送时机
            ,daynum -- 单笔透支有效天数
            ,overduerate -- 逾期贷款执行利率
            ,ovdrmi -- 起透金额
            ,odrfreeinterest -- 法透不跨月免息天数
            ,platformpaycashsource -- 地方融资平台偿债资金来源分类
            ,loanhandlechannel -- 贷款办理渠道
            ,inputdate -- 输入日期
            ,acceptinttype -- 结息方式
            ,whitelist -- 白名单
            ,sectionalinterest -- 是否靠档计息
            ,frecharger -- 收费频率（按月、按日）码值：refreq
            ,binllingday -- 收费日
            ,artificialno -- 文本合同号
            ,subsac -- 透支账户子户号
            ,maintp -- 维护类型
            ,agrbdt -- 协议法透额度有效期起始日
            ,agredt -- 协议法透额度有效期结束日
            ,purpose -- 资金用途
            ,ovtype -- 日间隔夜透支类型
            ,flrttp -- 利率浮动类型
            ,feeivl -- 手续费费率
            ,tyflag -- 对公同业法透类型
            ,tzrate -- 透支利率
            ,agreementid -- 协议编号
            ,status -- 任务状态
            ,feedate -- 手续费收费日
            ,overduefloatcycle -- 利率浮动周期
            ,overduefloatmodel -- 利率浮动方式
            ,feefrequency -- 手续费收费频率
            ,feemodel -- 手续费收取方式
            ,feerate -- 手续费收费比率
            ,issupplychainfinance -- 是否为供应链金融业务
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,inputtime -- 
            ,ecodepartmentcode -- 
            ,entscale -- 
            ,classifyresulteleven -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_business_fatou_putout_op(
            serialno -- 流水号
            ,businessrate -- 正常贷款执行利率
            ,lontyp -- 透支还款方式
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,odrputoutdate -- 法透额度起始日
            ,loanam -- 透支额度
            ,odrmaturity -- 法透额度到期日
            ,contractsum -- 合同金额
            ,operateuserid -- 经办人
            ,overduefloat -- 逾期贷款利率浮动
            ,lncmam -- 透支承诺费
            ,odrnextmonth -- 法透不跨月
            ,inputorgid -- 登记机构
            ,lendingorgid -- 贷款机构
            ,rategenre -- 新重定价方式
            ,businesstype -- 业务品种
            ,farmingloanuse -- 涉农贷款投向
            ,migtflag -- 
            ,careerguaranteeloantype -- 创业担保贷款类型
            ,ratefloat -- 正常贷款利率浮动
            ,oblopt -- 使用余额选择
            ,isputout -- 是否出账通过
            ,businesscurrency -- 币种
            ,iscareerguaranteeloan -- 是否创业担保贷款(1是0否)
            ,directionnew -- 行业投向17年版（最新）
            ,farmingloantype -- 涉农贷款主体类型
            ,tempsaveflag -- 暂存标志
            ,accountno1 -- 透支户账号
            ,baserate -- 基准利率
            ,operatedate -- 经办日期
            ,lprtype -- 基准利率选择LPR的取值方式（1最新LPR2首笔LPR）
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,customername -- 透支客户名称
            ,directionrs -- 行业投向（征信）
            ,isfarming -- 是否涉农(1是0否)
            ,contractserialno -- 合同流水号
            ,customerid -- 透支客户号
            ,baseratetype -- 基准利率类型
            ,bengdt -- 业务提醒短信发送时机
            ,daynum -- 单笔透支有效天数
            ,overduerate -- 逾期贷款执行利率
            ,ovdrmi -- 起透金额
            ,odrfreeinterest -- 法透不跨月免息天数
            ,platformpaycashsource -- 地方融资平台偿债资金来源分类
            ,loanhandlechannel -- 贷款办理渠道
            ,inputdate -- 输入日期
            ,acceptinttype -- 结息方式
            ,whitelist -- 白名单
            ,sectionalinterest -- 是否靠档计息
            ,frecharger -- 收费频率（按月、按日）码值：refreq
            ,binllingday -- 收费日
            ,artificialno -- 文本合同号
            ,subsac -- 透支账户子户号
            ,maintp -- 维护类型
            ,agrbdt -- 协议法透额度有效期起始日
            ,agredt -- 协议法透额度有效期结束日
            ,purpose -- 资金用途
            ,ovtype -- 日间隔夜透支类型
            ,flrttp -- 利率浮动类型
            ,feeivl -- 手续费费率
            ,tyflag -- 对公同业法透类型
            ,tzrate -- 透支利率
            ,agreementid -- 协议编号
            ,status -- 任务状态
            ,feedate -- 手续费收费日
            ,overduefloatcycle -- 利率浮动周期
            ,overduefloatmodel -- 利率浮动方式
            ,feefrequency -- 手续费收费频率
            ,feemodel -- 手续费收取方式
            ,feerate -- 手续费收费比率
            ,issupplychainfinance -- 是否为供应链金融业务
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,inputtime -- 
            ,ecodepartmentcode -- 
            ,entscale -- 
            ,classifyresulteleven -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.businessrate -- 正常贷款执行利率
    ,o.lontyp -- 透支还款方式
    ,o.inputuserid -- 登记人
    ,o.updateorgid -- 更新机构
    ,o.odrputoutdate -- 法透额度起始日
    ,o.loanam -- 透支额度
    ,o.odrmaturity -- 法透额度到期日
    ,o.contractsum -- 合同金额
    ,o.operateuserid -- 经办人
    ,o.overduefloat -- 逾期贷款利率浮动
    ,o.lncmam -- 透支承诺费
    ,o.odrnextmonth -- 法透不跨月
    ,o.inputorgid -- 登记机构
    ,o.lendingorgid -- 贷款机构
    ,o.rategenre -- 新重定价方式
    ,o.businesstype -- 业务品种
    ,o.farmingloanuse -- 涉农贷款投向
    ,o.migtflag -- 
    ,o.careerguaranteeloantype -- 创业担保贷款类型
    ,o.ratefloat -- 正常贷款利率浮动
    ,o.oblopt -- 使用余额选择
    ,o.isputout -- 是否出账通过
    ,o.businesscurrency -- 币种
    ,o.iscareerguaranteeloan -- 是否创业担保贷款(1是0否)
    ,o.directionnew -- 行业投向17年版（最新）
    ,o.farmingloantype -- 涉农贷款主体类型
    ,o.tempsaveflag -- 暂存标志
    ,o.accountno1 -- 透支户账号
    ,o.baserate -- 基准利率
    ,o.operatedate -- 经办日期
    ,o.lprtype -- 基准利率选择LPR的取值方式（1最新LPR2首笔LPR）
    ,o.updatedate -- 更新日期
    ,o.updateuserid -- 更新人
    ,o.customername -- 透支客户名称
    ,o.directionrs -- 行业投向（征信）
    ,o.isfarming -- 是否涉农(1是0否)
    ,o.contractserialno -- 合同流水号
    ,o.customerid -- 透支客户号
    ,o.baseratetype -- 基准利率类型
    ,o.bengdt -- 业务提醒短信发送时机
    ,o.daynum -- 单笔透支有效天数
    ,o.overduerate -- 逾期贷款执行利率
    ,o.ovdrmi -- 起透金额
    ,o.odrfreeinterest -- 法透不跨月免息天数
    ,o.platformpaycashsource -- 地方融资平台偿债资金来源分类
    ,o.loanhandlechannel -- 贷款办理渠道
    ,o.inputdate -- 输入日期
    ,o.acceptinttype -- 结息方式
    ,o.whitelist -- 白名单
    ,o.sectionalinterest -- 是否靠档计息
    ,o.frecharger -- 收费频率（按月、按日）码值：refreq
    ,o.binllingday -- 收费日
    ,o.artificialno -- 文本合同号
    ,o.subsac -- 透支账户子户号
    ,o.maintp -- 维护类型
    ,o.agrbdt -- 协议法透额度有效期起始日
    ,o.agredt -- 协议法透额度有效期结束日
    ,o.purpose -- 资金用途
    ,o.ovtype -- 日间隔夜透支类型
    ,o.flrttp -- 利率浮动类型
    ,o.feeivl -- 手续费费率
    ,o.tyflag -- 对公同业法透类型
    ,o.tzrate -- 透支利率
    ,o.agreementid -- 协议编号
    ,o.status -- 任务状态
    ,o.feedate -- 手续费收费日
    ,o.overduefloatcycle -- 利率浮动周期
    ,o.overduefloatmodel -- 利率浮动方式
    ,o.feefrequency -- 手续费收费频率
    ,o.feemodel -- 手续费收取方式
    ,o.feerate -- 手续费收费比率
    ,o.issupplychainfinance -- 是否为供应链金融业务
    ,o.supplychainfinancetype -- 供应链金融业务产品分类
    ,o.inputtime -- 
    ,o.ecodepartmentcode -- 
    ,o.entscale -- 
    ,o.classifyresulteleven -- 
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
from ${iol_schema}.icms_business_fatou_putout_bk o
    left join ${iol_schema}.icms_business_fatou_putout_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_business_fatou_putout_cl d
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
--truncate table ${iol_schema}.icms_business_fatou_putout;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_business_fatou_putout') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_business_fatou_putout drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_business_fatou_putout add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_business_fatou_putout exchange partition p_${batch_date} with table ${iol_schema}.icms_business_fatou_putout_cl;
alter table ${iol_schema}.icms_business_fatou_putout exchange partition p_20991231 with table ${iol_schema}.icms_business_fatou_putout_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_business_fatou_putout to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_business_fatou_putout_op purge;
drop table ${iol_schema}.icms_business_fatou_putout_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_business_fatou_putout_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_business_fatou_putout',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
