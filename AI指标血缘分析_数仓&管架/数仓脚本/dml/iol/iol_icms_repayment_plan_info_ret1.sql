/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_repayment_plan_info_ret1
CreateDate: 20250107
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
                       FROM icms_repayment_plan_info_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('icms_repayment_plan_info');

  if v_var <> 0 then
    execute immediate 'alter table icms_repayment_plan_info drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table icms_repayment_plan_info add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.icms_repayment_plan_info (
	duebillserialno -- 借据流水号
	,dateno -- 期号
	,penaltyinterest -- 实还罚息
	,paymenttype -- 还款方式
	,unpaidsum -- 本期剩余本金
	,businessrate -- 执行利率
	,businesscurrency -- 币种
	,enddate -- 终止日期
	,flag -- 处理标志（0-已执行1-未执行）
	,actualsum -- 实还本金
	,actualinterest -- 实还利息
	,compoundinterest -- 实还复息
	,normalsum -- 正常本金
	,periodinterestsum -- 本期应收利息
	,executiondate -- 结清日期
	,periodsum -- 本期应收本金
	,discountsum -- 其中贴息金额
	,startdate -- 起始日期
	,putoutunpaidsum -- 借据剩余贷款本金
	,migtflag -- 迁移标志：crs rcr ilc upl
	,schedamt -- 每期还款总额
	,intaccrued -- 应计利息
	,odpaccrued -- 应计罚息
	,odiaccrued -- 应计复利
	,odpoutstanding -- 应收罚息
	,odioutstanding -- 应收复利
	,ysintamt -- 应收欠息
	,remark -- 备注
	,gracedate -- 宽限日期
	,respaidintamt -- 剩余应还利息
	,start_dt -- 开始时间
	,end_dt -- 结束时间
	,id_mark -- 增删标志
	,etl_timestamp -- ETL处理时间戳
)
select
	duebillserialno as duebillserialno -- 借据流水号
	,dateno as dateno -- 期号
	,penaltyinterest as penaltyinterest -- 实还罚息
	,paymenttype as paymenttype -- 还款方式
	,unpaidsum as unpaidsum -- 本期剩余本金
	,businessrate as businessrate -- 执行利率
	,businesscurrency as businesscurrency -- 币种
	,enddate as enddate -- 终止日期
	,flag as flag -- 处理标志（0-已执行1-未执行）
	,actualsum as actualsum -- 实还本金
	,actualinterest as actualinterest -- 实还利息
	,compoundinterest as compoundinterest -- 实还复息
	,normalsum as normalsum -- 正常本金
	,periodinterestsum as periodinterestsum -- 本期应收利息
	,executiondate as executiondate -- 结清日期
	,periodsum as periodsum -- 本期应收本金
	,discountsum as discountsum -- 其中贴息金额
	,startdate as startdate -- 起始日期
	,putoutunpaidsum as putoutunpaidsum -- 借据剩余贷款本金
	,migtflag as migtflag -- 迁移标志：crs rcr ilc upl
	,schedamt as schedamt -- 每期还款总额
	,0 as intaccrued -- 应计利息
	,0 as odpaccrued -- 应计罚息
	,0 as odiaccrued -- 应计复利
	,0 as odpoutstanding -- 应收罚息
	,0 as odioutstanding -- 应收复利
	,0 as ysintamt -- 应收欠息
	,' ' as remark -- 备注
	,to_date('00010101', 'yyyymmdd') as gracedate -- 宽限日期
	,0 as respaidintamt -- 剩余应还利息
	,start_dt as start_dt -- 开始时间
	,end_dt as end_dt -- 结束时间
	,id_mark as id_mark -- 增删标志
	,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_repayment_plan_info_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

