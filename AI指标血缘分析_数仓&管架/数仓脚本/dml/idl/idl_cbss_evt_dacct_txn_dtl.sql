/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_cbss_evt_dacct_txn_dtl
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
alter table ${idl_schema}.cbss_evt_dacct_txn_dtl drop partition p_${last_date};
alter table ${idl_schema}.cbss_evt_dacct_txn_dtl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.cbss_evt_dacct_txn_dtl add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.cbss_evt_dacct_txn_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,txn_dt  -- 交易日期
    ,billsq  -- 事件编号
    ,dpst_acct_num  -- 存款账户编号
    ,db_cr_flg  -- 借贷标志
    ,txn_amt  -- 交易金额
    ,acct_bal  -- 账户余额
    ,txn_ccy_cd  -- 交易币种代码
    ,cntrpty_acct_num  -- 交易对手账号
    ,cntrpty_acct_name  -- 交易对手账户名称
    ,memo_cntt  -- 摘要内容
    ,data_src_cd  -- 数据来源代码
    ,dpst_acct_id  -- 存款分户编号
    ,evt_typ_cd  -- 事件类型代码
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
with With_Dept_Kns_Tran_Fund AS
       (SELECT  t3.Trandt, --交易日期
                t3.Acctno, --账号
                t3.Crcycd, --交易币种
                t3.Tranam, --交易金额
                t3.Subsac,
                t3.Transq --交易流水
          FROM ${iol_schema}.cbss_Kns_Tran_Fund T3
         WHERE t3.etl_dt = to_date('${batch_date}','yyyymmdd')
           AND  EXISTS (SELECT 1
                  FROM ${iol_schema}.CBSS_Kna_Accs T6 --匹配存款与内部账户
                 WHERE t6.start_dt<=to_date('${batch_date}','yyyymmdd')
                 and t6.end_dt>to_date('${batch_date}','yyyymmdd')
                 and T3.Acctno = T6.Acctno
                 AND T6.Accstp IN ('0',
                                     '9'))
           AND NOT EXISTS (SELECT 1
                  FROM ${iol_schema}.CBSS_Kns_Extd T66
                 WHERE T66.etl_dt = to_date('${batch_date}','yyyymmdd')
                   AND T66.Trandt = T3.Trandt
                   AND T66.Transq = T3.Transq
                   AND T66.Amntcd IN ('C',
                                      'D',
                                      'R',
                                      'P')) --除去账务部分
        ),
   With_Bill_All AS
       (SELECT x.Trandt, --交易日期
               x.Transq, --交易流水
               x.Acctno, --账号
               x.Acctid, --账户id
               x.Crcycd, --交易币种
               x.Amntcd, --借贷标志
               x.Tranam, --交易金额
               x.Tranbl, --交易余额
               x.Billsq, --账单流水
               x.Dscrtx, --摘要描述
               x.Toacct, --对手账号
               x.Toacna, --对手户名
               'B300' Billtp, --账单类型(存款账单)
               decode(x.Tosbac,' ','xxxxx',x.Tosbac) as Tosbac, --对手子户号
               x.Smrycd --摘要码
          FROM ${iol_schema}.cbss_kdl_bill X --存款账单
          WHERE etl_dt = to_date('${batch_date}','yyyymmdd')
        ),

With_Kna_Accs AS
       ( --对手账户id
        SELECT DISTINCT  T1.Toacct,    
                         T1.Tosbac,   
                         T24.Acctna AS Toacna   
          FROM (SELECT Toacct,
                       decode(Tosbac,' ','xxxxx',Tosbac) as Tosbac
                   FROM ${iol_schema}.cbss_Kdl_Bill 
                   WHERE etl_dt = to_date('${batch_date}','yyyymmdd')
                 UNION ALL
                 SELECT Toacct,
                        decode(Tosbac,' ','xxxxx',Tosbac) as Tosbac
                   FROM ${iol_schema}.cbss_Knl_Bill 
                   WHERE etl_dt = to_date('${batch_date}','yyyymmdd')) T1
          LEFT JOIN ${iol_schema}.cbss_Kna_Acct T24
            ON T1.Toacct = T24.Acctno
            AND T24.END_DT=to_date('${batch_date}','yyyymmdd')
        )           
            
SELECT 
					  to_date('${batch_date}','yyyymmdd') as ETL_DT
            ,
             To_Date(T0.Trandt,
                     'YYYY-MM-DD') AS Txn_Dt --交易日期
            ,
             T0.Billsq AS BILLSQ 
            ,
             T0.Acctno AS Dpst_Acct_Num --存款账户编号
            ,
            
             CASE
                WHEN T0.Amntcd IN ('C',
                                   'D') THEN
                 T0.Amntcd
                ELSE
                 ' '
             END AS Db_Cr_Flg --借贷标志
            ,
             T0.Tranam AS Txn_Amt --交易金额
            ,
             T0.Tranbl AS Acct_Bal --账户余额
            ,
            decode(T0.Crcycd,'01','CNY','12','GBP','13','HKD','14','USD','15','CHF','18','SGD','27','JPY','28','CAD','29','AUD','38','EUR','43','KRW','90','RUB','XXX') AS Txn_Ccy_Cd --交易币种代码  
            ,
            T0.Toacct AS Cntrpty_Acct_Num --交易对手账号
            ,
            decode(T0.Toacna,' ',T5.Toacna,T0.Toacna) as Cntrpty_Acct_Name --交易对手账户名称
            ,
            decode(T0.Dscrtx,' ',T20.Valuna,T0.Dscrtx) as Memo_Cntt --摘要内容
            ,
            'CBSS' AS Data_Src_Cd --数据来源代码
            ,    
             T0.Acctid AS Dpst_Acct_Id --存款分户编号
             ,
             T0.Billtp AS Evt_Typ_Cd --事件类型代码
             ,
             replace(replace('CABS',chr(13),''),chr(10),'')  -- 任务代码
             ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
             
        FROM With_Bill_All T0
        JOIN ${iol_schema}.cbss_Kns_Tran T1
          ON T0.Trandt = T1.Trandt
         AND T0.Transq = T1.Transq
        LEFT JOIN With_Kna_Accs T5 --对手账号
          ON T0.Toacct = T5.Toacct
         AND T0.Tosbac = T5.Tosbac
        LEFT JOIN ${iol_schema}.cbss_Sys_Lsvl t20
          ON T20.Listcd = 'smrycd'
         AND T0.Smrycd = T20.Listvl
         AND T20.START_DT <= TO_DATE('${batch_date}','YYYYMMDD')
         AND T20.END_DT > TO_DATE('${batch_date}','YYYYMMDD')
        where t1.ETL_DT = TO_DATE('${batch_date}','YYYYMMDD')
;
commit;

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'cbss_evt_dacct_txn_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);