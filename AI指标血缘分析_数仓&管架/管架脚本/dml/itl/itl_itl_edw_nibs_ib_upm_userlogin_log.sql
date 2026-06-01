/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_nibs_ib_upm_userlogin_log
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
--alter table ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log partition for (to_date('${batch_date}','yyyymmdd')) (
    username -- 用户名称
    ,note3 -- 备注3
    ,datereg -- 登记日期
    ,regtype -- 登记类型:登记类型：0登出1登入
    ,deviceoid -- 设备oid
    ,branchnum -- 机构号
    ,loginstate -- 登录状态:0失败1成功
    ,causefailure -- 失败原因
    ,sessionid -- sessionid
    ,loginip -- 登录ip
    ,usernum -- 用户编号
    ,note4 -- 备注4
    ,note5 -- 备注5
    ,appnum -- 渠道编号
    ,note1 -- 备注1
    ,note2 -- 备注2
    ,hostname -- 主机名
    ,regtime -- 登记时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(username), ' ') as username -- 用户名称
    ,nvl(trim(note3), ' ') as note3 -- 备注3
    ,nvl(trim(datereg), ' ') as datereg -- 登记日期
    ,nvl(trim(regtype), ' ') as regtype -- 登记类型:登记类型：0登出1登入
    ,nvl(trim(deviceoid), ' ') as deviceoid -- 设备oid
    ,nvl(trim(branchnum), ' ') as branchnum -- 机构号
    ,nvl(trim(loginstate), ' ') as loginstate -- 登录状态:0失败1成功
    ,nvl(trim(causefailure), ' ') as causefailure -- 失败原因
    ,nvl(trim(sessionid), ' ') as sessionid -- sessionid
    ,nvl(trim(loginip), ' ') as loginip -- 登录ip
    ,nvl(trim(usernum), ' ') as usernum -- 用户编号
    ,nvl(trim(note4), ' ') as note4 -- 备注4
    ,nvl(trim(note5), ' ') as note5 -- 备注5
    ,nvl(trim(appnum), ' ') as appnum -- 渠道编号
    ,nvl(trim(note1), ' ') as note1 -- 备注1
    ,nvl(trim(note2), ' ') as note2 -- 备注2
    ,nvl(trim(hostname), ' ') as hostname -- 主机名
    ,nvl(trim(regtime), ' ') as regtime -- 登记时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log
where etl_dt=to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_nibs_ib_upm_userlogin_log',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);