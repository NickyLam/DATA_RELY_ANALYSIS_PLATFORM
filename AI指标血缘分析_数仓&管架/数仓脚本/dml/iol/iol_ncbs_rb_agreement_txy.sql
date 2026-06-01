/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_agreement_txy
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
drop table ${iol_schema}.ncbs_rb_agreement_txy_ex purge;
alter table ${iol_schema}.ncbs_rb_agreement_txy add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ncbs_rb_agreement_txy;

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_agreement_txy_ex nologging
compress
as
select * from ${iol_schema}.ncbs_rb_agreement_txy where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_agreement_txy_ex(
    agreement_id -- 协议编号
    ,main_agreement_id -- 主协议协议号
    ,base_acct_no -- 交易账号/卡号
    ,prod_type -- 产品编号
    ,acct_ccy -- 账户币种
    ,acct_seq_no -- 账户子账号
    ,client_no -- 客户编号
    ,agree_int_rate -- 协议利率
    ,over_grade_rate -- 超档利率
    ,past_fad_rate -- 违约利率
    ,cycle_freq -- 结息频率
    ,agre_prod_type -- 签约主产品类型
    ,main_flag -- 主、分账户类型标志
    ,sign_id -- 外围系统协议编号
    ,internal_key -- 账户内部键值
    ,tran_timestamp -- 交易时间戳
    ,user_id -- 交易柜员编号
    ,branch -- 交易机构编号
    ,channel -- 渠道
    ,company -- 法人
    ,agg -- 积数
    ,int_accrued_calc_ctd -- 累计计提
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    agreement_id -- 协议编号
    ,main_agreement_id -- 主协议协议号
    ,base_acct_no -- 交易账号/卡号
    ,prod_type -- 产品编号
    ,acct_ccy -- 账户币种
    ,acct_seq_no -- 账户子账号
    ,client_no -- 客户编号
    ,agree_int_rate -- 协议利率
    ,over_grade_rate -- 超档利率
    ,past_fad_rate -- 违约利率
    ,cycle_freq -- 结息频率
    ,agre_prod_type -- 签约主产品类型
    ,main_flag -- 主、分账户类型标志
    ,sign_id -- 外围系统协议编号
    ,internal_key -- 账户内部键值
    ,tran_timestamp -- 交易时间戳
    ,user_id -- 交易柜员编号
    ,branch -- 交易机构编号
    ,channel -- 渠道
    ,company -- 法人
    ,agg -- 积数
    ,int_accrued_calc_ctd -- 累计计提
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_agreement_txy
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_agreement_txy exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_agreement_txy_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_agreement_txy to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_agreement_txy_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_agreement_txy',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);