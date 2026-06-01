/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_non_red_tax_info_ctrler_info_fund
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
drop table idl.non_red_tax_info_ctrler_info_fund_tmp purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table idl.non_red_tax_info_ctrler_info_fund_tmp nologging
compress ${option_switch} for query high
as
select * from idl.non_red_tax_info_ctrler_info_fund where 0=1 ;

-- 2.3 drop timeout partition and add partition
whenever sqlerror continue none;
alter table idl.non_red_tax_info_ctrler_info_fund drop partition p_${batch_date};

-- 2.4 add today partition
whenever sqlerror exit sql.sqlcode;
alter table idl.non_red_tax_info_ctrler_info_fund add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.5 取出连续两天的数据，过滤后插入临时表
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
'insert /*+ append */ into idl.non_red_tax_info_ctrler_info_fund_tmp (
       etl_dt                                                                                     --数据日期
      ,acc_type                                                                                   --客户标识类型
      ,account                                                                                    --客户标识
      ,trans_date                                                                                 --交易日期,如果是trans_date<T-1则是已删除数据
      ,full_name                                                                                  --控制人姓名
      ,family_name                                                                                --控制人姓
      ,first_name                                                                                 --控制人名
      ,control_region_code                                                                        --控制人国籍
      ,birthday                                                                                   --控制人出生日期
      ,resident_tax_type                                                                          --控制人居民纳税身份
      ,born_nation                                                                                --控制人出生地（国家）
      ,english_present_address                                                                    --控制人现居地址（详细地址，英文）
      ,job_cd                                                                                     --任务代码
      ,etl_timestamp                                                                              --数据处理时间
)
select
       '||reg.v_condition||'                                                            --数据日期 
      ,''客户号：1''                                                                    --客户标识类型
      ,t1.rela_ps_cust_id                                                               --客户标识
      ,t1.etl_dt                                                                        --交易日期
      ,t1.rela_ps_name                                                                  --控制人姓名
      ,t1.rela_ps_en_last_name                                                          --控制人姓
      ,t1.rela_ps_en_name                                                               --控制人名
      ,t1.rela_ps_nation_cd                                                             --控制人国籍
      ,t1.rela_ps_birth_dt                                                              --控制人出生日期
      ,t1.rela_ps_tax_red_idti_cd                                                       --控制人居民纳税身份
      ,t1.rela_ps_en_birth_addr                                                         --控制人出生地（国家）
      ,t1.rela_ps_en_resdnt_addr                                                        --控制人现居地址（详细地址，英文）
      ,'||reg.v_col2||'                                                                 --任务代码 
      ,to_timestamp(''${batch_timestamp}'', ''yyyy-mm-dd hh24:mi:ss.ff6'')              --数据处理时间 
  from icl.cmm_corp_cust_rela_ps_info t1   --对公客户关联人信息
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

 
--2.6 比对两天数据差异，插入目标表
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into idl.non_red_tax_info_ctrler_info_fund partition for (to_date('${batch_date}','yyyymmdd')) (
       etl_dt                                                                                     --数据日期
      ,acc_type                                                                                   --客户标识类型
      ,account                                                                                    --客户标识
      ,trans_date                                                                                 --交易日期,如果是trans_date<T-1则是已删除数据
      ,full_name                                                                                  --控制人姓名
      ,family_name                                                                                --控制人姓
      ,first_name                                                                                 --控制人名
      ,control_region_code                                                                        --控制人国籍
      ,birthday                                                                                   --控制人出生日期
      ,resident_tax_type                                                                          --控制人居民纳税身份
      ,born_nation                                                                                --控制人出生地（国家）
      ,english_present_address                                                                    --控制人现居地址（详细地址，英文）
      ,job_cd                                                                                     --任务代码
      ,etl_timestamp                                                                              --数据处理时间
)
select                                                                                               --当天数据
       to_date('${batch_date}','yyyymmdd')                                                           --数据日期 
      ,t1.acc_type                                                                                   --客户标识类型
      ,t1.account                                                                                    --客户标识
      ,to_date('${batch_date}','yyyymmdd')                                                           --交易日期
      ,t1.full_name                                                                                  --控制人姓名
      ,t1.family_name                                                                                --控制人姓
      ,t1.first_name                                                                                 --控制人名
      ,t1.control_region_code                                                                        --控制人国籍
      ,t1.birthday                                                                                   --控制人出生日期
      ,t1.resident_tax_type                                                                          --控制人居民纳税身份
      ,t1.born_nation                                                                                --控制人出生地（国家）
      ,t1.english_present_address                                                                    --控制人现居地址（详细地址，英文）
      ,t1.job_cd                                                                                     --任务代码
      ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')                                --数据处理时间
   from idl.non_red_tax_info_ctrler_info_fund_tmp t1
 where t1.trans_date = to_date('${batch_date}','yyyymmdd')
 minus                                                                                               --取差集
