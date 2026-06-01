/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bank_pc_edit_tran_flow_tbpsf1
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
drop table ${iml_schema}.evt_bank_pc_edit_tran_flow_tbpsf1_tm purge;
alter table ${iml_schema}.evt_bank_pc_edit_tran_flow add partition p_tbpsf1 values ('tbpsf1')(
        subpartition p_tbpsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_bank_pc_edit_tran_flow modify partition p_tbpsf1
    add subpartition p_tbpsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bank_pc_edit_tran_flow_tbpsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
    ,tran_code -- 交易码
    ,tran_order -- 交易命令
    ,unify_cust_id -- 统一客户编号
    ,user_seq_num -- 用户顺序号
    ,tran_chn_cd -- 交易渠道代码
    ,cust_name -- 客户姓名
    ,menu_id -- 菜单ID
    ,tran_status_cd -- 交易状态代码
    ,tran_return_code -- 交易返回编码
    ,fail_rs_descb -- 失败原因描述
    ,tran_acct_num -- 交易账号
    ,tran_amt -- 交易金额
    ,curr_cd -- 币种代码
    ,chn_send_flow_id -- 渠道发送流水编号
    ,sorc_sys_flow_id -- 源系统流水编号
    ,core_tran_flow_id -- 核心交易流水编号
    ,comm_fee -- 手续费
    ,parent_flow_id -- 父流水编号
    ,src_flow_seq_id -- 来源流水顺序编号
    ,auth_refuse_rs -- 授权拒绝原因
    ,visit_flow_id -- 访问流水编号
    ,core_tran_dt -- 核心交易日期
    ,callout_tran_code -- 被调方交易码
    ,cust_ip -- 客户IP
    ,curr_server_host_name -- 当前服务器主机名称
    ,req_src_server_ip -- 请求来源服务器IP
    ,cust_termn_mac_addr -- 客户终端MAC地址
    ,cust_termn_oper_sys -- 客户终端操作系统
    ,cust_termn_brow -- 客户终端浏览器
    ,cust_termn_equip_model -- 客户终端设备型号
    ,cust_termn_equip_id -- 客户终端设备ID
    ,session_id -- SESSION_ID
    ,rela_flow_id -- 关联流水编号
    ,save_cert_way_cd -- 安全认证方式代码
    ,auth_status_cd -- 授权状态代码
    ,bank_agent_flg -- 银行代办标志
    ,auth_role_seq_num -- 授权角色序号
    ,submit_core_dt -- 提交核心日期
    ,submit_core_tm -- 提交核心时间
    ,tran_tot_qtty -- 交易总数量
    ,remark -- 备注
    ,bus_flow_num -- 业务流水号
    ,chain_way_track_no -- 链路跟踪号
    ,ups_flow_num -- 上游流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bank_pc_edit_tran_flow
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- tbps_cpr_trade_flow-1
insert into ${iml_schema}.evt_bank_pc_edit_tran_flow_tbpsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
    ,tran_code -- 交易码
    ,tran_order -- 交易命令
    ,unify_cust_id -- 统一客户编号
    ,user_seq_num -- 用户顺序号
    ,tran_chn_cd -- 交易渠道代码
    ,cust_name -- 客户姓名
    ,menu_id -- 菜单ID
    ,tran_status_cd -- 交易状态代码
    ,tran_return_code -- 交易返回编码
    ,fail_rs_descb -- 失败原因描述
    ,tran_acct_num -- 交易账号
    ,tran_amt -- 交易金额
    ,curr_cd -- 币种代码
    ,chn_send_flow_id -- 渠道发送流水编号
    ,sorc_sys_flow_id -- 源系统流水编号
    ,core_tran_flow_id -- 核心交易流水编号
    ,comm_fee -- 手续费
    ,parent_flow_id -- 父流水编号
    ,src_flow_seq_id -- 来源流水顺序编号
    ,auth_refuse_rs -- 授权拒绝原因
    ,visit_flow_id -- 访问流水编号
    ,core_tran_dt -- 核心交易日期
    ,callout_tran_code -- 被调方交易码
    ,cust_ip -- 客户IP
    ,curr_server_host_name -- 当前服务器主机名称
    ,req_src_server_ip -- 请求来源服务器IP
    ,cust_termn_mac_addr -- 客户终端MAC地址
    ,cust_termn_oper_sys -- 客户终端操作系统
    ,cust_termn_brow -- 客户终端浏览器
    ,cust_termn_equip_model -- 客户终端设备型号
    ,cust_termn_equip_id -- 客户终端设备ID
    ,session_id -- SESSION_ID
    ,rela_flow_id -- 关联流水编号
    ,save_cert_way_cd -- 安全认证方式代码
    ,auth_status_cd -- 授权状态代码
    ,bank_agent_flg -- 银行代办标志
    ,auth_role_seq_num -- 授权角色序号
    ,submit_core_dt -- 提交核心日期
    ,submit_core_tm -- 提交核心时间
    ,tran_tot_qtty -- 交易总数量
    ,remark -- 备注
    ,bus_flow_num -- 业务流水号
    ,chain_way_track_no -- 链路跟踪号
    ,ups_flow_num -- 上游流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102049'||P1.CTF_TRADE_FLOWNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.CTF_TRADE_FLOWNO -- 流水号
    ,to_timestamp(substr(P1.CTF_TRANSTIME,1,4)||'-'||substr(P1.CTF_TRANSTIME,5,2)||'-'||substr(P1.CTF_TRANSTIME,7,2)||' '||substr(P1.CTF_TRANSTIME,9,2)||':'||substr(P1.CTF_TRANSTIME,11,2)||':'||
substr(P1.CTF_TRANSTIME,13,2)||'.'||substr(P1.CTF_TRANSTIME,15),'yyyy-mm-dd hh24:mi:ss.ff6') -- 交易时间
    ,${iml_schema}.DATEFORMAT_MAX(P1.CTF_TRANSDATE) -- 交易日期
    ,P1.CTF_TRANSCODE -- 交易码
    ,P1.CTF_ACTION -- 交易命令
    ,P1.CTF_ECIFNO -- 统一客户编号
    ,P1.CTF_USERNO -- 用户顺序号
    ,nvl(trim(P1.CTF_CHANNEL),'-') -- 交易渠道代码
    ,P1.CTF_ECIFNAME -- 客户姓名
    ,P1.CTF_MENUID -- 菜单ID
    ,P1.CTF_STATE -- 交易状态代码
    ,P1.CTF_RETURNCODE -- 交易返回编码
    ,P1.CTF_RETURNMSG -- 失败原因描述
    ,P1.CTF_ACCNO -- 交易账号
    ,P1.CTF_AMONUT -- 交易金额
    ,NVL(TRIM(p1.CTF_CURRENCY),'CNY') -- 币种代码
    ,P1.CTF_SENDFLOWNO -- 渠道发送流水编号
    ,P1.CTF_SRC_SENDFLOWNO -- 源系统流水编号
    ,P1.CTF_HOSTFLOWNO -- 核心交易流水编号
    ,P1.CTF_FEE -- 手续费
    ,P1.CTF_PARENTLOGNO -- 父流水编号
    ,P1.CTF_ROOTLOGNO -- 来源流水顺序编号
    ,P1.CTF_AUTHREFUSECAUSE -- 授权拒绝原因
    ,P1.CTF_ACCESSFLOWNO -- 访问流水编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.CTF_HOST_RETURNTIME) -- 核心交易日期
    ,P1.CTF_SVRTRANSCODE -- 被调方交易码
    ,P1.CTF_CUSTOMERIP -- 客户IP
    ,P1.CTF_HOSTNAME -- 当前服务器主机名称
    ,P1.CTF_SRC_SERVERIP -- 请求来源服务器IP
    ,P1.CTF_CLIENTMAC -- 客户终端MAC地址
    ,P1.CTF_CLIENTOS -- 客户终端操作系统
    ,P1.CTF_CLIENTBROWSER -- 客户终端浏览器
    ,P1.CTF_CLIENTNUNITTYPE -- 客户终端设备型号
    ,P1.CTF_CLIENTTERMINATENO -- 客户终端设备ID
    ,P1.CTF_SESSIONID -- SESSION_ID
    ,P1.CTF_RELFLOWNO -- 关联流水编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||p1.CTF_SECURITYTYPE END -- 安全认证方式代码
    ,NVL(TRIM(p1.CTF_AUTHSTATE),'-') -- 授权状态代码
    ,P1.CTF_DELEGATEFLAG -- 银行代办标志
    ,P1.CTF_AUTHSTEP -- 授权角色序号
    ,${iml_schema}.DATEFORMAT_MAX(P1.CTF_SENDDATE) -- 提交核心日期
    ,case when trim(CTF_SENDTIME)is null 
        then iml.timeformat_max('2099-12-31') 
      else iml.timeformat_max(substr(P1.CTF_SENDTIME,1,4)||'-'||substr(P1.CTF_SENDTIME,5,2)||'-'||substr(P1.CTF_SENDTIME,7,2)||' '||substr(P1.CTF_SENDTIME,9,2)||':'||substr(P1.CTF_SENDTIME,11,2)||':'||substr(P1.CTF_SENDTIME,13,2)) end -- 提交核心时间
    ,P1.CTF_TOTALCOUNT -- 交易总数量
    ,P1.CTF_REMARK -- 备注
    ,P1.CTF_BIZ_FLOW_NO -- 业务流水号
    ,P1.CTF_CHAIN_TRACK_NO -- 链路跟踪号
    ,P1.CTF_SEND_FLOW_NO -- 上游流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tbps_cpr_trade_flow' -- 源表名称
    ,'tbpsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tbps_cpr_trade_flow p1
    left join ${iml_schema}.ref_pub_cd_map r1 on p1.CTF_SECURITYTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'TBPS'
        AND R1.SRC_TAB_EN_NAME= 'TBPS_CPR_TRADE_FLOW'
        AND R1.SRC_FIELD_EN_NAME= 'CTF_SECURITYTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_BANK_PC_EDIT_TRAN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'SAVE_CERT_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_bank_pc_edit_tran_flow truncate partition p_tbpsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_bank_pc_edit_tran_flow exchange subpartition p_tbpsf1_${batch_date} with table ${iml_schema}.evt_bank_pc_edit_tran_flow_tbpsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bank_pc_edit_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_bank_pc_edit_tran_flow_tbpsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bank_pc_edit_tran_flow', partname => 'p_tbpsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);