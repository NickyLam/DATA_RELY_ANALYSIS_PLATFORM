/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_i_r_latestmonthlyinfo
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
drop table ${iol_schema}.cqss_i_r_latestmonthlyinfo_ex purge;
alter table ${iol_schema}.cqss_i_r_latestmonthlyinfo add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_i_r_latestmonthlyinfo truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_i_r_latestmonthlyinfo_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_i_r_latestmonthlyinfo where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_i_r_latestmonthlyinfo_ex(
    id -- 代码主键
    ,cr_supr_rcrd_id -- 征信上级记录编号
    ,msgidno -- 报文标识号
    ,mo -- 月份:PD01CR01
    ,dbtcr_acc_st -- 借贷账户状态:PD01CD01
    ,dbtcr_acba -- 借贷账户余额:PD01CJ01
    ,usd_lmt -- 已用额度:PD01CJ02
    ,notisugsbigasinstmbal -- 未出单的大额专项分期余额:PD01CJ03
    ,pbc_lv5cl_cd -- 人行五级分类代码:PD01CD02
    ,srpls_repy_prd -- 剩余还款期数:PD01CS01
    ,setl_repydy -- 结算还款日:PD01CR02
    ,tm_shldrepymt_amt -- 本月应还款金额:PD01CJ04
    ,tm_act_repy_amt -- 本月实际还款金额:PD01CJ05
    ,rctlyocact_repydy_prd -- 最近一次实际还款日期:PD01CR03
    ,cur_odue_prd -- 当前逾期期数:PD01CS02
    ,cur_odue_tamt -- 当前逾期总额:PD01CJ06
    ,odue31to60dynotretpnp -- 逾期31至60天未归还本金:PD01CJ07
    ,odue61to90dynotretpnp -- 逾期61至90天未归还本金:PD01CJ08
    ,odue91toohednotretpnp -- 逾期91至180天未归还本金:PD01CJ09
    ,odueohedyabv_ntpa_bal -- 逾期180天以上未归还本金:PD01CJ10
    ,od_ohedy_abv_ntpa_bal -- 透支180天以上未还余额:PD01CJ11
    ,rctly6etrsmoavgus_lmt -- 最近6个月平均使用额度:PD01CJ12
    ,rctly6etrsmoavgod_bal -- 最近6个月平均透支余额:PD01CJ13
    ,max_us_lmt -- 最大使用额度:PD01CJ14
    ,max_od_bal -- 最大透支余额:PD01CJ15
    ,rpt_dt -- 信息报告日期:PD01CR04
    ,multi_tenancy_id -- 多实体标识
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,cr_supr_rcrd_id -- 征信上级记录编号
    ,msgidno -- 报文标识号
    ,mo -- 月份:PD01CR01
    ,dbtcr_acc_st -- 借贷账户状态:PD01CD01
    ,dbtcr_acba -- 借贷账户余额:PD01CJ01
    ,usd_lmt -- 已用额度:PD01CJ02
    ,notisugsbigasinstmbal -- 未出单的大额专项分期余额:PD01CJ03
    ,pbc_lv5cl_cd -- 人行五级分类代码:PD01CD02
    ,srpls_repy_prd -- 剩余还款期数:PD01CS01
    ,setl_repydy -- 结算还款日:PD01CR02
    ,tm_shldrepymt_amt -- 本月应还款金额:PD01CJ04
    ,tm_act_repy_amt -- 本月实际还款金额:PD01CJ05
    ,rctlyocact_repydy_prd -- 最近一次实际还款日期:PD01CR03
    ,cur_odue_prd -- 当前逾期期数:PD01CS02
    ,cur_odue_tamt -- 当前逾期总额:PD01CJ06
    ,odue31to60dynotretpnp -- 逾期31至60天未归还本金:PD01CJ07
    ,odue61to90dynotretpnp -- 逾期61至90天未归还本金:PD01CJ08
    ,odue91toohednotretpnp -- 逾期91至180天未归还本金:PD01CJ09
    ,odueohedyabv_ntpa_bal -- 逾期180天以上未归还本金:PD01CJ10
    ,od_ohedy_abv_ntpa_bal -- 透支180天以上未还余额:PD01CJ11
    ,rctly6etrsmoavgus_lmt -- 最近6个月平均使用额度:PD01CJ12
    ,rctly6etrsmoavgod_bal -- 最近6个月平均透支余额:PD01CJ13
    ,max_us_lmt -- 最大使用额度:PD01CJ14
    ,max_od_bal -- 最大透支余额:PD01CJ15
    ,rpt_dt -- 信息报告日期:PD01CR04
    ,multi_tenancy_id -- 多实体标识
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_i_r_latestmonthlyinfo
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_i_r_latestmonthlyinfo exchange partition p_${batch_date} with table ${iol_schema}.cqss_i_r_latestmonthlyinfo_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_i_r_latestmonthlyinfo to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_i_r_latestmonthlyinfo_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_i_r_latestmonthlyinfo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);