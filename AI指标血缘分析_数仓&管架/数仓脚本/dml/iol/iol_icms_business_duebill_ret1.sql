/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_business_duebill
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
                       FROM icms_business_duebill_bak_${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('icms_business_duebill');
  
  if v_var <> 0 then 
    execute immediate 'alter table icms_business_duebill drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table icms_business_duebill add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.icms_business_duebill(
            serialno -- 借据编号
            ,putoutserialno -- 关联出账编号
            ,contractserialno -- 关联合同编号
            ,occurdate -- 发生日期
            ,occurtype -- 贷款发放类型
            ,vouchtype -- 主担保方式
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,productid -- 产品编号
            ,currency -- 币种
            ,businesssum -- 放款金额
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,putoutdate -- 发放日期
            ,maturity -- 约定到期日
            ,actualmaturity -- 实际到期日
            ,ratemodel -- 利率模式
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,executerate -- 执行年利率
            ,bailratio -- 保证金比例
            ,bailsum -- 保证金金额
            ,bailaccount -- 保证金账户编号
            ,repaytype -- 还款方式
            ,paymenttype -- 支付方式
            ,repaycycle -- 还款周期
            ,balance -- 贷款余额
            ,normalbalance -- 正常余额
            ,overduebalance -- 逾期余额
            ,dullbalance -- 呆滞余额
            ,badbalance -- 呆账余额
            ,extendtimes -- 展期次数
            ,innerinterestbalance -- 表内欠息余额
            ,outerinterestbalance -- 表外欠息余额
            ,capitalpenaltybalance -- 逾期罚息余额
            ,interestpenaltybalance -- 复息余额
            ,overduedays -- 贷款逾期天数
            ,owninterestdays -- 欠息天数
            ,ichangedate -- 欠息更新日期
            ,graceperiod -- 贷款宽限期
            ,reducereservesum -- 计提准备金额
            ,predictlostsum -- 预测损失金额
            ,finishtype -- 终结类型
            ,finishdate -- 终结日期
            ,belongdept -- 所属条线
            ,offsheetflag -- 表内外标志
            ,islowrisk -- 是否低风险
            ,badconfirmdate -- 首次认定不良日期
            ,classifyresult -- 贷款五级分类
            ,classifydate -- 风险分类日期
            ,advanceflag -- 担保代偿/垫款标志
            ,businessstatus -- 业务状态
            ,mforgid -- 主机机构号
            ,relativeduebillno -- 原始借据号
            ,loanno -- 贷款卡号
            ,remark -- 备注
            ,operatedate -- 经办日期
            ,operateuserid -- 业务经办人编号
            ,operateorgid -- 经办机构
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,repaydate -- 默认还款日
            ,mfcustomerid -- 核心客户号
            ,settlementaccount -- 结算账号
            ,overduedate -- 逾期日期
            ,oweinterestdate -- 欠息日期
            ,classifyresulteleven -- 风险分类结果（11级）
            ,overduerate -- 逾期利率
            ,mainorgid -- 机构代号(核心记账机构ID)
            ,remart -- 计量标记-资产三分类
            ,vouchtype2 -- 担保方式2
            ,vouchtype3 -- 担保方式3
            ,rateadjusttype -- 利率调整方式
            ,rateadjustfrequency -- 利率调整周期
            ,floatrange -- 浮动幅度
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountorgid -- 贷款入账(出账账户)账户开户机构
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,putoutorgid -- 出账机构编号(核心机构)
            ,dzhxstatus -- 呆账核销状态
            ,classifyresultelevendate -- 十一级分类日期
            ,loanaccountno -- 贷款入账账号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,loanstatus -- 贷款状态
            ,zxzflag -- 支小再专用标志（是否已报账） 1 ：是 2：否 3：已失效 1代表做过支小再业务2代表还未做过3代表该借据给在支小再业务中移除了
            ,assetflag -- 是否被认定为问题资产
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,wrndate -- 核销日期
            ,repayamt -- 实付金额
            ,prifirstduedate -- 本金未还最早日期
            ,intfirstduedate -- 利息未还最早日期
            ,compensateamt -- 代偿金额
            ,yjintamt -- 应计利息
            ,csyjintamt -- 催收应计利息
            ,ysintamt -- 应收欠息
            ,csintamt -- 催收欠息
            ,yjodpamt -- 应计罚息
            ,csyjodpamt -- 催收应计罚息
            ,ysodpamt -- 应收罚息
            ,csodpamt -- 催收罚息
            ,odppostedctddr -- 应收未收罚息
            ,odipostedctddr -- 应收未收复息
            ,yjodiamt -- 应计复息
            ,wrnpriamt -- 核销本金
            ,wrnintamt -- 核销利息
            ,wrnreceiptamt -- 核销回收金额
            ,intdate -- 下一结息日
            ,accountbalance -- 还款账号余额
            ,accountuserbalance -- 还款账户可用余额
            ,termtype -- 期限类型
            ,insum -- 累计归还本金
            ,interestinsum -- 累计归还利息
            ,exttradeno -- 原业务编号
            ,fyjbalamt -- 非应计余额
            ,periods -- 贷款总期数
            ,remain_periods -- 剩余还款期数
            ,lastclassifyresultten -- 上期十级分类标志
            ,lastclassifyresulttendate -- 上期十级分类日期
            ,classifyfivehchangedate -- 上一期五级分类变更日期
            ,tenclaind -- 十级分类人工干预标志1-人工、2-系统
            ,lastclassifyresult -- 上期五级分类结果
            ,lastclassifyresultdate -- 上期五级分类完成日期
            ,npltransflag -- 不良资产转让标识：转入转出
            ,reversalflag -- 冲正标志：Y-冲正，N-未冲正
            ,risktype -- 风险业务类型
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,loanaccountname -- 贷款入账(收款账户)账户名
            ,odiflag -- 是否复利
            ,odpflag -- 是否罚息
            ,compensatepotype -- 宽限到期日
            ,gracestartdate -- 宽限起始日
            ,loanserialno -- 风险监测关联流水号
            ,whethertorestructuretheloan -- 是否重组贷款
            ,restructuretheloantype -- 重组贷款类型
            ,ispensionindustry -- 养老产业标识
            ,gracetype -- 宽限期类型
            ,gearprodflag -- 是否靠档计息标识
            ,absflag -- 资产证券化标志
            ,intappltype -- 利率启用方式
            ,rollfreq -- 利率变更周期
            ,acctspreadrate -- 浮动百分点
            ,intindflag -- 是否计息
            ,intday -- 存贷结息日期
            ,inttype -- 利率类型
            ,interestbalance -- 利息余额
            ,paymentserialno -- 关联付款申请书编号
            ,actualoverduedays -- 实际逾期天数（来源核心系统）
            ,notificationstatus -- 债权通知书状态（客户级债权通知书）01-未确认,02-已确认
            ,principalbalance -- 本金余额(仅用于对账使用)
            ,tysumcp -- 同业系统本金余额(仅用于对账使用)
            ,originalloandeadline -- 原贷款到期日
            ,settlementaccountbank -- 结算账号开户行
            ,settlementaccountnum -- 结算账户序号
            ,restructuretheloandate -- 实施重组日期
            ,shareamount -- 分润金额
            ,overduecount -- 逾期次数
            ,firstoverduedate -- 首次逾期日期
            ,contoverduedate -- 连续逾期日期
            ,prioverduedays -- 本金逾期天数
            ,intoverduedays -- 利息逾期天数
            ,prioverdueamt -- 本金逾期金额
            ,intoverdueamt -- 利息逾期金额
            ,nextrolldate -- 下一重定价日期
            ,firstrolldate -- 首次重定价日期
            ,subproductname -- 子产品名称
            ,renewaltype -- 重组类型
            ,outrightsaleflag -- 卖断式转让标识
            ,incomerighttransferflag -- 收益权转让标识
            ,recoverflag -- 实时追缴标识
            ,speciallendflag -- 专项再贷款标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 借据编号
            ,putoutserialno -- 关联出账编号
            ,contractserialno -- 关联合同编号
            ,occurdate -- 发生日期
            ,occurtype -- 贷款发放类型
            ,vouchtype -- 主担保方式
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,productid -- 产品编号
            ,currency -- 币种
            ,businesssum -- 放款金额
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,putoutdate -- 发放日期
            ,maturity -- 约定到期日
            ,actualmaturity -- 实际到期日
            ,ratemodel -- 利率模式
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,executerate -- 执行年利率
            ,bailratio -- 保证金比例
            ,bailsum -- 保证金金额
            ,bailaccount -- 保证金账户编号
            ,repaytype -- 还款方式
            ,paymenttype -- 支付方式
            ,repaycycle -- 还款周期
            ,balance -- 贷款余额
            ,normalbalance -- 正常余额
            ,overduebalance -- 逾期余额
            ,dullbalance -- 呆滞余额
            ,badbalance -- 呆账余额
            ,extendtimes -- 展期次数
            ,innerinterestbalance -- 表内欠息余额
            ,outerinterestbalance -- 表外欠息余额
            ,capitalpenaltybalance -- 逾期罚息余额
            ,interestpenaltybalance -- 复息余额
            ,overduedays -- 贷款逾期天数
            ,owninterestdays -- 欠息天数
            ,ichangedate -- 欠息更新日期
            ,graceperiod -- 贷款宽限期
            ,reducereservesum -- 计提准备金额
            ,predictlostsum -- 预测损失金额
            ,finishtype -- 终结类型
            ,finishdate -- 终结日期
            ,belongdept -- 所属条线
            ,offsheetflag -- 表内外标志
            ,islowrisk -- 是否低风险
            ,badconfirmdate -- 首次认定不良日期
            ,classifyresult -- 贷款五级分类
            ,classifydate -- 风险分类日期
            ,advanceflag -- 担保代偿/垫款标志
            ,businessstatus -- 业务状态
            ,mforgid -- 主机机构号
            ,relativeduebillno -- 原始借据号
            ,loanno -- 贷款卡号
            ,remark -- 备注
            ,operatedate -- 经办日期
            ,operateuserid -- 业务经办人编号
            ,operateorgid -- 经办机构
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,repaydate -- 默认还款日
            ,mfcustomerid -- 核心客户号
            ,settlementaccount -- 结算账号
            ,overduedate -- 逾期日期
            ,oweinterestdate -- 欠息日期
            ,classifyresulteleven -- 风险分类结果（11级）
            ,overduerate -- 逾期利率
            ,mainorgid -- 机构代号(核心记账机构ID)
            ,remart -- 计量标记-资产三分类
            ,vouchtype2 -- 担保方式2
            ,vouchtype3 -- 担保方式3
            ,rateadjusttype -- 利率调整方式
            ,rateadjustfrequency -- 利率调整周期
            ,floatrange -- 浮动幅度
            ,settlementaccountname -- 结算账户(还款账户)名
            ,loanaccountorgid -- 贷款入账(出账账户)账户开户机构
            ,overdueratefloattype -- 逾期利率浮动方式
            ,overdueratefloatvalue -- 逾期利率浮动值
            ,putoutorgid -- 出账机构编号(核心机构)
            ,dzhxstatus -- 呆账核销状态
            ,classifyresultelevendate -- 十一级分类日期
            ,loanaccountno -- 贷款入账账号
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,loanstatus -- 贷款状态
            ,zxzflag -- 支小再专用标志（是否已报账） 1 ：是 2：否 3：已失效 1代表做过支小再业务2代表还未做过3代表该借据给在支小再业务中移除了
            ,assetflag -- 是否被认定为问题资产
            ,migtcustomerid -- 转换前客户号
            ,migtbusinesstype -- 转换前产品ID
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,wrndate -- 核销日期
            ,repayamt -- 实付金额
            ,prifirstduedate -- 本金未还最早日期
            ,intfirstduedate -- 利息未还最早日期
            ,compensateamt -- 代偿金额
            ,yjintamt -- 应计利息
            ,csyjintamt -- 催收应计利息
            ,ysintamt -- 应收欠息
            ,csintamt -- 催收欠息
            ,yjodpamt -- 应计罚息
            ,csyjodpamt -- 催收应计罚息
            ,ysodpamt -- 应收罚息
            ,csodpamt -- 催收罚息
            ,odppostedctddr -- 应收未收罚息
            ,odipostedctddr -- 应收未收复息
            ,yjodiamt -- 应计复息
            ,wrnpriamt -- 核销本金
            ,wrnintamt -- 核销利息
            ,wrnreceiptamt -- 核销回收金额
            ,intdate -- 下一结息日
            ,accountbalance -- 还款账号余额
            ,accountuserbalance -- 还款账户可用余额
            ,termtype -- 期限类型
            ,insum -- 累计归还本金
            ,interestinsum -- 累计归还利息
            ,exttradeno -- 原业务编号
            ,fyjbalamt -- 非应计余额
            ,periods -- 贷款总期数
            ,remain_periods -- 剩余还款期数
            ,lastclassifyresultten -- 上期十级分类标志
            ,lastclassifyresulttendate -- 上期十级分类日期
            ,classifyfivehchangedate -- 上一期五级分类变更日期
            ,tenclaind -- 十级分类人工干预标志1-人工、2-系统
            ,lastclassifyresult -- 上期五级分类结果
            ,lastclassifyresultdate -- 上期五级分类完成日期
            ,npltransflag -- 不良资产转让标识：转入转出
            ,reversalflag -- 冲正标志：Y-冲正，N-未冲正
            ,risktype -- 风险业务类型
            ,ratefloatratioorbp -- 利率浮动类型（1-按比例2-按点差）
            ,loanaccountname -- 贷款入账(收款账户)账户名
            ,odiflag -- 是否复利
            ,odpflag -- 是否罚息
            ,compensatepotype -- 宽限到期日
            ,gracestartdate -- 宽限起始日
            ,loanserialno -- 风险监测关联流水号
            ,whethertorestructuretheloan -- 是否重组贷款
            ,restructuretheloantype -- 重组贷款类型
            ,ispensionindustry -- 养老产业标识
            ,gracetype -- 宽限期类型
            ,gearprodflag -- 是否靠档计息标识
            ,absflag -- 资产证券化标志
            ,intappltype -- 利率启用方式
            ,rollfreq -- 利率变更周期
            ,acctspreadrate -- 浮动百分点
            ,intindflag -- 是否计息
            ,intday -- 存贷结息日期
            ,inttype -- 利率类型
            ,interestbalance -- 利息余额
            ,paymentserialno -- 关联付款申请书编号
            ,actualoverduedays -- 实际逾期天数（来源核心系统）
            ,notificationstatus -- 债权通知书状态（客户级债权通知书）01-未确认,02-已确认
            ,principalbalance -- 本金余额(仅用于对账使用)
            ,tysumcp -- 同业系统本金余额(仅用于对账使用)
            ,originalloandeadline -- 原贷款到期日
            ,settlementaccountbank -- 结算账号开户行
            ,settlementaccountnum -- 结算账户序号
            ,restructuretheloandate -- 实施重组日期
            ,shareamount -- 分润金额
            ,overduecount -- 逾期次数
            ,firstoverduedate -- 首次逾期日期
            ,contoverduedate -- 连续逾期日期
            ,prioverduedays -- 本金逾期天数
            ,intoverduedays -- 利息逾期天数
            ,prioverdueamt -- 本金逾期金额
            ,intoverdueamt -- 利息逾期金额
            ,nextrolldate -- 下一重定价日期
            ,firstrolldate -- 首次重定价日期
            ,subproductname -- 子产品名称
            ,renewaltype -- 重组类型
            ,' ' as outrightsaleflag -- 卖断式转让标识
            ,' ' as incomerighttransferflag -- 收益权转让标识
            ,' ' as recoverflag -- 实时追缴标识
            ,' ' as speciallendflag -- 专项再贷款标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from icms_business_duebill_bak_${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
