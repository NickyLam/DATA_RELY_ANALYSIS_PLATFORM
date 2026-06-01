/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_ama_loan_acct
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM tgls_ama_loan_acct_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('tgls_ama_loan_acct');
  
  if v_var <> 0 then 
    execute immediate 'alter table tgls_ama_loan_acct drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table tgls_ama_loan_acct add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.tgls_ama_loan_acct(
            stacid -- 账套标记
            ,systid -- 来源系统编号
            ,loanno -- 核心贷款账户编号
            ,transq -- 交易流水号
            ,trancd -- 子交易
            ,crcycd -- 币种，业务字典币种crcy
            ,deptcd -- 核心网点号
            ,debtno -- 核心借据编号
            ,busitp -- 业务类型
            ,prducd -- 产品编号
            ,lnctno -- 核心合同编号
            ,odlnno -- 旧贷款账户编号
            ,descpt -- 说明
            ,accrtg -- 数据字典应计标识，y-应计，n-非应计
            ,amortg -- 摊销标识，y-是，n-否
            ,extetg -- 展期标识，y-是，n-否
            ,secutg -- 资产证券化状态，y-是，n-否
            ,incotg -- 撤并标识，y-是，n-否
            ,dscttg -- 贴息标识，y-贴息，n-非贴息
            ,adittg -- 预收息标识，y-预收息，n-非预收息
            ,status -- 贷款状态,01-正常，02-结清，03-核销
            ,ratenr -- 正常合同利率
            ,ratecy -- 正常利率周期，数据字典周期：日，月，季，半年，年
            ,ovdurt -- 逾期利率
            ,ovducy -- 逾期利率周期，数据字典周期：日，月，季，半年，年
            ,compra -- 复利利率
            ,compcy -- 复利利率周期，数据字典周期：日，月，季，半年，年
            ,gracrt -- 宽限期利率
            ,graccy -- 宽限期利率周期，数据字典周期：日，月，季，半年，年
            ,amorfr -- 摊销频度
            ,stindt -- 起息日
            ,nesedt -- 下次结息日
            ,exindt -- 展期到期日
            ,gracdy -- 宽限期
            ,intetg -- 计息标志，y-是，n-否
            ,custcd -- 客户编号
            ,custna -- 客户名称
            ,drafcd -- 承兑人代码
            ,drafna -- 承兑人名称
            ,riskcd -- 贷款五级分类
            ,phascd -- 贷款阶段，数据字典贷款阶段:1-第一阶段，2-第二阶段，3-第三阶段
            ,devaam -- 贷款减值金额
            ,devatg -- 减值标识，数据字典减值标识：y-减值，n-未减值
            ,credco -- 贷前费用
            ,issudt -- 贷款放款日期
            ,actuam -- 贷款放款金额
            ,issuam -- 贷款放款金额
            ,expidt -- 贷款到期日期
            ,retuwy -- 还本付息方式
            ,recocy -- 本金付款周期，数据字典周期：日，月，季，半年，年
            ,recofr -- 本金付款频率
            ,reincy -- 利息付款周期，数据字典周期：日，月，季，半年，年
            ,reinfr -- 利息付款频率
            ,necodt -- 下次还本日
            ,neredt -- 下次还息日
            ,prodp1 -- 产品属性1
            ,prodp2 -- 产品属性2
            ,prodp3 -- 产品属性3
            ,prodp4 -- 产品属性4
            ,prodp5 -- 产品属性5
            ,prodp6 -- 产品属性6
            ,prodp7 -- 产品属性7
            ,prodp8 -- 产品属性8
            ,prodp9 -- 产品属性9
            ,prodpa -- 产品属性10
            ,intead -- 利息调整
            ,accrin -- 应计利息
            ,intein -- 利息收入
            ,ofbsci -- 表外应计复利
            ,asseip -- 资产减值准备
            ,impaii -- 已减值利息收入
            ,intere -- 应收利息
            ,ofbsir -- 表外应收利息
            ,ofbsrc -- 表外应收复利
            ,ofbsai -- 表外应计利息
            ,normpr -- 正常本金
            ,veripr -- 减值本金
            ,inteim -- 已减值利息
            ,asselo -- 资产减值损失
            ,wrofbd -- 已核销呆账本金
            ,wrofde -- 已核销呆账已减值利息
            ,wrinbd -- 已核销呆账利息
            ,iminye -- 本年利息收入
            ,acinin -- 累计利息收入
            ,imiiye -- 本年已减值利息收入
            ,acimii -- 累计已减值利息收入
            ,vataxm -- 应交增值税
            ,amou01 -- 金额01
            ,amou02 -- 金额02
            ,amou03 -- 金额03
            ,amou04 -- 金额04
            ,amou05 -- 金额05
            ,amou06 -- 金额06
            ,amou07 -- 金额07
            ,attra1 -- 附加属性1
            ,attra2 -- 附加属性2
            ,attra3 -- 附加属性3
            ,attra4 -- 附加属性4
            ,attra5 -- 附加属性5
            ,attra6 -- 附加属性6
            ,attra7 -- 附加属性7
            ,attra8 -- 附加属性8
            ,attra9 -- 附加属性9
            ,attraa -- 附加属性10
            ,puprtg -- 客户类型
            ,amorco -- 摊余成本
            ,oppotr -- 对方余额类型
            ,accuto -- 累计资产减值损失
            ,netrsq -- 新交易流水
            ,acasil -- 本年资产减值损失
            ,trandt -- 交易日期
            ,eventp -- 交易场景
            ,reinre -- 登记应收利息
            ,regcir -- 登记应收复利
            ,reacin -- 登记应计利息
            ,reacci -- 登记应计复利
            ,regaci -- 登记已还利息
            ,regicr -- 登记已还复利
            ,invein -- 投资收益
            ,inveye -- 本年投资收益
            ,inveto -- 累计投资收益
            ,islast -- 是否交易场景的最后一条，1-是，0-否
            ,bathid -- 批次号
            ,tranbr -- 交易机构
            ,strkst -- 冲正标识
            ,strkdt -- 被冲正流水日期
            ,strksq -- 被冲正流水
            ,evetdn -- 交易方向
            ,bsnssq -- 全局流水号
            ,amou08 -- 金额08
            ,amou09 -- 金额09
            ,amou10 -- 金额10
            ,amou11 -- 金额11
            ,amou12 -- 金额12
            ,amou13 -- 金额13
            ,amou14 -- 金额14
            ,amou15 -- 金额15
            ,amou16 -- 金额16
            ,amou17 -- 金额17
            ,amou18 -- 金额18
            ,amou19 -- 金额19
            ,amou20 -- 金额20
            ,collpe -- 当天到期的利息
            ,accoin -- 当天到期的罚息
            ,compin -- 当前到期的复利
            ,coacin -- 罚息
            ,recede -- 复利
            ,collde -- 当日应收未收利息余额
            ,reacpe -- 逾期利息
            ,coacpe -- 逾期罚息
            ,recepe -- 逾期复利
            ,ovdupr -- 逾期本金
            ,befdept -- 变更前机构
            ,aftdept -- 变更后机构
            ,ncbstranti -- 业务发生时点
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            stacid -- 账套标记
            ,systid -- 来源系统编号
            ,loanno -- 核心贷款账户编号
            ,transq -- 交易流水号
            ,trancd -- 子交易
            ,crcycd -- 币种，业务字典币种crcy
            ,deptcd -- 核心网点号
            ,debtno -- 核心借据编号
            ,busitp -- 业务类型
            ,prducd -- 产品编号
            ,lnctno -- 核心合同编号
            ,odlnno -- 旧贷款账户编号
            ,descpt -- 说明
            ,accrtg -- 数据字典应计标识，y-应计，n-非应计
            ,amortg -- 摊销标识，y-是，n-否
            ,extetg -- 展期标识，y-是，n-否
            ,secutg -- 资产证券化状态，y-是，n-否
            ,incotg -- 撤并标识，y-是，n-否
            ,dscttg -- 贴息标识，y-贴息，n-非贴息
            ,adittg -- 预收息标识，y-预收息，n-非预收息
            ,status -- 贷款状态,01-正常，02-结清，03-核销
            ,ratenr -- 正常合同利率
            ,ratecy -- 正常利率周期，数据字典周期：日，月，季，半年，年
            ,ovdurt -- 逾期利率
            ,ovducy -- 逾期利率周期，数据字典周期：日，月，季，半年，年
            ,compra -- 复利利率
            ,compcy -- 复利利率周期，数据字典周期：日，月，季，半年，年
            ,gracrt -- 宽限期利率
            ,graccy -- 宽限期利率周期，数据字典周期：日，月，季，半年，年
            ,amorfr -- 摊销频度
            ,stindt -- 起息日
            ,nesedt -- 下次结息日
            ,exindt -- 展期到期日
            ,gracdy -- 宽限期
            ,intetg -- 计息标志，y-是，n-否
            ,custcd -- 客户编号
            ,custna -- 客户名称
            ,drafcd -- 承兑人代码
            ,drafna -- 承兑人名称
            ,riskcd -- 贷款五级分类
            ,phascd -- 贷款阶段，数据字典贷款阶段:1-第一阶段，2-第二阶段，3-第三阶段
            ,devaam -- 贷款减值金额
            ,devatg -- 减值标识，数据字典减值标识：y-减值，n-未减值
            ,credco -- 贷前费用
            ,issudt -- 贷款放款日期
            ,actuam -- 贷款放款金额
            ,issuam -- 贷款放款金额
            ,expidt -- 贷款到期日期
            ,retuwy -- 还本付息方式
            ,recocy -- 本金付款周期，数据字典周期：日，月，季，半年，年
            ,recofr -- 本金付款频率
            ,reincy -- 利息付款周期，数据字典周期：日，月，季，半年，年
            ,reinfr -- 利息付款频率
            ,necodt -- 下次还本日
            ,neredt -- 下次还息日
            ,prodp1 -- 产品属性1
            ,prodp2 -- 产品属性2
            ,prodp3 -- 产品属性3
            ,prodp4 -- 产品属性4
            ,prodp5 -- 产品属性5
            ,prodp6 -- 产品属性6
            ,prodp7 -- 产品属性7
            ,prodp8 -- 产品属性8
            ,prodp9 -- 产品属性9
            ,prodpa -- 产品属性10
            ,intead -- 利息调整
            ,accrin -- 应计利息
            ,intein -- 利息收入
            ,ofbsci -- 表外应计复利
            ,asseip -- 资产减值准备
            ,impaii -- 已减值利息收入
            ,intere -- 应收利息
            ,ofbsir -- 表外应收利息
            ,ofbsrc -- 表外应收复利
            ,ofbsai -- 表外应计利息
            ,normpr -- 正常本金
            ,veripr -- 减值本金
            ,inteim -- 已减值利息
            ,asselo -- 资产减值损失
            ,wrofbd -- 已核销呆账本金
            ,wrofde -- 已核销呆账已减值利息
            ,wrinbd -- 已核销呆账利息
            ,iminye -- 本年利息收入
            ,acinin -- 累计利息收入
            ,imiiye -- 本年已减值利息收入
            ,acimii -- 累计已减值利息收入
            ,vataxm -- 应交增值税
            ,amou01 -- 金额01
            ,amou02 -- 金额02
            ,amou03 -- 金额03
            ,amou04 -- 金额04
            ,amou05 -- 金额05
            ,amou06 -- 金额06
            ,amou07 -- 金额07
            ,attra1 -- 附加属性1
            ,attra2 -- 附加属性2
            ,attra3 -- 附加属性3
            ,attra4 -- 附加属性4
            ,attra5 -- 附加属性5
            ,attra6 -- 附加属性6
            ,attra7 -- 附加属性7
            ,attra8 -- 附加属性8
            ,attra9 -- 附加属性9
            ,attraa -- 附加属性10
            ,puprtg -- 客户类型
            ,amorco -- 摊余成本
            ,oppotr -- 对方余额类型
            ,accuto -- 累计资产减值损失
            ,netrsq -- 新交易流水
            ,acasil -- 本年资产减值损失
            ,trandt -- 交易日期
            ,eventp -- 交易场景
            ,reinre -- 登记应收利息
            ,regcir -- 登记应收复利
            ,reacin -- 登记应计利息
            ,reacci -- 登记应计复利
            ,regaci -- 登记已还利息
            ,regicr -- 登记已还复利
            ,invein -- 投资收益
            ,inveye -- 本年投资收益
            ,inveto -- 累计投资收益
            ,islast -- 是否交易场景的最后一条，1-是，0-否
            ,bathid -- 批次号
            ,tranbr -- 交易机构
            ,strkst -- 冲正标识
            ,strkdt -- 被冲正流水日期
            ,strksq -- 被冲正流水
            ,evetdn -- 交易方向
            ,bsnssq -- 全局流水号
            ,amou08 -- 金额08
            ,amou09 -- 金额09
            ,amou10 -- 金额10
            ,amou11 -- 金额11
            ,amou12 -- 金额12
            ,amou13 -- 金额13
            ,amou14 -- 金额14
            ,amou15 -- 金额15
            ,amou16 -- 金额16
            ,amou17 -- 金额17
            ,amou18 -- 金额18
            ,amou19 -- 金额19
            ,amou20 -- 金额20
            ,collpe -- 当天到期的利息
            ,accoin -- 当天到期的罚息
            ,compin -- 当前到期的复利
            ,coacin -- 罚息
            ,recede -- 复利
            ,collde -- 当日应收未收利息余额
            ,reacpe -- 逾期利息
            ,coacpe -- 逾期罚息
            ,recepe -- 逾期复利
            ,ovdupr -- 逾期本金
            ,befdept -- 变更前机构
            ,aftdept -- 变更后机构
            ,' ' as ncbstranti -- 业务发生时点
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tgls_ama_loan_acct_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
