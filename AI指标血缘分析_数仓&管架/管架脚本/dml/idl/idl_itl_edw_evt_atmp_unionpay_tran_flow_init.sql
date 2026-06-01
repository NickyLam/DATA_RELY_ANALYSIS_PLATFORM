/*
Author:     郑沛隆
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_itl_edw_evt_atmp_unionpay_tran_flow_init
CreateDate: 20220905
Logs:
    郑沛隆 20221105版本，由于 itl_edw_evt_atmp_unionpay_tran_flow 字段类型变更，需备份并初始化数据表
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

----------truncate target table batch_date subpartition
whenever sqlerror continue none ;
--1.2 循环创建指定分区
truncate table itl_edw_evt_atmp_unionpay_tran_flow;

whenever sqlerror exit sql.sqlcode; 

set serveroutput on 
DECLARE
    --获取备份表分区
    CURSOR cur_partition IS
        SELECT to_char(etl_dt,'yyyymmdd') as partition_name
        FROM ITL_EDW_EVT_ATMP_UNIONPAY_TRAN_FLOW_BK20221105
        group by to_char(etl_dt,'yyyymmdd');

    exists_flag NUMBER(10) := 0; -- 判断标志
    v_sql       VARCHAR2(4000);
    v_partition VARCHAR2(200);

BEGIN

    FOR rec_partition IN cur_partition
    LOOP
    
        v_partition := rec_partition.partition_name;
    
        SELECT COUNT(1)
        INTO   exists_flag
        FROM   user_tab_partitions
        WHERE  table_name = 'ITL_EDW_EVT_ATMP_UNIONPAY_TRAN_FLOW'
        AND    partition_name = 'P_' || v_partition;
    
        IF exists_flag = 0
        THEN
            --分区不存在则直接创建
            --动态拼接创建分区sql
            v_sql := 'alter table itl_edw_evt_atmp_unionpay_tran_flow add partition p_' ||
                     v_partition || ' values ';
            v_sql := v_sql || '(to_date(''' || v_partition || ''',''yyyymmdd''))';
        
            EXECUTE IMMEDIATE v_sql;
        ELSE
            --分区存在则清空分区数据
            v_sql := 'alter table itl_edw_evt_atmp_unionpay_tran_flow truncate partition p_' ||
                     v_partition;
            EXECUTE IMMEDIATE v_sql;
        END IF;
    
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('循环创建指定分区出错' || SQLERRM);
    
END;


/

-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a50ubcardjourhis-
insert into ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,send_org_id -- 发送机构编号
    ,sys_follow_id -- 系统跟踪编号
    ,tran_tm -- 交易时间
    ,tran_cd -- 交易代码
    ,tran_type_cd -- 交易类型代码
    ,proc_org_id -- 受理机构编号
    ,tran_dt -- 交易日期
    ,teller_id -- 柜员编号
    ,tran_org_id -- 交易机构编号
    ,chn_cd -- 渠道代码
    ,msg_type_cd -- 报文类型代码
    ,main_acct_id -- 主账户编号
    ,proc_cd -- 处理代码
    ,intnal_proc_cd -- 内部处理代码
    ,tran_amt -- 交易金额
    ,onl_acct_bal -- 联机账户余额
    ,acct_td_aval_bal -- 账户当日可用余额
    ,atm_draw_td_aval_bal -- ATM取款当日可用余额
    ,tran_fee -- 交易费用
    ,proc_org_site_tm -- 受理机构所在地时间
    ,proc_org_site_dt -- 受理机构所在地日期
    ,clear_dt -- 清算日期
    ,mercht_type_cd -- 商户类型代码
    ,tran_serv_input_way_cd -- 交易服务点输入方式代码
    ,tran_serv_cond_cd -- 交易服务点条件代码
    ,retriv_ref_id -- 检索参考编号
    ,apprv_tran_auth_id -- 批准交易授权编号
    ,return_code -- 返回码
    ,proc_termn_id -- 受理终端编号
    ,proc_mercht_id -- 受理商户编号
    ,proc_mercht_name -- 受理商户名称
    ,addit_resp_descb -- 附加响应描述
    ,addit_priv -- 附加私有域
    ,curr_cd -- 币种代码
    ,resv_region -- 保留域
    ,recv_org_id -- 接收机构编号
    ,cups_resv_num -- CUPS保留号
    ,init_proc_org_id -- 原受理机构编号
    ,init_send_org_id -- 原发送机构编号
    ,init_sys_follow_id -- 原系统跟踪编号
    ,init_tran_tm -- 原交易时间
    ,unionpay_exch_rat -- 银联汇率
    ,expns_acct_id -- 支出账户编号
    ,depot_acct_id -- 存入账户编号
    ,atmc_tran_flow_num -- ATMC交易流水号
    ,msg_head_info -- 报文头信息
    ,tran_status_cd -- 交易状态代码
    ,err_cd -- 错误码
    ,err_info -- 错误信息
    ,termn_type_cd -- 终端类型代码
    ,init_way_cd -- 发起方式代码
    ,mercht_cty_rg_cd -- 商户国家地区代码
    ,deduct_amt -- 扣款金额
    ,deduct_exch_rat -- 扣款汇率
    ,clear_amt -- 清算金额
    ,send_org_actl_id -- 发送机构实际编号
    ,cross_bor_flg -- 跨境标志
    ,card_ser_num -- 卡序列号
    ,access_ic_data_region -- 接入IC卡数据域
    ,send_ic_data_region -- 发出IC卡数据域
    ,intnal_tran_cd -- 内部交易代码
    ,fcurr_tran_amt -- 外币交易金额
    ,bank_acct_type_cd -- 银行账户类型代码
    ,open_acct_org_id -- 开户机构编号
    ,comm_fee -- 手续费
    ,card_type_cd -- 卡类型代码
    ,card_tran_type_cd -- 卡交易类型代码
    ,qr_code_pay_scene_cd -- 二维码付款场景代码
    ,cross_bank_flg -- 跨行标志
    ,degr_flg -- 降级标志
    ,beps_unpasew_flg -- 小额免密标志
    ,subclass_return_code -- 细类返回码
    ,memo_cd -- 摘要代码
    ,ova_flow_num -- 全局流水号
    ,tran_flow_num -- 交易流水号
    ,init_tran_flow_num -- 原交易流水号
    ,upp_enter_status_cd -- UPP入账状态代码
    ,entry_flow_num -- 记账流水号
    ,entry_dt -- 记账日期
    ,delay_deduct_tran_flow_num -- 延时扣款交易流水号
    ,delay_deduct_tran_dt -- 延时扣款交易日期
    ,unionpay_delay_tran_return_cd -- 银联延时转账返回代码
    ,delay_tran_return_cd -- 延时转账返回代码
    ,termn_equip_id -- 终端设备编号
    ,termn_ip_addr -- 终端IP地址
    ,termn_sim_num -- 终端SIM号码
    ,termn_gps_position -- 终端GPS位置
    ,rsrv_mobile_no -- 预留手机号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,midgrod_tran_dt -- 中台交易日期
    ,acct_dt -- 账务日期
    ,init_tran_cd -- 原交易代码
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
     p1.evt_id -- 事件编号
    ,p1.lp_id -- 法人编号
    ,p1.send_org_id -- 发送机构编号
    ,p1.sys_follow_id -- 系统跟踪编号
    ,to_char(P1.tran_tm,'YYYYMMDDHH24MISSff6') -- 交易时间
    ,p1.tran_cd -- 交易代码
    ,p1.tran_type_cd -- 交易类型代码
    ,p1.proc_org_id -- 受理机构编号
    ,p1.tran_dt -- 交易日期
    ,p1.teller_id -- 柜员编号
    ,p1.tran_org_id -- 交易机构编号
    ,p1.chn_cd -- 渠道代码
    ,p1.msg_type_cd -- 报文类型代码
    ,p1.main_acct_id -- 主账户编号
    ,p1.proc_cd -- 处理代码
    ,p1.intnal_proc_cd -- 内部处理代码
    ,p1.tran_amt -- 交易金额
    ,p1.onl_acct_bal -- 联机账户余额
    ,p1.acct_td_aval_bal -- 账户当日可用余额
    ,p1.atm_draw_td_aval_bal -- ATM取款当日可用余额
    ,p1.tran_fee -- 交易费用
    ,p1.proc_org_site_tm -- 受理机构所在地时间
    ,p1.proc_org_site_dt -- 受理机构所在地日期
    ,p1.clear_dt -- 清算日期
    ,p1.mercht_type_cd -- 商户类型代码
    ,p1.tran_serv_input_way_cd -- 交易服务点输入方式代码
    ,p1.tran_serv_cond_cd -- 交易服务点条件代码
    ,p1.retriv_ref_id -- 检索参考编号
    ,p1.apprv_tran_auth_id -- 批准交易授权编号
    ,p1.return_code -- 返回码
    ,p1.proc_termn_id -- 受理终端编号
    ,p1.proc_mercht_id -- 受理商户编号
    ,p1.proc_mercht_name -- 受理商户名称
    ,p1.addit_resp_descb -- 附加响应描述
    ,p1.addit_priv -- 附加私有域
    ,p1.curr_cd -- 币种代码
    ,p1.resv_region -- 保留域
    ,p1.recv_org_id -- 接收机构编号
    ,p1.cups_resv_num -- CUPS保留号
    ,p1.init_proc_org_id -- 原受理机构编号
    ,p1.init_send_org_id -- 原发送机构编号
    ,p1.init_sys_follow_id -- 原系统跟踪编号
    ,p1.init_tran_tm -- 原交易时间
    ,p1.unionpay_exch_rat -- 银联汇率
    ,p1.expns_acct_id -- 支出账户编号
    ,p1.depot_acct_id -- 存入账户编号
    ,p1.atmc_tran_flow_num -- ATMC交易流水号
    ,p1.msg_head_info -- 报文头信息
    ,p1.tran_status_cd -- 交易状态代码
    ,p1.err_cd -- 错误码
    ,p1.err_info -- 错误信息
    ,p1.termn_type_cd -- 终端类型代码
    ,p1.init_way_cd -- 发起方式代码
    ,p1.mercht_cty_rg_cd -- 商户国家地区代码
    ,p1.deduct_amt -- 扣款金额
    ,p1.deduct_exch_rat -- 扣款汇率
    ,p1.clear_amt -- 清算金额
    ,p1.send_org_actl_id -- 发送机构实际编号
    ,p1.cross_bor_flg -- 跨境标志
    ,p1.card_ser_num -- 卡序列号
    ,p1.access_ic_data_region -- 接入IC卡数据域
    ,p1.send_ic_data_region -- 发出IC卡数据域
    ,p1.intnal_tran_cd -- 内部交易代码
    ,p1.fcurr_tran_amt -- 外币交易金额
    ,p1.bank_acct_type_cd -- 银行账户类型代码
    ,p1.open_acct_org_id -- 开户机构编号
    ,p1.comm_fee -- 手续费
    ,p1.card_type_cd -- 卡类型代码
    ,p1.card_tran_type_cd -- 卡交易类型代码
    ,p1.qr_code_pay_scene_cd -- 二维码付款场景代码
    ,p1.cross_bank_flg -- 跨行标志
    ,p1.degr_flg -- 降级标志
    ,p1.beps_unpasew_flg -- 小额免密标志
    ,p1.subclass_return_code -- 细类返回码
    ,p1.memo_cd -- 摘要代码
    ,p1.ova_flow_num -- 全局流水号
    ,p1.tran_flow_num -- 交易流水号
    ,p1.init_tran_flow_num -- 原交易流水号
    ,p1.upp_enter_status_cd -- UPP入账状态代码
    ,p1.entry_flow_num -- 记账流水号
    ,p1.entry_dt -- 记账日期
    ,p1.delay_deduct_tran_flow_num -- 延时扣款交易流水号
    ,p1.delay_deduct_tran_dt -- 延时扣款交易日期
    ,p1.unionpay_delay_tran_return_cd -- 银联延时转账返回代码
    ,p1.delay_tran_return_cd -- 延时转账返回代码
    ,p1.termn_equip_id -- 终端设备编号
    ,p1.termn_ip_addr -- 终端IP地址
    ,p1.termn_sim_num -- 终端SIM号码
    ,p1.termn_gps_position -- 终端GPS位置
    ,p1.rsrv_mobile_no -- 预留手机号
    ,p1.cust_id -- 客户编号
    ,p1.cust_name -- 客户名称
    ,p1.midgrod_tran_dt -- 中台交易日期
    ,p1.acct_dt -- 账务日期
    ,p1.init_tran_cd -- 原交易代码
    ,p1.etl_dt -- ETL处理日期
    ,p1.etl_timestamp -- ETL处理时间
from ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow_bk20221105 p1
;
commit;



-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_evt_atmp_unionpay_tran_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);