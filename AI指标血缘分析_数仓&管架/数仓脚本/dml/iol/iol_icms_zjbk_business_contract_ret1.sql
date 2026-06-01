/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_zjbk_business_contract_ret1
CreateDate: 20250729
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
                       FROM icms_zjbk_business_contract_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('icms_zjbk_business_contract');

  if v_var <> 0 then
    execute immediate 'alter table icms_zjbk_business_contract drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table icms_zjbk_business_contract add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.icms_zjbk_business_contract (
	serialno -- 合同号
	,relativelhdserialno -- 关联联合贷申请号
	,relativezdserialno -- 关联助贷申请号
	,parentserialno -- 关联额度合同号
	,accountid -- 授信ID
	,approvestatus -- 审批状态
	,status -- 合同状态
	,customerid -- 客户号
	,customername -- 姓名
	,certtype -- 证件类型
	,certid -- 证件号码
	,phone -- 手机号
	,productid -- 产品编号
	,productmode -- 产品类别
	,businesssum -- 合同金额
	,balance -- 合同余额
	,intrate -- 利率
	,currency -- 币种
	,businessflag -- 业务类型
	,startdate -- 合同起始日
	,enddate -- 合同到期日
	,termmonth -- 期限
	,usage -- 用途
	,loanid -- 用信申请流水号
	,inputuserid -- 登记人
	,inputorgid -- 登记机构
	,inputdate -- 登记日期
	,updateuserid -- 更新人
	,updateorgid -- 更新机构
	,updatedate -- 更新日期
	,newcrdtestimatlmt -- 预估额度
	,closedate -- 字节账户关闭日期
	,closetype -- 字节关闭类型：1：账户注销 2：账户关闭
	,dailyrate -- 授信日利率
	,availablebalance -- 可用额度余额
	,companyindustry -- 所属行业
	,intraindustrytype -- 贷款投向
	,start_dt -- 开始时间
	,end_dt -- 结束时间
	,id_mark -- 增删标志
	,etl_timestamp -- ETL处理时间戳
)
select
	serialno as serialno -- 合同号
	,relativelhdserialno as relativelhdserialno -- 关联联合贷申请号
	,relativezdserialno as relativezdserialno -- 关联助贷申请号
	,parentserialno as parentserialno -- 关联额度合同号
	,accountid as accountid -- 授信ID
	,approvestatus as approvestatus -- 审批状态
	,status as status -- 合同状态
	,customerid as customerid -- 客户号
	,customername as customername -- 姓名
	,certtype as certtype -- 证件类型
	,certid as certid -- 证件号码
	,phone as phone -- 手机号
	,productid as productid -- 产品编号
	,productmode as productmode -- 产品类别
	,businesssum as businesssum -- 合同金额
	,balance as balance -- 合同余额
	,intrate as intrate -- 利率
	,currency as currency -- 币种
	,businessflag as businessflag -- 业务类型
	,startdate as startdate -- 合同起始日
	,enddate as enddate -- 合同到期日
	,termmonth as termmonth -- 期限
	,usage as usage -- 用途
	,loanid as loanid -- 用信申请流水号
	,inputuserid as inputuserid -- 登记人
	,inputorgid as inputorgid -- 登记机构
	,inputdate as inputdate -- 登记日期
	,updateuserid as updateuserid -- 更新人
	,updateorgid as updateorgid -- 更新机构
	,updatedate as updatedate -- 更新日期
	,newcrdtestimatlmt as newcrdtestimatlmt -- 预估额度
	,closedate as closedate -- 字节账户关闭日期
	,closetype as closetype -- 字节关闭类型：1：账户注销 2：账户关闭
	,dailyrate as dailyrate -- 授信日利率
	,availablebalance as availablebalance -- 可用额度余额
	,' ' as companyindustry -- 所属行业
	,' ' as intraindustrytype -- 贷款投向
	,start_dt as start_dt -- 开始时间
	,end_dt as end_dt -- 结束时间
	,id_mark as id_mark -- 增删标志
	,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_zjbk_business_contract_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

