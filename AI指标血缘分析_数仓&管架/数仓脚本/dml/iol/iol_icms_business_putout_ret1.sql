/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_business_putout
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
                       FROM icms_business_putout_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('icms_business_putout');
  
  if v_var <> 0 then 
    execute immediate 'alter table icms_business_putout drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table icms_business_putout add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.icms_business_putout(
            serialno -- 出账流水号
            ,executerate -- 执行利率
            ,repaycycle -- 还款周期
            ,pigeonholedate -- 归档日期
            ,gainamount -- 递变幅度
            ,productid -- 产品编号
            ,purpose -- 贷款用途(手输描述)
            ,pdgpaymethod -- 手续费收取方式
            ,repaydate -- 默认还款日
            ,customerid -- 客户编号
            ,loanaccountnosub -- 贷款入账账号(收款账户)子户号
            ,baserate -- 基准利率
            ,policyid -- 政策编号
            ,occurdate -- 发生日期
            ,paymenttype -- 支付方式
            ,completeflag -- 数据录入完整性标识
            ,inputuserid -- 登记人
            ,subjectno -- 科目代码
            ,putoutorgid -- 出账机构编号(核心机构)
            ,applytype -- 申请类型
            ,approvestatus -- 审批状态
            ,updateuserid -- 更新人
            ,customername -- 客户名称
            ,rateadjustfrequency -- 利率调整周期
            ,putoutdate -- 起息日
            ,updatedate -- 更新日期
            ,segterm -- 指定还款计算期限
            ,inputorgid -- 登记机构
            ,flowtype -- 流程类型
            ,exchangetime -- 交易时间
            ,offsheetflag -- 表内外标志
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,pdgsum -- 手续费金额(元)
            ,jxhjduebillno -- 借新还旧借据号
            ,rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
            ,pdgaccountno -- 手续费扣费账户
            ,zftransserialno -- 受托支付止付流水号
            ,contractserialno -- 合同编号
            ,interestrepaycycle -- 结息方式
            ,exchangestate -- 交易状态
            ,bpspreads -- 合同点差
            ,fixedrate -- 固定利率
            ,floatrange -- 浮动幅度
            ,overdueratefloattype -- 逾期利率浮动方式
            ,remark -- 备注
            ,ratemodel -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
            ,ratefloattype -- 利率浮动类型浮动利率类型
            ,islowrisk -- 是否低风险
            ,lendingorgid -- 贷款机构编号(核心机构)
            ,commissionpaysum -- 受托支付金额
            ,clno -- 额度编号
            ,segrptamount -- 指定区段拟还本金金额
            ,bailratio -- 保证金比例(%)
            ,transserialno -- 核心交易流水号
            ,payfrequencyunit -- 指定周期单位
            ,payfrequency -- 指定周期
            ,repaytype -- 还款方式
            ,overduerate -- 逾期执行利率
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,termmonth -- 期限月
            ,maturity -- 到期日
            ,gaincyc -- 递变周期
            ,loanaccountno -- 贷款入账账号
            ,operateuserid -- 经办人
            ,contractsum -- 合同金额
            ,bailtransaccount -- 保证金转出账号
            ,operatedate -- 经办日期
            ,corporgid -- 法人机构编号
            ,currency -- 币种
            ,artificialno -- 文本合同编号
            ,bailsum -- 保证金金额
            ,vouchtype -- 主要担保方式
            ,transdate -- 核心交易日期
            ,secondpayaccount -- 第二还款账号
            ,bailsubaccount -- 保证金子户号
            ,putoutcontrol -- 到日期超批复半年设置，1允许，0禁止
            ,termday -- 期限天
            ,businesssum -- 本次放款金额
            ,occurtype -- 发生类型
            ,operateorgid -- 经办机构
            ,inputdate -- 登记日期
            ,bailaccount -- 保证金账号
            ,bailcurrency -- 保证金币种
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountbankname -- 结算账户(还款账户)开户行
            ,baseratetype -- 基准利率类型
            ,updateorgid -- 更新机构
            ,pdgamorfg -- 手续费是否摊销
            ,loanaccountorgid -- 贷款入账(收款账户)账户开户机构
            ,belongdept -- 所属条线
            ,policyversionid -- 政策版本编号
            ,settlementaccount -- 结算账号(还款账户)
            ,loanusetype -- 借款用途类型
            ,loanaccountname -- 贷款入账(收款账户)账户名
            ,duebillserialno -- 借据号
            ,pdgpaypercent -- 手续费率
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,remart -- 计量标记InvestGroup
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,cashconcenaccount -- 资金归集账户
            ,ecodepartmentcode -- 国民经济类型-EcoDepartmentCode
            ,entscale -- 企业规模
            ,isfirstloans -- 是否首次放款-YesNo
            ,ispensionindustry -- 养老产业标识
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,hangseqno -- 挂账账户序列号
            ,relacontractno -- 占用承兑行额度编号
            ,nextsettlementdate -- 下一结息日
            ,lprrefertype -- LPR参照方式
            ,othcustomername -- 对手客户名称
            ,othcustomerid -- 对手客户编号
            ,subproductname -- 子产品名称
            ,renewaltype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 出账流水号
            ,executerate -- 执行利率
            ,repaycycle -- 还款周期
            ,pigeonholedate -- 归档日期
            ,gainamount -- 递变幅度
            ,productid -- 产品编号
            ,purpose -- 贷款用途(手输描述)
            ,pdgpaymethod -- 手续费收取方式
            ,repaydate -- 默认还款日
            ,customerid -- 客户编号
            ,loanaccountnosub -- 贷款入账账号(收款账户)子户号
            ,baserate -- 基准利率
            ,policyid -- 政策编号
            ,occurdate -- 发生日期
            ,paymenttype -- 支付方式
            ,completeflag -- 数据录入完整性标识
            ,inputuserid -- 登记人
            ,subjectno -- 科目代码
            ,putoutorgid -- 出账机构编号(核心机构)
            ,applytype -- 申请类型
            ,approvestatus -- 审批状态
            ,updateuserid -- 更新人
            ,customername -- 客户名称
            ,rateadjustfrequency -- 利率调整周期
            ,putoutdate -- 起息日
            ,updatedate -- 更新日期
            ,segterm -- 指定还款计算期限
            ,inputorgid -- 登记机构
            ,flowtype -- 流程类型
            ,exchangetime -- 交易时间
            ,offsheetflag -- 表内外标志
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,pdgsum -- 手续费金额(元)
            ,jxhjduebillno -- 借新还旧借据号
            ,rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
            ,pdgaccountno -- 手续费扣费账户
            ,zftransserialno -- 受托支付止付流水号
            ,contractserialno -- 合同编号
            ,interestrepaycycle -- 结息方式
            ,exchangestate -- 交易状态
            ,bpspreads -- 合同点差
            ,fixedrate -- 固定利率
            ,floatrange -- 浮动幅度
            ,overdueratefloattype -- 逾期利率浮动方式
            ,remark -- 备注
            ,ratemodel -- 利率模式利率模式(1固定利率2浮动利率3组合利率)
            ,ratefloattype -- 利率浮动类型浮动利率类型
            ,islowrisk -- 是否低风险
            ,lendingorgid -- 贷款机构编号(核心机构)
            ,commissionpaysum -- 受托支付金额
            ,clno -- 额度编号
            ,segrptamount -- 指定区段拟还本金金额
            ,bailratio -- 保证金比例(%)
            ,transserialno -- 核心交易流水号
            ,payfrequencyunit -- 指定周期单位
            ,payfrequency -- 指定周期
            ,repaytype -- 还款方式
            ,overduerate -- 逾期执行利率
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,termmonth -- 期限月
            ,maturity -- 到期日
            ,gaincyc -- 递变周期
            ,loanaccountno -- 贷款入账账号
            ,operateuserid -- 经办人
            ,contractsum -- 合同金额
            ,bailtransaccount -- 保证金转出账号
            ,operatedate -- 经办日期
            ,corporgid -- 法人机构编号
            ,currency -- 币种
            ,artificialno -- 文本合同编号
            ,bailsum -- 保证金金额
            ,vouchtype -- 主要担保方式
            ,transdate -- 核心交易日期
            ,secondpayaccount -- 第二还款账号
            ,bailsubaccount -- 保证金子户号
            ,putoutcontrol -- 到日期超批复半年设置，1允许，0禁止
            ,termday -- 期限天
            ,businesssum -- 本次放款金额
            ,occurtype -- 发生类型
            ,operateorgid -- 经办机构
            ,inputdate -- 登记日期
            ,bailaccount -- 保证金账号
            ,bailcurrency -- 保证金币种
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountbankname -- 结算账户(还款账户)开户行
            ,baseratetype -- 基准利率类型
            ,updateorgid -- 更新机构
            ,pdgamorfg -- 手续费是否摊销
            ,loanaccountorgid -- 贷款入账(收款账户)账户开户机构
            ,belongdept -- 所属条线
            ,policyversionid -- 政策版本编号
            ,settlementaccount -- 结算账号(还款账户)
            ,loanusetype -- 借款用途类型
            ,loanaccountname -- 贷款入账(收款账户)账户名
            ,duebillserialno -- 借据号
            ,pdgpaypercent -- 手续费率
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,remart -- 计量标记InvestGroup
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,cashconcenaccount -- 资金归集账户
            ,ecodepartmentcode -- 国民经济类型-EcoDepartmentCode
            ,entscale -- 企业规模
            ,isfirstloans -- 是否首次放款-YesNo
            ,ispensionindustry -- 养老产业标识
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,hangseqno -- 挂账账户序列号
            ,relacontractno -- 占用承兑行额度编号
            ,nextsettlementdate -- 下一结息日
            ,lprrefertype -- LPR参照方式
            ,othcustomername -- 对手客户名称
            ,othcustomerid -- 对手客户编号
            ,subproductname -- 子产品名称
            ,' ' as renewaltype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from icms_business_putout_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
