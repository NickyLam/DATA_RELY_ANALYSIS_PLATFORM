/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icms_repayment_plan_info
CreateDate: 20250509
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.icms_repayment_plan_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_repayment_plan_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_repayment_plan_info (
etl_dt  --数据日期
,duebillserialno  --借据流水号
,dateno  --期号
,penaltyinterest  --实还罚息
,paymenttype  --还款方式
,unpaidsum  --本期剩余本金
,businessrate  --执行利率
,businesscurrency  --币种
,enddate  --终止日期
,flag  --处理标志（0-已执行1-未执行）
,actualsum  --实还本金
,actualinterest  --实还利息
,compoundinterest  --实还复息
,normalsum  --正常本金
,periodinterestsum  --本期应收利息
,executiondate  --结清日期
,periodsum  --本期应收本金
,discountsum  --其中贴息金额
,startdate  --起始日期
,putoutunpaidsum  --借据剩余贷款本金
,migtflag  --迁移标志：crs rcr ilc upl
,schedamt  --每期还款总额
,intaccrued  --应计利息
,odpaccrued  --应计罚息
,odiaccrued  --应计复利
,odpoutstanding  --应收罚息
,odioutstanding  --应收复利
,ysintamt  --应收欠息
,remark  --备注
,gracedate  --宽限日期
,respaidintamt  --剩余应还利息

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.duebillserialno,chr(13),''),chr(10),'') as duebillserialno --借据流水号
,t1.dateno as dateno --期号
,t1.penaltyinterest as penaltyinterest --实还罚息
,replace(replace(t1.paymenttype,chr(13),''),chr(10),'') as paymenttype --还款方式
,t1.unpaidsum as unpaidsum --本期剩余本金
,t1.businessrate as businessrate --执行利率
,replace(replace(t1.businesscurrency,chr(13),''),chr(10),'') as businesscurrency --币种
,t1.enddate as enddate --终止日期
,replace(replace(t1.flag,chr(13),''),chr(10),'') as flag --处理标志（0-已执行1-未执行）
,t1.actualsum as actualsum --实还本金
,t1.actualinterest as actualinterest --实还利息
,t1.compoundinterest as compoundinterest --实还复息
,t1.normalsum as normalsum --正常本金
,t1.periodinterestsum as periodinterestsum --本期应收利息
,t1.executiondate as executiondate --结清日期
,t1.periodsum as periodsum --本期应收本金
,t1.discountsum as discountsum --其中贴息金额
,t1.startdate as startdate --起始日期
,t1.putoutunpaidsum as putoutunpaidsum --借据剩余贷款本金
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag --迁移标志：crs rcr ilc upl
,t1.schedamt as schedamt --每期还款总额
,t1.intaccrued as intaccrued --应计利息
,t1.odpaccrued as odpaccrued --应计罚息
,t1.odiaccrued as odiaccrued --应计复利
,t1.odpoutstanding as odpoutstanding --应收罚息
,t1.odioutstanding as odioutstanding --应收复利
,t1.ysintamt as ysintamt --应收欠息
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --备注
,t1.gracedate as gracedate --宽限日期
,t1.respaidintamt as respaidintamt --剩余应还利息
from ${iol_schema}.icms_repayment_plan_info t1    --借据还款计划信息
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_repayment_plan_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
