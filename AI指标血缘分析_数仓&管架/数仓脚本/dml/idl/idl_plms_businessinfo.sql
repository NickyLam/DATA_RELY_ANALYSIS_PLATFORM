/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_plms_businessinfo
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
alter table ${idl_schema}.plms_businessinfo drop partition p_${last_date};
alter table ${idl_schema}.plms_businessinfo drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.plms_businessinfo add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none;
drop table ${idl_schema}.tmp_plms_businessinfo_01 purge;
drop table ${idl_schema}.tmp_plms_businessinfo_02 purge;
drop table ${idl_schema}.tmp_plms_businessinfo_03 purge;
drop table ${idl_schema}.tmp_plms_businessinfo_04 purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_plms_businessinfo_01(
  duebillserialno varchar2(20)
 ,nextdate varchar2(18)
)
nologging
compress ${option_switch} for query high
;
-- 1.2 insert data to temp table
insert /*+ append */ into ${idl_schema}.tmp_plms_businessinfo_01(
 duebillserialno  --借据号
 ,nextdate --执行日期    
)
 select rp.duebillserialno --借据号
 ,max(rp.executiondate) as nextdate  --执行日期
 from (
           select a.duebillserialno
            ,case when  b.periodinterestsum is null 
                     or (b.periodinterestsum is not null 
                     and a.periodinterestsum<>0 
                     and a.periodinterestsum<>b.periodinterestsum
                         )
             then a.bgindt
             else b.startdate
             end as bgindt
            ,a.executiondate
            ,a.periodsum
            ,case when a.periodinterestsum=0 and b.periodinterestsum is not null 
                  then b.periodinterestsum
                  else a.periodinterestsum 
                  end as periodinterestsum
         from (
            select lf.lncfno as duebillserialno        --借据号
                      ,sn.bgindt           --起息日期 
                      ,sn.schedt  as   executiondate  --执行日期 
                      ,nvl(sn.corpam,0)  as   periodsum  --本期应收本金 
                      ,nvl(sn.instam,0)  as   periodinterestsum  --执行利率 
                      ,sn.termno    --期号 
                      ,sn.std_crcycd     
                      ,sn.accrbl       --应计正常本金 
        from (select a.*
                          ,'ACCT'||acctid as agreement_id
                          ,termno as agreement_dcrt_sgh
                          ,b.ods_std_cd as std_crcycd 
            from ${iol_schema}.cbss_lnb_sbln a
            left join ${idl_schema}.p_ods_currency_src2std b
            on a.crcycd=b.source_cd 
            and b.src_system_id='CBS'
            where  a.start_dt<=to_date('${batch_date}','yyyymmdd') 
                 and a.end_dt>to_date('${batch_date}','yyyymmdd')
            ) sn     --分期贷款还款计划表
            left join (select a.*
                      ,'ACCT'||acctid as agreement_id
                      ,b.ods_std_cd as std_crcycd 
            from ${iol_schema}.cbss_lnb_lncf a
            left join ${idl_schema}.p_ods_currency_src2std b
            on a.crcycd=b.source_cd
            and b.src_system_id='CBS'
            where  a.start_dt<=to_date('${batch_date}','yyyymmdd') 
                  and a.end_dt>to_date('${batch_date}','yyyymmdd')
            ) lf   --贷款账户基本信息
                  on sn.acctid = lf.acctid      --账号id                   
            )a
            left join (select a.*
                             ,b.ods_std_cd as std_crcycd  
                   from ${iol_schema}.crss_difrepayment_plan_info a 
            left join ${idl_schema}.p_ods_currency_src2std b
            on a.businesscurrency=b.source_cd
            and b.src_system_id='CMS'
            where  a.start_dt<=to_date('${batch_date}','yyyymmdd') 
                   and a.end_dt>to_date('${batch_date}','yyyymmdd')
            ) b
            on a.duebillserialno=b.duebillserialno
            and a.executiondate=b.executiondate
            and a.std_crcycd=b.std_crcycd
          ) rp
          where  rp.executiondate>'${batch_date}'
               and rp.periodinterestsum<>0
               group by rp.duebillserialno 
;
commit;
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_plms_businessinfo_02(
   acctno  varchar2(40)
  ,lastbl  number
  ,acctbl  number
)
nologging
compress ${option_switch} for query high
;
-- 1.3 insert data to temp table
insert /*+ append */ into ${idl_schema}.tmp_plms_businessinfo_02(
   acctno 
  ,lastbl 
  ,acctbl
)
select f.acctno
       ,sum(case 
                 when q.bltype = 'D1' 
                 and q.modutp in ('1','3')  
                 then q.lastbl*nvl(g.hl,1)
                 else 0
                 end) as lastbl --正常本金
       ,sum(case 
                 when e.acctst = '3' or e.accst2 = '2' 
                 then 0 --全部冻结、全部止付
                 else 
                      case 
                      when q.bltype = 'D5' 
                      then q.lastbl*nvl(g.hl,1)--冻结余额
                      else 0
                      end
                 end) as acctbl
