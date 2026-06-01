/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_e_r_careerinexinfo2013
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
drop table ${iol_schema}.cqss_e_r_careerinexinfo2013_ex purge;
alter table ${iol_schema}.cqss_e_r_careerinexinfo2013 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_e_r_careerinexinfo2013 truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_e_r_careerinexinfo2013_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_e_r_careerinexinfo2013 where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_e_r_careerinexinfo2013_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_supr_rcrd_id -- 征信上级记录编号(上级序号)
    ,fnc_alwc_crrov_srpls -- 本期财政补助结转结余:EG10BJ01
    ,fnc_alwc_incm -- 财政补助收入:EG10BJ02
    ,crer_expn -- 事业支出（财政补助支出）:EG10BJ03
    ,crer_crrov_srpls -- 本期事业结转结余:EG10BJ04
    ,crcgy_incm -- 事业类收入:EG10BJ05
    ,crer_incm -- 事业收入:EG10BJ06
    ,supr_alwc_incm -- 上级补助收入:EG10BJ07
    ,aflt_unit_tnov_incm -- 附属单位上缴收入:EG10BJ08
    ,oicm -- 其他收入:EG10BJ09
    ,dntn_incm -- （其他收入科目下）捐赠收入:EG10BJ10
    ,crcgy_expn -- 事业类支出:EG10BJ11
    ,non_fnc_alwc_crer_expn -- 事业支出（非财政补助支出）:EG10BJ12
    ,tnov_supr_expn -- 上缴上级支出:EG10BJ13
    ,aflt_unit_alwc_expn -- 对附属单位补助支出:EG10BJ14
    ,othexp -- 其他支出:EG10BJ15
    ,crnprd_oprt_srpls -- 本期经营结余:EG10BJ16
    ,oprt_incm -- 经营收入:EG10BJ17
    ,oprt_expn -- 经营支出:EG10BJ18
    ,flup_bfrls_afs_oprt_stlmt -- 弥补以前年度亏损后的经营结余:EG10BJ19
    ,tsyr_non_fnc_crrov_srpls -- 本年非财政补助结转结余:EG10BJ20
    ,non_fnc_crrov -- 非财政补助结转:EG10BJ21
    ,tsyr_non_fnc_srpls -- 本年非财政补助结余:EG10BJ22
    ,pbl_entp_incmtax -- 应缴企业所得税:EG10BJ23
    ,rtrv_spclpps_fnd -- 提取专用基金:EG10BJ24
    ,tfrin_crer_fnd -- 转入事业基金:EG10BJ25
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_supr_rcrd_id -- 征信上级记录编号(上级序号)
    ,fnc_alwc_crrov_srpls -- 本期财政补助结转结余:EG10BJ01
    ,fnc_alwc_incm -- 财政补助收入:EG10BJ02
    ,crer_expn -- 事业支出（财政补助支出）:EG10BJ03
    ,crer_crrov_srpls -- 本期事业结转结余:EG10BJ04
    ,crcgy_incm -- 事业类收入:EG10BJ05
    ,crer_incm -- 事业收入:EG10BJ06
    ,supr_alwc_incm -- 上级补助收入:EG10BJ07
    ,aflt_unit_tnov_incm -- 附属单位上缴收入:EG10BJ08
    ,oicm -- 其他收入:EG10BJ09
    ,dntn_incm -- （其他收入科目下）捐赠收入:EG10BJ10
    ,crcgy_expn -- 事业类支出:EG10BJ11
    ,non_fnc_alwc_crer_expn -- 事业支出（非财政补助支出）:EG10BJ12
    ,tnov_supr_expn -- 上缴上级支出:EG10BJ13
    ,aflt_unit_alwc_expn -- 对附属单位补助支出:EG10BJ14
    ,othexp -- 其他支出:EG10BJ15
    ,crnprd_oprt_srpls -- 本期经营结余:EG10BJ16
    ,oprt_incm -- 经营收入:EG10BJ17
    ,oprt_expn -- 经营支出:EG10BJ18
    ,flup_bfrls_afs_oprt_stlmt -- 弥补以前年度亏损后的经营结余:EG10BJ19
    ,tsyr_non_fnc_crrov_srpls -- 本年非财政补助结转结余:EG10BJ20
    ,non_fnc_crrov -- 非财政补助结转:EG10BJ21
    ,tsyr_non_fnc_srpls -- 本年非财政补助结余:EG10BJ22
    ,pbl_entp_incmtax -- 应缴企业所得税:EG10BJ23
    ,rtrv_spclpps_fnd -- 提取专用基金:EG10BJ24
    ,tfrin_crer_fnd -- 转入事业基金:EG10BJ25
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_e_r_careerinexinfo2013
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_e_r_careerinexinfo2013 exchange partition p_${batch_date} with table ${iol_schema}.cqss_e_r_careerinexinfo2013_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_e_r_careerinexinfo2013 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_e_r_careerinexinfo2013_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_e_r_careerinexinfo2013',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);