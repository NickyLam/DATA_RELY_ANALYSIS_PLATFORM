/* 
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。 
Author:     Sunline 
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_non_red_tax_info_mtbl_fund 
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
drop table idl.non_red_tax_info_mtbl_fund_tmp purge; 
 
-- 2.3 create temp table 
whenever sqlerror exit sql.sqlcode; 
create table idl.non_red_tax_info_mtbl_fund_tmp nologging 
compress ${option_switch} for query high 
as 
select * from idl.non_red_tax_info_mtbl_fund where 0=1 ; 
 
-- 2.3 drop timeout partition and add partition 
whenever sqlerror continue none; 
alter table idl.non_red_tax_info_mtbl_fund drop partition p_${batch_date}; 
 
-- 2.4 add today partition 
whenever sqlerror exit sql.sqlcode; 
alter table idl.non_red_tax_info_mtbl_fund add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd')); 

whenever sqlerror exit sql.sqlcode; 

-- 2.5 insert data temp table 
declare load_sql varchar2(4000);
        v_col1 varchar2(200);
        v_col2 varchar2(200);
        v_col3 varchar2(200);
        v_col4 varchar2(200);
        v_col5 varchar2(200);
        v_col6 varchar2(200);
        v_col7 varchar2(200);
        v_col8 varchar2(200);
        v_col9 varchar2(200);
        v_col10 varchar2(200);
        v_col11 varchar2(200);
        v_tab_from varchar2(200);
        v_tab_filter varchar2(200);
        v_condition varchar2(200);
        
begin
dbms_output.enable(buffer_size=>null);
  for reg in (select '''对私''' as v_col1,'''基金''' as v_col2,'to_date(''${batch_date}'',''yyyymmdd'')' as v_condition,'''''' as v_col3,'''''' as v_col4,'''''' as v_col5,'''''' as v_col6,'replace(t1.CUST_EN_NAME,'';'','' '')' as v_col7,'replace(t1.CUST_EN_NAME,'';'','' '')' as v_col8,'t1.NATION_CD' as v_col9,'t1.NATION_CD' as v_col10,'t1.POSTA_ADDR' as v_col11,'icl.CMM_INDV_CUST_BASIC_INFO' as v_tab_from,'iol.nfss_tbclientseller' as v_tab_filter from dual
              union all                                                                                                
              select '''对私''' as v_col1,'''信托''' as v_col2,'to_date(''${batch_date}'',''yyyymmdd'')' as v_condition,'''''' as v_col3,'''''' as v_col4,'''''' as v_col5,'''''' as v_col6,'replace(t1.CUST_EN_NAME,'';'','' '')' as v_col7,'replace(t1.CUST_EN_NAME,'';'','' '')' as v_col8,'t1.NATION_CD' as v_col9,'t1.NATION_CD' as v_col10,'t1.POSTA_ADDR' as v_col11,'icl.CMM_INDV_CUST_BASIC_INFO' as v_tab_from,'iol.nfss_tcs_tbclientseller' as v_tab_filter from dual
              union all                                                                                                
              select '''对公''' as v_col1,'''基金''' as v_col2,'to_date(''${batch_date}'',''yyyymmdd'')' as v_condition,'t1.TAX_ORG_CATE_CD' as v_col3,'replace(t1.CUST_EN_NAME,'';'','' '')' as v_col4,'t1.CTY_RG_CD' as v_col5,'t1.POSTA_ADDR' as v_col6,'''''' as v_col7,'''''' as v_col8,'''''' as v_col9,'''''' as v_col10,'''''' as v_col11,'icl.CMM_CORP_CUST_BASIC_INFO' as v_tab_from,'iol.nfss_tbclientseller' as v_tab_filter from dual
              union all                                                                                                
              select '''对公''' as v_col1,'''信托''' as v_col2,'to_date(''${batch_date}'',''yyyymmdd'')' as v_condition,'t1.TAX_ORG_CATE_CD' as v_col3,'replace(t1.CUST_EN_NAME,'';'','' '')' as v_col4,'t1.CTY_RG_CD' as v_col5,'t1.POSTA_ADDR' as v_col6,'''''' as v_col7,'''''' as v_col8,'''''' as v_col9,'''''' as v_col10,'''''' as v_col11,'icl.CMM_CORP_CUST_BASIC_INFO' as v_tab_from,'iol.nfss_tcs_tbclientseller' as v_tab_filter from dual
              union all                                                                                                
              select '''对私''' as v_col1,'''基金''' as v_col2,'to_date(''${batch_date}'',''yyyymmdd'')-1' as v_condition,'''''' as v_col3,'''''' as v_col4,'''''' as v_col5,'''''' as v_col6,'replace(t1.CUST_EN_NAME,'';'','' '')' as v_col7,'replace(t1.CUST_EN_NAME,'';'','' '')' as v_col8,'t1.NATION_CD' as v_col9,'t1.NATION_CD' as v_col10,'t1.POSTA_ADDR' as v_col11,'icl.CMM_INDV_CUST_BASIC_INFO' as v_tab_from,'iol.nfss_tbclientseller' as v_tab_filter from dual
              union all                                                                                                
              select '''对私''' as v_col1,'''信托''' as v_col2,'to_date(''${batch_date}'',''yyyymmdd'')-1' as v_condition,'''''' as v_col3,'''''' as v_col4,'''''' as v_col5,'''''' as v_col6,'replace(t1.CUST_EN_NAME,'';'','' '')' as v_col7,'replace(t1.CUST_EN_NAME,'';'','' '')' as v_col8,'t1.NATION_CD' as v_col9,'t1.NATION_CD' as v_col10,'t1.POSTA_ADDR' as v_col11,'icl.CMM_INDV_CUST_BASIC_INFO' as v_tab_from,'iol.nfss_tcs_tbclientseller' as v_tab_filter from dual
              union all                                                                                                
              select '''对公''' as v_col1,'''基金''' as v_col2,'to_date(''${batch_date}'',''yyyymmdd'')-1' as v_condition,'t1.TAX_ORG_CATE_CD' as v_col3,'replace(t1.CUST_EN_NAME,'';'','' '')' as v_col4,'t1.CTY_RG_CD' as v_col5,'t1.POSTA_ADDR' as v_col6,'''''' as v_col7,'''''' as v_col8,'''''' as v_col9,'''''' as v_col10,'''''' as v_col11,'icl.CMM_CORP_CUST_BASIC_INFO' as v_tab_from,'iol.nfss_tbclientseller' as v_tab_filter from dual
              union all                                                                                                
              select '''对公''' as v_col1,'''信托''' as v_col2,'to_date(''${batch_date}'',''yyyymmdd'')-1' as v_condition,'t1.TAX_ORG_CATE_CD' as v_col3,'replace(t1.CUST_EN_NAME,'';'','' '')' as v_col4,'t1.CTY_RG_CD' as v_col5,'t1.POSTA_ADDR' as v_col6,'''''' as v_col7,'''''' as v_col8,'''''' as v_col9,'''''' as v_col10,'''''' as v_col11,'icl.CMM_CORP_CUST_BASIC_INFO' as v_tab_from,'iol.nfss_tcs_tbclientseller' as v_tab_filter from dual
      ) loop
load_sql:=
'insert into idl.non_red_tax_info_mtbl_fund_tmp (
     etl_dt
    ,acc_type
    ,account
    ,trans_date
    ,client_type
    ,resident_tax_type
    ,resident_inst_type
    ,english_name
    ,inst_nation
    ,inst_address
    ,english_inst_address
    ,chinese_name
    ,english_family_name
    ,english_first_name
    ,born_nation
    ,english_present_address
    ,present_nation
    ,present_address
    ,job_cd
    ,etl_timestamp
)
select
    '||reg.v_condition||'
   ,''客户号：1''
   ,t1.CUST_ID
   ,t1.ETL_DT
   ,'||reg.v_col1||'
   ,t1.TAX_RESDNT_IDTI_CD
   ,'||reg.v_col3||'
   ,'||reg.v_col4||'
   ,'||reg.v_col5||'
   ,'||reg.v_col6||'
   ,t2.CONT_ADDR
   ,t1.CUST_NAME
   ,'||reg.v_col7||'
   ,'||reg.v_col8||'
   ,'||reg.v_col9||'
   ,replace(t3.CONT_ADDR,'';'','' '')
   ,'||reg.v_col10||'
   ,'||reg.v_col11||'
   ,'||reg.v_col2||'
   ,to_timestamp(''${batch_timestamp}'', ''yyyy-mm-dd hh24:mi:ss.ff6'') as etl_timestamp
from '||reg.v_tab_from||' t1
left  join iml.PTY_PARTY_PHYS_ADDR_H t2
        on t1.CUST_ID = t2.PARTY_ID
       and t2.start_dt <= '||reg.v_condition||' and t2.end_dt > '||reg.v_condition||'
       and t2.PHYS_ADDR_TYPE_CD =''20''
left  join iml.PTY_PARTY_PHYS_ADDR_H t3
        on t1.CUST_ID = t3.PARTY_ID
       and t3.start_dt <= '||reg.v_condition||' and t3.end_dt > '||reg.v_condition||'
       and t3.PHYS_ADDR_TYPE_CD =''14''
where exists (select 1 from '||reg.v_tab_filter||' kk
               where t1.cust_id = kk.client_no
                 and kk.start_dt <= '||reg.v_condition||' and kk.end_dt > '||reg.v_condition||')
  and t1.etl_dt = '||reg.v_condition||' 
  and t1.TAX_RESDNT_IDTI_CD in (''2'',''3'')';
       dbms_output.put_line(load_sql); 
   execute immediate load_sql;
commit; 

end loop;

end;
/

-- 2.7 比对两天数据差异，插入目标表 

whenever sqlerror exit sql.sqlcode; 
insert /*+ append */ into idl.non_red_tax_info_mtbl_fund partition for (to_date('${batch_date}','yyyymmdd')) ( 
     etl_dt                       --数据日期 
    ,acc_type                     --客户标识类型 
    ,account                      --客户标识 
    ,trans_date                   --交易日期 
    ,client_type                  --客户类别 
    ,resident_tax_type            --税收居民身份 
    ,resident_inst_type           --金融机构类型 
    ,english_name                 --英文全称 
    ,inst_nation                  --机构地址（国家） 
    ,inst_address                 --机构地址详细地址 
    ,english_inst_address         --机构详细地址（英文） 
    ,chinese_name                 --中文姓名 
    ,english_family_name          --姓（英文） 
    ,english_first_name           --名（英文） 
    ,born_nation                  --出生地（国家） 
    ,english_present_address      --现居详细地址（英文） 
    ,present_nation               --现居地址（国家） 
    ,present_address              --现居详细地址 
    ,job_cd                       --任务代码 
    ,etl_timestamp                --数据处理时间 
) 
select 
     to_date('${batch_date}','yyyymmdd')                                               --数据日期 
    ,t1.acc_type                                                                       --客户标识类型 
    ,t1.account                                                                        --客户标识 
    ,to_date('${batch_date}','yyyymmdd')                                               --交易日期 
    ,t1.client_type                                                                    --客户类别 
    ,t1.resident_tax_type                                                              --税收居民身份 
    ,t1.resident_inst_type                                                             --金融机构类型 
    ,t1.english_name                                                                   --英文全称 
    ,t1.inst_nation                                                                    --机构地址（国家） 
    ,t1.inst_address                                                                   --机构地址详细地址 
    ,t1.english_inst_address                                                           --机构详细地址（英文） 
    ,t1.chinese_name                                                                   --中文姓名 
    ,t1.english_family_name                                                            --姓（英文） 
    ,t1.english_first_name                                                             --名（英文） 
    ,t1.born_nation                                                                    --出生地（国家） 
    ,t1.english_present_address                                                        --现居详细地址（英文） 
    ,t1.present_nation                                                                 --现居地址（国家） 
    ,t1.present_address                                                                --现居详细地址 
    ,t1.job_cd                                                                         --任务代码 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  --数据处理时间 
 from idl.non_red_tax_info_mtbl_fund_tmp t1
