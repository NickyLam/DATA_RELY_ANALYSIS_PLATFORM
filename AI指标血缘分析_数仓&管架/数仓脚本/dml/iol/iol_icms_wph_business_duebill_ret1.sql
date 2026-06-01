/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wph_business_duebill
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
                       FROM icms_wph_business_duebill_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('icms_wph_business_duebill');
  
  if v_var <> 0 then 
    execute immediate 'alter table icms_wph_business_duebill drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table icms_wph_business_duebill add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.icms_wph_business_duebill(
            serialno -- 借据编号
            ,putoutserialno -- 出账流水号
            ,contractserialno -- 合同流水号
            ,baseratetype -- 基准利率类型
            ,repayday -- 还款日
            ,baserate -- 基准利率
            ,overduerate -- 逾期利率
            ,rateadjustfrequency -- 利率调整周期
            ,floatrange -- 浮动幅度
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,classifyresult -- 贷款五级分类
            ,repaycycle -- 还款周期
            ,totalterms -- 总期数
            ,curterm -- 当前期数
            ,putoutorgid -- 账务机构
            ,manageorgid -- 管理机构
            ,productid -- 产品编号
            ,ratemodel -- 利率模式
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式
            ,remart -- 计量标记-资产三分类
            ,dailyint -- 当日计提利息
            ,dailypnltint -- 当日计提罚息
            ,bankcontriratio -- 银行出资比例
            ,operateuserid -- 经办人
            ,operateorgid -- 经办机构
            ,hxduebillno -- 核心借据号
            ,loantype -- 贷款类型
            ,clientname -- 客户名称
            ,documenttype -- 证件类型
            ,documentid -- 证件号码
            ,isscountry -- 签证国家
            ,cyclefreq -- 结息周期
            ,termtype -- 贷款期限类型
            ,guarpaiddate -- 代偿结清日期
            ,ddpercencontri -- 合作方出资比例
            ,intpltyrate -- 复利利率
            ,oslamt -- 未到期本金
            ,odipamt -- 逾期复利
            ,writeoff -- 核销标志
            ,writeoffamt -- 核销金额
            ,gracedays -- 宽限期天数
            ,nextrepaydate -- 下一还款日期
            ,accountingstatus -- 核算状态
            ,reasoncode -- 贷款用途
            ,remark1 -- 备用字段1（行外借据号）
            ,remark2 -- 备用字段2
            ,unionguaranteeflag -- 融担模式
            ,guaranteeaid -- 担保方ID1
            ,guaranteearate -- 担保方1担保比例
            ,guaranteeacontractno -- 客户担保合同编号1
            ,guaranteebid -- 担保方ID2
            ,guaranteebrate -- 担保方2担保比例
            ,guaranteebcontractno -- 客户担保合同编号2
            ,putoutdate -- 发放日期
            ,maturity -- 贷款到期日
            ,overduedate -- 逾期日期
            ,cleardate -- 结清日期
            ,encashamt -- 借据金额
            ,currency -- 币种
            ,repaymode -- 还款方式
            ,termmonth -- 期限
            ,customerid -- 客户编号
            ,occurdate -- 发生日期
            ,trandate -- 交易日期
            ,ovdprinbal -- 逾期本金余额
            ,ovdintbal -- 逾期利息余额
            ,pnltintbal -- 罚息余额
            ,wphproductid -- 唯品产品编号
            ,daysovd -- 逾期天数
            ,writeofftime -- 核销时间
            ,executerate -- 执行利率
            ,ovdrate -- 罚息利率
            ,vouchtype -- 担保方式
            ,repaynum -- 还款账户
            ,paymentnum -- 入账账户
            ,balance -- 借据余额
            ,interestrepaycycle -- 结息方式
            ,interestcalculation -- 计息方式
            ,paymentbankname -- 入账账户开户银行名称
            ,paymentbankno -- 还款账户开户银行编号
            ,paymentorgname -- 还款账户开户机构名称
            ,normalamt -- 正常本金
            ,normalintamt -- 正常利息
            ,pnltintoverdue -- 应收欠息
            ,pnltinttotal -- 应收罚息
            ,pnltintamt -- 应收利息
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,bizdate -- 流程日期
            ,pnltodiamt -- 应收复利
            ,classifyresultdate -- 五级分类认定日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 借据编号
            ,putoutserialno -- 出账流水号
            ,contractserialno -- 合同流水号
            ,baseratetype -- 基准利率类型
            ,repayday -- 还款日
            ,baserate -- 基准利率
            ,overduerate -- 逾期利率
            ,rateadjustfrequency -- 利率调整周期
            ,floatrange -- 浮动幅度
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,classifyresult -- 贷款五级分类
            ,repaycycle -- 还款周期
            ,totalterms -- 总期数
            ,curterm -- 当前期数
            ,putoutorgid -- 账务机构
            ,manageorgid -- 管理机构
            ,productid -- 产品编号
            ,ratemodel -- 利率模式
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式
            ,remart -- 计量标记-资产三分类
            ,dailyint -- 当日计提利息
            ,dailypnltint -- 当日计提罚息
            ,bankcontriratio -- 银行出资比例
            ,operateuserid -- 经办人
            ,operateorgid -- 经办机构
            ,hxduebillno -- 核心借据号
            ,loantype -- 贷款类型
            ,clientname -- 客户名称
            ,documenttype -- 证件类型
            ,documentid -- 证件号码
            ,isscountry -- 签证国家
            ,cyclefreq -- 结息周期
            ,termtype -- 贷款期限类型
            ,guarpaiddate -- 代偿结清日期
            ,ddpercencontri -- 合作方出资比例
            ,intpltyrate -- 复利利率
            ,oslamt -- 未到期本金
            ,odipamt -- 逾期复利
            ,writeoff -- 核销标志
            ,writeoffamt -- 核销金额
            ,gracedays -- 宽限期天数
            ,nextrepaydate -- 下一还款日期
            ,accountingstatus -- 核算状态
            ,reasoncode -- 贷款用途
            ,remark1 -- 备用字段1（行外借据号）
            ,remark2 -- 备用字段2
            ,unionguaranteeflag -- 融担模式
            ,guaranteeaid -- 担保方ID1
            ,guaranteearate -- 担保方1担保比例
            ,guaranteeacontractno -- 客户担保合同编号1
            ,guaranteebid -- 担保方ID2
            ,guaranteebrate -- 担保方2担保比例
            ,guaranteebcontractno -- 客户担保合同编号2
            ,putoutdate -- 发放日期
            ,maturity -- 贷款到期日
            ,overduedate -- 逾期日期
            ,cleardate -- 结清日期
            ,encashamt -- 借据金额
            ,currency -- 币种
            ,repaymode -- 还款方式
            ,termmonth -- 期限
            ,customerid -- 客户编号
            ,occurdate -- 发生日期
            ,trandate -- 交易日期
            ,ovdprinbal -- 逾期本金余额
            ,ovdintbal -- 逾期利息余额
            ,pnltintbal -- 罚息余额
            ,wphproductid -- 唯品产品编号
    ,to_number(nvl(trim(daysovd),0)) -- 逾期天数
            ,writeofftime -- 核销时间
            ,executerate -- 执行利率
            ,ovdrate -- 罚息利率
            ,vouchtype -- 担保方式
            ,repaynum -- 还款账户
            ,paymentnum -- 入账账户
            ,balance -- 借据余额
            ,interestrepaycycle -- 结息方式
            ,interestcalculation -- 计息方式
            ,paymentbankname -- 入账账户开户银行名称
            ,paymentbankno -- 还款账户开户银行编号
            ,paymentorgname -- 还款账户开户机构名称
            ,normalamt -- 正常本金
            ,normalintamt -- 正常利息
            ,pnltintoverdue -- 应收欠息
            ,pnltinttotal -- 应收罚息
            ,pnltintamt -- 应收利息
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,bizdate -- 流程日期
            ,pnltodiamt -- 应收复利
            ,classifyresultdate -- 五级分类认定日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_wph_business_duebill_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
