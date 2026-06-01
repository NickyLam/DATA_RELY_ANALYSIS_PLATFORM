/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bs_amt_entry_evt_mpcsi1
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

alter table ${iml_schema}.evt_bs_amt_entry_evt add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_bs_amt_entry_evt modify partition p_mpcsi1
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
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_bs_amt_entry_evt'') and subpartition_name = ''P_MPCSI1_'||bat_dt||''' ';
    dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_bs_amt_entry_evt truncate subpartition P_MPCSI1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iml.evt_bs_amt_entry_evt modify partition p_mpcsi1 add subpartition P_MPCSI1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
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
-- mpcs_a08tfintranlist-
insert into ${iml_schema}.evt_bs_amt_entry_evt(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bs_amt_entry_id -- 大小额记账编号
    ,sys_cd -- 系统代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,bank_int_bus_seq_num -- 行内业务序号
    ,bus_seq_num -- 业务序号
    ,msg_type_id -- 报文类型编号
    ,host_tran_code -- 主机交易码
    ,midgrod_tran_code -- 中台交易码
    ,mgmt_org_id -- 管理机构编号
    ,teller_id -- 柜员编号
    ,status_cd -- 状态代码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,payer_acct_num -- 付款人账号
    ,payer_name -- 付款人名称
    ,recver_acct_num -- 收款人账号
    ,recver_name -- 收款人名称
    ,trdpty_idf_id -- 第三方标识编号
    ,err_return_code -- 错误返回编码
    ,return_info -- 返回信息
    ,check_entry_status_cd -- 对账状态代码
    ,tran_amt -- 交易金额
    ,entry_code -- 记账分录编码
    ,check_entry_dt -- 对账日期
    ,e_acct_cd -- 电子账户代码
    ,req_flow_num -- 请求流水号
    ,ova_flow_num -- 全局流水号
    ,init_entry_flow_num -- 原记账流水号
    ,tran_type_cd -- 交易类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102043'||P1.TRANSDT||P1.MAINSEQ -- 事件编号
    ,'9999' -- 法人编号
    ,P1.MAINSEQ -- 大小额记账编号
    ,NVL(TRIM(P1.SYSID),'UNKN') -- 系统代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSDT) -- 交易日期
    ,SUBSTR( P1.TRANSTIME,9,6) -- 交易时间
    ,P1.BUSINESSTRACE -- 行内业务序号
    ,P1.BUSINESSNO -- 业务序号
    ,P1.CMTNO -- 报文类型编号
    ,P1.HOSTTRCD -- 主机交易码
    ,P1.FRONTTRCD -- 中台交易码
    ,P1.MAGEBRN -- 管理机构编号
    ,P1.USERID -- 柜员编号
    ,NVL(TRIM(P1.STATUS),'-') -- 状态代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.HOSTDATE) -- 主机日期
    ,P1.HOSTNBR -- 主机流水号
    ,P1.PAYACCT -- 付款人账号
    ,P1.PAYNAME -- 付款人名称
    ,P1.INCOACCT -- 收款人账号
    ,P1.INCONAME -- 收款人名称
    ,P1.DATAID -- 第三方标识编号
    ,P1.ERRCODE -- 错误返回编码
    ,P1.ERRMS -- 返回信息
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.COLSTS END -- 对账状态代码
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.TRANSAMT, '[0-9.]+')),0)) -- 交易金额
    ,P1.ABSCDE -- 记账分录编码
    ,${iml_schema}.DATEFORMAT_MAX(P1.COLLDT) -- 对账日期
    ,NVL(TRIM(P1.EACCFLG),'-') -- 电子账户代码
    ,P1.TRANSEQNO -- 请求流水号
    ,P1.GLOBALSEQNO -- 全局流水号
    ,P1.ORGDATAID -- 原记账流水号
    ,P1.TRNTP -- 交易类型代码
    ,P1.etl_dt as etl_dt -- ETL处理日期
    ,'mpcs_a08tfintranlist' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a08tfintranlist p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.COLSTS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A08TFINTRANLIST'
        AND R1.SRC_FIELD_EN_NAME= 'COLSTS'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_BS_AMT_ENTRY_EVT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CHECK_ENTRY_STATUS_CD'
where  1 = 1 
    and p1.etl_dt>=to_date('${batch_date}','yyyymmdd')-14 and p1.etl_dt<=to_date('${batch_date}','yyyymmdd')
;
commit;


-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bs_amt_entry_evt to ${iml_schema};


-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bs_amt_entry_evt', partname => 'p_mpcsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);