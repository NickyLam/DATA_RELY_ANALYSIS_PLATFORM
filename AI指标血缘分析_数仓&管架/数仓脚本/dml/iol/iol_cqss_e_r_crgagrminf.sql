/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_e_r_crgagrminf
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
drop table ${iol_schema}.cqss_e_r_crgagrminf_ex purge;
alter table ${iol_schema}.cqss_e_r_crgagrminf add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_e_r_crgagrminf truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_e_r_crgagrminf_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_e_r_crgagrminf where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_e_r_crgagrminf_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,crg_agrm_id -- 授信协议编号:ED060I01
    ,inst_tp -- 机构类型(业务管理机构类型):ED060D01
    ,mtit_ecd -- 管理机构编码(业务管理机构代码):ED060I02
    ,entp_cr_crgln_tp -- 授信额度类型:ED060D02
    ,lmt_rvl_ind -- 额度循环标志:ED060D03
    ,ccycd -- 币种代码(币种):ED060D04
    ,crgln -- 授信额度:ED060J01
    ,usd_lmt -- 已用额度:ED060J04
    ,crg_qot -- 授信限额:ED060J03
    ,crg_qot_id -- 授信限额编号:ED060I03
    ,efdt -- 生效日期:ED060R01
    ,crg_agrm_tmdt -- 授信协议终止日期(终止日期):ED060R02
    ,infrpt_dt -- 信息报告日期:ED060R03
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,crg_agrm_id -- 授信协议编号:ED060I01
    ,inst_tp -- 机构类型(业务管理机构类型):ED060D01
    ,mtit_ecd -- 管理机构编码(业务管理机构代码):ED060I02
    ,entp_cr_crgln_tp -- 授信额度类型:ED060D02
    ,lmt_rvl_ind -- 额度循环标志:ED060D03
    ,ccycd -- 币种代码(币种):ED060D04
    ,crgln -- 授信额度:ED060J01
    ,usd_lmt -- 已用额度:ED060J04
    ,crg_qot -- 授信限额:ED060J03
    ,crg_qot_id -- 授信限额编号:ED060I03
    ,efdt -- 生效日期:ED060R01
    ,crg_agrm_tmdt -- 授信协议终止日期(终止日期):ED060R02
    ,infrpt_dt -- 信息报告日期:ED060R03
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_e_r_crgagrminf
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_e_r_crgagrminf exchange partition p_${batch_date} with table ${iol_schema}.cqss_e_r_crgagrminf_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_e_r_crgagrminf to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_e_r_crgagrminf_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_e_r_crgagrminf',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);