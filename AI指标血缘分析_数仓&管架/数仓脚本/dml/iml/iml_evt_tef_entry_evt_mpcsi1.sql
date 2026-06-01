/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_tef_entry_evt_mpcsi1
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

alter table ${iml_schema}.evt_tef_entry_evt add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_tef_entry_evt modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
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
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_tef_entry_evt'') and subpartition_name = ''P_MPCSI1_'||bat_dt||''' ';
    dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_tef_entry_evt truncate subpartition P_MPCSI1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iml.evt_tef_entry_evt modify partition p_mpcsi1 add subpartition P_MPCSI1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
        dbms_output.put_line('AAA');
    end if;
      end loop;
end;
/


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a49tfintranlist-
insert into ${iml_schema}.evt_tef_entry_evt(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,tran_dt -- 交易日期
    ,sys_cd -- 系统代码
    ,tran_tm -- 交易时间
    ,front_flow_num -- 前置流水号
    ,front_dt -- 前置日期
    ,host_tran_code -- 主机交易码
    ,midgrod_tran_code -- 中台交易码
    ,proc_org_id -- 处理机构编号
    ,proc_teller_id -- 处理柜员编号
    ,status_cd -- 状态代码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,pay_acct -- 付款账户
    ,pay_acct_name -- 付款账户名称
    ,recvbl_acct -- 收款账户
    ,recvbl_acct_name -- 收款账户名称
    ,tran_index_num -- 交易索引号
    ,err_return_code -- 错误返回编码
    ,err_info -- 错误信息
    ,check_entry_status_cd -- 对账状态代码
    ,tran_amt -- 交易金额
    ,acct_ety_code -- 会计分录编码
    ,check_entry_dt -- 对账日期
    ,e_acct_cd -- 电子账户代码
    ,tran_flow_num -- 交易流水号
    ,ova_flow_num -- 全局流水号
    ,chn_code -- 渠道编码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102046'||P1.TRANSDT||P1.MAINSEQ -- 事件编号
    ,'9999' -- 法人编号
    ,P1.MAINSEQ -- 中台流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSDT) -- 交易日期
    ,NVL(TRIM(P1.SYSID),'-') -- 系统代码
    ,substr(P1.TRANSTIME,9) -- 交易时间
    ,P1.UNOTNBR -- 前置流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.UNOTDATE) -- 前置日期
    ,P1.HOSTTRCD -- 主机交易码
    ,P1.FRONTTRCD -- 中台交易码
    ,P1.MAGBRN -- 处理机构编号
    ,P1.USERID -- 处理柜员编号
    ,NVL(TRIM(P1.STATUS),'-') -- 状态代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.HOSTDATE) -- 主机日期
    ,P1.HOSTNBR -- 主机流水号
    ,P1.PAYACCT -- 付款账户
    ,P1.PAYNAME -- 付款账户名称
    ,P1.INCOACCT -- 收款账户
    ,P1.INCONAME -- 收款账户名称
    ,P1.DATAID -- 交易索引号
    ,P1.ERRCODE -- 错误返回编码
    ,P1.ERRMS -- 错误信息
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.COLSTS END -- 对账状态代码
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.TRANSAMT, '[0-9.]+')),0)) -- 交易金额
    ,P1.ABSCDE -- 会计分录编码
    ,${iml_schema}.DATEFORMAT_MAX(P1.COLLDATE) -- 对账日期
    ,NVL(TRIM(P1.EACCFLG),'-') -- 电子账户代码
    ,P1.TRANSEQNO -- 交易流水号
    ,P1.GLOBALSEQNO -- 全局流水号
    ,P1.CHN_ID -- 渠道编码
    ,P1.etl_dt as etl_dt -- ETL处理日期
    ,'mpcs_a49tfintranlist' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a49tfintranlist p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.COLSTS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A49TFINTRANLIST'
        AND R1.SRC_FIELD_EN_NAME= 'COLSTS'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_TEF_ENTRY_EVT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CHECK_ENTRY_STATUS_CD'
where  1 = 1 
    and p1.etl_dt>=to_date('${batch_date}','yyyymmdd')-14 and p1.etl_dt<=to_date('${batch_date}','yyyymmdd')
;
commit;


-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_tef_entry_evt to ${iml_schema};

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_tef_entry_evt', partname => 'p_mpcsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);