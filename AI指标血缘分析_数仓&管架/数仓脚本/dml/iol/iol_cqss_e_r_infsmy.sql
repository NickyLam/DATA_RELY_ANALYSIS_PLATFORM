/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_e_r_infsmy
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
drop table ${iol_schema}.cqss_e_r_infsmy_ex purge;
alter table ${iol_schema}.cqss_e_r_infsmy add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_e_r_infsmy truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_e_r_infsmy_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_e_r_infsmy where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_e_r_infsmy_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,ftm_ext_crln_txn_s_yr -- 首次有信贷交易的年份:EB01AR01
    ,ftmextrelrepyrspls_yr -- 首次有相关还款责任的年份:EB01AR02
    ,hpncrlntxn_s_inst_num -- 发生信贷交易的机构数:EB01AS01
    ,crnotclsg_ln_inst_num -- 征信未结清贷款机构数（当前有未结清信贷交易的机构数）:EB01AS02
    ,dbtcr_txn_bal -- 借贷交易余额:EB01AJ01
    ,berec_s_dbtcr_txn_bal -- 被追偿的借贷交易余额:EB01AJ02
    ,fcs_cgy_dbtcr_txn_bal -- 关注类借贷交易余额:EB01AJ03
    ,bad_cgy_dbtcr_txn_bal -- 不良类借贷交易余额:EB01AJ04
    ,wrnt_txn_bal_bal -- 担保交易余额余额:EB01AJ05
    ,fcs_cgy_wrnt_txn_bal -- 关注类担保交易余额:EB01AJ06
    ,bad_cgy_wrnt_txn_bal -- 不良类担保交易余额:EB01AJ07
    ,noncr_tnac_num -- 非信贷交易账户数:EB01BS01
    ,ow_tax_rcrd_num -- 欠税记录条数:EB01BS02
    ,cvl_jdgmt_rcrd_num -- 民事判决记录条数:EB01BS03
    ,efrcexe_rcrd_num -- 强制执行记录条数:EB01BS04
    ,admn_pnsh_rcrd_num -- 行政处罚记录条数:EB01BS05
    ,notclsgwrttclsentrnum -- 未结清担保交易分类汇总条目数量(担保交易分类汇总条目数量):EB03AS01
    ,alrdyclsgwtclsentrnum -- 已结清担保交易分类汇总条目数量(担保交易分类汇总条目数量):EB03BS01
    ,dbtcrtxnrelrrspltpnum -- 借贷交易相关还款责任类型数量:EB05AS01
    ,wrnttxnrelryrspltpnum -- 担保交易相关还款责任类型数量:EB05BS01
    ,hist_lby_mo_num -- 历史负债月份数(月份数):EB02CS01
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,ftm_ext_crln_txn_s_yr -- 首次有信贷交易的年份:EB01AR01
    ,ftmextrelrepyrspls_yr -- 首次有相关还款责任的年份:EB01AR02
    ,hpncrlntxn_s_inst_num -- 发生信贷交易的机构数:EB01AS01
    ,crnotclsg_ln_inst_num -- 征信未结清贷款机构数（当前有未结清信贷交易的机构数）:EB01AS02
    ,dbtcr_txn_bal -- 借贷交易余额:EB01AJ01
    ,berec_s_dbtcr_txn_bal -- 被追偿的借贷交易余额:EB01AJ02
    ,fcs_cgy_dbtcr_txn_bal -- 关注类借贷交易余额:EB01AJ03
    ,bad_cgy_dbtcr_txn_bal -- 不良类借贷交易余额:EB01AJ04
    ,wrnt_txn_bal_bal -- 担保交易余额余额:EB01AJ05
    ,fcs_cgy_wrnt_txn_bal -- 关注类担保交易余额:EB01AJ06
    ,bad_cgy_wrnt_txn_bal -- 不良类担保交易余额:EB01AJ07
    ,noncr_tnac_num -- 非信贷交易账户数:EB01BS01
    ,ow_tax_rcrd_num -- 欠税记录条数:EB01BS02
    ,cvl_jdgmt_rcrd_num -- 民事判决记录条数:EB01BS03
    ,efrcexe_rcrd_num -- 强制执行记录条数:EB01BS04
    ,admn_pnsh_rcrd_num -- 行政处罚记录条数:EB01BS05
    ,notclsgwrttclsentrnum -- 未结清担保交易分类汇总条目数量(担保交易分类汇总条目数量):EB03AS01
    ,alrdyclsgwtclsentrnum -- 已结清担保交易分类汇总条目数量(担保交易分类汇总条目数量):EB03BS01
    ,dbtcrtxnrelrrspltpnum -- 借贷交易相关还款责任类型数量:EB05AS01
    ,wrnttxnrelryrspltpnum -- 担保交易相关还款责任类型数量:EB05BS01
    ,hist_lby_mo_num -- 历史负债月份数(月份数):EB02CS01
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_e_r_infsmy
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_e_r_infsmy exchange partition p_${batch_date} with table ${iol_schema}.cqss_e_r_infsmy_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_e_r_infsmy to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_e_r_infsmy_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_e_r_infsmy',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);