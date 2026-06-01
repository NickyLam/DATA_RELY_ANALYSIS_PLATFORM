/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ponl_bk_cust_login_flow_osbsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_ponl_bk_cust_login_flow_osbsi1_tm purge;
alter table ${iml_schema}.evt_ponl_bk_cust_login_flow add partition p_osbsi1 values ('osbsi1')(
        subpartition p_osbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ponl_bk_cust_login_flow modify partition p_osbsi1
    add subpartition p_osbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ponl_bk_cust_login_flow_osbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,login_flow_num -- 登录流水号
    ,cust_id -- 客户编号
    ,oper_type_cd -- 操作类型代码
    ,login_rest_cd -- 登录结果代码
    ,login_rest_descb -- 登录结果描述
    ,login_user_name -- 登录用户名称
    ,login_tm -- 登录时间
    ,chn_cd -- 渠道代码
    ,login_equip_num -- 登录设备号
    ,cust_ip -- 客户IP
    ,login_user_id -- 登录用户编号
    ,login_type_cd -- 登录类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ponl_bk_cust_login_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- osbs_pbs_logon_flow-
insert into ${iml_schema}.evt_ponl_bk_cust_login_flow_osbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,login_flow_num -- 登录流水号
    ,cust_id -- 客户编号
    ,oper_type_cd -- 操作类型代码
    ,login_rest_cd -- 登录结果代码
    ,login_rest_descb -- 登录结果描述
    ,login_user_name -- 登录用户名称
    ,login_tm -- 登录时间
    ,chn_cd -- 渠道代码
    ,login_equip_num -- 登录设备号
    ,cust_ip -- 客户IP
    ,login_user_id -- 登录用户编号
    ,login_type_cd -- 登录类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102064'||P1.PLF_FLOWNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.PLF_FLOWNO -- 登录流水号
    ,P1.PLF_ECIFNO -- 客户编号
    ,nvl(trim(P1.PLF_OPERATIONTYPE),'-') -- 操作类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.PLF_RESULT END -- 登录结果代码
    ,P1.PLF_RESULTMSG -- 登录结果描述
    ,P1.PLF_LOGINID -- 登录用户名称
    ,${iml_schema}.dateformat_min(P1.PLF_LOGONDATE) -- 登录时间
    ,nvl(trim(P1.PLF_CHANNEL),'-') -- 渠道代码
    ,P1.PLF_DEVICENO -- 登录设备号
    ,P1.PLF_CUSTOMERIP -- 客户IP
    ,P1.PLF_USERID -- 登录用户编号
    ,nvl(trim(P1.PLF_LOGINTYPE),'-') -- 登录类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'osbs_pbs_logon_flow' -- 源表名称
    ,'osbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.osbs_pbs_logon_flow p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.PLF_RESULT = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'OSBS'
        AND R2.SRC_TAB_EN_NAME= 'OSBS_PBS_LOGON_FLOW'
        AND R2.SRC_FIELD_EN_NAME= 'PLF_RESULT'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_PONL_BK_CUST_LOGIN_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'LOGIN_REST_CD'
where  1 = 1 
    and SUBSTR(P1.PLF_LOGONDATE,1,8) = '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_ponl_bk_cust_login_flow truncate subpartition p_osbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_ponl_bk_cust_login_flow exchange subpartition p_osbsi1_${batch_date} with table ${iml_schema}.evt_ponl_bk_cust_login_flow_osbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ponl_bk_cust_login_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_ponl_bk_cust_login_flow_osbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ponl_bk_cust_login_flow', partname => 'p_osbsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);