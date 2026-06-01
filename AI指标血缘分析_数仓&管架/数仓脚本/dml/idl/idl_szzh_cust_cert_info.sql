/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl szzh_cust_cert_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.szzh_cust_cert_info drop partition p_${batch_date};
drop table ${idl_schema}.temp_szzh_cust_cert_info purge;
-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.szzh_cust_cert_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
--creat temp table
create table ${idl_schema}.temp_szzh_cust_cert_info(
   doc_rec varchar2(400) -- 文件记录
)
nologging
compress ${option_switch} for query high
;
--2.4.1 insert into temp_szzh_cust_cert_info
insert /*+ append */ into ${idl_schema}.temp_szzh_cust_cert_info  (
    doc_rec  -- 文件记录
)
select
    replace(replace(doc_rec,chr(13),''),chr(10),'')  -- 标准代码
 from (select '0'||case when c.datavl is null then '                                '
                        else 
                             rpad(c.datavl,32,' ') end||
               rpad('313584012014',14,' ')||rpad('广东华兴银行股份有限公司深圳分行',120,' ')||rpad(a.custcn,120,' ')||
               case 
                  when b.ods_std_cd ='A' then '01'
                  when b.ods_std_cd in('D','R','T') then '02'
                  when b.ods_std_cd ='G' then '04'
                  when b.ods_std_cd ='H' then '05'
                  when b.ods_std_cd ='C' then '06'
                  when b.ods_std_cd in('M','W') then '07'
                  when b.ods_std_cd in('B','E','F','I','J','K','L','N','O','P','Q','S','U','X','Y') then '08'
                   else '00'
                  end||rpad(b.certno,32,' ')||'0'||
                case 
                  when a.custtp='1' then 1
                  when a.custtp='2'  then 0
                  else  9
                  end doc_rec
          from  ${iol_schema}.cifs_cifs_cfb_cust a --客户基本信息
          left join  (select c.*,d.* from
                          (select source_cd,ods_std_cd 
                          from ${idl_schema}.p_ods_certificate_src2std 
                          where src_system_id='CIF') c --源系统代码和标准代码
                          left join  ${iol_schema}.cifs_cifs_aid_cert d --客户证件信息
                          on d.certtp=c.source_cd ) b
          on b.custno = a.custno 
          and b.mainfg='1'  --主证件
          and  b.start_dt <= to_date('${batch_date}','yyyymmdd') 
          and b.end_dt > to_date('${batch_date}','yyyymmdd') 
  left join ${iol_schema}.cbss_knc_acid c  --客户与标识关联关系 客户号和数据内容（账号）的状态
  on c.custno = a.custno 
  and c.start_dt >= to_date('${batch_date}','yyyymmdd')
  and c.end_dt < to_date('${batch_date}','yyyymmdd')
  where a.opendt between  to_char(to_date('${batch_date}','yyyymmdd')-6,'yyyymmdd') and '${batch_date}'
  and a.openbr like '805%' and a.start_dt <= to_date('${batch_date}','yyyymmdd') 
  and a.end_dt > to_date('${batch_date}','yyyymmdd')  
  and a.custtp in ('1','2')
  and c.datavl is not null);
commit;
 --2.4.2 insert into temp_szzh_cust_cert_info   
insert /*+ append */ into ${idl_schema}.temp_szzh_cust_cert_info  (
    doc_rec  -- 文件记录
)
select
    replace(replace(doc_rec,chr(13),''),chr(10),'')  -- 标准代码
 from (select '1'||case when c.datavl is null then '                                '
                        else rpad(c.datavl,32,' ')
                        end||
               rpad('313584012014',14,' ')||rpad('广东华兴银行股份有限公司深圳分行',120,' ')||rpad(a.custcn,120,' ')||
               case 
                   when b.ods_std_cd ='A' then '01'
                   when b.ods_std_cd in('D','R','T') then '02'
                   when b.ods_std_cd ='G' then '04'
                   when b.ods_std_cd ='H' then '05'
                   when b.ods_std_cd ='C' then '06'
                   when b.ods_std_cd in('M','W') then '07'
                   when b.ods_std_cd in('B','E','F','I','J','K','L','N','O','P','Q','S','U','X','Y') then '08'
                   else '00'
                   end|| rpad(b.certno,32,' ')||'0'||
                   case 
                       when a.custtp='1' then 1
                       when a.custtp='2'  then 0
                       else  9
                       end doc_rec
       from ${iol_schema}.cifs_cifs_cfb_cust a
       left join (select c.*,d.* 
                    from
                       (select source_cd,ods_std_cd 
                          from ${idl_schema}.p_ods_certificate_src2std 
                          where src_system_id='CIF') c
                        left join ${iol_schema}.cifs_cifs_aid_cert d
                               on d.certtp=c.source_cd) b
             on b.custno = a.custno 
             and b.mainfg='1'
             and b.start_dt <= to_date('${batch_date}','yyyymmdd') 
             and b.end_dt > to_date('${batch_date}','yyyymmdd') 
       inner join ${iol_schema}.cbss_knc_acid c
             on c.custno = a.custno 
             and c.start_dt< = to_date('${batch_date}','yyyymmdd')
             and c.end_dt > to_date('${batch_date}','yyyymmdd')
       inner join ${iol_schema}.cbss_kna_acct e  --账户表
             on  e.acctno=c.datavl
             and e.start_dt <= to_date('${batch_date}','yyyymmdd') 
             and e.end_dt > to_date('${batch_date}','yyyymmdd')
       left join ${idl_schema}.p_ods_certificate_src2std f 
             on f.ods_std_cd=b.certtp and f.src_system_id='CIF'
       where a.start_dt <= to_date('${batch_date}','yyyymmdd') 
             and a.end_dt > to_date('${batch_date}','yyyymmdd')
             and e.closdt between  to_char(to_date('${batch_date}','yyyymmdd')-6,'yyyymmdd') and '${batch_date}'
             and a.openbr like '805%'   
             and a.custtp in ('1','2') 
             and c.datavl is not null );
     /*把账号表有的，开户6天内的客户与标识表的数据内容加工*/
