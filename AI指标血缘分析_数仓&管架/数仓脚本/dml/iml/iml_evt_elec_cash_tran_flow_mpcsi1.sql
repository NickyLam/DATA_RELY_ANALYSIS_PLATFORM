/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_elec_cash_tran_flow_mpcsi1
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

alter table ${iml_schema}.evt_elec_cash_tran_flow add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_elec_cash_tran_flow modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

set serveroutput on
--set line 200;
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
--dbms_output.put_line('BBB');
for i in 0 .. 8 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_elec_cash_tran_flow'') and subpartition_name = ''P_MPCSI1_'||bat_dt||''' ';
    dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_elec_cash_tran_flow truncate subpartition P_MPCSI1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iml.evt_elec_cash_tran_flow modify partition p_mpcsi1 add subpartition P_MPCSI1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
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
-- mpcs_a51ubelecashtranlog-1
insert into ${iml_schema}.evt_elec_cash_tran_flow(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sys_follow_id -- 系统跟踪编号
    ,trader_type_cd -- 交易方类型代码
    ,send_org_id -- 发送机构编号
    ,proc_org_id -- 受理机构编号
    ,tran_tm -- 交易时间
    ,clear_dt -- 清算日期
    ,doc_dt -- 文件日期
    ,tran_dt -- 交易日期
    ,card_no -- 卡号
    ,card_seq_no -- 卡序号
    ,tran_type_cd -- 交易类型代码
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,check_rest_cd -- 校验结果代码
    ,clear_amt -- 清算金额
    ,clear_curr_cd -- 清算币种代码
    ,clear_status_cd -- 清算状态代码
    ,fee_rat -- 费率
    ,mercht_type_cd -- 商户类型代码
    ,termn_id -- 终端编号
    ,mercht_id -- 商户编号
    ,init_tran_type_cd -- 原交易类型代码
    ,init_sys_follow_id -- 原系统跟踪编号
    ,init_tran_clear_dt -- 原交易清算日期
    ,init_tran_tm -- 原交易时间
    ,comm_fee_amt -- 手续费金额
    ,card_holder_deduct_exch_rat -- 持卡人扣款汇率
    ,card_holder_deduct_amt -- 持卡人扣款金额
    ,card_holder_curr_cd -- 持卡人币种代码
    ,open_acct_org_id -- 开户机构编号
    ,host_tran_dt -- 主机交易日期
    ,host_tran_flow -- 主机交易流水号
    ,core_flow_num -- 核心流水号
    ,err_cd -- 错误码
    ,err_info_desc -- 错误信息描述
    ,entry_status_cd -- 记账状态代码
    ,td_rtn_goods_flg -- 当天退货标志
    ,ghb_exch_fee -- 本方交换费
    ,tran_clear_fee -- 转接清算费
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201019'||p1.SYSTRACE||p1.FWDINSTID||p1.ACQINSTID||p1.TRANSTIME||p1.SETTLMTDATE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SYSTRACE -- 系统跟踪编号
    ,P1.GATETYPE -- 交易方标识代码
    ,P1.FWDINSTID -- 发送机构编号
    ,P1.ACQINSTID -- 受理机构编号
    ,P1.TRANSTIME -- 交易时间
    ,${iml_schema}.dateformat_max2(P1.SETTLMTDATE) -- 清算日期
    ,${iml_schema}.dateformat_max2(P1.FILEDATE) -- 文件日期
    ,${iml_schema}.dateformat_max2(P1.TRANDATE) -- 交易日期
    ,P1.PRIACCT -- 卡号
    ,P1.CARDSQ -- 卡序号
    ,P1.TRANTP -- 交易类型代码
    ,P1.CRCYCD -- 币种代码
    ,P1.TRANAM -- 交易金额
    ,P1.PROVSTATUS -- 校验结果代码
    ,P1.SETTLMTAMT -- 清算金额
    ,P1.SETTLMTCY -- 清算币种代码
    ,P1.QSSTATUS -- 清算状态代码
    ,P1.RATEFEEAMT -- 费率
    ,P1.MERCTP -- 商户类型代码
    ,P1.TERMID -- 终端编号
    ,P1.MERCID -- 商户编号
    ,P1.OLDTRANTP -- 原交易类型代码
    ,P1.OLDSYSTRACE -- 原系统跟踪编号
    ,${iml_schema}.dateformat_max2(P1.OLDSETTLMTDATE) -- 原交易清算日期
    ,P1.OLDTRANSTIME -- 原交易时间
    ,P1.FEEAMT -- 手续费金额
    ,NVL(TRIM(P1.CARDHOLDRATE),0) -- 持卡人扣款汇率
    ,P1.CARDHOLDAMT -- 持卡人扣款金额
    ,P1.CARDHOLDCY -- 持卡人币种代码
    ,P1.OPENBRN -- 开户机构编号
    ,${iml_schema}.dateformat_max2(P1.HOSTDATE) -- 主机交易日期
    ,P1.HOSTNBR -- 主机交易流水号
    ,P1.DATAID -- 核心流水号
    ,P1.ERRCODE -- 错误码
    ,P1.ERRMSG -- 错误信息描述
    ,P1.OPSTATUS -- 记账状态代码
    ,P1.RETRFLG -- 当天退货标志
    ,P1.TRANEXAMT -- 本方交换费
    ,P1.COVAMT -- 转接清算费
    ,P1.ETL_DT as etl_dt -- ETL处理日期
    ,'mpcs_a51ubelecashtranlog' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.mpcs_a51ubelecashtranlog p1
 where 1 = 1
   and p1.etl_dt >= to_date('${batch_date}', 'yyyymmdd') - 8
   and p1.etl_dt <= to_date('${batch_date}', 'yyyymmdd')
   ;
commit;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_elec_cash_tran_flow', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);