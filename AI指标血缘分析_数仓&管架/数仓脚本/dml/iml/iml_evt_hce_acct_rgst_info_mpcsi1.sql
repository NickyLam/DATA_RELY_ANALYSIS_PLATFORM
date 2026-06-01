/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_hce_acct_rgst_info_mpcsi1
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
drop table ${iml_schema}.evt_hce_acct_rgst_info_mpcsi1_tm purge;
alter table ${iml_schema}.evt_hce_acct_rgst_info add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_hce_acct_rgst_info modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_hce_acct_rgst_info_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,oper_tm -- 操作时间
    ,cust_id -- 客户编号
    ,user_id -- 用户编号
    ,user_name -- 用户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,main_acct_id -- 主账户编号
    ,appl_dt -- 申请日期
    ,actv_dt -- 激活日期
    ,cld_card_id -- 云卡编号
    ,cld_card_invalid_dt -- 云卡失效日期
    ,cld_card_status_cd -- 云卡状态代码
    ,status_update_tm -- 状态更新时间
    ,main_acct_status_cd -- 主账号状态代码
    ,iss_bank_lock_flg -- 发卡行锁定标志
    ,card_holder_loss_flg -- 持卡人挂失标志
    ,equip_model -- 设备型号
    ,move_app_name -- 移动应用名称
    ,beps_unpasew_flg -- 小额免密标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_hce_acct_rgst_info
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a85applyinfotype-1
insert into ${iml_schema}.evt_hce_acct_rgst_info_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,oper_tm -- 操作时间
    ,cust_id -- 客户编号
    ,user_id -- 用户编号
    ,user_name -- 用户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,main_acct_id -- 主账户编号
    ,appl_dt -- 申请日期
    ,actv_dt -- 激活日期
    ,cld_card_id -- 云卡编号
    ,cld_card_invalid_dt -- 云卡失效日期
    ,cld_card_status_cd -- 云卡状态代码
    ,status_update_tm -- 状态更新时间
    ,main_acct_status_cd -- 主账号状态代码
    ,iss_bank_lock_flg -- 发卡行锁定标志
    ,card_holder_loss_flg -- 持卡人挂失标志
    ,equip_model -- 设备型号
    ,move_app_name -- 移动应用名称
    ,beps_unpasew_flg -- 小额免密标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104044'||P1.PAN -- 事件编号
    ,'9999' -- 法人编号
    ,${iml_schema}.TIMEFORMAT_MAX(P1.TRANSTIME) -- 操作时间
    ,P1.CUSTNO -- 客户编号
    ,P1.USERID -- 用户编号
    ,P1.USERNAME -- 用户名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.IDTYPE END -- 证件类型代码
    ,P1.IDVALUE -- 证件号码
    ,P1.MSISDN -- 手机号码
    ,P1.PAN -- 主账户编号
    ,${iml_schema}.DATEFORMAT_MAX(substr(P1.APPLYDATE,1,10)) -- 申请日期
    ,${iml_schema}.DATEFORMAT_MAX(substr(P1.ACTIVATEDATE,1,10)) -- 激活日期
    ,P1.TOKENPAN -- 云卡编号
    ,${iml_schema}.DATEFORMAT_MAX(substr(P1.EXPIREDATE,1,10)) -- 云卡失效日期
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.STATUS END -- 云卡状态代码
    ,${iml_schema}.TIMEFORMAT_MAX(P1.STATUSTIME) -- 状态更新时间
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.PANSTATUS END -- 主账号状态代码
    ,CASE WHEN P1.LOCKED='ture' THEN '1' ELSE '0' END -- 发卡行锁定标志
    ,CASE WHEN P1.LOST='ture' THEN '1' ELSE '0' END -- 持卡人挂失标志
    ,P1.DEVICEMODEL -- 设备型号
    ,P1.WALLETNAME -- 移动应用名称
    ,CASE WHEN P1.IFPWD='0' THEN '1' ELSE '0' END -- 小额免密标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a85applyinfotype' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a85applyinfotype p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.IDTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A85APPLYINFOTYPE'
        AND R1.SRC_FIELD_EN_NAME= 'IDTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_HCE_ACCT_RGST_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CERT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.STATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A85APPLYINFOTYPE'
        AND R2.SRC_FIELD_EN_NAME= 'STATUS'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_HCE_ACCT_RGST_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CLD_CARD_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.PANSTATUS = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A85APPLYINFOTYPE'
        AND R3.SRC_FIELD_EN_NAME= 'PANSTATUS'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_HCE_ACCT_RGST_INFO'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'MAIN_ACCT_STATUS_CD'
where  1 = 1 
    and substr(transtime,1,8)='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_hce_acct_rgst_info truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_hce_acct_rgst_info exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_hce_acct_rgst_info_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_hce_acct_rgst_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_hce_acct_rgst_info_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_hce_acct_rgst_info', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);