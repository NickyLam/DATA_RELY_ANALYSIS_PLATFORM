/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_ref_asset_bus_breed
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
--alter table ${idl_schema}.ref_asset_bus_breed drop partition p_${last_date};
alter table ${idl_schema}.ref_asset_bus_breed drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.ref_asset_bus_breed add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.ref_asset_bus_breed (
    etl_dt  -- 数据日期
    ,asset_bus_breed_id  -- 资产业务品种编号
    ,sort_id  -- 排序编号
    ,asset_bus_breed_name  -- 资产业务品种名称
    ,type_sort_id  -- 类型排序编号
    ,sub_type  -- 子类型
    ,attr1  -- 属性1
    ,attr2  -- 属性2
    ,attr3  -- 属性3
    ,attr4  -- 属性4
    ,attr5  -- 属性5
    ,attr6  -- 属性6
    ,attr7  -- 属性7
    ,attr8  -- 属性8
    ,attr9  -- 属性9
    ,attr10  -- 属性10
    ,attr11  -- 属性11
    ,asset_thd_cls_cd  -- 资产三分类代码
    ,attr13  -- 属性13
    ,attr14  -- 属性14
    ,attr15  -- 属性15
    ,attr16  -- 属性16
    ,attr17  -- 属性17
    ,attr18  -- 属性18
    ,attr19  -- 属性19
    ,attr20  -- 属性20
    ,attr21  -- 属性21
    ,attr22  -- 属性22
    ,attr23  -- 属性23
    ,attr24  -- 属性24
    ,attr25  -- 属性25
    ,use_flg  -- 使用标志
    ,loan_size_ctrl_flg  -- 贷款规模控制标志
    ,prod_catlg_id  -- 产品目录编号
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.asset_bus_breed_id,chr(13),''),chr(10),'')  -- 资产业务品种编号
    ,replace(replace(t1.sort_id,chr(13),''),chr(10),'')  -- 排序编号
    ,replace(replace(t1.asset_bus_breed_name,chr(13),''),chr(10),'')  -- 资产业务品种名称
    ,replace(replace(t1.type_sort_id,chr(13),''),chr(10),'')  -- 类型排序编号
    ,replace(replace(t1.sub_type,chr(13),''),chr(10),'')  -- 子类型
    ,replace(replace(t1.attr1,chr(13),''),chr(10),'')  -- 属性1
    ,replace(replace(t1.attr2,chr(13),''),chr(10),'')  -- 属性2
    ,replace(replace(t1.attr3,chr(13),''),chr(10),'')  -- 属性3
    ,replace(replace(t1.attr4,chr(13),''),chr(10),'')  -- 属性4
    ,replace(replace(t1.attr5,chr(13),''),chr(10),'')  -- 属性5
    ,replace(replace(t1.attr6,chr(13),''),chr(10),'')  -- 属性6
    ,replace(replace(t1.attr7,chr(13),''),chr(10),'')  -- 属性7
    ,replace(replace(t1.attr8,chr(13),''),chr(10),'')  -- 属性8
    ,replace(replace(t1.attr9,chr(13),''),chr(10),'')  -- 属性9
    ,replace(replace(t1.attr10,chr(13),''),chr(10),'')  -- 属性10
    ,replace(replace(t1.attr11,chr(13),''),chr(10),'')  -- 属性11
    ,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'')  -- 资产三分类代码
    ,replace(replace(t1.attr13,chr(13),''),chr(10),'')  -- 属性13
    ,replace(replace(t1.attr14,chr(13),''),chr(10),'')  -- 属性14
    ,replace(replace(t1.attr15,chr(13),''),chr(10),'')  -- 属性15
    ,replace(replace(t1.attr16,chr(13),''),chr(10),'')  -- 属性16
    ,replace(replace(t1.attr17,chr(13),''),chr(10),'')  -- 属性17
    ,replace(replace(t1.attr18,chr(13),''),chr(10),'')  -- 属性18
    ,replace(replace(t1.attr19,chr(13),''),chr(10),'')  -- 属性19
    ,replace(replace(t1.attr20,chr(13),''),chr(10),'')  -- 属性20
    ,replace(replace(t1.attr21,chr(13),''),chr(10),'')  -- 属性21
    ,replace(replace(t1.attr22,chr(13),''),chr(10),'')  -- 属性22
    ,replace(replace(t1.attr23,chr(13),''),chr(10),'')  -- 属性23
    ,replace(replace(t1.attr24,chr(13),''),chr(10),'')  -- 属性24
    ,replace(replace(t1.attr25,chr(13),''),chr(10),'')  -- 属性25
    ,replace(replace(t1.use_flg,chr(13),''),chr(10),'')  -- 使用标志
    ,replace(replace(t1.loan_size_ctrl_flg,chr(13),''),chr(10),'')  -- 贷款规模控制标志
    ,replace(replace(t1.prod_catlg_id,chr(13),''),chr(10),'')  -- 产品目录编号
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码
from ${iml_schema}.ref_asset_bus_breed t1    --资产业务品种表
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'ref_asset_bus_breed',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);