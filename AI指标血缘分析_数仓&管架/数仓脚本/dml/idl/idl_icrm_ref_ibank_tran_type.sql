/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_ref_ibank_tran_type
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.icrm_ref_ibank_tran_type drop partition p_${last_date};
alter table ${idl_schema}.icrm_ref_ibank_tran_type drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_ref_ibank_tran_type add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_ref_ibank_tran_type partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,tran_type_id  -- 交易类型编号
    ,lp_id  -- 法人编号
    ,tran_type_descb  -- 交易类型描述
    ,ped_instr_cd  -- 周期指令代码
    ,crdt_risk_check_flg  -- 信用风险审查标志
    ,check_admit_lib_flg  -- 校验准入库标志
    ,seq_num  -- 序号
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.tran_type_id,chr(13),''),chr(10),'')  -- 交易类型编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.tran_type_descb,chr(13),''),chr(10),'')  -- 交易类型描述
    ,replace(replace(t1.ped_instr_cd,chr(13),''),chr(10),'')  -- 周期指令代码
    ,replace(replace(t1.crdt_risk_check_flg,chr(13),''),chr(10),'')  -- 信用风险审查标志
    ,replace(replace(t1.check_admit_lib_flg,chr(13),''),chr(10),'')  -- 校验准入库标志
    ,replace(replace(t1.seq_num,chr(13),''),chr(10),'')  -- 序号
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.ref_ibank_tran_type t1    --同业交易类型
where t1.create_dt<= to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_ref_ibank_tran_type',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);