/* 
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。 
Author:     Sunline 
Usage:      python $ETL_HOME/script/main.py 20250430 idl_non_red_tax_info_tax_info_fund 
CreateDate: 20201023 
FileType:   DML 
Logs: 
    zjj 2018-05-15 新建表本 
    陈伟峰 20250529 优化税收居民国代码截取规则
*/ 

set timing on 
 
-- 1 alter parallel 
alter session force parallel query parallel 1; 
alter session force parallel dml parallel 1; 

 
-- 2.2 drop temp table 
whenever sqlerror continue none ; 
drop table idl.non_red_tax_info_tax_info_fund_tmp purge; 
drop table idl.non_red_tax_info_tax_info_fund_tmp01 purge; 
 
-- 2.3 create temp table 
whenever sqlerror exit sql.sqlcode; 
create table idl.non_red_tax_info_tax_info_fund_tmp nologging 
compress ${option_switch} for query high 
as 
select * from idl.non_red_tax_info_tax_info_fund where 0=1 ; 
create table idl.non_red_tax_info_tax_info_fund_tmp01 nologging 
compress ${option_switch} for query high 
as 
select * from idl.non_red_tax_info_tax_info_fund where 0=1 ; 
-- 2.3 drop timeout partition and add partition 
whenever sqlerror continue none; 
alter table idl.non_red_tax_info_tax_info_fund drop partition p_${batch_date}; 
 
-- 2.4 add today partition 
whenever sqlerror exit sql.sqlcode; 
alter table idl.non_red_tax_info_tax_info_fund add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd')); 

whenever sqlerror exit sql.sqlcode; 
-- 定义变量
declare load_sql varchar2(4000);
        v_col1 varchar2(200);
        v_col2 varchar2(200);
        v_col3 varchar2(200);
        v_tab_from varchar2(200);
        v_tab_filter varchar2(200);
        v_condition varchar2(200);
begin 
dbms_output.enable(buffer_size=>null);
-- 2.5 insert data temp table 
  for reg in (select '''对私''' as v_col1,'''基金''' as v_col2,'icl.CMM_INDV_CUST_BASIC_INFO' as v_tab_from,'to_date(''${batch_date}'',''yyyymmdd'')' as v_condition,'iol.nfss_tbclientseller' as v_tab_filter,'TAX_RED_CTY_CD' as col3 from dual
              union all                                                      
              select '''对私''' as v_col1,'''信托''' as v_col2,'icl.CMM_INDV_CUST_BASIC_INFO' as v_tab_from,'to_date(''${batch_date}'',''yyyymmdd'')' as v_condition,'iol.nfss_tcs_tbclientseller' as v_tab_filter,'TAX_RED_CTY_CD' as col3 from dual
              union all                                                      
              select '''对公''' as v_col1,'''基金''' as v_col2,'icl.CMM_CORP_CUST_BASIC_INFO' as v_tab_from,'to_date(''${batch_date}'',''yyyymmdd'')' as v_condition,'iol.nfss_tbclientseller' as v_tab_filter,'TAX_RESDNT_CTY_CD' as col3 from dual
              union all                                                      
              select '''对公''' as v_col1,'''信托''' as v_col2,'icl.CMM_CORP_CUST_BASIC_INFO' as v_tab_from,'to_date(''${batch_date}'',''yyyymmdd'')' as v_condition,'iol.nfss_tcs_tbclientseller' as v_tab_filter,'TAX_RESDNT_CTY_CD' as col3 from dual  
              union all                                                      
              select '''对私''' as v_col1,'''基金''' as v_col2,'icl.CMM_INDV_CUST_BASIC_INFO' as v_tab_from,'to_date(''${batch_date}'',''yyyymmdd'')-1' as v_condition,'iol.nfss_tbclientseller' as v_tab_filter,'TAX_RED_CTY_CD' as col3 from dual
              union all                                                      
              select '''对私''' as v_col1,'''信托''' as v_col2,'icl.CMM_INDV_CUST_BASIC_INFO' as v_tab_from,'to_date(''${batch_date}'',''yyyymmdd'')-1' as v_condition,'iol.nfss_tcs_tbclientseller' as v_tab_filter,'TAX_RED_CTY_CD' as col3 from dual
              union all                                                      
              select '''对公''' as v_col1,'''基金''' as v_col2,'icl.CMM_CORP_CUST_BASIC_INFO' as v_tab_from,'to_date(''${batch_date}'',''yyyymmdd'')-1' as v_condition,'iol.nfss_tbclientseller' as v_tab_filter,'TAX_RESDNT_CTY_CD' as col3 from dual
              union all                                                      
              select '''对公''' as v_col1,'''信托''' as v_col2,'icl.CMM_CORP_CUST_BASIC_INFO' as v_tab_from,'to_date(''${batch_date}'',''yyyymmdd'')-1' as v_condition,'iol.nfss_tcs_tbclientseller' as v_tab_filter,'TAX_RESDNT_CTY_CD' as col3 from dual  
      ) loop
