/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_cmm_teller_info
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
alter table ${itl_schema}.itl_edw_cmm_teller_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_cmm_teller_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_cmm_teller_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_cmm_teller_info partition for (to_date('${batch_date}','yyyymmdd')) (
    lp_id -- 法人编号
    ,teller_id -- 柜员编号
    ,cors_moy_box_id -- 对应钱箱编号
    ,teller_name -- 柜员名称
    ,teller_type_cd -- 柜员类型代码
    ,teller_status_cd -- 柜员状态代码
    ,teller_user_lev_cd -- 柜员用户级别代码
    ,teller_prvlg_lev_cd -- 柜员权限级别代码
    ,belong_org_id -- 所属机构编号
    ,jobs_cd -- 岗位代码
    ,jobs_cate -- 岗位类别
    ,jobs_name -- 岗位名称
    ,empyt_dt -- 入职日期
    ,cust_mgr_flg -- 客户经理标志
    ,enty_teller_flg -- 实体柜员标志
    ,syn_teller_flg -- 综合柜员标志
    ,super_teller_flg -- 超级柜员标志
    ,acct_teller_flg -- 账务柜员标志
    ,prvlg_mgmt_flg -- 权限管理标志
    ,director_mgmt_flg -- 主管管理标志
    ,crdt_cust_mgr_flg -- 信贷客户经理标志
    ,wah_kepr_flg -- 库管员标志
    ,auth_flg -- 授权标志
    ,auth_range -- 授权范围
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(trim(teller_id), ' ') as teller_id -- 柜员编号
    ,nvl(trim(cors_moy_box_id), ' ') as cors_moy_box_id -- 对应钱箱编号
    ,nvl(trim(teller_name), ' ') as teller_name -- 柜员名称
    ,nvl(trim(teller_type_cd), ' ') as teller_type_cd -- 柜员类型代码
    ,nvl(trim(teller_status_cd), ' ') as teller_status_cd -- 柜员状态代码
    ,nvl(trim(teller_user_lev_cd), ' ') as teller_user_lev_cd -- 柜员用户级别代码
    ,nvl(trim(teller_prvlg_lev_cd), ' ') as teller_prvlg_lev_cd -- 柜员权限级别代码
    ,nvl(trim(belong_org_id), ' ') as belong_org_id -- 所属机构编号
    ,nvl(trim(jobs_cd), ' ') as jobs_cd -- 岗位代码
    ,nvl(trim(jobs_cate), ' ') as jobs_cate -- 岗位类别
    ,nvl(trim(jobs_name), ' ') as jobs_name -- 岗位名称
    ,nvl(empyt_dt, to_date('00010101', 'yyyymmdd')) as empyt_dt -- 入职日期
    ,nvl(trim(cust_mgr_flg), ' ') as cust_mgr_flg -- 客户经理标志
    ,nvl(trim(enty_teller_flg), ' ') as enty_teller_flg -- 实体柜员标志
    ,nvl(trim(syn_teller_flg), ' ') as syn_teller_flg -- 综合柜员标志
    ,nvl(trim(super_teller_flg), ' ') as super_teller_flg -- 超级柜员标志
    ,nvl(trim(acct_teller_flg), ' ') as acct_teller_flg -- 账务柜员标志
    ,nvl(trim(prvlg_mgmt_flg), ' ') as prvlg_mgmt_flg -- 权限管理标志
    ,nvl(trim(director_mgmt_flg), ' ') as director_mgmt_flg -- 主管管理标志
    ,nvl(trim(crdt_cust_mgr_flg), ' ') as crdt_cust_mgr_flg -- 信贷客户经理标志
    ,nvl(trim(wah_kepr_flg), ' ') as wah_kepr_flg -- 库管员标志
    ,nvl(trim(auth_flg), ' ') as auth_flg -- 授权标志
    ,nvl(trim(auth_range), ' ') as auth_range -- 授权范围
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_cmm_teller_info
where etl_dt = to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_cmm_teller_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_cmm_teller_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);