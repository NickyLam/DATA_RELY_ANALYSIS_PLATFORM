/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_i_r_accfund
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
drop table ${iol_schema}.cqss_i_r_accfund_ex purge;
alter table ${iol_schema}.cqss_i_r_accfund add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_i_r_accfund truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_i_r_accfund_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_i_r_accfund where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_i_r_accfund_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,crprvdfnd_pcp_pyf_adr -- 征信公积金参加缴费地址:PF05AQ01
    ,cr_prvdfnd_pcp_pyf_dt -- 征信公积金参加缴费日期:PF05AR01
    ,cr_hsgrsvfnd_pyf_stcd -- 征信住房公积金缴费状态代码:PF05AD01
    ,crprvdfnd_ftm_pymt_dt -- 征信公积金首次缴交日期:PF05AR02
    ,hsgrsvfnd_pyt_yrmo -- 住房公积金缴至年月:PF05AR03
    ,prvdfndunit_depd_pctg -- 公积金单位缴存比例:PF05AQ02
    ,prvdfnd_idv_depd_pctg -- 公积金个人缴存比例:PF05AQ03
    ,cr_prvdfnd_mo_pym_amt -- 征信公积金月缴款总金额:PF05AJ01
    ,prvdfnd_unit_nm -- 公积金单位名称:PF05AQ04
    ,cr_inf_udt_dt -- 征信信息更新日期:PF05AR04
    ,annttn_and_sttmnt_num -- 标注及声明个数:PF05ZS01
    ,multi_tenancy_id -- 多实体标识
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,crprvdfnd_pcp_pyf_adr -- 征信公积金参加缴费地址:PF05AQ01
    ,cr_prvdfnd_pcp_pyf_dt -- 征信公积金参加缴费日期:PF05AR01
    ,cr_hsgrsvfnd_pyf_stcd -- 征信住房公积金缴费状态代码:PF05AD01
    ,crprvdfnd_ftm_pymt_dt -- 征信公积金首次缴交日期:PF05AR02
    ,hsgrsvfnd_pyt_yrmo -- 住房公积金缴至年月:PF05AR03
    ,prvdfndunit_depd_pctg -- 公积金单位缴存比例:PF05AQ02
    ,prvdfnd_idv_depd_pctg -- 公积金个人缴存比例:PF05AQ03
    ,cr_prvdfnd_mo_pym_amt -- 征信公积金月缴款总金额:PF05AJ01
    ,prvdfnd_unit_nm -- 公积金单位名称:PF05AQ04
    ,cr_inf_udt_dt -- 征信信息更新日期:PF05AR04
    ,annttn_and_sttmnt_num -- 标注及声明个数:PF05ZS01
    ,multi_tenancy_id -- 多实体标识
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_i_r_accfund
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_i_r_accfund exchange partition p_${batch_date} with table ${iol_schema}.cqss_i_r_accfund_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_i_r_accfund to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_i_r_accfund_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_i_r_accfund',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);