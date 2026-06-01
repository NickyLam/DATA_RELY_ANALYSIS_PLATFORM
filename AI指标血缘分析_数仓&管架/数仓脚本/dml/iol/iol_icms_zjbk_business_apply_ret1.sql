/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_zjbk_business_apply_ret1
CreateDate: 20250708
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
                       FROM icms_zjbk_business_apply_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('icms_zjbk_business_apply');

  if v_var <> 0 then
    execute immediate 'alter table icms_zjbk_business_apply drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table icms_zjbk_business_apply add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.icms_zjbk_business_apply (
  serialno -- 流水号
  ,lhdreqid -- 联合贷请求ID
  ,zdreqid -- 助贷请求ID
  ,accountid -- 授信ID
  ,credittag -- 授信请求类型
  ,approvestatus -- 授信状态
  ,status -- 授信状态
  ,customerid -- 客户号
  ,name -- 姓名
  ,idnumber -- 身份证
  ,phone -- 手机号
  ,gender -- 性别
  ,nation -- 国籍
  ,productmode -- 产品类别
  ,homephone -- 家庭电话
  ,address -- 居住地址
  ,birthday -- 生日
  ,creditamount -- 授信额度
  ,dailyrate -- 授信日利率
  ,annualrate -- 授信年利率
  ,idcardaddress -- 身份证上的地址信息
  ,idcardstartdate -- 身份证有效期开始时间
  ,idcardenddate -- 身份证有效期结束时间
  ,idcardethnicity -- 民族
  ,idcardauthority -- 签发机关
  ,careerindustry -- 现单位/经营主体所属行业
  ,cardid -- 银行卡号
  ,bankname -- 银行名称
  ,bankphone -- 银行预留手机号
  ,enterprisename -- 企业名称或者法人名称
  ,uniformsocialcreditcode -- 社会信用代码
  ,businesslicense -- 营业执照号
  ,customertype -- 客户属性
  ,companyindustry -- 所属行业类型
  ,ifexeshare -- 是否董监高
  ,xwlabel -- 小微标签
  ,riskstatus -- 风控结果
  ,failreason -- 风控拒绝原因
  ,inputuserid -- 登记人
  ,inputorgid -- 登记机构
  ,inputdate -- 登记日期
  ,updateuserid -- 更新人
  ,updateorgid -- 更新机构
  ,updatedate -- 更新日期
  ,businessflag -- 业务类型
  ,loanid -- 借款流水号
  ,appliedamount -- 实际额度
  ,availableamount -- 可用额度
  ,loanamount -- 借款总金额
  ,bankamount -- 联合行金额
  ,period -- 分期数
  ,repaytype -- 计息方式
  ,usage -- 借款用途
  ,currency -- 币种
  ,orderdailyrate -- 日利率
  ,orderannualrate -- 年利率
  ,capitalsetno -- 资金码
  ,riskcreditamount -- 风控授信额度
  ,riskintrate -- 风控利息年利率
  ,certtype -- 证件类型
  ,productid -- 产品编号
  ,riskreqtime -- 风控回调时间
  ,creditchannel -- 授信渠道
  ,contractno -- 额度合同号
  ,failcode -- 风控拒绝码
  ,effectdate -- 有效到期日
  ,intraindustrytype -- 投向行业
  ,industrysource -- 所属行业数据来源
  ,totalassets -- 资产总额
  ,operatingrevenue -- 营业收入
  ,colleguesnum -- 从业人数
  ,enterprisescale -- 企业规模
  ,locationinfo -- 客户位置信息
  ,repayday -- 每月还款日
  ,reserveinfo -- 征信预留字段
  ,rdriskstatus -- 融担风控结果
  ,rdfailcode -- 融担风控拒绝码
  ,rdfailreason -- 融担风控拒绝原因
  ,rdriskreqtime -- 融担回调时间
  ,start_dt -- 开始时间
  ,end_dt -- 结束时间
  ,id_mark -- 增删标志
  ,etl_timestamp -- ETL处理时间戳
)
select
  serialno as serialno -- 流水号
  ,lhdreqid as lhdreqid -- 联合贷请求ID
  ,zdreqid as zdreqid -- 助贷请求ID
  ,accountid as accountid -- 授信ID
  ,credittag as credittag -- 授信请求类型
  ,approvestatus as approvestatus -- 授信状态
  ,status as status -- 授信状态
  ,customerid as customerid -- 客户号
  ,name as name -- 姓名
  ,idnumber as idnumber -- 身份证
  ,phone as phone -- 手机号
  ,gender as gender -- 性别
  ,nation as nation -- 国籍
  ,productmode as productmode -- 产品类别
  ,homephone as homephone -- 家庭电话
  ,address as address -- 居住地址
  ,birthday as birthday -- 生日
  ,creditamount as creditamount -- 授信额度
  ,dailyrate as dailyrate -- 授信日利率
  ,annualrate as annualrate -- 授信年利率
  ,idcardaddress as idcardaddress -- 身份证上的地址信息
  ,idcardstartdate as idcardstartdate -- 身份证有效期开始时间
  ,idcardenddate as idcardenddate -- 身份证有效期结束时间
  ,idcardethnicity as idcardethnicity -- 民族
  ,idcardauthority as idcardauthority -- 签发机关
  ,careerindustry as careerindustry -- 现单位/经营主体所属行业
  ,cardid as cardid -- 银行卡号
  ,bankname as bankname -- 银行名称
  ,bankphone as bankphone -- 银行预留手机号
  ,enterprisename as enterprisename -- 企业名称或者法人名称
  ,uniformsocialcreditcode as uniformsocialcreditcode -- 社会信用代码
  ,businesslicense as businesslicense -- 营业执照号
  ,customertype as customertype -- 客户属性
  ,companyindustry as companyindustry -- 所属行业类型
  ,ifexeshare as ifexeshare -- 是否董监高
  ,xwlabel as xwlabel -- 小微标签
  ,riskstatus as riskstatus -- 风控结果
  ,failreason as failreason -- 风控拒绝原因
  ,inputuserid as inputuserid -- 登记人
  ,inputorgid as inputorgid -- 登记机构
  ,inputdate as inputdate -- 登记日期
  ,updateuserid as updateuserid -- 更新人
  ,updateorgid as updateorgid -- 更新机构
  ,updatedate as updatedate -- 更新日期
  ,businessflag as businessflag -- 业务类型
  ,loanid as loanid -- 借款流水号
  ,appliedamount as appliedamount -- 实际额度
  ,availableamount as availableamount -- 可用额度
  ,loanamount as loanamount -- 借款总金额
  ,bankamount as bankamount -- 联合行金额
  ,period as period -- 分期数
  ,repaytype as repaytype -- 计息方式
  ,usage as usage -- 借款用途
  ,currency as currency -- 币种
  ,orderdailyrate as orderdailyrate -- 日利率
  ,orderannualrate as orderannualrate -- 年利率
  ,capitalsetno as capitalsetno -- 资金码
  ,riskcreditamount as riskcreditamount -- 风控授信额度
  ,riskintrate as riskintrate -- 风控利息年利率
  ,certtype as certtype -- 证件类型
  ,productid as productid -- 产品编号
  ,riskreqtime as riskreqtime -- 风控回调时间
  ,creditchannel as creditchannel -- 授信渠道
  ,contractno as contractno -- 额度合同号
  ,failcode as failcode -- 风控拒绝码
  ,effectdate as effectdate -- 有效到期日
  ,' ' as intraindustrytype -- 投向行业
  ,' ' as industrysource -- 所属行业数据来源
  ,' ' as totalassets -- 资产总额
  ,' ' as operatingrevenue -- 营业收入
  ,' ' as colleguesnum -- 从业人数
  ,' ' as enterprisescale -- 企业规模
  ,' ' as locationinfo -- 客户位置信息
  ,' ' as repayday -- 每月还款日
  ,' ' as reserveinfo -- 征信预留字段
  ,' ' as rdriskstatus -- 融担风控结果
  ,' ' as rdfailcode -- 融担风控拒绝码
  ,' ' as rdfailreason -- 融担风控拒绝原因
  ,to_date('00010101','yyyymmdd') as rdriskreqtime -- 融担回调时间
  ,start_dt as start_dt -- 开始时间
  ,end_dt as end_dt -- 结束时间
  ,id_mark as id_mark -- 增删标志
  ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_zjbk_business_apply_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

