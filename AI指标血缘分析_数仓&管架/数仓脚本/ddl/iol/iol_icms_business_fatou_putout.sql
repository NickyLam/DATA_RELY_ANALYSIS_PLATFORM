/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_business_fatou_putout
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_business_fatou_putout
whenever sqlerror continue none;
drop table ${iol_schema}.icms_business_fatou_putout purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_business_fatou_putout(
    serialno varchar2(32) -- 流水号
    ,businessrate number(15,8) -- 正常贷款执行利率
    ,lontyp varchar2(1) -- 透支还款方式
    ,inputuserid varchar2(8) -- 登记人
    ,updateorgid varchar2(12) -- 更新机构
    ,odrputoutdate date -- 法透额度起始日
    ,loanam number(24,6) -- 透支额度
    ,odrmaturity date -- 法透额度到期日
    ,contractsum varchar2(32) -- 合同金额
    ,operateuserid varchar2(8) -- 经办人
    ,overduefloat number(6,2) -- 逾期贷款利率浮动
    ,lncmam number(24,6) -- 透支承诺费
    ,odrnextmonth varchar2(1) -- 法透不跨月
    ,inputorgid varchar2(32) -- 登记机构
    ,lendingorgid varchar2(80) -- 贷款机构
    ,rategenre varchar2(5) -- 新重定价方式
    ,businesstype varchar2(32) -- 业务品种
    ,farmingloanuse varchar2(18) -- 涉农贷款投向
    ,migtflag varchar2(80) -- 
    ,careerguaranteeloantype varchar2(18) -- 创业担保贷款类型
    ,ratefloat number(24,6) -- 正常贷款利率浮动
    ,oblopt varchar2(1) -- 使用余额选择
    ,isputout varchar2(1) -- 是否出账通过
    ,businesscurrency varchar2(10) -- 币种
    ,iscareerguaranteeloan varchar2(2) -- 是否创业担保贷款(1是0否)
    ,directionnew varchar2(18) -- 行业投向17年版（最新）
    ,farmingloantype varchar2(18) -- 涉农贷款主体类型
    ,tempsaveflag varchar2(18) -- 暂存标志
    ,accountno1 varchar2(40) -- 透支户账号
    ,baserate number(15,8) -- 基准利率
    ,operatedate date -- 经办日期
    ,lprtype varchar2(20) -- 基准利率选择LPR的取值方式（1最新LPR2首笔LPR）
    ,updatedate date -- 更新日期
    ,updateuserid varchar2(8) -- 更新人
    ,customername varchar2(200) -- 透支客户名称
    ,directionrs varchar2(18) -- 行业投向（征信）
    ,isfarming varchar2(2) -- 是否涉农(1是0否)
    ,contractserialno varchar2(32) -- 合同流水号
    ,customerid varchar2(32) -- 透支客户号
    ,baseratetype varchar2(18) -- 基准利率类型
    ,bengdt varchar2(1) -- 业务提醒短信发送时机
    ,daynum number(22) -- 单笔透支有效天数
    ,overduerate number(15,8) -- 逾期贷款执行利率
    ,ovdrmi number(24,6) -- 起透金额
    ,odrfreeinterest number(22) -- 法透不跨月免息天数
    ,platformpaycashsource varchar2(18) -- 地方融资平台偿债资金来源分类
    ,loanhandlechannel varchar2(20) -- 贷款办理渠道
    ,inputdate date -- 输入日期
    ,acceptinttype varchar2(18) -- 结息方式
    ,whitelist varchar2(3000) -- 白名单
    ,sectionalinterest varchar2(1) -- 是否靠档计息
    ,frecharger varchar2(2) -- 收费频率（按月、按日）码值：refreq
    ,binllingday varchar2(2) -- 收费日
    ,artificialno varchar2(100) -- 文本合同号
    ,subsac varchar2(5) -- 透支账户子户号
    ,maintp varchar2(1) -- 维护类型
    ,agrbdt date -- 协议法透额度有效期起始日
    ,agredt date -- 协议法透额度有效期结束日
    ,purpose varchar2(1000) -- 资金用途
    ,ovtype varchar2(1) -- 日间隔夜透支类型
    ,flrttp varchar2(10) -- 利率浮动类型
    ,feeivl number(24,6) -- 手续费费率
    ,tyflag varchar2(1) -- 对公同业法透类型
    ,tzrate varchar2(2) -- 透支利率
    ,agreementid varchar2(50) -- 协议编号
    ,status varchar2(2) -- 任务状态
    ,feedate varchar2(10) -- 手续费收费日
    ,overduefloatcycle varchar2(2) -- 利率浮动周期
    ,overduefloatmodel varchar2(10) -- 利率浮动方式
    ,feefrequency varchar2(2) -- 手续费收费频率
    ,feemodel varchar2(2) -- 手续费收取方式
    ,feerate number(15,8) -- 手续费收费比率
    ,issupplychainfinance varchar2(2) -- 是否为供应链金融业务
    ,supplychainfinancetype varchar2(8) -- 供应链金融业务产品分类
    ,inputtime date -- 
    ,ecodepartmentcode varchar2(18) -- 
    ,entscale varchar2(18) -- 
    ,classifyresulteleven varchar2(36) -- 
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
grant select on ${iol_schema}.icms_business_fatou_putout to ${iml_schema};
grant select on ${iol_schema}.icms_business_fatou_putout to ${icl_schema};
grant select on ${iol_schema}.icms_business_fatou_putout to ${idl_schema};
grant select on ${iol_schema}.icms_business_fatou_putout to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_business_fatou_putout is '法透出账详情';
comment on column ${iol_schema}.icms_business_fatou_putout.serialno is '流水号';
comment on column ${iol_schema}.icms_business_fatou_putout.businessrate is '正常贷款执行利率';
comment on column ${iol_schema}.icms_business_fatou_putout.lontyp is '透支还款方式';
comment on column ${iol_schema}.icms_business_fatou_putout.inputuserid is '登记人';
comment on column ${iol_schema}.icms_business_fatou_putout.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_business_fatou_putout.odrputoutdate is '法透额度起始日';
comment on column ${iol_schema}.icms_business_fatou_putout.loanam is '透支额度';
comment on column ${iol_schema}.icms_business_fatou_putout.odrmaturity is '法透额度到期日';
comment on column ${iol_schema}.icms_business_fatou_putout.contractsum is '合同金额';
comment on column ${iol_schema}.icms_business_fatou_putout.operateuserid is '经办人';
comment on column ${iol_schema}.icms_business_fatou_putout.overduefloat is '逾期贷款利率浮动';
comment on column ${iol_schema}.icms_business_fatou_putout.lncmam is '透支承诺费';
comment on column ${iol_schema}.icms_business_fatou_putout.odrnextmonth is '法透不跨月';
comment on column ${iol_schema}.icms_business_fatou_putout.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_business_fatou_putout.lendingorgid is '贷款机构';
comment on column ${iol_schema}.icms_business_fatou_putout.rategenre is '新重定价方式';
comment on column ${iol_schema}.icms_business_fatou_putout.businesstype is '业务品种';
comment on column ${iol_schema}.icms_business_fatou_putout.farmingloanuse is '涉农贷款投向';
comment on column ${iol_schema}.icms_business_fatou_putout.migtflag is '';
comment on column ${iol_schema}.icms_business_fatou_putout.careerguaranteeloantype is '创业担保贷款类型';
comment on column ${iol_schema}.icms_business_fatou_putout.ratefloat is '正常贷款利率浮动';
comment on column ${iol_schema}.icms_business_fatou_putout.oblopt is '使用余额选择';
comment on column ${iol_schema}.icms_business_fatou_putout.isputout is '是否出账通过';
comment on column ${iol_schema}.icms_business_fatou_putout.businesscurrency is '币种';
comment on column ${iol_schema}.icms_business_fatou_putout.iscareerguaranteeloan is '是否创业担保贷款(1是0否)';
comment on column ${iol_schema}.icms_business_fatou_putout.directionnew is '行业投向17年版（最新）';
comment on column ${iol_schema}.icms_business_fatou_putout.farmingloantype is '涉农贷款主体类型';
comment on column ${iol_schema}.icms_business_fatou_putout.tempsaveflag is '暂存标志';
comment on column ${iol_schema}.icms_business_fatou_putout.accountno1 is '透支户账号';
comment on column ${iol_schema}.icms_business_fatou_putout.baserate is '基准利率';
comment on column ${iol_schema}.icms_business_fatou_putout.operatedate is '经办日期';
comment on column ${iol_schema}.icms_business_fatou_putout.lprtype is '基准利率选择LPR的取值方式（1最新LPR2首笔LPR）';
comment on column ${iol_schema}.icms_business_fatou_putout.updatedate is '更新日期';
comment on column ${iol_schema}.icms_business_fatou_putout.updateuserid is '更新人';
comment on column ${iol_schema}.icms_business_fatou_putout.customername is '透支客户名称';
comment on column ${iol_schema}.icms_business_fatou_putout.directionrs is '行业投向（征信）';
comment on column ${iol_schema}.icms_business_fatou_putout.isfarming is '是否涉农(1是0否)';
comment on column ${iol_schema}.icms_business_fatou_putout.contractserialno is '合同流水号';
comment on column ${iol_schema}.icms_business_fatou_putout.customerid is '透支客户号';
comment on column ${iol_schema}.icms_business_fatou_putout.baseratetype is '基准利率类型';
comment on column ${iol_schema}.icms_business_fatou_putout.bengdt is '业务提醒短信发送时机';
comment on column ${iol_schema}.icms_business_fatou_putout.daynum is '单笔透支有效天数';
comment on column ${iol_schema}.icms_business_fatou_putout.overduerate is '逾期贷款执行利率';
comment on column ${iol_schema}.icms_business_fatou_putout.ovdrmi is '起透金额';
comment on column ${iol_schema}.icms_business_fatou_putout.odrfreeinterest is '法透不跨月免息天数';
comment on column ${iol_schema}.icms_business_fatou_putout.platformpaycashsource is '地方融资平台偿债资金来源分类';
comment on column ${iol_schema}.icms_business_fatou_putout.loanhandlechannel is '贷款办理渠道';
comment on column ${iol_schema}.icms_business_fatou_putout.inputdate is '输入日期';
comment on column ${iol_schema}.icms_business_fatou_putout.acceptinttype is '结息方式';
comment on column ${iol_schema}.icms_business_fatou_putout.whitelist is '白名单';
comment on column ${iol_schema}.icms_business_fatou_putout.sectionalinterest is '是否靠档计息';
comment on column ${iol_schema}.icms_business_fatou_putout.frecharger is '收费频率（按月、按日）码值：refreq';
comment on column ${iol_schema}.icms_business_fatou_putout.binllingday is '收费日';
comment on column ${iol_schema}.icms_business_fatou_putout.artificialno is '文本合同号';
comment on column ${iol_schema}.icms_business_fatou_putout.subsac is '透支账户子户号';
comment on column ${iol_schema}.icms_business_fatou_putout.maintp is '维护类型';
comment on column ${iol_schema}.icms_business_fatou_putout.agrbdt is '协议法透额度有效期起始日';
comment on column ${iol_schema}.icms_business_fatou_putout.agredt is '协议法透额度有效期结束日';
comment on column ${iol_schema}.icms_business_fatou_putout.purpose is '资金用途';
comment on column ${iol_schema}.icms_business_fatou_putout.ovtype is '日间隔夜透支类型';
comment on column ${iol_schema}.icms_business_fatou_putout.flrttp is '利率浮动类型';
comment on column ${iol_schema}.icms_business_fatou_putout.feeivl is '手续费费率';
comment on column ${iol_schema}.icms_business_fatou_putout.tyflag is '对公同业法透类型';
comment on column ${iol_schema}.icms_business_fatou_putout.tzrate is '透支利率';
comment on column ${iol_schema}.icms_business_fatou_putout.agreementid is '协议编号';
comment on column ${iol_schema}.icms_business_fatou_putout.status is '任务状态';
comment on column ${iol_schema}.icms_business_fatou_putout.feedate is '手续费收费日';
comment on column ${iol_schema}.icms_business_fatou_putout.overduefloatcycle is '利率浮动周期';
comment on column ${iol_schema}.icms_business_fatou_putout.overduefloatmodel is '利率浮动方式';
comment on column ${iol_schema}.icms_business_fatou_putout.feefrequency is '手续费收费频率';
comment on column ${iol_schema}.icms_business_fatou_putout.feemodel is '手续费收取方式';
comment on column ${iol_schema}.icms_business_fatou_putout.feerate is '手续费收费比率';
comment on column ${iol_schema}.icms_business_fatou_putout.issupplychainfinance is '是否为供应链金融业务';
comment on column ${iol_schema}.icms_business_fatou_putout.supplychainfinancetype is '供应链金融业务产品分类';
comment on column ${iol_schema}.icms_business_fatou_putout.inputtime is '';
comment on column ${iol_schema}.icms_business_fatou_putout.ecodepartmentcode is '';
comment on column ${iol_schema}.icms_business_fatou_putout.entscale is '';
comment on column ${iol_schema}.icms_business_fatou_putout.classifyresulteleven is '';
comment on column ${iol_schema}.icms_business_fatou_putout.start_dt is '开始时间';
comment on column ${iol_schema}.icms_business_fatou_putout.end_dt is '结束时间';
comment on column ${iol_schema}.icms_business_fatou_putout.id_mark is '增删标志';
comment on column ${iol_schema}.icms_business_fatou_putout.etl_timestamp is 'ETL处理时间戳';
