/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_overdraftadjust
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
create table ${iol_schema}.icms_overdraftadjust_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_overdraftadjust
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_overdraftadjust_op purge;
drop table ${iol_schema}.icms_overdraftadjust_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_overdraftadjust_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_overdraftadjust where 0=1;

create table ${iol_schema}.icms_overdraftadjust_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_overdraftadjust where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_overdraftadjust_cl(
            serialno -- 申请流水号
            ,relativeserialno -- 关联法透申请流水号
            ,maintp -- 维护类型
            ,trandt -- 交易日期
            ,transq -- 交易流水
            ,loancn -- 额度合同号
            ,acctno -- 透支账户号
            ,subsac -- 透支账户子户号
            ,custno -- 客户编号
            ,loanam -- 透支额度上限
            ,ovdram -- 原透支额度
            ,newovdram -- 新透支额度
            ,ovdra1 -- 已用透支额度
            ,ovdra2 -- 剩余透支额度
            ,loabdt -- 原额度有效期起始日
            ,newloabdt -- 新额度有效期起始日
            ,loaedt -- 原额度有效期结束日
            ,newloaedt -- 新额度有效期结束日
            ,daynum -- 单笔透支有效天数
            ,loanbr -- 贷款机构
            ,termcd -- 期限
            ,rpcode -- 原利率重定价方式
            ,lnrttp -- 原基准利率类型
            ,newlnrttp -- 新基准利率类型
            ,baserate -- 基准利率
            ,floart -- 原正常利率浮动比例
            ,newfloart -- 新正常利率浮动比例
            ,npflrt -- 原逾期利率浮动比例
            ,newnpflrt -- 新逾期利率浮动比例
            ,cntrir -- 原正常贷款利率
            ,newcntrir -- 新正常贷款利率
            ,ovduir -- 原逾期贷款利率
            ,newovduir -- 新逾期贷款利率
            ,ipcode -- 原结息方式
            ,newipcode -- 新结息方式
            ,lncmam -- 透支承诺费
            ,ovdrmi -- 原起透金额
            ,oblopt -- 原使用余额选择
            ,bengdt -- 原短信发送时间
            ,lontyp -- 原透支还款方式
            ,custmg -- 客户经理
            ,loans1 -- 信用状态
            ,loans2 -- 原透支服务状态
            ,avaibl -- 账户可用余额
            ,odrtfg -- 是否触发业务
            ,odrtam -- 透支金额
            ,msgcode -- 相应码
            ,listnm -- 白名单明细笔数
            ,ovmthf -- 不夸月期间
            ,ovfind -- 透支免息期
            ,flrttp -- 原利率浮动类型
            ,newflrttp -- 新利率浮动类型
            ,tyflag -- 对公法透类型
            ,feeivl -- 原透支手续费费率
            ,newfeeivl -- 新透支手续费费率
            ,agrbdt -- 协议法透额度有效期起始日
            ,agredt -- 议法透额度有效期结束日
            ,ovtype -- 原日间隔夜透支类型
            ,newovtype -- 新日间隔夜透支类型
            ,tempsaveflag -- 暂存标识
            ,newloans2 -- 新透支服务状态
            ,rategenre -- 透支利率
            ,newlontyp -- 新透支还款方式
            ,newbengdt -- 新短信发送时间
            ,newoblopt -- 新使用余额选择
            ,newovdrmi -- 新起透金额
            ,newrpcode -- 新利率重定价方式
            ,artificialno -- 文本合同号
            ,purpose -- 资金用途
            ,newlncmam -- 续签管理费
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputtime -- 登记时间
            ,updatetime -- 更新时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,migtflag -- 
            ,custname -- 透支客户名称
            ,overduefloatmodel -- 利率浮动方式
            ,overduefloatcycle -- 利率浮动周期
            ,odrfreeinterest -- 法透不跨月免息天数
            ,sectionalinterest -- 是否靠档计息
            ,isfarming -- 是否涉农贷款标志
            ,farmingloantype -- 涉农贷款主体类型
            ,farmingloanuse -- 涉农贷款主体类型
            ,iscareerguaranteeloan -- 是否创业担保贷款(1是0否)
            ,careerguaranteeloantype -- 创业担保贷款类型
            ,platformpaycashsource -- 地方融资平台偿债资金来源分类
            ,directionnew -- 行业投向17年版（最新）
            ,loanhandlechannel -- 贷款办理渠道
            ,feemodel -- 手续费收取方式
            ,feefrequency -- 手续费收费频率
            ,feedate -- 手续费收费日
            ,issupplychainfinance -- 是否为供应链金融业务
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_overdraftadjust_op(
            serialno -- 申请流水号
            ,relativeserialno -- 关联法透申请流水号
            ,maintp -- 维护类型
            ,trandt -- 交易日期
            ,transq -- 交易流水
            ,loancn -- 额度合同号
            ,acctno -- 透支账户号
            ,subsac -- 透支账户子户号
            ,custno -- 客户编号
            ,loanam -- 透支额度上限
            ,ovdram -- 原透支额度
            ,newovdram -- 新透支额度
            ,ovdra1 -- 已用透支额度
            ,ovdra2 -- 剩余透支额度
            ,loabdt -- 原额度有效期起始日
            ,newloabdt -- 新额度有效期起始日
            ,loaedt -- 原额度有效期结束日
            ,newloaedt -- 新额度有效期结束日
            ,daynum -- 单笔透支有效天数
            ,loanbr -- 贷款机构
            ,termcd -- 期限
            ,rpcode -- 原利率重定价方式
            ,lnrttp -- 原基准利率类型
            ,newlnrttp -- 新基准利率类型
            ,baserate -- 基准利率
            ,floart -- 原正常利率浮动比例
            ,newfloart -- 新正常利率浮动比例
            ,npflrt -- 原逾期利率浮动比例
            ,newnpflrt -- 新逾期利率浮动比例
            ,cntrir -- 原正常贷款利率
            ,newcntrir -- 新正常贷款利率
            ,ovduir -- 原逾期贷款利率
            ,newovduir -- 新逾期贷款利率
            ,ipcode -- 原结息方式
            ,newipcode -- 新结息方式
            ,lncmam -- 透支承诺费
            ,ovdrmi -- 原起透金额
            ,oblopt -- 原使用余额选择
            ,bengdt -- 原短信发送时间
            ,lontyp -- 原透支还款方式
            ,custmg -- 客户经理
            ,loans1 -- 信用状态
            ,loans2 -- 原透支服务状态
            ,avaibl -- 账户可用余额
            ,odrtfg -- 是否触发业务
            ,odrtam -- 透支金额
            ,msgcode -- 相应码
            ,listnm -- 白名单明细笔数
            ,ovmthf -- 不夸月期间
            ,ovfind -- 透支免息期
            ,flrttp -- 原利率浮动类型
            ,newflrttp -- 新利率浮动类型
            ,tyflag -- 对公法透类型
            ,feeivl -- 原透支手续费费率
            ,newfeeivl -- 新透支手续费费率
            ,agrbdt -- 协议法透额度有效期起始日
            ,agredt -- 议法透额度有效期结束日
            ,ovtype -- 原日间隔夜透支类型
            ,newovtype -- 新日间隔夜透支类型
            ,tempsaveflag -- 暂存标识
            ,newloans2 -- 新透支服务状态
            ,rategenre -- 透支利率
            ,newlontyp -- 新透支还款方式
            ,newbengdt -- 新短信发送时间
            ,newoblopt -- 新使用余额选择
            ,newovdrmi -- 新起透金额
            ,newrpcode -- 新利率重定价方式
            ,artificialno -- 文本合同号
            ,purpose -- 资金用途
            ,newlncmam -- 续签管理费
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputtime -- 登记时间
            ,updatetime -- 更新时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,migtflag -- 
            ,custname -- 透支客户名称
            ,overduefloatmodel -- 利率浮动方式
            ,overduefloatcycle -- 利率浮动周期
            ,odrfreeinterest -- 法透不跨月免息天数
            ,sectionalinterest -- 是否靠档计息
            ,isfarming -- 是否涉农贷款标志
            ,farmingloantype -- 涉农贷款主体类型
            ,farmingloanuse -- 涉农贷款主体类型
            ,iscareerguaranteeloan -- 是否创业担保贷款(1是0否)
            ,careerguaranteeloantype -- 创业担保贷款类型
            ,platformpaycashsource -- 地方融资平台偿债资金来源分类
            ,directionnew -- 行业投向17年版（最新）
            ,loanhandlechannel -- 贷款办理渠道
            ,feemodel -- 手续费收取方式
            ,feefrequency -- 手续费收费频率
            ,feedate -- 手续费收费日
            ,issupplychainfinance -- 是否为供应链金融业务
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 申请流水号
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 关联法透申请流水号
    ,nvl(n.maintp, o.maintp) as maintp -- 维护类型
    ,nvl(n.trandt, o.trandt) as trandt -- 交易日期
    ,nvl(n.transq, o.transq) as transq -- 交易流水
    ,nvl(n.loancn, o.loancn) as loancn -- 额度合同号
    ,nvl(n.acctno, o.acctno) as acctno -- 透支账户号
    ,nvl(n.subsac, o.subsac) as subsac -- 透支账户子户号
    ,nvl(n.custno, o.custno) as custno -- 客户编号
    ,nvl(n.loanam, o.loanam) as loanam -- 透支额度上限
    ,nvl(n.ovdram, o.ovdram) as ovdram -- 原透支额度
    ,nvl(n.newovdram, o.newovdram) as newovdram -- 新透支额度
    ,nvl(n.ovdra1, o.ovdra1) as ovdra1 -- 已用透支额度
    ,nvl(n.ovdra2, o.ovdra2) as ovdra2 -- 剩余透支额度
    ,nvl(n.loabdt, o.loabdt) as loabdt -- 原额度有效期起始日
    ,nvl(n.newloabdt, o.newloabdt) as newloabdt -- 新额度有效期起始日
    ,nvl(n.loaedt, o.loaedt) as loaedt -- 原额度有效期结束日
    ,nvl(n.newloaedt, o.newloaedt) as newloaedt -- 新额度有效期结束日
    ,nvl(n.daynum, o.daynum) as daynum -- 单笔透支有效天数
    ,nvl(n.loanbr, o.loanbr) as loanbr -- 贷款机构
    ,nvl(n.termcd, o.termcd) as termcd -- 期限
    ,nvl(n.rpcode, o.rpcode) as rpcode -- 原利率重定价方式
    ,nvl(n.lnrttp, o.lnrttp) as lnrttp -- 原基准利率类型
    ,nvl(n.newlnrttp, o.newlnrttp) as newlnrttp -- 新基准利率类型
    ,nvl(n.baserate, o.baserate) as baserate -- 基准利率
    ,nvl(n.floart, o.floart) as floart -- 原正常利率浮动比例
    ,nvl(n.newfloart, o.newfloart) as newfloart -- 新正常利率浮动比例
    ,nvl(n.npflrt, o.npflrt) as npflrt -- 原逾期利率浮动比例
    ,nvl(n.newnpflrt, o.newnpflrt) as newnpflrt -- 新逾期利率浮动比例
    ,nvl(n.cntrir, o.cntrir) as cntrir -- 原正常贷款利率
    ,nvl(n.newcntrir, o.newcntrir) as newcntrir -- 新正常贷款利率
    ,nvl(n.ovduir, o.ovduir) as ovduir -- 原逾期贷款利率
    ,nvl(n.newovduir, o.newovduir) as newovduir -- 新逾期贷款利率
    ,nvl(n.ipcode, o.ipcode) as ipcode -- 原结息方式
    ,nvl(n.newipcode, o.newipcode) as newipcode -- 新结息方式
    ,nvl(n.lncmam, o.lncmam) as lncmam -- 透支承诺费
    ,nvl(n.ovdrmi, o.ovdrmi) as ovdrmi -- 原起透金额
    ,nvl(n.oblopt, o.oblopt) as oblopt -- 原使用余额选择
    ,nvl(n.bengdt, o.bengdt) as bengdt -- 原短信发送时间
    ,nvl(n.lontyp, o.lontyp) as lontyp -- 原透支还款方式
    ,nvl(n.custmg, o.custmg) as custmg -- 客户经理
    ,nvl(n.loans1, o.loans1) as loans1 -- 信用状态
    ,nvl(n.loans2, o.loans2) as loans2 -- 原透支服务状态
    ,nvl(n.avaibl, o.avaibl) as avaibl -- 账户可用余额
    ,nvl(n.odrtfg, o.odrtfg) as odrtfg -- 是否触发业务
    ,nvl(n.odrtam, o.odrtam) as odrtam -- 透支金额
    ,nvl(n.msgcode, o.msgcode) as msgcode -- 相应码
    ,nvl(n.listnm, o.listnm) as listnm -- 白名单明细笔数
    ,nvl(n.ovmthf, o.ovmthf) as ovmthf -- 不夸月期间
    ,nvl(n.ovfind, o.ovfind) as ovfind -- 透支免息期
    ,nvl(n.flrttp, o.flrttp) as flrttp -- 原利率浮动类型
    ,nvl(n.newflrttp, o.newflrttp) as newflrttp -- 新利率浮动类型
    ,nvl(n.tyflag, o.tyflag) as tyflag -- 对公法透类型
    ,nvl(n.feeivl, o.feeivl) as feeivl -- 原透支手续费费率
    ,nvl(n.newfeeivl, o.newfeeivl) as newfeeivl -- 新透支手续费费率
    ,nvl(n.agrbdt, o.agrbdt) as agrbdt -- 协议法透额度有效期起始日
    ,nvl(n.agredt, o.agredt) as agredt -- 议法透额度有效期结束日
    ,nvl(n.ovtype, o.ovtype) as ovtype -- 原日间隔夜透支类型
    ,nvl(n.newovtype, o.newovtype) as newovtype -- 新日间隔夜透支类型
    ,nvl(n.tempsaveflag, o.tempsaveflag) as tempsaveflag -- 暂存标识
    ,nvl(n.newloans2, o.newloans2) as newloans2 -- 新透支服务状态
    ,nvl(n.rategenre, o.rategenre) as rategenre -- 透支利率
    ,nvl(n.newlontyp, o.newlontyp) as newlontyp -- 新透支还款方式
    ,nvl(n.newbengdt, o.newbengdt) as newbengdt -- 新短信发送时间
    ,nvl(n.newoblopt, o.newoblopt) as newoblopt -- 新使用余额选择
    ,nvl(n.newovdrmi, o.newovdrmi) as newovdrmi -- 新起透金额
    ,nvl(n.newrpcode, o.newrpcode) as newrpcode -- 新利率重定价方式
    ,nvl(n.artificialno, o.artificialno) as artificialno -- 文本合同号
    ,nvl(n.purpose, o.purpose) as purpose -- 资金用途
    ,nvl(n.newlncmam, o.newlncmam) as newlncmam -- 续签管理费
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 登记时间
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.custname, o.custname) as custname -- 透支客户名称
    ,nvl(n.overduefloatmodel, o.overduefloatmodel) as overduefloatmodel -- 利率浮动方式
    ,nvl(n.overduefloatcycle, o.overduefloatcycle) as overduefloatcycle -- 利率浮动周期
    ,nvl(n.odrfreeinterest, o.odrfreeinterest) as odrfreeinterest -- 法透不跨月免息天数
    ,nvl(n.sectionalinterest, o.sectionalinterest) as sectionalinterest -- 是否靠档计息
    ,nvl(n.isfarming, o.isfarming) as isfarming -- 是否涉农贷款标志
    ,nvl(n.farmingloantype, o.farmingloantype) as farmingloantype -- 涉农贷款主体类型
    ,nvl(n.farmingloanuse, o.farmingloanuse) as farmingloanuse -- 涉农贷款主体类型
    ,nvl(n.iscareerguaranteeloan, o.iscareerguaranteeloan) as iscareerguaranteeloan -- 是否创业担保贷款(1是0否)
    ,nvl(n.careerguaranteeloantype, o.careerguaranteeloantype) as careerguaranteeloantype -- 创业担保贷款类型
    ,nvl(n.platformpaycashsource, o.platformpaycashsource) as platformpaycashsource -- 地方融资平台偿债资金来源分类
    ,nvl(n.directionnew, o.directionnew) as directionnew -- 行业投向17年版（最新）
    ,nvl(n.loanhandlechannel, o.loanhandlechannel) as loanhandlechannel -- 贷款办理渠道
    ,nvl(n.feemodel, o.feemodel) as feemodel -- 手续费收取方式
    ,nvl(n.feefrequency, o.feefrequency) as feefrequency -- 手续费收费频率
    ,nvl(n.feedate, o.feedate) as feedate -- 手续费收费日
    ,nvl(n.issupplychainfinance, o.issupplychainfinance) as issupplychainfinance -- 是否为供应链金融业务
    ,nvl(n.supplychainfinancetype, o.supplychainfinancetype) as supplychainfinancetype -- 供应链金融业务产品分类
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
from (select * from ${iol_schema}.icms_overdraftadjust_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_overdraftadjust where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.relativeserialno <> n.relativeserialno
        or o.maintp <> n.maintp
        or o.trandt <> n.trandt
        or o.transq <> n.transq
        or o.loancn <> n.loancn
        or o.acctno <> n.acctno
        or o.subsac <> n.subsac
        or o.custno <> n.custno
        or o.loanam <> n.loanam
        or o.ovdram <> n.ovdram
        or o.newovdram <> n.newovdram
        or o.ovdra1 <> n.ovdra1
        or o.ovdra2 <> n.ovdra2
        or o.loabdt <> n.loabdt
        or o.newloabdt <> n.newloabdt
        or o.loaedt <> n.loaedt
        or o.newloaedt <> n.newloaedt
        or o.daynum <> n.daynum
        or o.loanbr <> n.loanbr
        or o.termcd <> n.termcd
        or o.rpcode <> n.rpcode
        or o.lnrttp <> n.lnrttp
        or o.newlnrttp <> n.newlnrttp
        or o.baserate <> n.baserate
        or o.floart <> n.floart
        or o.newfloart <> n.newfloart
        or o.npflrt <> n.npflrt
        or o.newnpflrt <> n.newnpflrt
        or o.cntrir <> n.cntrir
        or o.newcntrir <> n.newcntrir
        or o.ovduir <> n.ovduir
        or o.newovduir <> n.newovduir
        or o.ipcode <> n.ipcode
        or o.newipcode <> n.newipcode
        or o.lncmam <> n.lncmam
        or o.ovdrmi <> n.ovdrmi
        or o.oblopt <> n.oblopt
        or o.bengdt <> n.bengdt
        or o.lontyp <> n.lontyp
        or o.custmg <> n.custmg
        or o.loans1 <> n.loans1
        or o.loans2 <> n.loans2
        or o.avaibl <> n.avaibl
        or o.odrtfg <> n.odrtfg
        or o.odrtam <> n.odrtam
        or o.msgcode <> n.msgcode
        or o.listnm <> n.listnm
        or o.ovmthf <> n.ovmthf
        or o.ovfind <> n.ovfind
        or o.flrttp <> n.flrttp
        or o.newflrttp <> n.newflrttp
        or o.tyflag <> n.tyflag
        or o.feeivl <> n.feeivl
        or o.newfeeivl <> n.newfeeivl
        or o.agrbdt <> n.agrbdt
        or o.agredt <> n.agredt
        or o.ovtype <> n.ovtype
        or o.newovtype <> n.newovtype
        or o.tempsaveflag <> n.tempsaveflag
        or o.newloans2 <> n.newloans2
        or o.rategenre <> n.rategenre
        or o.newlontyp <> n.newlontyp
        or o.newbengdt <> n.newbengdt
        or o.newoblopt <> n.newoblopt
        or o.newovdrmi <> n.newovdrmi
        or o.newrpcode <> n.newrpcode
        or o.artificialno <> n.artificialno
        or o.purpose <> n.purpose
        or o.newlncmam <> n.newlncmam
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputtime <> n.inputtime
        or o.updatetime <> n.updatetime
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.migtflag <> n.migtflag
        or o.custname <> n.custname
        or o.overduefloatmodel <> n.overduefloatmodel
        or o.overduefloatcycle <> n.overduefloatcycle
        or o.odrfreeinterest <> n.odrfreeinterest
        or o.sectionalinterest <> n.sectionalinterest
        or o.isfarming <> n.isfarming
        or o.farmingloantype <> n.farmingloantype
        or o.farmingloanuse <> n.farmingloanuse
        or o.iscareerguaranteeloan <> n.iscareerguaranteeloan
        or o.careerguaranteeloantype <> n.careerguaranteeloantype
        or o.platformpaycashsource <> n.platformpaycashsource
        or o.directionnew <> n.directionnew
        or o.loanhandlechannel <> n.loanhandlechannel
        or o.feemodel <> n.feemodel
        or o.feefrequency <> n.feefrequency
        or o.feedate <> n.feedate
        or o.issupplychainfinance <> n.issupplychainfinance
        or o.supplychainfinancetype <> n.supplychainfinancetype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_overdraftadjust_cl(
            serialno -- 申请流水号
            ,relativeserialno -- 关联法透申请流水号
            ,maintp -- 维护类型
            ,trandt -- 交易日期
            ,transq -- 交易流水
            ,loancn -- 额度合同号
            ,acctno -- 透支账户号
            ,subsac -- 透支账户子户号
            ,custno -- 客户编号
            ,loanam -- 透支额度上限
            ,ovdram -- 原透支额度
            ,newovdram -- 新透支额度
            ,ovdra1 -- 已用透支额度
            ,ovdra2 -- 剩余透支额度
            ,loabdt -- 原额度有效期起始日
            ,newloabdt -- 新额度有效期起始日
            ,loaedt -- 原额度有效期结束日
            ,newloaedt -- 新额度有效期结束日
            ,daynum -- 单笔透支有效天数
            ,loanbr -- 贷款机构
            ,termcd -- 期限
            ,rpcode -- 原利率重定价方式
            ,lnrttp -- 原基准利率类型
            ,newlnrttp -- 新基准利率类型
            ,baserate -- 基准利率
            ,floart -- 原正常利率浮动比例
            ,newfloart -- 新正常利率浮动比例
            ,npflrt -- 原逾期利率浮动比例
            ,newnpflrt -- 新逾期利率浮动比例
            ,cntrir -- 原正常贷款利率
            ,newcntrir -- 新正常贷款利率
            ,ovduir -- 原逾期贷款利率
            ,newovduir -- 新逾期贷款利率
            ,ipcode -- 原结息方式
            ,newipcode -- 新结息方式
            ,lncmam -- 透支承诺费
            ,ovdrmi -- 原起透金额
            ,oblopt -- 原使用余额选择
            ,bengdt -- 原短信发送时间
            ,lontyp -- 原透支还款方式
            ,custmg -- 客户经理
            ,loans1 -- 信用状态
            ,loans2 -- 原透支服务状态
            ,avaibl -- 账户可用余额
            ,odrtfg -- 是否触发业务
            ,odrtam -- 透支金额
            ,msgcode -- 相应码
            ,listnm -- 白名单明细笔数
            ,ovmthf -- 不夸月期间
            ,ovfind -- 透支免息期
            ,flrttp -- 原利率浮动类型
            ,newflrttp -- 新利率浮动类型
            ,tyflag -- 对公法透类型
            ,feeivl -- 原透支手续费费率
            ,newfeeivl -- 新透支手续费费率
            ,agrbdt -- 协议法透额度有效期起始日
            ,agredt -- 议法透额度有效期结束日
            ,ovtype -- 原日间隔夜透支类型
            ,newovtype -- 新日间隔夜透支类型
            ,tempsaveflag -- 暂存标识
            ,newloans2 -- 新透支服务状态
            ,rategenre -- 透支利率
            ,newlontyp -- 新透支还款方式
            ,newbengdt -- 新短信发送时间
            ,newoblopt -- 新使用余额选择
            ,newovdrmi -- 新起透金额
            ,newrpcode -- 新利率重定价方式
            ,artificialno -- 文本合同号
            ,purpose -- 资金用途
            ,newlncmam -- 续签管理费
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputtime -- 登记时间
            ,updatetime -- 更新时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,migtflag -- 
            ,custname -- 透支客户名称
            ,overduefloatmodel -- 利率浮动方式
            ,overduefloatcycle -- 利率浮动周期
            ,odrfreeinterest -- 法透不跨月免息天数
            ,sectionalinterest -- 是否靠档计息
            ,isfarming -- 是否涉农贷款标志
            ,farmingloantype -- 涉农贷款主体类型
            ,farmingloanuse -- 涉农贷款主体类型
            ,iscareerguaranteeloan -- 是否创业担保贷款(1是0否)
            ,careerguaranteeloantype -- 创业担保贷款类型
            ,platformpaycashsource -- 地方融资平台偿债资金来源分类
            ,directionnew -- 行业投向17年版（最新）
            ,loanhandlechannel -- 贷款办理渠道
            ,feemodel -- 手续费收取方式
            ,feefrequency -- 手续费收费频率
            ,feedate -- 手续费收费日
            ,issupplychainfinance -- 是否为供应链金融业务
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_overdraftadjust_op(
            serialno -- 申请流水号
            ,relativeserialno -- 关联法透申请流水号
            ,maintp -- 维护类型
            ,trandt -- 交易日期
            ,transq -- 交易流水
            ,loancn -- 额度合同号
            ,acctno -- 透支账户号
            ,subsac -- 透支账户子户号
            ,custno -- 客户编号
            ,loanam -- 透支额度上限
            ,ovdram -- 原透支额度
            ,newovdram -- 新透支额度
            ,ovdra1 -- 已用透支额度
            ,ovdra2 -- 剩余透支额度
            ,loabdt -- 原额度有效期起始日
            ,newloabdt -- 新额度有效期起始日
            ,loaedt -- 原额度有效期结束日
            ,newloaedt -- 新额度有效期结束日
            ,daynum -- 单笔透支有效天数
            ,loanbr -- 贷款机构
            ,termcd -- 期限
            ,rpcode -- 原利率重定价方式
            ,lnrttp -- 原基准利率类型
            ,newlnrttp -- 新基准利率类型
            ,baserate -- 基准利率
            ,floart -- 原正常利率浮动比例
            ,newfloart -- 新正常利率浮动比例
            ,npflrt -- 原逾期利率浮动比例
            ,newnpflrt -- 新逾期利率浮动比例
            ,cntrir -- 原正常贷款利率
            ,newcntrir -- 新正常贷款利率
            ,ovduir -- 原逾期贷款利率
            ,newovduir -- 新逾期贷款利率
            ,ipcode -- 原结息方式
            ,newipcode -- 新结息方式
            ,lncmam -- 透支承诺费
            ,ovdrmi -- 原起透金额
            ,oblopt -- 原使用余额选择
            ,bengdt -- 原短信发送时间
            ,lontyp -- 原透支还款方式
            ,custmg -- 客户经理
            ,loans1 -- 信用状态
            ,loans2 -- 原透支服务状态
            ,avaibl -- 账户可用余额
            ,odrtfg -- 是否触发业务
            ,odrtam -- 透支金额
            ,msgcode -- 相应码
            ,listnm -- 白名单明细笔数
            ,ovmthf -- 不夸月期间
            ,ovfind -- 透支免息期
            ,flrttp -- 原利率浮动类型
            ,newflrttp -- 新利率浮动类型
            ,tyflag -- 对公法透类型
            ,feeivl -- 原透支手续费费率
            ,newfeeivl -- 新透支手续费费率
            ,agrbdt -- 协议法透额度有效期起始日
            ,agredt -- 议法透额度有效期结束日
            ,ovtype -- 原日间隔夜透支类型
            ,newovtype -- 新日间隔夜透支类型
            ,tempsaveflag -- 暂存标识
            ,newloans2 -- 新透支服务状态
            ,rategenre -- 透支利率
            ,newlontyp -- 新透支还款方式
            ,newbengdt -- 新短信发送时间
            ,newoblopt -- 新使用余额选择
            ,newovdrmi -- 新起透金额
            ,newrpcode -- 新利率重定价方式
            ,artificialno -- 文本合同号
            ,purpose -- 资金用途
            ,newlncmam -- 续签管理费
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputtime -- 登记时间
            ,updatetime -- 更新时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,migtflag -- 
            ,custname -- 透支客户名称
            ,overduefloatmodel -- 利率浮动方式
            ,overduefloatcycle -- 利率浮动周期
            ,odrfreeinterest -- 法透不跨月免息天数
            ,sectionalinterest -- 是否靠档计息
            ,isfarming -- 是否涉农贷款标志
            ,farmingloantype -- 涉农贷款主体类型
            ,farmingloanuse -- 涉农贷款主体类型
            ,iscareerguaranteeloan -- 是否创业担保贷款(1是0否)
            ,careerguaranteeloantype -- 创业担保贷款类型
            ,platformpaycashsource -- 地方融资平台偿债资金来源分类
            ,directionnew -- 行业投向17年版（最新）
            ,loanhandlechannel -- 贷款办理渠道
            ,feemodel -- 手续费收取方式
            ,feefrequency -- 手续费收费频率
            ,feedate -- 手续费收费日
            ,issupplychainfinance -- 是否为供应链金融业务
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 申请流水号
    ,o.relativeserialno -- 关联法透申请流水号
    ,o.maintp -- 维护类型
    ,o.trandt -- 交易日期
    ,o.transq -- 交易流水
    ,o.loancn -- 额度合同号
    ,o.acctno -- 透支账户号
    ,o.subsac -- 透支账户子户号
    ,o.custno -- 客户编号
    ,o.loanam -- 透支额度上限
    ,o.ovdram -- 原透支额度
    ,o.newovdram -- 新透支额度
    ,o.ovdra1 -- 已用透支额度
    ,o.ovdra2 -- 剩余透支额度
    ,o.loabdt -- 原额度有效期起始日
    ,o.newloabdt -- 新额度有效期起始日
    ,o.loaedt -- 原额度有效期结束日
    ,o.newloaedt -- 新额度有效期结束日
    ,o.daynum -- 单笔透支有效天数
    ,o.loanbr -- 贷款机构
    ,o.termcd -- 期限
    ,o.rpcode -- 原利率重定价方式
    ,o.lnrttp -- 原基准利率类型
    ,o.newlnrttp -- 新基准利率类型
    ,o.baserate -- 基准利率
    ,o.floart -- 原正常利率浮动比例
    ,o.newfloart -- 新正常利率浮动比例
    ,o.npflrt -- 原逾期利率浮动比例
    ,o.newnpflrt -- 新逾期利率浮动比例
    ,o.cntrir -- 原正常贷款利率
    ,o.newcntrir -- 新正常贷款利率
    ,o.ovduir -- 原逾期贷款利率
    ,o.newovduir -- 新逾期贷款利率
    ,o.ipcode -- 原结息方式
    ,o.newipcode -- 新结息方式
    ,o.lncmam -- 透支承诺费
    ,o.ovdrmi -- 原起透金额
    ,o.oblopt -- 原使用余额选择
    ,o.bengdt -- 原短信发送时间
    ,o.lontyp -- 原透支还款方式
    ,o.custmg -- 客户经理
    ,o.loans1 -- 信用状态
    ,o.loans2 -- 原透支服务状态
    ,o.avaibl -- 账户可用余额
    ,o.odrtfg -- 是否触发业务
    ,o.odrtam -- 透支金额
    ,o.msgcode -- 相应码
    ,o.listnm -- 白名单明细笔数
    ,o.ovmthf -- 不夸月期间
    ,o.ovfind -- 透支免息期
    ,o.flrttp -- 原利率浮动类型
    ,o.newflrttp -- 新利率浮动类型
    ,o.tyflag -- 对公法透类型
    ,o.feeivl -- 原透支手续费费率
    ,o.newfeeivl -- 新透支手续费费率
    ,o.agrbdt -- 协议法透额度有效期起始日
    ,o.agredt -- 议法透额度有效期结束日
    ,o.ovtype -- 原日间隔夜透支类型
    ,o.newovtype -- 新日间隔夜透支类型
    ,o.tempsaveflag -- 暂存标识
    ,o.newloans2 -- 新透支服务状态
    ,o.rategenre -- 透支利率
    ,o.newlontyp -- 新透支还款方式
    ,o.newbengdt -- 新短信发送时间
    ,o.newoblopt -- 新使用余额选择
    ,o.newovdrmi -- 新起透金额
    ,o.newrpcode -- 新利率重定价方式
    ,o.artificialno -- 文本合同号
    ,o.purpose -- 资金用途
    ,o.newlncmam -- 续签管理费
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputtime -- 登记时间
    ,o.updatetime -- 更新时间
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.migtflag -- 
    ,o.custname -- 透支客户名称
    ,o.overduefloatmodel -- 利率浮动方式
    ,o.overduefloatcycle -- 利率浮动周期
    ,o.odrfreeinterest -- 法透不跨月免息天数
    ,o.sectionalinterest -- 是否靠档计息
    ,o.isfarming -- 是否涉农贷款标志
    ,o.farmingloantype -- 涉农贷款主体类型
    ,o.farmingloanuse -- 涉农贷款主体类型
    ,o.iscareerguaranteeloan -- 是否创业担保贷款(1是0否)
    ,o.careerguaranteeloantype -- 创业担保贷款类型
    ,o.platformpaycashsource -- 地方融资平台偿债资金来源分类
    ,o.directionnew -- 行业投向17年版（最新）
    ,o.loanhandlechannel -- 贷款办理渠道
    ,o.feemodel -- 手续费收取方式
    ,o.feefrequency -- 手续费收费频率
    ,o.feedate -- 手续费收费日
    ,o.issupplychainfinance -- 是否为供应链金融业务
    ,o.supplychainfinancetype -- 供应链金融业务产品分类
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
from ${iol_schema}.icms_overdraftadjust_bk o
    left join ${iol_schema}.icms_overdraftadjust_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_overdraftadjust_cl d
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
--truncate table ${iol_schema}.icms_overdraftadjust;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_overdraftadjust') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_overdraftadjust drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_overdraftadjust add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_overdraftadjust exchange partition p_${batch_date} with table ${iol_schema}.icms_overdraftadjust_cl;
alter table ${iol_schema}.icms_overdraftadjust exchange partition p_20991231 with table ${iol_schema}.icms_overdraftadjust_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_overdraftadjust to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_overdraftadjust_op purge;
drop table ${iol_schema}.icms_overdraftadjust_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_overdraftadjust_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_overdraftadjust',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
