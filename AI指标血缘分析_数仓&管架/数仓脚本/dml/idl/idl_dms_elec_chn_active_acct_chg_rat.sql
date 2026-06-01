/*
Purpose:    动态监测系统-主要电子渠道活跃用户账户变化率表
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_dms_elec_chn_active_acct_chg_rat
Createdate: 20191025
Logs:

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.dms_elec_chn_active_acct_chg_rat drop partition p_${last_date};
alter table ${idl_schema}.dms_elec_chn_active_acct_chg_rat drop partition p_${batch_date};

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.dms_elec_chn_active_acct_chg_rat add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${idl_schema}.dms_elec_chn_active_acct_chg_rat_ex purge;
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dms_elec_chn_active_acct_chg_rat_ex
nologging
compress ${option_switch} for query high
as
select * from ${idl_schema}.dms_elec_chn_active_acct_chg_rat where 0=1;

-- 2.1.1 insert into ex table(第一组（共三组）网上银行交易量）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.dms_elec_chn_active_acct_chg_rat_ex(
       etl_dt           --数据日期
      ,chn_type         --渠道类型  
      ,chn_id           --渠道编号  
      ,chn_tran_qtty    --渠道交易量
      ,etl_timestamp  --ETL处理时间戳
)
select to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
      ,t1.chn_type --渠道类型
      ,t1.chn_id --渠道编号
      ,t1.chn_tran_qtty --渠道交易量
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间戳
  from (select 'ECAUCR' as chn_type,
       '1' as chn_id,
       sum(chn_tran_qtty) as chn_tran_qtty
          from (select count(*) as chn_tran_qtty
                  from (select clf_ecifno AS "客户号", count(*) AS "登录次数"
                          from ${iol_schema}.tbps_cpr_login_flow
                         where clf_date >= substr('${batch_date}', 1, 6) || '01'
                           and clf_date <= '${batch_date}'
                           and clf_state = '0'
                         group by clf_ecifno)
                 union all
                select count(*) as chn_tran_qtty
                  from (select plf_channel, b.plf_ecifno, count(*)
                          from ${iol_schema}.tbws_pbs_logon_flow b
                         where b.plf_logondate >= substr('${batch_date}', 1, 6) || '01000000'
                           and b.plf_logondate < to_char(to_date('${batch_date}', 'yyyymmdd') + 1, 'yyyymmdd') || '000000'
                           and b.plf_channel = 'NPB'
                         group by plf_channel, b.plf_ecifno
                         order by plf_channel, b.plf_ecifno)
         group by plf_channel)) t1
;
commit;

-- 2.1.2 insert into ex table(第二组（共三组）电话银行交易量）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.dms_elec_chn_active_acct_chg_rat_ex(
       etl_dt           --数据日期
      ,chn_type         --渠道类型  
      ,chn_id           --渠道编号  
      ,chn_tran_qtty    --渠道交易量
      ,etl_timestamp  --ETL处理时间戳
)
select to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
      ,t1.chn_type --渠道类型
      ,t1.chn_id --渠道编号
      ,t1.chn_tran_qtty --渠道交易量
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间戳
  from (select 'ECAUCR' as chn_type,
               '2' as chn_id,
               sum(chn_tran_qtty) as chn_tran_qtty
          from (select count(*) as chn_tran_qtty
                  from (select paper_id, count(cti_connection_id) couNm
                          from ${iol_schema}.ccdb_log_ivr_comm
                         where to_char(call_time,'YYYYMM') = substr('${batch_date}', 1, 6)
                           and cti_connection_id is not null --有效会话 
                           and paper_id is not null --有实名进线
                           and is_to_agent='0' --纯IVR活动，没有转人工
                         group by paper_id
                         order by couNm desc)
                 union
                select count(*) as chn_tran_qtty
                  from (select cust_paper_id, count(connect_id) couNm
                          from ${iol_schema}.ccdb_log_call_worksum
                         where to_char(to_date(tsringtime,'YYYY-MM-dd hh24:mi:ss'),'YYYYMM') = substr('${batch_date}', 1, 6)
                           and connect_id is not null --有效会话 
                           and cust_paper_id is not null --有实名进线
                           and tsringtime is not null --振铃时间
                           and call_type !='3' --呼入，3为呼出
                         group by cust_paper_id
                         order by couNm desc)
                 union all
                 select count(*) as chn_tran_qtty
                   from (select holder_no "曾登录客户卡号", count(connect_id) AS "客户登录次数"
                           from ${iol_schema}.ccss_log_tran_com t
                          where to_char(t.channel_send_date, 'yyyymm') = substr('${batch_date}', 1, 6)
                            and holder_no is not null
                            and t.connect_id is not null
                          group by t.holder_no
                          order by holder_no)
               )
       ) t1
;
commit;

-- 2.1.3 insert into ex table(第三组（共三组）手机银行交易量）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.dms_elec_chn_active_acct_chg_rat_ex(
       etl_dt           --数据日期
      ,chn_type         --渠道类型  
      ,chn_id           --渠道编号  
      ,chn_tran_qtty    --渠道交易量
      ,etl_timestamp  --ETL处理时间戳
)
select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,t1.chn_type
      ,t1.chn_id
      ,t1.chn_tran_qtty
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间戳
  from (select 'ECAUCR' as chn_type,
               '3' as chn_id,
                count(*) as chn_tran_qtty
          from (select plf_channel, b.plf_ecifno, count(*)
                  from ${iol_schema}.tbws_pbs_logon_flow b
                 where b.plf_logondate >= substr('${batch_date}', 1, 6) || '01000000'
                   and b.plf_logondate < to_char(to_date('${batch_date}', 'yyyymmdd') + 1, 'yyyymmdd') || '000000'
                   and b.plf_channel = 'NMB'
                 group by plf_channel, b.plf_ecifno
                 order by plf_channel, b.plf_ecifno)
 group by plf_channel) t1
;
commit;

-- 2.3 exchage ex table and target table
alter table ${idl_schema}.dms_elec_chn_active_acct_chg_rat exchange partition p_${batch_date} with table ${idl_schema}.dms_elec_chn_active_acct_chg_rat_ex;

-- 3.1 drop ex table
drop table ${idl_schema}.dms_elec_chn_active_acct_chg_rat_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'dms_elec_chn_active_acct_chg_rat', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);