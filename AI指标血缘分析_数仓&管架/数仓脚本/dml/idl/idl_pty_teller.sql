/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_pty_teller
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
--alter table ${idl_schema}.pty_teller drop partition p_${last_date};
alter table ${idl_schema}.pty_teller drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.pty_teller add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.pty_teller (
    etl_dt  -- 数据日期
    ,emply_id  -- 员工编号
    ,party_id  -- 当事人编号
    ,lp_id  -- 法人编号
    ,belong_org_id  -- 所属机构编号
    ,teller_id  -- 柜员编号
    ,belong_dept_id  -- 归属部门编号
    ,teller_status_cd  -- 柜员状态代码
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码

)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.emply_id,chr(13),''),chr(10),'')  -- 员工编号
    ,replace(replace(t1.party_id,chr(13),''),chr(10),'')  -- 当事人编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'')  -- 所属机构编号
    ,replace(replace(t1.teller_id,chr(13),''),chr(10),'')  -- 柜员编号
    ,replace(replace(t1.belong_dept_id,chr(13),''),chr(10),'')  -- 归属部门编号
    ,replace(replace(t1.teller_status_cd,chr(13),''),chr(10),'')  -- 柜员状态代码
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码

from ${iml_schema}.pty_teller t1    --柜员
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'pty_teller',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);