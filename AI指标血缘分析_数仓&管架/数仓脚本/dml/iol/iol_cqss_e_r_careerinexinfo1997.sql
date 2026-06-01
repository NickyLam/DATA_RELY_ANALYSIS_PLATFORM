/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_e_r_careerinexinfo1997
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
drop table ${iol_schema}.cqss_e_r_careerinexinfo1997_ex purge;
alter table ${iol_schema}.cqss_e_r_careerinexinfo1997 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_e_r_careerinexinfo1997 truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_e_r_careerinexinfo1997_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_e_r_careerinexinfo1997 where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_e_r_careerinexinfo1997_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_supr_rcrd_id -- 征信上级记录编号(上级序号)
    ,fnc_alwc_incm -- 财政补助收入:EG09BJ01
    ,supr_alwc_incm -- 上级补助收入:EG09BJ02
    ,aflt_unit_pym -- 附属单位缴款:EG09BJ03
    ,crer_incm -- 事业收入:EG09BJ04
    ,bdgt_frgncptl_gld_incm -- 预算外资金收入:EG09BJ05
    ,oicm -- 其他收入:EG09BJ06
    ,crer_incm_sbtl -- 事业收入小计:EG09BJ07
    ,oprt_incm -- 经营收入:EG09BJ08
    ,oprt_incm_sbtl -- 经营收入小计:EG09BJ09
    ,into_spclfnd -- 拨入专款:EG09BJ10
    ,into_spclfnd_sbtl -- 拨入专款小计:EG09BJ11
    ,incm_tot -- 收入总计:EG09BJ12
    ,out_fee -- 拨出经费:EG09BJ13
    ,tnov_supr_expn -- 上缴上级支出:EG09BJ14
    ,to_aflt_unit_alwc -- 对附属单位补助:EG09BJ15
    ,crer_expn -- 事业支出:EG09BJ16
    ,fnc_alwc_expn -- 财政补助支出:EG09BJ17
    ,bdgt_frgncptl_gld_expn -- 预算外资金支出:EG09BJ18
    ,crer_sale_tax -- 销售税金:EG09BJ19
    ,crrov_slfnc_nfrstr -- 结转自筹基建:EG09BJ20
    ,crer_expn_sbtl -- 事业支出小计:EG09BJ21
    ,oprt_expn -- 经营支出:EG09BJ22
    ,oprt_sale_tax -- 销售税金:EG09BJ23
    ,oprt_expn_sbtl -- 经营支出小计:EG09BJ24
    ,out_spclfnd -- 拨出专款:EG09BJ25
    ,spclfnd_expn -- 专款支出:EG09BJ26
    ,spclfnd_sbtl -- 专款小计:EG09BJ27
    ,expn_tot -- 支出总计:EG09BJ28
    ,crer_srpls -- 事业结余:EG09BJ29
    ,rglr_incm_srpls -- 正常收入结余:EG09BJ30
    ,wd_awla_bfr_crer_expn -- 收回以前年度事业支出:EG09BJ31
    ,oprt_srpls -- 经营结余:EG09BJ32
    ,awla_bfr_oprt_loss -- 以前年度经营亏损:EG09BJ33
    ,srpls_alct -- 结余分配:EG09BJ34
    ,pymt_incmtax -- 应交所得税:EG09BJ35
    ,rtrv_spclpps_fnd -- 提取专用基金:EG09BJ36
    ,tfrin_crer_fnd -- 转入事业基金:EG09BJ37
    ,othr_srpls_alct -- 其他结余分配:EG09BJ38
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_supr_rcrd_id -- 征信上级记录编号(上级序号)
    ,fnc_alwc_incm -- 财政补助收入:EG09BJ01
    ,supr_alwc_incm -- 上级补助收入:EG09BJ02
    ,aflt_unit_pym -- 附属单位缴款:EG09BJ03
    ,crer_incm -- 事业收入:EG09BJ04
    ,bdgt_frgncptl_gld_incm -- 预算外资金收入:EG09BJ05
    ,oicm -- 其他收入:EG09BJ06
    ,crer_incm_sbtl -- 事业收入小计:EG09BJ07
    ,oprt_incm -- 经营收入:EG09BJ08
    ,oprt_incm_sbtl -- 经营收入小计:EG09BJ09
    ,into_spclfnd -- 拨入专款:EG09BJ10
    ,into_spclfnd_sbtl -- 拨入专款小计:EG09BJ11
    ,incm_tot -- 收入总计:EG09BJ12
    ,out_fee -- 拨出经费:EG09BJ13
    ,tnov_supr_expn -- 上缴上级支出:EG09BJ14
    ,to_aflt_unit_alwc -- 对附属单位补助:EG09BJ15
    ,crer_expn -- 事业支出:EG09BJ16
    ,fnc_alwc_expn -- 财政补助支出:EG09BJ17
    ,bdgt_frgncptl_gld_expn -- 预算外资金支出:EG09BJ18
    ,crer_sale_tax -- 销售税金:EG09BJ19
    ,crrov_slfnc_nfrstr -- 结转自筹基建:EG09BJ20
    ,crer_expn_sbtl -- 事业支出小计:EG09BJ21
    ,oprt_expn -- 经营支出:EG09BJ22
    ,oprt_sale_tax -- 销售税金:EG09BJ23
    ,oprt_expn_sbtl -- 经营支出小计:EG09BJ24
    ,out_spclfnd -- 拨出专款:EG09BJ25
    ,spclfnd_expn -- 专款支出:EG09BJ26
    ,spclfnd_sbtl -- 专款小计:EG09BJ27
    ,expn_tot -- 支出总计:EG09BJ28
    ,crer_srpls -- 事业结余:EG09BJ29
    ,rglr_incm_srpls -- 正常收入结余:EG09BJ30
    ,wd_awla_bfr_crer_expn -- 收回以前年度事业支出:EG09BJ31
    ,oprt_srpls -- 经营结余:EG09BJ32
    ,awla_bfr_oprt_loss -- 以前年度经营亏损:EG09BJ33
    ,srpls_alct -- 结余分配:EG09BJ34
    ,pymt_incmtax -- 应交所得税:EG09BJ35
    ,rtrv_spclpps_fnd -- 提取专用基金:EG09BJ36
    ,tfrin_crer_fnd -- 转入事业基金:EG09BJ37
    ,othr_srpls_alct -- 其他结余分配:EG09BJ38
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_e_r_careerinexinfo1997
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_e_r_careerinexinfo1997 exchange partition p_${batch_date} with table ${iol_schema}.cqss_e_r_careerinexinfo1997_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_e_r_careerinexinfo1997 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_e_r_careerinexinfo1997_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_e_r_careerinexinfo1997',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);