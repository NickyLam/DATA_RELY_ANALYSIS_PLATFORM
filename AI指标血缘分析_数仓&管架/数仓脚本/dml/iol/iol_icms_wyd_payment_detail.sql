/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wyd_payment_detail
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
drop table ${iol_schema}.icms_wyd_payment_detail_ex purge;
alter table ${iol_schema}.icms_wyd_payment_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_wyd_payment_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_wyd_payment_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wyd_payment_detail where 0=1;

insert /*+ append */ into ${iol_schema}.icms_wyd_payment_detail_ex(
    datadt -- 数据日期
    ,operorg -- 合作机构号
    ,contractno -- 借款合同号
    ,lendingref -- 借据号
    ,refno -- 交易流水号
    ,ppay -- 还本金额
    ,ipay -- 还利息金额
    ,pppay -- 还罚息
    ,feerepay -- 还费用
    ,type -- 还款类型
    ,insurancepaymentflag -- 保险代偿标志
    ,insurancepaymentdate -- 保险代偿日期
    ,transdate -- 交易日期
    ,fundprincipal -- 归属于资金端还本金额
    ,fundinterest -- 归属于资金端还利息金额
    ,fundpenalty -- 归属于资金端还罚息
    ,fundfee -- 归属于资金端还费用
    ,billprincipal -- 归属于票据还本金额
    ,billinterest -- 归属于票据还利息金额
    ,billpenalty -- 归属于票据还罚息
    ,billfee -- 归属于票据还费用
    ,ipaybn -- 还表内利息
    ,fpaybn -- 还表内罚息
    ,inputuserid -- 登记人
    ,inputorgid -- 登记人所属机构
    ,inputdate -- 登记时间
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,customerid -- 我行客户号
    ,productid -- 产品编号
    ,classifyresult -- 废除五级分类
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    datadt -- 数据日期
    ,operorg -- 合作机构号
    ,contractno -- 借款合同号
    ,lendingref -- 借据号
    ,refno -- 交易流水号
    ,ppay -- 还本金额
    ,ipay -- 还利息金额
    ,pppay -- 还罚息
    ,feerepay -- 还费用
    ,type -- 还款类型
    ,insurancepaymentflag -- 保险代偿标志
    ,insurancepaymentdate -- 保险代偿日期
    ,transdate -- 交易日期
    ,fundprincipal -- 归属于资金端还本金额
    ,fundinterest -- 归属于资金端还利息金额
    ,fundpenalty -- 归属于资金端还罚息
    ,fundfee -- 归属于资金端还费用
    ,billprincipal -- 归属于票据还本金额
    ,billinterest -- 归属于票据还利息金额
    ,billpenalty -- 归属于票据还罚息
    ,billfee -- 归属于票据还费用
    ,ipaybn -- 还表内利息
    ,fpaybn -- 还表内罚息
    ,inputuserid -- 登记人
    ,inputorgid -- 登记人所属机构
    ,inputdate -- 登记时间
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,customerid -- 我行客户号
    ,productid -- 产品编号
    ,classifyresult -- 废除五级分类
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_wyd_payment_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_wyd_payment_detail exchange partition p_${batch_date} with table ${iol_schema}.icms_wyd_payment_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wyd_payment_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_wyd_payment_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wyd_payment_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);