where t1.trans_date = to_date('${batch_date}','yyyymmdd') 
minus
select 
     to_date('${batch_date}','yyyymmdd')                                               --数据日期 
    ,t1.acc_type                                                                       --客户标识类型 
    ,t1.account                                                                        --客户标识 
    ,to_date('${batch_date}','yyyymmdd')                                               --交易日期 
    ,t1.client_type                                                                    --客户类别 
    ,t1.resident_tax_type                                                              --税收居民身份 
    ,t1.resident_inst_type                                                             --金融机构类型 
    ,t1.english_name                                                                   --英文全称 
    ,t1.inst_nation                                                                    --机构地址（国家） 
    ,t1.inst_address                                                                   --机构地址详细地址 
    ,t1.english_inst_address                                                           --机构详细地址（英文） 
    ,t1.chinese_name                                                                   --中文姓名 
    ,t1.english_family_name                                                            --姓（英文） 
    ,t1.english_first_name                                                             --名（英文） 
    ,t1.born_nation                                                                    --出生地（国家） 
    ,t1.english_present_address                                                        --现居详细地址（英文） 
    ,t1.present_nation                                                                 --现居地址（国家） 
    ,t1.present_address                                                                --现居详细地址 
    ,t1.job_cd                                                                         --任务代码 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  --数据处理时间 
 from idl.non_red_tax_info_mtbl_fund_tmp t1