load_sql:=
'insert into idl.non_red_tax_info_tax_info_fund_tmp
  (
    etl_dt
   ,acc_type
   ,account
   ,trans_date
   ,client_type
   ,resident_tax_nation
   ,resident_tax_id
   ,resident_tax_nation_unreason
   ,resident_tax_id_unreason
   ,job_cd
   ,etl_timestamp
     )
 select 
    '||reg.v_condition||'
   ,''客户号：1''
   ,t1.CUST_ID
   ,t1.ETL_DT
   ,'||reg.v_col1||'
   ,'||reg.col3||'
   ,t1.TAX_NUM
   ,t1.TAX_NUM_NULL_RS_DESCB
   ,t1.TAX_NUM_NULL_RS_DESCB
   ,'||reg.v_col2||'
   ,to_timestamp(''${batch_timestamp}'',''yyyy-mm-dd hh24:mi:ss.ff6'') as etl_timestamp
 from '||reg.v_tab_from||' t1 
 where exists (select 1 from '||reg.v_tab_filter||' kk 
               where t1.cust_id = kk.client_no 
                 and kk.start_dt <= '||reg.v_condition||' 
                 and kk.end_dt > '||reg.v_condition||') 
  and t1.etl_dt = '||reg.v_condition||' 
  and t1.TAX_RESDNT_IDTI_CD in (''2'',''3'')';
       dbms_output.put_line(load_sql);
   execute immediate load_sql;
  commit;
end loop;

end;

/

whenever sqlerror exit sql.sqlcode; 


-- 2.6 Transformation data

begin

for i in 0..3
  loop   

insert into  idl.non_red_tax_info_tax_info_fund_tmp01
   (
       etl_dt                          --数据日期 
      ,acc_type                        --客户标识类型 
      ,account                         --客户标识 
      ,trans_date                      --交易日期  
      ,client_type                     --客户类别 
      ,resident_tax_nation             --税收居民国 
      ,resident_tax_id                 --纳税人识别号 
      ,resident_tax_nation_unreason    --不能提供居民国（地区）纳税人识别号原因 
      ,resident_tax_id_unreason        --未能取得纳税人识别号原因 
      ,job_cd                          --任务代码 
      ,etl_timestamp                   --数据处理时间 
    )
