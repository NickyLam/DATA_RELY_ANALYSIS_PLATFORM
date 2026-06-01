/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_BUSINESS_FATOU_PUTOUT_ret1
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
                       FROM ICMS_BUSINESS_FATOU_PUTOUT_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_BUSINESS_FATOU_PUTOUT');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_BUSINESS_FATOU_PUTOUT drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_BUSINESS_FATOU_PUTOUT add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_BUSINESS_FATOU_PUTOUT(
            serialno -- 流水号
            ,businessrate -- 正常贷款执行利率
            ,lontyp -- 透支还款方式
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,odrputoutdate -- 法透额度起始日
            ,loanam -- 透支额度
            ,odrmaturity -- 法透额度到期日
            ,contractsum -- 合同金额
            ,operateuserid -- 经办人
            ,overduefloat -- 逾期贷款利率浮动
            ,lncmam -- 透支承诺费
            ,odrnextmonth -- 法透不跨月
            ,inputorgid -- 登记机构
            ,lendingorgid -- 贷款机构
            ,rategenre -- 新重定价方式
            ,businesstype -- 业务品种
            ,farmingloanuse -- 涉农贷款投向
            ,migtflag -- 
            ,careerguaranteeloantype -- 创业担保贷款类型
            ,ratefloat -- 正常贷款利率浮动
            ,oblopt -- 使用余额选择
            ,isputout -- 是否出账通过
            ,businesscurrency -- 币种
            ,iscareerguaranteeloan -- 是否创业担保贷款(1是0否)
            ,directionnew -- 行业投向17年版（最新）
            ,farmingloantype -- 涉农贷款主体类型
            ,tempsaveflag -- 暂存标志
            ,accountno1 -- 透支户账号
            ,baserate -- 基准利率
            ,operatedate -- 经办日期
            ,lprtype -- 基准利率选择LPR的取值方式（1最新LPR2首笔LPR）
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,customername -- 透支客户名称
            ,directionrs -- 行业投向（征信）
            ,isfarming -- 是否涉农(1是0否)
            ,contractserialno -- 合同流水号
            ,customerid -- 透支客户号
            ,baseratetype -- 基准利率类型
            ,bengdt -- 业务提醒短信发送时机
            ,daynum -- 单笔透支有效天数
            ,overduerate -- 逾期贷款执行利率
            ,ovdrmi -- 起透金额
            ,odrfreeinterest -- 法透不跨月免息天数
            ,platformpaycashsource -- 地方融资平台偿债资金来源分类
            ,loanhandlechannel -- 贷款办理渠道
            ,inputdate -- 输入日期
            ,acceptinttype -- 结息方式
            ,whitelist -- 白名单
            ,sectionalinterest -- 是否靠档计息
            ,frecharger -- 收费频率（按月、按日）码值：refreq
            ,binllingday -- 收费日
            ,artificialno -- 文本合同号
            ,subsac -- 透支账户子户号
            ,maintp -- 维护类型
            ,agrbdt -- 协议法透额度有效期起始日
            ,agredt -- 协议法透额度有效期结束日
            ,purpose -- 资金用途
            ,ovtype -- 日间隔夜透支类型
            ,flrttp -- 利率浮动类型
            ,feeivl -- 手续费费率
            ,tyflag -- 对公同业法透类型
            ,tzrate -- 透支利率
            ,agreementid -- 协议编号
            ,status -- 任务状态
            ,feedate -- 手续费收费日
            ,overduefloatcycle -- 利率浮动周期
            ,overduefloatmodel -- 利率浮动方式
            ,feefrequency -- 手续费收费频率
            ,feemodel -- 手续费收取方式
            ,feerate -- 手续费收费比率
            ,issupplychainfinance -- 是否为供应链金融业务
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,inputtime -- 
            ,ecodepartmentcode -- 
            ,entscale -- 
            ,classifyresulteleven -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 流水号
            ,businessrate -- 正常贷款执行利率
            ,lontyp -- 透支还款方式
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,odrputoutdate -- 法透额度起始日
            ,loanam -- 透支额度
            ,odrmaturity -- 法透额度到期日
            ,contractsum -- 合同金额
            ,operateuserid -- 经办人
            ,overduefloat -- 逾期贷款利率浮动
            ,lncmam -- 透支承诺费
            ,odrnextmonth -- 法透不跨月
            ,inputorgid -- 登记机构
            ,lendingorgid -- 贷款机构
            ,rategenre -- 新重定价方式
            ,businesstype -- 业务品种
            ,farmingloanuse -- 涉农贷款投向
            ,migtflag -- 
            ,careerguaranteeloantype -- 创业担保贷款类型
            ,ratefloat -- 正常贷款利率浮动
            ,oblopt -- 使用余额选择
            ,isputout -- 是否出账通过
            ,businesscurrency -- 币种
            ,iscareerguaranteeloan -- 是否创业担保贷款(1是0否)
            ,directionnew -- 行业投向17年版（最新）
            ,farmingloantype -- 涉农贷款主体类型
            ,tempsaveflag -- 暂存标志
            ,accountno1 -- 透支户账号
            ,baserate -- 基准利率
            ,operatedate -- 经办日期
            ,lprtype -- 基准利率选择LPR的取值方式（1最新LPR2首笔LPR）
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,customername -- 透支客户名称
            ,directionrs -- 行业投向（征信）
            ,isfarming -- 是否涉农(1是0否)
            ,contractserialno -- 合同流水号
            ,customerid -- 透支客户号
            ,baseratetype -- 基准利率类型
            ,bengdt -- 业务提醒短信发送时机
            ,daynum -- 单笔透支有效天数
            ,overduerate -- 逾期贷款执行利率
            ,ovdrmi -- 起透金额
            ,odrfreeinterest -- 法透不跨月免息天数
            ,platformpaycashsource -- 地方融资平台偿债资金来源分类
            ,loanhandlechannel -- 贷款办理渠道
            ,inputdate -- 输入日期
            ,acceptinttype -- 结息方式
            ,whitelist -- 白名单
            ,sectionalinterest -- 是否靠档计息
            ,frecharger -- 收费频率（按月、按日）码值：refreq
            ,binllingday -- 收费日
            ,artificialno -- 文本合同号
            ,subsac -- 透支账户子户号
            ,maintp -- 维护类型
            ,agrbdt -- 协议法透额度有效期起始日
            ,agredt -- 协议法透额度有效期结束日
            ,purpose -- 资金用途
            ,ovtype -- 日间隔夜透支类型
            ,flrttp -- 利率浮动类型
            ,feeivl -- 手续费费率
            ,tyflag -- 对公同业法透类型
            ,tzrate -- 透支利率
            ,agreementid -- 协议编号
            ,status -- 任务状态
            ,feedate -- 手续费收费日
            ,overduefloatcycle -- 利率浮动周期
            ,overduefloatmodel -- 利率浮动方式
            ,feefrequency -- 手续费收费频率
            ,feemodel -- 手续费收取方式
            ,feerate -- 手续费收费比率
            ,issupplychainfinance -- 是否为供应链金融业务
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,to_date('00010101','yyyymmdd')  AS inputtime -- 
            ,' ' AS ecodepartmentcode -- 
            ,' ' AS entscale -- 
            ,' ' AS classifyresulteleven -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_BUSINESS_FATOU_PUTOUT_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