from  ${iol_schema}.cbss_kna_acct_lsbl q 
     left join ${iol_schema}.cbss_kna_dpac e 
         on e.acctid = q.acctid 
         and e.start_dt<=to_date('${batch_date}','yyyymmdd') 
         and e.end_dt>to_date('${batch_date}','yyyymmdd')
    left join (select a.*
                      ,b.ods_std_cd as std_crcycd 
               from ${iol_schema}.cbss_kna_accs a
               left join ${idl_schema}.p_ods_currency_src2std b
               on a.crcycd=b.source_cd
               where b.src_system_id = 'CBS'
               ) f 
        on q.acctid=f.acctid 
        and f.start_dt<=to_date('${batch_date}','yyyymmdd') 
        and f.end_dt>to_date('${batch_date}','yyyymmdd')
    left join ${idl_schema}.t_d_cm_exrt_cvrt_dt g 
        on f.std_crcycd=g.curr_code
        and g.zb='CN'
        and g.etl_dt=to_date('${batch_date}','yyyymmdd') 
        where q.bltype in ('D1','D5')
        and q.start_dt<=to_date('${batch_date}','yyyymmdd') 
        and q.end_dt>to_date('${batch_date}','yyyymmdd')
        group by f.acctno
;
commit;


whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_plms_businessinfo_03(
   acctno      varchar2(40)
  ,std_crcycd  varchar2(10)
  ,tranam      number(18,2)
)
nologging
compress ${option_switch} for query high
;
-- 1.3 insert data to temp table
insert /*+ append */ into ${idl_schema}.tmp_plms_businessinfo_03(
    acctno 
   ,std_crcycd  
   ,tranam 
)
select 
  bill.acctno
 ,bill.std_crcycd
 ,sum(bill.tranam) as tranam
from (select a.*
            ,'EVT'||trandt||billsq as event_id
            ,b.ods_std_cd as std_crcycd 
      from ${iol_schema}.cbss_lns_bill a
      left join ${idl_schema}.p_ods_currency_src2std b
           on  a.crcycd=b.source_cd
           and b.src_system_id='CBS'
      where not exists (select 1 from IOL.CBSS_LNB_LNCF lncf WHERE lncf.PRODCD = '130001' and lncf.ACCTID=a.ACCTID and lncf.start_dt<=to_date('${batch_date}','yyyymmdd') and lncf.end_dt>to_date('${batch_date}','yyyymmdd'))
     ) bill
where bill.amntcd = 'C'
and bill.billtp in ('P')
and bill.strktg = '0' 
group by  bill.std_crcycd
         ,bill.acctno   
;
commit;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_plms_businessinfo_04(
   acctno      varchar2(40)
  ,std_crcycd  varchar2(10)
  ,tranam      number(18,2)
)
nologging
compress ${option_switch} for query high
;
-- 1.3 insert data to temp table
insert /*+ append */ into ${idl_schema}.tmp_plms_businessinfo_04(
         acctno
        ,std_crcycd
        ,tranam 
     )
select 
         bill.acctno
        ,bill.std_crcycd
        ,sum(tranam) as tranam
from  (select a.*
             ,'EVT'||trandt||billsq as event_id
             ,b.ods_std_cd as std_crcycd 
            from ${iol_schema}.cbss_lns_bill a
            left join ${idl_schema}.p_ods_currency_src2std b
                 on  a.crcycd=b.source_cd
                 AND b.src_system_id='CBS'
            where not exists (select 1 from IOL.CBSS_LNB_LNCF lncf WHERE lncf.PRODCD = '130001' and lncf.ACCTID=a.ACCTID and lncf.start_dt<=to_date('${batch_date}','yyyymmdd') and lncf.end_dt>to_date('${batch_date}','yyyymmdd'))
            ) bill
     where bill.amntcd = 'C'
     and bill.billtp in ('I','F')
     and bill.strktg = '0'
     group by bill.std_crcycd
             ,bill.acctno     
;
commit;

--第一组
-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.plms_businessinfo partition for (to_date('${batch_date}','yyyymmdd')) (
         duebillno  -- 借据号
         ,intdate  -- 执行日期
         ,accountbalance  -- 还款账户余额
         ,accountuserbalance  -- 还款账户可用余额
         ,termtype  -- 贷款类型码
         ,termmonthtype  -- 期限代码
         ,tatimes  -- 借据上次状态
         ,insum  -- 发生额
         ,interestinsum  -- 发生额
         ,finishdate  -- 约定还款到期日
         ,etl_dt  -- 数据日期
         ,job_cd  -- 任务代码
         ,etl_timestamp  -- 数据处理时间
     )
select
         replace(replace(duebillno,chr(13),''),chr(10),'')  -- 借据号
         ,replace(replace(intdate,chr(13),''),chr(10),'')  -- 执行日期
         ,accountbalance  -- 还款账户余额
         ,accountuserbalance  -- 还款账户可用余额
         ,replace(replace(termtype,chr(13),''),chr(10),'')  -- 贷款类型码
         ,replace(replace(termmonthtype,chr(13),''),chr(10),'')  -- 期限代码
         ,tatimes  -- 借据上次状态
         ,insum  -- 发生额
         ,interestinsum  -- 发生额
         ,replace(replace(finishdate,chr(13),''),chr(10),'')  -- 约定还款到期日
         ,to_date('${batch_date}','yyyymmdd')  -- 
         ,''  -- 
         ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 
