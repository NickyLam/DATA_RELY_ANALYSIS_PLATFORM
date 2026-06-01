/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcrs_myjb_acc_loan3
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
                       FROM icms_mybk_acc_loan_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_MYBK_ACC_LOAN');
  
  if v_var <> 0 then 
    execute immediate 'alter table icms_mybk_acc_loan drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table icms_mybk_acc_loan add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;
    
insert /*+ append */ into icms_mybk_acc_loan(
        contractno -- 借据号
        ,dayrate -- 贷款日利率
        ,encashaccttype -- 收款帐号类型
        ,prinovddays -- 本金逾期天数
        ,encashbankname -- 收款银行名称
        ,repayaccttype -- 还款帐号类型
        ,cleardate -- 结清日期
        ,encashamt -- 放款金额
        ,intbal -- 正常利息余额
        ,lpr -- LPR
        ,opttype -- 转让类型，转出（OUT）\转入（IN）
        ,bsntype -- 产品业务类型
        ,loanuse -- 贷款用途
        ,settledate -- 会计日期
        ,typecontributionration -- 出资比例类型
        ,industrytype -- 贷款投向行业
        ,fundseqno -- 放款资金流水号
        ,creditno -- 授信编号
        ,encashacctno -- 收款帐号
        ,repayacctno -- 还款帐号
        ,ovdintpnltbal -- 逾期利息罚息余额
        ,writeoff -- 核销标识，已核销为Y，否则为N
        ,assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
        ,intrepayfrequency -- 利息还款频率
        ,repaybankname -- 还款银行名称
        ,ovdterms -- 逾期期次数
        ,contributionration -- 出资比例
        ,repaymode -- 还款方式
        ,encashacctname -- 收款账号户名
        ,prinbal -- 正常本金余额
        ,cusmgrid -- 客户经理
        ,loanstatus -- 贷款状态
        ,enddate -- 贷款到期日
        ,accruedstatus -- 应计非应计标识
        ,ipid -- 用户ID
        ,iswhite -- 是否白户
        ,currency -- 币种
        ,prinrepayfrequency -- 本金还款频率
        ,repayacctname -- 还款账号户名
        ,assetclass -- 五级分类标识
        ,intovddays -- 利息逾期天数
        ,ovdintbal -- 逾期利息余额
        ,execrate -- 执行年利率，网商贷推送日利率X360
        ,migtflag -- 
        ,biztype -- 业务种类
        ,prodcode -- 产品码
        ,name -- 客户真实姓名
        ,applydate -- 申请支用时间
        ,totalterms -- 贷款期次数
        ,guaranteetype -- 担保类型
        ,ovdprinbal -- 逾期本金余额
        ,ovdprinpnltbal -- 逾期本金罚息余额
        ,ratelprtype -- 利率类型1基准利率2LPR
        ,encashdate -- 放款日期
        ,ratetype -- 利率类型
        ,nextrepaydate -- 下一还款日期
        ,unclearterms -- 未结清期数
        ,ratefloatmode -- 利率浮动方式
        ,isbankrel -- 是否关联人1是2否
        ,certtype -- 证件类型
        ,usearea -- 贷款资金使用位置
        ,graceday -- 宽限期天数
        ,status -- 合约状态
        ,certno -- 客户证件号码
        ,startdate -- 贷款起息日
        ,cusid -- 客户号
        ,floatratebp -- 利率上限浮动点差BP
        ,businessesflag -- 客群经营标签（人行口径）
        ,agriflg -- 是否农户
        ,classifyresult -- 五级分类标识(信贷)
        ,encashbanknm -- 收款银行名称
        ,externalserialno -- 清算交易编号
        ,isdebttransfer -- 是否债权直转(1是/0否)
        ,inputdate -- 登记日期
        ,updatedate -- 更新日期
        ,selfencashamt -- 我行贷款金额
        ,selfterms -- 我行贷款总期数
        ,selfstartdate -- 我行贷款起始日
        ,contracttype -- 网商借据类型
        ,contractserialno -- 合同编号
        ,oldenddate -- 原借据到期日
        ,isregroup -- 是否重组
        ,regroupdate -- 重组日期
        ,regrouptype -- 重组贷款类型
        ,regroupcontractno -- 重组前借据号（多笔借据间用|分隔）
        ,occurtype -- 发生方式
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
            contractno -- 借据号
        ,dayrate -- 贷款日利率
        ,encashaccttype -- 收款帐号类型
        ,prinovddays -- 本金逾期天数
        ,encashbankname -- 收款银行名称
        ,repayaccttype -- 还款帐号类型
        ,cleardate -- 结清日期
        ,encashamt -- 放款金额
        ,intbal -- 正常利息余额
        ,lpr -- LPR
        ,opttype -- 转让类型，转出（OUT）\转入（IN）
        ,bsntype -- 产品业务类型
        ,loanuse -- 贷款用途
        ,settledate -- 会计日期
        ,typecontributionration -- 出资比例类型
        ,industrytype -- 贷款投向行业
        ,fundseqno -- 放款资金流水号
        ,creditno -- 授信编号
        ,encashacctno -- 收款帐号
        ,repayacctno -- 还款帐号
        ,ovdintpnltbal -- 逾期利息罚息余额
        ,writeoff -- 核销标识，已核销为Y，否则为N
        ,assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
        ,intrepayfrequency -- 利息还款频率
        ,repaybankname -- 还款银行名称
        ,ovdterms -- 逾期期次数
        ,contributionration -- 出资比例
        ,repaymode -- 还款方式
        ,encashacctname -- 收款账号户名
        ,prinbal -- 正常本金余额
        ,cusmgrid -- 客户经理
        ,loanstatus -- 贷款状态
        ,enddate -- 贷款到期日
        ,accruedstatus -- 应计非应计标识
        ,ipid -- 用户ID
        ,iswhite -- 是否白户
        ,currency -- 币种
        ,prinrepayfrequency -- 本金还款频率
        ,repayacctname -- 还款账号户名
        ,assetclass -- 五级分类标识
        ,intovddays -- 利息逾期天数
        ,ovdintbal -- 逾期利息余额
        ,execrate -- 执行年利率，网商贷推送日利率X360
        ,migtflag -- 
        ,biztype -- 业务种类
        ,prodcode -- 产品码
        ,name -- 客户真实姓名
        ,applydate -- 申请支用时间
        ,totalterms -- 贷款期次数
        ,guaranteetype -- 担保类型
        ,ovdprinbal -- 逾期本金余额
        ,ovdprinpnltbal -- 逾期本金罚息余额
        ,ratelprtype -- 利率类型1基准利率2LPR
        ,encashdate -- 放款日期
        ,ratetype -- 利率类型
        ,nextrepaydate -- 下一还款日期
        ,unclearterms -- 未结清期数
        ,ratefloatmode -- 利率浮动方式
        ,isbankrel -- 是否关联人1是2否
        ,certtype -- 证件类型
        ,usearea -- 贷款资金使用位置
        ,graceday -- 宽限期天数
        ,status -- 合约状态
        ,certno -- 客户证件号码
        ,startdate -- 贷款起息日
        ,cusid -- 客户号
        ,floatratebp -- 利率上限浮动点差BP
        ,businessesflag -- 客群经营标签（人行口径）
        ,agriflg -- 是否农户
        ,classifyresult -- 五级分类标识(信贷)
        ,encashbanknm -- 收款银行名称
        ,externalserialno -- 清算交易编号
        ,isdebttransfer -- 是否债权直转(1是/0否)
        ,inputdate -- 登记日期
        ,updatedate -- 更新日期
        ,selfencashamt -- 我行贷款金额
        ,selfterms -- 我行贷款总期数
        ,selfstartdate -- 我行贷款起始日
        ,contracttype -- 网商借据类型
        ,contractserialno -- 合同编号
        ,oldenddate -- 原借据到期日
        ,isregroup -- 是否重组
        ,regroupdate -- 重组日期
        ,regrouptype -- 重组贷款类型
        ,regroupcontractno -- 重组前借据号（多笔借据间用|分隔）
        ,' ' as occurtype -- 发生方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from icms_mybk_acc_loan_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
