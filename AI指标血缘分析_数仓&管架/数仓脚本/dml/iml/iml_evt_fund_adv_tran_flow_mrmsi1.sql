/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_fund_adv_tran_flow_mrmsi1
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
drop table ${iml_schema}.evt_fund_adv_tran_flow_mrmsi1_tm purge;
alter table ${iml_schema}.evt_fund_adv_tran_flow add partition p_mrmsi1 values ('mrmsi1')(
        subpartition p_mrmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_fund_adv_tran_flow modify partition p_mrmsi1
    add subpartition p_mrmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
-- 2.2.1 get new data into table
set serveroutput on
--set line 200;
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
--dbms_output.put_line('BBB');
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_fund_adv_tran_flow'') and subpartition_name = ''P_MRMSI1_'||bat_dt||''' ';
    dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_fund_adv_tran_flow truncate subpartition p_mrmsi1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iml.evt_fund_adv_tran_flow modify partition p_mrmsi1 add subpartition p_mrmsi1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
        dbms_output.put_line('AAA');
    end if;
      end loop;
end;
/


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to  table
-- mrms_bth_jj_mcht_sum-1
insert into ${iml_schema}.evt_fund_adv_tran_flow(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,intnal_brch_id -- 内部分行编号
    ,tran_dt -- 交易日期
    ,recv_org_id -- 收单机构编号
    ,seq_num -- 序号
    ,agt_corp_id -- 协议单位编号
    ,clear_acct_id -- 清算账户编号
    ,clear_intnal_acct_id -- 清算内部账户编号
    ,clear_intnal_acct_name -- 清算内部账户名称
    ,clear_dt -- 清算日期
    ,stl_mode_descb -- 结算模式描述
    ,tot_e_amt -- 总额度
    ,used_lmt -- 已使用额度
    ,comm_fee_amt -- 手续费金额
    ,unionpay_sucs_amt -- 银联成功金额
    ,tot -- 总笔数
    ,tot_amt -- 总金额
    ,sucs_cnt -- 成功笔数
    ,sucs_tot_amt -- 成功总金额
    ,fail_cnt -- 失败笔数
    ,fail_amt -- 失败金额
    ,not_tran_cnt -- 未明交易笔数
    ,not_tran_amt -- 未明交易金额
    ,payfan_repay_amt -- 代付还款金额
    ,bus_cfm_amt -- 业务确认金额
    ,cfm_ps_id -- 确认人编号
    ,cfm_status_cd -- 确认状态代码
    ,actl_remit_acct_amt -- 实际划账金额
    ,aldy_remit_acct_flg -- 划账状态代码
    ,core_flow_num -- 核心流水号
    ,err_descb -- 错误描述
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401027'||P1.SEQNO||P1.TRANDT -- 事件编号
    ,'9999' -- 法人编号
    ,P1.INTER_BRH_CODE -- 内部分行编号
    ,${iml_schema}.timeformat_max2(P1.TRANDT) -- 交易日期
    ,P1.ACQ_INST_ID -- 收单机构编号
    ,P1.SEQNO -- 序号
    ,P1.FUND_ID -- 协议单位编号
    ,P1.SETT_ACCOUNT -- 清算账户编号
    ,P1.INNERACCT -- 清算内部账户编号
    ,P1.INNERACNA -- 清算内部账户名称
    ,${iml_schema}.timeformat_max2(P1.SETTLMT_DATE) -- 清算日期
    ,P1.SETT_NA -- 结算模式描述
    ,P1.FUND_AMT -- 总额度
    ,P1.USED_AMT -- 已使用额度
    ,P1.FEE_AMT -- 手续费金额
    ,P1.YL_AMT -- 银联成功金额
    ,P1.TOTCNT -- 总笔数
    ,P1.TOTAMT -- 总金额
    ,P1.SUCCCNT -- 成功笔数
    ,P1.SUCCAMT -- 成功总金额
    ,P1.FAILCNT -- 失败笔数
    ,P1.FAILAMT -- 失败金额
    ,P1.UNKNCNT -- 未明交易笔数
    ,P1.UNKNAMT -- 未明交易金额
    ,P1.ONLNBL -- 代付还款金额
    ,P1.CHCKAMT -- 业务确认金额
    ,P1.CHCKUSER -- 确认人编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CHCKSTAT END -- 确认状态代码
    ,P1.CBSAMT -- 实际划账金额
    ,nvl(trim(P1.ACCT_FLAG),'-') -- 划账状态代码
    ,P1.HOST_SSN -- 核心流水号
    ,P1.RES_DESC -- 错误描述
    ,P1.ETL_DT as etl_dt -- ETL处理日期
    ,'mrms_bth_jj_mcht_sum' -- 源表名称
    ,'mrmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_bth_jj_mcht_sum p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CHCKSTAT = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MRMS'
        AND R1.SRC_TAB_EN_NAME= 'MRMS_BTH_JJ_MCHT_SUM'
        AND R1.SRC_FIELD_EN_NAME= 'CHCKSTAT'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_FUND_ADV_TRAN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CFM_STATUS_CD'
where  1 = 1 
   and p1.etl_dt>=to_date('${batch_date}','yyyymmdd')-14 
   and p1.etl_dt<=to_date('${batch_date}','yyyymmdd')

;
commit;




-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_fund_adv_tran_flow to ${iml_schema};



-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_fund_adv_tran_flow', partname => 'p_mrmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);