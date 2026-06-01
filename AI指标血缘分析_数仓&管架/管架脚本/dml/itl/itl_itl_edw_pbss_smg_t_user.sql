/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pbss_smg_t_user
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
alter table ${itl_schema}.itl_edw_pbss_smg_t_user drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pbss_smg_t_user drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pbss_smg_t_user add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pbss_smg_t_user partition for (to_date('${batch_date}','yyyymmdd')) (
    id -- 逻辑主键
    ,user_code -- 用户代码
    ,user_hxyh_code -- HXYH用户代码
    ,user_name -- 用户名称
    ,br_code -- 机构代码
    ,user_pass -- 用户密码
    ,encrypt_para -- 加密参数
    ,identity_no -- 身份证号
    ,sso_user_name -- 统一用户名
    ,notes_mail -- Notes邮箱
    ,email -- 用户外部邮箱
    ,telephone1 -- 电话号码1
    ,telephone2 -- 电话号码2
    ,address1 -- 联系地址1
    ,address2 -- 联系地址2
    ,user_stat -- 用户状态, 0  禁用 ， 1启用
    ,login_stat -- 登录状态[代码1006][0-签退1-签到]
    ,create_time -- 创建日期
    ,creator_id -- 创建者ID
    ,del_time -- 删除日期
    ,dele_id -- 删除者ID
    ,modify_time -- 维护时间
    ,modi_id -- 维护者ID
    ,last_pass_time -- 上次密码修改日期
    ,auth_method -- 用户认证方式[代码0117][1-指纹认证2-密码认证3-特殊人群认证]
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(id), ' ') as id -- 逻辑主键
    ,nvl(trim(user_code), ' ') as user_code -- 用户代码
    ,nvl(trim(user_hxyh_code), ' ') as user_hxyh_code -- HXYH用户代码
    ,nvl(trim(user_name), ' ') as user_name -- 用户名称
    ,nvl(trim(br_code), ' ') as br_code -- 机构代码
    ,nvl(trim(user_pass), ' ') as user_pass -- 用户密码
    ,nvl(trim(encrypt_para), ' ') as encrypt_para -- 加密参数
    ,nvl(trim(identity_no), ' ') as identity_no -- 身份证号
    ,nvl(trim(sso_user_name), ' ') as sso_user_name -- 统一用户名
    ,nvl(trim(notes_mail), ' ') as notes_mail -- Notes邮箱
    ,nvl(trim(email), ' ') as email -- 用户外部邮箱
    ,nvl(trim(telephone1), ' ') as telephone1 -- 电话号码1
    ,nvl(trim(telephone2), ' ') as telephone2 -- 电话号码2
    ,nvl(trim(address1), ' ') as address1 -- 联系地址1
    ,nvl(trim(address2), ' ') as address2 -- 联系地址2
    ,nvl(trim(user_stat), ' ') as user_stat -- 用户状态, 0  禁用 ， 1启用
    ,nvl(trim(login_stat), ' ') as login_stat -- 登录状态[代码1006][0-签退1-签到]
    ,nvl(create_time, to_date('00010101', 'yyyymmdd')) as create_time -- 创建日期
    ,nvl(trim(creator_id), ' ') as creator_id -- 创建者ID
    ,nvl(del_time, to_date('00010101', 'yyyymmdd')) as del_time -- 删除日期
    ,nvl(trim(dele_id), ' ') as dele_id -- 删除者ID
    ,nvl(modify_time, to_timestamp('00010101', 'yyyymmdd')) as modify_time -- 维护时间
    ,nvl(trim(modi_id), ' ') as modi_id -- 维护者ID
    ,nvl(last_pass_time, to_date('00010101', 'yyyymmdd')) as last_pass_time -- 上次密码修改日期
    ,nvl(trim(auth_method), ' ') as auth_method -- 用户认证方式[代码0117][1-指纹认证2-密码认证3-特殊人群认证]
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pbss_smg_t_user
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pbss_smg_t_user to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pbss_smg_t_user',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);