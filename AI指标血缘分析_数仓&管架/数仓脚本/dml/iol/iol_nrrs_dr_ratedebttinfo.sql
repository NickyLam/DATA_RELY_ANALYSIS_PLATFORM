/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nrrs_dr_ratedebttinfo
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
drop table ${iol_schema}.nrrs_dr_ratedebttinfo_ex purge;
alter table ${iol_schema}.nrrs_dr_ratedebttinfo add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.nrrs_dr_ratedebttinfo;

-- 2.3 insert data to ex table
create table ${iol_schema}.nrrs_dr_ratedebttinfo_ex nologging
compress
as
select * from ${iol_schema}.nrrs_dr_ratedebttinfo where 0=1;

insert /*+ append */ into ${iol_schema}.nrrs_dr_ratedebttinfo_ex(
    lsh -- 债项计算流水号
    ,debtid -- 债项编号
    ,custid -- 债项客户号
    ,pdcustid -- pd对象编号
    ,usetype -- 使用方式
    ,ccf -- CCF值
    ,ccf1 -- 
    ,ccf2 -- 
    ,ccf1a -- CCF1a值
    ,ccf2a -- CCF2a值
    ,ccf3 -- CCF3值
    ,ur3 -- UR3值
    ,ead -- ead值
    ,isorflag -- 实有或有标识，字典70030：0-实有，1-或有
    ,loan_capitalbal -- 借据表内本金金额
    ,loan_interestbal -- 借据表内利息余额
    ,loan_tradebal -- 借据表内交易费用余额
    ,loan_advanceamt -- 借据累计垫款
    ,loan_interestif -- 借据表内欠息
    ,loan_interestof -- 借据表外欠息
    ,term -- 债项原始期限，以月为单位
    ,aviterm -- 债项剩余期限，以月为单位
    ,curr -- 币种,字典0302
    ,prorecrate -- 产品回收系数
    ,prorecrates -- 产品回收基准系数
    ,prorecratet -- 产品回收调整系数
    ,counterparty -- 交易对手实力:1-我行内部评级在AA（含）以上、2-我行内部评级在A（含）以上、3-我行内部评级在BBB（含）以上、4-我行内部评级在BBB（含）以下、5-交易对手在我行暂无评级
    ,counterpartyage -- 交易对手合作年限
    ,counterpartytime -- 与交易对手成功合作次数
    ,counterpartyrate -- 交易对手实力调整系数
    ,counterpartyagerate -- 交易对手合作年限调整系数
    ,counterpartytimerate -- 与交易对手成功合作次数调整系数
    ,tradetype -- 交易类型:1-回购类交易、2-其他资本市场交易、3-抵押贷款
    ,revalrate -- 在评估频率,以天为单位
    ,debtamount -- 债项金额
    ,protype -- 产品类型，产品类型存储在sys_busitype
    ,creditlimitno -- 额度编号
    ,spcreditlimitno -- 切分额度编号
    ,contractno -- 合同编号
    ,crlimitamount -- 额度金额
    ,spcrlimitamount -- 切分额度金额
    ,contractamount -- 合同金额
    ,sxcustid -- 授信人编号
    ,isbreak -- 是否违约：0-否，1-是
    ,beel -- 
    ,debttype -- 债项类型：0-额度合同、1-切分额度合同、2-合同、3-借据
    ,lgd -- 
    ,rwa -- 
    ,lgdlevel -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    lsh -- 债项计算流水号
    ,debtid -- 债项编号
    ,custid -- 债项客户号
    ,pdcustid -- pd对象编号
    ,usetype -- 使用方式
    ,ccf -- CCF值
    ,ccf1 -- 
    ,ccf2 -- 
    ,ccf1a -- CCF1a值
    ,ccf2a -- CCF2a值
    ,ccf3 -- CCF3值
    ,ur3 -- UR3值
    ,ead -- ead值
    ,isorflag -- 实有或有标识，字典70030：0-实有，1-或有
    ,loan_capitalbal -- 借据表内本金金额
    ,loan_interestbal -- 借据表内利息余额
    ,loan_tradebal -- 借据表内交易费用余额
    ,loan_advanceamt -- 借据累计垫款
    ,loan_interestif -- 借据表内欠息
    ,loan_interestof -- 借据表外欠息
    ,term -- 债项原始期限，以月为单位
    ,aviterm -- 债项剩余期限，以月为单位
    ,curr -- 币种,字典0302
    ,prorecrate -- 产品回收系数
    ,prorecrates -- 产品回收基准系数
    ,prorecratet -- 产品回收调整系数
    ,counterparty -- 交易对手实力:1-我行内部评级在AA（含）以上、2-我行内部评级在A（含）以上、3-我行内部评级在BBB（含）以上、4-我行内部评级在BBB（含）以下、5-交易对手在我行暂无评级
    ,counterpartyage -- 交易对手合作年限
    ,counterpartytime -- 与交易对手成功合作次数
    ,counterpartyrate -- 交易对手实力调整系数
    ,counterpartyagerate -- 交易对手合作年限调整系数
    ,counterpartytimerate -- 与交易对手成功合作次数调整系数
    ,tradetype -- 交易类型:1-回购类交易、2-其他资本市场交易、3-抵押贷款
    ,revalrate -- 在评估频率,以天为单位
    ,debtamount -- 债项金额
    ,protype -- 产品类型，产品类型存储在sys_busitype
    ,creditlimitno -- 额度编号
    ,spcreditlimitno -- 切分额度编号
    ,contractno -- 合同编号
    ,crlimitamount -- 额度金额
    ,spcrlimitamount -- 切分额度金额
    ,contractamount -- 合同金额
    ,sxcustid -- 授信人编号
    ,isbreak -- 是否违约：0-否，1-是
    ,beel -- 
    ,debttype -- 债项类型：0-额度合同、1-切分额度合同、2-合同、3-借据
    ,lgd -- 
    ,rwa -- 
    ,lgdlevel -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nrrs_dr_ratedebttinfo
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nrrs_dr_ratedebttinfo exchange partition p_${batch_date} with table ${iol_schema}.nrrs_dr_ratedebttinfo_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nrrs_dr_ratedebttinfo to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nrrs_dr_ratedebttinfo_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nrrs_dr_ratedebttinfo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);