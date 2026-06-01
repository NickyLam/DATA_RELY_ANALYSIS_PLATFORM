/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_evt_bank_pc_edit_tran_flow
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
alter table ${itl_schema}.itl_edw_evt_bank_pc_edit_tran_flow drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_evt_bank_pc_edit_tran_flow drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_evt_bank_pc_edit_tran_flow add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_evt_bank_pc_edit_tran_flow partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,evt_id  -- 事件编号
    ,lp_id  -- 法人编号
    ,flow_num  -- 流水号
    ,tran_tm  -- 交易时间
    ,tran_dt  -- 交易日期
    ,tran_code  -- 交易码
    ,tran_order  -- 交易命令
    ,unify_cust_id  -- 统一客户编号
    ,user_seq_num  -- 用户顺序号
    ,tran_chn_cd  -- 交易渠道代码
    ,cust_name  -- 客户姓名
    ,menu_id  -- 菜单ID
    ,tran_status_cd  -- 交易状态代码
    ,tran_return_code  -- 交易返回编码
    ,fail_rs_descb  -- 失败原因描述
    ,tran_acct_num  -- 交易账号
    ,tran_amt  -- 交易金额
    ,curr_cd  -- 币种代码
    ,chn_send_flow_id  -- 渠道发送流水编号
    ,sorc_sys_flow_id  -- 源系统流水编号
    ,core_tran_flow_id  -- 核心交易流水编号
    ,comm_fee  -- 手续费
    ,parent_flow_id  -- 父流水编号
    ,src_flow_seq_id  -- 来源流水顺序编号
    ,auth_refuse_rs  -- 授权拒绝原因
    ,visit_flow_id  -- 访问流水编号
    ,core_tran_dt  -- 核心交易日期
    ,callout_tran_code  -- 被调方交易码
    ,cust_ip  -- 客户IP
    ,curr_server_host_name  -- 当前服务器主机名称
    ,req_src_server_ip  -- 请求来源服务器IP
    ,cust_termn_mac_addr  -- 客户终端MAC地址
    ,cust_termn_oper_sys  -- 客户终端操作系统
    ,cust_termn_brow  -- 客户终端浏览器
    ,cust_termn_equip_model  -- 客户终端设备型号
    ,cust_termn_equip_id  -- 客户终端设备ID
    ,session_id  -- SESSION_ID
    ,rela_flow_id  -- 关联流水编号
    ,save_cert_way_cd  -- 安全认证方式代码
    ,auth_status_cd  -- 授权状态代码
    ,bank_agent_flg  -- 银行代办标志
    ,auth_role_seq_num  -- 授权角色序号
    ,submit_core_dt  -- 提交核心日期
    ,submit_core_tm  -- 提交核心时间
    ,tran_tot_qtty  -- 交易总数量
    ,remark  -- 备注
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.evt_id,chr(13),''),chr(10),'')  -- 事件编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.flow_num,chr(13),''),chr(10),'')  -- 流水号
    ,t1.tran_tm  -- 交易时间
    ,t1.tran_dt  -- 交易日期
    ,replace(replace(t1.tran_code,chr(13),''),chr(10),'')  -- 交易码
    ,replace(replace(t1.tran_order,chr(13),''),chr(10),'')  -- 交易命令
    ,replace(replace(t1.unify_cust_id,chr(13),''),chr(10),'')  -- 统一客户编号
    ,replace(replace(t1.user_seq_num,chr(13),''),chr(10),'')  -- 用户顺序号
    ,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'')  -- 交易渠道代码
    ,replace(replace(t1.cust_name,chr(13),''),chr(10),'')  -- 客户姓名
    ,replace(replace(t1.menu_id,chr(13),''),chr(10),'')  -- 菜单ID
    ,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'')  -- 交易状态代码
    ,replace(replace(t1.tran_return_code,chr(13),''),chr(10),'')  -- 交易返回编码
    ,replace(replace(t1.fail_rs_descb,chr(13),''),chr(10),'')  -- 失败原因描述
    ,replace(replace(t1.tran_acct_num,chr(13),''),chr(10),'')  -- 交易账号
    ,t1.tran_amt  -- 交易金额
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,replace(replace(t1.chn_send_flow_id,chr(13),''),chr(10),'')  -- 渠道发送流水编号
    ,replace(replace(t1.sorc_sys_flow_id,chr(13),''),chr(10),'')  -- 源系统流水编号
    ,replace(replace(t1.core_tran_flow_id,chr(13),''),chr(10),'')  -- 核心交易流水编号
    ,t1.comm_fee  -- 手续费
    ,replace(replace(t1.parent_flow_id,chr(13),''),chr(10),'')  -- 父流水编号
    ,replace(replace(t1.src_flow_seq_id,chr(13),''),chr(10),'')  -- 来源流水顺序编号
    ,replace(replace(t1.auth_refuse_rs,chr(13),''),chr(10),'')  -- 授权拒绝原因
    ,replace(replace(t1.visit_flow_id,chr(13),''),chr(10),'')  -- 访问流水编号
    ,t1.core_tran_dt  -- 核心交易日期
    ,replace(replace(t1.callout_tran_code,chr(13),''),chr(10),'')  -- 被调方交易码
    ,replace(replace(t1.cust_ip,chr(13),''),chr(10),'')  -- 客户IP
    ,replace(replace(t1.curr_server_host_name,chr(13),''),chr(10),'')  -- 当前服务器主机名称
    ,replace(replace(t1.req_src_server_ip,chr(13),''),chr(10),'')  -- 请求来源服务器IP
    ,replace(replace(t1.cust_termn_mac_addr,chr(13),''),chr(10),'')  -- 客户终端MAC地址
    ,replace(replace(t1.cust_termn_oper_sys,chr(13),''),chr(10),'')  -- 客户终端操作系统
    ,replace(replace(t1.cust_termn_brow,chr(13),''),chr(10),'')  -- 客户终端浏览器
    ,replace(replace(t1.cust_termn_equip_model,chr(13),''),chr(10),'')  -- 客户终端设备型号
    ,replace(replace(t1.cust_termn_equip_id,chr(13),''),chr(10),'')  -- 客户终端设备ID
    ,replace(replace(t1.session_id,chr(13),''),chr(10),'')  -- SESSION_ID
    ,replace(replace(t1.rela_flow_id,chr(13),''),chr(10),'')  -- 关联流水编号
    ,replace(replace(t1.save_cert_way_cd,chr(13),''),chr(10),'')  -- 安全认证方式代码
    ,replace(replace(t1.auth_status_cd,chr(13),''),chr(10),'')  -- 授权状态代码
    ,replace(replace(t1.bank_agent_flg,chr(13),''),chr(10),'')  -- 银行代办标志
    ,replace(replace(t1.auth_role_seq_num,chr(13),''),chr(10),'')  -- 授权角色序号
    ,t1.submit_core_dt  -- 提交核心日期
    ,t1.submit_core_tm  -- 提交核心时间
    ,t1.tran_tot_qtty  -- 交易总数量
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 备注
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from ${msl_schema}.msl_edw_evt_bank_pc_edit_tran_flow t1    --银行pc版交易流水
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_evt_bank_pc_edit_tran_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
