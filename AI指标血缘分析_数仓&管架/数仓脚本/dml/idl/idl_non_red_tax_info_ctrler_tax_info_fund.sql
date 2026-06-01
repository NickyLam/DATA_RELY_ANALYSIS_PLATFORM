/* 
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。 
Author:     Sunline 
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_non_red_tax_info_ctrler_tax_info_fund 
CreateDate: 20201023 
FileType:   DML 
Logs: 
    zjj 2018-05-15 新建表本 
*/ 
 
set timing on 
 
-- 1 alter parallel 
alter session force parallel query parallel 1; 
alter session force parallel dml parallel 1; 
 
 
-- 2.2 drop temp table 
whenever sqlerror continue none ; 
drop table idl.non_red_tax_info_ctrler_tax_info_fund_tmp purge; 
 
-- 2.3 create temp table 
whenever sqlerror exit sql.sqlcode; 
create table idl.non_red_tax_info_ctrler_tax_info_fund_tmp nologging 
compress ${option_switch} for query high 
as 
select * from idl.non_red_tax_info_ctrler_tax_info_fund where 0=1 ; 
 
-- 2.3 drop timeout partition and add partition 
whenever sqlerror continue none; 
alter table idl.non_red_tax_info_ctrler_tax_info_fund drop partition p_${batch_date}; 
 
-- 2.4 add today partition 
whenever sqlerror exit sql.sqlcode; 
alter table idl.non_red_tax_info_ctrler_tax_info_fund add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd')); 
 
-- 2.5 insert data temp table 
whenever sqlerror exit sql.sqlcode; 

declare load_sql varchar2(4000);
        v_col2 varchar2(200);
        v_tab_filter varchar2(200);
        v_condition varchar2(200);
        
begin
dbms_output.enable(buffer_size=>null);
  for reg in (select '''基金''' as v_col2,'to_date(''${batch_date}'',''yyyymmdd'')' as v_condition,'iol.nfss_tbclientseller' as v_tab_filter from dual
              union all                                                                                                
              select '''信托''' as v_col2,'to_date(''${batch_date}'',''yyyymmdd'')' as v_condition,'iol.nfss_tcs_tbclientseller' as v_tab_filter from dual
              union all                                                                                                
              select '''基金''' as v_col2,'to_date(''${batch_date}'',''yyyymmdd'')-1' as v_condition,'iol.nfss_tbclientseller' as v_tab_filter from dual
              union all                                                                                                
              select '''信托''' as v_col2,'to_date(''${batch_date}'',''yyyymmdd'')-1' as v_condition,'iol.nfss_tcs_tbclientseller' as v_tab_filter from dual
      ) loop
