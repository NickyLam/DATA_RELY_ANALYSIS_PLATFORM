/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ponl_bk_oper_mgmt_flow_osbsi1
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
drop table ${iml_schema}.evt_ponl_bk_oper_mgmt_flow_osbsi1_tm purge;
alter table ${iml_schema}.evt_ponl_bk_oper_mgmt_flow add partition p_osbsi1 values ('osbsi1')(
        subpartition p_osbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ponl_bk_oper_mgmt_flow modify partition p_osbsi1
    add subpartition p_osbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ponl_bk_oper_mgmt_flow_osbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,tran_tm -- 交易时间
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,return_code -- 返回码
    ,fail_rs -- 失败原因
    ,acct_id -- 账户编号
    ,tran_amt -- 交易金额
    ,curr_cd -- 币种代码
    ,cust_id -- 客户编号
    ,tran_chn_cd -- 交易渠道代码
    ,chn_send_flow_num -- 渠道发送流水号
    ,sorc_sys_flow_num -- 源系统流水号
    ,core_tran_flow_num -- 核心交易流水号
    ,cust_ip -- 客户IP
    ,curr_server_host_name -- 当前服务器主机名
    ,req_src_server_ip -- 请求来源服务器IP
    ,cust_termn_mac_addr -- 客户终端MAC地址
    ,cust_termn_oper_sys -- 客户终端操作系统
    ,cust_termn_brow -- 客户终端浏览器
    ,cust_termn_equip_model -- 客户终端设备型号
    ,cust_termn_equip_id -- 客户终端设备ID
    ,logon_session_id -- 登陆sessionID
    ,rela_flow_num -- 关联流水号
    ,tran_jnl_info -- 交易日志信息
    ,tran_type_code -- 交易类型码
    ,cust_name -- 客户名称
    ,save_cert_way_cd -- 安全认证方式代码
    ,func_menu_id -- 功能菜单编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ponl_bk_oper_mgmt_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- osbs_ops_pub_trade_flow-
insert into ${iml_schema}.evt_ponl_bk_oper_mgmt_flow_osbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,tran_tm -- 交易时间
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,return_code -- 返回码
    ,fail_rs -- 失败原因
    ,acct_id -- 账户编号
    ,tran_amt -- 交易金额
    ,curr_cd -- 币种代码
    ,cust_id -- 客户编号
    ,tran_chn_cd -- 交易渠道代码
    ,chn_send_flow_num -- 渠道发送流水号
    ,sorc_sys_flow_num -- 源系统流水号
    ,core_tran_flow_num -- 核心交易流水号
    ,cust_ip -- 客户IP
    ,curr_server_host_name -- 当前服务器主机名
    ,req_src_server_ip -- 请求来源服务器IP
    ,cust_termn_mac_addr -- 客户终端MAC地址
    ,cust_termn_oper_sys -- 客户终端操作系统
    ,cust_termn_brow -- 客户终端浏览器
    ,cust_termn_equip_model -- 客户终端设备型号
    ,cust_termn_equip_id -- 客户终端设备ID
    ,logon_session_id -- 登陆sessionID
    ,rela_flow_num -- 关联流水号
    ,tran_jnl_info -- 交易日志信息
    ,tran_type_code -- 交易类型码
    ,cust_name -- 客户名称
    ,save_cert_way_cd -- 安全认证方式代码
    ,func_menu_id -- 功能菜单编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102066'||P1.PTF_TRADE_FLOWNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.PTF_TRADE_FLOWNO -- 流水号
    ,${iml_schema}.timeformat_max(substr(P1.PTF_TRANSTIME,1,14)||'.'||substr(P1.PTF_TRANSTIME,15,3)) -- 交易时间
    ,P1.PTF_TRANSCODE -- 交易码
    ,P1.PTF_STATE -- 交易状态代码
    ,P1.PTF_RETURNCODE -- 返回码
    ,P1.PTF_RETURNMSG -- 失败原因
    ,P1.PTF_ACCNO -- 账户编号
    ,P1.PTF_AMONUT -- 交易金额
    ,nvl(trim(P1.PTF_CURRENCY),' ') -- 币种代码
    ,P1.PTF_ECIFNO -- 客户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PTF_CHANNEL END -- 交易渠道代码
    ,P1.PTF_SENDFLOWNO -- 渠道发送流水号
    ,P1.PTF_SRC_SENDFLOWNO -- 源系统流水号
    ,P1.PTF_HOSTFLOWNO -- 核心交易流水号
    ,P1.PTF_CUSTOMERIP -- 客户IP
    ,P1.PTF_HOSTNAME -- 当前服务器主机名
    ,P1.PTF_SRC_SERVERIP -- 请求来源服务器IP
    ,P1.PTF_CLIENTMAC -- 客户终端MAC地址
    ,P1.PTF_CLIENTOS -- 客户终端操作系统
    ,P1.PTF_CLIENTBROWSER -- 客户终端浏览器
    ,P1.PTF_CLIENTNUNITTYPE -- 客户终端设备型号
    ,P1.PTF_CLIENTTERMINATENO -- 客户终端设备ID
    ,P1.PTF_SESSIONID -- 登陆sessionID
    ,P1.PTF_RELFLOWNO -- 关联流水号
    ,P1.PTF_TRADE_INF -- 交易日志信息
    ,P1.PTF_TRANSTYPE -- 交易类型码
    ,P1.PTF_ECIFNAME -- 客户名称
    ,nvl(trim(P1.PTF_SECURITYTYPE),'-') -- 安全认证方式代码
    ,P1.PTF_MENUID -- 功能菜单编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'osbs_ops_pub_trade_flow' -- 源表名称
    ,'osbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.osbs_ops_pub_trade_flow p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PTF_CHANNEL = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'OSBS'
        AND R1.SRC_TAB_EN_NAME= 'OSBS_OPS_PUB_TRADE_FLOW'
        AND R1.SRC_FIELD_EN_NAME= 'PTF_CHANNEL'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_PONL_BK_OPER_MGMT_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_CHN_CD'
where  1 = 1 
    and SUBSTR(P1.ptf_transtime,1,8) = '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_ponl_bk_oper_mgmt_flow truncate subpartition p_osbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_ponl_bk_oper_mgmt_flow exchange subpartition p_osbsi1_${batch_date} with table ${iml_schema}.evt_ponl_bk_oper_mgmt_flow_osbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ponl_bk_oper_mgmt_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_ponl_bk_oper_mgmt_flow_osbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ponl_bk_oper_mgmt_flow', partname => 'p_osbsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);