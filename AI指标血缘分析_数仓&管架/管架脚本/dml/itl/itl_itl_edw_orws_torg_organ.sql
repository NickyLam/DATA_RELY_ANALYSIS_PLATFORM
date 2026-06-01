/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_orws_torg_organ
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
alter table ${itl_schema}.itl_edw_orws_torg_organ drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_orws_torg_organ drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_orws_torg_organ add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_orws_torg_organ partition for (to_date('${batch_date}','yyyymmdd')) (
    organid -- 
    ,ownerorganid -- 
    ,organcode -- 
    ,organnum -- 
    ,organname -- 
    ,invoicename -- 
    ,shortname -- 
    ,organtype -- 
    ,isbuildaccunt -- 
    ,address -- 
    ,builddate -- 
    ,invaliddate -- 
    ,corporation -- 
    ,master -- 
    ,postcode -- 
    ,linkphone -- 
    ,fax -- 
    ,email -- 
    ,taxno -- 
    ,personnelnum -- 
    ,isused -- 
    ,remark -- 
    ,ext1 -- 
    ,ext2 -- 
    ,ext3 -- 
    ,officedate -- 
    ,managermaster -- 
    ,mofficedate -- 
    ,status -- 
    ,source_type -- 
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(organid), 0) as organid -- 
    ,nvl(trim(ownerorganid), 0) as ownerorganid -- 
    ,nvl(trim(organcode), ' ') as organcode -- 
    ,nvl(trim(organnum), ' ') as organnum -- 
    ,nvl(trim(organname), ' ') as organname -- 
    ,nvl(trim(invoicename), ' ') as invoicename -- 
    ,nvl(trim(shortname), ' ') as shortname -- 
    ,nvl(trim(organtype), 0) as organtype -- 
    ,nvl(trim(isbuildaccunt), 0) as isbuildaccunt -- 
    ,nvl(trim(address), ' ') as address -- 
    ,nvl(builddate, to_timestamp('00010101', 'yyyymmdd')) as builddate -- 
    ,nvl(invaliddate, to_timestamp('00010101', 'yyyymmdd')) as invaliddate -- 
    ,nvl(trim(corporation), ' ') as corporation -- 
    ,nvl(trim(master), ' ') as master -- 
    ,nvl(trim(postcode), ' ') as postcode -- 
    ,nvl(trim(linkphone), ' ') as linkphone -- 
    ,nvl(trim(fax), ' ') as fax -- 
    ,nvl(trim(email), ' ') as email -- 
    ,nvl(trim(taxno), ' ') as taxno -- 
    ,nvl(trim(personnelnum), 0) as personnelnum -- 
    ,nvl(trim(isused), 0) as isused -- 
    ,nvl(trim(remark), ' ') as remark -- 
    ,nvl(trim(ext1), ' ') as ext1 -- 
    ,nvl(trim(ext2), ' ') as ext2 -- 
    ,nvl(trim(ext3), ' ') as ext3 -- 
    ,nvl(officedate, to_timestamp('00010101', 'yyyymmdd')) as officedate -- 
    ,nvl(trim(managermaster), ' ') as managermaster -- 
    ,nvl(mofficedate, to_timestamp('00010101', 'yyyymmdd')) as mofficedate -- 
    ,nvl(trim(status), 0) as status -- 
    ,nvl(trim(source_type), ' ') as source_type -- 
    ,nvl(start_dt, to_date('00010101', 'yyyymmdd')) as start_dt -- 开始时间
    ,nvl(end_dt, to_date('00010101', 'yyyymmdd')) as end_dt -- 结束时间
    ,nvl(trim(id_mark), ' ') as id_mark -- 增删标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_orws_torg_organ
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_orws_torg_organ to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_orws_torg_organ',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);