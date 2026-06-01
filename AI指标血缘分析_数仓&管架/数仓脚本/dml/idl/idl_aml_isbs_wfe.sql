/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_isbs_wfe
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
alter table ${idl_schema}.aml_isbs_wfe drop partition p_${last_date};
alter table ${idl_schema}.aml_isbs_wfe drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_isbs_wfe add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_isbs_wfe partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,wfsinr  -- WFS ID
    ,wfssub  -- WFS记录内子ID
    ,srv  -- 服务名
    ,sta  -- 状态
    ,rtycnt  -- 重试次数
    ,tardattim  -- 计划完成时间
    ,ssninr  -- 最近操作SSN ID
    ,dattim  -- 最近操作时间
    ,txt  -- 操作事件描述
    ,manflg  -- 是否手工干预
    ,opndur  -- Open状态持续时间
    ,waidur  -- Waiting状态持续时间
    ,retdur  -- Retry状态持续时间
    ,hdldur  -- 处理时间
    ,bchkeyinr  -- 经办机构号
    ,txt2  -- 冲证描述
    ,itfinr  -- 接口流水号
    ,coreinr  -- 
    ,czinr  -- 
    ,itfdate  -- 
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.wfsinr,chr(13),''),chr(10),'')  -- WFS ID
    ,replace(replace(t1.wfssub,chr(13),''),chr(10),'')  -- WFS记录内子ID
    ,replace(replace(t1.srv,chr(13),''),chr(10),'')  -- 服务名
    ,replace(replace(t1.sta,chr(13),''),chr(10),'')  -- 状态
    ,t1.rtycnt  -- 重试次数
    ,t1.tardattim  -- 计划完成时间
    ,replace(replace(t1.ssninr,chr(13),''),chr(10),'')  -- 最近操作SSN ID
    ,t1.dattim  -- 最近操作时间
    ,replace(replace(t1.txt,chr(13),''),chr(10),'')  -- 操作事件描述
    ,replace(replace(t1.manflg,chr(13),''),chr(10),'')  -- 是否手工干预
    ,t1.opndur  -- Open状态持续时间
    ,t1.waidur  -- Waiting状态持续时间
    ,t1.retdur  -- Retry状态持续时间
    ,t1.hdldur  -- 处理时间
    ,replace(replace(t1.bchkeyinr,chr(13),''),chr(10),'')  -- 经办机构号
    ,replace(replace(t1.txt2,chr(13),''),chr(10),'')  -- 冲证描述
    ,replace(replace(t1.itfinr,chr(13),''),chr(10),'')  -- 接口流水号
    ,replace(replace(t1.coreinr,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.czinr,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.itfdate,chr(13),''),chr(10),'')  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.isbs_wfe t1    --工作流记录
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_isbs_wfe',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);