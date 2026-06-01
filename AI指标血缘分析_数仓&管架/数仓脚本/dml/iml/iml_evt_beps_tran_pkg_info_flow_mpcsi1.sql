/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_beps_tran_pkg_info_flow_mpcsi1
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
drop table ${iml_schema}.evt_beps_tran_pkg_info_flow_mpcsi1_tm purge;
alter table ${iml_schema}.evt_beps_tran_pkg_info_flow add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_beps_tran_pkg_info_flow modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

set serveroutput on
--set line 200;
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_beps_tran_pkg_info_flow'') and subpartition_name = ''P_MPCSI1_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_beps_tran_pkg_info_flow truncate subpartition P_MPCSI1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --no exists partitions  
    else 
        v_sql := 'alter table iml.evt_beps_tran_pkg_info_flow modify partition p_mpcsi1 add subpartition P_MPCSI1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd''))' ;
        execute immediate v_sql;
    end if;
      end loop;
end;
/


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a08tbetotallog-1
insert into ${iml_schema}.evt_beps_tran_pkg_info_flow(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,pkg_seq_num -- 包序号
    ,pkg_entr_dt -- 包委托日期
    ,pkg_init_clear_bk_no -- 包发起清算行行号
    ,debit_crdt_flg -- 借贷标志
    ,pkg_init_clear_bk_rg_cd -- 包发起清算行地区代码
    ,pkg_recv_clear_bk_no -- 包接收清算行行号
    ,pkg_recv_clear_bk_rg_code -- 包接收清算行地区码
    ,tran_dt -- 交易日期
    ,midgrod_flow_num -- 中台流水号
    ,bank_int_proc_status_cd -- 行内处理状态代码
    ,rtn_rcpt_day_tenor -- 回执日期限
    ,rtn_rcpt_dt -- 回执日期
    ,tot -- 总笔数
    ,tot_amt -- 总金额
    ,sucs_cnt -- 成功笔数
    ,sucs_amt -- 成功金额
    ,fail_cnt -- 失败笔数
    ,fail_amt -- 失败金额
    ,curr_cd -- 币种代码
    ,offs_bal_num_site -- 轧差场次
    ,offs_bal_dt -- 轧差日期
    ,reissue_flg -- 补发标志
    ,clear_dt -- 清算日期
    ,brac_org_id -- 网点机构编号
    ,pkg_tran_status_cd -- 包交易状态代码
    ,cont_pkg_idf_cd -- 往来包标识代码
    ,init_pkg_init_clear_bk_no -- 原包发起清算行行号
    ,init_pkg_entr_dt -- 原包委托日期
    ,init_pkg_midgrod_flow_num -- 原包中台流水号
    ,init_pkg_seq_num -- 原包序号
    ,reg_bus_batch_no -- 定期业务批次号
    ,init_pkg_proc_status_cd -- 原包处理状态代码
    ,tran_flow_num -- 交易流水号
    ,send_flow_num -- 发送流水号
    ,check_entry_status_cd -- 对账状态代码
    ,check_entry_dt -- 对账日期
    ,cntpty_sys_edit_cd -- 对手系统版本代码
    ,entry_fail_flg -- 记账失败标志
    ,proc_idf_cd -- 处理标识代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102041'||p1.PKSQNO||p1.DATE0||p1.SDCLBK||p1.FLAG4 -- 事件编号
    ,'9999' -- 法人编号
    ,P1.PKSQNO -- 包序号
    ,${iml_schema}.dateformat_max2(P1.DATE0) -- 包委托日期
    ,P1.SDCLBK -- 包发起清算行行号
    ,P1.FLAG4 -- 借贷标志
    ,P1.SENDCT -- 包发起清算行地区代码
    ,P1.RDCLBK -- 包接收清算行行号
    ,P1.RECVCT -- 包接收清算行地区码
    ,${iml_schema}.dateformat_max2(P1.TRANDT) -- 交易日期
    ,P1.PKGBUSINESSTRACE -- 中台流水号
    ,P1.STATUS -- 行内处理状态代码
    ,NVL(TRIM(P1.DEADLINE    ),0) -- 回执日期限
    ,${iml_schema}.dateformat_max2(P1.BACKDATE) -- 回执日期
    ,NVL(TRIM(P1.TOTALNUM    ),0) -- 总笔数
    ,NVL(TRIM(P1.TOTALAMT    ),0) -- 总金额
    ,NVL(TRIM(P1.SUCCTOTALNUM),0) -- 成功笔数
    ,NVL(TRIM(P1.SUCCTOTALAMT),0) -- 成功金额
    ,NVL(TRIM(P1.FAILTOTALNUM),0) -- 失败笔数
    ,NVL(TRIM(P1.FAILTOTALAMT),0) -- 失败金额
    ,P1.CRCYCD -- 币种代码
    ,NVL(TRIM(P1.OBALOD      ),0)  -- 轧差场次
    ,${iml_schema}.dateformat_max2(P1.OBALDT) -- 轧差日期
    ,nvl(trim(P1.REISSUSFLAG),'-') -- 补发标志
    ,${iml_schema}.dateformat_max2(P1.CLERDT) -- 清算日期
    ,P1.NODE -- 网点机构编号
    ,P1.TRANSSTATUS -- 包交易状态代码
    ,P1.IOTYPE -- 往来包标识代码
    ,P1.ORASDCLBK -- 原包发起清算行行号
    ,${iml_schema}.dateformat_max2(P1.ORADATE0) -- 原包委托日期
    ,P1.ORAPKGBUSINESSTRACE -- 原包中台流水号
    ,P1.ORAPKSQNO -- 原包序号
    ,P1.DISKNO -- 定期业务批次号
    ,P1.ORASTATUS -- 原包处理状态代码
    ,P1.TRANSQ -- 交易流水号
    ,P1.SDTRSQ -- 发送流水号
    ,P1.COLSTATUS -- 对账状态代码
    ,${iml_schema}.dateformat_max2(P1.COLDATE) -- 对账日期
    ,P1.OTHERCNAPSVER -- 对手系统版本代码
    ,nvl(trim(P1.DEALERRFLAG),'-') -- 记账失败标志
    ,P1.DEALFLAG -- 处理标识代码
    ,to_date(p1.trandt,'yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a08tbetotallog' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a08tbetotallog p1
where  1 = 1 
     and p1.trandt>=to_char(to_date('${batch_date}','yyyymmdd')-14,'yyyymmdd') and p1.trandt<='${batch_date}'
;
commit;




-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_beps_tran_pkg_info_flow to ${iml_schema};



-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_beps_tran_pkg_info_flow', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);


