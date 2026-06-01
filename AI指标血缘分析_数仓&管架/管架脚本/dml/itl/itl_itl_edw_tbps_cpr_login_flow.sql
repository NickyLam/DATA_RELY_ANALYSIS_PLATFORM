/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_tbps_cpr_login_flow
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
alter table ${itl_schema}.itl_edw_tbps_cpr_login_flow drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_tbps_cpr_login_flow drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_tbps_cpr_login_flow add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_tbps_cpr_login_flow partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,clf_logno  -- 访问流水号
    ,clf_userno  -- 用户顺序号
    ,clf_ecifno  -- 全行统一客户号
    ,clf_state  -- 状态(0：登陆；1：登出；2：超时；3：被强制退出；4：登录失败)
    ,clf_date  -- 日期
    ,clf_time  -- 时间
    ,clf_customerip  -- 客户IP
    ,clf_channel  -- 客户渠道标识(PC)
    ,clf_logintype  -- 登录类型（0：密码登录、1：token登录、2：短信登录、4：证书登录+密码）
    ,clf_returncode  -- 返回码
    ,clf_returnmsg  -- 返回信息
    ,clf_ifp_sid  -- sessionId
    ,clf_hostip  -- 服务IP
    ,clf_wxcode  -- 微信号
    ,clf_useragent  -- 客户浏览器类型
    ,clf_token  -- 跳转登录token
    ,clf_globalflow  -- 全局流水
    ,clf_clientmac  -- 客户MAC地址
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.clf_logno,chr(13),''),chr(10),'')  -- 访问流水号
    ,replace(replace(t1.clf_userno,chr(13),''),chr(10),'')  -- 用户顺序号
    ,replace(replace(t1.clf_ecifno,chr(13),''),chr(10),'')  -- 全行统一客户号
    ,replace(replace(t1.clf_state,chr(13),''),chr(10),'')  -- 状态(0：登陆；1：登出；2：超时；3：被强制退出；4：登录失败)
    ,replace(replace(t1.clf_date,chr(13),''),chr(10),'')  -- 日期
    ,replace(replace(t1.clf_time,chr(13),''),chr(10),'')  -- 时间
    ,replace(replace(t1.clf_customerip,chr(13),''),chr(10),'')  -- 客户IP
    ,replace(replace(t1.clf_channel,chr(13),''),chr(10),'')  -- 客户渠道标识(PC)
    ,replace(replace(t1.clf_logintype,chr(13),''),chr(10),'')  -- 登录类型（0：密码登录、1：token登录、2：短信登录、4：证书登录+密码）
    ,replace(replace(t1.clf_returncode,chr(13),''),chr(10),'')  -- 返回码
    ,replace(replace(t1.clf_returnmsg,chr(13),''),chr(10),'')  -- 返回信息
    ,replace(replace(t1.clf_ifp_sid,chr(13),''),chr(10),'')  -- sessionId
    ,replace(replace(t1.clf_hostip,chr(13),''),chr(10),'')  -- 服务IP
    ,replace(replace(t1.clf_wxcode,chr(13),''),chr(10),'')  -- 微信号
    ,replace(replace(t1.clf_useragent,chr(13),''),chr(10),'')  -- 客户浏览器类型
    ,replace(replace(t1.clf_token,chr(13),''),chr(10),'')  -- 跳转登录token
    ,replace(replace(t1.clf_globalflow,chr(13),''),chr(10),'')  -- 全局流水
    ,replace(replace(t1.clf_clientmac,chr(13),''),chr(10),'')  -- 客户MAC地址
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from iol.v_tbps_cpr_login_flow t1    --登录记录表
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_tbps_cpr_login_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);