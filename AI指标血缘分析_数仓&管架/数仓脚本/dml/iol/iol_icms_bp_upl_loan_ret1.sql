/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_BP_UPL_LOAN_ret1
CreateDate: 20240712_月度版本
Logs:
     SUNDEXIN 新建脚本 
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
                       FROM ICMS_BP_UPL_LOAN_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_BP_UPL_LOAN');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_BP_UPL_LOAN drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_BP_UPL_LOAN add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_BP_UPL_LOAN(
            serialno -- 出账流水号
            ,paybankno -- 收款人行号
            ,mfcustomerid -- 核心客户编号
            ,migtflag -- 
            ,oldtradedate -- 原交易日期
            ,oldtradeserialno -- 原交易流水号
            ,loanterm -- 贷款期限
            ,vouchmode -- 担保方式
            ,repaymode -- 付款方式
            ,begintime -- 开始时间
            ,loankind -- 期限类型
            ,trustpayaccountno -- 受托支付账号
            ,paysource -- 还款说明
            ,loantype -- 贷款类型
            ,businessserialno -- 交易流水号
            ,warrantorid -- 主要担保人编码
            ,warrantor -- 主要担保人
            ,uplaccountno -- 微贷结算账号
            ,stayentrustnumber -- 待受托划款的笔数
            ,paybankaddcode -- 收款人开户行地点
            ,holdcorpus -- 保留本金
            ,crstranseqno -- 正向交易流水号
            ,uplpayaccountno2 -- 微贷还款账户2
            ,paybankname -- 收款人行名
            ,subbusinesstype -- 助贷业务品种
            ,uplpayaccountno1 -- 微贷还款账户1
            ,tradedate -- 交易日期
            ,putoutstatus -- 出账状态
            ,bankinoutflag -- 行内外标识
            ,errorinfo -- 错误信息
            ,paybankkindcode -- 收款人开户行类别
            ,trustpayaccountname -- 受托支付户名
            ,batchpaymentflag -- 是否参与批扣
            ,userid -- 用户编号
            ,payaccountno2 -- 第二还款账户
            ,actualbegintime -- 实际开始时间
            ,exchangetype -- 交易类型
            ,payprinintvl -- 贷款还息间隔
            ,incomeorgid -- 入账机构
            ,payaccountname2 -- 第二还款账户名
            ,crstrandate -- 正向交易日期
            ,paymentmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 出账流水号
            ,paybankno -- 收款人行号
            ,mfcustomerid -- 核心客户编号
            ,migtflag -- 
            ,oldtradedate -- 原交易日期
            ,oldtradeserialno -- 原交易流水号
            ,loanterm -- 贷款期限
            ,vouchmode -- 担保方式
            ,repaymode -- 付款方式
            ,begintime -- 开始时间
            ,loankind -- 期限类型
            ,trustpayaccountno -- 受托支付账号
            ,paysource -- 还款说明
            ,loantype -- 贷款类型
            ,businessserialno -- 交易流水号
            ,warrantorid -- 主要担保人编码
            ,warrantor -- 主要担保人
            ,uplaccountno -- 微贷结算账号
            ,stayentrustnumber -- 待受托划款的笔数
            ,paybankaddcode -- 收款人开户行地点
            ,holdcorpus -- 保留本金
            ,crstranseqno -- 正向交易流水号
            ,uplpayaccountno2 -- 微贷还款账户2
            ,paybankname -- 收款人行名
            ,subbusinesstype -- 助贷业务品种
            ,uplpayaccountno1 -- 微贷还款账户1
            ,tradedate -- 交易日期
            ,putoutstatus -- 出账状态
            ,bankinoutflag -- 行内外标识
            ,errorinfo -- 错误信息
            ,paybankkindcode -- 收款人开户行类别
            ,trustpayaccountname -- 受托支付户名
            ,batchpaymentflag -- 是否参与批扣
            ,userid -- 用户编号
            ,payaccountno2 -- 第二还款账户
            ,actualbegintime -- 实际开始时间
            ,exchangetype -- 交易类型
            ,payprinintvl -- 贷款还息间隔
            ,incomeorgid -- 入账机构
            ,payaccountname2 -- 第二还款账户名
            ,crstrandate -- 正向交易日期
            ,' ' AS paymentmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_BP_UPL_LOAN_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
