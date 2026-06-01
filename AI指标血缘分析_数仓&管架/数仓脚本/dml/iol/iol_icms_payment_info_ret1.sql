/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_PAYMENT_INFO_ret1
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
                       FROM ICMS_PAYMENT_INFO_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_PAYMENT_INFO');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_PAYMENT_INFO drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_PAYMENT_INFO add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_PAYMENT_INFO(
            serialno -- 支付流水号
            ,maxpaydate -- 最迟支付日
            ,entrustedno -- 受托支付编号
            ,pigeonholedate -- 归档日期
            ,updateorgid -- 更新机构
            ,corporgid -- 法人机构编号
            ,updatedate -- 更新日期
            ,zfjyserialno -- 在线受托支付-止付交易流水号
            ,putoutserialno -- 放贷流水号
            ,paymentdate -- 支付日期
            ,payeename -- 收款人名称
            ,docid -- 交易代码
            ,inputorgid -- 登记机构
            ,sequencenum -- 支付序列号
            ,resenddatetime -- 重新发送时间
            ,capitalpurpose -- 资金用途
            ,inputdate -- 登记日期
            ,transeqno -- 平台请求流水号
            ,confirmstatus -- 确认状态
            ,isreservepay -- 是否预约受托支付
            ,rowno -- 明细流水号
            ,objectno -- 受托支付汇总记录编号
            ,remark -- 备注
            ,cause -- 支付失败原因
            ,batchno -- 受托支付批次号
            ,transformno -- 平台交易流水号
            ,freezeseqno -- 冻结流水号
            ,isinneraccount -- 是否行内账号
            ,actualpaydate -- 实际支付日期
            ,zfserialno -- 止付流水号
            ,iskj -- 是否跨境
            ,customerid -- 客户编号
            ,payeebank -- 收款人开户行
            ,currency -- 币种
            ,inputuserid -- 登记人
            ,paystatus -- 在线受托支付-支付状态码值BillPayStatus
            ,paymenttime -- 支付时间（10/15）
            ,updateuserid -- 更新人
            ,zfdate -- 止付交易日期
            ,plattrxseq -- 在线受托支付-原交易平台流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,payeeaccount -- 收款账户号
            ,payeebankname -- 转入行名
            ,customername -- 客户名称
            ,paymentsum -- 支付金额
            ,paymentstatus -- 支付状态
            ,trxdate -- 平台交易日期
            ,entrustedpayid -- 受托支付序号
            ,isinuse -- 添加维护标志1正常2不维护
            ,resendstatus -- 重发状态
            ,isbankaccount -- 是否是本行客户
            ,payeenameadd -- 收款人地址
            ,capitalpurposedesc -- 贷款用途描述
            ,paymenttype -- 
            ,payeecertid -- 
            ,bcsacctseqnum -- 
            ,commodityamt -- 
            ,businessname -- 
            ,businesscertcode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 支付流水号
            ,maxpaydate -- 最迟支付日
            ,entrustedno -- 受托支付编号
            ,pigeonholedate -- 归档日期
            ,updateorgid -- 更新机构
            ,corporgid -- 法人机构编号
            ,updatedate -- 更新日期
            ,zfjyserialno -- 在线受托支付-止付交易流水号
            ,putoutserialno -- 放贷流水号
            ,paymentdate -- 支付日期
            ,payeename -- 收款人名称
            ,docid -- 交易代码
            ,inputorgid -- 登记机构
            ,sequencenum -- 支付序列号
            ,resenddatetime -- 重新发送时间
            ,capitalpurpose -- 资金用途
            ,inputdate -- 登记日期
            ,transeqno -- 平台请求流水号
            ,confirmstatus -- 确认状态
            ,isreservepay -- 是否预约受托支付
            ,rowno -- 明细流水号
            ,objectno -- 受托支付汇总记录编号
            ,remark -- 备注
            ,cause -- 支付失败原因
            ,batchno -- 受托支付批次号
            ,transformno -- 平台交易流水号
            ,freezeseqno -- 冻结流水号
            ,isinneraccount -- 是否行内账号
            ,actualpaydate -- 实际支付日期
            ,zfserialno -- 止付流水号
            ,iskj -- 是否跨境
            ,customerid -- 客户编号
            ,payeebank -- 收款人开户行
            ,currency -- 币种
            ,inputuserid -- 登记人
            ,paystatus -- 在线受托支付-支付状态码值BillPayStatus
            ,paymenttime -- 支付时间（10/15）
            ,updateuserid -- 更新人
            ,zfdate -- 止付交易日期
            ,plattrxseq -- 在线受托支付-原交易平台流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,payeeaccount -- 收款账户号
            ,payeebankname -- 转入行名
            ,customername -- 客户名称
            ,paymentsum -- 支付金额
            ,paymentstatus -- 支付状态
            ,trxdate -- 平台交易日期
            ,entrustedpayid -- 受托支付序号
            ,isinuse -- 添加维护标志1正常2不维护
            ,resendstatus -- 重发状态
            ,isbankaccount -- 是否是本行客户
            ,payeenameadd -- 收款人地址
            ,capitalpurposedesc -- 贷款用途描述
            ,' ' AS paymenttype -- 
            ,' ' AS payeecertid -- 
            ,' ' AS bcsacctseqnum -- 
            ,0 AS commodityamt -- 
            ,' ' AS businessname -- 
            ,' ' AS businesscertcode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_PAYMENT_INFO_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