commit;     
--2.4.3 insert into temp_szzh_cust_cert_info     
insert /*+ append */ into ${idl_schema}.temp_szzh_cust_cert_info  (
    doc_rec  -- 文件记录
)
select
    replace(replace(doc_rec,chr(13),''),chr(10),'')  -- 标准代码
 from (select '1'||case when c.datavl is null then '                                '
                        else rpad(c.datavl,32,' ')
                        end||
               rpad('313584012014',14,' ')||rpad('广东华兴银行股份有限公司深圳分行',120,' ')||rpad(a.custcn,120,' ')||
               case 
                    when b.ods_std_cd ='A' then '01'
                    when b.ods_std_cd in('D','R','T') then '02'
                    when b.ods_std_cd ='G' then '04'
                    when b.ods_std_cd ='H' then '05'
                    when b.ods_std_cd ='C' then '06'
                    when b.ods_std_cd in('M','W') then '07'
                    when b.ods_std_cd in('B','E','F','I','J','K','L','N','O','P','Q','S','U','X','Y') then '08'
                    else '00'
                    end||rpad(b.certno,32,' ')||case when e.acctst='0' then '1' else '0' end||
                case 
                    when a.custtp='1' then 1
                    when a.custtp='2'  then 0
                    else  9
                    end doc_rec
         from ${iol_schema}.cifs_cifs_cfb_cust a
         inner join ( select distinct custno 
                      from 
                          (select custno,custcn,ods_src_dt 
                           from
                               (select
                                       b.custno ,
                                       b.custcn,
                                      '${batch_date}' as ods_src_dt
                                 from ${iol_schema}.cifs_cifs_cfb_cust a      --客户基本信息
                                 inner join ${iol_schema}.cifs_cifs_cfb_cust b
                                 on a.custno=b.custno
                                 where a.custcn<>b.custcn
                                       and a.start_dt <= to_date('${batch_date}','yyyymmdd')-1
                                       and a.end_dt > to_date('${batch_date}','yyyymmdd')-1
                                       and b.start_dt <= to_date('${batch_date}','yyyymmdd') 
                                       and b.end_dt > to_date('${batch_date}','yyyymmdd')--今天和昨天比账号一样客户中文名不一样，今天改过中文名的数据
                                 union all
                                 select
                                       b.custno ,
                                       b.certno,
                                       '${batch_date}' as ods_src_dt
                                 from ${iol_schema}.cifs_cifs_aid_cert a
                                 inner join ${iol_schema}.cifs_cifs_aid_cert b
                                 on a.custno=b.custno
                                 where a.certno<>b.certno     
                                       and a.start_dt <= to_date('${batch_date}','yyyymmdd')-1 
                                       and a.end_dt > to_date('${batch_date}','yyyymmdd')-1
                                       and b.start_dt <= to_date('${batch_date}','yyyymmdd') 
                                       and b.end_dt > to_date('${batch_date}','yyyymmdd'))--今天和昨天比账号一样，证件号码不一样的今天的数据
                          )) a2 
         on a.custno=a2.custno 
         left join (select c.*,d.* 
                    from
                    (select source_cd,ods_std_cd 
                     from ${idl_schema}.p_ods_certificate_src2std where src_system_id='CIF') c 
                     left join ${iol_schema}.cifs_cifs_aid_cert d
                     on d.certtp=c.source_cd) b
         on b.custno = a.custno 
         and b.mainfg='1' 
         and b.start_dt <= to_date('${batch_date}','yyyymmdd') 
         and b.end_dt > to_date('${batch_date}','yyyymmdd')
         left join ${iol_schema}.cbss_knc_acid c
         on c.custno = a.custno 
         and c.start_dt <= to_date('${batch_date}','yyyymmdd')
         and c.end_dt > to_date('${batch_date}','yyyymmdd')
         inner join ${iol_schema}.cbss_kna_acct e  
         on e.acctno=c.datavl
         and e.start_dt <= to_date('${batch_date}','yyyymmdd') 
         and e.end_dt > to_date('${batch_date}','yyyymmdd')
         left join ${idl_schema}.p_ods_certificate_src2std d 
         on d.ods_std_cd=b.certtp and d.src_system_id='CIF'
         where a.openbr like '805%' and a.start_dt <= to_date('${batch_date}','yyyymmdd') 
         and a.end_dt > to_date('${batch_date}','yyyymmdd')  
         and a.custtp in ('1','2') 
         and not c.datavl is null) ;
commit;
--2.5 insert into szzh_cust_cert_info
insert /*+ append */ into ${idl_schema}.szzh_cust_cert_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,doc_rec  -- 文件记录
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')  -- 数据日期
    ,'671'||'${batch_date}'||'00000001'||rpad('313584012014',14,' ')||lpad(count(*),8,'0')  
    ,''  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
from ${idl_schema}.temp_szzh_cust_cert_info; 
commit;
insert /*+ append */ into ${idl_schema}.szzh_cust_cert_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,doc_rec  -- 文件记录
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')  -- 数据日期
    ,to_char(rownum, 'FM00000000')||doc_rec
    ,''  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
from ${idl_schema}.temp_szzh_cust_cert_info; 
commit;
--3.1 drop temp table
drop table ${idl_schema}.temp_szzh_cust_cert_info purge;
-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.szzh_cust_cert_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'szzh_cust_cert_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);