/*
Purpose:    指标模型层-ATM业务情况明细，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_base_d_atm_bus_situ_dtl
CreateDate: 20210705
修改记录：
    郑沛隆 2021-07-05 新建脚本 
    依赖于源表：
    ITL_EDW_EVT_ATMP_UNIONPAY_TRAN_FLOW
    MSL_MPCS_A50TTRNCDMAP
    ITL_EDW_CMM_DEP_ACCT_INFO
    MSL_MPCS_A50UBCARDBIN
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${idl_schema}.base_d_atm_bus_situ_dtl_${batch_date}_tm purge ;
alter table ${idl_schema}.base_d_atm_bus_situ_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.base_d_atm_bus_situ_dtl_${batch_date}_tm
compress ${option_switch} for query high
as
select
    *
from ${idl_schema}.base_d_atm_bus_situ_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table

INSERT INTO ${idl_schema}.base_d_atm_bus_situ_dtl_${batch_date}_tm
    (tran_type --VARCHAR2(10) 交易类型 
    ,cross_bank_idf --VARCHAR2(10) 跨行标识 
    ,tran_tm --DATE         交易时间 
    ,tran_org_cd --VARCHAR2(20) 交易机构代码 
    ,tran_amt --NUMBER(38,8) 交易金额 
    ,proc_termn_id --VARCHAR2(20) 受理终端编号 
    ,cust_id --VARCHAR2(30) 客户编号 
    ,cust_name --VARCHAR2(100)客户名称 
    ,open_acct_org --VARCHAR2(20) 开户机构 
    ,main_acct_id --VARCHAR2(100)主账户编号 
    ,expns_acct_id --VARCHAR2(100)支出账户编号 
    ,depot_acct_id --VARCHAR2(100)存入账户编号 
    ,city_wide_remote_idf --VARCHAR2(10) 同城异地标识 
    ,dim_class 
		,dim_class_name --VARCHAR2(100) 交易类型分类名称(管驾用) 
    ,etl_dt --DATE         ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6) ETL处理时间戳 
     )

    SELECT b.trnname AS tran_type --交易类型
          ,decode(a.cross_bank_flg,'1','是','否') AS cross_bank_idf --跨行标志 --1是 0否
          ,to_date(substr(a.tran_tm,1,14),'yyyy-MM-dd hh24:mi:ss') AS tran_tm --交易时间
          ,a.tran_org_id AS tran_org_cd --交易机构代码
          ,a.tran_amt AS tran_amt --交易金额
          ,a.proc_termn_id AS proc_termn_id --受理终端编号
          ,c.acct_id AS cust_id --客户编号
          ,c.acct_name AS cust_name --客户名称
          ,c.open_acct_org_id AS open_acct_org --开户机构编号
          ,a.main_acct_id AS main_acct_id --主账户编号
          ,a.expns_acct_id AS expns_acct_id --支出账户编号
          ,a.depot_acct_id AS depot_acct_id --存入账户编号
          , (CASE
               WHEN substr(c.open_acct_org_id
                          ,1
                          ,3) = substr(a.tran_org_id
                                      ,1
                                      ,3) THEN
                '同城'
               ELSE
                '异地'
           END) AS city_wide_remote_idf --同城异地标识 --1同城 0异地
          ,decode(fun_code_conv(b.trnname,null),'转账','ATM_ZZ','取款','ATM_QK','存款','ATM_CK','查询','ATM_CX','ATM_QT') as dim_class
          ,fun_code_conv(b.trnname,null) as dim_class_name --交易类型分类名称(管驾用) 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   itl_edw_evt_atmp_unionpay_tran_flow a
    LEFT   JOIN msl_mpcs_a50ttrncdmap b
    ON     substr(a.intnal_tran_cd
                 ,4) = substr(b.trncd
                             ,4)
    LEFT   JOIN itl_edw_cmm_dep_acct_info c
     ON c.cust_acct_id = a.main_acct_id
    and  c.cust_acct_card_no=replace(a.main_acct_id,' ','1234567890')
    WHERE  a.tran_status_cd = '1'
    AND    tran_type_cd = '02'
    AND    (intnal_proc_cd <> 'up9999' OR
          (trncd = 'ZTSA50F07' AND --二维码取款
          substr(a.main_acct_id
                   ,1
                   ,6) IN
          (SELECT pinblock FROM msl_mpcs_a50ubcardbin)))
    AND    b.chnlid = 'ATM'
    AND    C.CUST_ACCT_SUB_ACCT_NUM = '1'
    AND    C.ETL_DT=to_date('${batch_date}','yyyymmdd')
    AND    A.ETL_DT=to_date('${batch_date}','yyyymmdd')
    AND    substr(a.tran_tm, 1,8) ='${batch_date}';

COMMIT;




-- 3.2 truncate target table batch_date partition
alter table ${idl_schema}.base_d_atm_bus_situ_dtl truncate partition p_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${idl_schema}.base_d_atm_bus_situ_dtl exchange partition p_${batch_date} with table ${idl_schema}.base_d_atm_bus_situ_dtl_${batch_date}_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.base_d_atm_bus_situ_dtl to ${idl_schema};

-- 4.2 drop tm table
drop table ${idl_schema}.base_d_atm_bus_situ_dtl_${batch_date}_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'base_d_atm_bus_situ_dtl', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);