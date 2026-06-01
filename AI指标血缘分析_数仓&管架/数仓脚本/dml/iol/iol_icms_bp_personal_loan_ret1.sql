/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_bp_personal_loan_ret1
CreateDate: 20250603
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
                       FROM icms_bp_personal_loan_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('icms_bp_personal_loan');

  if v_var <> 0 then
    execute immediate 'alter table icms_bp_personal_loan drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table icms_bp_personal_loan add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.icms_bp_personal_loan (
    serialno -- 出账流水号
    ,isnogroup -- 是否集团客户
    ,groupcustname -- 集团客户名称
    ,relationship -- 借款人与集团关系
    ,payee_bank_name -- 收款人行名
    ,loanfinishdate -- 贷款终止日
    ,putouttime -- 放款时间
    ,payorderid -- 支付订单号
    ,isrecordtax -- 是否录入印花税
    ,payaccounttel -- 开户绑定手机号
    ,loanbegindate -- 贷款发放日
    ,payacctno -- 受托支付账号编号
    ,channelcode -- 放款渠道码
    ,remark -- 备注
    ,loanstage -- 贷款期数
    ,loantruedate -- 贷款实际发放日
    ,guacontno -- 担保保证函编号
    ,taxaccount -- 印花税扣税账号
    ,repaydatetype -- 还款日确定
    ,imageno -- 影像编号
    ,approveenddate -- 放款结束时间
    ,taxaccountname -- 印花税扣税账号名称
    ,putoutconditionremark -- 出账落实条件说明
    ,groupcustcode -- 集团客户号
    ,informflag -- 放款通知是否成功
    ,approvestartdate -- 审批开始时间
    ,availexposure -- 集团客户可用敞口额度
    ,migtflag -- 迁移标志：crs rcr ilc upl
    ,applysum -- 申请放款金额
    ,taxamount -- 印花税金额
    ,imageupflag -- 影像上传结果1完成上传2未完成上传
    ,paymentmethodtype -- 支付工具类型
    ,confirmstate -- 受托支付确认状态
    ,confirmtime -- 受托支付确认时间
    ,checkresult -- 风控规则结果
    ,payaccounttype -- 卡类型0:本行卡1:他行卡
    ,repaymentmethodtype -- 还款支付工具类型
    ,cashsum -- 自主支付金额
    ,exchangeresultremark -- 交易结果描述
    ,balldate -- 气球贷摊销日期
    ,relaserialno -- 关联流水号
    ,isbelongterm -- 是否靠档计息
    ,productchannel -- 产品渠道标识
    ,moneylevelresult -- 命中反洗钱评级情况（0-未命中,1-命中,2-仅命中）
    ,isicmsfactory -- 信贷工厂模式（01-是,02-否,03-无）
    ,recoverflag -- 实时追缴标志字段：N否，Y是
    ,repayacctwthrobankcard -- 还款账户是否他行卡：N否，Y是
    ,postacctwthrobankcard -- 入账账户是否他行卡：N否，Y是
    ,hangseqno -- 挂账序列号
    ,settleprodtype -- 入账账户产品类型
    ,loanprodtype -- 还款账户产品类型
    ,nextcycledate -- 下一结息日
    ,finalmerger -- 末期合并
    ,prerepaydeal -- 还款计划变更方式
    ,invstflg -- 尽调标志（N否，Y是，是否尽调为否的时候则为互联网业务）
    ,offlchkidenflg -- 线下核身标志（N否，Y是）
    ,iscentralizedaccount -- 是否集中出账（好企贷IPC产品）
    ,priceorderno -- 定价单号
    ,priceapprovestatus -- 定价单审批状态
    ,priceenddate -- 定价单生效截止日
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_timestamp -- ETL处理时间戳
)
select
    serialno as serialno -- 出账流水号
    ,isnogroup as isnogroup -- 是否集团客户
    ,groupcustname as groupcustname -- 集团客户名称
    ,relationship as relationship -- 借款人与集团关系
    ,payee_bank_name as payee_bank_name -- 收款人行名
    ,loanfinishdate as loanfinishdate -- 贷款终止日
    ,putouttime as putouttime -- 放款时间
    ,payorderid as payorderid -- 支付订单号
    ,isrecordtax as isrecordtax -- 是否录入印花税
    ,payaccounttel as payaccounttel -- 开户绑定手机号
    ,loanbegindate as loanbegindate -- 贷款发放日
    ,payacctno as payacctno -- 受托支付账号编号
    ,channelcode as channelcode -- 放款渠道码
    ,remark as remark -- 备注
    ,loanstage as loanstage -- 贷款期数
    ,loantruedate as loantruedate -- 贷款实际发放日
    ,guacontno as guacontno -- 担保保证函编号
    ,taxaccount as taxaccount -- 印花税扣税账号
    ,repaydatetype as repaydatetype -- 还款日确定
    ,imageno as imageno -- 影像编号
    ,approveenddate as approveenddate -- 放款结束时间
    ,taxaccountname as taxaccountname -- 印花税扣税账号名称
    ,putoutconditionremark as putoutconditionremark -- 出账落实条件说明
    ,groupcustcode as groupcustcode -- 集团客户号
    ,informflag as informflag -- 放款通知是否成功
    ,approvestartdate as approvestartdate -- 审批开始时间
    ,availexposure as availexposure -- 集团客户可用敞口额度
    ,migtflag as migtflag -- 迁移标志：crs rcr ilc upl
    ,applysum as applysum -- 申请放款金额
    ,taxamount as taxamount -- 印花税金额
    ,imageupflag as imageupflag -- 影像上传结果1完成上传2未完成上传
    ,paymentmethodtype as paymentmethodtype -- 支付工具类型
    ,confirmstate as confirmstate -- 受托支付确认状态
    ,confirmtime as confirmtime -- 受托支付确认时间
    ,checkresult as checkresult -- 风控规则结果
    ,payaccounttype as payaccounttype -- 卡类型0:本行卡1:他行卡
    ,repaymentmethodtype as repaymentmethodtype -- 还款支付工具类型
    ,cashsum as cashsum -- 自主支付金额
    ,exchangeresultremark as exchangeresultremark -- 交易结果描述
    ,balldate as balldate -- 气球贷摊销日期
    ,relaserialno as relaserialno -- 关联流水号
    ,isbelongterm as isbelongterm -- 是否靠档计息
    ,productchannel as productchannel -- 产品渠道标识
    ,moneylevelresult as moneylevelresult -- 命中反洗钱评级情况（0-未命中,1-命中,2-仅命中）
    ,isicmsfactory as isicmsfactory -- 信贷工厂模式（01-是,02-否,03-无）
    ,recoverflag as recoverflag -- 实时追缴标志字段：N否，Y是
    ,repayacctwthrobankcard as repayacctwthrobankcard -- 还款账户是否他行卡：N否，Y是
    ,postacctwthrobankcard as postacctwthrobankcard -- 入账账户是否他行卡：N否，Y是
    ,hangseqno as hangseqno -- 挂账序列号
    ,settleprodtype as settleprodtype -- 入账账户产品类型
    ,loanprodtype as loanprodtype -- 还款账户产品类型
    ,nextcycledate as nextcycledate -- 下一结息日
    ,finalmerger as finalmerger -- 末期合并
    ,prerepaydeal as prerepaydeal -- 还款计划变更方式
    ,invstflg as invstflg -- 尽调标志（N否，Y是，是否尽调为否的时候则为互联网业务）
    ,offlchkidenflg as offlchkidenflg -- 线下核身标志（N否，Y是）
    ,' ' as iscentralizedaccount -- 是否集中出账（好企贷IPC产品）
    ,' ' as priceorderno -- 定价单号
    ,' ' as priceapprovestatus -- 定价单审批状态
    ,' ' as priceenddate -- 定价单生效截止日
    ,start_dt as start_dt -- 开始时间
    ,end_dt as end_dt -- 结束时间
    ,id_mark as id_mark -- 增删标志
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_bp_personal_loan_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

