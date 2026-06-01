/*
Purpose:    指标模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_base_d_teller_perf_analy
CreateDate: 20220922
Logs:
    郑沛隆 2022-09-22 新建脚本 
    -- 以下为依赖了上游的表 (OGG实时表):
    MSL_nibs_IB_UPM_USER_WORKTIME
    MSL_nibs_IB_UPM_USER_INFO
    MSL_nibs_IB_UPM_POST_RLT
    ITL_EDW_CMM_TELLER_INFO
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${idl_schema}.base_d_teller_perf_analy_${batch_date}_tm purge ;

alter table ${idl_schema}.base_d_teller_perf_analy add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.base_d_teller_perf_analy_${batch_date}_tm
compress ${option_switch} for query high
as
select
    *
from ${idl_schema}.base_d_teller_perf_analy
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- 主表处理

INSERT INTO ${idl_schema}.base_d_teller_perf_analy_${batch_date}_tm
    (teller_no --VARCHAR2(10) 柜员号   
    ,teller_name --VARCHAR2(150)柜员名称 
    ,sign_dt --DATE         签到日期 
    ,tot_duran --NUMBER(16,2) 总时长   
    ,td_sign_in_cnt --NUMBER       当天签到次数 
    ,td_sign_out_cnt --NUMBER       当天签退次数 
    ,td_fir_sign_in_tm --DATE         当天首次签到时间 
    ,td_final_sign_out_tm --DATE         当天最后签退时间 
    ,onl_tot_duran --NUMBER(16,2) 在线总时长 
    ,onl_tran_duran --NUMBER(16,2) 在线交易时长 
    ,onl_null_duran --NUMBER(16,2) 在线空闲时长 
    ,offl_duran --NUMBER(16,2) 离柜时长 
    ,td_fir_tran_tm --DATE         当天首次交易时间 
    ,td_final_tran_tm --DATE         当天最后交易时间 
    ,org_no --VARCHAR2(6)  所属机构号 
    ,etl_dt --DATE         ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6) ETL处理时间戳 
     )
    SELECT w.USERNUM
      , --柜员号
       u.SURNAME || '' || u.username
      , --柜员名称
        TO_DATE(w.LOGINDATESTR,'yyyymmdd')
      , --签到日期   
       sum(ROUND(w.TOTALTIMESECOND / 60)) AS tot_duran --总时长
      ,null as td_sign_in_cnt --当天签退次数
      ,null as td_sign_out_cnt --当天签退次数
      ,w.LOGINTIME as td_fir_sign_in_tm --当天首次签到时间
      ,null AS td_final_sign_out_tm --当天最后签退时间   
      ,null AS onl_tot_duran --在线总时长 
      ,SUM(ROUND(w.TRANTIMESECOND / 60)) --在线交易时长 
      ,SUM(ROUND(w.ONLINELEISURESECOND / 60)) AS onl_null_duran --在线空闲时长 
      ,SUM(ROUND(w.LEVELTIMESECOND / 60)) AS offl_duran --离柜时长 
      ,null --当天首次交易时间 
      ,null --当天最后交易时间 
      , (CASE
          WHEN substr(w.BRANCHNUM, 1, 2) = '89' OR w.BRANCHNUM = '800001' THEN
           '800'
          ELSE
           w.BRANCHNUM
        END) AS org_no --所属机构号 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳
     FROM MSL_nibs_IB_UPM_USER_WORKTIME w
 INNER JOIN MSL_nibs_IB_UPM_USER_INFO u
    ON w.usernum = u.usernum
 INNER JOIN MSL_nibs_IB_UPM_POST_RLT r
    ON w.usernum = r.usernum
 INNER JOIN ITL_EDW_CMM_TELLER_INFO T3
    ON u.USERNUM = T3.TELLER_ID 
    AND T3.TELLER_TYPE_CD = 'TELLER_USER'
 WHERE w.LOGINDATESTR =${batch_date} AND
       r.postnum IN ('2013'
                    ,'2020'
                    ,'2012'
                    ,'3010'
                    ,'2032'
                    ,'3014'
                    ,'3011'
                    ,'1023'
                    ,'2023')
    GROUP BY w.USERNUM,u.SURNAME || '' || u.username,w.LOGINDATESTR,w.BRANCHNUM,w.LOGINTIME;
COMMIT;

-- 3.2 truncate target table batch_date partition
alter table ${idl_schema}.base_d_teller_perf_analy truncate partition p_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${idl_schema}.base_d_teller_perf_analy exchange partition p_${batch_date} with table ${idl_schema}.base_d_teller_perf_analy_${batch_date}_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.base_d_teller_perf_analy to ${idl_schema};

-- 4.2 drop tm table
drop table ${idl_schema}.base_d_teller_perf_analy_${batch_date}_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'base_d_teller_perf_analy', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);