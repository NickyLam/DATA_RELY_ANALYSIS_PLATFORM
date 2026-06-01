/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_org_int_org_addr_h
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
alter table ${idl_schema}.aml_org_int_org_addr_h drop partition p_${last_date};
alter table ${idl_schema}.aml_org_int_org_addr_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_org_int_org_addr_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_org_int_org_addr_h partition for (to_date('${batch_date}','yyyymmdd')) (
    org_id  -- 机构编号
    ,lp_id  -- 法人编号
    ,start_dt  -- 开始日期
    ,tel_num  -- 电话号码
    ,zip_cd  -- 邮政编码
    ,cty_or_rg_cd  -- 国家或地区代码
    ,prov_cd  -- 省代码
    ,city_cd  -- 市代码
    ,county_cd  -- 县代码
    ,dtl_addr  -- 详细地址
    ,princ_emply_id  -- 负责人员工编号
    ,princ_name  -- 负责人姓名
    ,ddd_area_cd  -- 国内长途区号
    ,end_dt  -- 结束日期
    ,id_mark  -- 删除标识
    ,src_table_name  -- 源表名称
    ,job_cd  -- 任务代码
    ,etl_dt  -- 数据日期
    ,etl_timestamp  -- 数据处理时间
)
select
    replace(replace(t1.org_id,chr(13),''),chr(10),'')  -- 机构编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,t1.start_dt  -- 开始日期
    ,replace(replace(t1.tel_num,chr(13),''),chr(10),'')  -- 电话号码
    ,replace(replace(t1.zip_cd,chr(13),''),chr(10),'')  -- 邮政编码
    ,replace(replace(t1.cty_or_rg_cd,chr(13),''),chr(10),'')  -- 国家或地区代码
    ,replace(replace(t1.prov_cd,chr(13),''),chr(10),'')  -- 省代码
    ,replace(replace(t1.city_cd,chr(13),''),chr(10),'')  -- 市代码
    ,replace(replace(t1.county_cd,chr(13),''),chr(10),'')  -- 县代码
    ,replace(replace(t1.dtl_addr,chr(13),''),chr(10),'')  -- 详细地址
    ,replace(replace(t1.princ_emply_id,chr(13),''),chr(10),'')  -- 负责人员工编号
    ,replace(replace(t1.princ_name,chr(13),''),chr(10),'')  -- 负责人姓名
    ,replace(replace(t1.ddd_area_cd,chr(13),''),chr(10),'')  -- 国内长途区号
    ,t1.end_dt  -- 结束日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.src_table_name,chr(13),''),chr(10),'')  -- 源表名称
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,t1.etl_timestamp  -- 数据处理时间
from ${iml_schema}.org_int_org_addr_h t1    --内部机构地址历史
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_org_int_org_addr_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);