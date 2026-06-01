/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_onl_bank_tran_flow_osbsf1
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
drop table ${iml_schema}.evt_onl_bank_tran_flow_osbsf1_tm purge;
alter table ${iml_schema}.evt_onl_bank_tran_flow add partition p_osbsf1 values ('osbsf1')(
        subpartition p_osbsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_onl_bank_tran_flow modify partition p_osbsf1
    add subpartition p_osbsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

set serveroutput on
--set line 200;
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
--dbms_output.put_line('BBB');
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_onl_bank_tran_flow'') and subpartition_name = ''P_OSBSF1_'||bat_dt||''' ';
   -- dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    --dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_onl_bank_tran_flow truncate subpartition P_OSBSF1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iml.evt_onl_bank_tran_flow modify partition p_osbsf1 add subpartition P_OSBSF1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
      --  dbms_output.put_line(v_sql);
        execute immediate v_sql;
      --  dbms_output.put_line('AAA');
    end if;
      end loop;
end;
/


-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- osbs_pub_trade_flow-
insert into ${iml_schema}.evt_onl_bank_tran_flow(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_code -- 交易码
    ,onl_bank_tran_status_cd -- 网上银行交易状态代码
    ,tran_return_code -- 交易返回码
    ,fail_rs -- 失败原因
    ,tran_acct_num -- 交易账号
    ,tran_amt -- 交易金额
    ,curr_cd -- 币种代码
    ,whole_unify_cust_id -- 全行统一客户编号
    ,tran_chn_cd -- 交易渠道代码
    ,chn_send_flow_num -- 渠道发送流水号
    ,sorc_sys_flow_num -- 源系统流水号
    ,core_tran_flow_num -- 核心交易流水号
    ,comm_fee -- 手续费
    ,visit_flow_num -- 访问流水号
    ,core_tran_dt -- 核心交易日期
    ,cust_ip_num -- 客户IP号
    ,curr_server_host_name -- 当前服务器主机名
    ,cust_termn_mac_addr -- 客户终端MAC地址
    ,cust_termn_oper_sys_edit_num -- 客户终端操作系统版本号
    ,cust_termn_brow -- 客户终端浏览器
    ,cust_termn_equip_model -- 客户终端设备型号
    ,cust_termn_equip_id -- 客户终端设备编号
    ,logon_session_id -- 登陆session编号
    ,rela_flow_num -- 关联流水号
    ,tran_jnl_info -- 交易日志信息
    ,tran_type_code -- 交易类型码
    ,cust_name -- 客户名称
    ,save_cert_way_cd -- 安全认证方式代码
    ,splt_flow_num -- 拆笔流水号
    ,camp_job_no -- 营销工号
    ,pbc_flow_num -- 人行流水号
    ,user_seq_id -- 用户顺序编号
    ,tran_order_no -- 交易订单号
    ,chain_way_track_no -- 链路跟踪号
    ,sys_flow_num -- 系统流水号
    ,chn_id -- 渠道编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102036'||p1.PTF_TRADE_FLOWNO -- 事件编号
    ,'9999' -- 法人编号
    ,p1.PTF_TRADE_FLOWNO -- 流水号
    ,${iml_schema}.dateformat_min(substr(P1.PTF_TRANSTIME,1,8)) -- 交易日期
    ,P1.PTF_TRANSTIME -- 交易时间
    ,p1.PTF_TRANSCODE -- 交易码
    ,p1.PTF_STATE -- 网上银行交易状态代码
    ,p1.PTF_RETURNCODE -- 交易返回码
    ,p1.PTF_RETURNMSG -- 失败原因
    ,p1.PTF_ACCNO -- 交易账号
    ,p1.PTF_AMONUT -- 交易金额
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PTF_CURRENCY END -- 币种代码
    ,p1.PTF_ECIFNO -- 全行统一客户编号
    ,nvl(trim(P1.PTF_CHANNEL),'-') -- 交易渠道代码
    ,p1.PTF_SENDFLOWNO -- 渠道发送流水号
    ,p1.PTF_SRC_SENDFLOWNO -- 源系统流水号
    ,p1.PTF_HOSTFLOWNO -- 核心交易流水号
    ,p1.PTF_FEE -- 手续费
    ,p1.PTF_ACCESSFLOWNO -- 访问流水号
    ,case when p1.PTF_HOST_RETURNTIME=' ' then to_date('00010101','yyyymmdd') else to_date(substr(p1.PTF_HOST_RETURNTIME,1,8),'yyyymmdd') end -- 核心交易日期
    ,p1.PTF_CUSTOMERIP -- 客户IP号
    ,p1.PTF_HOSTNAME -- 当前服务器主机名
    ,p1.PTF_CLIENTMAC -- 客户终端MAC地址
    ,p1.PTF_CLIENTOS -- 客户终端操作系统版本号
    ,p1.PTF_CLIENTBROWSER -- 客户终端浏览器
    ,p1.PTF_CLIENTNUNITTYPE -- 客户终端设备型号
    ,p1.PTF_CLIENTTERMINATENO -- 客户终端设备编号
    ,p1.PTF_SESSIONID -- 登陆session编号
    ,p1.PTF_RELFLOWNO -- 关联流水号
    ,p1.PTF_TRADE_INF -- 交易日志信息
    ,p1.PTF_TRANSTYPE -- 交易类型码
    ,p1.PTF_ECIFNAME -- 客户名称
    ,nvl(trim(P1.PTF_SECURITYTYPE),'-') -- 安全认证方式代码
    ,p1.PTF_PICKFLOWNO -- 拆笔流水号
    ,p1.PTF_MARKETING_NUMBER -- 营销工号
    ,p1.PTF_BUSINESSNO -- 人行流水号
    ,p1.PTF_USERNO -- 用户顺序编号
    ,P1.TX_SEQ_NUM -- 交易订单号
    ,P1.CHAIN_WAY_TRACK_NO -- 链路跟踪号
    ,P1.BIZ_SEQ_NUM -- 系统流水号
    ,nvl(trim(P1.PTF_CHANNELCODE),'-') -- 渠道编号
    ,P1.ETL_DT as etl_dt -- ETL处理日期
    ,'osbs_pub_trade_flow' -- 源表名称
    ,'osbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.osbs_pub_trade_flow p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PTF_CURRENCY = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'OSBS'
        AND R1.SRC_TAB_EN_NAME= 'OSBS_PUB_TRADE_FLOW'
        AND R1.SRC_FIELD_EN_NAME= 'PTF_CURRENCY'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_ONL_BANK_TRAN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
  where  1 = 1 
     and p1.etl_dt >= to_date('${batch_date}','yyyymmdd')-14 
     and p1.etl_dt <= to_date('${batch_date}','yyyymmdd') 
;
commit;



-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_onl_bank_tran_flow to ${iml_schema};



-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_onl_bank_tran_flow', partname => 'p_osbsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);