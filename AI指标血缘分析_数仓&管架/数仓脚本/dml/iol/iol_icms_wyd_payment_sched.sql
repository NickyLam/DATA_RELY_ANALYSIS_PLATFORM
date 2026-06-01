/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wyd_payment_sched
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wyd_payment_sched_ex purge;
alter table ${iol_schema}.icms_wyd_payment_sched add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_wyd_payment_sched truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_wyd_payment_sched_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wyd_payment_sched where 0=1;

insert /*+ append */ into ${iol_schema}.icms_wyd_payment_sched_ex(
    datadt -- 数据日期
    ,lendingref -- 借据号
    ,orgid -- 机构号
    ,term -- 当前期数
    ,pmaturitydate -- 当期本金到期日期
    ,prepay -- 当期应还本金
    ,prepayact -- 当期实还本金
    ,imaturitydate -- 当期利息到期日期
    ,irepay -- 当期应还总利息
    ,irepayact -- 当期实还利息
    ,poverdueamt -- 逾期金额
    ,remainingmaturitym -- 剩余期限-月
    ,remainingmaturityd -- 剩余期限_日
    ,remainingmaturitymi -- 下一利息收付剩余期限_月
    ,remainingmaturitydi -- 下一利息收付剩余期限_日
    ,scheduleaction -- 还款计划操作动作
    ,insurancepaymentflag -- 保险代偿标志
    ,insurancepaymentdate -- 保险代偿日期
    ,intedate -- 顺延日期
    ,prepayadv -- 本金提前还款金额
    ,delayinterest -- 递延利息
    ,payinterestamt -- 应还利息
    ,payprincipalpenaltyamt -- 应还本金罚息
    ,payinterestpenaltyamt -- 应还利息罚息
    ,actualpayinterestamt -- 实还利息
    ,actualpayprincipalpenaltyamt -- 实还本金罚息
    ,actualpayinterestpenaltyamt -- 实还利息罚息
    ,pstatus -- 本金状态
    ,dstatus -- 本期状态
    ,finishdate -- 当期结清日期
    ,waiveprincipalamt -- 减免本金
    ,waiveinterestamt -- 减免利息
    ,waivepenaltyamt -- 减免罚息
    ,inputuserid -- 登记人
    ,inputorgid -- 登记人所属机构
    ,inputdate -- 登记时间
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,customerid -- 我行客户号
    ,productid -- 产品编号
    ,classifyresult -- 废除五级分类
    ,prinovddate -- 本金转逾期日期
    ,intovddate -- 利息转逾期日期
    ,capitaloverdays -- 本金逾期天数
    ,intovddays -- 利息逾期天数
    ,dateofvalue -- 起息日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    datadt -- 数据日期
    ,lendingref -- 借据号
    ,orgid -- 机构号
    ,term -- 当前期数
    ,pmaturitydate -- 当期本金到期日期
    ,prepay -- 当期应还本金
    ,prepayact -- 当期实还本金
    ,imaturitydate -- 当期利息到期日期
    ,irepay -- 当期应还总利息
    ,irepayact -- 当期实还利息
    ,poverdueamt -- 逾期金额
    ,remainingmaturitym -- 剩余期限-月
    ,remainingmaturityd -- 剩余期限_日
    ,remainingmaturitymi -- 下一利息收付剩余期限_月
    ,remainingmaturitydi -- 下一利息收付剩余期限_日
    ,scheduleaction -- 还款计划操作动作
    ,insurancepaymentflag -- 保险代偿标志
    ,insurancepaymentdate -- 保险代偿日期
    ,intedate -- 顺延日期
    ,prepayadv -- 本金提前还款金额
    ,delayinterest -- 递延利息
    ,payinterestamt -- 应还利息
    ,payprincipalpenaltyamt -- 应还本金罚息
    ,payinterestpenaltyamt -- 应还利息罚息
    ,actualpayinterestamt -- 实还利息
    ,actualpayprincipalpenaltyamt -- 实还本金罚息
    ,actualpayinterestpenaltyamt -- 实还利息罚息
    ,pstatus -- 本金状态
    ,dstatus -- 本期状态
    ,finishdate -- 当期结清日期
    ,waiveprincipalamt -- 减免本金
    ,waiveinterestamt -- 减免利息
    ,waivepenaltyamt -- 减免罚息
    ,inputuserid -- 登记人
    ,inputorgid -- 登记人所属机构
    ,inputdate -- 登记时间
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,customerid -- 我行客户号
    ,productid -- 产品编号
    ,classifyresult -- 废除五级分类
    ,prinovddate -- 本金转逾期日期
    ,intovddate -- 利息转逾期日期
    ,capitaloverdays -- 本金逾期天数
    ,intovddays -- 利息逾期天数
    ,dateofvalue -- 起息日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_wyd_payment_sched
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_wyd_payment_sched exchange partition p_${batch_date} with table ${iol_schema}.icms_wyd_payment_sched_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wyd_payment_sched to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_wyd_payment_sched_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wyd_payment_sched',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);