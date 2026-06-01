/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_intellge_brac_comm_flow_nibsi1
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
drop table ${iml_schema}.evt_intellge_brac_comm_flow_nibsi1_tm purge;
alter table ${iml_schema}.evt_intellge_brac_comm_flow add partition p_nibsi1 values ('nibsi1')(
        subpartition p_nibsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_intellge_brac_comm_flow modify partition p_nibsi1
    add subpartition p_nibsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_intellge_brac_comm_flow_nibsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bus_flow_num -- 业务流水号
    ,plat_flow_num -- 平台流水号
    ,plat_tran_dt -- 平台交易日期
    ,ova_flow_num -- 全局流水号
    ,sorc_sys_id -- 源系统编号
    ,chn_id -- 渠道编号
    ,chn_dt -- 渠道日期
    ,chn_flow_num -- 渠道流水号
    ,back_end_serv_sys_id -- 后台服务系统编号
    ,back_end_serv_sys_intfc_id -- 后台服务系统接口编号
    ,back_end_serv_sys_intfc_name -- 后台服务系统接口名称
    ,back_end_resp_dt -- 后台响应日期
    ,back_end_flow_num -- 后台流水号
    ,back_end_proc_status_cd -- 后台处理状态代码
    ,back_end_process_cd -- 后台处理码
    ,back_end_return_info_desc -- 后台返回信息描述
    ,req_tm -- 请求时间
    ,resp_tm -- 响应时间
    ,menu_id -- 菜单编号
    ,main_comm_flg -- 主通讯标志
    ,cust_type_cd -- 客户类型代码
    ,menu_name -- 菜单名称
    ,cust_id -- 客户编号
    ,core_bus_type_cd -- 核心业务类型代码
    ,acct_id -- 账户编号
    ,acct_num_name -- 账号名称
    ,tran_amt -- 交易金额
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,node_id -- 节点编号
    ,node_name -- 节点名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_intellge_brac_comm_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- nibs_ib_log_comm_log-1
insert into ${iml_schema}.evt_intellge_brac_comm_flow_nibsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bus_flow_num -- 业务流水号
    ,plat_flow_num -- 平台流水号
    ,plat_tran_dt -- 平台交易日期
    ,ova_flow_num -- 全局流水号
    ,sorc_sys_id -- 源系统编号
    ,chn_id -- 渠道编号
    ,chn_dt -- 渠道日期
    ,chn_flow_num -- 渠道流水号
    ,back_end_serv_sys_id -- 后台服务系统编号
    ,back_end_serv_sys_intfc_id -- 后台服务系统接口编号
    ,back_end_serv_sys_intfc_name -- 后台服务系统接口名称
    ,back_end_resp_dt -- 后台响应日期
    ,back_end_flow_num -- 后台流水号
    ,back_end_proc_status_cd -- 后台处理状态代码
    ,back_end_process_cd -- 后台处理码
    ,back_end_return_info_desc -- 后台返回信息描述
    ,req_tm -- 请求时间
    ,resp_tm -- 响应时间
    ,menu_id -- 菜单编号
    ,menu_name --  菜单名称
    ,core_bus_type_cd -- 核心业务类型代码
    ,main_comm_flg --主通讯标志
    ,cust_type_cd -- 客户类型代码
    ,cust_id -- 客户编号    
    ,acct_id -- 账户编号
    ,acct_num_name -- 账号名称
    ,tran_amt -- 交易金额
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,node_id -- 节点编号
    ,node_name -- 节点名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401005'||P1.TX_SEQ_NUM -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TX_SEQ_NUM -- 业务流水号
    ,P1.P_BIZ_SEQ_NUM -- 平台流水号
    ,P1.P_WORKDATE -- 平台交易日期
    ,P1.CORE_TRAN_FLOW_NUM -- 全局流水号
    ,P1.SYS_NUM -- 源系统编号
    ,P1.CHAN_NUM -- 渠道编号
    ,P1.CHANNELDATE -- 渠道日期
    ,P1.CHAN_BIZ_SEQ_NUM -- 渠道流水号
    ,P1.BACKSYSNUM -- 后台服务系统编号
    ,P1.BACKINTERCODE -- 后台服务系统接口编号
    ,P1.BACKINTERCODENM -- 后台服务系统接口名称
    ,P1.BACKRSPDATE -- 后台响应日期
    ,P1.BACKSERIALNUM -- 后台流水号
    ,P1.BACK_RET_STATUS -- 后台处理状态代码
    ,P1.BACK_RET_CODE -- 后台处理码
    ,P1.BACK_RET_DESC -- 后台返回信息描述
    ,P1.REQDATETIME -- 请求时间
    ,P1.RSPDATETIME -- 响应时间
    ,P1.CHANNELTRANCODE -- 菜单编号
    ,P1.CHANNELTRANNAME -- 菜单名称
    ,P1.BIZTYPE-- 核心业务类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.ISMAINCOMM END -- 主通讯标志
    ,nvl(trim(P1.CUST_TYPE_CD),'-') -- 客户类型代码
    ,P1.CUST_NUM -- 客户编号
    ,P1.ACCT_NUM -- 账户编号
    ,P1.ACCT_NAME -- 账号名称
    ,P1.TX_AMT -- 交易金额
    ,P1.TX_CNTPTY_ACCT_NUM -- 交易对手账户编号
    ,P1.TX_CNTPTY_NAME -- 交易对手账户名称
    ,P1.NODECODE -- 节点编号
    ,P1.NODENAME -- 节点名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nibs_ib_log_comm_log' -- 源表名称
    ,'nibsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nibs_ib_log_comm_log p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.ISMAINCOMM= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'NIBS'
        AND R2.SRC_TAB_EN_NAME= 'NIBS_IB_LOG_COMM_LOG'
        AND R2.SRC_FIELD_EN_NAME= 'ISMAINCOMM'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_INTELLGE_BRAC_COMM_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'MAIN_COMM_FLG'
where  1 = 1 
       and P1.P_WORKDATE = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_intellge_brac_comm_flow truncate subpartition p_nibsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_intellge_brac_comm_flow exchange subpartition p_nibsi1_${batch_date} with table ${iml_schema}.evt_intellge_brac_comm_flow_nibsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_intellge_brac_comm_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_intellge_brac_comm_flow_nibsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_intellge_brac_comm_flow', partname => 'p_nibsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);