select                                                                                               --上日数据
       to_date('${batch_date}','yyyymmdd')                                                           --数据日期 
      ,t1.acc_type                                                                                   --客户标识类型
      ,t1.account                                                                                    --客户标识
      ,to_date('${batch_date}','yyyymmdd')                                                           --交易日期
      ,t1.full_name                                                                                  --控制人姓名
      ,t1.family_name                                                                                --控制人姓
      ,t1.first_name                                                                                 --控制人名
      ,t1.control_region_code                                                                        --控制人国籍
      ,t1.birthday                                                                                   --控制人出生日期
      ,t1.resident_tax_type                                                                          --控制人居民纳税身份
      ,t1.born_nation                                                                                --控制人出生地（国家）
      ,t1.english_present_address                                                                    --控制人现居地址（详细地址，英文）
      ,t1.job_cd                                                                                     --任务代码
      ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')                                --数据处理时间
  from idl.non_red_tax_info_ctrler_info_fund_tmp t1   --临时表
 where t1.trans_date = to_date('${batch_date}','yyyymmdd')-1
union all                                                                                          --补充已删除数据
select                                                                                             --上日数据
     to_date('${batch_date}','yyyymmdd')                                                           --数据日期 
    ,t1.acc_type                                                                                   --客户标识类型
    ,t1.account                                                                                    --客户标识
    ,t1.etl_dt                                                                                     --交易日期
    ,t1.full_name                                                                                  --控制人姓名
    ,t1.family_name                                                                                --控制人姓
    ,t1.first_name                                                                                 --控制人名
    ,t1.control_region_code                                                                        --控制人国籍
    ,t1.birthday                                                                                   --控制人出生日期
    ,t1.resident_tax_type                                                                          --控制人居民纳税身份
    ,t1.born_nation                                                                                --控制人出生地（国家）
    ,t1.english_present_address                                                                    --控制人现居地址（详细地址，英文）
    ,t1.job_cd                                                                                     --任务代码
    ,t1.etl_timestamp                                                                              --数据处理时间
  from idl.non_red_tax_info_ctrler_info_fund_tmp t1   --临时表
 where not exists
           (select 1 from idl.non_red_tax_info_ctrler_info_fund_tmp t2
             where t1.account = t2.account
               AND t2.trans_date = to_date('${batch_date}','yyyymmdd'))
  and t1.trans_date = to_date('${batch_date}','yyyymmdd')-1
group by t1.etl_dt,t1.acc_type,t1.account,t1.etl_dt,t1.full_name,t1.family_name,t1.first_name,t1.control_region_code,t1.birthday,t1.resident_tax_type,t1.born_nation,t1.english_present_address,t1.job_cd,t1.etl_timestamp;
commit;


--2.7 比对新开户客户，插入目标表
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into idl.non_red_tax_info_ctrler_info_fund partition for (to_date('${batch_date}','yyyymmdd')) (
       etl_dt                                                                                     --数据日期
      ,acc_type                                                                                   --客户标识类型
      ,account                                                                                    --客户标识
      ,trans_date                                                                                 --交易日期,如果是trans_date<T-1则是已删除数据
      ,full_name                                                                                  --控制人姓名
      ,family_name                                                                                --控制人姓
      ,first_name                                                                                 --控制人名
      ,control_region_code                                                                        --控制人国籍
      ,birthday                                                                                   --控制人出生日期
      ,resident_tax_type                                                                          --控制人居民纳税身份
      ,born_nation                                                                                --控制人出生地（国家）
      ,english_present_address                                                                    --控制人现居地址（详细地址，英文）
      ,job_cd                                                                                     --任务代码
      ,etl_timestamp                                                                              --数据处理时间
)
select                                                                                               --当天数据
       to_date('${batch_date}','yyyymmdd')                                                           --数据日期 
      ,t1.acc_type                                                                                   --客户标识类型
      ,t1.account                                                                                    --客户标识
      ,to_date('${batch_date}','yyyymmdd')                                                           --交易日期
      ,t1.full_name                                                                                  --控制人姓名
      ,t1.family_name                                                                                --控制人姓
      ,t1.first_name                                                                                 --控制人名
      ,t1.control_region_code                                                                        --控制人国籍
      ,t1.birthday                                                                                   --控制人出生日期
      ,t1.resident_tax_type                                                                          --控制人居民纳税身份
      ,t1.born_nation                                                                                --控制人出生地（国家）
      ,t1.english_present_address                                                                    --控制人现居地址（详细地址，英文）
      ,t1.job_cd                                                                                     --任务代码
      ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')                                --数据处理时间
   from idl.non_red_tax_info_ctrler_info_fund_tmp t1
 where t1.trans_date = to_date('${batch_date}','yyyymmdd')
   and not exists (select 1 from ${idl_schema}.non_red_tax_info_ctrler_info_fund tt
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
                            group by client_no)
;
commit;


whenever sqlerror continue none ;
drop table idl.non_red_tax_info_ctrler_info_fund_tmp purge;

-- 5 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => 'idl',tabname => 'non_red_tax_info_ctrler_info_fund',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);