select 
     to_date('${batch_date}','yyyymmdd')                                               --数据日期 
    ,t1.acc_type                                                                       --客户标识类型 
    ,t1.account                                                                        --客户标识 
    ,t1.trans_date                                                                     --交易日期 
    ,t1.client_type                                                                    --客户类别 
    ,CASE WHEN LENGTH(t1.resident_tax_nation)='3' THEN t1.resident_tax_nation ELSE SUBSTR(regexp_substr(trim(replace(translate(t1.resident_tax_nation,'@ ','@'),';',' ')),'[^ ]+',1,i+1),decode(t1.resident_tax_nation,'XXX',1,2)) END as resident_tax_nation --税收居民国 
    ,SUBSTR(regexp_substr(trim(replace(translate(t1.resident_tax_id,'@ ','@'),';',' ')),'[^ ]+',1,i+1),2) as resident_tax_id --纳税人识别号 
    ,SUBSTR(regexp_substr(trim(replace(translate(t1.resident_tax_nation_unreason,'@ ','@'),';',' ')),'[^ ]+',1,i+1),2) as resident_tax_nation_unreason --不能提供居民国（地区）纳税人识别号原因 
    ,SUBSTR(regexp_substr(trim(replace(translate(t1.resident_tax_id_unreason,'@ ','@'),';',' ')),'[^ ]+',1,i+1),2) as resident_tax_id_unreason --未能取得纳税人识别号原因 
    ,t1.job_cd                                                                           --任务代码 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --数据处理时间 
from idl.non_red_tax_info_tax_info_fund_tmp t1 
where NVL(regexp_count(trim(replace(translate(t1.resident_tax_nation,'@ 123','@'),';',' ')),'[ ]'),0) >= i;
commit;
end loop;

end;
/

