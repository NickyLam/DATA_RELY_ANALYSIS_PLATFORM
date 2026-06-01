/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_e_r_profitinfo2007
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
drop table ${iol_schema}.cqss_e_r_profitinfo2007_ex purge;
alter table ${iol_schema}.cqss_e_r_profitinfo2007 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_e_r_profitinfo2007 truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_e_r_profitinfo2007_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_e_r_profitinfo2007 where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_e_r_profitinfo2007_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_supr_rcrd_id -- 征信上级记录编号(上级序号)
    ,oprg_incm -- 营业收入:EG04BJ01
    ,oprg_cost -- 营业成本:EG04BJ02
    ,btschrg -- 营业税金及附加:EG04BJ03
    ,sale_eps -- 销售费用:EG04BJ04
    ,mtex -- 管理费用:EG04BJ05
    ,fncex -- 财务费用:EG04BJ06
    ,ammls -- 资产减值损失:EG04BJ07
    ,frval_chg_ntincm -- 公允价值变动净收益:EG04BJ08
    ,ivs_netincm -- 投资净收益:EG04BJ09
    ,ascent_jnvnts_ivs_pft -- 对联营企业和合营企业的投资收益:EG04BJ10
    ,oprg_pft -- 营业利润:EG04BJ11
    ,nonoprgincm -- 营业外收入:EG04BJ12
    ,nopex -- 营业外支出:EG04BJ13
    ,non_lqud_ast_loss -- 非流动资产损失（其中：非流动资产处置损失）:EG04BJ14
    ,pft_tamt -- 利润总额:EG04BJ15
    ,incmtax_eps -- 所得税费用:EG04BJ16
    ,net_pft -- 净利润:EG04BJ17
    ,bsc_eps -- 基本每股收益:EG04BJ18
    ,dut_eps -- 稀释每股收益:EG04BJ19
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_supr_rcrd_id -- 征信上级记录编号(上级序号)
    ,oprg_incm -- 营业收入:EG04BJ01
    ,oprg_cost -- 营业成本:EG04BJ02
    ,btschrg -- 营业税金及附加:EG04BJ03
    ,sale_eps -- 销售费用:EG04BJ04
    ,mtex -- 管理费用:EG04BJ05
    ,fncex -- 财务费用:EG04BJ06
    ,ammls -- 资产减值损失:EG04BJ07
    ,frval_chg_ntincm -- 公允价值变动净收益:EG04BJ08
    ,ivs_netincm -- 投资净收益:EG04BJ09
    ,ascent_jnvnts_ivs_pft -- 对联营企业和合营企业的投资收益:EG04BJ10
    ,oprg_pft -- 营业利润:EG04BJ11
    ,nonoprgincm -- 营业外收入:EG04BJ12
    ,nopex -- 营业外支出:EG04BJ13
    ,non_lqud_ast_loss -- 非流动资产损失（其中：非流动资产处置损失）:EG04BJ14
    ,pft_tamt -- 利润总额:EG04BJ15
    ,incmtax_eps -- 所得税费用:EG04BJ16
    ,net_pft -- 净利润:EG04BJ17
    ,bsc_eps -- 基本每股收益:EG04BJ18
    ,dut_eps -- 稀释每股收益:EG04BJ19
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_e_r_profitinfo2007
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_e_r_profitinfo2007 exchange partition p_${batch_date} with table ${iol_schema}.cqss_e_r_profitinfo2007_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_e_r_profitinfo2007 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_e_r_profitinfo2007_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_e_r_profitinfo2007',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);