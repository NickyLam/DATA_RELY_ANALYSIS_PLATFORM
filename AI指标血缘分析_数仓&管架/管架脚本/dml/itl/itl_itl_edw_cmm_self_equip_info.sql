/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_cmm_self_equip_info
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${itl_schema}.itl_edw_cmm_self_equip_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_cmm_self_equip_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_cmm_self_equip_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_cmm_self_equip_info partition for (to_date('${batch_date}','yyyymmdd')) (
    lp_id -- 法人编号
    ,equip_id -- 设备编号
    ,equip_ip_addr_id -- 设备IP地址编号
    ,belong_org_id -- 所属机构编号
    ,in_bank_flg -- 在行标志
    ,self_equip_model -- 自助设备型号
    ,self_equip_type_cd -- 自助设备类型代码
    ,equip_type_name -- 设备类型名称
    ,equip_type_name_cn_descb -- 设备类型名称中文描述
    ,equip_status_cd -- 设备状态代码
    ,equip_matnce_id -- 设备维护商编号
    ,equip_install_dt -- 设备安装日期
    ,cash_flg -- 现金标志
    ,install_way_cd -- 安装方式代码
    ,dist_cd -- 行政区划代码
    ,chn_id -- 渠道编号
    ,equip_install_addr -- 设备安装地址
    ,equip_kind_name -- 设备种类名称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(trim(equip_id), ' ') as equip_id -- 设备编号
    ,nvl(trim(equip_ip_addr_id), ' ') as equip_ip_addr_id -- 设备IP地址编号
    ,nvl(trim(belong_org_id), ' ') as belong_org_id -- 所属机构编号
    ,nvl(trim(in_bank_flg), ' ') as in_bank_flg -- 在行标志
    ,nvl(trim(self_equip_model), ' ') as self_equip_model -- 自助设备型号
    ,nvl(trim(self_equip_type_cd), ' ') as self_equip_type_cd -- 自助设备类型代码
    ,nvl(trim(equip_type_name), ' ') as equip_type_name -- 设备类型名称
    ,nvl(trim(equip_type_name_cn_descb), ' ') as equip_type_name_cn_descb -- 设备类型名称中文描述
    ,nvl(trim(equip_status_cd), ' ') as equip_status_cd -- 设备状态代码
    ,nvl(trim(equip_matnce_id), ' ') as equip_matnce_id -- 设备维护商编号
    ,nvl(equip_install_dt, to_date('00010101', 'yyyymmdd')) as equip_install_dt -- 设备安装日期
    ,nvl(trim(cash_flg), ' ') as cash_flg -- 现金标志
    ,nvl(trim(install_way_cd), ' ') as install_way_cd -- 安装方式代码
    ,nvl(trim(dist_cd), ' ') as dist_cd -- 行政区划代码
    ,nvl(trim(chn_id), ' ') as chn_id -- 渠道编号
    ,nvl(trim(equip_install_addr), ' ') as equip_install_addr -- 设备安装地址
    ,nvl(trim(equip_kind_name), ' ') as equip_kind_name -- 设备种类名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_cmm_self_equip_info
where etl_dt = to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_cmm_self_equip_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_cmm_self_equip_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);