-- 2.7 比对两天数据差异，插入目标表 
whenever sqlerror exit sql.sqlcode; 
insert /*+ append */ into idl.non_red_tax_info_tax_info_fund partition for (to_date('${batch_date}','yyyymmdd')) ( 
       etl_dt                          --数据日期 
      ,acc_type                        --客户标识类型 
      ,account                         --客户标识 
      ,trans_date                      --交易日期
      ,client_type                     --客户类别 
      ,resident_tax_nation             --税收居民国 
      ,resident_tax_id                 --纳税人识别号 
      ,resident_tax_nation_unreason    --不能提供居民国（地区）纳税人识别号原因 
      ,resident_tax_id_unreason        --未能取得纳税人识别号原因 
      ,job_cd                          --任务代码 
      ,etl_timestamp                   --数据处理时间 
) 
select 
       to_date('${batch_date}','yyyymmdd')                                               --数据日期 
      ,t1.acc_type                        --客户标识类型 
      ,t1.account                         --客户标识 
      ,to_date('${batch_date}','yyyymmdd')                      --交易日期
      ,t1.client_type                     --客户类别 
      ,t1.resident_tax_nation             --税收居民国 
      ,t1.resident_tax_id                 --纳税人识别号 
      ,t1.resident_tax_nation_unreason    --不能提供居民国（地区）纳税人识别号原因 
      ,t1.resident_tax_id_unreason        --未能取得纳税人识别号原因 
      ,t1.job_cd                          --任务代码 
      ,to_timestamp('${batch_date}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --数据处理时间 
from idl.non_red_tax_info_tax_info_fund_tmp01 t1
 where t1.trans_date = to_date('${batch_date}','yyyymmdd') 
minus 
select 
       to_date('${batch_date}','yyyymmdd')                                               --数据日期 
      ,t1.acc_type                        --客户标识类型 
      ,t1.account                         --客户标识 
      ,to_date('${batch_date}','yyyymmdd')                     --交易日期  
      ,t1.client_type                     --客户类别 
      ,t1.resident_tax_nation             --税收居民国 
      ,t1.resident_tax_id                 --纳税人识别号 
      ,t1.resident_tax_nation_unreason    --不能提供居民国（地区）纳税人识别号原因 
      ,t1.resident_tax_id_unreason        --未能取得纳税人识别号原因 
      ,t1.job_cd                          --任务代码 
      ,to_timestamp('${batch_date}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --数据处理时间 
from idl.non_red_tax_info_tax_info_fund_tmp01 t1
 where t1.trans_date = to_date('${batch_date}','yyyymmdd') -1
union all 
select 
     to_date('${batch_date}','yyyymmdd')                                               --数据日期 
    ,t1.acc_type                        --客户标识类型 
    ,t1.account                         --客户标识 
    ,t1.trans_date                      --交易日期  
    ,t1.client_type                     --客户类别 
    ,t1.resident_tax_nation             --税收居民国 
    ,t1.resident_tax_id                 --纳税人识别号 
    ,t1.resident_tax_nation_unreason    --不能提供居民国（地区）纳税人识别号原因 
    ,t1.resident_tax_id_unreason        --未能取得纳税人识别号原因 
    ,t1.job_cd                          --任务代码 
    ,t1.etl_timestamp                           --数据处理时间 
from idl.non_red_tax_info_tax_info_fund_tmp01 t1
where not exists (select 1 from idl.non_red_tax_info_tax_info_fund_tmp01 t2
                   where t2.trans_date = to_date('${batch_date}','yyyymmdd')
                     and t1.account = t2.account)
 and t1.trans_date = to_date('${batch_date}','yyyymmdd') -1
group by  t1.etl_dt,t1.acc_type,t1.account,t1.trans_date,t1.client_type,t1.resident_tax_nation,t1.resident_tax_id,t1.resident_tax_nation_unreason,t1.resident_tax_id_unreason,t1.job_cd,t1.etl_timestamp;
commit; 


-- 2.8 比对新开户客户，插入目标表
whenever sqlerror exit sql.sqlcode; 
insert /*+ append */ into idl.non_red_tax_info_tax_info_fund partition for (to_date('${batch_date}','yyyymmdd')) ( 
       etl_dt                          --数据日期 
      ,acc_type                        --客户标识类型 
      ,account                         --客户标识 
      ,trans_date                      --交易日期
      ,client_type                     --客户类别 
      ,resident_tax_nation             --税收居民国 
      ,resident_tax_id                 --纳税人识别号 
      ,resident_tax_nation_unreason    --不能提供居民国（地区）纳税人识别号原因 
      ,resident_tax_id_unreason        --未能取得纳税人识别号原因 
      ,job_cd                          --任务代码 
      ,etl_timestamp                   --数据处理时间 
) 
select 
       to_date('${batch_date}','yyyymmdd')                                               --数据日期 
      ,t1.acc_type                        --客户标识类型 
      ,t1.account                         --客户标识 
      ,to_date('${batch_date}','yyyymmdd')                      --交易日期
      ,t1.client_type                     --客户类别 
      ,t1.resident_tax_nation             --税收居民国 
      ,t1.resident_tax_id                 --纳税人识别号 
      ,t1.resident_tax_nation_unreason    --不能提供居民国（地区）纳税人识别号原因 
      ,t1.resident_tax_id_unreason        --未能取得纳税人识别号原因 
      ,t1.job_cd                          --任务代码 
      ,to_timestamp('${batch_date}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --数据处理时间 
from idl.non_red_tax_info_tax_info_fund_tmp01 t1
 where t1.trans_date = to_date('${batch_date}','yyyymmdd')
   and not exists (select 1 from ${idl_schema}.non_red_tax_info_tax_info_fund tt
                   where tt.account =t1.account
                     and tt.etl_dt = to_date('${batch_date}','yyyymmdd'))
   and t1.account in (select client_no from (
                         select client_no from ${iol_schema}.nfss_tbclientseller
                          where start_dt <= to_date('${batch_date}','yyyymmdd')
                            and end_dt > to_date('${batch_date}','yyyymmdd')
                            and ${iml_schema}.dateformat_min(open_date) =to_date('${batch_date}','yyyymmdd')
                          union all  
                         select client_no from ${iol_schema}.nfss_tcs_tbclientseller
                          where start_dt <= to_date('${batch_date}','yyyymmdd')
                            and end_dt > to_date('${batch_date}','yyyymmdd')
                            and ${iml_schema}.dateformat_min(open_date) =to_date('${batch_date}','yyyymmdd'))
                            group by client_no);
commit; 


-- 5 gater table status 
exec dbms_stats.gather_table_stats(ownname => 'idl',tabname => 'non_red_tax_info_tax_info_fund',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);

