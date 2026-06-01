/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_jdjr_repay_detail
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
drop table ${iol_schema}.icms_jdjr_repay_detail_ex purge;
alter table ${iol_schema}.icms_jdjr_repay_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_jdjr_repay_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_jdjr_repay_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_jdjr_repay_detail where 0=1;

insert /*+ append */ into ${iol_schema}.icms_jdjr_repay_detail_ex(
    repayserno -- 贷款进行交易的流水号(可能存在一天还款多笔)
    ,busmodel -- 业务模式
    ,prdno -- 产品编号
    ,currtermpnlt -- 累计应还罚息
    ,migtflag -- 
    ,termno -- 分期单号
    ,repaydt -- 还款日期
    ,repaytype -- 还款方式
    ,unpayterms -- 剩余还款期数
    ,realreapyvolfee -- 实还违约金金额
    ,contno -- 合同号
    ,realrepaypnlt -- 实还罚息金额
    ,limitno -- 额度编号
    ,realrepayamt -- 实还本金金额
    ,accrepayenchashfee -- 累计应还取现手续费
    ,loanno -- 贷款编号
    ,currtermamt -- 累计应还本金
    ,realrepayenchashfee -- 实还取现手续费金额
    ,servicefee -- 服务费
    ,mangovdincome -- 资方应收分润逾期收益
    ,prdcode -- 产品编号（行内）
    ,mangrecfixed -- 资方应收固收
    ,collectfee -- 催收费
    ,ovddays -- 逾期天数本次还款分期单的逾期天数，无逾期时，值为0
    ,realrepayint -- 实还利息金额
    ,repayterms -- 还款期数
    ,repaymodel -- 还款类型
    ,mangnorincome -- 资方应收分润正常收益
    ,bussdate -- 业务日期
    ,accrepayvolfee -- 累计应还违约金
    ,currtermint -- 累计应还利息
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    repayserno -- 贷款进行交易的流水号(可能存在一天还款多笔)
    ,busmodel -- 业务模式
    ,prdno -- 产品编号
    ,currtermpnlt -- 累计应还罚息
    ,migtflag -- 
    ,termno -- 分期单号
    ,repaydt -- 还款日期
    ,repaytype -- 还款方式
    ,unpayterms -- 剩余还款期数
    ,realreapyvolfee -- 实还违约金金额
    ,contno -- 合同号
    ,realrepaypnlt -- 实还罚息金额
    ,limitno -- 额度编号
    ,realrepayamt -- 实还本金金额
    ,accrepayenchashfee -- 累计应还取现手续费
    ,loanno -- 贷款编号
    ,currtermamt -- 累计应还本金
    ,realrepayenchashfee -- 实还取现手续费金额
    ,servicefee -- 服务费
    ,mangovdincome -- 资方应收分润逾期收益
    ,prdcode -- 产品编号（行内）
    ,mangrecfixed -- 资方应收固收
    ,collectfee -- 催收费
    ,ovddays -- 逾期天数本次还款分期单的逾期天数，无逾期时，值为0
    ,realrepayint -- 实还利息金额
    ,repayterms -- 还款期数
    ,repaymodel -- 还款类型
    ,mangnorincome -- 资方应收分润正常收益
    ,bussdate -- 业务日期
    ,accrepayvolfee -- 累计应还违约金
    ,currtermint -- 累计应还利息
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_jdjr_repay_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_jdjr_repay_detail exchange partition p_${batch_date} with table ${iol_schema}.icms_jdjr_repay_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_jdjr_repay_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_jdjr_repay_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_jdjr_repay_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);