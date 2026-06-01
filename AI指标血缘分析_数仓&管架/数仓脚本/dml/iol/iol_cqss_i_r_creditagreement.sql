/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_i_r_creditagreement
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
drop table ${iol_schema}.cqss_i_r_creditagreement_ex purge;
alter table ${iol_schema}.cqss_i_r_creditagreement add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_i_r_creditagreement truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_i_r_creditagreement_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_i_r_creditagreement where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_i_r_creditagreement_ex(
    id -- 代码主键
    ,crg_agrm_id -- 授信协议编号:PD02AI01
    ,msgidno -- 报文标识号
    ,inst_tp -- 机构类型:PD02AD01
    ,mtit_ecd -- 管理机构编码:PD02AI02
    ,crg_agrm_idr_cd -- 授信协议标识码:PD02AI03
    ,crgln_use -- 授信额度用途:PD02AD02
    ,crgln -- 授信额度:PD02AJ01
    ,ccycd -- 币种代码:PD02AD03
    ,efdt -- 生效日期:PD02AR01
    ,exdat -- 到期日期:PD02AR02
    ,crg_agrm_st -- 授信协议状态:PD02AD04
    ,crg_qot -- 授信限额:PD02AJ03
    ,crg_qot_id -- 授信限额编号:PD02AI04
    ,usd_lmt -- 已用额度:PD02AJ04
    ,alrdyclsglnhostrtyrmo -- 已结清贷款历史逾期开始年月
    ,alrdyclsglnhtocofyrmo -- 已结清贷款历史逾期截止年月
    ,sptxn_num -- 特殊交易个数
    ,annttn_and_sttmnt_num -- 标注及声明个数:PD02ZS01
    ,multi_tenancy_id -- 多实体标识
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,crg_agrm_id -- 授信协议编号:PD02AI01
    ,msgidno -- 报文标识号
    ,inst_tp -- 机构类型:PD02AD01
    ,mtit_ecd -- 管理机构编码:PD02AI02
    ,crg_agrm_idr_cd -- 授信协议标识码:PD02AI03
    ,crgln_use -- 授信额度用途:PD02AD02
    ,crgln -- 授信额度:PD02AJ01
    ,ccycd -- 币种代码:PD02AD03
    ,efdt -- 生效日期:PD02AR01
    ,exdat -- 到期日期:PD02AR02
    ,crg_agrm_st -- 授信协议状态:PD02AD04
    ,crg_qot -- 授信限额:PD02AJ03
    ,crg_qot_id -- 授信限额编号:PD02AI04
    ,usd_lmt -- 已用额度:PD02AJ04
    ,alrdyclsglnhostrtyrmo -- 已结清贷款历史逾期开始年月
    ,alrdyclsglnhtocofyrmo -- 已结清贷款历史逾期截止年月
    ,sptxn_num -- 特殊交易个数
    ,annttn_and_sttmnt_num -- 标注及声明个数:PD02ZS01
    ,multi_tenancy_id -- 多实体标识
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_i_r_creditagreement
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_i_r_creditagreement exchange partition p_${batch_date} with table ${iol_schema}.cqss_i_r_creditagreement_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_i_r_creditagreement to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_i_r_creditagreement_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_i_r_creditagreement',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);