from 
        (select
             t1.lncfno  as duebillno -- 借据号
            ,t2.nextdate as intdate -- 执行日期
            ,nvl(t3.lastbl,0) as accountbalance -- 还款账户余额
            ,nvl(t3.lastbl,0) + nvl(t3.acctbl,0) as accountuserbalance -- 还款账户可用余额
            ,t1.loantp as termtype -- 贷款类型码
            ,t1.termcd as termmonthtype  -- 期限代码
            ,case when t1.lncfst='2' 
                 then 1   
                 else 0
                 end as tatimes --借据上次状态 
            ,nvl(t4.tranam,0) as insum -- 发生额
            ,nvl(t5.tranam,0) as interestinsum -- 发生额
            ,t1.matudt as finishdate -- 约定还款到期日
            ,to_date('${batch_date}','yyyymmdd')  -- 
            ,''  -- 
            ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  --
       from
          (select a.*
                 ,b.ods_std_cd as std_crcycd 
           from ${iol_schema}.cbss_lnb_lncf a 
           left join ${idl_schema}.p_ods_currency_src2std b  
                on a.crcycd=b.source_cd 
                and b.src_system_id='CBS'
           where a.start_dt<=to_date('${batch_date}','yyyymmdd') 
                and a.end_dt>to_date('${batch_date}','yyyymmdd')
           ) t1 --贷款账户基本信息
     left join  tmp_plms_businessinfo_01 t2
          on  t1.lncfno=t2.duebillserialno
     left join  tmp_plms_businessinfo_02 t3
          on  t1.dpacno=t3.acctno
     left join  tmp_plms_businessinfo_03 t4
          on  t1.lncfno=t4.acctno
          and t1.std_crcycd=t4.std_crcycd
     left join tmp_plms_businessinfo_04 t5 
          on  t1.lncfno=t5.acctno
          and t1.std_crcycd=t5.std_crcycd
      )
;
commit;
     
     
--第二组
-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.plms_businessinfo partition for (to_date('${batch_date}','yyyymmdd')) (
         duebillno  -- 借据号
         ,intdate  -- 执行日期
         ,accountbalance  -- 还款账户余额
         ,accountuserbalance  -- 还款账户可用余额
         ,termtype  -- 贷款类型码
         ,termmonthtype  -- 期限代码
         ,tatimes  -- 借据上次状态
         ,insum  -- 发生额
         ,interestinsum  -- 发生额
         ,finishdate  -- 约定还款到期日
         ,etl_dt  -- 数据日期
         ,job_cd  -- 任务代码
         ,etl_timestamp  -- 数据处理时间
     )
select
          replace(replace(duebillno,chr(13),''),chr(10),'')  -- 借据号
         ,replace(replace(intdate,chr(13),''),chr(10),'')  -- 执行日期
         ,accountbalance  -- 还款账户余额
         ,accountuserbalance  -- 还款账户可用余额
         ,replace(replace(termtype,chr(13),''),chr(10),'')  -- 贷款类型码
         ,replace(replace(termmonthtype,chr(13),''),chr(10),'')  -- 期限代码
         ,tatimes  -- 借据上次状态
         ,insum  -- 发生额
         ,interestinsum  -- 发生额
         ,replace(replace(finishdate,chr(13),''),chr(10),'')  -- 约定还款到期日
         ,to_date('${batch_date}','yyyymmdd')  -- 
         ,''  -- 
         ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 
from 
        (select
                 t1.serialno as duebillno -- 借据号
                ,t3.executiondate as intdate -- 执行日期
                ,nvl(t2.lastbl, 0) as accountbalance -- 还款账户余额
                ,nvl(t2.lastbl, 0) + nvl(t2.acctbl, 0) as accountuserbalance -- 还款账户可用余额
                ,'' as termtype -- 贷款类型码
                ,'' as termmonthtype -- 期限代码
                ,0 tatimes --借据上次状态 
                ,t1.businesssum-t1.balance as insum -- 发生额
                ,0 as interestinsum -- 发生额
                ,replace(t1.finishdate,'/','') as finishdate   -- 约定还款到期日
                ,to_date('${batch_date}','yyyymmdd')  -- 
                ,''  -- 
                ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 
         from ${iol_schema}.crss_business_duebill t1
         left join tmp_plms_businessinfo_02 t2
              on t1.paybackaccount = t2.acctno
         left join ${iol_schema}.crss_repayment_plan_info t3
              on t1.serialno=t3.duebillserialno
              and t3.etl_dt=to_date('${batch_date}','yyyymmdd')
          where t1.businesstype = '2010010' 
             and t1.start_dt<=to_date('${batch_date}','yyyymmdd') 
             and t1.end_dt>to_date('${batch_date}','yyyymmdd')
        )
;
commit;

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'plms_businessinfo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);