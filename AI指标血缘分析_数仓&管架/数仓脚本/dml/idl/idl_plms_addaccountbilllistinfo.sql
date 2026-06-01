/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_plms_addaccountbilllistinfo
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
alter table ${idl_schema}.plms_addaccountbilllistinfo drop partition p_${last_date};
alter table ${idl_schema}.plms_addaccountbilllistinfo drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror continue none;
alter table ${idl_schema}.plms_addaccountbilllistinfo add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

--删除临时表
whenever sqlerror continue none;
drop table ${idl_schema}.crss_customer_info_tmp_${batch_date};


--创建临时表
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.crss_customer_info_tmp_${batch_date} as select mfcustomerid from ${iol_schema}.crss_customer_info where 1=2;

--临时表装数
insert/*+append*/ into ${idl_schema}.crss_customer_info_tmp_${batch_date} nologging
select
         distinct
          t1.mfcustomerid
     from iol.crss_customer_info t1,
          idl.f_pty_cust_identity_rela t2 
     where 
       t1.start_dt<=to_date('${batch_date}','yyyymmdd') 
      and t1.end_dt>to_date('${batch_date}','yyyymmdd') 
      and t2.etl_dt=to_date('${batch_date}','yyyymmdd') 
      and (
       'CSTCMS'||t1.CUSTOMERID = t2.PARTY_ID
       or 'CSTCIF' || t1.mfcustomerid = t2.party_id
       --and 'CSTCMS' || t1.customerid <> t2.party_id
       or 'CSTCIF'||t1.CUSTOMERID = t2.PARTY_ID and t1.MFCUSTOMERID is null
     )
;
commit;

-- 2.4 insert data target table
insert /*+ append */ into ${idl_schema}.plms_addaccountbilllistinfo partition for (to_date('${batch_date}','yyyymmdd')) (
    transq  -- 交易流水
    ,acctno  -- 账号
    ,subsac  -- 子户号
    ,tranbr  -- 交易部门
    ,brchna  -- 交易机构名称
    ,trandt  -- 交易日期
    ,billsq  -- 账单流水
    ,cheqtp  -- 交易凭证种类
    ,cheqno  -- 交易凭证号码
    ,toacct  -- 交易对手账号
    ,tobkna  -- 交易对手行名称
    ,toacna  -- 交易对手户名
    ,trantp  -- 交易类型
    ,valuna  -- 中文名称
    ,amntcd  -- 借贷标志
    ,tranam  -- 交易金额
    ,tranbl  -- 本次余额
    ,etl_dt  -- 数据日期
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    replace(replace(t1.transq,chr(13),''),chr(10),'')  -- 交易流水
    ,replace(replace(t1.acctno,chr(13),''),chr(10),'')  -- 账号
    ,replace(replace(t1.subsac,chr(13),''),chr(10),'')  -- 子户号
    ,replace(replace(t1.tranbr,chr(13),''),chr(10),'')  -- 交易部门
    ,replace(replace(t3.brchna,chr(13),''),chr(10),'')  -- 交易机构名称
    ,replace(replace(t1.trandt,chr(13),''),chr(10),'')  -- 交易日期
    ,replace(replace(t1.billsq,chr(13),''),chr(10),'')  -- 账单流水
    ,replace(replace(t1.cheqtp,chr(13),''),chr(10),'')  -- 交易凭证种类
    ,replace(replace(t1.cheqno,chr(13),''),chr(10),'')  -- 交易凭证号码
    ,replace(replace(t1.toacct,chr(13),''),chr(10),'')  -- 交易对手账号
    ,replace(replace(t1.tobkna,chr(13),''),chr(10),'')  -- 交易对手行名称
    ,replace(replace(t1.toacna,chr(13),''),chr(10),'')  -- 交易对手户名
    ,replace(replace(t1.trantp,chr(13),''),chr(10),'')  -- 交易类型
    ,replace(replace(t2.valuna,chr(13),''),chr(10),'')  -- 中文名称
    ,replace(replace(t1.amntcd,chr(13),''),chr(10),'')  -- 借贷标志
    ,t1.tranam  -- 交易金额
    ,t1.tranbl  -- 本次余额
    ,to_date('${batch_date}','yyyymmdd')  -- 
    ,''  -- 
    ,t1.etl_timestamp  -- 
from ${iol_schema}.cbss_kdl_bill t1 --存款户账单
inner join ${iol_schema}.cbss_sys_lsvl t2 --列表值选项定义
 on  t1.smrycd=t2.listvl
 and t2.listcd='smrycd' 
 and t2.start_dt<=to_date('${batch_date}','yyyymmdd') 
 and t2.end_dt>to_date('${batch_date}','yyyymmdd')
left join ${iol_schema}.cbss_kub_brch t3 --机构表
 on  t1.tranbr=t3.brchno
 and t3.start_dt<=to_date('${batch_date}','yyyymmdd') 
 and t3.end_dt>to_date('${batch_date}','yyyymmdd')
inner join ${idl_schema}.a_d_dp_info_ft t4 --adm存款明细汇总
 on  t4.acct_no=t1.acctno 
 and t4.subs_ac=t1.subsac
 and t4.etl_dt=to_date('${batch_date}','yyyymmdd')
inner join ${idl_schema}.crss_customer_info_tmp_${batch_date} t5
 on  t4.cust_no=t5.mfcustomerid
where t1.etl_dt=to_date('${batch_date}','yyyymmdd') 
;
commit;

--drop tmp table
whenever sqlerror exit sql.sqlcode;
drop table ${idl_schema}.crss_customer_info_tmp_${batch_date};

-- 2.6 gater table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'plms_addaccountbilllistinfo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);