/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_e_r_dbtcrtxnrlrrsplsmyinf
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
drop table ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf_ex purge;
alter table ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,rel_repy_rspl_tp -- 相关还款责任类型:EB05AD01
    ,berecaccsrepyrspl_qot -- 被追偿账户的还款责任限额:EB05AJ01
    ,be_rec_acc_tot -- 被追偿账户数合计:EB05AS02
    ,be_rec_bal_tot -- 被追偿余额合计:EB05AJ02
    ,othrdbtcrtrepyrsplqot -- 其他借贷交易的还款责任限额:EB05AJ03
    ,othr_dbtcr_tnac_num -- 其他借贷交易账户数:EB05AS03
    ,othr_dbtcr_tnac_bal -- 其他借贷交易账户余额:EB05AJ04
    ,othrdbtcrtnafcscgybal -- 其他借贷交易账户关注类余额:EB05AJ05
    ,othrdbtcrtnabadcgybal -- 其他借贷交易账户不良类余额:EB05AJ06
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,rel_repy_rspl_tp -- 相关还款责任类型:EB05AD01
    ,berecaccsrepyrspl_qot -- 被追偿账户的还款责任限额:EB05AJ01
    ,be_rec_acc_tot -- 被追偿账户数合计:EB05AS02
    ,be_rec_bal_tot -- 被追偿余额合计:EB05AJ02
    ,othrdbtcrtrepyrsplqot -- 其他借贷交易的还款责任限额:EB05AJ03
    ,othr_dbtcr_tnac_num -- 其他借贷交易账户数:EB05AS03
    ,othr_dbtcr_tnac_bal -- 其他借贷交易账户余额:EB05AJ04
    ,othrdbtcrtnafcscgybal -- 其他借贷交易账户关注类余额:EB05AJ05
    ,othrdbtcrtnabadcgybal -- 其他借贷交易账户不良类余额:EB05AJ06
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf exchange partition p_${batch_date} with table ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_e_r_dbtcrtxnrlrrsplsmyinf',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);