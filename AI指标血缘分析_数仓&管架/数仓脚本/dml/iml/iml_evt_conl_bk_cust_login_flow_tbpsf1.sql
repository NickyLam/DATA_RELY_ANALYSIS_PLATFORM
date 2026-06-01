/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_conl_bk_cust_login_flow_tbpsf1
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
drop table ${iml_schema}.evt_conl_bk_cust_login_flow_tbpsf1_tm purge;
alter table ${iml_schema}.evt_conl_bk_cust_login_flow add partition p_tbpsf1 values ('tbpsf1')(
        subpartition p_tbpsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_conl_bk_cust_login_flow modify partition p_tbpsf1
    add subpartition p_tbpsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_conl_bk_cust_login_flow_tbpsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,visit_flow_num -- 访问流水号
    ,user_seq_num -- 用户顺序号
    ,cust_id -- 交易客户编号
    ,login_status_cd -- 登录状态代码
    ,login_dt -- 登录日期
    ,login_tm -- 登录时间
    ,cust_ip -- 客户IP
    ,chn_cd -- 渠道代码
    ,login_way_cd -- 登录方式代码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,server_ip -- 服务器IP
    ,ova_flow_num -- 全局流水号
    ,cust_termn_mac_addr -- 客户终端MAC地址
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_conl_bk_cust_login_flow
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- tbps_cpr_login_flow-1
insert into ${iml_schema}.evt_conl_bk_cust_login_flow_tbpsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,visit_flow_num -- 访问流水号
    ,user_seq_num -- 用户顺序号
    ,cust_id -- 交易客户编号
    ,login_status_cd -- 登录状态代码
    ,login_dt -- 登录日期
    ,login_tm -- 登录时间
    ,cust_ip -- 客户IP
    ,chn_cd -- 渠道代码
    ,login_way_cd -- 登录方式代码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,server_ip -- 服务器IP
    ,ova_flow_num -- 全局流水号
    ,cust_termn_mac_addr -- 客户终端MAC地址
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102079'||P1.CLF_LOGNO||P1.CLF_STATE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.CLF_LOGNO -- 访问流水号
    ,P1.CLF_USERNO -- 用户顺序号
    ,P1.CLF_ECIFNO -- 交易客户编号
    ,nvl(trim(P1.CLF_STATE),'-') -- 登录状态代码
    ,${iml_schema}.dateformat_max2(P1.CLF_DATE) -- 登录日期
    ,${iml_schema}.timeformat_max2(substr(P1.CLF_DATE, 1, 4) || '-' ||
                      substr(P1.CLF_DATE, 5, 2) || '-' ||
                      substr(P1.CLF_DATE, 7, 2) || ' ' ||
                      substr(P1.CLF_TIME, 1, 2) || ':' ||
                      substr(P1.CLF_TIME, 3, 2) || ':' ||
                      substr(P1.CLF_TIME, 5, 2)) -- 登录时间
    ,P1.CLF_CUSTOMERIP -- 客户IP
    ,nvl(trim(P1.CLF_CHANNEL),'-') -- 渠道代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CLF_LOGINTYPE END -- 登录方式代码
    ,P1.CLF_RETURNCODE -- 返回码
    ,P1.CLF_RETURNMSG -- 返回信息
    ,P1.CLF_HOSTIP -- 服务器IP
    ,P1.CLF_GLOBALFLOW -- 全局流水号
    ,P1.CLF_CLIENTMAC -- 客户终端MAC地址
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tbps_cpr_login_flow' -- 源表名称
    ,'tbpsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tbps_cpr_login_flow p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLF_CHANNEL = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'TBPS'
        AND R1.SRC_TAB_EN_NAME= 'TBPS_CPR_LOGIN_FLOW'
        AND R1.SRC_FIELD_EN_NAME= 'CLF_CHANNEL'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_CONL_BK_CUST_LOGIN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CHN_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CLF_LOGINTYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'TBPS'
        AND R2.SRC_TAB_EN_NAME= 'TBPS_CPR_LOGIN_FLOW'
        AND R2.SRC_FIELD_EN_NAME= 'CLF_LOGINTYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_CONL_BK_CUST_LOGIN_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'LOGIN_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_conl_bk_cust_login_flow truncate partition p_tbpsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_conl_bk_cust_login_flow exchange subpartition p_tbpsf1_${batch_date} with table ${iml_schema}.evt_conl_bk_cust_login_flow_tbpsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_conl_bk_cust_login_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_conl_bk_cust_login_flow_tbpsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_conl_bk_cust_login_flow', partname => 'p_tbpsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);