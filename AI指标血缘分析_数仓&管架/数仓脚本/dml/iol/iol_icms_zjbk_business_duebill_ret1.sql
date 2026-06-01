/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_zjbk_business_duebill_ret1
CreateDate: 20250515
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
                       FROM icms_zjbk_business_duebill_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('icms_zjbk_business_duebill');

  if v_var <> 0 then
    execute immediate 'alter table icms_zjbk_business_duebill drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table icms_zjbk_business_duebill add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.icms_zjbk_business_duebill (
    loanid -- 借据号
    ,putoutserialno -- 出账流水号
    ,contractserialno -- 合同流水号
    ,customerid -- 客户号
    ,customername -- 客户名称
    ,status -- 状态
    ,termmonth -- 期限
    ,ratemodel -- 利率模式
    ,baseratetype -- 基准利率类型
    ,baserate -- 基准利率
    ,ratefloattype -- 利率浮动方式
    ,executerate -- 执行利率
    ,overduerate -- 逾期利率
    ,rateadjusttype -- 利率调整方式
    ,rateadjustfrequency -- 利率调整周期
    ,floatrange -- 浮动幅度
    ,overdueratefloattype -- 逾期利率浮动方式
    ,overdueratefloatvalue -- 逾期利率浮动值
    ,classifyresult -- 贷款五级分类
    ,applydate -- 申请日期
    ,startdate -- 开始日期
    ,enddate -- 到期日期
    ,overduedate -- 逾期日期
    ,cleardate -- 结清日期
    ,encashamt -- 借据金额
    ,currency -- 币种
    ,repaymode -- 还款方式
    ,repaycycle -- 还款周期
    ,totalterms -- 总期数
    ,curterm -- 当前期数
    ,repayday -- 还款日
    ,graceday -- 宽限期
    ,loanstatus -- 贷款状态
    ,loanform -- 贷款形态
    ,printotal -- 应还本金
    ,prinrepay -- 已还本金
    ,prinbal -- 正常本金余额
    ,ovdprinbal -- 逾期本金余额
    ,intplan -- 计划利息
    ,inttotal -- 应还利息
    ,intrepay -- 已还利息
    ,intdiscount -- 减免利息
    ,intbal -- 利息余额
    ,ovdintbal -- 逾期利息余额
    ,pnltinttotal -- 应收罚息
    ,pnltintrepay -- 已还罚息
    ,pnltintdiscount -- 减免罚息
    ,pnltintbal -- 罚息余额
    ,prepmtfeerepay -- 已还提前还款手续费
    ,productno -- 字节产品编号
    ,outloanchannelno -- 平台订单号
    ,daysovd -- 逾期天数
    ,interesttransferstatus -- 非应计状态 
    ,loanresponsetime -- 支付返回成功时间
    ,writeoffstatus -- 核销状态
    ,writeofftime -- 核销时间
    ,inputdate -- 登记日期
    ,updatedate -- 更新日期
    ,inputuserid -- 登记人
    ,inputorgid -- 登记机构
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,startterm -- 开始期序
    ,endterm -- 结束期序
    ,intrate -- 正常利率
    ,intrateunit -- 正常利率类型
    ,ovdrate -- 罚息利率
    ,ovdrateunit -- 罚息利率类型
    ,prepmtfeerate -- 提前还款手续费率
    ,remart -- 计量标记-资产三分类
    ,dailyint -- 当日计提利息
    ,dailypnltint -- 当日计提罚息
    ,vouchtype -- 担保方式
    ,bankcontriratio -- 银行出资比例
    ,repaynum -- 还款账户
    ,repaynumtype -- 还款账户类型
    ,paymentnum -- 入账账户
    ,paymentnumtype -- 入账账户类型
    ,operateuserid -- 经办人
    ,operateorgid -- 经办机构
    ,putoutorgid -- 账务机构
    ,manageorgid -- 管理机构
    ,productid -- 产品编号
    ,hxduebillno -- 核心借据号
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_timestamp -- ETL处理时间戳
)
select
    loanid as loanid -- 借据号
    ,putoutserialno as putoutserialno -- 出账流水号
    ,contractserialno as contractserialno -- 合同流水号
    ,customerid as customerid -- 客户号
    ,customername as customername -- 客户名称
    ,status as status -- 状态
    ,termmonth as termmonth -- 期限
    ,ratemodel as ratemodel -- 利率模式
    ,baseratetype as baseratetype -- 基准利率类型
    ,baserate as baserate -- 基准利率
    ,ratefloattype as ratefloattype -- 利率浮动方式
    ,executerate as executerate -- 执行利率
    ,overduerate as overduerate -- 逾期利率
    ,rateadjusttype as rateadjusttype -- 利率调整方式
    ,rateadjustfrequency as rateadjustfrequency -- 利率调整周期
    ,floatrange as floatrange -- 浮动幅度
    ,overdueratefloattype as overdueratefloattype -- 逾期利率浮动方式
    ,overdueratefloatvalue as overdueratefloatvalue -- 逾期利率浮动值
    ,classifyresult as classifyresult -- 贷款五级分类
    ,applydate as applydate -- 申请日期
    ,startdate as startdate -- 开始日期
    ,enddate as enddate -- 到期日期
    ,overduedate as overduedate -- 逾期日期
    ,cleardate as cleardate -- 结清日期
    ,encashamt as encashamt -- 借据金额
    ,currency as currency -- 币种
    ,repaymode as repaymode -- 还款方式
    ,repaycycle as repaycycle -- 还款周期
    ,totalterms as totalterms -- 总期数
    ,curterm as curterm -- 当前期数
    ,repayday as repayday -- 还款日
    ,graceday as graceday -- 宽限期
    ,loanstatus as loanstatus -- 贷款状态
    ,loanform as loanform -- 贷款形态
    ,printotal as printotal -- 应还本金
    ,prinrepay as prinrepay -- 已还本金
    ,prinbal as prinbal -- 正常本金余额
    ,ovdprinbal as ovdprinbal -- 逾期本金余额
    ,intplan as intplan -- 计划利息
    ,inttotal as inttotal -- 应还利息
    ,intrepay as intrepay -- 已还利息
    ,intdiscount as intdiscount -- 减免利息
    ,intbal as intbal -- 利息余额
    ,ovdintbal as ovdintbal -- 逾期利息余额
    ,pnltinttotal as pnltinttotal -- 应收罚息
    ,pnltintrepay as pnltintrepay -- 已还罚息
    ,pnltintdiscount as pnltintdiscount -- 减免罚息
    ,pnltintbal as pnltintbal -- 罚息余额
    ,prepmtfeerepay as prepmtfeerepay -- 已还提前还款手续费
    ,productno as productno -- 字节产品编号
    ,outloanchannelno as outloanchannelno -- 平台订单号
    ,daysovd as daysovd -- 逾期天数
    ,interesttransferstatus as interesttransferstatus -- 非应计状态 
    ,loanresponsetime as loanresponsetime -- 支付返回成功时间
    ,writeoffstatus as writeoffstatus -- 核销状态
    ,writeofftime as writeofftime -- 核销时间
    ,inputdate as inputdate -- 登记日期
    ,updatedate as updatedate -- 更新日期
    ,inputuserid as inputuserid -- 登记人
    ,inputorgid as inputorgid -- 登记机构
    ,updateuserid as updateuserid -- 更新人
    ,updateorgid as updateorgid -- 更新机构
    ,startterm as startterm -- 开始期序
    ,endterm as endterm -- 结束期序
    ,intrate as intrate -- 正常利率
    ,intrateunit as intrateunit -- 正常利率类型
    ,ovdrate as ovdrate -- 罚息利率
    ,ovdrateunit as ovdrateunit -- 罚息利率类型
    ,prepmtfeerate as prepmtfeerate -- 提前还款手续费率
    ,remart as remart -- 计量标记-资产三分类
    ,dailyint as dailyint -- 当日计提利息
    ,dailypnltint as dailypnltint -- 当日计提罚息
    ,vouchtype as vouchtype -- 担保方式
    ,bankcontriratio as bankcontriratio -- 银行出资比例
    ,repaynum as repaynum -- 还款账户
    ,repaynumtype as repaynumtype -- 还款账户类型
    ,paymentnum as paymentnum -- 入账账户
    ,paymentnumtype as paymentnumtype -- 入账账户类型
    ,operateuserid as operateuserid -- 经办人
    ,operateorgid as operateorgid -- 经办机构
    ,putoutorgid as putoutorgid -- 账务机构
    ,manageorgid as manageorgid -- 管理机构
    ,productid as productid -- 产品编号
    ,' ' as hxduebillno -- 核心借据号
    ,start_dt as start_dt -- 开始时间
    ,end_dt as end_dt -- 结束时间
    ,id_mark as id_mark -- 增删标志
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_zjbk_business_duebill_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