load_sql:=
'insert /*+ append */ into idl.non_red_tax_info_ctrler_tax_info_fund_tmp ( 
       etl_dt                        --数据日期 
      ,acc_type                      --客户标识类型 
      ,account                       --客户标识 
      ,trans_date                    --交易日期 
      ,client_type                   --客户类型 
      ,resident_tax_nation           --控制人税收居民国（地区） 
      ,resident_tax_id               --控制人纳税识别号 
      ,resident_tax_nation_unreason  --控制人不能提供居民国（地区）纳税人识别号原因 
      ,resident_tax_id_unreason      --控制人未能取得纳税人识别号原因 
      ,job_cd                        --任务代码 
      ,etl_timestamp                 --数据处理时间 
) 
select 
       '||reg.v_condition||'                                                            --数据日期 
      ,''客户号：1''                                                                    --客户标识类型 
      ,t1.CUST_ID                                                                       --客户标识 
      ,t1.ETL_DT                                                                        --交易日期 
      ,''对私''                                                                         --客户类型 
      ,t1.CTRLER_TAX_RED_CTY                                                            --控制人税收居民国（地区） 
      ,t1.CTRLER_TAX_NUM                                                                --控制人纳税识别号 
      ,t1.CTRLER_TAX_NULL_RS_DESCB                                                      --控制人不能提供居民国（地区）纳 
      ,t1.CTRLER_TAX_NULL_RS_DESCB                                                      --控制人未能取得纳税人识别号原因 
      ,'||reg.v_col2||'                                                                 --任务代码 
      ,to_timestamp(''${batch_timestamp}'', ''yyyy-mm-dd hh24:mi:ss.ff6'') as etl_timestamp --数据处理时间 
  from icl.CMM_CORP_CUST_RELA_PS_INFO t1   --对公客户关联人信息 
 where exists (select 1 from '||reg.v_tab_filter||' kk
                       where t1.rela_ps_cust_id = kk.client_no
                         and kk.start_dt <= '||reg.v_condition||'
                         and kk.end_dt > '||reg.v_condition||')
   and t1.etl_dt = '||reg.v_condition||'
   and rela_type_cd = ''30110''';
   
       dbms_output.put_line(load_sql); 
   execute immediate load_sql;
commit; 

 end loop;
 
end;
/

 
-- 2.6 insert data target table 
whenever sqlerror exit sql.sqlcode; 
insert /*+ append */ into idl.non_red_tax_info_ctrler_tax_info_fund partition for (to_date('${batch_date}','yyyymmdd')) ( 
       etl_dt                        --数据日期 
      ,acc_type                      --客户标识类型 
      ,account                       --客户标识 
      ,trans_date                    --交易日期,如果是trans_date<T-1则是已删除数据  
      ,client_type                   --客户类型 
      ,resident_tax_nation           --控制人税收居民国（地区） 
      ,resident_tax_id               --控制人纳税识别号 
      ,resident_tax_nation_unreason  --控制人不能提供居民国（地区）纳税人识别号原因 
      ,resident_tax_id_unreason      --控制人未能取得纳税人识别号原因 
      ,job_cd                        --任务代码 
      ,etl_timestamp                 --数据处理时间 
) 
select 
       to_date('${batch_date}','yyyymmdd')                                               --数据日期 
      ,t1.acc_type                                                                       --客户标识类型 
      ,t1.account                                                                        --客户标识 
      ,to_date('${batch_date}','yyyymmdd')                                                                     --交易日期 
      ,t1.client_type                                                                    --客户类型 
      ,t1.resident_tax_nation                                                            --控制人税收居民国（地区） 
      ,t1.resident_tax_id                                                                --控制人纳税识别号 
      ,t1.resident_tax_nation_unreason                                                   --控制人不能提供居民国（地区）纳税人识别号原因 
      ,t1.resident_tax_id_unreason                                                       --控制人未能取得纳税人识别号原因 
      ,t1.job_cd                                                                         --任务代码 
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  --数据处理时间 
from idl.non_red_tax_info_ctrler_tax_info_fund_tmp t1        --历史数据 
where t1.trans_date = to_date('${batch_date}','yyyymmdd') 
minus 
select 
       to_date('${batch_date}','yyyymmdd')                                               --数据日期 
      ,t1.acc_type                                                                       --客户标识类型 
      ,t1.account                                                                        --客户标识 
      ,to_date('${batch_date}','yyyymmdd')                                                                     --交易日期 
      ,t1.client_type                                                                    --客户类型 
      ,t1.resident_tax_nation                                                            --控制人税收居民国（地区） 
      ,t1.resident_tax_id                                                                --控制人纳税识别号 
      ,t1.resident_tax_nation_unreason                                                   --控制人不能提供居民国（地区）纳税人识别号原因 
      ,t1.resident_tax_id_unreason                                                       --控制人未能取得纳税人识别号原因 
      ,t1.job_cd                                                                         --任务代码 
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  --数据处理时间 
from idl.non_red_tax_info_ctrler_tax_info_fund_tmp t1        --历史数据 
where t1.trans_date = to_date('${batch_date}','yyyymmdd')-1 
union all                                                                              --补充已删除数据
select                                                                                 --上日数据
     to_date('${batch_date}','yyyymmdd')                                               --数据日期 
    ,t1.acc_type                                                                       --客户标识类型 
    ,t1.account                                                                        --客户标识 
    ,t1.trans_date                                                                     --交易日期 
    ,t1.client_type                                                                    --客户类型 
    ,t1.resident_tax_nation                                                            --控制人税收居民国（地区） 
    ,t1.resident_tax_id                                                                --控制人纳税识别号 
    ,t1.resident_tax_nation_unreason                                                   --控制人不能提供居民国（地区）纳税人识别号原因 
    ,t1.resident_tax_id_unreason                                                       --控制人未能取得纳税人识别号原因 
    ,t1.job_cd                                                                         --任务代码 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  --数据处理时间 
from idl.non_red_tax_info_ctrler_tax_info_fund_tmp t1      --当前数据 
where not exists (select 1 from idl.non_red_tax_info_ctrler_tax_info_fund_tmp t2
                   where t1.account = t2.account
                     and t2.trans_date = to_date('${batch_date}','yyyymmdd'))
  AND t1.trans_date = to_date('${batch_date}','yyyymmdd')-1 
GROUP BY t1.etl_dt,t1.acc_type,t1.account,t1.trans_date,t1.client_type,t1.resident_tax_nation,t1.resident_tax_id,t1.resident_tax_nation_unreason,t1.resident_tax_id_unreason,t1.job_cd,t1.etl_timestamp;
commit;

 

--2.7 比对新开户客户，插入目标表
whenever sqlerror exit sql.sqlcode; 
insert /*+ append */ into idl.non_red_tax_info_ctrler_tax_info_fund partition for (to_date('${batch_date}','yyyymmdd')) ( 
       etl_dt                        --数据日期 
      ,acc_type                      --客户标识类型 
      ,account                       --客户标识 
      ,trans_date                    --交易日期,如果是trans_date<T-1则是已删除数据  
      ,client_type                   --客户类型 
      ,resident_tax_nation           --控制人税收居民国（地区） 
      ,resident_tax_id               --控制人纳税识别号 
      ,resident_tax_nation_unreason  --控制人不能提供居民国（地区）纳税人识别号原因 
      ,resident_tax_id_unreason      --控制人未能取得纳税人识别号原因 
      ,job_cd                        --任务代码 
      ,etl_timestamp                 --数据处理时间 
) 
select 
       to_date('${batch_date}','yyyymmdd')                                               --数据日期 
      ,t1.acc_type                                                                       --客户标识类型 
      ,t1.account                                                                        --客户标识 
      ,to_date('${batch_date}','yyyymmdd')                                                                     --交易日期 
      ,t1.client_type                                                                    --客户类型 
      ,t1.resident_tax_nation                                                            --控制人税收居民国（地区） 
      ,t1.resident_tax_id                                                                --控制人纳税识别号 
      ,t1.resident_tax_nation_unreason                                                   --控制人不能提供居民国（地区）纳税人识别号原因 
      ,t1.resident_tax_id_unreason                                                       --控制人未能取得纳税人识别号原因 
      ,t1.job_cd                                                                         --任务代码 
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  --数据处理时间 
from idl.non_red_tax_info_ctrler_tax_info_fund_tmp t1        --历史数据 
 where t1.trans_date = to_date('${batch_date}','yyyymmdd')
   and not exists (select 1 from ${idl_schema}.non_red_tax_info_ctrler_tax_info_fund tt
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



-- 3 table grant
-- whenever sqlerror exit sql.sqlcode; 
-- grant select on idl.non_red_tax_info_ctrler_tax_info_fund to idl; 
 
-- 4 drop temp table 
-- it is no need to check when this segment SQL was return faied 
whenever sqlerror continue none ; 
drop table idl.non_red_tax_info_ctrler_tax_info_fund_tmp purge; 

-- 5 gater table status 
whenever sqlerror exit sql.sqlcode; 
exec dbms_stats.gather_table_stats(ownname => 'idl',tabname => 'non_red_tax_info_ctrler_tax_info_fund',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);