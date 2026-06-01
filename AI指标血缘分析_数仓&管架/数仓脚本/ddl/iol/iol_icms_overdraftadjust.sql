/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_overdraftadjust
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_overdraftadjust
whenever sqlerror continue none;
drop table ${iol_schema}.icms_overdraftadjust purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_overdraftadjust(
    serialno varchar2(40) -- 申请流水号
    ,relativeserialno varchar2(40) -- 关联法透申请流水号
    ,maintp varchar2(1) -- 维护类型
    ,trandt date -- 交易日期
    ,transq varchar2(10) -- 交易流水
    ,loancn varchar2(30) -- 额度合同号
    ,acctno varchar2(40) -- 透支账户号
    ,subsac varchar2(32) -- 透支账户子户号
    ,custno varchar2(32) -- 客户编号
    ,loanam number(18,2) -- 透支额度上限
    ,ovdram number(18,2) -- 原透支额度
    ,newovdram number(18,2) -- 新透支额度
    ,ovdra1 number(18,2) -- 已用透支额度
    ,ovdra2 number(18,2) -- 剩余透支额度
    ,loabdt date -- 原额度有效期起始日
    ,newloabdt date -- 新额度有效期起始日
    ,loaedt date -- 原额度有效期结束日
    ,newloaedt date -- 新额度有效期结束日
    ,daynum varchar2(10) -- 单笔透支有效天数
    ,loanbr varchar2(10) -- 贷款机构
    ,termcd varchar2(5) -- 期限
    ,rpcode varchar2(5) -- 原利率重定价方式
    ,lnrttp varchar2(12) -- 原基准利率类型
    ,newlnrttp varchar2(12) -- 新基准利率类型
    ,baserate number(6,2) -- 基准利率
    ,floart number(6,2) -- 原正常利率浮动比例
    ,newfloart number(6,2) -- 新正常利率浮动比例
    ,npflrt number(6,2) -- 原逾期利率浮动比例
    ,newnpflrt number(6,2) -- 新逾期利率浮动比例
    ,cntrir number(11,7) -- 原正常贷款利率
    ,newcntrir number(11,7) -- 新正常贷款利率
    ,ovduir number(11,7) -- 原逾期贷款利率
    ,newovduir number(11,7) -- 新逾期贷款利率
    ,ipcode varchar2(5) -- 原结息方式
    ,newipcode varchar2(5) -- 新结息方式
    ,lncmam number(18,2) -- 透支承诺费
    ,ovdrmi number(18,2) -- 原起透金额
    ,oblopt varchar2(1) -- 原使用余额选择
    ,bengdt varchar2(1) -- 原短信发送时间
    ,lontyp varchar2(1) -- 原透支还款方式
    ,custmg varchar2(12) -- 客户经理
    ,loans1 varchar2(1) -- 信用状态
    ,loans2 varchar2(1) -- 原透支服务状态
    ,avaibl number(18,2) -- 账户可用余额
    ,odrtfg varchar2(1) -- 是否触发业务
    ,odrtam number(18,2) -- 透支金额
    ,msgcode varchar2(10) -- 相应码
    ,listnm varchar2(4) -- 白名单明细笔数
    ,ovmthf varchar2(1) -- 不夸月期间
    ,ovfind varchar2(4) -- 透支免息期
    ,flrttp varchar2(1) -- 原利率浮动类型
    ,newflrttp varchar2(1) -- 新利率浮动类型
    ,tyflag varchar2(1) -- 对公法透类型
    ,feeivl number(11,7) -- 原透支手续费费率
    ,newfeeivl number(11,7) -- 新透支手续费费率
    ,agrbdt date -- 协议法透额度有效期起始日
    ,agredt date -- 议法透额度有效期结束日
    ,ovtype varchar2(1) -- 原日间隔夜透支类型
    ,newovtype varchar2(1) -- 新日间隔夜透支类型
    ,tempsaveflag varchar2(1) -- 暂存标识
    ,newloans2 varchar2(1) -- 新透支服务状态
    ,rategenre varchar2(2) -- 透支利率
    ,newlontyp varchar2(1) -- 新透支还款方式
    ,newbengdt varchar2(1) -- 新短信发送时间
    ,newoblopt varchar2(1) -- 新使用余额选择
    ,newovdrmi number(18,2) -- 新起透金额
    ,newrpcode varchar2(5) -- 新利率重定价方式
    ,artificialno varchar2(100) -- 文本合同号
    ,purpose varchar2(1000) -- 资金用途
    ,newlncmam number(18,2) -- 续签管理费
    ,inputuserid varchar2(8) -- 登记人
    ,inputorgid varchar2(20) -- 登记机构
    ,inputtime date -- 登记时间
    ,updatetime date -- 更新时间
    ,updateuserid varchar2(8) -- 更新人
    ,updateorgid varchar2(12) -- 更新机构
    ,migtflag varchar2(80) -- 
    ,custname varchar2(200) -- 透支客户名称
    ,overduefloatmodel varchar2(10) -- 利率浮动方式
    ,overduefloatcycle varchar2(2) -- 利率浮动周期
    ,odrfreeinterest number(38,0) -- 法透不跨月免息天数
    ,sectionalinterest varchar2(1) -- 是否靠档计息
    ,isfarming varchar2(2) -- 是否涉农贷款标志
    ,farmingloantype varchar2(18) -- 涉农贷款主体类型
    ,farmingloanuse varchar2(18) -- 涉农贷款主体类型
    ,iscareerguaranteeloan varchar2(2) -- 是否创业担保贷款(1是0否)
    ,careerguaranteeloantype varchar2(18) -- 创业担保贷款类型
    ,platformpaycashsource varchar2(18) -- 地方融资平台偿债资金来源分类
    ,directionnew varchar2(18) -- 行业投向17年版（最新）
    ,loanhandlechannel varchar2(20) -- 贷款办理渠道
    ,feemodel varchar2(2) -- 手续费收取方式
    ,feefrequency varchar2(2) -- 手续费收费频率
    ,feedate varchar2(10) -- 手续费收费日
    ,issupplychainfinance varchar2(2) -- 是否为供应链金融业务
    ,supplychainfinancetype varchar2(8) -- 供应链金融业务产品分类
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
grant select on ${iol_schema}.icms_overdraftadjust to ${iml_schema};
grant select on ${iol_schema}.icms_overdraftadjust to ${icl_schema};
grant select on ${iol_schema}.icms_overdraftadjust to ${idl_schema};
grant select on ${iol_schema}.icms_overdraftadjust to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_overdraftadjust is '同业法透要素调整申请表';
comment on column ${iol_schema}.icms_overdraftadjust.serialno is '申请流水号';
comment on column ${iol_schema}.icms_overdraftadjust.relativeserialno is '关联法透申请流水号';
comment on column ${iol_schema}.icms_overdraftadjust.maintp is '维护类型';
comment on column ${iol_schema}.icms_overdraftadjust.trandt is '交易日期';
comment on column ${iol_schema}.icms_overdraftadjust.transq is '交易流水';
comment on column ${iol_schema}.icms_overdraftadjust.loancn is '额度合同号';
comment on column ${iol_schema}.icms_overdraftadjust.acctno is '透支账户号';
comment on column ${iol_schema}.icms_overdraftadjust.subsac is '透支账户子户号';
comment on column ${iol_schema}.icms_overdraftadjust.custno is '客户编号';
comment on column ${iol_schema}.icms_overdraftadjust.loanam is '透支额度上限';
comment on column ${iol_schema}.icms_overdraftadjust.ovdram is '原透支额度';
comment on column ${iol_schema}.icms_overdraftadjust.newovdram is '新透支额度';
comment on column ${iol_schema}.icms_overdraftadjust.ovdra1 is '已用透支额度';
comment on column ${iol_schema}.icms_overdraftadjust.ovdra2 is '剩余透支额度';
comment on column ${iol_schema}.icms_overdraftadjust.loabdt is '原额度有效期起始日';
comment on column ${iol_schema}.icms_overdraftadjust.newloabdt is '新额度有效期起始日';
comment on column ${iol_schema}.icms_overdraftadjust.loaedt is '原额度有效期结束日';
comment on column ${iol_schema}.icms_overdraftadjust.newloaedt is '新额度有效期结束日';
comment on column ${iol_schema}.icms_overdraftadjust.daynum is '单笔透支有效天数';
comment on column ${iol_schema}.icms_overdraftadjust.loanbr is '贷款机构';
comment on column ${iol_schema}.icms_overdraftadjust.termcd is '期限';
comment on column ${iol_schema}.icms_overdraftadjust.rpcode is '原利率重定价方式';
comment on column ${iol_schema}.icms_overdraftadjust.lnrttp is '原基准利率类型';
comment on column ${iol_schema}.icms_overdraftadjust.newlnrttp is '新基准利率类型';
comment on column ${iol_schema}.icms_overdraftadjust.baserate is '基准利率';
comment on column ${iol_schema}.icms_overdraftadjust.floart is '原正常利率浮动比例';
comment on column ${iol_schema}.icms_overdraftadjust.newfloart is '新正常利率浮动比例';
comment on column ${iol_schema}.icms_overdraftadjust.npflrt is '原逾期利率浮动比例';
comment on column ${iol_schema}.icms_overdraftadjust.newnpflrt is '新逾期利率浮动比例';
comment on column ${iol_schema}.icms_overdraftadjust.cntrir is '原正常贷款利率';
comment on column ${iol_schema}.icms_overdraftadjust.newcntrir is '新正常贷款利率';
comment on column ${iol_schema}.icms_overdraftadjust.ovduir is '原逾期贷款利率';
comment on column ${iol_schema}.icms_overdraftadjust.newovduir is '新逾期贷款利率';
comment on column ${iol_schema}.icms_overdraftadjust.ipcode is '原结息方式';
comment on column ${iol_schema}.icms_overdraftadjust.newipcode is '新结息方式';
comment on column ${iol_schema}.icms_overdraftadjust.lncmam is '透支承诺费';
comment on column ${iol_schema}.icms_overdraftadjust.ovdrmi is '原起透金额';
comment on column ${iol_schema}.icms_overdraftadjust.oblopt is '原使用余额选择';
comment on column ${iol_schema}.icms_overdraftadjust.bengdt is '原短信发送时间';
comment on column ${iol_schema}.icms_overdraftadjust.lontyp is '原透支还款方式';
comment on column ${iol_schema}.icms_overdraftadjust.custmg is '客户经理';
comment on column ${iol_schema}.icms_overdraftadjust.loans1 is '信用状态';
comment on column ${iol_schema}.icms_overdraftadjust.loans2 is '原透支服务状态';
comment on column ${iol_schema}.icms_overdraftadjust.avaibl is '账户可用余额';
comment on column ${iol_schema}.icms_overdraftadjust.odrtfg is '是否触发业务';
comment on column ${iol_schema}.icms_overdraftadjust.odrtam is '透支金额';
comment on column ${iol_schema}.icms_overdraftadjust.msgcode is '相应码';
comment on column ${iol_schema}.icms_overdraftadjust.listnm is '白名单明细笔数';
comment on column ${iol_schema}.icms_overdraftadjust.ovmthf is '不夸月期间';
comment on column ${iol_schema}.icms_overdraftadjust.ovfind is '透支免息期';
comment on column ${iol_schema}.icms_overdraftadjust.flrttp is '原利率浮动类型';
comment on column ${iol_schema}.icms_overdraftadjust.newflrttp is '新利率浮动类型';
comment on column ${iol_schema}.icms_overdraftadjust.tyflag is '对公法透类型';
comment on column ${iol_schema}.icms_overdraftadjust.feeivl is '原透支手续费费率';
comment on column ${iol_schema}.icms_overdraftadjust.newfeeivl is '新透支手续费费率';
comment on column ${iol_schema}.icms_overdraftadjust.agrbdt is '协议法透额度有效期起始日';
comment on column ${iol_schema}.icms_overdraftadjust.agredt is '议法透额度有效期结束日';
comment on column ${iol_schema}.icms_overdraftadjust.ovtype is '原日间隔夜透支类型';
comment on column ${iol_schema}.icms_overdraftadjust.newovtype is '新日间隔夜透支类型';
comment on column ${iol_schema}.icms_overdraftadjust.tempsaveflag is '暂存标识';
comment on column ${iol_schema}.icms_overdraftadjust.newloans2 is '新透支服务状态';
comment on column ${iol_schema}.icms_overdraftadjust.rategenre is '透支利率';
comment on column ${iol_schema}.icms_overdraftadjust.newlontyp is '新透支还款方式';
comment on column ${iol_schema}.icms_overdraftadjust.newbengdt is '新短信发送时间';
comment on column ${iol_schema}.icms_overdraftadjust.newoblopt is '新使用余额选择';
comment on column ${iol_schema}.icms_overdraftadjust.newovdrmi is '新起透金额';
comment on column ${iol_schema}.icms_overdraftadjust.newrpcode is '新利率重定价方式';
comment on column ${iol_schema}.icms_overdraftadjust.artificialno is '文本合同号';
comment on column ${iol_schema}.icms_overdraftadjust.purpose is '资金用途';
comment on column ${iol_schema}.icms_overdraftadjust.newlncmam is '续签管理费';
comment on column ${iol_schema}.icms_overdraftadjust.inputuserid is '登记人';
comment on column ${iol_schema}.icms_overdraftadjust.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_overdraftadjust.inputtime is '登记时间';
comment on column ${iol_schema}.icms_overdraftadjust.updatetime is '更新时间';
comment on column ${iol_schema}.icms_overdraftadjust.updateuserid is '更新人';
comment on column ${iol_schema}.icms_overdraftadjust.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_overdraftadjust.migtflag is '';
comment on column ${iol_schema}.icms_overdraftadjust.custname is '透支客户名称';
comment on column ${iol_schema}.icms_overdraftadjust.overduefloatmodel is '利率浮动方式';
comment on column ${iol_schema}.icms_overdraftadjust.overduefloatcycle is '利率浮动周期';
comment on column ${iol_schema}.icms_overdraftadjust.odrfreeinterest is '法透不跨月免息天数';
comment on column ${iol_schema}.icms_overdraftadjust.sectionalinterest is '是否靠档计息';
comment on column ${iol_schema}.icms_overdraftadjust.isfarming is '是否涉农贷款标志';
comment on column ${iol_schema}.icms_overdraftadjust.farmingloantype is '涉农贷款主体类型';
comment on column ${iol_schema}.icms_overdraftadjust.farmingloanuse is '涉农贷款主体类型';
comment on column ${iol_schema}.icms_overdraftadjust.iscareerguaranteeloan is '是否创业担保贷款(1是0否)';
comment on column ${iol_schema}.icms_overdraftadjust.careerguaranteeloantype is '创业担保贷款类型';
comment on column ${iol_schema}.icms_overdraftadjust.platformpaycashsource is '地方融资平台偿债资金来源分类';
comment on column ${iol_schema}.icms_overdraftadjust.directionnew is '行业投向17年版（最新）';
comment on column ${iol_schema}.icms_overdraftadjust.loanhandlechannel is '贷款办理渠道';
comment on column ${iol_schema}.icms_overdraftadjust.feemodel is '手续费收取方式';
comment on column ${iol_schema}.icms_overdraftadjust.feefrequency is '手续费收费频率';
comment on column ${iol_schema}.icms_overdraftadjust.feedate is '手续费收费日';
comment on column ${iol_schema}.icms_overdraftadjust.issupplychainfinance is '是否为供应链金融业务';
comment on column ${iol_schema}.icms_overdraftadjust.supplychainfinancetype is '供应链金融业务产品分类';
comment on column ${iol_schema}.icms_overdraftadjust.start_dt is '开始时间';
comment on column ${iol_schema}.icms_overdraftadjust.end_dt is '结束时间';
comment on column ${iol_schema}.icms_overdraftadjust.id_mark is '增删标志';
comment on column ${iol_schema}.icms_overdraftadjust.etl_timestamp is 'ETL处理时间戳';
