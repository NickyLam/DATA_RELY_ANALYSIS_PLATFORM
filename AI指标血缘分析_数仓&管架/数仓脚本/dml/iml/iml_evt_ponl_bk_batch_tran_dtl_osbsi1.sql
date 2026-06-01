/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ponl_bk_batch_tran_dtl_osbsi1
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
drop table ${iml_schema}.evt_ponl_bk_batch_tran_dtl_osbsi1_tm purge;
alter table ${iml_schema}.evt_ponl_bk_batch_tran_dtl add partition p_osbsi1 values ('osbsi1')(
        subpartition p_osbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ponl_bk_batch_tran_dtl modify partition p_osbsi1
    add subpartition p_osbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
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
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_ponl_bk_batch_tran_dtl'') and subpartition_name = upper(''p_osbsi1_'||bat_dt||''') ';
    dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_ponl_bk_batch_tran_dtl truncate subpartition p_osbsi1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iml.evt_ponl_bk_batch_tran_dtl modify partition p_osbsi1 add subpartition p_osbsi1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
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
-- osbs_tps_batch_detail-1
insert into ${iml_schema}.evt_ponl_bk_batch_tran_dtl(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,dtl_flow_num -- 明细流水号
    ,onl_bank_tran_flow_num -- 网银交易流水号
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,pay_acct_type_cd -- 付款账户类型代码
    ,curr_cd -- 币种代码
    ,pay_dept_id -- 付款部门编号
    ,pay_ec_idf_cd -- 付款钞汇标识代码
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_cust_type_cd -- 收款客户类型代码
    ,recv_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行名称
    ,recv_bank_prov_cd -- 收款行省份代码
    ,recv_bank_prov_name -- 收款行省份名称
    ,recv_bank_city_cd -- 收款行城市代码
    ,recv_bank_city_name -- 收款行城市名称
    ,recv_bank_brac_id -- 收款行网点编号
    ,recv_bank_brac_name -- 收款行网点名称
    ,recvbl_clear_bk_no -- 收款清算行行号
    ,recver_mobile_no -- 收款人手机号码
    ,tran_amt -- 交易金额
    ,tran_fee -- 交易费
    ,postsc -- 附言
    ,remark -- 备注
    ,tran_code -- 交易码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,save_recver_flg -- 保存收款人标志
    ,advise_recver_flg -- 通知收款人标志
    ,dtl_status_cd -- 明细状态代码
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,proc_start_tm -- 处理开始时间
    ,proc_end_tm -- 处理结束时间
    ,proc_flow_num -- 处理流水号
    ,core_tran_flow_num -- 核心交易流水号
    ,core_tran_dt -- 核心交易日期
    ,tran_out_way_cd -- 转出方式代码
    ,tran_out_dt -- 转出日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104041'||P1.TBD_BATCHNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TBD_BATCHNO -- 批次编号
    ,P1.TBD_DETAILNO -- 明细流水号
    ,P1.TBD_FLOWNO -- 网银交易流水号
    ,P1.TBD_PAYERACNO -- 付款账户编号
    ,P1.TBD_PAYERACNAME -- 付款账户名称
    ,NVL(P1.TBD_PAYERBANKACTYPE,'-') -- 付款账户类型代码
    ,NVL(P1.TBD_CURRENCY,'-') -- 币种代码
    ,P1.TBD_PAYERDEPTID -- 付款部门编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TBD_PAYERCRFLAG END -- 付款钞汇标识代码
    ,P1.TBD_PAYEEACNO -- 收款账户编号
    ,P1.TBD_PAYEEACNAME -- 收款账户名称
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.TBD_PAYEEBANKACTYPE END -- 收款账户类型代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.TBD_PAYEECIFTYPE END -- 收款客户类型代码
    ,P1.TBD_PAYEEBANKID -- 收款行行号
    ,P1.TBD_PAYEEBANKNAME -- 收款行名称
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.TBD_PAYEEPROVINCECODE END -- 收款行省份代码
    ,P1.TBD_PAYEEPROVINCENAME -- 收款行省份名称
    ,NVL(P1.TBD_PAYEECITYCODE,'0000') -- 收款行城市代码
    ,P1.TBD_PAYEECITYNAME -- 收款行城市名称
    ,P1.TBD_PAYEEUNIONDEPTID -- 收款行网点编号
    ,P1.TBD_PAYEEUNIONDEPTNAME -- 收款行网点名称
    ,P1.TBD_PAYEECLEARBANKID -- 收款清算行行号
    ,P1.TBD_PAYEEMOBILE -- 收款人手机号码
    ,P1.TBD_AMOUNT -- 交易金额
    ,P1.TBD_FEE -- 交易费
    ,P1.TBD_NOTECODE -- 附言
    ,P1.TBD_REMARK -- 备注
    ,P1.TBD_TRANSCODE -- 交易码
    ,${iml_schema}.DATEFORMAT_MIN(substr(P1.TBD_TRANSDATE,1,8)) -- 交易日期
    ,${iml_schema}.timeformat_min(p1.TBD_TRANSTIME) -- 交易时间
    ,P1.TBD_SAVEPAYEEFLAG -- 保存收款人标志
    ,P1.TBD_NOTIFYPAYEEFLAG -- 通知收款人标志
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.TBD_DETAILSTATE END -- 明细状态代码
    ,P1.TBD_RETURNCODE -- 返回码
    ,P1.TBD_RETURNMSG -- 返回信息
    ,${iml_schema}.timeformat_min(p1.TBD_PROCESSSTARTTIME) -- 处理开始时间
    ,${iml_schema}.timeformat_min(p1.TBD_PROCESSENDTIME) -- 处理结束时间
    ,P1.TBD_PROCESSJNLNO -- 处理流水号
    ,P1.TBD_HOSTJNLNO -- 核心交易流水号
    ,${iml_schema}.DATEFORMAT_MIN(substr(P1.TBD_HOSTDATE,1,8)) -- 核心交易日期
    ,P1.TBD_TRANSFERTYPE -- 转出方式代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.TBD_TRANSFERDATE) -- 转出日期
    ,to_date(substr(p1.TBD_TRANSDATE,1,8),'yyyymmdd') as etl_dt -- ETL处理日期
    ,'osbs_tps_batch_detail' -- 源表名称
    ,'osbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.osbs_tps_batch_detail p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TBD_PAYERCRFLAG = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'OSBS'
        AND R1.SRC_TAB_EN_NAME= 'OSBS_TPS_BATCH_DETAIL'
        AND R1.SRC_FIELD_EN_NAME= 'TBD_PAYERCRFLAG'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_PONL_BK_BATCH_TRAN_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PAY_EC_IDF_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.TBD_PAYEEBANKACTYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'OSBS'
        AND R2.SRC_TAB_EN_NAME= 'OSBS_TPS_BATCH_DETAIL'
        AND R2.SRC_FIELD_EN_NAME= 'TBD_PAYEEBANKACTYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_PONL_BK_BATCH_TRAN_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'RECVBL_ACCT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.TBD_PAYEECIFTYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'OSBS'
        AND R3.SRC_TAB_EN_NAME= 'OSBS_TPS_BATCH_DETAIL'
        AND R3.SRC_FIELD_EN_NAME= 'TBD_PAYEECIFTYPE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_PONL_BK_BATCH_TRAN_DTL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'RECVBL_CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.TBD_PAYEEPROVINCECODE = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'OSBS'
        AND R4.SRC_TAB_EN_NAME= 'OSBS_TPS_BATCH_DETAIL'
        AND R4.SRC_FIELD_EN_NAME= 'TBD_PAYEEPROVINCECODE'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_PONL_BK_BATCH_TRAN_DTL'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'RECV_BANK_PROV_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.TBD_DETAILSTATE = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'OSBS'
        AND R5.SRC_TAB_EN_NAME= 'OSBS_TPS_BATCH_DETAIL'
        AND R5.SRC_FIELD_EN_NAME= 'TBD_DETAILSTATE'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_PONL_BK_BATCH_TRAN_DTL'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'DTL_STATUS_CD'
where  1 = 1 
     and p1.start_dt<=to_date('${batch_date}','yyyymmdd') and p1.end_dt>to_date('${batch_date}','yyyymmdd')
     and to_date(substr(p1.TBD_TRANSDATE,1,8),'yyyymmdd')>= to_date('${batch_date}','yyyymmdd')-14
     and to_date(substr(p1.TBD_TRANSDATE,1,8),'yyyymmdd')<= to_date('${batch_date}','yyyymmdd')
;
commit;



-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ponl_bk_batch_tran_dtl to ${iml_schema};


-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ponl_bk_batch_tran_dtl', partname => 'p_osbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);