/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_jdjr_acc_loan
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
                       FROM icms_jdjr_acc_loan_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('icms_jdjr_acc_loan');
  
  if v_var <> 0 then 
    execute immediate 'alter table icms_jdjr_acc_loan drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table icms_jdjr_acc_loan add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.icms_jdjr_acc_loan(
            contno -- 客户签订的合同号码，即借据号、出资方贷款单号
            ,countenchashfee -- 应计取现手续费
            ,laonrealityrate -- 借款执行利率
            ,limitno -- 客户额度编号
            ,cusid -- 客户号
            ,prdcode -- 产品编号(行内)
            ,enchashfeerate -- 取现手续费利率
            ,cusno -- 京东pin
            ,loanterms -- 贷款期数
            ,lpr -- LPR
            ,instovdinterest -- 改分期逾期利息
            ,volfeerate -- 违约金利率
            ,loaninneraccount -- 贷款入帐账号
            ,ratefloatmode -- 利率浮动方式
            ,iswhite -- 
            ,bussdate -- 数据日期
            ,instpricbalance -- 改分期本金余额
            ,loanrepayaccount -- 还款账号
            ,execrate -- 执行年利率，京东推送日利率X360
            ,floatratebp -- 利率浮动点差BP
            ,loanserno -- 放款流水号
            ,certno -- 证件号
            ,intovdstartdt -- 利息逾期日期
            ,loanovdbalance -- 逾期贷款余额
            ,inpnltamt -- 应计罚息
            ,withenchashfeeday -- 当日计提取现手续费
            ,repayinthz -- 利息还款频率
            ,prinovdstartdt -- 本金逾期日期
            ,loanoutintbalance -- 表外欠息
            ,loanrate -- 借款利率
            ,laonrealityratetype -- 借款执行利率类型
            ,feeratetype -- 手续费费率类型D、日M、月W、周
            ,isbankrel -- 是否关联人1是2否
            ,currency -- 参见币种表
            ,instpricovdbalance -- 改分期本金逾期余额
            ,migtflag -- 
            ,loanenddt -- 业务到期日期
            ,prdno -- 产品编号
            ,loanstartdt -- 放款日期
            ,localarea -- 贷款资金使用位置
            ,intnextpaydt -- 下一付息日
            ,intflag -- 计息标志
            ,repaychangetype -- 新增还款变更类型
            ,volfeeratetype -- 违约金费率类型
            ,loanno -- 借据号
            ,ovdterms -- 逾期期数
            ,countvolfee -- 应计违约金
            ,loanstatus -- 贷款状态
            ,pnltrate -- 罚息利率
            ,loanratetype -- 借款利率类型
            ,instinterest -- 改分期利息
            ,volfeeday -- 当日违约金
            ,assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
            ,selfpayamt -- 自主支付金额
            ,todaypnltintamt -- 当日罚息
            ,instintpenalty -- 改分期罚息
            ,busmodel -- 业务模式
            ,loanamt -- 贷款放款金额
            ,repayprinhz -- 本金还款频率
            ,ratetype -- 利率调整方式
            ,todayintamt -- 当日利息
            ,cusname -- 客户姓名
            ,ratelprtype -- 利率类型1基准利率2LPR
            ,loansucessreceivedate -- 放款成功接收日期YYYYMMMMDD
            ,loanbalance -- 贷款余额
            ,loanovdintbalance -- 逾期利息
            ,granttype -- 贷款担保方式
            ,repaytype -- 还款方式
            ,ordinterest -- 普通利息
            ,ordovdinterest -- 普通逾期利息
            ,ordintpenalty -- 普通罚息
            ,unrepaysterms -- 待还期数
            ,outterms -- 表外期数
            ,ovdflag -- 贷款逾期标志
            ,intamt -- 应计利息
            ,inputid -- 所属客户经理
            ,ordpricbalance -- 普通本金余额
            ,ovddays -- 逾期天数
            ,ordpricovdbalance -- 普通本金逾期余额
            ,pnltratetype -- 罚息利率类型
            ,loanuseway -- 借款用途
            ,entrustedpayamt -- 受托支付金额
            ,extenddays -- 逾期宽限天数
            ,cleardate -- 结清日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            contno -- 客户签订的合同号码，即借据号、出资方贷款单号
            ,countenchashfee -- 应计取现手续费
            ,laonrealityrate -- 借款执行利率
            ,limitno -- 客户额度编号
            ,cusid -- 客户号
            ,prdcode -- 产品编号(行内)
            ,enchashfeerate -- 取现手续费利率
            ,cusno -- 京东pin
            ,loanterms -- 贷款期数
            ,lpr -- LPR
            ,instovdinterest -- 改分期逾期利息
            ,volfeerate -- 违约金利率
            ,loaninneraccount -- 贷款入帐账号
            ,ratefloatmode -- 利率浮动方式
            ,iswhite -- 
            ,bussdate -- 数据日期
            ,instpricbalance -- 改分期本金余额
            ,loanrepayaccount -- 还款账号
            ,execrate -- 执行年利率，京东推送日利率X360
            ,floatratebp -- 利率浮动点差BP
            ,loanserno -- 放款流水号
            ,certno -- 证件号
            ,intovdstartdt -- 利息逾期日期
            ,loanovdbalance -- 逾期贷款余额
            ,inpnltamt -- 应计罚息
            ,withenchashfeeday -- 当日计提取现手续费
            ,repayinthz -- 利息还款频率
            ,prinovdstartdt -- 本金逾期日期
            ,loanoutintbalance -- 表外欠息
            ,loanrate -- 借款利率
            ,laonrealityratetype -- 借款执行利率类型
            ,feeratetype -- 手续费费率类型D、日M、月W、周
            ,isbankrel -- 是否关联人1是2否
            ,currency -- 参见币种表
            ,instpricovdbalance -- 改分期本金逾期余额
            ,migtflag -- 
            ,loanenddt -- 业务到期日期
            ,prdno -- 产品编号
            ,loanstartdt -- 放款日期
            ,localarea -- 贷款资金使用位置
            ,intnextpaydt -- 下一付息日
            ,intflag -- 计息标志
            ,repaychangetype -- 新增还款变更类型
            ,volfeeratetype -- 违约金费率类型
            ,loanno -- 借据号
            ,ovdterms -- 逾期期数
            ,countvolfee -- 应计违约金
            ,loanstatus -- 贷款状态
            ,pnltrate -- 罚息利率
            ,loanratetype -- 借款利率类型
            ,instinterest -- 改分期利息
            ,volfeeday -- 当日违约金
            ,assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
            ,selfpayamt -- 自主支付金额
            ,todaypnltintamt -- 当日罚息
            ,instintpenalty -- 改分期罚息
            ,busmodel -- 业务模式
            ,loanamt -- 贷款放款金额
            ,repayprinhz -- 本金还款频率
            ,ratetype -- 利率调整方式
            ,todayintamt -- 当日利息
            ,cusname -- 客户姓名
            ,ratelprtype -- 利率类型1基准利率2LPR
            ,loansucessreceivedate -- 放款成功接收日期YYYYMMMMDD
            ,loanbalance -- 贷款余额
            ,loanovdintbalance -- 逾期利息
            ,granttype -- 贷款担保方式
            ,repaytype -- 还款方式
            ,ordinterest -- 普通利息
            ,ordovdinterest -- 普通逾期利息
            ,ordintpenalty -- 普通罚息
            ,unrepaysterms -- 待还期数
            ,outterms -- 表外期数
            ,ovdflag -- 贷款逾期标志
            ,intamt -- 应计利息
            ,inputid -- 所属客户经理
            ,ordpricbalance -- 普通本金余额
            ,ovddays -- 逾期天数
            ,ordpricovdbalance -- 普通本金逾期余额
            ,pnltratetype -- 罚息利率类型
            ,loanuseway -- 借款用途
            ,entrustedpayamt -- 受托支付金额
            ,extenddays -- 逾期宽限天数
            ,' ' as cleardate -- 结清日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_jdjr_acc_loan_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
