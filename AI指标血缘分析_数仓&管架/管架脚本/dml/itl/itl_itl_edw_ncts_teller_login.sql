/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_ncts_teller_login
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
alter table ${itl_schema}.itl_edw_ncts_teller_login drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_ncts_teller_login drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_ncts_teller_login add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_ncts_teller_login partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,login_date  -- 登录日期
    ,login_time  -- 登录时间
    ,login_teller  -- 登录柜员
    ,mac_address  -- mac地址
    ,ip_address  -- ip地址
    ,compu_name  -- 计算机名
    ,login_status  -- 登录状态：0-上线；1-下线
    ,logout_date  -- 下线日期
    ,logout_time  -- 下线时间
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.login_date,chr(13),''),chr(10),'')  -- 登录日期
    ,replace(replace(t1.login_time,chr(13),''),chr(10),'')  -- 登录时间
    ,replace(replace(t1.login_teller,chr(13),''),chr(10),'')  -- 登录柜员
    ,replace(replace(t1.mac_address,chr(13),''),chr(10),'')  -- mac地址
    ,replace(replace(t1.ip_address,chr(13),''),chr(10),'')  -- ip地址
    ,replace(replace(t1.compu_name,chr(13),''),chr(10),'')  -- 计算机名
    ,replace(replace(t1.login_status,chr(13),''),chr(10),'')  -- 登录状态：0-上线；1-下线
    ,replace(replace(t1.logout_date,chr(13),''),chr(10),'')  -- 下线日期
    ,replace(replace(t1.logout_time,chr(13),''),chr(10),'')  -- 下线时间
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from iol.v_ncts_teller_login
 t1    --业务量系统统计表
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_ncts_teller_login',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);