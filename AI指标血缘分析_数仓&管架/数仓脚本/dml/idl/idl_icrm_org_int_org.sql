/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_org_int_org
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
alter table ${idl_schema}.icrm_org_int_org drop partition p_${last_date};
alter table ${idl_schema}.icrm_org_int_org drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_org_int_org add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_org_int_org partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,org_id  -- 机构编号
    ,lp_id  -- 法人编号
    ,org_name  -- 机构名称
    ,org_abbr  -- 机构简称
    ,org_type_cd  -- 机构类型代码
    ,org_found_dt  -- 机构成立日期
    ,org_close_dt  -- 机构关闭日期
    ,enty_org_flg  -- 实体机构标志
    ,accti_org_flg  -- 核算机构标志
    ,bus_org_flg  -- 营业机构标志
    ,admin_org_flg  -- 行政机构标志
    ,acct_instit_flg  -- 账务机构标志
    ,vtual_org_flg  -- 虚拟机构标志
    ,org_lev_cd  -- 机构级别代码
    ,org_status_cd  -- 机构状态代码
    ,org_bus_status_cd  -- 机构营业状态代码
    ,unify_orgnz_id  -- 统一组织机构编号
    ,fin_lics_num  -- 金融许可证号码
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.org_id,chr(13),''),chr(10),'')  -- 机构编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t3.org_name,chr(13),''),chr(10),'') as org_name  -- 机构名称
    ,replace(replace(t3.org_abbr,chr(13),''),chr(10),'') as org_abbr  -- 机构简称
    ,replace(replace(t1.org_type_cd,chr(13),''),chr(10),'')  -- 机构类型代码
    ,t1.org_found_dt  -- 机构成立日期
    ,t1.org_close_dt  -- 机构关闭日期
    ,replace(replace(t1.enty_org_flg,chr(13),''),chr(10),'')  -- 实体机构标志
    ,replace(replace(t1.accti_org_flg,chr(13),''),chr(10),'')  -- 核算机构标志
    ,replace(replace(t1.bus_org_flg,chr(13),''),chr(10),'')  -- 营业机构标志
    ,replace(replace(t1.admin_org_flg,chr(13),''),chr(10),'')  -- 行政机构标志
    ,replace(replace(t1.acct_instit_flg,chr(13),''),chr(10),'')  -- 账务机构标志
    ,replace(replace(t1.vtual_org_flg,chr(13),''),chr(10),'')  -- 虚拟机构标志
    ,replace(replace(t1.org_lev_cd,chr(13),''),chr(10),'')  -- 机构级别代码
    ,replace(replace(t2.org_status_cd,chr(13),''),chr(10),'') as org_status_cd  -- 机构状态代码
    ,replace(replace(t4.org_status_cd,chr(13),''),chr(10),'') as org_bus_status_cd  -- 机构状态代码
    ,replace(replace(t1.unify_orgnz_id,chr(13),''),chr(10),'')  -- 统一组织机构编号
    ,replace(replace(t1.fin_lics_num,chr(13),''),chr(10),'')  -- 金融许可证号码
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.org_int_org t1    --内部机构
left join ${iml_schema}.org_intnal_org_status_h t2  --内部机构状态历史
    on t1.org_id = t2.org_id
    and t1.lp_id = t2.lp_id
    and t2.job_cd = 'uussf1'
    and t2.start_dt <=to_date('${batch_date}','yyyymmdd')
    and t2.end_dt >to_date('${batch_date}','yyyymmdd')
    and t2.id_mark <> 'D'
    and t2.intnal_org_status_type_cd = '01'
left join ${iml_schema}.org_intnal_org_status_h t4  --内部机构状态历史
    on t1.org_id = t4.org_id
    and t1.lp_id = t4.lp_id
    and t4.job_cd = 'uussf1'
    and t4.start_dt <=to_date('${batch_date}','yyyymmdd')
    and t4.end_dt >to_date('${batch_date}','yyyymmdd')
    and t4.id_mark <> 'D'
    and t4.intnal_org_status_type_cd = '02'
left join ${iml_schema}.org_intnal_org_name_h t3  --内部机构名称历史
    on t1.org_id = t3.org_id
    and t1.lp_id = t3.lp_id
    and t3.job_cd = 'uussf1'
    and t3.start_dt <=to_date('${batch_date}','yyyymmdd')
    and t3.end_dt >to_date('${batch_date}','yyyymmdd')
    and t3.id_mark <> 'D'
    and t3.src_table_name = 'uuss_uus_organ'
where t1.create_dt<= to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_org_int_org',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);