where t1.trans_date = to_date('${batch_date}','yyyymmdd')-1 
union all 
select 
     to_date('${batch_date}','yyyymmdd')                                               --数据日期 
    ,t1.acc_type                                                                       --客户标识类型 
    ,t1.account                                                                        --客户标识 
    ,t1.trans_date                                                                     --交易日期 
    ,t1.client_type                                                                    --客户类别 
    ,t1.resident_tax_type                                                              --税收居民身份 
    ,t1.resident_inst_type                                                             --金融机构类型 
    ,t1.english_name                                                                   --英文全称 
    ,t1.inst_nation                                                                    --机构地址（国家） 
    ,t1.inst_address                                                                   --机构地址详细地址 
    ,t1.english_inst_address                                                           --机构详细地址（英文） 
    ,t1.chinese_name                                                                   --中文姓名 
    ,t1.english_family_name                                                            --姓（英文） 
    ,t1.english_first_name                                                             --名（英文） 
    ,t1.born_nation                                                                    --出生地（国家） 
    ,t1.english_present_address                                                        --现居详细地址（英文） 
    ,t1.present_nation                                                                 --现居地址（国家） 
    ,t1.present_address                                                                --现居详细地址 
    ,t1.job_cd                                                                         --任务代码 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  --数据处理时间 
