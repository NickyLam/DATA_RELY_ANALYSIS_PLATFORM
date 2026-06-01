/*
Purpose:    共性加工层-存款账户交易明细:包括所有行内存款账户的金融交易明细，数据来源于新核心系统。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220930 icl_cmm_dep_acct_tran_dtl_change
Createdate: 20200424
Logs:	      20240102 陈伟峰 新增脚本用于更新MAC地址字段
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_03_1 purge;
--update ${icl_schema}.cmm_dep_acct_tran_dtl set cross_bor_tran_flg ='0' where etl_dt >=to_date('20230501','yyyymmdd');
commit;


-- 1.5 insert data to tmp table
-- 获取区分跨境交易口径(含涉外收入申报单、境外汇款申请书、对外承兑通知书等)
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_03_1
nologging
compress ${option_switch} for query high
as
select * from (
   --国结
   with tmp1 as (select source_id,qjls,ywls,tran_type from (
 select 'ISBS' as source_id,trn.qjls as qjls,wfe.itfinr as ywls,
         case when trim(gl.tran_type) is not null then trim(gl.tran_type)
              when wfe.srv ='SHA'  then 'FX09'
              when wfe.srv ='JHA'  then 'FX04' 
               end as tran_type  
   from iol.isbs_dba dba 
  inner join  iol.isbs_trn trn 
     on (trim(trn.ownref)=trim(dba.buscode)) 
    and trim(trn.qjls) is not null and trn.relflg='R' 
    and trn.start_dt <= to_date('${batch_date}','yyyymmdd') and trn.end_dt > to_date('${batch_date}','yyyymmdd')
   left join iol.isbs_gl059660 gl
     on gl.trninr=trn.inr 
  inner join iol.isbs_wfs wfs 
     on wfs.objinr=trn.inr and wfs.objtyp='TRN'  
    and wfs.start_dt <=to_date('${batch_date}','yyyymmdd') and wfs.end_dt >to_date('${batch_date}','yyyymmdd')
  inner join iol.isbs_wfe wfe 
     on wfe.wfsinr=wfs.inr 
    and wfe.srv IN('SHA','ACT','JHA') 
    and wfe.start_dt <=to_date('${batch_date}','yyyymmdd') and wfe.end_dt >to_date('${batch_date}','yyyymmdd')
  where dba.start_dt <=to_date('${batch_date}','yyyymmdd') and dba.end_dt >to_date('${batch_date}','yyyymmdd') 
 union all 
 select 'ISBS' as source_id,trn.qjls as qjls,wfe.itfinr as ywls,
         case when trim(gl.tran_type) is not null then trim(gl.tran_type)
              when wfe.srv ='SHA'  then 'FX09'
              when wfe.srv ='JHA'  then 'FX04' 
               end as tran_type  
   from iol.isbs_dbb dbb 
  inner join  iol.isbs_trn trn 
     on (trim(trn.ownref)=trim(dbb.buscode)) 
    and trim(trn.qjls) is not null and trn.relflg='R' 
    and trn.start_dt <= to_date('${batch_date}','yyyymmdd') and trn.end_dt > to_date('${batch_date}','yyyymmdd')
   left join iol.isbs_gl059660 gl
     on gl.trninr=trn.inr 
  inner join iol.isbs_wfs wfs 
     on wfs.objinr=trn.inr and wfs.objtyp='TRN'  
    and wfs.start_dt <=to_date('${batch_date}','yyyymmdd') and wfs.end_dt >to_date('${batch_date}','yyyymmdd')
  inner join iol.isbs_wfe wfe 
on wfe.wfsinr=wfs.inr 
and wfe.srv IN('SHA','ACT','JHA') 
and wfe.start_dt <=to_date('${batch_date}','yyyymmdd') and wfe.end_dt >to_date('${batch_date}','yyyymmdd')
where dbb.start_dt <=to_date('${batch_date}','yyyymmdd') and dbb.end_dt >to_date('${batch_date}','yyyymmdd') 
 union all 
 select  'ISBS' as source_id,trn.qjls as qjls,wfe.itfinr as ywls,
 case when trim(gl.tran_type) is not null then trim(gl.tran_type)
      when wfe.srv ='SHA'  then 'FX09'
      when wfe.srv ='JHA'  then 'FX04' 
       end as tran_type  
 from iol.isbs_dbc dbc
inner join  iol.isbs_trn trn 
on (trim(trn.ownref)=trim(dbc.buscode)) 
and trim(trn.qjls) is not null and trn.relflg='R' 
and trn.start_dt <= to_date('${batch_date}','yyyymmdd') and trn.end_dt > to_date('${batch_date}','yyyymmdd')
left join iol.isbs_gl059660 gl
on gl.trninr=trn.inr 
inner join iol.isbs_wfs wfs 
on wfs.objinr=trn.inr and wfs.objtyp='TRN'  
and wfs.start_dt <=to_date('${batch_date}','yyyymmdd') and wfs.end_dt >to_date('${batch_date}','yyyymmdd')
inner join iol.isbs_wfe wfe 
on wfe.wfsinr=wfs.inr 
and wfe.srv IN('SHA','ACT','JHA') 
and wfe.start_dt <=to_date('${batch_date}','yyyymmdd') and wfe.end_dt >to_date('${batch_date}','yyyymmdd')
where dbc.start_dt <=to_date('${batch_date}','yyyymmdd') and dbc.end_dt >to_date('${batch_date}','yyyymmdd') 
 ) 
 group by source_id,qjls,ywls,tran_type
   )
   select t1.channel_seq_no,t1.tran_type,t1.bus_seq_no,t1.tran_date,t1.seq_no,'1' as cross_bor_tran_flg 
    from  iol.ncbs_rb_tran_hist t1
    inner join tmp1 t2
     on t1.channel_seq_no =t2.qjls
     and t1.tran_type=t2.tran_type
     and t1.sub_seq_no=t2.ywls
   where t1.tran_type in ('FX04','FX09','4686','4689','GJ01','GJ03')
   and t1.tran_date>=to_date('20230501','yyyymmdd')  )
;


-- 1.5 update data to target table
whenever sqlerror exit sql.sqlcode;
merge into ${icl_schema}.cmm_dep_acct_tran_dtl t1
using ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_03_1 t2
on (t1.ova_flow_num =t2.channel_seq_no
and t1.tran_dt=t2.tran_date
and t1.acct_bill_flow_num =t2.seq_no
and t1.tran_kind_cd =t2.tran_type)
when matched then update set cross_bor_tran_flg ='1'
where t1.etl_dt >=to_date('20230501','yyyymmdd');
commit;