from idl.non_red_tax_info_mtbl_fund_tmp t1      --当前数据 
where not exists (select 1 from idl.non_red_tax_info_mtbl_fund_tmp t2
                   where t1.account = t2.account
                     and t2.trans_date = to_date('${batch_date}','yyyymmdd'))
  and t1.trans_date = to_date('${batch_date}','yyyymmdd')-1
group by etl_dt,acc_type,account,trans_date,client_type,resident_tax_type,resident_inst_type,english_name,inst_nation,inst_address,english_inst_address,chinese_name,english_family_name,english_first_name,born_nation,english_present_address,present_nation,present_address,job_cd,etl_timestamp;
commit; 
 
 

-- 2.8 比对新开户客户，插入目标表
whenever sqlerror exit sql.sqlcode; 
insert /*+ append */ into idl.non_red_tax_info_mtbl_fund partition for (to_date('${batch_date}','yyyymmdd')) ( 
     etl_dt                       --数据日期 
    ,acc_type                     --客户标识类型 
    ,account                      --客户标识 
    ,trans_date                   --交易日期 
    ,client_type                  --客户类别 
    ,resident_tax_type            --税收居民身份 
    ,resident_inst_type           --金融机构类型 
    ,english_name                 --英文全称 
    ,inst_nation                  --机构地址（国家） 
    ,inst_address                 --机构地址详细地址 
    ,english_inst_address         --机构详细地址（英文） 
    ,chinese_name                 --中文姓名 
    ,english_family_name          --姓（英文） 
    ,english_first_name           --名（英文） 
    ,born_nation                  --出生地（国家） 
    ,english_present_address      --现居详细地址（英文） 
    ,present_nation               --现居地址（国家） 
    ,present_address              --现居详细地址 
    ,job_cd                       --任务代码 
    ,etl_timestamp                --数据处理时间 
) 
select 
     to_date('${batch_date}','yyyymmdd')                                               --数据日期 
    ,t1.acc_type                                                                       --客户标识类型 
    ,t1.account                                                                        --客户标识 
    ,to_date('${batch_date}','yyyymmdd')                                               --交易日期 
    ,t1.client_type                                                                    --客户类别 
    ,t1.resident_tax_type                                                              --税收居民身份 
    ,t1.resident_inst_type                                                             --金融机构类型 
    ,t1.english_name                                                                   --英文全称 
    ,t1.inst_nation                                                                    --机构地址（国家） 
    ,t1.inst_address                                                                   --机构地址详细地址 
    ,t1.english_inst_address                                                           --机构详细地址（英文） 
    ,t1.chinese_name                                                                   --中文姓名 
    ,t1.english_family_name                                                            --姓（英文） 
    ,t1.english_first_name                                                             --名（英文） 
    ,t1.born_nation                                                                    --出生地（国家） 
    ,t1.english_present_address                                                        --现居详细地址（英文） 
    ,t1.present_nation                                                                 --现居地址（国家） 
    ,t1.present_address                                                                --现居详细地址 
    ,t1.job_cd                                                                         --任务代码 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  --数据处理时间 
 from idl.non_red_tax_info_mtbl_fund_tmp t1
 where t1.trans_date = to_date('${batch_date}','yyyymmdd')
   and not exists (select 1 from ${idl_schema}.non_red_tax_info_mtbl_fund tt
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
exec dbms_stats.gather_table_stats(ownname => 'idl',tabname => 'non_red_tax_info_mtbl_fund',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);

